module registerfile(clk, rst_n, read1, read2, write_addr, write_data, write_en, data1, data2);

input clk;
input rst_n;
input [4:0] read1, read2, write_addr;
input [15:0] write_data;
input write_en;
output [15:0] data1, data2;

reg [15:0] regfile [31:0];
reg [15:0] regfile_next [31:0];

assign data1 = regfile[read1];
assign data2 = regfile[read2];

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    for (int i=0; i < 32; i = i + 1)
      regfile[i] <= 16'h0000;
  end else begin
    for (int i=0; i < 32; i = i + 1)
      regfile[i] <= regfile_next[i];
  end
end

always @*
begin
  for (int i=0; i < 32; i = i + 1)
    regfile_next[i] = regfile[i];
  if (write_en)
    regfile_next[write_addr] = write_data;
end

endmodule
