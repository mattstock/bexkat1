`include "bexkat2.vh"

module fpu(input clk_i,
	   input rst_i,
	   input [31:0] in1,
	   input [31:0] in2,
	   input [2:0] func,
	   output reg [31:0] out,
	   output reg overflow,
	   output reg underflow,
	   output reg nan,
	   output reg divzero);

wire [31:0] cvtis_out, cvtsi_out, addsub_out, mult_out, div_out, sqrt_out;
wire addsub_nan, addsub_ov, addsub_un;
wire mult_nan, mult_ov, mult_un;
wire div_nan, div_ov, div_un, div_divzero;
wire sqrt_ov;


always @* begin
  overflow = 1'b0;
  nan = 1'b0;
  underflow = 1'b0;
  divzero = 1'b0;
  case (func)
    FPU_CVTIS: out = cvtis_out;
    FPU_CVTSI: out = cvtsi_out; 
    FPU_SQRT: begin
      out = sqrt_out;
      overflow = sqrt_ov;
    end
    FPU_NEG: out = 32'h0;
    FPU_ADD: begin
      out = addsub_out;
      overflow = addsub_ov;
      underflow = addsub_un;
      nan = addsub_nan;
    end
    FPU_SUB: begin
      out = addsub_out;
      overflow = addsub_ov;
      underflow = addsub_un;
      nan = addsub_nan;
    end
    FPU_MUL: begin
      out = mult_out;
      overflow = mult_ov;
      underflow = mult_un;
      nan = mult_nan;
    end
    FPU_DIV: begin
      out = div_out;
      overflow = div_ov;
      underflow = div_un;
      nan = div_nan;
      divzero = div_divzero;
    end
  endcase    
end // always @ *

fp_cvtis fp_cvtis0(.clock(clk_i), .dataa(in2), .result(cvtis_out));
fp_cvtsi fp_cvtsi0(.clock(clk_i), .dataa(in2), .result(cvtsi_out));
fp_addsub fp_addsub0(.clock(clk_i), .aclr(rst_i),
		     .dataa(in1), .datab(in2),
		     .add_sub(func[0]),
		     .result(addsub_out),
		     .nan(addsub_nan),
		     .overflow(addsub_ov),
		     .underflow(addsub_un));
fp_mult fp_mult0(.clock(clk_i), .aclr(rst_i),
		 .dataa(in1), .datab(in2),
		 .result(mult_out),
		 .nan(mult_nan),
		 .overflow(mult_ov),
		 .underflow(mult_un));
fp_div fp_div0(.clock(clk_i), .aclr(rst_i),
	       .dataa(in1), .datab(in2),
	       .result(div_out),
	       .nan(div_nan),
	       .overflow(div_ov),
	       .underflow(div_un),
	       .division_by_zero(div_divzero));
fp_sqrt fp_sqrt0(.clock(clk_i), .aclr(rst_i),
		 .data(in2),
		 .result(sqrt_out),
		 .overflow(sqrt_ov));

endmodule // fpu
