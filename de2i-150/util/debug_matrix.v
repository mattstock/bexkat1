module debug_matrix(
  input clk_i,
  input rst_i,
  input [31:0] o0,
  input [31:0] o1,
  input [31:0] o2,
  input [31:0] o3,
  input [31:0] o4,
  input [31:0] o5,
  input [31:0] o6,
  input [31:0] o7,
  input [31:0] o8,
  input [31:0] o9,
  input [31:0] o10,
  input [31:0] o11,
  input [31:0] o12,
  input [31:0] o13,
  input [31:0] o14,
  input [31:0] o15,
  output [2:0] demux,
  output logic [2:0] matrix0,
  output logic [2:0] matrix1,
  output matrix_stb,
  output matrix_clk,
  output oe_n);

logic [2:0] matrix0_next, matrix1_next;
logic [4:0] colpos, colpos_next;
logic [2:0] rowpos, rowpos_next;
logic [3:0] state, state_next;
logic [7:0] delay, delay_next;
logic [31:0] buf0, buf1;

wire r,g,b;
wire led_clk;
wire [31:0] val0, val1;

localparam STATE_IDLE = 3'h0, STATE_READ = 3'h1, STATE_CLOCK = 3'h2, STATE_LATCH = 3'h3, STATE_DELAY = 3'h4;

assign matrix_stb = (state == STATE_LATCH);
assign matrix_clk = (state == STATE_CLOCK);
assign oe_n = ~(state == STATE_DELAY);

always_comb
begin
  case (rowpos)
    3'h0: begin val0 = o0; val1 = o8; end
    3'h1: begin val0 = o1; val1 = o9; end
    3'h2: begin val0 = o2; val1 = o10; end
    3'h3: begin val0 = o3; val1 = o11; end
    3'h4: begin val0 = o4; val1 = o12; end
    3'h5: begin val0 = o5; val1 = o13; end
    3'h6: begin val0 = o6; val1 = o14; end
    3'h7: begin val0 = o7; val1 = o15; end  
  endcase
end

assign demux = rowpos;

always @(posedge led_clk or posedge rst_i)
begin
  if (rst_i) begin
    matrix0 <= 1'b0;
    matrix1 <= 1'b0;
    state <= STATE_IDLE;
    colpos <= 5'h0;
    rowpos <= 3'h0;
	 delay <= 8'hff;
	 buf0 <= 32'h0;
	 buf1 <= 32'h0;
  end else begin
    state <= state_next;
    matrix0 <= matrix0_next;
    matrix1 <= matrix1_next;
    colpos <= colpos_next;
    rowpos <= rowpos_next;
	 delay <= delay_next;
	 buf0 <= val0;
	 buf1 <= val1;
  end
end

always_comb
begin
  state_next = state;
  matrix0_next = matrix0;
  matrix1_next = matrix1;
  colpos_next = colpos;
  rowpos_next = rowpos;
  delay_next = delay;
  case (state)
    STATE_IDLE: state_next = STATE_READ;
    STATE_READ: begin
      state_next = STATE_CLOCK;
      matrix0_next = (buf0[5'h1f-colpos] ? 3'b011 : 3'b000); 
      matrix1_next = (buf1[5'h1f-colpos] ? 3'b011 : 3'b000);
      colpos_next = colpos + 1'b1;
    end
    STATE_CLOCK: begin
      if (colpos == 5'h00)
        state_next = STATE_LATCH;
      else
        state_next = STATE_IDLE;
    end
    STATE_LATCH: begin
      state_next = STATE_DELAY;
      delay_next = 8'h80;
    end
    STATE_DELAY: begin
      if (delay == 8'h00) begin
        rowpos_next = rowpos + 1'b1;
        state_next = STATE_IDLE;
      end else
        delay_next = delay - 1'h1;
    end
  endcase
end

matrixpll pll1(.inclk0(clk_i), .areset(rst_i), .c0(led_clk));

  
endmodule
