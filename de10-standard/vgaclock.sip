set_global_assignment -entity "vgaclock" -library "lib_vgaclock" -name IP_TOOL_NAME "altera_pll"
set_global_assignment -entity "vgaclock" -library "lib_vgaclock" -name IP_TOOL_VERSION "18.1"
set_global_assignment -entity "vgaclock" -library "lib_vgaclock" -name IP_TOOL_ENV "mwpim"
set_global_assignment -library "lib_vgaclock" -name SPD_FILE [file join $::quartus(sip_path) "vgaclock.spd"]

set_global_assignment -library "lib_vgaclock" -name MISC_FILE [file join $::quartus(sip_path) "vgaclock_sim/vgaclock.vo"]
