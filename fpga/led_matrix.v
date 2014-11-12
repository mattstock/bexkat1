module led_matrix(clk, rst_n, rgb_a, rgb_b, rgb_c, rgb0, rgb1, rgb_stb, rgb_clk, pixel, row, col, write);

input clk;
input rst_n;
output rgb_a, rgb_b, rgb_c;
output [2:0] rgb0, rgb1;
output rgb_stb;
output rgb_clk;
input [23:0] pixel;
input [3:0] row;
input [4:0] col;
input write;

wire [2:0] lp = phase[2:0]-1'b1;
wire r,g,b;

assign r = (phase[9:2] < buffer[23:16]);
//assign r = buffer[2];
assign g = (phase[9:2] < buffer[15:8]);
//assign g = buffer[1];
assign b = (phase[9:2] < buffer[7:0]);
//assign b = buffer[0];

assign rgb_a = lp[0];
assign rgb_b = lp[1];
assign rgb_c = lp[2];
assign rgb_stb = (state == STATE_LATCH);

localparam STATE_IDLE = 3'b000, STATE_READ1 = 3'b001, STATE_READ2 = 3'b010, STATE_READ3 = 3'b011, STATE_LATCH = 3'b100;

reg [31:0] freerun;
reg rgb_clk;
reg [9:0] phase, phase_next;
reg [2:0] rgb0, rgb0_next, rgb1, rgb1_next;
reg [4:0] tick, tick_last;
reg [2:0] state, state_next;
reg ab, ab_next;

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    freerun <= 1'b0;
    rgb_clk <= 1'b0;
    ab <= 1'b0;
    rgb0 <= 1'b0;
    rgb1 <= 1'b0;
    state <= STATE_IDLE;
    phase <= 1'b0;
    tick_last <= 1'b0;
  end else begin
    phase <= phase_next;
    state <= state_next;
    rgb0 <= rgb0_next;
    rgb1 <= rgb1_next;
    ab <= ab_next;
    tick_last <= tick;
    if (freerun < 50000000/10000000) begin
      freerun <= freerun + 1'b1;
    end else begin
      freerun <= 1'b0;
      rgb_clk <= ~rgb_clk;
    end
  end
end

always @*
begin
  state_next = state;
  rgb0_next = rgb0;
  rgb1_next = rgb1;
  phase_next = phase;
  ab_next = ab;
  case (state)
    STATE_IDLE:
      if (tick != tick_last) begin
        ab_next = 1'b0;
        state_next = STATE_READ1;
      end
    STATE_READ1: begin
      ab_next = 1'b1;
      state_next = STATE_READ2;
    end
    STATE_READ2: begin
      rgb0_next = {r,g,b};
      state_next = STATE_READ3;
    end
    STATE_READ3: begin
      rgb1_next = {r,g,b};
      if (tick == 5'b11111)
        state_next = STATE_LATCH;
      else
        state_next = STATE_IDLE;
    end
    STATE_LATCH: begin
      state_next = STATE_IDLE;
      phase_next = phase + 1'b1;
    end
  endcase
end

always @(negedge rgb_clk or negedge rst_n)
begin
  if (!rst_n) begin
    tick <= 1'b0;
  end else begin
    if (tick != 8'hff) begin
      tick <= tick + 1'b1;
    end else begin
      tick <= 1'b0;
    end
  end
end

wire [31:0] buffer;

matrixmem m0(.clock(clk), .data({ 8'h00, pixel}), .q(buffer), .wren(write), .wraddress({row,col}), .rdaddress({ab, phase[2:0], tick}));
endmodule
