module floatingpoint(clock, in1, in2, out, func, over, under, zero);

parameter WIDTH=32;

input clock;
input [WIDTH-1:0] in1;
input [WIDTH-1:0] in2;
input [1:0] func;
output reg [WIDTH-1:0] out;
output reg over;
output reg under;
output reg zero;

localparam ADD=2'b01, SUB=2'b00, MUL=2'b10, DIV=2'b11;

wire addsub_over, addsub_under, addsub_zero;
wire [WIDTH-1:0] addsub_out;

always @*
begin
  case (func)
    ADD: begin
      over = addsub_over;
      under = addsub_under;
      zero = addsub_zero;
      out = addsub_out;
    end
    SUB: begin
      over = addsub_over;
      under = addsub_under;
      zero = addsub_zero;
      out = addsub_out;
    end
    MUL: begin
      over = addsub_over;
      under = addsub_under;
      zero = addsub_zero;
      out = addsub_out;
    end
    DIV: begin
      over = addsub_over;
      under = addsub_under;
      zero = addsub_zero;
      out = addsub_out;
    end
  endcase
end

fpaddsub fpaddsub(.clock(clock), .dataa(in1), .datab(in2), .result(addsub_out), .add_sub(func[0]),
  .overflow(addsub_over), .zero(addsub_zero), .underflow(addsub_under));

endmodule
