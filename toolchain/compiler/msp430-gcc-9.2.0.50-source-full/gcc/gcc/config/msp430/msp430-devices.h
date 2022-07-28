struct t_msp430_mcu_data
{
  const char * name;
  unsigned int revision; /* 0=> MSP430, 1=>MSP430X, 2=> MSP430Xv2.  */
  unsigned int hwmpy;    /* 0=>none, 1=>16-bit, 2=>16-bit w/sign extend.  */
			 /* 4=>32-bit, 8=> 32-bit (5xx).  */
};

extern struct t_msp430_mcu_data extracted_mcu_data;

void msp430_extract_mcu_data (const char * mcu_name, bool surpress_warn);
int msp430_check_env_var_for_devices (char **local_devices_csv_loc);
char * msp430_dirname (char *path);
