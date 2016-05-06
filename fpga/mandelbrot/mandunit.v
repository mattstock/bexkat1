module mandunit(
  input clk_i,
  input rst_i,
  input cyc_i,
  input stb_i,
  input we_i,
  output ack_o,
  input [3:0] sel_i,
  input [2:0] adr_i,
  input [31:0] dat_i,
  output [31:0] dat_o);

  
localparam [3:0] STATE_IDLE = 4'h0, STATE_MEMOP = 4'h1, STATE_DONE = 4'h2, STATE_PUSH = 4'h3, STATE_POP = 4'h4,
  STATE_EVAL = 4'h5, STATE_EVAL2 = 4'h6, STATE_INGEST = 4'h7,
  STATE_COMPARE = 4'h8, STATE_COMPARE2 = 4'h9, STATE_COMPARE3 = 4'ha;

reg [3:0] state, state_next;
reg [31:0] values[4:0];
reg [31:0] values_next[4:0];
reg [31:0] result, result_next;
reg complete_read, complete_write, processing_read, processing_write,  pixel_write;
reg m_trigger, pixel_read, result_complete;
reg [223:0] pixel, pixel_next;

wire [8:0] complete_used;
wire [31:0] m_x0, m_y0, m_xn, m_yn, m_loop, m_result, m_x0i, m_y0i;
wire [31:0] p_x0, p_y0, p_xn, p_yn, p_loop, p_result, p_x0i, p_y0i;
wire [31:0] c_x0, c_y0, c_loop, c_x0i, c_y0i;
wire [31:0] pixel_x0, pixel_y0, pixel_xn, pixel_yn, pixel_loop, pixel_x0i, pixel_y0i;
wire active, pixel_empty, processing_empty;

assign ack_o = (state == STATE_DONE);
assign active = (cyc_i && stb_i);
assign dat_o = result;
assign pixel_write = (state == STATE_EVAL2 || state == STATE_PUSH);
assign processing_read = (state == STATE_IDLE && !processing_empty);
assign m_trigger = (state == STATE_INGEST);
assign pixel_read = (state == STATE_IDLE && !pixel_empty);

always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i)
    begin
      state <= STATE_IDLE;
      for (int i=0; i < 5; i = i+1)
        values[i] <= 32'h0;
      result <= 32'h0;
      pixel <= 160'h0;
    end
  else
    begin
      state <= state_next;
      for (int i=0; i < 5; i = i+1)
        values[i] <= values_next[i];
      result <= result_next;
      pixel <= pixel_next;
    end
end

always @*
begin
  state_next = state;  
  for (int i=0; i < 5; i = i+1)
    values_next[i] = values[i];
  result_next = result;
  pixel_next = pixel;
  
  complete_read = 1'b0;
  complete_write = 1'b0;
  
  case (state)
    STATE_IDLE:
      begin
        if (!processing_empty)
          state_next = STATE_COMPARE;
        else
          if (!pixel_empty)
            state_next = STATE_INGEST;
          else
            if (active)
              state_next = STATE_MEMOP;
      end
    STATE_MEMOP:
      begin
        if (adr_i != 3'h7)
          begin
            if (we_i)
              values_next[adr_i[2:0]] = dat_i;
            else
              result_next = values[adr_i[2:0]];
            state_next = STATE_DONE;
          end
        else
          begin
            if (we_i)
              begin
                if (dat_i[0])
                  begin
                    pixel_next = { values[0], values[1], values[0], values[1], 32'h1, values[2], values[3] };
                    state_next = STATE_PUSH;
                  end
                else
                  begin
                    complete_read = 1'b1;
                    state_next = STATE_POP;
                  end
              end
            else
              begin
                result_next = complete_used;
                state_next = STATE_DONE;
              end
          end
      end
    STATE_COMPARE: state_next = STATE_COMPARE2;
    STATE_COMPARE2: state_next = STATE_COMPARE3;
    STATE_COMPARE3: state_next = STATE_EVAL;
    STATE_EVAL:
      begin
        if (p_loop == 9'd256 || result_complete)
          begin
            complete_write = 1'b1;
            state_next = STATE_IDLE;
          end
        else
          begin
            pixel_next = { p_x0, p_y0, p_xn, p_yn, p_loop + 1'b1, p_x0i, p_y0i };
            state_next = STATE_EVAL2;
          end
      end
    STATE_INGEST: state_next = STATE_IDLE;
    STATE_EVAL2: state_next = STATE_IDLE;
    STATE_PUSH: state_next = STATE_DONE;
    STATE_POP:
      begin
        values_next[0] = c_x0;
        values_next[1] = c_y0;
        values_next[2] = c_x0i;
        values_next[3] = c_y0i;
        values_next[4] = c_loop;
        state_next = STATE_DONE;
      end
    STATE_DONE: state_next = STATE_IDLE;
    default: state_next = STATE_IDLE;
  endcase
end

mand_fifo_in fifo0(.clock(clk_i), .aclr(rst_i), .data(pixel),
  .q({pixel_x0, pixel_y0, pixel_xn, pixel_yn, pixel_loop, pixel_x0i, pixel_y0i}),
  .wrreq(pixel_write), .rdreq(pixel_read), .empty(pixel_empty));
  
mandelbrot mand0(.clk_i(clk_i), .rst_i(rst_i),
  .load({m_trigger, pixel_loop, pixel_x0i, pixel_y0i, pixel_x0, pixel_y0}),
  .xn(pixel_xn), .yn(pixel_yn),
  .store({processing_write, m_loop, m_x0i, m_y0i, m_x0, m_y0}),
  .xnext(m_xn), .ynext(m_yn), .result(m_result));

mand_fifo fifo1(.clock(clk_i), .aclr(rst_i), .data({m_x0, m_y0, m_xn, m_yn, m_loop, m_result, m_x0i, m_y0i}),
  .q({p_x0, p_y0, p_xn, p_yn, p_loop, p_result, p_x0i, p_y0i}),
  .wrreq(processing_write), .rdreq(processing_read), .empty(processing_empty));
  
mand_fifo_out fifo2(.clock(clk_i), .aclr(rst_i),
  .data({p_x0, p_y0, p_x0i, p_y0i, p_loop}),
  .q({c_x0, c_y0, c_x0i, c_y0i, c_loop}),
  .wrreq(complete_write), .rdreq(complete_read), .usedw(complete_used));

mand_comp comp0(.clock(clk_i), .dataa(p_result), .datab(32'h40800000), .agb(result_complete));

endmodule
