# TCL File Generated by Component Editor 14.0
# Tue Feb 24 11:10:40 EST 2015
# DO NOT MODIFY


# 
# led_matrix "led_matrix" v1.1
# Matt Stock 2015.02.24.11:10:40
# LED Matrix driver
# 

# 
# request TCL package from ACDS 14.0
# 
package require -exact qsys 14.0


# 
# module led_matrix
# 
set_module_property DESCRIPTION "LED Matrix driver"
set_module_property NAME led_matrix
set_module_property VERSION 1.1
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR "Matt Stock"
set_module_property DISPLAY_NAME led_matrix
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


# 
# file sets
# 
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL led_matrix
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file led_matrix.v VERILOG PATH led_matrix.v TOP_LEVEL_FILE
add_fileset_file matrixmem.qip OTHER PATH matrixmem.qip
add_fileset_file matrixmem.v VERILOG PATH matrixmem.v


# 
# parameters
# 
add_parameter DELAY STD_LOGIC_VECTOR 32
set_parameter_property DELAY DEFAULT_VALUE 32
set_parameter_property DELAY DISPLAY_NAME DELAY
set_parameter_property DELAY TYPE STD_LOGIC_VECTOR
set_parameter_property DELAY ENABLED false
set_parameter_property DELAY UNITS None
set_parameter_property DELAY ALLOWED_RANGES 0:511
set_parameter_property DELAY HDL_PARAMETER true


# 
# display items
# 


# 
# connection point clock
# 
add_interface clock clock end
set_interface_property clock clockRate 0
set_interface_property clock ENABLED true
set_interface_property clock EXPORT_OF ""
set_interface_property clock PORT_NAME_MAP ""
set_interface_property clock CMSIS_SVD_VARIABLES ""
set_interface_property clock SVD_ADDRESS_GROUP ""

add_interface_port clock csi_clk clk Input 1


# 
# connection point reset
# 
add_interface reset reset end
set_interface_property reset associatedClock clock
set_interface_property reset synchronousEdges DEASSERT
set_interface_property reset ENABLED true
set_interface_property reset EXPORT_OF ""
set_interface_property reset PORT_NAME_MAP ""
set_interface_property reset CMSIS_SVD_VARIABLES ""
set_interface_property reset SVD_ADDRESS_GROUP ""

add_interface_port reset rsi_reset_n reset_n Input 1


# 
# connection point s0
# 
add_interface s0 avalon end
set_interface_property s0 addressUnits WORDS
set_interface_property s0 associatedClock clock
set_interface_property s0 associatedReset reset
set_interface_property s0 bitsPerSymbol 8
set_interface_property s0 burstOnBurstBoundariesOnly false
set_interface_property s0 burstcountUnits WORDS
set_interface_property s0 explicitAddressSpan 0
set_interface_property s0 holdTime 0
set_interface_property s0 linewrapBursts false
set_interface_property s0 maximumPendingReadTransactions 0
set_interface_property s0 maximumPendingWriteTransactions 0
set_interface_property s0 readLatency 0
set_interface_property s0 readWaitTime 1
set_interface_property s0 setupTime 0
set_interface_property s0 timingUnits Cycles
set_interface_property s0 writeWaitTime 0
set_interface_property s0 ENABLED true
set_interface_property s0 EXPORT_OF ""
set_interface_property s0 PORT_NAME_MAP ""
set_interface_property s0 CMSIS_SVD_VARIABLES ""
set_interface_property s0 SVD_ADDRESS_GROUP ""

add_interface_port s0 avs_s0_writedata writedata Input 32
add_interface_port s0 avs_s0_readdata readdata Output 32
add_interface_port s0 avs_s0_address address Input 9
add_interface_port s0 avs_s0_write write Input 1
add_interface_port s0 avs_s0_read read Input 1
add_interface_port s0 avs_s0_byteenable byteenable Input 4
set_interface_assignment s0 embeddedsw.configuration.isFlash 0
set_interface_assignment s0 embeddedsw.configuration.isMemoryDevice 0
set_interface_assignment s0 embeddedsw.configuration.isNonVolatileStorage 0
set_interface_assignment s0 embeddedsw.configuration.isPrintableDevice 0


# 
# connection point matrix
# 
add_interface matrix conduit end
set_interface_property matrix associatedClock ""
set_interface_property matrix associatedReset ""
set_interface_property matrix ENABLED true
set_interface_property matrix EXPORT_OF ""
set_interface_property matrix PORT_NAME_MAP ""
set_interface_property matrix CMSIS_SVD_VARIABLES ""
set_interface_property matrix SVD_ADDRESS_GROUP ""

add_interface_port matrix rgb_a a Output 1
add_interface_port matrix oe_n rgb_oe_n Output 1
add_interface_port matrix rgb_b b Output 1
add_interface_port matrix rgb_c c Output 1
add_interface_port matrix rgb0 rgb0 Output 3
add_interface_port matrix rgb1 rgb1 Output 3
add_interface_port matrix rgb_stb stb Output 1
add_interface_port matrix rgb_clk rgb_clk Output 1

