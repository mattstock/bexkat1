module led_matrix(
  input clk_i,
  input rst_i,
  input [31:0] dat_i,
  output [31:0] dat_o,
  input [8:0] adr_i,
  input [3:0] sel_i,
  input we_i,
  input stb_i,
  input cyc_i,
  output ack_o,
  output [2:0] demux,
  output reg [2:0] matrix0,
  output reg [2:0] matrix1,
  output matrix_stb,
  output matrix_clk,
  output oe_n);
  
wire r,g,b;
wire led_clk, select;
wire [23:0] buffer, matrixmem_out;

wire [7:0] r_level, g_level, b_level;

reg [1:0] ack_delay;

always @(posedge clk_i) ack_delay <= {ack_delay[0], cyc_i & stb_i };

assign select = cyc_i & stb_i;
assign ack_o = ack_delay[1];
assign dat_o = { 8'h00, matrixmem_out };

assign r_level = buffer[23:16];
assign g_level = buffer[15:8];
assign b_level = buffer[7:0];

assign r = r_level[pwmval];
assign g = g_level[pwmval];
assign b = b_level[pwmval];
assign matrix_stb = (state == STATE_LATCH);
assign matrix_clk = (state == STATE_CLOCK);
assign oe_n = ~(state == STATE_DELAY);

localparam STATE_IDLE = 3'h0, STATE_READ1 = 3'h1, STATE_READ2 = 3'h2, STATE_CLOCK = 3'h3, STATE_LATCH = 3'h4, STATE_DELAY = 3'h5;

reg [2:0] matrix0_next, matrix1_next;
reg [2:0] state, state_next;
reg ab, ab_next;
reg [4:0] colpos, colpos_next;
reg [2:0] rowpos, rowpos_next;
reg [2:0] pwmval, pwmval_next; 
reg [7:0] delay, delay_next;

assign demux = rowpos;

always @(posedge led_clk or posedge rst_i)
begin
  if (rst_i) begin
    matrix0 <= 1'b0;
    matrix1 <= 1'b0;
    state <= STATE_IDLE;
    colpos <= 5'h0;
    rowpos <= 3'h0;
    ab <= 1'b0;
    pwmval <= 3'h7;
    delay <= 8'h00;
  end else begin
    state <= state_next;
    matrix0 <= matrix0_next;
    matrix1 <= matrix1_next;
    colpos <= colpos_next;
    rowpos <= rowpos_next;
    ab <= ab_next;
    pwmval <= pwmval_next;
    delay <= delay_next;
  end
end

always @*
begin
  state_next = state;
  matrix0_next = matrix0;
  matrix1_next = matrix1;
  colpos_next = colpos;
  rowpos_next = rowpos;
  ab_next = ab;
  pwmval_next = pwmval;
  delay_next = delay;
  case (state)
    STATE_IDLE: begin
      state_next = STATE_READ1;
      ab_next = ~ab;
    end
    STATE_READ1: begin
      state_next = STATE_READ2;
      ab_next = ~ab;
      matrix0_next = {r,g,b};      
    end
    STATE_READ2: begin
      matrix1_next = {r,g,b};
      state_next = STATE_CLOCK;
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
      pwmval_next = pwmval - 1'b1;
      case (pwmval)
        3'h7: delay_next = 8'hff;
        3'h6: delay_next = 8'h80;
        3'h5: delay_next = 8'h40;
        3'h4: delay_next = 8'h20;
        3'h3: delay_next = 8'h10;
        3'h2: delay_next = 8'h08;
        3'h1: delay_next = 8'h04;
        3'h0: delay_next = 8'h02;
      endcase
    end
    STATE_DELAY: begin
      if (delay == 8'h00) begin
        if (pwmval == 3'h0)
          rowpos_next = rowpos + 1'b1;
        state_next = STATE_IDLE;
      end else
        delay_next = delay - 1'h1;
    end
  endcase
end

matrixmem m0(.clock_a(led_clk), .clock_b(clk_i), .data_b(dat_i[23:0]), .wren_b(select&we_i), .address_b(adr_i), .byteena_b(sel_i[2:0]),
  .q_b(matrixmem_out), .wren_a(1'b0), .q_a(buffer), .address_a({ab, rowpos, colpos}));
matrixpll pll1(.inclk0(clk_i), .areset(rst_i), .c0(led_clk));
  
endmodule
