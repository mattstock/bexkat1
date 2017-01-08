module bios(
  input clk_i,
  input rst_i,
  input cyc_i,
  input [14:0] adr_i,
  input stb_i,
  input select,
  output [31:0] dat_o,
  output ack_o);

wire [31:0] rom_readdata, rom2_readdata;

assign dat_o = (select ? rom2_readdata : rom_readdata);
assign ack_o = rom_ack[1];

// only need one cycle for reading onboard memory
reg [1:0] rom_ack;

always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i)
    rom_ack <= 2'b0;
  else begin
    if (!stb_i)
      rom_ack <= 2'b0;
    else
      rom_ack <= { rom_ack[0], cyc_i & stb_i };
  end
end

monitor rom0(.clock(clk_i), .q(rom_readdata), .rden(cyc_i & stb_i), .address(adr_i));
testrom rom1(.clock(clk_i), .q(rom2_readdata), .rden(cyc_i & stb_i), .address(adr_i));

endmodule
