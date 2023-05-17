/* Generated automatically by the program `genattr'
   from the machine description file `md'.  */

#ifndef GCC_INSN_ATTR_H
#define GCC_INSN_ATTR_H

#include "insn-attr-common.h"

#define HAVE_ATTR_type 1
extern enum attr_type get_attr_type (rtx_insn *);

#define HAVE_ATTR_extension 1
extern enum attr_extension get_attr_extension (rtx_insn *);

#define HAVE_ATTR_length_multiplier 1
extern int get_attr_length_multiplier (rtx_insn *);
#define HAVE_ATTR_extra_length 1
extern int get_attr_extra_length (rtx_insn *);
#define HAVE_ATTR_length 1
extern int get_attr_length (rtx_insn *);
extern void shorten_branches (rtx_insn *);
extern int insn_default_length (rtx_insn *);
extern int insn_min_length (rtx_insn *);
extern int insn_variable_length_p (rtx_insn *);
extern int insn_current_length (rtx_insn *);

#include "insn-addr.h"

extern int num_delay_slots (rtx_insn *);
extern int eligible_for_delay (rtx_insn *, int, rtx_insn *, int);

extern int const_num_delay_slots (rtx_insn *);

#define ANNUL_IFTRUE_SLOTS 0
extern int eligible_for_annul_true (rtx_insn *, int, rtx_insn *, int);
#define ANNUL_IFFALSE_SLOTS 0
extern int eligible_for_annul_false (rtx_insn *, int, rtx_insn *, int);
typedef void *state_t;

#ifndef HAVE_ATTR_length
#define HAVE_ATTR_length 0
#endif
#ifndef HAVE_ATTR_enabled
#define HAVE_ATTR_enabled 0
#endif
#ifndef HAVE_ATTR_preferred_for_size
#define HAVE_ATTR_preferred_for_size 0
#endif
#ifndef HAVE_ATTR_preferred_for_speed
#define HAVE_ATTR_preferred_for_speed 0
#endif
#if !HAVE_ATTR_length
extern int hook_int_rtx_insn_unreachable (rtx_insn *);
#define insn_default_length hook_int_rtx_insn_unreachable
#define insn_min_length hook_int_rtx_insn_unreachable
#define insn_variable_length_p hook_int_rtx_insn_unreachable
#define insn_current_length hook_int_rtx_insn_unreachable
#include "insn-addr.h"
#endif
extern int hook_int_rtx_1 (rtx);
#if !HAVE_ATTR_enabled
#define get_attr_enabled hook_int_rtx_1
#endif
#if !HAVE_ATTR_preferred_for_size
#define get_attr_preferred_for_size hook_int_rtx_1
#endif
#if !HAVE_ATTR_preferred_for_speed
#define get_attr_preferred_for_speed hook_int_rtx_1
#endif


#define ATTR_FLAG_forward	0x1
#define ATTR_FLAG_backward	0x2

#endif /* GCC_INSN_ATTR_H */
