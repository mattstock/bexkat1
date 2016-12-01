module cache(
  input clk_i,
  input rst_i,
  input s_cyc_i,
  input s_we_i,
  input [24:0] s_adr_i,
  input [3:0] s_sel_i,
  input [31:0] s_dat_i,
  output reg [31:0] s_dat_o,
  output [1:0] cache_status,
  input s_stb_i,
  output s_ack_o,
  output reg m_cyc_o,
  output reg m_we_o,
  output reg [24:0] m_adr_o,
  output reg [3:0] m_sel_o,
  input [31:0] m_dat_i,
  output [31:0] m_dat_o,
  output reg m_stb_o,
  input m_ack_i);
  
logic [147:0] rowin, rowin_next;
wire [147:0] rowout;

reg [31:0] s_dat_o_next;
reg [4:0] state, state_next;
reg [7:0] initaddr, initaddr_next;

wire [14:0] tag_in, tag_cache;
wire [7:0] rowaddr;
wire [1:0] wordsel;
wire [3:0] dirty;
wire valid, wren;
wire [31:0] word0, word1, word2, word3;
wire fifo_empty, fifo_full;
wire [31:0] fifo_dat_i;
wire [24:0] fifo_adr_i;
wire [3:0] fifo_sel_i;
wire fifo_we_i;

localparam VALID = 'd147, 
  DIRTY0 = 'd143, DIRTY1 = 'd144,
  DIRTY2 = 'd145, DIRTY3 = 'd146;

assign cache_status = { state == STATE_HIT, state == STATE_MISS };
assign { tag_in, rowaddr, wordsel } = fifo_adr_i;
assign { valid, dirty, tag_cache, word3, word2, word1, word0 } = rowout;

wire hit = (tag_cache == tag_in) & valid;

assign m_stb_o = m_cyc_o;
assign m_sel_o = 4'hf;
assign s_ack_o = (bus_state == BUS_STATE_DONE);

localparam [4:0] STATE_IDLE = 5'h0, STATE_BUSY = 5'h1, STATE_HIT = 5'h2, STATE_MISS = 5'h3,
  STATE_FILL = 5'h4, STATE_FILL2 = 5'h5, STATE_FILL3 = 5'h6, STATE_FILL4 = 5'h7, STATE_FILL5 = 5'h8,
  STATE_FILL6 = 5'h9, STATE_FILL7 = 5'ha, STATE_FILL8 = 5'hb, STATE_FLUSH = 5'hc, STATE_FLUSH2 = 5'hd,
  STATE_FLUSH3 = 5'he, STATE_FLUSH4 = 5'hf, STATE_FLUSH5 = 5'h10, STATE_FLUSH6 = 5'h11, STATE_FLUSH7 = 5'h12,
  STATE_FLUSH8 = 5'h13, STATE_DONE = 5'h14, STATE_INIT = 5'h15, STATE_BUSY2 = 5'h16;

always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i) begin
    state <= STATE_INIT;
	 bus_state <= BUS_STATE_IDLE;
    rowin <= 148'h0;
    s_dat_o <= 32'h0;
    initaddr <= 8'hff;
  end else begin
    bus_state <= bus_state_next;
    state <= state_next;
    rowin <= rowin_next;
    s_dat_o <= s_dat_o_next;
    initaddr <= initaddr_next;
  end
end

localparam [1:0] BUS_STATE_IDLE = 'h0, BUS_STATE_DONE = 'h1, BUS_STATE_READ_WAIT = 'h2;
logic [1:0] bus_state, bus_state_next;

wire fifo_write = (bus_state == BUS_STATE_IDLE) & ~fifo_full & s_cyc_i & s_stb_i;

always_comb
begin
  bus_state_next = bus_state;
  case (bus_state)  
    BUS_STATE_IDLE: begin
      if (s_cyc_i & s_stb_i)
		  if (~fifo_full)
		    bus_state_next = (s_we_i ? BUS_STATE_DONE : BUS_STATE_READ_WAIT);
    end
	 BUS_STATE_READ_WAIT: begin // reads need to block until all transactions are complete
	   if (fifo_empty & state == STATE_DONE)
		  bus_state_next = BUS_STATE_DONE;
	 end
	 BUS_STATE_DONE: bus_state_next = BUS_STATE_IDLE;
  endcase
end
 
wire fifo_read = (state == STATE_IDLE & ~fifo_empty);
wire [61:0] fifo_out;
assign { fifo_we_i, fifo_adr_i, fifo_dat_i, fifo_sel_i } = fifo_out;

always_comb
begin
  state_next = state;
  rowin_next = rowin;
  initaddr_next = initaddr;
  s_dat_o_next = s_dat_o;
  m_we_o = 1'h0;
  m_cyc_o = 1'h0;
  m_dat_o = 32'h0;
  m_adr_o = 25'h0;
  wren = 1'b0;

  case (state)
    STATE_INIT: begin
      rowin_next[VALID] = 1'b0;
      wren = 1'b1;
      initaddr_next = initaddr - 1'b1;
      if (initaddr == 8'h00)
        state_next = STATE_IDLE;
    end
	 STATE_IDLE: if (~fifo_empty) state_next = STATE_BUSY;
    STATE_BUSY: state_next = STATE_BUSY2;
	 STATE_BUSY2: state_next = (hit ? STATE_HIT : STATE_MISS);
    STATE_HIT: begin
      if (fifo_we_i) begin
        rowin_next = rowout;
        case (wordsel)
          2'h0: begin
            rowin_next[DIRTY0] = 1'b1;
            rowin_next[7:0] = (fifo_sel_i[0] ? fifo_dat_i[7:0] : word0[7:0]);
            rowin_next[15:8] = (fifo_sel_i[1] ? fifo_dat_i[15:8] : word0[15:8]);
            rowin_next[23:16] = (fifo_sel_i[2] ? fifo_dat_i[23:16] : word0[23:16]);
            rowin_next[31:24] = (fifo_sel_i[3] ? fifo_dat_i[31:24] : word0[31:24]);
          end
          2'h1: begin
            rowin_next[DIRTY1] = 1'b1;
            rowin_next[39:32] = (fifo_sel_i[0] ? fifo_dat_i[7:0] : word1[7:0]);
            rowin_next[47:40] = (fifo_sel_i[1] ? fifo_dat_i[15:8] : word1[15:8]);
            rowin_next[55:48] = (fifo_sel_i[2] ? fifo_dat_i[23:16] : word1[23:16]);
            rowin_next[63:56] = (fifo_sel_i[3] ? fifo_dat_i[31:24] : word1[31:24]);
          end
          2'h2: begin
            rowin_next[DIRTY2] = 1'b1;
            rowin_next[71:64] = (fifo_sel_i[0] ? fifo_dat_i[7:0] : word2[7:0]);
            rowin_next[79:72] = (fifo_sel_i[1] ? fifo_dat_i[15:8] : word2[15:8]);
            rowin_next[87:80] = (fifo_sel_i[2] ? fifo_dat_i[23:16] : word2[23:16]);
            rowin_next[95:88] = (fifo_sel_i[3] ? fifo_dat_i[31:24] : word2[31:24]);
          end
          2'h3: begin
            rowin_next[DIRTY3] = 1'b1;
            rowin_next[103:96] = (fifo_sel_i[0] ? fifo_dat_i[7:0] : word3[7:0]);
            rowin_next[111:104] = (fifo_sel_i[1] ? fifo_dat_i[15:8] : word3[15:8]);
            rowin_next[119:112] = (fifo_sel_i[2] ? fifo_dat_i[23:16] : word3[23:16]);
            rowin_next[127:120] = (fifo_sel_i[3] ? fifo_dat_i[31:24] : word3[31:24]);
          end
        endcase
      end else begin
        case (wordsel)
          2'h0: s_dat_o_next = word0;
          2'h1: s_dat_o_next = word1;
          2'h2: s_dat_o_next = word2;
          2'h3: s_dat_o_next = word3;
        endcase
      end
      state_next = STATE_DONE;
    end
    STATE_DONE: begin
      if (fifo_we_i)
        wren = 1'b1;
      state_next = STATE_IDLE;
    end
    STATE_MISS: begin
      state_next = (valid ? STATE_FLUSH : STATE_FILL);
    end
    STATE_FILL: begin
      rowin_next[VALID] = 1'b1;
      rowin_next[DIRTY0] = 1'b0; // clean
      rowin_next[142:128] = tag_in;
      m_adr_o = { tag_in, rowaddr, 2'h0 };
      m_cyc_o = 1'b1;
      rowin_next[31:0] = m_dat_i;
      if (m_ack_i)
        state_next = STATE_FILL2;
    end
    STATE_FILL2: state_next = STATE_FILL3;
    STATE_FILL3: begin
      m_adr_o = { tag_in, rowaddr, 2'h1 };
      m_cyc_o = 1'b1;
      rowin_next[DIRTY1] = 1'b0; // clean
      rowin_next[63:32] = m_dat_i;
      if (m_ack_i)
        state_next = STATE_FILL4;
    end
    STATE_FILL4: state_next = STATE_FILL5;
    STATE_FILL5: begin
      m_adr_o = { tag_in, rowaddr, 2'h2 };
      m_cyc_o = 1'b1;
      rowin_next[DIRTY2] = 1'b0; // clean
      rowin_next[95:64] = m_dat_i;
      if (m_ack_i)
        state_next = STATE_FILL6;
    end
    STATE_FILL6: state_next = STATE_FILL7;
    STATE_FILL7: begin
      m_adr_o = { tag_in, rowaddr, 2'h3 };
      m_cyc_o = 1'b1;
      rowin_next[DIRTY3] = 1'b0; // clean
      rowin_next[127:96] = m_dat_i;
      if (m_ack_i)
        state_next = STATE_FILL8;
    end
    STATE_FILL8: begin
      wren = 1'b1;
      state_next = STATE_BUSY;
    end
    STATE_FLUSH: begin
      if (dirty[0]) begin
        m_adr_o = { tag_cache, rowaddr, 2'h0 };
        m_dat_o = word0;
        m_cyc_o = 1'b1;
        m_we_o = 1'b1;
        if (m_ack_i) begin
          rowin_next[DIRTY0] = 1'b0;
          state_next = STATE_FLUSH2;
        end
      end else
        state_next = STATE_FLUSH3;
    end
    STATE_FLUSH2: state_next = STATE_FLUSH3;
    STATE_FLUSH3: begin
      if (dirty[1]) begin
        m_adr_o = { tag_cache, rowaddr, 2'h1 };
        m_dat_o = word1;
        m_cyc_o = 1'b1;
        m_we_o = 1'b1;
        if (m_ack_i) begin
          rowin_next[DIRTY1] = 1'b0;
          state_next = STATE_FLUSH4;
        end
      end else
        state_next = STATE_FLUSH5;
    end
    STATE_FLUSH4: state_next = STATE_FLUSH5;
    STATE_FLUSH5: begin
      if (dirty[2]) begin
        m_adr_o = { tag_cache, rowaddr, 2'h2 };
        m_dat_o = word2;
        m_cyc_o = 1'b1;
        m_we_o = 1'b1;
        if (m_ack_i) begin
          rowin_next[DIRTY2] = 1'b0;
          state_next = STATE_FLUSH6;
        end
      end else
        state_next = STATE_FLUSH7;
    end
    STATE_FLUSH6: state_next = STATE_FLUSH7;
    STATE_FLUSH7: begin
      if (dirty[3]) begin
        m_adr_o = { tag_cache, rowaddr, 2'h3 };
        m_dat_o = word3;
        m_cyc_o = 1'b1;
        m_we_o = 1'b1;
        if (m_ack_i) begin
          rowin_next[DIRTY3] = 1'b0;
          state_next = STATE_FLUSH8;
        end
      end else begin
        state_next = STATE_FILL;
      end
    end
    STATE_FLUSH8: begin
      wren = 1'b1;
      state_next = STATE_FILL;
    end
    default: state_next = STATE_IDLE;
  endcase
end

cachemem cmem0(.clock(clk_i), .aclr(rst_i), .address((state == STATE_INIT ? initaddr : rowaddr)), .wren(wren), .data(rowin), .q(rowout));
cachefifo cfifo0(.clock(clk_i), .aclr(rst_i), .rdreq(fifo_read), .wrreq(fifo_write), .data({s_we_i, s_adr_i, s_dat_i, s_sel_i}),
  .full(fifo_full), .empty(fifo_empty), .q(fifo_out));
 
endmodule
