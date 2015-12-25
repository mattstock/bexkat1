`include "bexkat2.vh"

module intcalc2(clock, func, in1, in2, out);

parameter WIDTH=32;

input clock;
input [3:0] func;
input [WIDTH-1:0] in1;
input [WIDTH-1:0] in2;
output reg [WIDTH-1:0] out;

wire [WIDTH-1:0] divq, divr, divuq, divur;
wire [2*WIDTH-1:0] mul_out, mulu_out;

always @*
begin
  case (func)
    INT_MUL :  out = mul_out[WIDTH-1:0];
    INT_DIV :  out = divq;
    INT_MOD :  out = divr;
    INT_MULU:  out = mulu_out[WIDTH-1:0];
    INT_DIVU:  out = divuq;
    INT_MODU:  out = divur;
    INT_MULX:  out = mul_out[2*WIDTH-1:WIDTH];
    INT_MULUX: out = mulu_out[2*WIDTH-1:WIDTH];
    INT_EXT:   out = { {16{in2[15]}}, in2[15:0] };
    INT_EXTB:  out = { {24{in2[7]}}, in2[7:0] };
    INT_COM:   out = ~in2;
    INT_NEG:   out = -in2;
    default:   out = 'h0;
  endcase
end

intsdiv d0(.clock(clock), .numer(in1), .denom(in2), .quotient(divq), .remain(divr));
intudiv d1(.clock(clock), .numer(in1), .denom(in2), .quotient(divuq), .remain(divur));
intumult m0(.clock(clock), .dataa(in1), .datab(in2), .result(mulu_out));
intsmult m1(.clock(clock), .dataa(in1), .datab(in2), .result(mul_out));

endmodule
