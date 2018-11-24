module hexdisp(in, out);

input [3:0] in;
output [6:0] out;

reg [6:0] out;

always_comb begin
  case (in)
    4'h1: out = 'b1111001;
    4'h2: out = 'b0100100;
    4'h3: out = 'b0110000;
    4'h4: out = 'b0011001;
    4'h5: out = 'b0010010;
    4'h6: out = 'b0000010;
    4'h7: out = 'b1111000;
    4'h8: out = 'b0000000;
    4'h9: out = 'b0010000;
    4'ha: out = 'b0001000;
    4'hb: out = 'b0000011;
    4'hc: out = 'b1000110;
    4'hd: out = 'b0100001;
    4'he: out = 'b0000110;
    4'hf: out = 'b0001110;
    4'h0: out = 'b1000000;  
  endcase
end

endmodule
