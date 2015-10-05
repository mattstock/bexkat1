// megafunction wizard: %ALTFP_CONVERT%
// GENERATION: STANDARD
// VERSION: WM1.0
// MODULE: ALTFP_CONVERT 

// ============================================================
// File Name: dp_cvtsd.v
// Megafunction Name(s):
// 			ALTFP_CONVERT
//
// Simulation Library Files(s):
// 			lpm
// ============================================================
// ************************************************************
// THIS IS A WIZARD-GENERATED FILE. DO NOT EDIT THIS FILE!
//
// 14.0.2 Build 209 09/17/2014 SJ Web Edition
// ************************************************************


//Copyright (C) 1991-2014 Altera Corporation. All rights reserved.
//Your use of Altera Corporation's design tools, logic functions 
//and other software and tools, and its AMPP partner logic 
//functions, and any output files from any of the foregoing 
//(including device programming or simulation files), and any 
//associated documentation or information are expressly subject 
//to the terms and conditions of the Altera Program License 
//Subscription Agreement, the Altera Quartus II License Agreement,
//the Altera MegaCore Function License Agreement, or other 
//applicable license agreement, including, without limitation, 
//that your use is for the sole purpose of programming logic 
//devices manufactured by Altera and sold by Altera or its 
//authorized distributors.  Please refer to the applicable 
//agreement for further details.


//altfp_convert CBX_AUTO_BLACKBOX="ALL" DEVICE_FAMILY="Cyclone IV GX" OPERATION="FLOAT2FLOAT" ROUNDING="TO_NEAREST" WIDTH_DATA=32 WIDTH_EXP_INPUT=8 WIDTH_EXP_OUTPUT=11 WIDTH_INT=32 WIDTH_MAN_INPUT=23 WIDTH_MAN_OUTPUT=52 WIDTH_RESULT=64 clock dataa nan overflow result underflow
//VERSION_BEGIN 14.0 cbx_altbarrel_shift 2014:09:17:18:41:02:SJ cbx_altfp_convert 2014:09:17:18:41:02:SJ cbx_altpriority_encoder 2014:09:17:18:41:02:SJ cbx_altsyncram 2014:09:17:18:41:02:SJ cbx_cycloneii 2014:09:17:18:41:02:SJ cbx_lpm_abs 2014:09:17:18:41:02:SJ cbx_lpm_add_sub 2014:09:17:18:41:02:SJ cbx_lpm_compare 2014:09:17:18:41:02:SJ cbx_lpm_decode 2014:09:17:18:41:02:SJ cbx_lpm_divide 2014:09:17:18:41:02:SJ cbx_lpm_mux 2014:09:17:18:41:02:SJ cbx_mgl 2014:09:17:20:49:57:SJ cbx_stratix 2014:09:17:18:41:02:SJ cbx_stratixii 2014:09:17:18:41:02:SJ cbx_stratixiii 2014:09:17:18:41:03:SJ cbx_stratixv 2014:09:17:18:41:03:SJ cbx_util_mgl 2014:09:17:18:41:02:SJ  VERSION_END
// synthesis VERILOG_INPUT_VERSION VERILOG_2001
// altera message_off 10463


//synthesis_resources = lpm_add_sub 1 reg 75 
//synopsys translate_off
`timescale 1 ps / 1 ps
//synopsys translate_on
module  dp_cvtsd_altfp_convert_ikp
	( 
	clock,
	dataa,
	nan,
	overflow,
	result,
	underflow) ;
	input   clock;
	input   [31:0]  dataa;
	output   nan;
	output   overflow;
	output   [63:0]  result;
	output   underflow;

	reg	[10:0]	bias_adjust_adder_reg;
	reg	[34:0]	dp_result_reg;
	reg	exp_and_reg;
	reg	exp_or_reg;
	reg	man_or_reg;
	reg	[22:0]	mantissa_input_reg;
	reg	nan_reg;
	reg	overflow_reg;
	reg	sign_reg1;
	wire  [10:0]   wire_add_sub1_result;
	wire aclr;
	wire  [10:0]  bias_adjust_a;
	wire  [10:0]  bias_adjust_b;
	wire clk_en;
	wire  denormal_input_w;
	wire  [33:0]  dp_int_w;
	wire  [34:0]  dp_result_w;
	wire  [7:0]  exp_and;
	wire  exp_and_w;
	wire  [7:0]  exp_bus;
	wire  [10:0]  exp_exc_ones_w;
	wire  [10:0]  exp_exc_zeros_w;
	wire  [7:0]  exp_or;
	wire  exp_or_w;
	wire  [2:0]  exp_zero_padding_w;
	wire  [10:0]  exponent_dp_w;
	wire  [7:0]  exponent_input;
	wire  infinity_input_w;
	wire  [33:0]  infinity_result_w;
	wire  infinity_selector_w;
	wire  [33:0]  infinity_value_w;
	wire  [22:0]  man_bus;
	wire  [21:0]  man_exc_nan_zeros_w;
	wire  [22:0]  man_exc_zeros_w;
	wire  [22:0]  man_or;
	wire  man_or_w;
	wire  [22:0]  mantissa_dp_w;
	wire  [22:0]  mantissa_input;
	wire  nan_input_w;
	wire  [33:0]  nan_result_w;
	wire  nan_selector_w;
	wire  [33:0]  nan_value_w;
	wire  sign_input;
	wire  zero_input_w;
	wire  [33:0]  zero_result_w;
	wire  zero_selector_w;
	wire  [33:0]  zero_value_w;

	// synopsys translate_off
	initial
		bias_adjust_adder_reg = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) bias_adjust_adder_reg <= 11'b0;
		else if  (clk_en == 1'b1)   bias_adjust_adder_reg <= wire_add_sub1_result;
	// synopsys translate_off
	initial
		dp_result_reg = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) dp_result_reg <= 35'b0;
		else if  (clk_en == 1'b1)   dp_result_reg <= dp_result_w;
	// synopsys translate_off
	initial
		exp_and_reg = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) exp_and_reg <= 1'b0;
		else if  (clk_en == 1'b1)   exp_and_reg <= exp_and_w;
	// synopsys translate_off
	initial
		exp_or_reg = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) exp_or_reg <= 1'b0;
		else if  (clk_en == 1'b1)   exp_or_reg <= exp_or_w;
	// synopsys translate_off
	initial
		man_or_reg = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) man_or_reg <= 1'b0;
		else if  (clk_en == 1'b1)   man_or_reg <= man_or_w;
	// synopsys translate_off
	initial
		mantissa_input_reg = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) mantissa_input_reg <= 23'b0;
		else if  (clk_en == 1'b1)   mantissa_input_reg <= mantissa_input;
	// synopsys translate_off
	initial
		nan_reg = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) nan_reg <= 1'b0;
		else if  (clk_en == 1'b1)   nan_reg <= nan_selector_w;
	// synopsys translate_off
	initial
		overflow_reg = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) overflow_reg <= 1'b0;
		else if  (clk_en == 1'b1)   overflow_reg <= infinity_selector_w;
	// synopsys translate_off
	initial
		sign_reg1 = 0;
	// synopsys translate_on
	always @ ( posedge clock or  posedge aclr)
		if (aclr == 1'b1) sign_reg1 <= 1'b0;
		else if  (clk_en == 1'b1)   sign_reg1 <= sign_input;
	lpm_add_sub   add_sub1
	( 
	.cout(),
	.dataa(bias_adjust_a),
	.datab(bias_adjust_b),
	.overflow(),
	.result(wire_add_sub1_result)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_off
	`endif
	,
	.aclr(1'b0),
	.add_sub(1'b1),
	.cin(),
	.clken(1'b1),
	.clock(1'b0)
	`ifndef FORMAL_VERIFICATION
	// synopsys translate_on
	`endif
	);
	defparam
		add_sub1.lpm_direction = "ADD",
		add_sub1.lpm_width = 11,
		add_sub1.lpm_type = "lpm_add_sub",
		add_sub1.lpm_hint = "ONE_INPUT_IS_CONSTANT=YES";
	assign
		aclr = 1'b0,
		bias_adjust_a = {exp_zero_padding_w, exponent_input},
		bias_adjust_b = 11'b01110000000,
		clk_en = 1'b1,
		denormal_input_w = ((~ exp_or_reg) & man_or_reg),
		dp_int_w = {exponent_dp_w, mantissa_dp_w},
		dp_result_w = {sign_reg1, nan_result_w},
		exp_and = {(exp_and[6] & exp_bus[7]), (exp_and[5] & exp_bus[6]), (exp_and[4] & exp_bus[5]), (exp_and[3] & exp_bus[4]), (exp_and[2] & exp_bus[3]), (exp_and[1] & exp_bus[2]), (exp_and[0] & exp_bus[1]), exp_bus[0]},
		exp_and_w = exp_and[7],
		exp_bus = exponent_input,
		exp_exc_ones_w = {11{1'b1}},
		exp_exc_zeros_w = {11{1'b0}},
		exp_or = {(exp_or[6] | exp_bus[7]), (exp_or[5] | exp_bus[6]), (exp_or[4] | exp_bus[5]), (exp_or[3] | exp_bus[4]), (exp_or[2] | exp_bus[3]), (exp_or[1] | exp_bus[2]), (exp_or[0] | exp_bus[1]), exp_bus[0]},
		exp_or_w = exp_or[7],
		exp_zero_padding_w = {3{1'b0}},
		exponent_dp_w = bias_adjust_adder_reg,
		exponent_input = dataa[30:23],
		infinity_input_w = (exp_and_reg & (~ man_or_reg)),
		infinity_result_w = (({34{(~ infinity_selector_w)}} & zero_result_w) | ({34{infinity_selector_w}} & infinity_value_w)),
		infinity_selector_w = infinity_input_w,
		infinity_value_w = {exp_exc_ones_w, man_exc_zeros_w},
		man_bus = mantissa_input,
		man_exc_nan_zeros_w = {22{1'b0}},
		man_exc_zeros_w = {23{1'b0}},
		man_or = {(man_or[21] | man_bus[22]), (man_or[20] | man_bus[21]), (man_or[19] | man_bus[20]), (man_or[18] | man_bus[19]), (man_or[17] | man_bus[18]), (man_or[16] | man_bus[17]), (man_or[15] | man_bus[16]), (man_or[14] | man_bus[15]), (man_or[13] | man_bus[14]), (man_or[12] | man_bus[13]), (man_or[11] | man_bus[12]), (man_or[10] | man_bus[11]), (man_or[9] | man_bus[10]), (man_or[8] | man_bus[9]), (man_or[7] | man_bus[8]), (man_or[6] | man_bus[7]), (man_or[5] | man_bus[6]), (man_or[4] | man_bus[5]), (man_or[3] | man_bus[4]), (man_or[2] | man_bus[3]), (man_or[1] | man_bus[2]), (man_or[0] | man_bus[1]), man_bus[0]},
		man_or_w = man_or[22],
		mantissa_dp_w = mantissa_input_reg,
		mantissa_input = dataa[22:0],
		nan = nan_reg,
		nan_input_w = (exp_and_reg & man_or_reg),
		nan_result_w = (({34{(~ nan_selector_w)}} & infinity_result_w) | ({34{nan_selector_w}} & nan_value_w)),
		nan_selector_w = nan_input_w,
		nan_value_w = {exp_exc_ones_w, 1'b1, man_exc_nan_zeros_w},
		overflow = overflow_reg,
		result = {dp_result_reg, {29{1'b0}}},
		sign_input = dataa[31],
		underflow = 1'b0,
		zero_input_w = ((~ exp_or_reg) & (~ man_or_reg)),
		zero_result_w = (({34{(~ zero_selector_w)}} & dp_int_w) | ({34{zero_selector_w}} & zero_value_w)),
		zero_selector_w = (denormal_input_w | zero_input_w),
		zero_value_w = {exp_exc_zeros_w, man_exc_zeros_w};
endmodule //dp_cvtsd_altfp_convert_ikp
//VALID FILE


// synopsys translate_off
`timescale 1 ps / 1 ps
// synopsys translate_on
module dp_cvtsd (
	clock,
	dataa,
	nan,
	overflow,
	result,
	underflow);

	input	  clock;
	input	[31:0]  dataa;
	output	  nan;
	output	  overflow;
	output	[63:0]  result;
	output	  underflow;

	wire  sub_wire0;
	wire  sub_wire1;
	wire [63:0] sub_wire2;
	wire  sub_wire3;
	wire  nan = sub_wire0;
	wire  overflow = sub_wire1;
	wire [63:0] result = sub_wire2[63:0];
	wire  underflow = sub_wire3;

	dp_cvtsd_altfp_convert_ikp	dp_cvtsd_altfp_convert_ikp_component (
				.clock (clock),
				.dataa (dataa),
				.nan (sub_wire0),
				.overflow (sub_wire1),
				.result (sub_wire2),
				.underflow (sub_wire3));

endmodule

// ============================================================
// CNX file retrieval info
// ============================================================
// Retrieval info: LIBRARY: altera_mf altera_mf.altera_mf_components.all
// Retrieval info: PRIVATE: INTENDED_DEVICE_FAMILY STRING "Cyclone IV GX"
// Retrieval info: CONSTANT: INTENDED_DEVICE_FAMILY STRING "Cyclone IV GX"
// Retrieval info: CONSTANT: LPM_HINT STRING "UNUSED"
// Retrieval info: CONSTANT: LPM_TYPE STRING "altfp_convert"
// Retrieval info: CONSTANT: OPERATION STRING "FLOAT2FLOAT"
// Retrieval info: CONSTANT: ROUNDING STRING "TO_NEAREST"
// Retrieval info: CONSTANT: WIDTH_DATA NUMERIC "32"
// Retrieval info: CONSTANT: WIDTH_EXP_INPUT NUMERIC "8"
// Retrieval info: CONSTANT: WIDTH_EXP_OUTPUT NUMERIC "11"
// Retrieval info: CONSTANT: WIDTH_INT NUMERIC "32"
// Retrieval info: CONSTANT: WIDTH_MAN_INPUT NUMERIC "23"
// Retrieval info: CONSTANT: WIDTH_MAN_OUTPUT NUMERIC "52"
// Retrieval info: CONSTANT: WIDTH_RESULT NUMERIC "64"
// Retrieval info: USED_PORT: clock 0 0 0 0 INPUT NODEFVAL "clock"
// Retrieval info: CONNECT: @clock 0 0 0 0 clock 0 0 0 0
// Retrieval info: USED_PORT: dataa 0 0 32 0 INPUT NODEFVAL "dataa[31..0]"
// Retrieval info: CONNECT: @dataa 0 0 32 0 dataa 0 0 32 0
// Retrieval info: USED_PORT: nan 0 0 0 0 OUTPUT NODEFVAL "nan"
// Retrieval info: CONNECT: nan 0 0 0 0 @nan 0 0 0 0
// Retrieval info: USED_PORT: overflow 0 0 0 0 OUTPUT NODEFVAL "overflow"
// Retrieval info: CONNECT: overflow 0 0 0 0 @overflow 0 0 0 0
// Retrieval info: USED_PORT: result 0 0 64 0 OUTPUT NODEFVAL "result[63..0]"
// Retrieval info: CONNECT: result 0 0 64 0 @result 0 0 64 0
// Retrieval info: USED_PORT: underflow 0 0 0 0 OUTPUT NODEFVAL "underflow"
// Retrieval info: CONNECT: underflow 0 0 0 0 @underflow 0 0 0 0
// Retrieval info: GEN_FILE: TYPE_NORMAL dp_cvtsd.v TRUE FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL dp_cvtsd.qip TRUE FALSE
// Retrieval info: GEN_FILE: TYPE_NORMAL dp_cvtsd.bsf FALSE TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL dp_cvtsd_inst.v FALSE TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL dp_cvtsd_bb.v FALSE TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL dp_cvtsd.inc FALSE TRUE
// Retrieval info: GEN_FILE: TYPE_NORMAL dp_cvtsd.cmp FALSE TRUE
// Retrieval info: LIB_FILE: lpm
