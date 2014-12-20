module led_matrix(clk, rst_n, rgb_a, rgb_b, rgb_c, rgb0, rgb1, rgb_stb, rgb_clk, oe_n, data_in, data_out, address, write);

input clk;
input rst_n;
output rgb_a, rgb_b, rgb_c;
output [2:0] rgb0, rgb1;
output rgb_stb;
output rgb_clk;
output oe_n;
input [15:0] data_in;
input [9:0] address;
output [15:0] data_out;
input write;

wire [2:0] lp = phase[2:0]-1'b1;
wire r,g,b;
wire [31:0] buffer;
wire ab;

assign r = (phase[9:2] < buffer[15:8]);
assign g = (phase[9:2] < buffer[7:0]);
assign b = (phase[9:2] < buffer[31:24]);
assign ab = (state == STATE_READ1);

assign rgb_a = lp[0];
assign rgb_b = lp[1];
assign rgb_c = lp[2];
assign rgb_stb = (state == STATE_LATCH);
assign rgb_clk = (state == STATE_CLOCK);
assign oe_n = (state == STATE_LATCH || state == STATE_BLANK1 || state == STATE_BLANK2);

parameter [7:0] DELAY = 8'h20;

localparam STATE_IDLE = 3'b000, STATE_READ1 = 3'b001, STATE_READ2 = 3'b010, STATE_CLOCK = 3'b011, STATE_LATCH = 3'b100, STATE_BLANK1 = 3'b101, STATE_BLANK2 = 3'b111;

reg [9:0] phase, phase_next;
reg [2:0] rgb0, rgb0_next, rgb1, rgb1_next;
reg [4:0] colpos, colpos_next;
reg [2:0] state, state_next;
reg [7:0] delay, delay_next;

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    rgb0 <= 1'b0;
    rgb1 <= 1'b0;
    delay <= 8'h00;
    state <= STATE_IDLE;
    phase <= 10'h0;
    colpos <= 4'h0;
  end else begin
    phase <= phase_next;
    state <= state_next;
    delay <= delay_next;
    rgb0 <= rgb0_next;
    rgb1 <= rgb1_next;
    colpos <= colpos_next;
  end
end

always @*
begin
  state_next = state;
  rgb0_next = rgb0;
  rgb1_next = rgb1;
  phase_next = phase;
  colpos_next = colpos;
  delay_next = delay;
  case (state)
    STATE_IDLE: begin
      state_next = STATE_READ1;
    end
    STATE_READ1: begin
      rgb0_next = {r,g,b};
      state_next = STATE_READ2;
    end
    STATE_READ2: begin
      rgb1_next = {r,g,b};
      state_next = STATE_CLOCK;
    end
    STATE_CLOCK: begin
      colpos_next = colpos + 1'b1;
      if (colpos == 5'b11111) begin
        state_next = STATE_BLANK1;
        delay_next = DELAY;
      end else
        state_next = STATE_IDLE;
    end
    STATE_BLANK1: begin
      if (delay == 8'h00)
        state_next = STATE_LATCH;
      else
        delay_next = delay - 1'b1;
    end
    STATE_LATCH: begin
      state_next = STATE_BLANK2;
      phase_next = phase + 1'b1;
      delay_next = DELAY;
    end
    STATE_BLANK2: begin
      if (delay == 8'h00)
        state_next = STATE_IDLE;
      else
        delay_next = delay - 1'b1;
    end
  endcase
end

matrixmem m0(.clock(clk), .data_b(data_in), .wren_b(write), .address_b(address), .q_b(data_out), .wren_a(1'b0), .q_a(buffer), .address_a({ab, phase[2:0], colpos}));
endmodule
