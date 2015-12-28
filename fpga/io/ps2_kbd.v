module ps2_kbd(
  input clk_i,
  input rst_i,
  input ps2_clock,
  input ps2_data,
  input we_i,
  input cyc_i,
  input stb_i,
  input [3:0] sel_i,
  output ack_o,
  input adr_i,
  input [31:0] dat_i,
  output [31:0] dat_o);
    
assign dat_o = result;
assign ack_o = (state == STATE_DONE);
  
reg sclr, sclr_next;
reg [10:0] eventbuf, eventbuf_next;
reg [2:0] clk_reg;
reg [2:0] data_reg, state, state_next, tstate, tstate_next;
reg [3:0] count, count_next;
reg [31:0] result, result_next;
reg [9:0] mapval, mapval_next;

localparam [2:0] STATE_IDLE = 3'h0, STATE_BUSY = 3'h1, STATE_READ = 3'h2,
  STATE_READ2 = 3'h3, STATE_DONE = 3'h4;

wire [9:0] kbdval;
wire [5:0] usedw;
wire ps2_clock_falling = (clk_reg[2:1] == 2'b10);
wire ps2_clock_rising = (clk_reg[2:1] == 2'b01);
wire kbd_data = data_reg[1];
wire [7:0] event_data = eventbuf[8:1]; // STOP, PARITY, 8 x DATA, START
wire event_ready = (count == 4'h0) && ps2_clock_rising;
wire full;

// 0: r/w next byte on the queue
// 1: status register (read is number of bytes in read queue)

always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i) begin
    result <= 32'h0;
    sclr <= 1'b0;
    state <= STATE_IDLE;
  end else begin
    result <= result_next;
    sclr <= sclr_next;
    state <= state_next;
  end
end

always @(*)
begin
  state_next = state;
  result_next = result;
  sclr_next = sclr;
  
  case (state)
    STATE_IDLE: if (cyc_i && stb_i) state_next = STATE_BUSY;
    STATE_BUSY: begin
      case (adr_i)
        1'h0: state_next = (we_i ? STATE_DONE : STATE_READ);
        1'h1: begin
          if (~we_i)
            result_next = { 25'h0, full, usedw };
          else
            sclr_next = dat_i[0];
          state_next = STATE_DONE;
        end
      endcase
    end
    STATE_READ: state_next = STATE_READ2;
    STATE_READ2: begin
      result_next = { 22'h0, kbdval };
      state_next = STATE_DONE;
    end
    STATE_DONE: begin
      state_next = STATE_IDLE;
      sclr_next = 1'b0;
    end
  endcase
end

// Bottom half
always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i) begin
    eventbuf <= 11'h0;
    count <= 4'h0;
    clk_reg <= 3'h0;
    data_reg <= 3'h0;
    mapval <= 10'h0;
    tstate <= STATE_IDLE;
  end else begin
    eventbuf <= eventbuf_next;
    count <= count_next;
    clk_reg <= {clk_reg[1:0], ps2_clock};
    data_reg <= {data_reg[1:0], ps2_data};
    mapval <= mapval_next;
    tstate <= tstate_next;
  end
end

always @(*)
begin
  eventbuf_next = eventbuf;
  count_next = count;
  mapval_next = mapval;
  tstate_next = tstate;
  if (ps2_clock_falling) begin
    if (count == 4'ha)
      count_next = 4'h0;
    else
      count_next = count + 1'b1;
    eventbuf_next = {kbd_data, eventbuf[10:1]};
  end
  
  case (tstate)
    STATE_IDLE: begin
      if (event_ready) begin
        tstate_next = STATE_BUSY;
        mapval_next[7:0] = event_data;
      end
    end
    STATE_BUSY: begin
      case (mapval[7:0])
        8'hf0: begin
          mapval_next[9] = 1'b1;
          tstate_next = STATE_IDLE;
        end
        8'he0: begin
          mapval_next[8] = 1'b1;
          tstate_next = STATE_IDLE;
        end
        default: begin
          mapval_next[7:0] = event_data;
          tstate_next = STATE_DONE;
        end
      endcase
    end
    STATE_DONE: begin
      mapval_next[9:8] = 2'b00;
      tstate_next = STATE_IDLE;
    end
  endcase
end

ps2_kbd_fifo fifo0(.clock(clk_i), .aclr(rst_i), .sclr(sclr), .full(full), .q(kbdval), .rdreq(state == STATE_READ),
  .wrreq(tstate == STATE_DONE), .data(mapval), .usedw(usedw));

endmodule
