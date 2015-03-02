module registerfile(clk, rst_n, read1, read2, write_addr, write_data, write_en, data1, data2);

input clk;
input rst_n;
input [COUNTP-1:0] read1, read2, write_addr;
input [WIDTH-1:0] write_data;
input [1:0] write_en;
output [WIDTH-1:0] data1, data2;

parameter WIDTH=32;
parameter COUNT=32;
parameter COUNTP=5;

reg [WIDTH-1:0] regfile [COUNT-1:0];
reg [WIDTH-1:0] regfile_next [COUNT-1:0];

assign data1 = regfile[read1];
assign data2 = regfile[read2];

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    for (int i=0; i < COUNT-1; i = i + 1)
      regfile[i] <= 'h00000000;
    regfile[COUNT-1] <= 'h0007fffe;  // such a hack
  end else begin
    for (int i=0; i < COUNT; i = i + 1)
      regfile[i] <= regfile_next[i];
  end
end

always @*
begin
  for (int i=0; i < COUNT; i = i + 1)
    regfile_next[i] = regfile[i];
  if (write_en[0]) 
    regfile_next[write_addr][15:0] = write_data[15:0];
  if (write_en[1]) 
    regfile_next[write_addr][31:16] = write_data[31:16];
end

endmodule
