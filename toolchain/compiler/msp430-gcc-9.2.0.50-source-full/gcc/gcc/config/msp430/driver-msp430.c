/* Subroutines for the gcc driver.
   Copyright (C) 2015-2019 Free Software Foundation, Inc.
   Contributed by Georg-Johann Lay <avr@gjlay.de>

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
#include "diagnostic.h"
#include "tm.h"
#include "msp430-devices.h"

const char *
msp430_select_cpu (int argc, const char ** argv)
{
  if (argc == 0)
    return NULL;
  msp430_extract_mcu_data (argv[0], true);
  /* Do not add an mcpu option onto the command line if the mcu isn't found,
     in case the user manually specified one.  */
  if (extracted_mcu_data.name != NULL)
    {
      switch (extracted_mcu_data.revision)
	{
	case 0: return "-mcpu=msp430";
	case 1: return "-mcpu=msp430x";
	case 2: return "-mcpu=msp430xv2";
	default:
		gcc_unreachable ();
	}
    }
  return NULL;
}

/* Implement spec function `msp430_hwmult_lib´.  */

const char *
msp430_select_hwmult_lib (int argc ATTRIBUTE_UNUSED,
			  const char ** argv ATTRIBUTE_UNUSED)
{
  int i;

  switch (argc)
  {
  case 1:
    if (strcasecmp (argv[0], "default"))
      error ("unexpected argument to msp430_select_hwmult_lib: %s", argv[0]);
    break;

  default:
    /* We can get three or more arguments passed to this function.
       This happens when the same option is repeated on the command line.
       For example:
         msp430-elf-gcc -mhwmult=none -mhwmult=16bit foo.c
       We have to use the last argument as our selector.  */
    if (strcasecmp (argv[0], "hwmult") == 0)
      {
	static struct hwmult_options
	{
	  const char * name;
	  const char * lib;
	} hwmult_options [] =
	{
	  { "none", "-lmul_none" },
	  { "auto", "-lmul_AUTO" }, /* Should not see this one... */
	  { "16bit", "-lmul_16" },
	  { "32bit", "-lmul_32" },
	  { "f5series", "-lmul_f5" }
	};

	for (i = ARRAY_SIZE (hwmult_options); i--;)
	  if (strcasecmp (argv[argc - 1], hwmult_options[i].name) == 0)
	    return hwmult_options[i].lib;
      }
    else if (strcasecmp (argv[0], "mcu") == 0)
      {
	msp430_extract_mcu_data (argv[argc - 1], true);
	if (extracted_mcu_data.name != NULL)
	  {
	    switch (extracted_mcu_data.hwmpy)
	      {
	      case 0: return "-lmul_none";
	      case 2:
	      case 1: return "-lmul_16";
	      case 4: return "-lmul_32";
	      case 8: return "-lmul_f5";
	      default:
		      gcc_unreachable ();
	      }
	  }
      }
    else
      error ("unexpected first argument to msp430_select_hwmult_lib: %s", argv[0]);
    break;

  case 0:
    error ("msp430_select_hwmult_lib needs one or more arguments");
    break;
  }
  
  return "-lmul_none";
}

const char *
msp430_get_linker_devices_include_path (int argc ATTRIBUTE_UNUSED,
					const char **argv ATTRIBUTE_UNUSED)
{
  char *devices_csv_path;
  if (msp430_check_env_var_for_devices (&devices_csv_path))
    return NULL;
  return concat ("-L", msp430_dirname (devices_csv_path), NULL);
}

/* Propagate data-region={none,upper,either} to the linker, for lower only
   propagte if -muse-lower-region-prefix is also passed.  */
const char *
msp430_check_lower_region_prefix (int argc, const char **argv)
{
  if (strcmp (argv[0], "lower") != 0)
    return argv[0];
  else if ((argc > 1) && (strcmp(argv[1], "-muse-lower-region-prefix") == 0))
    return argv[0]; /* argv[0] == "lower".  */
  return "none";
}
