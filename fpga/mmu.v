module mmu(
  input clock,
  input reset_n,
  input read,
  input write,
  input [31:0] address,
  input map,
  output buswait,
  output buswrite,
  output busfault,
  output start,
  output [3:0] chipselect);
  
reg [3:0] cs;
reg [1:0] state, state_next;

localparam [1:0] STATE_IDLE = 2'b00, STATE_START = 2'b01, STATE_PRE = 2'b10, STATE_POST = 2'b11;

assign chipselect = (read || write ? cs : 4'h0);
assign busfault = (read || write) && (cs == 4'h0);
assign start = (state == STATE_START);
assign buswrite = (state == STATE_PRE) & write;
assign buswait = (state != STATE_POST);

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
  if (map) begin
    if (address >= 32'h00000000 && address <= 32'h003fffff)
      cs = 4'h6; // 1M x 32 SSRAM
    else if (address >= 32'h00800000 && address <= 32'h008007ff)
      cs = 4'h5; // LED matrix
    else if (address >= 32'h00800800 && address <= 32'h00800fff)
      cs = 4'h4; // IO
    else if (address >= 32'he0000000 && address <= 32'hefffffff)
      cs = 4'h8; // 32M x 16 FLASH
    else if (address >= 32'hffff0000 && address <= 32'hffffffbf)
      cs = 4'h2; // 16k x 32 internal ROM
    else if (address >= 32'hffffffc0 && address <= 32'hffffffff)
      cs = 4'h1; // interrupt vectors
    else
      cs = 4'h0;
  end else begin
    if (address >= 32'h00000000 && address <= 32'h003fffff)
      cs = 4'h6; // 1M x 32 SSRAM
    else if (address >= 32'h00800000 && address <= 32'h008007ff)
      cs = 4'h5; // LED matrix
    else if (address >= 32'h00800800 && address <= 32'h00800fff)
      cs = 4'h4; // IO
    else if (address >= 32'hf0000000 && address <= 32'hffffffff)
      cs = 4'h8; // 32M x 16 FLASH
    else 
      cs = 4'h0;
  end
end

always @*
begin
  state_next = state;
  case (state)
    STATE_IDLE: begin
      if (read || write) begin
        state_next = STATE_START;
      end
    end
    STATE_START: begin // Address latching
      if (read || write)
        state_next = STATE_PRE;
      else begin
        state_next = STATE_IDLE;
      end
    end
    STATE_PRE: state_next = STATE_POST; // read or write cycle
    STATE_POST: begin // data visible
      if (!(read || write)) begin
        state_next = STATE_IDLE;
      end
    end
  endcase
end

endmodule
