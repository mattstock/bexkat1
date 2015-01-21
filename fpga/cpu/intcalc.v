module intcalc(clock, func, in1, in2, out);

parameter WIDTH=32;

input clock;
input [2:0] func;
input [WIDTH-1:0] in1;
input [WIDTH-1:0] in2;
output reg [WIDTH-1:0] out;

wire [WIDTH-1:0] divq, divr, divuq, divur;
wire [2*WIDTH-1:0] mul_out, mulu_out;

localparam MUL=3'b000, DIV=3'b001, MOD=3'b010, MULU=3'b100, DIVU=3'b101, MODU=3'b110;

always @*
begin
  case (func)
    MUL : out = mul_out[15:0];
    DIV : out = divq;
    MOD : out = divr;
    MULU: out = mulu_out[15:0];
    DIVU: out = divuq;
    MODU: out = divur;
    default: out = 'h0;
  endcase
end

intsdiv d0(.numer(in1), .denom(in2), .quotient(divq), .remain(divr));
intudiv d1(.numer(in1), .denom(in2), .quotient(divuq), .remain(divur));
intumult m0(.dataa(in1), .datab(in2), .result(mulu_out));
intsmult m1(.dataa(in1), .datab(in2), .result(mul_out));

endmodule