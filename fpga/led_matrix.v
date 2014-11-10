module lcd_matrix(clk, rst_n, rgb_a, rgb_b, rgb_c, rgb0, rgb1, rgb_stb, rgb_clk, control);

input clk;
input rst_n;
output rgb_a, rgb_b, rgb_c;
output [2:0] rgb0, rgb1;
output rgb_stb;
output rgb_clk;
input [8:0] control;

wire [2:0] lp = phase[2:0]-1'b1;

assign rgb_a = lp[0];
assign rgb_b = lp[1];
assign rgb_c = lp[2];
assign rgb_stb = ((state == STATE_LATCH) || control[7] ? 1'b1 : 1'b0);

localparam STATE_IDLE = 2'b00, STATE_LATCH = 2'b01, STATE_RELEASE = 2'b10;

reg [31:0] freerun;
reg rgb_clk;
reg [9:0] phase, phase_next;
reg [2:0] rgb0, rgb1;
reg [4:0] tick;
reg [1:0] state, state_next;

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    freerun <= 1'b0;
    rgb_clk <= 1'b0;
    rgb0 <= 1'b0;
    rgb1 <= 1'b0;
    state <= STATE_IDLE;
    phase <= 1'b0;
  end else begin
    phase <= phase_next;
    state <= state_next;
    if (freerun < 50000000/(control[8] ? 5000000 : 1000)) begin
      freerun <= freerun + 1'b1;
    end else begin
      freerun <= 1'b0;
      rgb_clk <= ~rgb_clk;
    end
    case ({phase[2:0], tick})
      8'h24: begin
        if (phase[9:3] < control[6:0])
          rgb0 <= 3'b101;
        else
          rgb0 <= 3'b001;
        rgb1 <= 3'b000;
      end
      8'h42: begin
        rgb0 <= 3'b001;
        rgb1 <= 3'b010;
      end
      default: begin
        rgb0 <= 3'b000;
        rgb1 <= 3'b000;
      end
    endcase
  end
end

always @*
begin
  state_next = state;
  phase_next = phase;
  case (state)
    STATE_IDLE: if (tick == 5'b00000) state_next = STATE_LATCH;
    STATE_LATCH: begin
      state_next = STATE_RELEASE;
      phase_next = phase + 1'b1;
    end
    STATE_RELEASE: if (tick == 5'b00001) state_next = STATE_IDLE;
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

endmodule
