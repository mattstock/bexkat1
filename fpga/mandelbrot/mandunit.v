module mandunit(
  input clk_i,
  input rst_i,
  input cyc_i,
  input stb_i,
  input we_i,
  output ack_o,
  input [3:0] sel_i,
  input [3:0] adr_i,
  input [31:0] dat_i,
  output [31:0] dat_o);

  
localparam [2:0] STATE_IDLE = 3'h0, STATE_MEMOP = 3'h1, STATE_DONE = 3'h2, STATE_COMMAND = 3'h3, STATE_POP = 3'h4, STATE_CRASH = 3'h5;

reg [2:0] state, state_next;
reg [31:0] values[7:0];
reg [31:0] values_next[7:0];
reg trigger, active;
reg fifo_push, fifo_pop;

wire [159:0] fifo_out;
wire [31:0] x0, y0, xn, yn, xn1, yn1, x0next, y0next, mand_result;
wire [31:0] xn1_f, yn1_f, result_f, x0_f, y0_f;
wire fifo_full, fifo_empty;
wire [9:0] fifo_used;

assign ack_o = (state == STATE_DONE);
assign active = (cyc_i && stb_i);
assign { x0_f, y0_f, xn1_f, yn1_f, result_f } = fifo_out;
assign dat_o = values[5];

always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i) begin
    state <= STATE_IDLE;
    for (int i=0; i < 8; i = i+1)
      values[i] <= 32'h0;
  end else begin
    state <= state_next;
    for (int i=0; i < 8; i = i+1)
      values[i] <= values_next[i];
  end
end

always @*
begin
  state_next = state;  
  for (int i=0; i < 8; i = i+1)
    values_next[i] = values[i];
  trigger = 1'b0;
  fifo_pop = 1'b0;
  
  case (state)
    STATE_IDLE: begin
      if (active && adr_i[3] == 1'h0)
        state_next = STATE_MEMOP;
      if (active && adr_i[3] == 1'h1)
        state_next = STATE_COMMAND;
    end
    STATE_MEMOP: begin
      if (we_i)
        values_next[adr_i[2:0]] = dat_i;
      else
        values_next[5] = values[adr_i[2:0]];
      state_next = STATE_DONE;
    end
    STATE_COMMAND: begin
      case (adr_i[2:0])
        3'h0: begin // command write push initial data
          if (we_i)
            trigger = 1'b1;
          state_next = STATE_DONE;
        end
        3'h1: begin // command write pop result
          if (we_i && !fifo_empty)
            fifo_pop = 1'b1;
          values_next[5] = fifo_used;
          state_next = STATE_POP;
        end
        default: state_next = STATE_DONE;
      endcase
    end
    STATE_POP: begin
      values_next[0] = x0_f;
      values_next[1] = y0_f;
      values_next[2] = xn1_f;
      values_next[3] = yn1_f;
      values_next[4] = result_f;
      state_next = STATE_DONE;
    end
    STATE_DONE: state_next = STATE_IDLE;
    STATE_CRASH: state_next = STATE_CRASH;
    default: state_next = STATE_IDLE;
  endcase
end

mandelbrot mand0(.clock(clk_i), .x0(values[0]), .y0(values[1]), .xn(values[2]), .yn(values[3]),
  .xnext(xn1), .ynext(yn1), .result(mand_result), .trigger(trigger), .complete(fifo_push),
  .x0next(x0next), .y0next(y0next));

mand_fifo fifo0(.clock(clk_i), .aclr(rst_i),  .data({x0next, y0next, xn1, yn1, mand_result}), .q(fifo_out),
  .wrreq(fifo_push), .rdreq(fifo_pop), .empty(fifo_empty), .usedw(fifo_used));
  
endmodule
