module registerfile2(clk, rst_n, supervisor, read1, read2, write_addr, write_data, write_en, data1, data2);

input clk;
input rst_n;
input supervisor;
input [COUNTP-1:0] read1, read2, write_addr;
input [WIDTH-1:0] write_data;
input [1:0] write_en;
output [WIDTH-1:0] data1, data2;

parameter WIDTH=32;
parameter COUNT=16;
parameter COUNTP=4;

reg [WIDTH-1:0] regfile [COUNT-1:0];
reg [WIDTH-1:0] regfile_next [COUNT-1:0];
reg [WIDTH-1:0] ssp, ssp_next;

assign data1 = (supervisor && read1 == 4'd15 ? ssp : regfile[read1]);
assign data2 = (supervisor && read2 == 4'd15 ? ssp : regfile[read2]);

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    for (int i=0; i < COUNT; i = i + 1)
      regfile[i] <= 'h00000000;
    ssp <= 'h00000000;
  end else begin
    for (int i=0; i < COUNT; i = i + 1)
      regfile[i] <= regfile_next[i];
    ssp <= ssp_next;
  end
end

always @*
begin
  for (int i=0; i < COUNT; i = i + 1)
    regfile_next[i] = regfile[i];
  ssp_next = ssp;
  case (write_en)
    2'b00: begin end
    2'b01: begin
      if (write_addr == 4'd15 && supervisor)
        ssp_next = { 24'h000000, write_data[7:0] };
      else
        regfile_next[write_addr] = { 24'h000000, write_data[7:0] };
    end
    2'b10: begin
      if (write_addr == 4'd15 && supervisor)
        ssp_next = { 16'h0000, write_data[15:0] };
      else
        regfile_next[write_addr] = { 16'h0000, write_data[15:0] };
    end
    2'b11: begin
      if (write_addr == 4'd15 && supervisor)
        ssp_next = write_data;
      else
        regfile_next[write_addr] = write_data;
    end
  endcase
end

endmodule
