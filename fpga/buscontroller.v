module buscontroller(
  input clock,
  input reset_n,
  input [31:0] cpu_address,
  input [31:0] vga_address,
  input cpu_read,
  input vga_read,
  input cpu_write,
  input [3:0] cpu_be,
  input [31:0] cpu_writedata,
  input [1:0] map,
  output [31:0] address,
  output read,
  output write,
  output cpu_wait,
  output vga_wait,
  output start,
  output burst,
  output burst_adv,
  output [3:0] be,
  output [31:0] writedata,
  output [9:0] chipselect);
  
reg [3:0] delay, delay_next;
reg [9:0] cs;
reg [1:0] state, state_next;
reg [1:0] grant, grant_next;

localparam [1:0] STATE_IDLE = 2'b00, STATE_START = 2'b01, STATE_PRE = 2'b10, STATE_POST = 2'b11;
localparam MASTER_CPU = 1'b0, MASTER_VGA = 1'b1;

assign burst = 1'b0;
assign burst_adv = 1'b0;

assign write = (grant[MASTER_CPU] ? cpu_write : 1'b0);
assign read = (grant[MASTER_CPU] ? cpu_read : 1'b0) | (grant[MASTER_VGA] ? vga_read : 1'b0);
assign be = (grant[MASTER_CPU] ? cpu_be : 4'b0000) | (grant[MASTER_VGA] ? 4'b1111 : 4'b0000);
assign writedata = (grant[MASTER_CPU] ? cpu_writedata : 0);
assign address = (grant[MASTER_CPU] ? cpu_address : 0) | (grant[MASTER_VGA] ? vga_address : 0);
assign cpu_wait = (grant[MASTER_CPU] ? (state != STATE_POST) : 1'b1);
assign vga_wait = (grant[MASTER_VGA] ? (state != STATE_POST) : 1'b1);
assign chipselect = (state != STATE_IDLE ? cs : 10'h00);
assign start = (state == STATE_START);

always @(posedge clock or negedge reset_n)
begin
  if (!reset_n) begin
    state <= STATE_IDLE;
    delay <= 4'h0;
    grant <= 2'b00;
  end else begin
    state <= state_next;
    delay <= delay_next;
    grant <= grant_next;
  end
end

always @*
begin
  case (map)
    2'b11:
      if (address >= 32'h00000000 && address <= 32'h00003fff)
        cs = 10'b0001000000; // 4k x 32 internal RAM
      else if (address >= 32'h00004000 && address <= 32'h000fffff)
        cs = 10'b0000000001; // 1M x 32 SSRAM
      else if (address >= 32'h00800000 && address <= 32'h008007ff)
        cs = 10'b0000100000; // LED matrix
      else if (address >= 32'h00800800 && address <= 32'h00800807)
        cs = 10'b0000010000; // UART 0
      else if (address >= 32'h00800808 && address <= 32'h0080080f)
        cs = 10'b0000001000; // UART 1
      else if (address >= 32'h00800810 && address <= 32'h00800813)
        cs = 10'b0000000100; // SW
      else if (address >= 32'h00800814 && address <= 32'h0080081f)
        cs = 10'b0000000010; // Encoder
      else if (address >= 32'h00800c00 && address <= 32'h00800cff)
        cs = 10'b0100000000; // LCD
      else if (address >= 32'hffffc000 && address <= 32'hffffffbf)
        cs = 10'b0010000000; // 4k x 32 internal ROM
      else if (address >= 32'hffffffc0 && address <= 32'hffffffff)
        cs = 10'b1000000000; // interrupt vectors
      else
        cs = 10'b0000000000;
    default:
      if (address >= 32'h00000000 && address <= 32'h000fffff)
        cs = 10'b0000000001; // 1M x 32 SSRAM
      else if (address >= 32'h00800000 && address <= 32'h008007ff)
        cs = 10'b0000100000; // LED matrix
      else if (address >= 32'h00800800 && address <= 32'h00800807)
        cs = 10'b0000010000; // UART 0
      else if (address >= 32'h00800808 && address <= 32'h0080080f)
        cs = 10'b0000001000; // UART 1
      else if (address >= 32'h00800810 && address <= 32'h00800813)
        cs = 10'b0000000100; // SW
      else if (address >= 32'h00800814 && address <= 32'h0080081f)
        cs = 10'b0000000010; // Encoder
      else if (address >= 32'h00800c00 && address <= 32'h00800cff)
        cs = 10'b0100000000; // LCD
      else if (address >= 32'hffff8000 && address <= 32'hffffbfff)
        cs = 10'b0001000000; // 4k x 32 internal RAM
      else if (address >= 32'hffffc000 && address <= 32'hffffffbf)
        cs = 10'b0010000000; // 4k x 32 internal ROM
      else if (address >= 32'hffffffc0 && address <= 32'hffffffff)
        cs = 10'b1000000000; // interrupt vectors
      else
        cs = 10'b0000000000;
  endcase
end

always @*
begin
  state_next = state;
  delay_next = delay;
  grant_next = grant;
  case (state)
    STATE_IDLE: begin
      if (cpu_read | cpu_write) begin
        state_next = STATE_START;
        grant_next[MASTER_CPU] = 1'b1;
      end else if (vga_read) begin
        state_next = STATE_START;
        grant_next[MASTER_VGA] = 1'b1;
      end
    end
    STATE_START: begin
      delay_next = 4'h0;
      if (grant[MASTER_CPU] && (cpu_read || cpu_write))
        state_next = STATE_PRE;
      else if (grant[MASTER_VGA] && vga_read)
        state_next = STATE_PRE;
      else begin
        grant_next = 2'b00;
        state_next = STATE_IDLE;
      end
    end
    STATE_PRE: begin
      if (delay == 4'h0)
        state_next = STATE_POST;
      else begin
        if (grant[MASTER_CPU] && ~(cpu_read | cpu_write)) begin
          delay_next = 4'h0;
          grant_next = 2'b00;
          state_next = STATE_IDLE;
        end else if (grant[MASTER_VGA] && ~vga_read) begin
          delay_next = 4'h0;
          grant_next = 2'b00;
          state_next = STATE_IDLE;
        end else
          delay_next = delay - 1'b1;
      end
    end
    STATE_POST: begin
      if (grant[MASTER_CPU] && ~(cpu_read | cpu_write)) begin
        grant_next = 2'b00;
        state_next = STATE_IDLE;
      end else if (grant[MASTER_VGA] && ~vga_read) begin
        grant_next = 2'b00;
        state_next = STATE_IDLE;
      end
    end
  endcase
end

endmodule
