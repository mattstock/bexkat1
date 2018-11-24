module quadenc(clk, rst_n, quadA, quadB, count);

input clk;
input quadA;
input quadB;
output [5:0] count;
input rst_n;

reg [5:0] count;
reg quadA_last, quadB_last;

wire quadA_sync, quadB_sync;

always @(posedge clk) begin
  if (!rst_n) begin
    count <= 6'b0;
  end else begin
    case ({quadA_sync, quadA_last, quadB_sync, quadB_last})
      4'b0100: if (count == 6'h0)
                 count <= 6'd23;
               else
                 count <= count - 1'b1;
      4'b0001: if (count == 6'd23)
                 count <= 6'd0;
               else
                 count <= count + 1'b1;
    endcase
    
    quadA_last <= quadA_sync;
    quadB_last <= quadB_sync;
  end
end

debounce b0(.clk(clk), .in(quadA), .out(quadA_sync));
debounce b1(.clk(clk), .in(quadB), .out(quadB_sync));

endmodule
