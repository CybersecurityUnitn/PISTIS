/* Subroutines used for code generation on TI MSP430 processors.
   Copyright (C) 2012-2019 Free Software Foundation, Inc.
   Contributed by Red Hat.

   This file is part of GCC.

   GCC is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3, or (at your option)
   any later version.

   GCC is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with GCC; see the file COPYING3.  If not see
   <http://www.gnu.org/licenses/>.  */

#define IN_TARGET_CODE 1

#include "config.h"
#include "system.h"
#include "coretypes.h"
#include "backend.h"
#include "target.h"
#include "rtl.h"
#include "tree.h"
#include "stringpool.h"
#include "attribs.h"
#include "gimple-expr.h"
#include "df.h"
#include "memmodel.h"
#include "tm_p.h"
#include "regs.h"
#include "emit-rtl.h"
#include "varasm.h"
#include "diagnostic-core.h"
#include "fold-const.h"
#include "stor-layout.h"
#include "calls.h"
#include "output.h"
#include "explow.h"
#include "expr.h"
#include "langhooks.h"
#include "builtins.h"
#include "intl.h"
#include "msp430-devices.h"
#include "incpath.h"
#include "prefix.h"

/* This file should be included last.  */
#include "target-def.h"


static void msp430_compute_frame_info (void);
static bool use_32bit_hwmult (void);



/* Run-time Target Specification.  */

bool msp430x = true;

struct GTY(()) machine_function
{
  /* If set, the rest of the fields have been computed.  */
  int computed;
  /* Which registers need to be saved in the pro/epilogue.  */
  int need_to_save [FIRST_PSEUDO_REGISTER];

  /* These fields describe the frame layout...  */
  /* arg pointer */
  /* 2/4 bytes for saved PC */
  int framesize_regs;
  /* frame pointer */
  int framesize_locals;
  int framesize_outgoing;
  /* stack pointer */
  int framesize;

  /* How much we adjust the stack when returning from an exception
     handler.  */
  rtx eh_stack_adjust;
};

/* This is our init_machine_status, as set in
   msp430_option_override.  */
static struct machine_function *
msp430_init_machine_status (void)
{
  struct machine_function *m;

  m = ggc_cleared_alloc<machine_function> ();

  return m;
}

#undef  TARGET_OPTION_OVERRIDE
#define TARGET_OPTION_OVERRIDE		msp430_option_override

/* Generate a C preprocessor symbol based upon the MCU selected by the user.
   If a specific MCU has not been selected then return a generic symbol instead.  */

const char *
msp430_mcu_name (void)
{
  if (target_mcu)
    {
      msp430_extract_mcu_data (target_mcu, false);
      unsigned int i;
      unsigned int start_upper;
      unsigned int end_upper;
      static char mcu_name[64];

      /* The 'i' in the device name symbol for msp430i* devices must be lower
	 case, to match the expected symbol in msp430.h.  */
      if (strncmp (target_mcu, "msp430i", 7) == 0)
	{
	  snprintf (mcu_name, sizeof (mcu_name) - 1, "__MSP430i%s__",
		    target_mcu + 7);
	  start_upper = 9;
	}
      else
	{
	  snprintf (mcu_name, sizeof (mcu_name) - 1, "__%s__", target_mcu);
	  start_upper = 2;
	}
      end_upper = strlen (mcu_name) - 2;
      for (i = start_upper; i < end_upper; i++)
	mcu_name[i] = TOUPPER (mcu_name[i]);
      return mcu_name;
    }

  return msp430x ? "__MSP430XGENERIC__" : "__MSP430GENERIC__";
}

static const char *
hwmult_name (unsigned int val)
{
  switch (val)
    {
    case 0: return "none";
    case 2:
    case 1: return "16bit";
    case 4: return "32bit";
    case 8: return "f5series";
    default: gcc_unreachable ();
    }
}

static void
msp430_option_override (void)
{
  /* The MSP430 architecture can safely dereference a NULL pointer. In fact,
  there are memory mapped registers there.  */
  flag_delete_null_pointer_checks = 0;

  init_machine_status = msp430_init_machine_status;

  msp430x = target_cpu >= MSP430_CPU_MSP430X_DEFAULT;

  if (target_mcu)
    {
      msp430_extract_mcu_data (target_mcu, false);

      if (extracted_mcu_data.name != NULL)
	{
	  bool xisa = extracted_mcu_data.revision >= 1;

	  if (msp430_warn_mcu)
	    {
	      if (target_cpu != MSP430_CPU_MSP430X_DEFAULT && msp430x != xisa)
		warning (0, "MCU '%s' supports %s ISA but -mcpu option is set "
			 "to %s", target_mcu, xisa ? "430X" : "430",
			 msp430x ? "430X" : "430");

	      if (extracted_mcu_data.hwmpy == 0
		  && msp430_hwmult_type != MSP430_HWMULT_AUTO
		  && msp430_hwmult_type != MSP430_HWMULT_NONE)
		warning (0, "MCU '%s' does not have hardware multiply support, "
			 "but -mhwmult is set to %s",
			 target_mcu,
			 msp430_hwmult_type == MSP430_HWMULT_SMALL ? "16bit"
			 : msp430_hwmult_type == MSP430_HWMULT_LARGE ? "32bit"
			 : "f5series");
	      else if (msp430_hwmult_type == MSP430_HWMULT_SMALL
		       && extracted_mcu_data.hwmpy != 1
		       && extracted_mcu_data.hwmpy != 2)
		warning (0, "MCU '%s' supports %s hardware multiply, "
			 "but -mhwmult is set to 16bit",
			 target_mcu, hwmult_name (extracted_mcu_data.hwmpy));
	      else if (msp430_hwmult_type == MSP430_HWMULT_LARGE
		       && extracted_mcu_data.hwmpy != 4)
		warning (0, "MCU '%s' supports %s hardware multiply, "
			 "but -mhwmult is set to 32bit",
			 target_mcu, hwmult_name (extracted_mcu_data.hwmpy));
	      else if (msp430_hwmult_type == MSP430_HWMULT_F5SERIES
		       && extracted_mcu_data.hwmpy != 8)
		warning (0, "MCU '%s' supports %s hardware multiply, "
			 "but -mhwmult is set to f5series",
			 target_mcu, hwmult_name (extracted_mcu_data.hwmpy));
	    }

	  /* Only override the default setting with the extracted MCU value if
	     the user has not passed -mcpu=  */
	  if (target_cpu == MSP430_CPU_MSP430X_DEFAULT)
	    msp430x = xisa;
	}
      else
	{
	  if (msp430_hwmult_type == MSP430_HWMULT_AUTO)
	    {
	      if (msp430_warn_mcu)
		{
		  if (target_cpu == MSP430_CPU_MSP430X_DEFAULT)
		    warning (0,
			     "Unrecognized MCU name %qs, assuming that it is "
			     "just a MSP430 with no hardware multiply.\n"
			     "Use the %<-mcpu%> and %<-mhwmult%> options to "
			     "set these explicitly.",
			     target_mcu);
		  else
		    warning (0,
			     "Unrecognized MCU name %qs, assuming that it "
			     "has no hardware multiply.\nUse the %<-mhwmult%> "
			     "option to set this explicitly.",
			     target_mcu);
		}

	      msp430_hwmult_type = MSP430_HWMULT_NONE;
	    }
	  else if (target_cpu == MSP430_CPU_MSP430X_DEFAULT)
	    {
	      if (msp430_warn_mcu)
		warning (0,
			 "Unrecognized MCU name %qs, assuming that it just "
			 "supports the MSP430 ISA.\nUse the %<-mcpu%> option "
			 "to set the ISA explicitly.",
			 target_mcu);

	    }
	  else if (msp430_warn_mcu)
	    warning (0, "Unrecognized MCU name %qs.", target_mcu);
	}
    }

  if (TARGET_LARGE && !msp430x)
    error ("%<-mlarge%> requires a 430X-compatible %<-mmcu=%>");

  if (!TARGET_LARGE && msp430_code_region == MSP430_REGION_EITHER)
    error ("-mcode-region=either requires the large memory model (-mlarge)");
  else if (!TARGET_LARGE && msp430_code_region == MSP430_REGION_UPPER)
    error ("-mcode-region=upper requires the large memory model (-mlarge)");

  if (!TARGET_LARGE && msp430_data_region == MSP430_REGION_EITHER)
    error ("-mdata-region=either requires the large memory model (-mlarge)");
  else if (!TARGET_LARGE && msp430_data_region == MSP430_REGION_UPPER)
    error ("-mdata-region=upper requires the large memory model (-mlarge)");

  if (flag_exceptions || flag_non_call_exceptions
      || flag_unwind_tables || flag_asynchronous_unwind_tables)
    flag_omit_frame_pointer = false;
  else
    flag_omit_frame_pointer = true;

  /* The MSP ABI C Helper functions do not have versions which can perform
     overflow checking.  */
  if (flag_trapv)
    error ("-ftrapv is not supported for msp430-elf");

  /* Explicitly disable -fgnu-tm.  It is not supported in the first place,
     but .tm_clone_table and (de)register_tm_clones have also been
     removed from crt{begin,end}.o by setting USE_TM_CLONE_REGISTRY to 0.  */
  if (flag_tm)
    error ("-fgnu-tm is not supported for msp430-elf");

  /* This is a hack to work around a problem with the newlib build
     mechanism.  Newlib always appends CFLAGS to the end of the GCC
     command line and always sets -O2 in CFLAGS.  Thus it is not
     possible to build newlib with -Os enabled.  Until now...  */
  if (TARGET_OPT_SPACE && optimize < 3)
    optimize_size = 1;
}

#undef  TARGET_SCALAR_MODE_SUPPORTED_P
#define TARGET_SCALAR_MODE_SUPPORTED_P msp430_scalar_mode_supported_p

static bool
msp430_scalar_mode_supported_p (scalar_mode m)
{
  if (m == PSImode && msp430x)
    return true;
#if 0
  if (m == TImode)
    return true;
#endif
  return default_scalar_mode_supported_p (m);
}



/* Storage Layout */

#undef  TARGET_MS_BITFIELD_LAYOUT_P
#define TARGET_MS_BITFIELD_LAYOUT_P msp430_ms_bitfield_layout_p

bool
msp430_ms_bitfield_layout_p (const_tree record_type ATTRIBUTE_UNUSED)
{
  return false;
}



/* Register Usage */

#undef TARGET_HARD_REGNO_NREGS
#define TARGET_HARD_REGNO_NREGS msp430_hard_regno_nregs

static unsigned int
msp430_hard_regno_nregs (unsigned int, machine_mode mode)
{
  if (mode == PSImode && msp430x)
    return 1;
  if (mode == CPSImode && msp430x)
    return 2;
  return ((GET_MODE_SIZE (mode) + UNITS_PER_WORD - 1)
	  / UNITS_PER_WORD);
}

/* FIXME: These next two functions are not actually linked to the target macros
   that are expected, but defining them has no effect.  Should they be removed
   altogether or defined for completeness?  */
/* Implements HARD_REGNO_NREGS_HAS_PADDING.  */
int
msp430_hard_regno_nregs_has_padding (int regno ATTRIBUTE_UNUSED,
				     machine_mode mode)
{
  if (mode == PSImode && msp430x)
    return 1;
  return ((GET_MODE_SIZE (mode) + UNITS_PER_WORD - 1)
	  / UNITS_PER_WORD);
}

/* Implements HARD_REGNO_NREGS_WITH_PADDING.  */
int
msp430_hard_regno_nregs_with_padding (int regno ATTRIBUTE_UNUSED,
				     machine_mode mode)
{
  if (mode == PSImode)
    return 2;
  if (mode == CPSImode)
    return 4;
  return msp430_hard_regno_nregs (regno, mode);
}

#undef TARGET_HARD_REGNO_MODE_OK
#define TARGET_HARD_REGNO_MODE_OK msp430_hard_regno_mode_ok

static bool
msp430_hard_regno_mode_ok (unsigned int regno, machine_mode mode)
{
  return regno <= (ARG_POINTER_REGNUM
		   - (unsigned int) msp430_hard_regno_nregs (regno, mode));
}

#undef TARGET_MODES_TIEABLE_P
#define TARGET_MODES_TIEABLE_P msp430_modes_tieable_p

static bool
msp430_modes_tieable_p (machine_mode mode1, machine_mode mode2)
{
  if ((mode1 == PSImode || mode2 == SImode)
      || (mode1 == SImode || mode2 == PSImode))
    return false;

  return ((GET_MODE_CLASS (mode1) == MODE_FLOAT
	   || GET_MODE_CLASS (mode1) == MODE_COMPLEX_FLOAT)
	  == (GET_MODE_CLASS (mode2) == MODE_FLOAT
	      || GET_MODE_CLASS (mode2) == MODE_COMPLEX_FLOAT));
}

#undef  TARGET_FRAME_POINTER_REQUIRED
#define TARGET_FRAME_POINTER_REQUIRED msp430_frame_pointer_required

static bool
msp430_frame_pointer_required (void)
{
  if (cfun->has_nonlocal_label || cfun->calls_setjmp)
    return true;
  return false;
}

#undef  TARGET_CAN_ELIMINATE
#define TARGET_CAN_ELIMINATE		msp430_can_eliminate

static bool
msp430_can_eliminate (const int from_reg ATTRIBUTE_UNUSED,
		      const int to_reg ATTRIBUTE_UNUSED)
{
  return true;
}

/* Implements INITIAL_ELIMINATION_OFFSET.  */
int
msp430_initial_elimination_offset (int from, int to)
{
  int rv = 0; /* As if arg to arg.  */

  msp430_compute_frame_info ();

  switch (to)
    {
    case STACK_POINTER_REGNUM:
      rv += cfun->machine->framesize_outgoing;
      rv += cfun->machine->framesize_locals;
      /* Fall through.  */
    case FRAME_POINTER_REGNUM:
      rv += cfun->machine->framesize_regs;
      /* Allow for the saved return address.  */
      rv += (TARGET_LARGE ? 4 : 2);
      /* NB/ No need to allow for crtl->args.pretend_args_size.
         GCC does that for us.  */
      break;
    default:
      gcc_unreachable ();
    }

  switch (from)
    {
    case FRAME_POINTER_REGNUM:
      /* Allow for the fall through above.  */
      rv -= (TARGET_LARGE ? 4 : 2);
      rv -= cfun->machine->framesize_regs;
    case ARG_POINTER_REGNUM:
      break;
    default:
      gcc_unreachable ();
    }

  return rv;
}

/* Named Address Space support */


/* Return the appropriate mode for a named address pointer.  */
#undef  TARGET_ADDR_SPACE_POINTER_MODE
#define TARGET_ADDR_SPACE_POINTER_MODE msp430_addr_space_pointer_mode
#undef  TARGET_ADDR_SPACE_ADDRESS_MODE
#define TARGET_ADDR_SPACE_ADDRESS_MODE msp430_addr_space_pointer_mode

static scalar_int_mode
msp430_addr_space_pointer_mode (addr_space_t addrspace)
{
  switch (addrspace)
    {
    default:
    case ADDR_SPACE_GENERIC:
      return Pmode;
    case ADDR_SPACE_NEAR:
      return HImode;
    case ADDR_SPACE_FAR:
      return PSImode;
    }
}

/* Function pointers are stored in unwind_word sized
   variables, so make sure that unwind_word is big enough.  */
#undef  TARGET_UNWIND_WORD_MODE
#define TARGET_UNWIND_WORD_MODE msp430_unwind_word_mode

static scalar_int_mode
msp430_unwind_word_mode (void)
{
  /* This needs to match msp430_init_dwarf_reg_sizes_extra (below).  */
  return msp430x ? PSImode : HImode;
}

/* Determine if one named address space is a subset of another.  */
#undef  TARGET_ADDR_SPACE_SUBSET_P
#define TARGET_ADDR_SPACE_SUBSET_P msp430_addr_space_subset_p
static bool
msp430_addr_space_subset_p (addr_space_t subset, addr_space_t superset)
{
  if (subset == superset)
    return true;
  else
    return (subset != ADDR_SPACE_FAR && superset == ADDR_SPACE_FAR);
}

#undef  TARGET_ADDR_SPACE_CONVERT
#define TARGET_ADDR_SPACE_CONVERT msp430_addr_space_convert
/* Convert from one address space to another.  */
static rtx
msp430_addr_space_convert (rtx op, tree from_type, tree to_type)
{
  addr_space_t from_as = TYPE_ADDR_SPACE (TREE_TYPE (from_type));
  addr_space_t to_as = TYPE_ADDR_SPACE (TREE_TYPE (to_type));
  rtx result;

  if (to_as != ADDR_SPACE_FAR && from_as == ADDR_SPACE_FAR)
    {
      /* This is unpredictable, as we're truncating off usable address
	 bits.  */

      if (CONSTANT_P (op))
	return gen_rtx_CONST (HImode, op);

      result = gen_reg_rtx (HImode);
      emit_insn (gen_truncpsihi2 (result, op));
      return result;
    }
  else if (to_as == ADDR_SPACE_FAR && from_as != ADDR_SPACE_FAR)
    {
      /* This always works.  */

      if (CONSTANT_P (op))
	return gen_rtx_CONST (PSImode, op);

      result = gen_reg_rtx (PSImode);
      emit_insn (gen_zero_extendhipsi2 (result, op));
      return result;
    }
  else
    gcc_unreachable ();
}

/* Stack Layout and Calling Conventions.  */

/* For each function, we list the gcc version and the TI version on
   each line, where we're converting the function names.  */
static char const * const special_convention_function_names [] =
{
  "__muldi3", "__mspabi_mpyll",
  "__udivdi3", "__mspabi_divull",
  "__umoddi3", "__mspabi_remull",
  "__divdi3", "__mspabi_divlli",
  "__moddi3", "__mspabi_remlli",
  "__mspabi_srall",
  "__mspabi_srlll",
  "__mspabi_sllll",
  "__adddf3", "__mspabi_addd",
  "__subdf3", "__mspabi_subd",
  "__muldf3", "__mspabi_mpyd",
  "__divdf3", "__mspabi_divd",
  "__mspabi_cmpd",
  NULL
};

/* TRUE if the function passed is a "speical" function.  Special
   functions pass two DImode parameters in registers.  */
static bool
msp430_special_register_convention_p (const char *name)
{
  int i;

  for (i = 0; special_convention_function_names [i]; i++)
    if (! strcmp (name, special_convention_function_names [i]))
      return true;

  return false;
}

#undef  TARGET_FUNCTION_VALUE_REGNO_P
#define TARGET_FUNCTION_VALUE_REGNO_P msp430_function_value_regno_p

bool
msp430_function_value_regno_p (unsigned int regno)
{
  return regno == 12;
}


#undef  TARGET_FUNCTION_VALUE
#define TARGET_FUNCTION_VALUE msp430_function_value

rtx
msp430_function_value (const_tree ret_type,
		       const_tree fn_decl_or_type ATTRIBUTE_UNUSED,
		       bool outgoing ATTRIBUTE_UNUSED)
{
  return gen_rtx_REG (TYPE_MODE (ret_type), 12);
}

#undef  TARGET_LIBCALL_VALUE
#define TARGET_LIBCALL_VALUE msp430_libcall_value

rtx
msp430_libcall_value (machine_mode mode, const_rtx fun ATTRIBUTE_UNUSED)
{
  return gen_rtx_REG (mode, 12);
}

/* Implements INIT_CUMULATIVE_ARGS.  */
void
msp430_init_cumulative_args (CUMULATIVE_ARGS *ca,
			     tree fntype ATTRIBUTE_UNUSED,
			     rtx libname ATTRIBUTE_UNUSED,
			     tree fndecl ATTRIBUTE_UNUSED,
			     int n_named_args ATTRIBUTE_UNUSED)
{
  const char *fname;
  memset (ca, 0, sizeof(*ca));

  ca->can_split = 1;

  if (fndecl)
    fname = IDENTIFIER_POINTER (DECL_NAME (fndecl));
  else if (libname)
    fname = XSTR (libname, 0);
  else
    fname = NULL;

  if (fname && msp430_special_register_convention_p (fname))
    ca->special_p = 1;
}

/* Helper function for argument passing; this function is the common
   code that determines where an argument will be passed.  */
static void
msp430_evaluate_arg (cumulative_args_t cap,
		     machine_mode mode,
		     const_tree type ATTRIBUTE_UNUSED,
		     bool named)
{
  CUMULATIVE_ARGS *ca = get_cumulative_args (cap);
  int nregs = GET_MODE_SIZE (mode);
  int i;

  ca->reg_count = 0;
  ca->mem_count = 0;

  if (!named)
    return;

  if (mode == PSImode)
    nregs = 1;
  else
    nregs = (nregs + 1) / 2;

  if (ca->special_p)
    {
      /* Function is passed two DImode operands, in R8:R11 and
	 R12:15.  */
      ca->start_reg = 8;
      ca->reg_count = 4;
      return;
    }

  switch (nregs)
    {
    case 1:
      for (i = 0; i < 4; i++)
	if (! ca->reg_used [i])
	  {
	    ca->reg_count = 1;
	    ca->start_reg = CA_FIRST_REG + i;
	    return;
	  }
      break;
    case 2:
      for (i = 0; i < 3; i++)
	if (! ca->reg_used [i] && ! ca->reg_used [i + 1])
	  {
	    ca->reg_count = 2;
	    ca->start_reg = CA_FIRST_REG + i;
	    return;
	  }
      if (! ca->reg_used [3] && ca->can_split)
	{
	  ca->reg_count = 1;
	  ca->mem_count = 2;
	  ca->start_reg = CA_FIRST_REG + 3;
	  return;
	}
      break;
    case 3:
    case 4:
      ca->can_split = 0;
      if (! ca->reg_used [0]
	  && ! ca->reg_used [1]
	  && ! ca->reg_used [2]
	  && ! ca->reg_used [3])
	{
	  ca->reg_count = 4;
	  ca->start_reg = CA_FIRST_REG;
	  return;
	}
      break;
    }
}

#undef  TARGET_PROMOTE_PROTOTYPES
#define TARGET_PROMOTE_PROTOTYPES msp430_promote_prototypes

bool
msp430_promote_prototypes (const_tree fntype ATTRIBUTE_UNUSED)
{
  return false;
}

#undef  TARGET_FUNCTION_ARG
#define TARGET_FUNCTION_ARG msp430_function_arg

rtx
msp430_function_arg (cumulative_args_t cap,
		     machine_mode mode,
		     const_tree type,
		     bool named)
{
  CUMULATIVE_ARGS *ca = get_cumulative_args (cap);

  msp430_evaluate_arg (cap, mode, type, named);

  if (ca->reg_count)
    return gen_rtx_REG (mode, ca->start_reg);

  return 0;
}

#undef  TARGET_ARG_PARTIAL_BYTES
#define TARGET_ARG_PARTIAL_BYTES msp430_arg_partial_bytes

int
msp430_arg_partial_bytes (cumulative_args_t cap,
			  machine_mode mode,
			  tree type,
			  bool named)
{
  CUMULATIVE_ARGS *ca = get_cumulative_args (cap);

  msp430_evaluate_arg (cap, mode, type, named);

  if (ca->reg_count && ca->mem_count)
    return ca->reg_count * UNITS_PER_WORD;

  return 0;
}

#undef  TARGET_PASS_BY_REFERENCE
#define TARGET_PASS_BY_REFERENCE msp430_pass_by_reference

static bool
msp430_pass_by_reference (cumulative_args_t cap ATTRIBUTE_UNUSED,
			  machine_mode mode,
			  const_tree type,
			  bool named ATTRIBUTE_UNUSED)
{
  return (mode == BLKmode
	   || (type && TREE_CODE (type) == RECORD_TYPE)
	   || (type && TREE_CODE (type) == UNION_TYPE));
}

#undef  TARGET_CALLEE_COPIES
#define TARGET_CALLEE_COPIES msp430_callee_copies

static bool
msp430_callee_copies (cumulative_args_t cap ATTRIBUTE_UNUSED,
                     machine_mode mode ATTRIBUTE_UNUSED,
                     const_tree type ATTRIBUTE_UNUSED,
                     bool named ATTRIBUTE_UNUSED)
{
  return true;
}

#undef  TARGET_FUNCTION_ARG_ADVANCE
#define TARGET_FUNCTION_ARG_ADVANCE msp430_function_arg_advance

void
msp430_function_arg_advance (cumulative_args_t cap,
			     machine_mode mode,
			     const_tree type,
			     bool named)
{
  CUMULATIVE_ARGS *ca = get_cumulative_args (cap);
  int i;

  msp430_evaluate_arg (cap, mode, type, named);

  if (ca->start_reg >= CA_FIRST_REG)
    for (i = 0; i < ca->reg_count; i ++)
      ca->reg_used [i + ca->start_reg - CA_FIRST_REG] = 1;

  ca->special_p = 0;
}

#undef  TARGET_FUNCTION_ARG_BOUNDARY
#define TARGET_FUNCTION_ARG_BOUNDARY msp430_function_arg_boundary

static unsigned int
msp430_function_arg_boundary (machine_mode mode, const_tree type)
{
  if (mode == BLKmode
      && int_size_in_bytes (type) > 1)
    return 16;
  if (GET_MODE_BITSIZE (mode) > 8)
    return 16;
  return 8;
}

#undef  TARGET_RETURN_IN_MEMORY
#define TARGET_RETURN_IN_MEMORY msp430_return_in_memory

static bool
msp430_return_in_memory (const_tree ret_type, const_tree fntype ATTRIBUTE_UNUSED)
{
  machine_mode mode = TYPE_MODE (ret_type);

  if (mode == BLKmode
      || (fntype && TREE_CODE (TREE_TYPE (fntype)) == RECORD_TYPE)
      || (fntype && TREE_CODE (TREE_TYPE (fntype)) == UNION_TYPE))
    return true;

  if (GET_MODE_SIZE (mode) > 8)
    return true;

  return false;
}

#undef  TARGET_GET_RAW_ARG_MODE
#define TARGET_GET_RAW_ARG_MODE msp430_get_raw_arg_mode

static fixed_size_mode
msp430_get_raw_arg_mode (int regno)
{
  return as_a <fixed_size_mode> (regno == ARG_POINTER_REGNUM
				 ? VOIDmode : Pmode);
}

#undef  TARGET_GET_RAW_RESULT_MODE
#define TARGET_GET_RAW_RESULT_MODE msp430_get_raw_result_mode

static fixed_size_mode
msp430_get_raw_result_mode (int regno ATTRIBUTE_UNUSED)
{
  return Pmode;
}

#undef  TARGET_GIMPLIFY_VA_ARG_EXPR
#define TARGET_GIMPLIFY_VA_ARG_EXPR msp430_gimplify_va_arg_expr

#include "gimplify.h"

static tree
msp430_gimplify_va_arg_expr (tree valist, tree type, gimple_seq *pre_p,
			  gimple_seq *post_p)
{
  tree addr, t, type_size, rounded_size, valist_tmp;
  unsigned HOST_WIDE_INT align, boundary;
  bool indirect;

  indirect = pass_by_reference (NULL, TYPE_MODE (type), type, false);
  if (indirect)
    type = build_pointer_type (type);

  align = PARM_BOUNDARY / BITS_PER_UNIT;
  boundary = targetm.calls.function_arg_boundary (TYPE_MODE (type), type);

  /* When we align parameter on stack for caller, if the parameter
     alignment is beyond MAX_SUPPORTED_STACK_ALIGNMENT, it will be
     aligned at MAX_SUPPORTED_STACK_ALIGNMENT.  We will match callee
     here with caller.  */
  if (boundary > MAX_SUPPORTED_STACK_ALIGNMENT)
    boundary = MAX_SUPPORTED_STACK_ALIGNMENT;

  boundary /= BITS_PER_UNIT;

  /* Hoist the valist value into a temporary for the moment.  */
  valist_tmp = get_initialized_tmp_var (valist, pre_p, NULL);

  /* va_list pointer is aligned to PARM_BOUNDARY.  If argument actually
     requires greater alignment, we must perform dynamic alignment.  */
  if (boundary > align
      && !integer_zerop (TYPE_SIZE (type)))
    {
      /* FIXME: This is where this function diverts from targhooks.c:
	 std_gimplify_va_arg_expr().  It works, but I do not know why...  */
      if (! POINTER_TYPE_P (type))
	{
	  t = build2 (MODIFY_EXPR, TREE_TYPE (valist), valist_tmp,
		      fold_build_pointer_plus_hwi (valist_tmp, boundary - 1));
	  gimplify_and_add (t, pre_p);

	  t = build2 (MODIFY_EXPR, TREE_TYPE (valist), valist_tmp,
		      fold_build2 (BIT_AND_EXPR, TREE_TYPE (valist),
				   valist_tmp,
				   build_int_cst (TREE_TYPE (valist), -boundary)));
	  gimplify_and_add (t, pre_p);
	}
    }
  else
    boundary = align;

  /* If the actual alignment is less than the alignment of the type,
     adjust the type accordingly so that we don't assume strict alignment
     when dereferencing the pointer.  */
  boundary *= BITS_PER_UNIT;
  if (boundary < TYPE_ALIGN (type))
    {
      type = build_variant_type_copy (type);
      SET_TYPE_ALIGN (type, boundary);
    }

  /* Compute the rounded size of the type.  */
  type_size = size_in_bytes (type);
  rounded_size = round_up (type_size, align);

  /* Reduce rounded_size so it's sharable with the postqueue.  */
  gimplify_expr (&rounded_size, pre_p, post_p, is_gimple_val, fb_rvalue);

  /* Get AP.  */
  addr = valist_tmp;

  /* Compute new value for AP.  */
  t = fold_build_pointer_plus (valist_tmp, rounded_size);
  t = build2 (MODIFY_EXPR, TREE_TYPE (valist), valist, t);
  gimplify_and_add (t, pre_p);

  addr = fold_convert (build_pointer_type (type), addr);

  if (indirect)
    addr = build_va_arg_indirect_ref (addr);

  addr = build_va_arg_indirect_ref (addr);

  return addr;
}

#undef TARGET_LRA_P
#define TARGET_LRA_P hook_bool_void_false

/* The concepts of shared libraries and dynamic linking are not applicable for
   MSP430, for which applications are often run in a "bare-metal" environment.
   Even when running an OS on the MSP430, due to memory constraints there will
   certainly be no dynamic linker running on the target.
   For these reasons, we will never need the functionality provided by the
   global data object "__dso_handle", which has a unique value in every shared
   object.  It is normally provided by crtbegin.o (crtstuff.c), and used by
   __cxa_atexit().
   The definition of __dso_handle in crtstuff.c can be removed by defining the
   symbol "NO_DSO_HANDLE".  If "atexit" is used instead of "__cxa_atexit"
   (by enabling TARGET_CXX_USE_ATEXIT_FOR_CXA_ATEXIT as below), then the
   only remaining usage of __dso_handle will also be removed.
   In programs which would otherwise not have any global data to initialize and
   copy from ROM to RAM, removing __dso_handle provides reduces code size.
   For the small memory model code size is reduced by 90 bytes, and the large
   memory model by 120 bytes.  */
#undef TARGET_CXX_USE_ATEXIT_FOR_CXA_ATEXIT
#define TARGET_CXX_USE_ATEXIT_FOR_CXA_ATEXIT hook_bool_void_true

/* Addressing Modes */

#undef  TARGET_LEGITIMATE_ADDRESS_P
#define TARGET_LEGITIMATE_ADDRESS_P msp430_legitimate_address_p

static bool
reg_ok_for_addr (rtx r, bool strict)
{
  int rn = REGNO (r);

  if (strict && rn >= FIRST_PSEUDO_REGISTER)
    rn = reg_renumber [rn];
  if (strict && 0 <= rn && rn < FIRST_PSEUDO_REGISTER)
    return true;
  if (!strict)
    return true;
  return false;
}

bool
msp430_legitimate_address_p (machine_mode mode ATTRIBUTE_UNUSED,
			     rtx x ATTRIBUTE_UNUSED,
			     bool strict ATTRIBUTE_UNUSED)
{
  switch (GET_CODE (x))
    {
    case MEM:
      return false;

    case PLUS:
    case POST_INC:
      if (REG_P (XEXP (x, 0)))
	{
	  if (GET_MODE (x) != GET_MODE (XEXP (x, 0)))
	    return false;
	  if (!reg_ok_for_addr (XEXP (x, 0), strict))
	    return false;
	  if (GET_CODE (x) == POST_INC)
	    /* At this point, if the original rtx was a post_inc, we don't have
	       anything further to check.  */
	    return true;
	  switch (GET_CODE (XEXP (x, 1)))
	    {
	    case CONST:
	    case SYMBOL_REF:
	    case CONST_INT:
	      return true;
	    default:
	      return false;
	    }
	}
      return false;

    case REG:
      if (!reg_ok_for_addr (x, strict))
	return false;
      /* FALLTHRU */
    case CONST:
    case SYMBOL_REF:
    case CONST_INT:
      return true;

    default:
      return false;
    }
}

#undef  TARGET_ADDR_SPACE_LEGITIMATE_ADDRESS_P
#define TARGET_ADDR_SPACE_LEGITIMATE_ADDRESS_P msp430_addr_space_legitimate_address_p

bool
msp430_addr_space_legitimate_address_p (machine_mode mode,
					rtx x,
					bool strict,
					addr_space_t as ATTRIBUTE_UNUSED)
{
  return msp430_legitimate_address_p (mode, x, strict);
}

#undef  TARGET_ASM_INTEGER
#define TARGET_ASM_INTEGER msp430_asm_integer
static bool
msp430_asm_integer (rtx x, unsigned int size, int aligned_p)
{
  int c = GET_CODE (x);

  if (size == 3 && GET_MODE (x) == PSImode)
    size = 4;

  switch (size)
    {
    case 4:
      if (c == SYMBOL_REF || c == CONST || c == LABEL_REF || c == CONST_INT
	  || c == PLUS || c == MINUS)
	{
	  fprintf (asm_out_file, "\t.long\t");
	  output_addr_const (asm_out_file, x);
	  fputc ('\n', asm_out_file);
	  return true;
	}
      break;
    }
  return default_assemble_integer (x, size, aligned_p);
}

#undef  TARGET_ASM_OUTPUT_ADDR_CONST_EXTRA
#define TARGET_ASM_OUTPUT_ADDR_CONST_EXTRA msp430_asm_output_addr_const_extra
static bool
msp430_asm_output_addr_const_extra (FILE *file ATTRIBUTE_UNUSED, rtx x)
{
  debug_rtx(x);
  return false;
}

#undef  TARGET_LEGITIMATE_CONSTANT_P
#define TARGET_LEGITIMATE_CONSTANT_P msp430_legitimate_constant

static bool
msp430_legitimate_constant (machine_mode mode, rtx x)
{
  return ! CONST_INT_P (x)
    || mode != PSImode
    /* GCC does not know the width of the PSImode, so make
       sure that it does not try to use a constant value that
       is out of range.  */
    || (INTVAL (x) < (1 << 20) && INTVAL (x) >= (HOST_WIDE_INT)(HOST_WIDE_INT_M1U << 20));
}


#undef  TARGET_RTX_COSTS
#define TARGET_RTX_COSTS msp430_rtx_costs

static bool msp430_rtx_costs (rtx	   x ATTRIBUTE_UNUSED,
			      machine_mode mode,
			      int	   outer_code ATTRIBUTE_UNUSED,
			      int	   opno ATTRIBUTE_UNUSED,
			      int *	   total,
			      bool	   speed ATTRIBUTE_UNUSED)
{
  int code = GET_CODE (x);

  switch (code)
    {
    case SIGN_EXTEND:
      if (mode == SImode && outer_code == SET)
	{
	  *total = COSTS_N_INSNS (4);
	  return true;
	}
      break;
    }
  return false;
}

/* Function Entry and Exit */

/* The MSP430 call frame looks like this:

   <higher addresses>
   +--------------------+
   |                    |
   | Stack Arguments    |
   |                    |
   +--------------------+ <-- "arg pointer"
   |                    |
   | PC from call       |  (2 bytes for 430, 4 for TARGET_LARGE)
   |                    |
   +--------------------+
   | SR if this func has|
   | been called via an |
   | interrupt.         |
   +--------------------+  <-- SP before prologue, also AP
   |                    |
   | Saved Regs         |  (2 bytes per reg for 430, 4 per for TARGET_LARGE)
   |                    |
   +--------------------+  <-- "frame pointer"
   |                    |
   | Locals             |
   |                    |
   +--------------------+
   |                    |
   | Outgoing Args      |
   |                    |
   +--------------------+  <-- SP during function
   <lower addresses>

*/

/* We use this to wrap all emitted insns in the prologue, so they get
   the "frame-related" (/f) flag set.  */
static rtx
F (rtx x)
{
  RTX_FRAME_RELATED_P (x) = 1;
  return x;
}

/* This is the one spot that decides if a register is to be saved and
   restored in the prologue/epilogue.  */
static bool
msp430_preserve_reg_p (int regno)
{
  /* PC, SP, SR, and the constant generator.  */
  if (regno <= 3)
    return false;

  /* FIXME: add interrupt, EH, etc.  */
  if (crtl->calls_eh_return)
    return true;

  /* Shouldn't be more than the above, but just in case...  */
  if (fixed_regs [regno])
    return false;

  /* The only different behaviour we require for interrupt functions is to save
     and restore the used regs that would normally be caller-saved R11->R15.  */
  if (msp430_is_interrupt_func () && regno >= 11 && regno <= 15)
    {
      if (crtl->is_leaf && df_regs_ever_live_p (regno))
	/* If the interrupt func is a leaf then we only need to restore the
	   caller-saved regs that are used.  */
	return true;
      else if (!crtl->is_leaf)
	/* If the interrupt function is not a leaf we must save all
	   caller-saved regs in case the callee modifies them.  */
	return true;
    }

  if (!call_used_regs [regno]
      && df_regs_ever_live_p (regno))
    return true;

  return false;
}

/* Compute all the frame-related fields in our machine_function
   structure.  */
static void
msp430_compute_frame_info (void)
{
  int i;

  cfun->machine->computed = 1;
  cfun->machine->framesize_regs = 0;
  cfun->machine->framesize_locals = get_frame_size ();
  cfun->machine->framesize_outgoing = crtl->outgoing_args_size;

  for (i = 0; i < ARG_POINTER_REGNUM; i ++)
    if (msp430_preserve_reg_p (i))
      {
	cfun->machine->need_to_save [i] = 1;
	cfun->machine->framesize_regs += (TARGET_LARGE ? 4 : 2);
      }
    else
      cfun->machine->need_to_save [i] = 0;

  if ((cfun->machine->framesize_locals + cfun->machine->framesize_outgoing) & 1)
    cfun->machine->framesize_locals ++;

  cfun->machine->framesize = (cfun->machine->framesize_regs
			      + cfun->machine->framesize_locals
			      + cfun->machine->framesize_outgoing);
}

/* Attribute Handling.  */

const char * const  ATTR_INTR   = "interrupt";
const char * const  ATTR_WAKEUP = "wakeup";
const char * const  ATTR_NAKED  = "naked";
const char * const  ATTR_REENT  = "reentrant";
const char * const  ATTR_CRIT   = "critical";
const char * const  ATTR_LOWER  = "lower";
const char * const  ATTR_UPPER  = "upper";
const char * const  ATTR_EITHER = "either";
const char * const  ATTR_NOINIT = "noinit";
const char * const  ATTR_PERSIST = "persistent";
const char * const  SEC_NOINIT = ".noinit";
const char * const  SEC_PERSIST = ".persistent";

static inline bool
has_attr (const char * attr, tree decl)
{
  if (decl == NULL_TREE)
    return false;
  return lookup_attribute (attr, DECL_ATTRIBUTES (decl)) != NULL_TREE;
}

static bool
is_interrupt_func (tree decl = current_function_decl)
{
  return has_attr (ATTR_INTR, decl);
}

/* Returns true if the current function has the "interrupt" attribute.  */

bool
msp430_is_interrupt_func (void)
{
  return is_interrupt_func (current_function_decl);
}

static bool
is_wakeup_func (tree decl = current_function_decl)
{
  return is_interrupt_func (decl) && has_attr (ATTR_WAKEUP, decl);
}

static inline bool
is_naked_func (tree decl = current_function_decl)
{
  return has_attr (ATTR_NAKED, decl);
}

static inline bool
is_reentrant_func (tree decl = current_function_decl)
{
  return has_attr (ATTR_REENT, decl);
}

static inline bool
is_critical_func (tree decl = current_function_decl)
{
  return has_attr (ATTR_CRIT, decl);
}

static bool
has_section_name (const char * name, tree decl = current_function_decl)
{
  if (decl == NULL_TREE)
    return false;
  return (DECL_SECTION_NAME (decl)
    && (strcmp (name, DECL_SECTION_NAME (decl)) == 0));
}

#undef  TARGET_ALLOCATE_STACK_SLOTS_FOR_ARGS
#define TARGET_ALLOCATE_STACK_SLOTS_FOR_ARGS	msp430_allocate_stack_slots_for_args

static bool
msp430_allocate_stack_slots_for_args (void)
{
  /* Naked functions should not allocate stack slots for arguments.  */
  return ! is_naked_func ();
}

#undef TARGET_WARN_FUNC_RETURN
#define TARGET_WARN_FUNC_RETURN msp430_warn_func_return

static bool
msp430_warn_func_return (tree decl)
{
  /* Naked functions are implemented entirely in assembly, including the
     return sequence, so suppress warnings about this.  */
  return !is_naked_func (decl);
}

/* Verify MSP430 specific attributes.  */
#define TREE_NAME_EQ(NAME, STR) (strcmp (IDENTIFIER_POINTER (NAME), (STR)) == 0)

static tree
msp430_attr (tree * node,
	     tree   name,
	     tree   args,
	     int    flags ATTRIBUTE_UNUSED,
	     bool * no_add_attrs)
{
  gcc_assert (DECL_P (* node));

  /* Only the interrupt attribute takes an argument.  */
  if (args != NULL)
    {
      tree value = TREE_VALUE (args);

      switch (TREE_CODE (value))
	{
	case STRING_CST:
	  if (   strcmp (TREE_STRING_POINTER (value), "reset")
	      && strcmp (TREE_STRING_POINTER (value), "nmi")
	      && strcmp (TREE_STRING_POINTER (value), "watchdog"))
	    /* Allow the attribute to be added - the linker script
	       being used may still recognise this name.  */
	    warning (OPT_Wattributes,
		     "unrecognized interrupt vector argument of %qE attribute",
		     name);
	  break;

	case INTEGER_CST:
	  if (wi::gtu_p (wi::to_wide (value), 63))
	    /* Allow the attribute to be added - the linker script
	       being used may still recognise this value.  */
	    warning (OPT_Wattributes,
		     "numeric argument of %qE attribute must be in range 0..63",
		     name);
	  break;

	default:
	  warning (OPT_Wattributes,
		   "argument of %qE attribute is not a string constant or number",
		   name);
	  *no_add_attrs = true;
	  break;
	}
    }

  const char * message = NULL;

  if (TREE_CODE (* node) != FUNCTION_DECL)
    {
      message = "%qE attribute only applies to functions";
    }
  else if (TREE_NAME_EQ (name, ATTR_INTR))
    {
      if (TREE_CODE (TREE_TYPE (* node)) == FUNCTION_TYPE
	  && ! VOID_TYPE_P (TREE_TYPE (TREE_TYPE (* node))))
	message = "interrupt handlers must be void";
      else
	{
	  /* Disable cloning and ICF for interrupt functions to prevent any
	     possible issues with GCC assuming the calling convention of
	     interrupt functions is the same as regular functions.  */
	  tree no_icf = tree_cons (get_identifier ("no_icf"), NULL, NULL_TREE);
	  tree noclone = tree_cons (get_identifier ("noclone"), NULL, NULL_TREE);
	  DECL_ATTRIBUTES (* node) = merge_attributes (DECL_ATTRIBUTES (* node),
						       no_icf);
	  DECL_ATTRIBUTES (* node) = merge_attributes (DECL_ATTRIBUTES (* node),
						       noclone);
	  /* Ensure interrupt handlers never get optimised out.  */
	  TREE_USED (* node) = 1;
	  DECL_PRESERVE_P (* node) = 1;
	}
      if (is_critical_func (* node))
	{
	  warning (OPT_Wattributes,
		   "critical attribute has no effect on interrupt functions");
	  DECL_ATTRIBUTES (*node) = remove_attribute (ATTR_CRIT,
						      DECL_ATTRIBUTES (* node));
	}
    }
  else if (TREE_NAME_EQ (name, ATTR_REENT))
    {
      if (is_naked_func (* node))
	message = "naked functions cannot be reentrant";
      else if (is_critical_func (* node))
	message = "critical functions cannot be reentrant";
    }
  else if (TREE_NAME_EQ (name, ATTR_CRIT))
    {
      if (is_naked_func (* node))
	message = "naked functions cannot be critical";
      else if (is_reentrant_func (* node))
	message = "reentrant functions cannot be critical";
      else if (is_interrupt_func ( *node))
	message = "critical attribute has no effect on interrupt functions";
    }
  else if (TREE_NAME_EQ (name, ATTR_NAKED))
    {
      if (is_critical_func (* node))
	message = "critical functions cannot be naked";
      else if (is_reentrant_func (* node))
	message = "reentrant functions cannot be naked";
    }

  if (message)
    {
      warning (OPT_Wattributes, message, name);
      * no_add_attrs = true;
    }
    
  return NULL_TREE;
}

static tree
msp430_section_attr (tree * node,
		     tree   name,
		     tree   args,
		     int    flags ATTRIBUTE_UNUSED,
		     bool * no_add_attrs ATTRIBUTE_UNUSED)
{
  gcc_assert (DECL_P (* node));
  gcc_assert (args == NULL);

  const char * message = NULL;

  if (TREE_NAME_EQ (name, ATTR_UPPER))
    {
      if (has_attr (ATTR_LOWER, * node))
	message = G_("%qE attribute ignored. already marked with 'lower' attribute");
      else if (has_attr (ATTR_EITHER, * node))
	message = G_("%qE attribute ignored. already marked with 'either' attribute");
      else if (! msp430x)
	message = G_("%qE attribute ignored. upper attribute needs a 430X cpu");
    }
  else if (TREE_NAME_EQ (name, ATTR_LOWER))
    {
      if (has_attr (ATTR_UPPER, * node))
	message = G_("%qE attribute ignored. already marked with 'upper' attribute");
      else if (has_attr (ATTR_EITHER, * node))
	message = G_("%qE attribute ignored. already marked with 'either' attribute");
    }
  else
    {
      gcc_assert (TREE_NAME_EQ (name, ATTR_EITHER));

      if (has_attr (ATTR_LOWER, * node))
	message = G_("%qE attribute ignored. already marked with 'lower' attribute");
      else if (has_attr (ATTR_UPPER, * node))
	message = G_("%qE attribute ignored. already marked with 'upper' attribute");
    }

  /* It does not make sense to use upper/lower/either attributes without
     -mlarge.
     Without -mlarge, "lower" is the default and only region, so is redundant.
     Without -mlarge, "upper" will (and "either" might) place code/data in the
     upper region, which for data could result in relocation overflows, and for
     code could result in stack mismanagement and faulty call/return
     instructions.  */
  if (!TARGET_LARGE)
    message = G_("%qE attribute ignored. large memory model (-mlarge) is required");

  if (message)
    {
      warning (OPT_Wattributes, message, name);
      * no_add_attrs = true;
    }
    
  return NULL_TREE;
}

static tree
msp430_data_attr (tree * node,
		  tree   name,
		  tree   args,
		  int    flags ATTRIBUTE_UNUSED,
		  bool * no_add_attrs ATTRIBUTE_UNUSED)
{
  const char * message = NULL;

  gcc_assert (DECL_P (* node));
  gcc_assert (args == NULL);

  /* Variable name to use in warning string, defaults to attribute name.  */
  tree var = name;
  tree decl = *node;

  if (TREE_CODE (decl) != VAR_DECL)
    {
      message = G_("%qE attribute only applies to variables");
      goto fail;
    }

  if (!(TREE_STATIC (decl) || TREE_PUBLIC (decl) || DECL_EXTERNAL (decl)
	|| in_lto_p))
    {
      message = G_("%qE attribute has no effect on automatic variables");
      goto fail;
    }

  if ((TREE_NAME_EQ (name, ATTR_PERSIST)
       && has_attr (ATTR_NOINIT, decl))
      || (TREE_NAME_EQ (name, ATTR_NOINIT)
	  && has_attr (ATTR_PERSIST, decl)))
    {
      message
	= G_("variable %qE cannot have both noinit and persistent attributes");
      var = decl;
      goto fail;
    }

  /* The decl may have already been given a section.  Ensure it matches the
     given attribute.  */
  if (DECL_SECTION_NAME (decl) != NULL
      && ((TREE_NAME_EQ (name, ATTR_PERSIST)
	   && strcmp (SEC_PERSIST, DECL_SECTION_NAME (decl)) != 0)
	  || (TREE_NAME_EQ (name, ATTR_NOINIT)
	      && strcmp (SEC_NOINIT, DECL_SECTION_NAME (decl)) != 0)))
    {
      message = G_("section of %qE conflicts with previous declaration");
      var = decl;
      goto fail;
    }

  if (TREE_NAME_EQ (name, ATTR_PERSIST))
    {
      if (DECL_INITIAL (decl) == NULL)
	{
	  message = G_("variable %qE was declared persistent and should be "
		       "explicitly initialized");
	  var = decl;
	  goto fail;
	}
    }

  /* In some cases the front-end will place data before msp430_select_section
     gets a chance, so just put noinit and persistent variables in the correct
     section now.  */
  if (TREE_NAME_EQ (name, ATTR_PERSIST))
    set_decl_section_name (decl, SEC_PERSIST);
  else if (TREE_NAME_EQ (name, ATTR_NOINIT))
    set_decl_section_name (decl, SEC_NOINIT);

  goto done;

fail:
  warning (OPT_Wattributes, message, var);
  * no_add_attrs = true;

done:
  return NULL_TREE;
}

static unsigned int
get_location_attribute_address (tree decl)
{
  tree loc_attr;
  loc_attr = lookup_attribute ("location", DECL_ATTRIBUTES (decl));
  if (loc_attr != NULL_TREE)
    {
      tree value = TREE_VALUE (loc_attr);
      value = TREE_VALUE (value);
      /* The attribute spec should be enforcing that the location attribute
         must have exactly one argument.  */
      gcc_assert (value != NULL_TREE);

      return TREE_INT_CST_LOW (value);
    }
  return 0;
}

/* Assume variables without an explicit section or attribute will be in lower
   (i.e. < 0x10000) memory.  */
static int
msp430_var_in_low_mem (tree decl)
{
  /* "noinit" variables are always placed in the lower memory region.  */
  if (has_attr (ATTR_UPPER, decl)
      || has_attr (ATTR_EITHER, decl)
      || has_attr (ATTR_PERSIST, decl)
      || get_location_attribute_address (decl) >= 0x10000
      /* Unless the variable is marked with the lower or noinit attribute, we
	 cannot assume that it is in the lower region if it is marked with the
	 section attribute or -mdata-region={upper,either,none} have been
	 passed.
	 The noinit and section attributes conflict.  */
      || (!has_attr (ATTR_LOWER, decl) && !has_attr (ATTR_NOINIT, decl)
	  && (has_attr ("section", decl)
	      || msp430_data_region == MSP430_REGION_UPPER
	      || msp430_data_region == MSP430_REGION_EITHER
	      || msp430_data_region == MSP430_REGION_ANY)))
    return 0;
  return 1;
}

#undef TARGET_ENCODE_SECTION_INFO
#define TARGET_ENCODE_SECTION_INFO msp430_encode_section_info

static void
msp430_encode_section_info (tree decl, rtx rtl, int first)
{
  default_encode_section_info (decl, rtl, first);
  rtx symbol = XEXP (rtl, 0);

  /* Careful not to prod global register variables.  */
  if (TREE_CODE (decl) == VAR_DECL
      && GET_CODE (DECL_RTL (decl)) == MEM
      && GET_CODE (XEXP (DECL_RTL (decl), 0)) == SYMBOL_REF
      && (TREE_STATIC (decl) || DECL_EXTERNAL (decl))
      && msp430_var_in_low_mem (decl))
    SYMBOL_REF_FLAGS (symbol) = SYMBOL_FLAG_LOW_MEM;
}

#undef  TARGET_ATTRIBUTE_TABLE
#define TARGET_ATTRIBUTE_TABLE		msp430_attribute_table

/* Table of MSP430-specific attributes.  */
const struct attribute_spec msp430_attribute_table[] =
{
  /* Name        min_num_args     type_req,             handler
		      max_num_args,     fn_type_req		exclude
                          decl_req               affects_type_identity.  */
  { ATTR_INTR,        0, 1, true,  false, false, false, msp430_attr, NULL },
  { ATTR_NAKED,       0, 0, true,  false, false, false, msp430_attr, NULL },
  { ATTR_REENT,       0, 0, true,  false, false, false, msp430_attr, NULL },
  { ATTR_CRIT,        0, 0, true,  false, false, false, msp430_attr, NULL },
  { ATTR_WAKEUP,      0, 0, true,  false, false, false, msp430_attr, NULL },

  { ATTR_LOWER,       0, 0, true,  false, false, false, msp430_section_attr,
    NULL },
  { ATTR_UPPER,       0, 0, true,  false, false, false, msp430_section_attr,
    NULL },
  { ATTR_EITHER,      0, 0, true,  false, false, false, msp430_section_attr,
    NULL },

  { ATTR_NOINIT,      0, 0, true,  false, false, false, msp430_data_attr,
    NULL },
  { ATTR_PERSIST,     0, 0, true,  false, false, false, msp430_data_attr,
    NULL },

  { NULL,             0, 0, false, false, false, false, NULL,  NULL }
};

#undef  TARGET_ASM_FUNCTION_PROLOGUE
#define TARGET_ASM_FUNCTION_PROLOGUE	msp430_start_function

static void
msp430_start_function (FILE *outfile)
{
  int r, n;

  fprintf (outfile, "; start of function\n");

  if (DECL_ATTRIBUTES (current_function_decl) != NULL_TREE)
    {
      fprintf (outfile, "; attributes: ");
      if (is_naked_func ())
	fprintf (outfile, "naked ");
      if (msp430_is_interrupt_func ())
	fprintf (outfile, "interrupt ");
      if (is_reentrant_func ())
	fprintf (outfile, "reentrant ");
      if (is_critical_func ())
	fprintf (outfile, "critical ");
      if (is_wakeup_func ())
	fprintf (outfile, "wakeup ");
      fprintf (outfile, "\n");
    }

  fprintf (outfile, "; framesize_regs:     %d\n", cfun->machine->framesize_regs);
  fprintf (outfile, "; framesize_locals:   %d\n", cfun->machine->framesize_locals);
  fprintf (outfile, "; framesize_outgoing: %d\n", cfun->machine->framesize_outgoing);
  fprintf (outfile, "; framesize:          %d\n", cfun->machine->framesize);
  fprintf (outfile, "; elim ap -> fp       %d\n", msp430_initial_elimination_offset (ARG_POINTER_REGNUM, FRAME_POINTER_REGNUM));
  fprintf (outfile, "; elim fp -> sp       %d\n", msp430_initial_elimination_offset (FRAME_POINTER_REGNUM, STACK_POINTER_REGNUM));

  n = 0;
  fprintf (outfile, "; saved regs:");
  for (r = 0; r < ARG_POINTER_REGNUM; r++)
    if (cfun->machine->need_to_save [r])
      {
	fprintf (outfile, " %s", reg_names [r]);
	n = 1;
      }
  if (n == 0)
    fprintf (outfile, "(none)");
  fprintf (outfile, "\n");
}

/* Common code to change the stack pointer.  */
static void
increment_stack (HOST_WIDE_INT amount)
{
  rtx inc;
  rtx sp =  stack_pointer_rtx;

  if (amount == 0)
    return;

  if (amount < 0)
    {
      inc = GEN_INT (- amount);
      if (TARGET_LARGE)
	F (emit_insn (gen_subpsi3 (sp, sp, inc)));
      else
	F (emit_insn (gen_subhi3 (sp, sp, inc)));
    }
  else
    {
      inc = GEN_INT (amount);
      if (TARGET_LARGE)
	F (emit_insn (gen_addpsi3 (sp, sp, inc)));
      else
	F (emit_insn (gen_addhi3 (sp, sp, inc)));
    }
}

void
msp430_start_function (FILE *file, const char *name, tree decl)
{
  tree int_attr;

  int_attr = lookup_attribute ("interrupt", DECL_ATTRIBUTES (decl));
  if (int_attr != NULL_TREE)
    {
      tree intr_vector = TREE_VALUE (int_attr);

      if (intr_vector != NULL_TREE)
	{
	  char buf[101];

	  /* Interrupt vector sections should be unique, but use of weak
	     functions implies multiple definitions.  */
	  if (DECL_WEAK (decl))
	    {
	      error ("argument to interrupt attribute is unsupported for weak functions");
	    }

	  intr_vector = TREE_VALUE (intr_vector);

	  /* The interrupt attribute has a vector value.  Turn this into a
	     section name, switch to that section and put the address of
	     the current function into that vector slot.  Note msp430_attr()
	     has already verified the vector name for us.  */
	  if (TREE_CODE (intr_vector) == STRING_CST)
	    sprintf (buf, "__interrupt_vector_%.80s",
		     TREE_STRING_POINTER (intr_vector));
	  else /* TREE_CODE (intr_vector) == INTEGER_CST */
	    sprintf (buf, "__interrupt_vector_%u",
		     (unsigned int) TREE_INT_CST_LOW (intr_vector));

	  switch_to_section (get_section (buf, SECTION_CODE, decl));
	  fputs ("\t.word\t", file);
	  assemble_name (file, name);
	  fputc ('\n', file);
	  fputc ('\t', file);
	}
    }

  switch_to_section (function_section (decl));
  ASM_OUTPUT_TYPE_DIRECTIVE(file, name, "function");
  ASM_OUTPUT_SYM_META_INFO (file, name, decl);
  ASM_OUTPUT_FUNCTION_LABEL (file, name, decl);
}

static const char * const lower_prefix = ".lower";
static const char * const upper_prefix = ".upper";
static const char * const either_prefix = ".either";

/* Generate a prefix for a section name, based upon
   the region into which the object should be placed.  */

static const char *
gen_prefix (tree decl)
{
  if (DECL_ONE_ONLY (decl))
    return NULL;

  /* If the user has specified a particular section then do not use any prefix.  */
  if (has_attr ("section", decl))
    return NULL;

  /* If the function has been put in the .lowtext section (because it is an
     interrupt handler, and the large memory model is used), then do not add
     any prefixes.  */
  if (has_section_name (".lowtext", decl))
    return NULL;

  /* If the object has __attribute__((lower)) then use the ".lower." prefix.
     TARGET_USE_LOWER_REGION_PREFIX is not required to be set when adding the
     .lower prefix to a specific object.  */
  if (has_attr (ATTR_LOWER, decl))
    return lower_prefix;

  /* If we are compiling for the MSP430 then we do not support the upper region.  */
  if (! msp430x)
    return NULL;

  /* Do not add prefixes to data to be placed in the .noinit or .persistent
     section.  */
  if (has_attr (ATTR_NOINIT, decl) || has_attr (ATTR_PERSIST, decl))
    return NULL;

  if (has_attr (ATTR_UPPER, decl))
    return upper_prefix;

  if (has_attr (ATTR_EITHER, decl))
    return either_prefix;

  if (TREE_CODE (decl) == FUNCTION_DECL)
    {
      if ((msp430_code_region == MSP430_REGION_LOWER) && TARGET_USE_LOWER_REGION_PREFIX)
	return lower_prefix;

      if (msp430_code_region == MSP430_REGION_UPPER)
	return upper_prefix;

      if (msp430_code_region == MSP430_REGION_EITHER)
	return either_prefix;
    }
  else
    {
      if ((msp430_data_region == MSP430_REGION_LOWER) && TARGET_USE_LOWER_REGION_PREFIX)
	return lower_prefix;

      if (msp430_data_region == MSP430_REGION_UPPER)
	return upper_prefix;

      if (msp430_data_region == MSP430_REGION_EITHER)
	return either_prefix;
    }

  return NULL;
}

static section * noinit_section;
static section * persist_section;

#undef  TARGET_ASM_INIT_SECTIONS
#define TARGET_ASM_INIT_SECTIONS msp430_init_sections

static void
msp430_init_sections (void)
{
  noinit_section = get_unnamed_section (0, output_section_asm_op, ".section .noinit,\"aw\"");
  persist_section = get_unnamed_section (0, output_section_asm_op, ".section .persistent,\"aw\"");
}

#undef  TARGET_ASM_SELECT_SECTION
#define TARGET_ASM_SELECT_SECTION msp430_select_section

static section *
msp430_select_section (tree decl, int reloc, unsigned HOST_WIDE_INT align)
{
  gcc_assert (decl != NULL_TREE);

  if (TREE_CODE (decl) == STRING_CST
      || TREE_CODE (decl) == CONSTRUCTOR
      || TREE_CODE (decl) == INTEGER_CST
      || TREE_CODE (decl) == VECTOR_CST
      || TREE_CODE (decl) == COMPLEX_CST)
    return default_elf_select_section (decl, reloc, align);
  
  /* In large mode we must make sure that interrupt handlers are put into
     low memory as the vector table only accepts 16-bit addresses.  */
  if (TARGET_LARGE && TREE_CODE (decl) == FUNCTION_DECL && is_interrupt_func (decl))
    return get_section (".lowtext", SECTION_CODE | SECTION_WRITE , decl);

  const char * prefix = gen_prefix (decl);
  if (prefix == NULL)
    {
      if (TREE_CODE (decl) == FUNCTION_DECL)
	return text_section;
      else if (has_attr (ATTR_NOINIT, decl))
	return noinit_section;
      else if (has_attr (ATTR_PERSIST, decl))
	return persist_section;
      else
	return default_elf_select_section (decl, reloc, align);
    }
  
  const char * sec;
  switch (categorize_decl_for_section (decl, reloc))
    {
    case SECCAT_TEXT:   sec = ".text";   break;
    case SECCAT_DATA:   sec = ".data";   break;
    case SECCAT_BSS:    sec = ".bss";    break;
    case SECCAT_RODATA: sec = ".rodata"; break;

    case SECCAT_RODATA_MERGE_STR:
    case SECCAT_RODATA_MERGE_STR_INIT:
    case SECCAT_RODATA_MERGE_CONST:
    case SECCAT_SRODATA:
    case SECCAT_DATA_REL:
    case SECCAT_DATA_REL_LOCAL:
    case SECCAT_DATA_REL_RO:
    case SECCAT_DATA_REL_RO_LOCAL:
    case SECCAT_SDATA:
    case SECCAT_SBSS:
    case SECCAT_TDATA:
    case SECCAT_TBSS:
      return default_elf_select_section (decl, reloc, align);

    default:
      gcc_unreachable ();
    }
  
  const char * dec_name = DECL_SECTION_NAME (decl);
  char * name = ACONCAT ((prefix, sec, dec_name, NULL));

  return get_named_section (decl, name, 0);
}

#undef  TARGET_ASM_FUNCTION_SECTION
#define TARGET_ASM_FUNCTION_SECTION msp430_function_section

static section *
msp430_function_section (tree decl, enum node_frequency freq, bool startup, bool exit)
{
  const char * name;

  gcc_assert (DECL_SECTION_NAME (decl) != NULL);
  name = DECL_SECTION_NAME (decl);

  const char * prefix = gen_prefix (decl);
  if (prefix == NULL
      || strncmp (name, prefix, strlen (prefix)) == 0)
    return default_function_section (decl, freq, startup, exit);

  name = ACONCAT ((prefix, name, NULL));
  return get_named_section (decl, name, 0);
}

#undef  TARGET_SECTION_TYPE_FLAGS
#define TARGET_SECTION_TYPE_FLAGS msp430_section_type_flags

unsigned int
msp430_section_type_flags (tree decl, const char * name, int reloc)
{
  if (strncmp (name, lower_prefix, strlen (lower_prefix)) == 0)
    name += strlen (lower_prefix);
  else if (strncmp (name, upper_prefix, strlen (upper_prefix)) == 0)
    name += strlen (upper_prefix);
  else if (strncmp (name, either_prefix, strlen (either_prefix)) == 0)
    name += strlen (either_prefix);
  else if (strcmp (name, SEC_NOINIT) == 0)
    return SECTION_WRITE | SECTION_BSS | SECTION_NOTYPE;
  else if (strcmp (name, SEC_PERSIST) == 0)
    return SECTION_WRITE | SECTION_NOTYPE;
  
  return default_section_type_flags (decl, name, reloc);
}

#undef  TARGET_ASM_UNIQUE_SECTION
#define TARGET_ASM_UNIQUE_SECTION msp430_unique_section

static void
msp430_unique_section (tree decl, int reloc)
{
  gcc_assert (decl != NULL_TREE);

  /* In large mode we must make sure that interrupt handlers are put into
     low memory as the vector table only accepts 16-bit addresses.  */
  if (TARGET_LARGE && TREE_CODE (decl) == FUNCTION_DECL && is_interrupt_func (decl))
    {
      set_decl_section_name (decl, ".lowtext");
      return;
    }

  default_unique_section (decl, reloc);

  const char * prefix;

  if (   TREE_CODE (decl) == STRING_CST
      || TREE_CODE (decl) == CONSTRUCTOR
      || TREE_CODE (decl) == INTEGER_CST
      || TREE_CODE (decl) == VECTOR_CST
      || TREE_CODE (decl) == COMPLEX_CST
      || (prefix = gen_prefix (decl)) == NULL
      )
    return;

  const char * dec_name = DECL_SECTION_NAME (decl);
  char * name = ACONCAT ((prefix, dec_name, NULL));

  set_decl_section_name (decl, name);
}

/* Emit a declaration of a common symbol.
   If a data region is in use then put the symbol into the
   equivalent .bss section instead.  */

void
msp430_output_aligned_decl_common (FILE *                 stream,
				   const tree             decl,
				   const char *           name,
				   unsigned HOST_WIDE_INT size,
				   unsigned int           align)
{
  if ((msp430_data_region == MSP430_REGION_ANY
       || ((msp430_data_region == MSP430_REGION_LOWER)
	   && !TARGET_USE_LOWER_REGION_PREFIX))
      && !has_attr (ATTR_EITHER, decl)
      && !has_attr (ATTR_LOWER, decl)
      && !has_attr (ATTR_UPPER, decl)
      && !has_attr (ATTR_PERSIST, decl)
      && !has_attr (ATTR_NOINIT, decl)
      && !has_attr ("location", decl)
      && !has_attr ("retain", decl))
    {
      fprintf (stream, COMMON_ASM_OP);
      assemble_name (stream, name);
      fprintf (stream, "," HOST_WIDE_INT_PRINT_UNSIGNED",%u\n",
	       size, align / BITS_PER_UNIT);
    }
  else
    {
      section * sec;

      if (decl)
	sec = msp430_select_section (decl, 0, align);
      else
	switch (msp430_data_region)
	  {
	  case MSP430_REGION_UPPER:
	    sec = get_named_section (NULL, ".upper.bss", 0);
	    break;
	  case MSP430_REGION_LOWER:
	    if (TARGET_USE_LOWER_REGION_PREFIX)
	      sec = get_named_section (NULL, ".lower.bss", 0);
	    else
	      sec = get_named_section (NULL, ".bss", 0);
	    break;
	  case MSP430_REGION_EITHER:
	    sec = get_named_section (NULL, ".either.bss", 0);
	    break;
	  default:
	    gcc_unreachable ();
	  }
      gcc_assert (sec != NULL);

      switch_to_section (sec);
      ASM_OUTPUT_ALIGN (stream, floor_log2 (align / BITS_PER_UNIT));
      targetm.asm_out.globalize_label (stream, name);
      ASM_WEAKEN_LABEL (stream, name);
      ASM_OUTPUT_LABEL (stream, name);
      ASM_OUTPUT_SKIP (stream, size ? size : 1);
    }
  ASM_OUTPUT_SYM_META_INFO (stream, name, decl);
}

#undef TARGET_ASM_FILE_END
#define TARGET_ASM_FILE_END msp430_file_end

/* Emit MSPABI and GNU object attributes.
   Tags and values for MSPABI attributes are:
   OFBA_MSPABI_Tag_ISA		4
     MSP430	1
     MSP430X	2
   OFBA_MSPABI_Tag_Code_Model	6
     Small 	1
     Large	2
   OFBA_MSPABI_Tag_Data_Model	8
     Small 	1
     Large	2
     Restricted	3 (Unused by GNU)
   OFBA_MSPABI_Tag_enum_size	10 (Unused by GNU)
   Note that Code_Model and Data_Model are always equal for GNU.
   We define a new .gnu_attribute to keep track of the data region used.
   Tag_GNU_MSP430_Data_Region	4
     LOWER	1
     ANY	2
   See binutils-gdb/include/elf/msp430.h for the full details.  */
static void
msp430_file_end (void)
{
#ifdef HAVE_AS_GNU_ATTRIBUTE
  /* Enum for tag names.  */
  enum
    {
      OFBA_MSPABI_Tag_ISA = 4,
      OFBA_MSPABI_Tag_Code_Model = 6,
      OFBA_MSPABI_Tag_Data_Model = 8,
      Tag_GNU_MSP430_Data_Region = 4
    };
  /* Enum for tag values.  */
  enum
    {
      OFBA_MSPABI_Val_ISA_MSP430 = 1,
      OFBA_MSPABI_Val_ISA_MSP430X = 2,
      OFBA_MSPABI_Val_Model_Small = 1,
      OFBA_MSPABI_Val_Model_Large = 2,
      Tag_GNU_MSP430_Data_Region_Lower = 1,
      Tag_GNU_MSP430_Data_Region_Any = 2
    };
  /* .mspabi_attribute is a GNU assembler directive only.  The assembler will
     construct a .MSP430.attributes section based on the options it is invoked
     with.  The values it reads from these directives are used for validating
     those options.  */
  const char *msp_attr = ".mspabi_attribute";
  const char *gnu_attr = ".gnu_attribute";

#ifdef HAVE_AS_MSPABI_ATTRIBUTE
  /* Emit .mspabi_attribute directive for OFBA_MSPABI_Tag_ISA.  */
  fprintf (asm_out_file, "\t%s %d, %d\n", msp_attr, OFBA_MSPABI_Tag_ISA,
	   msp430x ? OFBA_MSPABI_Val_ISA_MSP430X : OFBA_MSPABI_Val_ISA_MSP430);
  /* Emit .mspabi_attribute directive for OFBA_MSPABI_Tag_Code_Model.  */
  fprintf (asm_out_file, "\t%s %d, %d\n", msp_attr, OFBA_MSPABI_Tag_Code_Model,
	   TARGET_LARGE ? OFBA_MSPABI_Val_Model_Large
	   : OFBA_MSPABI_Val_Model_Small);
  /* Emit .mspabi_attribute directive for OFBA_MSPABI_Tag_Data_Model.  */
  fprintf (asm_out_file, "\t%s %d, %d\n", msp_attr, OFBA_MSPABI_Tag_Data_Model,
	   TARGET_LARGE ? OFBA_MSPABI_Val_Model_Large
	   : OFBA_MSPABI_Val_Model_Small);
#endif /* HAVE_AS_MSPABI_ATTRIBUTE */
  /* Emit .gnu_attribute directive for Tag_GNU_MSP430_Data_Region.  */
  fprintf (asm_out_file, "\t%s %d, %d\n", gnu_attr, Tag_GNU_MSP430_Data_Region,
	   msp430_data_region == MSP430_REGION_LOWER
	   ? Tag_GNU_MSP430_Data_Region_Lower
	   : Tag_GNU_MSP430_Data_Region_Any);
#endif /* HAVE_AS_GNU_ATTRIBUTE */
}

bool
msp430_do_not_relax_short_jumps (void)
{
  /* When placing code into "either" low or high memory we do not want the linker
     to grow the size of sections, which it can do if it is encounters a branch to
     a label that is too far away.  So we tell the cbranch patterns to avoid using
     short jumps when there is a chance that the instructions will end up in a low
     section.  */
  return
    msp430_code_region == MSP430_REGION_EITHER
    || msp430_code_region == MSP430_REGION_LOWER
    || has_attr (ATTR_EITHER, current_function_decl)
    || has_attr (ATTR_LOWER, current_function_decl);
}

enum msp430_builtin
{
  MSP430_BUILTIN_BIC_SR,
  MSP430_BUILTIN_BIS_SR,
  MSP430_BUILTIN_DELAY_CYCLES,
  MSP430_BUILTIN_max
};

static GTY(()) tree msp430_builtins [(int) MSP430_BUILTIN_max];

static void
msp430_init_builtins (void)
{
  tree void_ftype_int = build_function_type_list (void_type_node, integer_type_node, NULL);
  tree void_ftype_longlong = build_function_type_list (void_type_node, long_long_integer_type_node, NULL);

  msp430_builtins[MSP430_BUILTIN_BIC_SR] =
    add_builtin_function ( "__bic_SR_register_on_exit", void_ftype_int,
			   MSP430_BUILTIN_BIC_SR, BUILT_IN_MD, NULL, NULL_TREE);

  msp430_builtins[MSP430_BUILTIN_BIS_SR] =
    add_builtin_function ( "__bis_SR_register_on_exit", void_ftype_int,
			   MSP430_BUILTIN_BIS_SR, BUILT_IN_MD, NULL, NULL_TREE);

  msp430_builtins[MSP430_BUILTIN_DELAY_CYCLES] =
    add_builtin_function ( "__delay_cycles", void_ftype_longlong,
			   MSP430_BUILTIN_DELAY_CYCLES, BUILT_IN_MD, NULL, NULL_TREE);
}

static tree
msp430_builtin_decl (unsigned code, bool initialize ATTRIBUTE_UNUSED)
{
  switch (code)
    {
    case MSP430_BUILTIN_BIC_SR:
    case MSP430_BUILTIN_BIS_SR:
    case MSP430_BUILTIN_DELAY_CYCLES:
      return msp430_builtins[code];
    default:
      return error_mark_node;
    }
}

/* These constants are really register reads, which are faster than
   regular constants.  */
static int
cg_magic_constant (HOST_WIDE_INT c)
{
  switch (c)
    {
    case 0xffff:
    case -1:
    case 0:
    case 1:
    case 2:
    case 4:
    case 8:
      return 1;
    default:
      return 0;
    }
}

static rtx
msp430_expand_delay_cycles (rtx arg)
{
  HOST_WIDE_INT i, c, n;
  /* extra cycles for MSP430X instructions */
#define CYCX(M,X) (msp430x ? (X) : (M))

  if (GET_CODE (arg) != CONST_INT)
    {
      error ("__delay_cycles() only takes constant arguments");
      return NULL_RTX;
    }

  c = INTVAL (arg);

  if (HOST_BITS_PER_WIDE_INT > 32)
    {
      if (c < 0)
	{
	  error ("__delay_cycles only takes non-negative cycle counts");
	  return NULL_RTX;
	}
    }

  emit_insn (gen_delay_cycles_start (arg));

  /* For 32-bit loops, there's 13(16) + 5(min(x,0x10000) + 6x cycles.  */
  if (c > 3 * 0xffff + CYCX (7, 10))
    {
      n = c;
      /* There's 4 cycles in the short (i>0xffff) loop and 7 in the long (x<=0xffff) loop */
      if (c >= 0x10000 * 7 + CYCX (14, 16))
	{
	  i = 0x10000;
	  c -= CYCX (14, 16) + 7 * 0x10000;
	  i += c / 4;
	  c %= 4;
	  if ((unsigned long long) i > 0xffffffffULL)
	    {
	      error ("__delay_cycles is limited to 32-bit loop counts");
	      return NULL_RTX;
	    }
	}
      else
	{
	  i = (c - CYCX (14, 16)) / 7;
	  c -= CYCX (14, 16) + i * 7;
	}

      if (cg_magic_constant (i & 0xffff))
	c ++;
      if (cg_magic_constant ((i >> 16) & 0xffff))
	c ++;

      if (msp430x)
	emit_insn (gen_delay_cycles_32x (GEN_INT (i), GEN_INT (n - c)));
      else
	emit_insn (gen_delay_cycles_32 (GEN_INT (i), GEN_INT (n - c)));
    }

  /* For 16-bit loops, there's 7(10) + 3x cycles - so the max cycles is 0x30004(7).  */
  if (c > 12)
    {
      n = c;
      i = (c - CYCX (7, 10)) / 3;
      c -= CYCX (7, 10) + i * 3;

      if (cg_magic_constant (i))
	c ++;

      if (msp430x)
	emit_insn (gen_delay_cycles_16x (GEN_INT (i), GEN_INT (n - c)));
      else
	emit_insn (gen_delay_cycles_16 (GEN_INT (i), GEN_INT (n - c)));
    }

  while (c > 1)
    {
      emit_insn (gen_delay_cycles_2 ());
      c -= 2;
    }

  if (c)
    {
      emit_insn (gen_delay_cycles_1 ());
      c -= 1;
    }

  emit_insn (gen_delay_cycles_end (arg));

  return NULL_RTX;
}

static rtx
msp430_expand_builtin (tree exp,
		       rtx target ATTRIBUTE_UNUSED,
		       rtx subtarget ATTRIBUTE_UNUSED,
		       machine_mode mode ATTRIBUTE_UNUSED,
		       int ignore ATTRIBUTE_UNUSED)
{
  tree fndecl = TREE_OPERAND (CALL_EXPR_FN (exp), 0);
  unsigned int fcode = DECL_FUNCTION_CODE (fndecl);
  rtx arg1 = expand_normal (CALL_EXPR_ARG (exp, 0));

  if (fcode == MSP430_BUILTIN_DELAY_CYCLES)
    return msp430_expand_delay_cycles (arg1);

  if (! msp430_is_interrupt_func ())
    {
      error ("MSP430 builtin functions only work inside interrupt handlers");
      return NULL_RTX;
    }

  if (! REG_P (arg1) && ! CONSTANT_P (arg1))
    arg1 = force_reg (mode, arg1);

  switch (fcode)
    {
    case MSP430_BUILTIN_BIC_SR:  emit_insn (gen_bic_SR (arg1)); break;
    case MSP430_BUILTIN_BIS_SR:  emit_insn (gen_bis_SR (arg1)); break;
    default:
      internal_error ("bad builtin code");
      break;
    }
  return NULL_RTX;
}

#undef  TARGET_INIT_BUILTINS
#define TARGET_INIT_BUILTINS  msp430_init_builtins

#undef  TARGET_EXPAND_BUILTIN
#define TARGET_EXPAND_BUILTIN msp430_expand_builtin

#undef  TARGET_BUILTIN_DECL
#define TARGET_BUILTIN_DECL   msp430_builtin_decl

void
msp430_expand_prologue (void)
{
  int i, j;
  int fs;
  /* Always use stack_pointer_rtx instead of calling
     rtx_gen_REG ourselves.  Code elsewhere in GCC assumes
     that there is a single rtx representing the stack pointer,
     namely stack_pointer_rtx, and uses == to recognize it.  */
  rtx sp = stack_pointer_rtx;
  rtx p;

  if (is_naked_func ())
    {
      /* We must generate some RTX as thread_prologue_and_epilogue_insns()
	 examines the output of the gen_prologue() function.  */
      emit_insn (gen_rtx_CLOBBER (VOIDmode, GEN_INT (0)));
      return;
    }

  emit_insn (gen_prologue_start_marker ());

  if (is_critical_func ())
    {
      emit_insn (gen_push_intr_state ());
      emit_insn (gen_disable_interrupts ());
    }
  else if (is_reentrant_func ())
    emit_insn (gen_disable_interrupts ());

  if (!cfun->machine->computed)
    msp430_compute_frame_info ();

  if (flag_stack_usage_info)
    current_function_static_stack_size = cfun->machine->framesize;

  if (crtl->args.pretend_args_size)
    {
      rtx note;

      gcc_assert (crtl->args.pretend_args_size == 2);

      p = emit_insn (gen_grow_and_swap ());

      /* Document the stack decrement...  */
      note = F (gen_rtx_SET (stack_pointer_rtx,
			     gen_rtx_MINUS (Pmode, stack_pointer_rtx, GEN_INT (2))));
      add_reg_note (p, REG_FRAME_RELATED_EXPR, note);

      /* ...and the establishment of a new location for the return address.  */
      note = F (gen_rtx_SET (gen_rtx_MEM (Pmode,
					  gen_rtx_PLUS (Pmode,
							stack_pointer_rtx,
							GEN_INT (-2))),
			     pc_rtx));
      add_reg_note (p, REG_CFA_OFFSET, note);
      F (p);
    }

  for (i = 15; i >= 4; i--)
    if (cfun->machine->need_to_save [i])
      {
	/* We need to save COUNT sequential registers starting from regnum
	   I.  */
	int seq, count;
	rtx note;

	for (seq = i - 1; seq >= 4 && cfun->machine->need_to_save[seq]; seq --)
	  ;
	count = i - seq;

	if (msp430x)
	  {
	    /* Note: with TARGET_LARGE we still use PUSHM as PUSHX.A is two bytes bigger.  */
	    p = F (emit_insn (gen_pushm (gen_rtx_REG (Pmode, i),
					 GEN_INT (count))));

	    /* Document the stack decrement as a result of PUSHM.  */
	    note = gen_rtx_SEQUENCE (VOIDmode, rtvec_alloc (count + 1));

	    XVECEXP (note, 0, 0)
	      = F (gen_rtx_SET (stack_pointer_rtx,
				gen_rtx_PLUS (Pmode,
					      stack_pointer_rtx,
					      GEN_INT (count * (TARGET_LARGE ? -4 : -2)))));

	    /* *sp-- = R[i-j] */
	    /* sp+N	R10
	       ...
	       sp	R4  */
	    for (j = 0; j < count; j ++)
	      {
		rtx addr;
		int ofs = (count - j - 1) * (TARGET_LARGE ? 4 : 2);

		if (ofs)
		  addr = gen_rtx_PLUS (Pmode, sp, GEN_INT (ofs));
		else
		  addr = stack_pointer_rtx;

		XVECEXP (note, 0, j + 1) =
		  F (gen_rtx_SET (gen_rtx_MEM (Pmode, addr),
				  gen_rtx_REG (Pmode, i - j)) );
	      }

	    add_reg_note (p, REG_FRAME_RELATED_EXPR, note);
	    i -= count - 1;
	  }
	else
	  F (emit_insn (gen_push (gen_rtx_REG (Pmode, i))));
      }

  if (frame_pointer_needed)
    F (emit_move_insn (gen_rtx_REG (Pmode, FRAME_POINTER_REGNUM), sp));

  fs = cfun->machine->framesize_locals + cfun->machine->framesize_outgoing;

  increment_stack (- fs);

  emit_insn (gen_prologue_end_marker ());
}

void
msp430_expand_epilogue (int is_eh)
{
  int i, j;
  int fs;
  rtx sp = stack_pointer_rtx;
  rtx p;
  int helper_n = 0;

  if (is_naked_func ())
    {
      /* We must generate some RTX as thread_prologue_and_epilogue_insns()
	 examines the output of the gen_epilogue() function.  */
      emit_insn (gen_rtx_CLOBBER (VOIDmode, GEN_INT (0)));
      return;
    }

  if (cfun->machine->need_to_save [10])
    {
      /* Check for a helper function.  */
      helper_n = 7; /* For when the loop below never sees a match.  */
      for (i = 9; i >= 4; i--)
	if (!cfun->machine->need_to_save [i])
	  {
	    helper_n = 10 - i;
	    for (; i >= 4; i--)
	      if (cfun->machine->need_to_save [i])
		{
		  helper_n = 0;
		  break;
		}
	    break;
	  }
    }

  emit_insn (gen_epilogue_start_marker ());

  if (cfun->decl && strcmp (IDENTIFIER_POINTER (DECL_NAME (cfun->decl)), "main") == 0)
    emit_insn (gen_msp430_refsym_need_exit ());

  if (is_wakeup_func ())
    /* Clear the SCG1, SCG0, OSCOFF and CPUOFF bits in the saved copy of the
       status register current residing on the stack.  When this function
       executes its RETI instruction the SR will be updated with this saved
       value, thus ensuring that the processor is woken up from any low power
       state in which it may be residing.  */
    emit_insn (gen_bic_SR (GEN_INT (0xf0)));

  fs = cfun->machine->framesize_locals + cfun->machine->framesize_outgoing;

  increment_stack (fs);

  if (is_eh)
    {
      /* We need to add the right "SP" register save just after the
	 regular ones, so that when we pop it off we're in the EH
	 return frame, not this one.  This overwrites our own return
	 address, but we're not going to be returning anyway.  */
      rtx r12 = gen_rtx_REG (Pmode, 12);
      rtx (*addPmode)(rtx, rtx, rtx) = TARGET_LARGE ? gen_addpsi3 : gen_addhi3;

      /* R12 will hold the new SP.  */
      i = cfun->machine->framesize_regs;
      emit_move_insn (r12, stack_pointer_rtx);
      emit_insn (addPmode (r12, r12, EH_RETURN_STACKADJ_RTX));
      emit_insn (addPmode (r12, r12, GEN_INT (i)));
      emit_move_insn (gen_rtx_MEM (Pmode, plus_constant (Pmode, stack_pointer_rtx, i)), r12);
    }

  for (i = 4; i <= 15; i++)
    if (cfun->machine->need_to_save [i])
      {
	/* We need to restore COUNT sequential registers starting from regnum
	   I.  */
	int seq;
	int count = 1;
	int helper_used = 0;
	rtx note;

	if (msp430x)
	  {
	    for (seq = i + 1; seq <= 15 && cfun->machine->need_to_save[seq]; seq ++)
	      ;
	    count = seq - i;
	  }

	if (msp430x)
	  {
	    /* Note: With TARGET_LARGE we still use
	       POPM as POPX.A is two bytes bigger.  */
	    p = F (emit_insn (gen_popm (stack_pointer_rtx, GEN_INT (seq - 1),
					GEN_INT (count))));
	  }
	else if (i == 11 - helper_n
		 && ! msp430_is_interrupt_func ()
		 && ! is_reentrant_func ()
		 && ! is_critical_func ()
		 && crtl->args.pretend_args_size == 0
		 /* Calling the helper takes as many bytes as the POP;RET sequence.  */
		 && helper_n > 1
		 && !is_eh)
	  {
	    p = F (emit_jump_insn (gen_epilogue_helper (GEN_INT (helper_n))));
	    count = helper_n;
	    helper_used = 1;
	  }
	else
	  p = F (emit_insn (gen_pop (gen_rtx_REG (Pmode, i))));

	/* Document the stack increment as a result of POPM.  */
	note = gen_rtx_SEQUENCE (VOIDmode, rtvec_alloc (count + 1));

	XVECEXP (note, 0, 0)
	  = F (gen_rtx_SET (stack_pointer_rtx,
			    gen_rtx_PLUS (Pmode,
					  stack_pointer_rtx,
					  GEN_INT (count * (TARGET_LARGE ? 4 : 2)))));

	/* *sp++ = R[i+j] */
	/* sp	R4
	   ...
	   sp+N	R10  */
	for (j = 0; j < count; j ++)
	  {
	    rtx addr;
	    int ofs = j * (TARGET_LARGE ? 4 : 2);

	    if (ofs)
	      addr = gen_rtx_PLUS (Pmode, sp, GEN_INT (ofs));
	    else
	      addr = stack_pointer_rtx;

	    XVECEXP (note, 0, j + 1) =
	      F (gen_rtx_SET (gen_rtx_MEM (Pmode, addr),
			      gen_rtx_REG (Pmode, i + j)) );
	  }
	add_reg_note (p, REG_FRAME_RELATED_EXPR, note);
	i += count - 1;

	if (helper_used)
	  return;
      }

  if (is_eh)
    {
      /* Also pop SP, which puts us into the EH return frame.  Except
	 that you can't "pop" sp, you have to just load it off the
	 stack.  */
      emit_move_insn (stack_pointer_rtx, gen_rtx_MEM (Pmode, stack_pointer_rtx));
    }

  if (crtl->args.pretend_args_size)
    emit_insn (gen_swap_and_shrink ());

  if (is_critical_func ())
    emit_insn (gen_pop_intr_state ());
  else if (is_reentrant_func ())
    emit_insn (gen_enable_interrupts ());

  emit_jump_insn (gen_msp430_return ());
}

/* Implements EH_RETURN_STACKADJ_RTX.  Saved and used later in
   m32c_emit_eh_epilogue.  */
rtx
msp430_eh_return_stackadj_rtx (void)
{
  if (!cfun->machine->eh_stack_adjust)
    {
      rtx sa;

      sa = gen_rtx_REG (Pmode, 15);
      cfun->machine->eh_stack_adjust = sa;
    }
  return cfun->machine->eh_stack_adjust;
}

/* This function is called before reload, to "fix" the stack in
   preparation for an EH return.  */
void
msp430_expand_eh_return (rtx eh_handler)
{
  /* These are all Pmode */
  rtx ap, sa, ra, tmp;

  ap = arg_pointer_rtx;
  sa = msp430_eh_return_stackadj_rtx ();
  ra = eh_handler;

  tmp = ap;
  tmp = gen_rtx_PLUS (Pmode, ap, sa);
  tmp = plus_constant (Pmode, tmp, TARGET_LARGE ? -4 : -2);
  tmp = gen_rtx_MEM (Pmode, tmp);
  emit_move_insn (tmp, ra);
}

#undef  TARGET_INIT_DWARF_REG_SIZES_EXTRA
#define TARGET_INIT_DWARF_REG_SIZES_EXTRA msp430_init_dwarf_reg_sizes_extra
void
msp430_init_dwarf_reg_sizes_extra (tree address)
{
  int i;
  rtx addr = expand_normal (address);
  rtx mem = gen_rtx_MEM (BLKmode, addr);

  /* This needs to match msp430_unwind_word_mode (above).  */
  if (!msp430x)
    return;

  for (i = 0; i < FIRST_PSEUDO_REGISTER; i++)
    {
      unsigned int dnum = DWARF_FRAME_REGNUM (i);
      unsigned int rnum = DWARF2_FRAME_REG_OUT (dnum, 1);

      if (rnum < DWARF_FRAME_REGISTERS)
	{
	  HOST_WIDE_INT offset = rnum * GET_MODE_SIZE (QImode);

	  emit_move_insn (adjust_address (mem, QImode, offset),
			  gen_int_mode (4, QImode));
	}
    }
}

/* The MSP430 ABI defines a number of helper functions that should be
   used for, for example, 32-bit shifts.  This function is called to
   emit such a function, using the table above to optimize some
   cases.  */
void
msp430_expand_helper (rtx *operands, const char *helper_name, bool const_variants)
{
  rtx c, fusage, fsym;
  char *helper_const = NULL;
  int arg1 = 12;
  int arg2 = 13;
  int arg1sz = 1;
  machine_mode arg0mode = GET_MODE (operands[0]);
  machine_mode arg1mode = GET_MODE (operands[1]);
  machine_mode arg2mode = GET_MODE (operands[2]);
  int expand_mpy = strncmp (helper_name, "__mspabi_mpy",
			    sizeof("__mspabi_mpy") - 1) == 0;
  /* This function has been used incorrectly if CONST_VARIANTS is TRUE for a
     hwmpy function.  */
  gcc_assert (!(expand_mpy && const_variants));

  if (arg1mode != VOIDmode && arg2mode != VOIDmode)
    /* Modes of arguments must be equal if not constants.  */
    gcc_assert (arg1mode == arg2mode);

  if (arg1mode == VOIDmode)
    arg1mode = arg0mode;
  if (arg2mode == VOIDmode)
    arg2mode = arg0mode;

  if (arg1mode == SImode)
    {
      arg2 = 14;
      arg1sz = 2;
    }
  else if (arg1mode == DImode)
    {
      arg1 = 8;
      arg1sz = 4;
      arg2 = 12;
    }

  /* Use the "const_variant" of a shift library function if requested.
     These are faster, but have larger code size.  */
  if (const_variants
      && CONST_INT_P (operands[2])
      && INTVAL (operands[2]) >= 1
      && INTVAL (operands[2]) <= 15)
    {
      /* Note that the INTVAL is limited in value and length by the conditional above.  */
      int len = strlen (helper_name) + 4;
      helper_const = (char *) xmalloc (len);
      snprintf (helper_const, len, "%s_%d", helper_name, (int) INTVAL (operands[2]));
    }

  /* Setup the arguments to the helper function.  */
  emit_move_insn (gen_rtx_REG (arg1mode, arg1),
		  operands[1]);
  if (!helper_const)
    emit_move_insn (gen_rtx_REG (arg2mode, arg2),
		    operands[2]);

  /* We could be lazy and just always emit HELPER_NAME without any specific
     suffix, and thanks to the way the hardware multiply library is laid out,
     it will always result in the desired library function being called.
     i.e. if f5 hardware multiply is enabled then "__mspabi_mpysl" will point
     to the f5 version, but if hardware multiply support is disabled then the
     same function name will point to the software implementation.  */
  if (expand_mpy)
    {
      if (msp430_use_f5_series_hwmult ())
	fsym = gen_rtx_SYMBOL_REF (VOIDmode, concat (helper_name,
						      "_f5hw", NULL));
      else if (use_32bit_hwmult ())
	{
	  /* When the arguments are 16-bits, the 16-bit hardware multiplier is
	     used.  */
	  if (arg1mode == HImode)
	    fsym = gen_rtx_SYMBOL_REF (VOIDmode, concat (helper_name,
							  "_hw", NULL));
	  else
	    fsym = gen_rtx_SYMBOL_REF (VOIDmode, concat (helper_name,
							  "_hw32", NULL));
	}
      /* 16-bit hardware multiply.  */
      else if (msp430_has_hwmult ())
	fsym = gen_rtx_SYMBOL_REF (VOIDmode, concat (helper_name,
						      "_hw", NULL));
      else
	fsym = gen_rtx_SYMBOL_REF (VOIDmode, helper_name);
    }
  else
    fsym = gen_rtx_SYMBOL_REF (VOIDmode,
			       helper_const ? helper_const : helper_name);

  c = gen_call_value_internal (gen_rtx_REG (arg0mode, 12), fsym, GEN_INT (0));

  c = emit_call_insn (c);
  RTL_CONST_CALL_P (c) = 1;

  /* Add register usage information for the arguments to the call.  */
  fusage = NULL;
  use_regs (&fusage, arg1, arg1sz);
  if (!helper_const)
    {
      /* If we are expanding a shift, we only need to use the low register
	 for the shift amount. */
      if (!expand_mpy)
	use_regs (&fusage, arg2, 1);
      else
	use_regs (&fusage, arg2, arg1sz);
    }
  add_function_usage_to (c, fusage);

  emit_move_insn (operands[0],
		  /* Return value will always start in R12.  */
		  gen_rtx_REG (arg0mode, 12));
}

/* Return 1 if the helper function should be used. 0 if the shifts insns
   should be emitted inline.  */
static bool
use_helper_for_const_shift (enum rtx_code code, machine_mode mode, HOST_WIDE_INT amt)
{
  const int default_inline_shift = 4;
  /* We initialize the option to 65 so we know if the user set it or not.  */
  int user_set_max_inline = (msp430_max_inline_shift == 65 ? 0 : 1);
  int max_inline = (user_set_max_inline ? msp430_max_inline_shift : default_inline_shift);
  /* 32-bit shifts are roughly twice as costly as 16-bit shifts so we adjust
     the heuristic accordingly.  */
  int max_inline_32 = max_inline / 2;

  /* Never use helpers for these modes on 430X, or when optimizing for speed, or
     when we are emitting a small number of insns.  */
  if ((mode == E_QImode || mode == E_HImode || mode == E_PSImode)
      && (msp430x
	  /* If the user set max_inline then we always obey that number.
	     Otherwise we always emit the shifts inline at -O2 and above.  */
	  || amt <= max_inline
	  || (!user_set_max_inline
	      && (optimize >= 2 && !optimize_size))))
    return false;

  /* 430 and 430X codegen for SImode shifts is the same.  */
  if (mode == E_SImode
      && (amt <= max_inline_32
	  || (!user_set_max_inline
	      && (optimize >= 2 && !optimize_size))))
    return false;

  return true;
}

/* Return 1 to indicate we have finished with this insn and invoke "DONE".
   Otherwise return 0 to indicate the insn should fallthrough.
   Never FAIL.  */
int
msp430_expand_shift (enum rtx_code code, machine_mode mode, rtx *operands)
{
  /* Always use the helper function when the shift amount is not a
     constant.  */
  if (!CONST_INT_P (operands[2])
      || mode == E_DImode
      || use_helper_for_const_shift (code, mode, INTVAL (operands[2])))
    {
      const char *helper_name;
      /* The const variants of mspabi shifts have significantly larger code
	 size than the generic version, so use the generic version if
	 optimizing for size.  */
      bool const_variant = !optimize_size;
      switch (mode)
	{
	case E_HImode:
	  helper_name = (code == ASHIFT ? "__mspabi_slli" :
			 (code == ASHIFTRT ? "__mspabi_srai" :
			  (code == LSHIFTRT ? "__mspabi_srli" :
			   NULL)));
	  break;
	case E_PSImode:
	  helper_name = (code == ASHIFT ? "__gnu_mspabi_sllp" :
			 (code == ASHIFTRT ? "__gnu_mspabi_srap" :
			  (code == LSHIFTRT ? "__gnu_mspabi_srlp" :
			   NULL)));
	  /* No const variant for PSImode shifts FIXME.  */
	  const_variant = false;
	  break;
	case E_SImode:
	  helper_name = (code == ASHIFT ? "__mspabi_slll" :
			 (code == ASHIFTRT ? "__mspabi_sral" :
			  (code == LSHIFTRT ? "__mspabi_srll" :
			   NULL)));
	  break;
	case E_DImode:
	  helper_name = (code == ASHIFT ? "__mspabi_sllll" :
			 (code == ASHIFTRT ? "__mspabi_srall" :
			  (code == LSHIFTRT ? "__mspabi_srlll" :
			   NULL)));
	  /* No const variant for DImode shifts.  */
	  const_variant = false;
	  break;
	default:
	  gcc_unreachable ();
	  break;
	}
      gcc_assert (helper_name);
      msp430_expand_helper (operands, helper_name, const_variant);
      return 1;
    }
  /* If we return 0, need to be sure that there is an insn to match the RTL
     pattern otherwise we will have an unrecognizeable insn.  */
  return 0;
}

/* For 430 we output copies of identical inline shifts for all modes.
 * For 430X it is inneficient to do so for any modes except SI and DI, since we
 * can make use of R*M insns or RPT with 430X insns.  */
const char *
msp430_output_asm_shift_insns (enum rtx_code code, machine_mode mode, rtx *operands)
{
  int i;
  int amt = INTVAL (operands[2]);
  int max_shift = GET_MODE_BITSIZE (mode) - 1;

  if (amt == 0 || amt > max_shift)
    {
      /* FIXME it would be neater to use snprintf into a buffer for the
         variable part of the string.  */
      switch (code)
	{
	case ASHIFT:
	  output_asm_insn ("# ignored undefined behaviour left shift "
			   "of %1 by %2", operands);
	  break;
	case ASHIFTRT:
	  output_asm_insn ("# ignored undefined behaviour arithmetic right "
			   "shift of %1 by %2", operands);
	  break;
	case LSHIFTRT:
	  output_asm_insn ("# ignored undefined behaviour logical right shift "
			   "of %1 by %2", operands);
	  break;
	default:
	  gcc_unreachable ();
	}
      return "";
    }


  /* FIXME list How costly are all these insns in terms of cycles and code size/????? */
  if (code == ASHIFT)
    {
      if (!msp430x && mode == HImode)
	for (i = 0; i < amt; i++)
	  output_asm_insn ("RLA.W\t%0", operands);
      else if (mode == SImode)
	for (i = 0; i < amt; i++)
	  output_asm_insn ("RLA%X0.W\t%L0 { RLC%X0.W\t%H0", operands);
      else
	/* Catch unhandled cases.  */
	gcc_unreachable ();
    }
  else if (code == ASHIFTRT)
    {
      if (!msp430x && mode == HImode)
	for (i = 0; i < amt; i++)
	  output_asm_insn ("RRA.W\t%0", operands);
      else if (mode == SImode)
	for (i = 0; i < amt; i++)
	  output_asm_insn ("RRA%X0.W\t%H0 { RRC%X0.W\t%L0", operands);
      else
	gcc_unreachable ();
    }
  else if (code == LSHIFTRT)
    {
      if (!msp430x && mode == HImode)
	for (i = 0; i < amt; i++)
	  output_asm_insn ("CLRC { RRC.W\t%0", operands);
      /* FIXME: Why doesn't "RRUX.W\t%H0 { RRC%X0.W\t%L0" work for msp430x??
	 It causes execution timeouts e.g. pr41963.c.  */
      else if (mode == SImode)
	for (i = 0; i < amt; i++)
	  output_asm_insn ("CLRC { RRC%X0.W\t%H0 { RRC%X0.W\t%L0", operands);
#if 0
      else if (msp430x && mode == SImode)
	for (i = 0; i < amt; i++)
	  output_asm_insn ("RRUX.W\t%H0 { RRC%X0.W\t%L0", operands);
#endif
      else
	gcc_unreachable ();
    }
  return "";
}

/* Called by cbranch<mode>4 to coerce operands into usable forms.  */
void
msp430_fixup_compare_operands (machine_mode my_mode, rtx * operands)
{
  /* constants we're looking for, not constants which are allowed.  */
  int const_op_idx = 1;

  if (msp430_reversible_cmp_operator (operands[0], VOIDmode))
    const_op_idx = 2;

  if (GET_CODE (operands[const_op_idx]) != REG
      && GET_CODE (operands[const_op_idx]) != MEM)
    operands[const_op_idx] = copy_to_mode_reg (my_mode, operands[const_op_idx]);
}

/* Simplify_gen_subreg() doesn't handle memory references the way we
   need it to below, so we use this function for when we must get a
   valid subreg in a "natural" state.  */
rtx
msp430_subreg (machine_mode mode, rtx r, machine_mode omode, int byte)
{
  rtx rv;
  gcc_assert (mode == HImode);

  if (GET_CODE (r) == SUBREG
      && SUBREG_BYTE (r) == 0)
    {
      rtx ireg = SUBREG_REG (r);
      machine_mode imode = GET_MODE (ireg);

      /* special case for (HI (SI (PSI ...), 0)) */
      if (imode == PSImode
	  && mode == HImode
	  && byte == 0)
	rv = gen_rtx_SUBREG (mode, ireg, byte);
      else
	rv = simplify_gen_subreg (mode, ireg, imode, byte);
    }
  else if (GET_CODE (r) == MEM)
    {
      /* When byte == 2, we can be certain that we were already called with an
         identical rtx with byte == 0.  So we don't need to do anything to
         get a 2 byte offset of a (mem (post_inc)) rtx, since the address has
         already been offset by the post_inc itself.  */
      if (GET_CODE (XEXP (r, 0)) == POST_INC && byte == 2)
	byte = 0;
      rv = adjust_address (r, mode, byte);
    }
  else if (GET_CODE (r) == SYMBOL_REF
	   && (byte == 0 || byte == 2)
	   && mode == HImode)
    {
      rv = gen_rtx_ZERO_EXTRACT (HImode, r, GEN_INT (16), GEN_INT (8*byte));
      rv = gen_rtx_CONST (HImode, r);
    }
  else
    rv = simplify_gen_subreg (mode, r, omode, byte);

  if (!rv)
    gcc_unreachable ();

  return rv;
}

int
msp430_split_addsi (rtx *operands)
{
  operands[3] = msp430_subreg (HImode, operands[0], SImode, 0);
  operands[4] = msp430_subreg (HImode, operands[1], SImode, 0);
  operands[5] = msp430_subreg (HImode, operands[2], SImode, 0);
  operands[6] = msp430_subreg (HImode, operands[0], SImode, 2);
  operands[7] = msp430_subreg (HImode, operands[1], SImode, 2);
  operands[8] = msp430_subreg (HImode, operands[2], SImode, 2);

  /* BZ 64160: Do not use this splitter when the dest partially overlaps the source.  */
  if (reg_overlap_mentioned_p (operands[3], operands[7])
      || reg_overlap_mentioned_p (operands[3], operands[8]))
    return 1;

  if (GET_CODE (operands[5]) == CONST_INT)
    operands[9] = GEN_INT (INTVAL (operands[5]) & 0xffff);
  /* Handle post_inc, for example:
     (set (reg:SI)
	  (plus:SI (reg:SI)
		   (mem:SI (post_inc:PSI (reg:PSI))))).  */
  else if (MEM_P (operands[5]) && GET_CODE (XEXP (operands[5], 0)) == POST_INC)
    {
      /* Strip out the post_inc from (mem (post_inc (reg))).  */
      operands[9] = XEXP (XEXP (operands[5], 0), 0);
      operands[9] = gen_rtx_MEM (HImode, operands[9]);
      /* Then zero extend as normal.  */
      operands[9] = gen_rtx_ZERO_EXTEND (SImode, operands[9]);
    }
  else
    operands[9] = gen_rtx_ZERO_EXTEND (SImode, operands[5]);
  return 0;
}

/* Called by movsi_x to generate the HImode operands.  */
void
msp430_split_movsi (rtx *operands)
{
  rtx op00, op02, op10, op12;

  op00 = msp430_subreg (HImode, operands[0], SImode, 0);
  op02 = msp430_subreg (HImode, operands[0], SImode, 2);

  if (GET_CODE (operands[1]) == CONST
      || GET_CODE (operands[1]) == SYMBOL_REF)
    {
      op10 = gen_rtx_ZERO_EXTRACT (HImode, operands[1], GEN_INT (16), GEN_INT (0));
      op10 = gen_rtx_CONST (HImode, op10);
      op12 = gen_rtx_ZERO_EXTRACT (HImode, operands[1], GEN_INT (16), GEN_INT (16));
      op12 = gen_rtx_CONST (HImode, op12);
    }
  else
    {
      op10 = msp430_subreg (HImode, operands[1], SImode, 0);
      op12 = msp430_subreg (HImode, operands[1], SImode, 2);
    }

  if (rtx_equal_p (operands[0], operands[1]))
    {
      operands[2] = op02;
      operands[4] = op12;
      operands[3] = op00;
      operands[5] = op10;
    }
  else if (rtx_equal_p (op00, op12)
	   /* Catch the case where we are loading (rN, rN+1) from mem (rN).  */
	   || (REG_P (op00) && reg_mentioned_p (op00, op10))
	   /* Or storing (rN) into mem (rN).  */
	   || (REG_P (op10) && reg_mentioned_p (op10, op00))
	   )
    {
      operands[2] = op02;
      operands[4] = op12;
      operands[3] = op00;
      operands[5] = op10;
    }
  else
    {
      operands[2] = op00;
      operands[4] = op10;
      operands[3] = op02;
      operands[5] = op12;
    }
}


/* The MSPABI specifies the names of various helper functions, many of
   which are compatible with GCC's helpers.  This table maps the GCC
   name to the MSPABI name.  */
static const struct
{
  char const * const gcc_name;
  char const * const ti_name;
}
  helper_function_name_mappings [] =
{
  /* Floating point to/from integer conversions.  */
  { "__truncdfsf2", "__mspabi_cvtdf" },
  { "__extendsfdf2", "__mspabi_cvtfd" },
  { "__fixdfhi", "__mspabi_fixdi" },
  { "__fixdfsi", "__mspabi_fixdli" },
  { "__fixdfdi", "__mspabi_fixdlli" },
  { "__fixunsdfhi", "__mspabi_fixdu" },
  { "__fixunsdfsi", "__mspabi_fixdul" },
  { "__fixunsdfdi", "__mspabi_fixdull" },
  { "__fixsfhi", "__mspabi_fixfi" },
  { "__fixsfsi", "__mspabi_fixfli" },
  { "__fixsfdi", "__mspabi_fixflli" },
  { "__fixunsfhi", "__mspabi_fixfu" },
  { "__fixunsfsi", "__mspabi_fixful" },
  { "__fixunsfdi", "__mspabi_fixfull" },
  { "__floathisf", "__mspabi_fltif" },
  { "__floatsisf", "__mspabi_fltlif" },
  { "__floatdisf", "__mspabi_fltllif" },
  { "__floathidf", "__mspabi_fltid" },
  { "__floatsidf", "__mspabi_fltlid" },
  { "__floatdidf", "__mspabi_fltllid" },
  { "__floatunhisf", "__mspabi_fltuf" },
  { "__floatunsisf", "__mspabi_fltulf" },
  { "__floatundisf", "__mspabi_fltullf" },
  { "__floatunhidf", "__mspabi_fltud" },
  { "__floatunsidf", "__mspabi_fltuld" },
  { "__floatundidf", "__mspabi_fltulld" },

  /* Floating point comparisons.  */
  /* GCC uses individual functions for each comparison, TI uses one
     compare <=> function.  */

  /* Floating point arithmatic */
  { "__adddf3", "__mspabi_addd" },
  { "__addsf3", "__mspabi_addf" },
  { "__divdf3", "__mspabi_divd" },
  { "__divsf3", "__mspabi_divf" },
  { "__muldf3", "__mspabi_mpyd" },
  { "__mulsf3", "__mspabi_mpyf" },
  { "__subdf3", "__mspabi_subd" },
  { "__subsf3", "__mspabi_subf" },
  /* GCC does not use helper functions for negation */

  /* Integer multiply, divide, remainder.  */
  { "__mulhi3", "__mspabi_mpyi" },
  { "__mulsi3", "__mspabi_mpyl" },
  { "__muldi3", "__mspabi_mpyll" },
#if 0
  /* These libgcc widening multiplication functions don't exist yet; we catch
     them in RTL instead.  */
  /* Clarify signed vs unsigned first.  */
  { "__mulhisi3", "__mspabi_mpysl" },
  { "__mulsidi3", "__mspabi_mpysll" },
#endif

  { "__divhi3", "__mspabi_divi" },
  { "__divsi3", "__mspabi_divli" },
  { "__divdi3", "__mspabi_divlli" },
  { "__udivhi3", "__mspabi_divu" },
  { "__udivsi3", "__mspabi_divul" },
  { "__udivdi3", "__mspabi_divull" },
  { "__modhi3", "__mspabi_remi" },
  { "__modsi3", "__mspabi_remli" },
  { "__moddi3", "__mspabi_remlli" },
  { "__umodhi3", "__mspabi_remu" },
  { "__umodsi3", "__mspabi_remul" },
  { "__umoddi3", "__mspabi_remull" },

  /* Bitwise operations.  */
  /* Rotation - no rotation support yet.  */
  /* Logical left shift - gcc already does these itself.  */
  /* Arithmetic left shift - gcc already does these itself.  */
  /* Arithmetic right shift - gcc already does these itself.  */

  { NULL, NULL }
};

/* Returns true if the current MCU supports an F5xxx series
   hardware multiper.  */

bool
msp430_use_f5_series_hwmult (void)
{
  static const char * cached_match = NULL;
  static bool         cached_result;

  if (msp430_hwmult_type == MSP430_HWMULT_F5SERIES)
    return true;

  if (target_mcu == NULL || msp430_hwmult_type != MSP430_HWMULT_AUTO)
    return false;

  if (target_mcu == cached_match)
    return cached_result;

  cached_match = target_mcu;

  if (strncasecmp (target_mcu, "msp430f5", 8) == 0)
    return cached_result = true;
  if (strncasecmp (target_mcu, "msp430fr5", 9) == 0)
    return cached_result = true;
  if (strncasecmp (target_mcu, "msp430f6", 8) == 0)
    return cached_result = true;

  msp430_extract_mcu_data (target_mcu, false);

  if (extracted_mcu_data.name != NULL)
    return cached_result = extracted_mcu_data.hwmpy == 8;

  return cached_result = false;
}

/* Returns true if the current MCU has a second generation
   32-bit hardware multiplier.  */

static bool
use_32bit_hwmult (void)
{
  static const char * cached_match = NULL;
  static bool         cached_result;

  if (msp430_hwmult_type == MSP430_HWMULT_LARGE)
    return true;

  if (target_mcu == NULL || msp430_hwmult_type != MSP430_HWMULT_AUTO)
    return false;

  if (target_mcu == cached_match)
    return cached_result;

  cached_match = target_mcu;

  msp430_extract_mcu_data (target_mcu, false);
  if (extracted_mcu_data.name != NULL)
    return cached_result = extracted_mcu_data.hwmpy == 4;

  return cached_result = false;
}

/* Returns true if the current MCU does not have a
   hardware multiplier of any kind.  */

bool
msp430_has_hwmult (void)
{
  static const char * cached_match = NULL;
  static bool         cached_result;

  if (msp430_hwmult_type == MSP430_HWMULT_NONE)
    return false;

  /* TRUE for any other explicit hwmult specified.  */
  if (msp430_hwmult_type != MSP430_HWMULT_AUTO)
    return true;

  /* Now handle -mhwmult=auto.  */
  if (target_mcu == NULL)
    return false;

  if (target_mcu == cached_match)
    return cached_result;

  cached_match = target_mcu;

  msp430_extract_mcu_data (target_mcu, false);
  if (extracted_mcu_data.name != NULL)
    return cached_result = extracted_mcu_data.hwmpy != 0;

  /* If we do not recognise the MCU name, we assume that it does not support
     any kind of hardware multiply - this is the safest assumption to make.  */
  return cached_result = false;
}

/* This function does the same as the default, but it will replace GCC
   function names with the MSPABI-specified ones.  */

void
msp430_output_labelref (FILE *file, const char *name)
{
  int i;

  for (i = 0; helper_function_name_mappings [i].gcc_name; i++)
    if (strcmp (helper_function_name_mappings [i].gcc_name, name) == 0)
      {
	name = helper_function_name_mappings [i].ti_name;
	break;
      }

  /* If we have been given a specific MCU name then we may be
     able to make use of its hardware multiply capabilities.  */
  /* FIXME: This bit doesn't seem to make sense/is unnecessary. If hardware
     multiply support is enabled, all the below helper function names (for the
     same comparable operation) will point to the same library function.  */
  if (msp430_has_hwmult ())
    {
      if (strcmp ("__mspabi_mpyi", name) == 0)
	{
	  if (msp430_use_f5_series_hwmult ())
	    name = "__mulhi2_f5";
	  else
	    name = "__mulhi2";
	}
      else if (strcmp ("__mspabi_mpyl", name) == 0)
	{
	  if (msp430_use_f5_series_hwmult ())
	    name = "__mulsi2_f5";
	  else if (use_32bit_hwmult ())
	    name = "__mulsi2_hw32";
	  else
	    name = "__mulsi2";
	}
    }

  if (user_label_prefix[0] != 0)
    fputs (user_label_prefix, file);

  fputs (name, file);
}

/* Common code for msp430_print_operand...  */

static void
msp430_print_operand_raw (FILE * file, rtx op)
{
  HOST_WIDE_INT i;

  switch (GET_CODE (op))
    {
    case REG:
      fprintf (file, "%s", reg_names [REGNO (op)]);
      break;

    case CONST_INT:
      i = INTVAL (op);
      if (TARGET_ASM_HEX)
	fprintf (file, "%#" HOST_WIDE_INT_PRINT "x", i);
      else
	fprintf (file, "%" HOST_WIDE_INT_PRINT "d", i);
      break;

    case CONST:
    case PLUS:
    case MINUS:
    case SYMBOL_REF:
    case LABEL_REF:
      output_addr_const (file, op);
      break;

    default:
      print_rtl (file, op);
      break;
    }
}

#undef  TARGET_ASM_ALIGNED_PSI_OP
#define TARGET_ASM_ALIGNED_PSI_OP "\t.long\t"
#undef  TARGET_ASM_UNALIGNED_PSI_OP
#define TARGET_ASM_UNALIGNED_PSI_OP TARGET_ASM_ALIGNED_PSI_OP

#undef  TARGET_PRINT_OPERAND_ADDRESS
#define TARGET_PRINT_OPERAND_ADDRESS	msp430_print_operand_addr

/* Output to stdio stream FILE the assembler syntax for an
   instruction operand that is a memory reference whose address
   is ADDR.  */

static void
msp430_print_operand_addr (FILE * file, machine_mode /*mode*/, rtx addr)
{
  switch (GET_CODE (addr))
    {
    case PLUS:
      msp430_print_operand_raw (file, XEXP (addr, 1));
      gcc_assert (REG_P (XEXP (addr, 0)));
      fprintf (file, "(%s)", reg_names [REGNO (XEXP (addr, 0))]);
      return;

      /* TODO: If REG is the dst operand, syntax should be 0(REG).  */
    case REG:
      fprintf (file, "@");
      break;

    case POST_INC:
      fprintf (file, "@%s+", reg_names[REGNO (XEXP (addr, 0))]);
      return;

    case CONST:
    case CONST_INT:
    case SYMBOL_REF:
    case LABEL_REF:
      fprintf (file, "&");
      break;

    default:
      break;
    }

  msp430_print_operand_raw (file, addr);
}

/* We can only allow signed 15-bit indexes i.e. +/-32K.  */
static bool
msp430_check_index_not_high_mem (rtx op)
{
  if (CONST_INT_P (op)
      && IN_RANGE (INTVAL (op), HOST_WIDE_INT_M1U << 15, (1 << 15) - 1))
    return true;
  return false;
}

/* If this returns true, we don't need a 430X insn.  */
/* FIXME unless we check the symbol in the register we can't use a 430X insn,
   since the address could be in high mem.
   When worrying about safety we should consider the C code that is generating
   these insns. For example foo_arr+2(R12) will be some valid offset from
   foo_arr, not some crazy random address.  
   Indexed addressing:
   - If the register holds a 16-bit value, we can index from it with both a symbol_ref
     and an absolute value.
   - If the register holds a 20-bit value, we can only index it with an absolute value
     +/-32K. Addressing it with a symbol_ref could provide unexpected results.
   In indexed addressing mode, the resulting address must be 16-bits in a 430 insn,
   since the high bits will be truncated.  
 */
static bool
msp430_check_plus_not_high_mem (rtx op)
{
  if (GET_CODE (op) != PLUS)
    return false;
  rtx op0 = XEXP (op, 0);
  rtx op1 = XEXP (op, 1);
  if (SYMBOL_REF_P (op0)
      && (SYMBOL_REF_FLAGS (op0) & SYMBOL_FLAG_LOW_MEM)
      && msp430_check_index_not_high_mem (op1))
    return true;
#if 0
  /* FIXME: If we could verify the register does not contain the address of a
     variable that is in upper memory (e.g. by checking REG_EXPR to get the
     original decl), then we could allow these patterns in certain
     situations.  */
  /* (mem:HI (plus:PSI (reg:PSI 12 R12)
                (symbol_ref:PSI ("foo_arr")  */
  else if (REG_P (op0)
	   && SYMBOL_REF_P (op1)
	   && (SYMBOL_REF_FLAGS (op1) & SYMBOL_FLAG_LOW_MEM))
    return true;
  /* (mem:HI (plus:PSI (reg:PSI 12 R12)
                (const:PSI (plus:PSI (symbol_ref:PSI ("foo_arr") )
                        (const_int 2 [0x2])))) */
  else if (REG_P (op0)
	   && ((GET_CODE (op1) == CONST)
	       && msp430_check_plus_not_high_mem (XEXP (op1, 0))))
    return true;
#endif
  return false;
}

/* OK, bad name, but accurate. OP might not be a MEM, so it would be wrong to
   say "op in low mem", as OP might not be in memory at all.
   Hence, "op not in high mem".
   The Ys constraint will catch (mem(plus...) but we catch other cases here.  */
bool
msp430_op_not_in_high_mem (rtx op)
{
  rtx op0;

  if (!TARGET_LARGE || (GET_CODE (op) != MEM))
    return true;

  op0 = XEXP (op, 0);

  if (SYMBOL_REF_P (op0) &&
      (SYMBOL_REF_FLAGS (op0) & SYMBOL_FLAG_LOW_MEM))
    /* msp430_encode_section_info decided this data will be in lower
       memory.  */
    return true;

  /* Check possibilites for (mem (plus)).
     e.g. (mem (const (plus ((symbol_ref) (const_int))))) : &addr+2  */
  if (msp430_check_plus_not_high_mem (op0)
      || ((GET_CODE (op0) == CONST)
	  && msp430_check_plus_not_high_mem (XEXP (op0, 0))))
    return true;

  /* An absolute 16-bit address is allowed.  */
  if ((CONST_INT_P (op0) && (IN_RANGE (INTVAL (op0), 0, (1 << 16)-1))))
    return true;

  /* Return false when undecided, to indicate OP might be in high mem.  */
  return false;
}

/* Based on the operand OP, is a 430X insn required to handle it?
   There are only 3 conditions for which we require a 430X insn:
   - PSImode operand
   - memory reference to a symbol which could be in upper memory
     (so its address is > 0xFFFF)
   - absolute address which has VOIDmode, i.e. (mem:HI (const_int))
   We can use a 430 insn if neither of these conditions are true.  */
static bool
msp430x_insn_required (rtx op)
{
  return (GET_MODE (op) == PSImode
	  || !msp430_op_not_in_high_mem (op));
}

/* Convenience function for the .md file.  */
bool
msp430_430x_insn_not_required (rtx op1, rtx op2)
{
  return !(msp430x_insn_required (op1) || msp430x_insn_required (op2));
}

#undef  TARGET_PRINT_OPERAND
#define TARGET_PRINT_OPERAND		msp430_print_operand

/* A   low 16-bits of int/lower of register pair
   B   high 16-bits of int/higher of register pair
   C   bits 32-47 of a 64-bit value/reg 3 of a DImode value
   D   bits 48-63 of a 64-bit value/reg 4 of a DImode value
   H   like %B (for backwards compatibility)
   I   inverse of value
   J   an integer without a # prefix
   L   like %A (for backwards compatibility)
   O   offset of the top of the stack
   Q   like X but generates an A postfix
   R   inverse of condition code, unsigned.
   W   value - 16
   X   X instruction postfix in large mode
   Y   value - 4
   Z   value - 1
   b   .B or .W or .A, depending upon the mode
   d   bits 8-15 (2nd byte) of a memory reference or constant value
   e   bits 24-31 (4th byte) of a memory reference or constant value
   f   bits 40-47 (6th byte) of a memory reference or constant value
   g   bits 56-63 (8th byte) of a memory reference or constant value
   p   bit position
   r   inverse of condition code
   x   like X but only for pointers.  */

static void
msp430_print_operand (FILE * file, rtx op, int letter)
{
  rtx addr;
  int mem_off = 0;
  int reg_off = 0;
  int const_shift = 0;

  /* We can't use c, n, a, or l.  */
  switch (letter)
    {
    case 'Z':
      gcc_assert (CONST_INT_P (op));
      /* Print the constant value, less one.  */
      fprintf (file, "#%ld", INTVAL (op) - 1);
      return;
    case 'Y':
      gcc_assert (CONST_INT_P (op));
      /* Print the constant value, less four.  */
      fprintf (file, "#%ld", INTVAL (op) - 4);
      return;
    case 'W':
      gcc_assert (CONST_INT_P (op));
      /* Print the constant value, less 16.  */
      fprintf (file, "#%ld", INTVAL (op) - 16);
      return;
    case 'I':
      if (GET_CODE (op) == CONST_INT)
	{
	  /* Inverse of constants */
	  int i = INTVAL (op);
	  fprintf (file, "%d", ~i);
	  return;
	}
      op = XEXP (op, 0);
      break;
    case 'r': /* Conditional jump where the condition is reversed.  */
      switch (GET_CODE (op))
	{
	case EQ: fprintf (file, "NE"); break;
	case NE: fprintf (file, "EQ"); break;
	case GEU: fprintf (file, "LO"); break;
	case LTU: fprintf (file, "HS"); break;
	case GE: fprintf (file, "L"); break;
	case LT: fprintf (file, "GE"); break;
	  /* Assume these have reversed operands.  */
	case GTU: fprintf (file, "HS"); break;
	case LEU: fprintf (file, "LO"); break;
	case GT: fprintf (file, "GE"); break;
	case LE: fprintf (file, "L"); break;
	default:
	  msp430_print_operand_raw (file, op);
	  break;
	}
      return;
    case 'R': /* Conditional jump where the operands are reversed.  */
      switch (GET_CODE (op))
	{
	case GTU: fprintf (file, "LO"); break;
	case LEU: fprintf (file, "HS"); break;
	case GT: fprintf (file, "L"); break;
	case LE: fprintf (file, "GE"); break;
	default:
	  msp430_print_operand_raw (file, op);
	  break;
	}
      return;
    case 'p': /* Bit position. 0 == 0x01, 3 = 0x08 etc.  */
      gcc_assert (CONST_INT_P (op));
      fprintf (file, "#%d", 1 << INTVAL (op));
      return;
    case 'b':
      switch (GET_MODE (op))
	{
	case E_QImode: fprintf (file, ".B"); return;
	case E_HImode: fprintf (file, ".W"); return;
	case E_PSImode: fprintf (file, ".A"); return;
	case E_SImode: fprintf (file, ".A"); return;
	default:
	  return;
	}
    case 'd': case 'e': case 'f': case 'g':
      if (GET_CODE (op) == REG)
	{
	  output_operand_lossage ("%%d, %%e, %%f, %%g operand selectors are for "
				   "memory references or constant values only");
	  return;
	}
      /* fallthru */
    case 'A': case 'L': /* Low half.  */
    case 'B': case 'H': /* high half */
    case 'C':
    case 'D':
      if (letter == 'd')
	{
	  mem_off = 1;
	  const_shift = 8;
	}
      else if (letter == 'B' || letter == 'H')
	{
	  mem_off = 2;
	  reg_off = 1;
	  const_shift = 16;
	}
      else if (letter == 'e')
	{
	  mem_off = 3;
	  const_shift = 24;
	}
      else if (letter == 'C')
	{
	  mem_off = 4;
	  reg_off = 2;
	  const_shift = 32;
	}
      else if (letter == 'f')
	{
	  mem_off = 5;
	  const_shift = 40;
	}
      else if (letter == 'D')
	{
	  mem_off = 6;
	  reg_off = 3;
	  const_shift = 48;
	}
      else if (letter == 'g')
	{
	  mem_off = 7;
	  const_shift = 56;
	}
      switch (GET_CODE (op))
	{
	case MEM:
	  /* We don't need to adjust the address for post_inc.  */
	  op = adjust_address (op, Pmode,
			       (GET_CODE (XEXP (op, 0)) == POST_INC)
			       ? 0 : mem_off);
	  break;
	case REG:
	  op = gen_rtx_REG (Pmode, REGNO (op) + reg_off);
	  break;
	case CONST_INT:
	  /* I don't think the mask is necessary for low part.
	     op = GEN_INT (INTVAL (op) & 0xffff);  */
	  op = GEN_INT (((long long) INTVAL (op) >> const_shift) & 0xffff);
	  letter = 0;
	  break;
	default:
	  /* If you get here, figure out a test case :-) */
	  gcc_unreachable ();
	}
      break;

    case 'X':
      /* This is used to turn, for example, an ADD opcode into an ADDX
	 opcode when we're using 20-bit addresses.  */
      if (GET_MODE (op) == PSImode
	  || (!msp430_op_not_in_high_mem (op)))
	fprintf (file, "X");
      /* We don't care which operand we use, but we want 'X' in the MD
	 file, so we do it this way.  */
      return;

    case 'x':
      /* Similarly, but only for PSImodes.  BIC, for example, needs this.  */
      if (GET_MODE (op) == PSImode)
	fprintf (file, "X");
      return;

    case 'Q':
      /* Likewise, for BR -> BRA.  */
      if (TARGET_LARGE)
	fprintf (file, "A");
      return;

    case 'O':
      /* Computes the offset to the top of the stack for the current frame.
	 This has to be done here rather than in, say, msp430_expand_builtin()
	 because builtins are expanded before the frame layout is determined.  */
      fprintf (file, "%d",
	       msp430_initial_elimination_offset (ARG_POINTER_REGNUM, STACK_POINTER_REGNUM)
	       - (TARGET_LARGE ? 4 : 2));
      return;

    case 'J':
      gcc_assert (GET_CODE (op) == CONST_INT);
    case 0:
      break;
    default:
      output_operand_lossage ("invalid operand prefix");
      return;
    }

  switch (GET_CODE (op))
    {
    case REG:
      msp430_print_operand_raw (file, op);
      break;

    case MEM:
      addr = XEXP (op, 0);
      msp430_print_operand_addr (file, GET_MODE (op), addr);
      break;

    case CONST:
      if (GET_CODE (XEXP (op, 0)) == ZERO_EXTRACT)
	{
	  op = XEXP (op, 0);
	  switch (INTVAL (XEXP (op, 2)))
	    {
	    case 0:
	      fprintf (file, "#lo (");
	      msp430_print_operand_raw (file, XEXP (op, 0));
	      fprintf (file, ")");
	      break;
	  
	    case 16:
	      fprintf (file, "#hi (");
	      msp430_print_operand_raw (file, XEXP (op, 0));
	      fprintf (file, ")");
	      break;

	    default:
	      output_operand_lossage ("invalid zero extract");
	      break;
	    }
	  break;
	}
      /* Fall through.  */
    case CONST_INT:
    case SYMBOL_REF:
    case LABEL_REF:
      if (letter == 0)
	fprintf (file, "#");
      msp430_print_operand_raw (file, op);
      break;

    case EQ: fprintf (file, "EQ"); break;
    case NE: fprintf (file, "NE"); break;
    case GEU: fprintf (file, "HS"); break;
    case LTU: fprintf (file, "LO"); break;
    case GE: fprintf (file, "GE"); break;
    case LT: fprintf (file, "L"); break;

    default:
      print_rtl (file, op);
      break;
    }
}


/* Frame stuff.  */

rtx
msp430_return_addr_rtx (int count)
{
  int ra_size;
  if (count)
    return NULL_RTX;

  ra_size = TARGET_LARGE ? 4 : 2;
  if (crtl->args.pretend_args_size)
    ra_size += 2;

  return gen_rtx_MEM (Pmode, gen_rtx_PLUS (Pmode, arg_pointer_rtx, GEN_INT (- ra_size)));
}

rtx
msp430_incoming_return_addr_rtx (void)
{
  return gen_rtx_MEM (Pmode, stack_pointer_rtx);
}

/* Instruction generation stuff.  */

/* Generate a sequence of instructions to sign-extend an HI
   value into an SI value.  Handles the tricky case where
   we are overwriting the destination.  */

const char *
msp430x_extendhisi (rtx * operands)
{
  if (REGNO (operands[0]) == REGNO (operands[1]))
    /* Low word of dest == source word.  */
    return "BIT.W\t#0x8000, %L0 { SUBC.W\t%H0, %H0 { INV.W\t%H0, %H0"; /* 8-bytes.  */

  if (! msp430x)
    /* Note: This sequence is approximately the same length as invoking a helper
       function to perform the sign-extension, as in:

         MOV.W  %1, %L0
	 MOV.W  %1, r12
	 CALL   __mspabi_srai_15
	 MOV.W  r12, %H0

       but this version does not involve any function calls or using argument
       registers, so it reduces register pressure.  */
    return "MOV.W\t%1, %L0 { BIT.W\t#0x8000, %L0 { SUBC.W\t%H0, %H0 { INV.W\t%H0, %H0"; /* 10-bytes.  */

  if (REGNO (operands[0]) + 1 == REGNO (operands[1]))
    /* High word of dest == source word.  */
    return "MOV.W\t%1, %L0 { RPT\t#15 { RRAX.W\t%H0"; /* 6-bytes.  */

  /* No overlap between dest and source.  */
  return "MOV.W\t%1, %L0 { MOV.W\t%1, %H0 { RPT\t#15 { RRAX.W\t%H0"; /* 8-bytes.  */
}

/* Stop GCC from thinking that it can eliminate (SUBREG:PSI (SI)).  */

#undef TARGET_CAN_CHANGE_MODE_CLASS
#define TARGET_CAN_CHANGE_MODE_CLASS msp430_can_change_mode_class

static bool
msp430_can_change_mode_class (machine_mode from, machine_mode to, reg_class_t)
{
  if ((to == PSImode && from == SImode)
      || (to == SImode && from == PSImode)
      || (to == DImode && from == PSImode)
      || (to == PSImode && from == DImode))
    return false;
  return true;
}

void
msp430_register_pre_includes (const char *sysroot ATTRIBUTE_UNUSED,
			      const char *iprefix ATTRIBUTE_UNUSED,
			      int stdinc ATTRIBUTE_UNUSED)
{
  char *include_dir;
  if (msp430_check_env_var_for_devices (&include_dir))
    return;
  include_dir = msp430_dirname (include_dir);

  include_dir = update_path (include_dir, "");
  add_path (include_dir, INC_SYSTEM, false, false);
}

#undef  TARGET_HAVE_SPECULATION_SAFE_VALUE
#define TARGET_HAVE_SPECULATION_SAFE_VALUE speculation_safe_value_not_needed

struct gcc_target targetm = TARGET_INITIALIZER;

#include "gt-msp430.h"
