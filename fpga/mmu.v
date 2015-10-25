module mmu(
  input clock,
  input reset_n,
  input read_in,
  input write_in,
  input [31:0] address,
  input wait_in,
  output reg wait_out,
  output reg cache_enable,
  output reg read_out,
  output reg write_out,
  output reg fault,
  output reg [3:0] chipselect);
  
reg [1:0] state, state_next;

localparam STATE_IDLE = 2'h0, STATE_BUSOP = 2'h1, STATE_DONE= 2'h2;

always wait_out = (state != STATE_DONE);

always @(posedge clock or negedge reset_n)
begin
  if (!reset_n) begin
    state <= STATE_IDLE;
  end else begin
    state <= state_next;
  end
end

always @*
begin
  state_next = state;
  fault = 1'b0;
      if (address >= 32'h00000000 && address <= 32'h003fffff)
        chipselect = 4'h6; // 1M x 32 SSRAM
      else if (address >= 32'h00800000 && address <= 32'h008007ff)
        chipselect = 4'h5; // LED matrix
      else if (address >= 32'h00800800 && address <= 32'h00800fff) begin
        chipselect = 4'h4; // IO
        cache_enable = 1'b0;
      end else if (address >= 32'hb0000000 && address <= 32'hbfffffff) begin
        chipselect = 4'h9; // VGA
        cache_enable = 1'b0;
      end else if (address >= 32'hc0000000 && address <= 32'hcfffffff)
        chipselect = 4'h7; // SDRAM
      else if (address >= 32'hd0000000 && address <= 32'hdfffffff)
        chipselect = 4'h3; // mandelbrot
      else if (address >= 32'he0000000 && address <= 32'hefffffff)
        chipselect = 4'h8; // 32M x 16 FLASH
      else if (address >= 32'hffff0000 && address <= 32'hffffffbf)
        chipselect = 4'h2; // 16k x 32 internal ROM
      else if (address >= 32'hffffffc0 && address <= 32'hffffffff)
        chipselect = 4'h1; // interrupt vector
      else begin
        fault = 1'b1;
        chipselect = 4'h0;
      end
  read_out = 1'b0;
  write_out = 1'b0;
  cache_enable = 1'b1;
  case (state)
    STATE_IDLE: begin
      if (read_in || write_in) begin
        state_next = STATE_BUSOP;
      end
    end
    STATE_BUSOP: begin
      read_out = read_in;
      write_out = write_in;
      if (!(read_in || write_in))
        state_next = STATE_IDLE;
      else if (wait_in == 1'b0)
        state_next = STATE_DONE;
    end
    STATE_DONE: begin
      read_out = read_in;
      write_out = write_in;
      if (!(read_in || write_in))
        state_next = STATE_IDLE;
    end
    default: state_next = STATE_IDLE;
  endcase
end

endmodule
