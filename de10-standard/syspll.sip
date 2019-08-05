set_global_assignment -entity "syspll" -library "lib_syspll" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "syspll" -library "lib_syspll" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "syspll" -library "lib_syspll" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_syspll" -name SPD_FILE [file join $::quartus(sip_path) "syspll.spd"]

set_global_assignment -library "lib_syspll" -name MISC_FILE [file join $::quartus(sip_path) "syspll_sim/syspll.vo"]
