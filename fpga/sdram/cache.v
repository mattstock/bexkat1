module cache(
  input clk_i,
  input rst_i,
  input s_cyc_i,
  input s_we_i,
  input [BUSWIDTH-1:0] s_adr_i,
  input [3:0] s_sel_i,
  input [WORDSIZE-1:0] s_dat_i,
  output logic [WORDSIZE-1:0] s_dat_o,
  output [1:0] cache_status,
  input stats_stb_i,
  input s_stb_i,
  output s_ack_o,
  output logic m_cyc_o,
  output logic m_we_o,
  output logic [BUSWIDTH-1:0] m_adr_o,
  output logic [3:0] m_sel_o,
  input [WORDSIZE-1:0] m_dat_i,
  output [WORDSIZE-1:0] m_dat_o,
  output logic m_stb_o,
  input m_ack_i);
  

// for my own sanity
localparam TAGSIZE = 'd13;
localparam BUSWIDTH = 'd25;
localparam INDEXSIZE = BUSWIDTH-TAGSIZE-'d2;
localparam WORDSIZE = 'd32;
localparam ROWWIDTH = 'd4;
// 2 bits for valid and lru
localparam ROWSIZE = 'd2 + ROWWIDTH + TAGSIZE + ROWWIDTH*WORDSIZE;

localparam LRU = 'd146, VALID = 'd145, 
  DIRTY0 = 'd141, DIRTY1 = 'd142,
  DIRTY2 = 'd143, DIRTY3 = 'd144;
localparam [1:0] BUS_STATE_IDLE = 'h0, BUS_STATE_DONE = 'h1, BUS_STATE_READ_WAIT = 'h2, BUS_STATE_READ = 'h3;
localparam [4:0] STATE_IDLE = 5'h0, STATE_BUSY = 5'h1, STATE_HIT = 5'h2, STATE_MISS = 5'h3,
  STATE_FILL = 5'h4, STATE_FILL2 = 5'h5, STATE_FILL3 = 5'h6, STATE_FILL4 = 5'h7, STATE_FILL5 = 5'h8,
  STATE_FLUSH = 5'h9, STATE_FLUSH2 = 5'ha, STATE_FLUSH3 = 5'hb, STATE_FLUSH4 = 5'hc, STATE_FLUSH5 = 5'hd,
  STATE_DONE = 5'he, STATE_INIT = 5'hf, STATE_BUSY2 = 5'h10;


logic [WORDSIZE-1:0] s_dat_o_next;
logic [4:0] state, state_next;
logic [INDEXSIZE-1:0] initaddr, initaddr_next;
logic [31:0] hitreg, hitreg_next;
logic [31:0] flushreg, flushreg_next;
logic [31:0] fillreg, fillreg_next;
logic [1:0] bus_state, bus_state_next;
logic [ROWSIZE-1:0] rowin [1:0], rowin_next [1:0];
logic lruset, lruset_next;
logic hitset, hitset_next;

wire [TAGSIZE-1:0] tag_in;
wire [TAGSIZE-1:0] tag_cache [1:0];
wire [ROWSIZE-1:0] rowout [1:0];
wire [INDEXSIZE-1:0] rowaddr;
wire [1:0] wordsel;
wire [ROWWIDTH-1:0] dirty [1:0];
wire [1:0] valid, wren, hit, lru;
wire anyhit;
wire [WORDSIZE-1:0] word0 [1:0], word1 [1:0], word2 [1:0], word3 [1:0];
wire fifo_empty, fifo_full, fifo_write;
wire [WORDSIZE-1:0] fifo_dat_i;
wire [BUSWIDTH-1:0] fifo_adr_i;
wire [3:0] fifo_sel_i;
wire fifo_we_i;
wire mem_stb;
wire fifo_read = (state == STATE_IDLE & ~fifo_empty);
wire [61:0] fifo_out;

assign fifo_write = (bus_state == BUS_STATE_IDLE) & ~fifo_full & s_cyc_i & s_stb_i & ~stats_stb_i;
assign cache_status = hit;
assign tag_in = fifo_adr_i[24:12];
assign rowaddr = fifo_adr_i[11:2];
assign wordsel = fifo_adr_i[1:0];
assign { fifo_we_i, fifo_adr_i, fifo_dat_i, fifo_sel_i } = fifo_out;
assign m_stb_o = m_cyc_o;
assign m_sel_o = 4'hf;
assign s_ack_o = (bus_state == BUS_STATE_DONE);
assign anyhit = |hit;

always_comb
begin
  for (int i=0; i < 2; i = i + 1)
  begin
    lru[i] = rowout[i][LRU];
    valid[i] = rowout[i][VALID];
    dirty[i] = rowout[i][DIRTY3:DIRTY0];
    tag_cache[i] = rowout[i][140:128];
    word3[i] = rowout[i][127:96];
    word2[i] = rowout[i][95:64];
    word1[i] = rowout[i][63:32];
    word0[i] = rowout[i][31:0];
    hit[i] = (tag_cache[i] == tag_in) & valid[i];
  end
end

always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i) begin
    state <= STATE_INIT;
	 bus_state <= BUS_STATE_IDLE;
	 for (int i=0; i < 2; i = i + 1)
	   rowin[i] <= 'h0;
    s_dat_o <= 32'h0;
    initaddr <= 10'h3ff;
	 hitreg <= 32'h0;
	 flushreg <= 32'h0;
	 fillreg <= 32'h0;
	 hitset <= 1'h0;
	 lruset <= 1'h0;
  end else begin
    bus_state <= bus_state_next;
    state <= state_next;
	 for (int i=0; i < 2; i = i + 1)
	   rowin[i] <= rowin_next[i];
    s_dat_o <= s_dat_o_next;
    initaddr <= initaddr_next;
	 hitreg <= hitreg_next;
	 flushreg <= flushreg_next;
	 fillreg <= fillreg_next;
	 hitset <= hitset_next;
	 lruset <= lruset_next;
  end
end

always_comb
begin
  bus_state_next = bus_state;
  case (bus_state)
    BUS_STATE_IDLE: begin
      if (s_cyc_i & s_stb_i)
		  if (~fifo_full | stats_stb_i)
		      bus_state_next = (s_we_i ? BUS_STATE_DONE : BUS_STATE_READ_WAIT);
    end
	 BUS_STATE_READ_WAIT: begin // reads need to block until all transactions are complete
	   if (fifo_empty & state == STATE_DONE)
		  bus_state_next = BUS_STATE_DONE;
	 end
	 BUS_STATE_DONE: bus_state_next = BUS_STATE_IDLE;
  endcase
end
 

always_comb
begin
  state_next = state;
  for (int i=0; i < 2; i = i + 1) begin
	 rowin_next[i] = rowin[i];
	 wren[i] = 1'b0;
  end
  initaddr_next = initaddr;
  s_dat_o_next = s_dat_o;
  hitreg_next = hitreg;
  flushreg_next = flushreg;
  fillreg_next = fillreg;
  lruset_next = lruset;
  hitset_next = hitset;
  m_we_o = 1'h0;
  m_cyc_o = 1'h0;
  m_dat_o = 32'h0;
  m_adr_o = 25'h0;
  
  case (state)
    STATE_INIT: begin
      for (int i=0; i < 2; i = i + 1) begin
	     rowin_next[i][VALID] = 1'b0;
	     wren[i] = 1'b1;
      end
      initaddr_next = initaddr - 1'b1;
      if (initaddr == 10'h00)
        state_next = STATE_IDLE;
    end
	 STATE_IDLE: begin
	   if (s_cyc_i & s_stb_i & stats_stb_i) begin
        case (s_adr_i[3:0])
		    'h0: s_dat_o_next = hitreg;
		    'h1: s_dat_o_next = flushreg;
		    'h2: s_dat_o_next = fillreg;
		    default: s_dat_o_next = 32'h0;
		  endcase
		  state_next = STATE_DONE;
	   end else  
	     if (~fifo_empty) state_next = STATE_BUSY;
	 end
    STATE_BUSY: state_next = STATE_BUSY2;
	 STATE_BUSY2: begin
		for (int i=0; i < 2; i = i + 1)
        rowin_next[i] = rowout[i];
		hitset_next = hit[1];
		lruset_next = lru[1];
	   state_next = (anyhit ? STATE_HIT : STATE_MISS);
    end
    STATE_HIT: begin
	   if (hitset) begin
		  rowin_next[1][LRU] = 1'b0;
		  rowin_next[0][LRU] = 1'b1;
		end else begin
		  rowin_next[0][LRU] = 1'b0;
		  rowin_next[1][LRU] = 1'b1;
		end
      if (fifo_we_i) begin
        case (wordsel)
          2'h0: begin
            rowin_next[hitset][DIRTY0] = 1'b1;
            rowin_next[hitset][7:0] = (fifo_sel_i[0] ? fifo_dat_i[7:0] : word0[hitset][7:0]);
            rowin_next[hitset][15:8] = (fifo_sel_i[1] ? fifo_dat_i[15:8] : word0[hitset][15:8]);
            rowin_next[hitset][23:16] = (fifo_sel_i[2] ? fifo_dat_i[23:16] : word0[hitset][23:16]);
            rowin_next[hitset][31:24] = (fifo_sel_i[3] ? fifo_dat_i[31:24] : word0[hitset][31:24]);
          end
          2'h1: begin
            rowin_next[hitset][DIRTY1] = 1'b1;
            rowin_next[hitset][39:32] = (fifo_sel_i[0] ? fifo_dat_i[7:0] : word1[hitset][7:0]);
            rowin_next[hitset][47:40] = (fifo_sel_i[1] ? fifo_dat_i[15:8] : word1[hitset][15:8]);
            rowin_next[hitset][55:48] = (fifo_sel_i[2] ? fifo_dat_i[23:16] : word1[hitset][23:16]);
            rowin_next[hitset][63:56] = (fifo_sel_i[3] ? fifo_dat_i[31:24] : word1[hitset][31:24]);
          end
          2'h2: begin
            rowin_next[hitset][DIRTY2] = 1'b1;
            rowin_next[hitset][71:64] = (fifo_sel_i[0] ? fifo_dat_i[7:0] : word2[hitset][7:0]);
            rowin_next[hitset][79:72] = (fifo_sel_i[1] ? fifo_dat_i[15:8] : word2[hitset][15:8]);
            rowin_next[hitset][87:80] = (fifo_sel_i[2] ? fifo_dat_i[23:16] : word2[hitset][23:16]);
            rowin_next[hitset][95:88] = (fifo_sel_i[3] ? fifo_dat_i[31:24] : word2[hitset][31:24]);
          end
          2'h3: begin
            rowin_next[hitset][DIRTY3] = 1'b1;
            rowin_next[hitset][103:96] = (fifo_sel_i[0] ? fifo_dat_i[7:0] : word3[hitset][7:0]);
            rowin_next[hitset][111:104] = (fifo_sel_i[1] ? fifo_dat_i[15:8] : word3[hitset][15:8]);
            rowin_next[hitset][119:112] = (fifo_sel_i[2] ? fifo_dat_i[23:16] : word3[hitset][23:16]);
            rowin_next[hitset][127:120] = (fifo_sel_i[3] ? fifo_dat_i[31:24] : word3[hitset][31:24]);
          end
        endcase
      end else begin
        case (wordsel)
          2'h0: s_dat_o_next = word0[hitset];
          2'h1: s_dat_o_next = word1[hitset];
          2'h2: s_dat_o_next = word2[hitset];
          2'h3: s_dat_o_next = word3[hitset];
        endcase
      end
		hitreg_next = hitreg + 1'h1;
      state_next = STATE_DONE;
    end
    STATE_DONE: begin
      if (~stats_stb_i)
		  for (int i=0; i < 2; i = i + 1)
          wren[i] = 1'h1;
      state_next = STATE_IDLE;
    end
    STATE_MISS: begin
	   rowin_next[lruset][140:128] = tag_in;
      state_next = (valid[lruset] & |dirty[lruset]  ? STATE_FLUSH : STATE_FILL);
    end
    STATE_FILL: begin
	   if (lruset) begin
		  rowin_next[1][LRU] = 1'b0;
		  rowin_next[0][LRU] = 1'b1;
		end else begin
		  rowin_next[0][LRU] = 1'b0;
		  rowin_next[1][LRU] = 1'b1;
		end
      rowin_next[lruset][VALID] = 1'b1;
      rowin_next[lruset][DIRTY0] = 1'b0; // clean
      m_adr_o = { tag_in, rowaddr, 2'h0 };
      m_cyc_o = 1'b1;
      rowin_next[lruset][31:0] = m_dat_i;
      if (m_ack_i)
        state_next = STATE_FILL2;
    end
    STATE_FILL2: begin
      m_cyc_o = 1'b1;
      rowin_next[lruset][DIRTY1] = 1'b0; // clean
      rowin_next[lruset][63:32] = m_dat_i;
      if (m_ack_i)
        state_next = STATE_FILL3;
    end
    STATE_FILL3: begin
      m_cyc_o = 1'b1;
      rowin_next[lruset][DIRTY2] = 1'b0; // clean
      rowin_next[lruset][95:64] = m_dat_i;
      if (m_ack_i)
        state_next = STATE_FILL4;
    end
    STATE_FILL4: begin
      m_cyc_o = 1'b1;
      rowin_next[lruset][DIRTY3] = 1'b0; // clean
      rowin_next[lruset][127:96] = m_dat_i;
      if (m_ack_i)
        state_next = STATE_FILL5;
    end
    STATE_FILL5: begin
	   for (int i=0; i < 2; i = i + 1)
        wren[i] = 1'b1;
		fillreg_next = fillreg + 1'h1;
      state_next = STATE_BUSY;
    end
    STATE_FLUSH: begin
      m_adr_o = { tag_cache[lruset], rowaddr, 2'h0 };
      m_dat_o = word0[lruset];
      m_cyc_o = 1'b1;
      m_we_o = 1'b1;
      if (m_ack_i) state_next = STATE_FLUSH2;
    end
    STATE_FLUSH2: begin
      m_dat_o = word1[lruset];
      m_cyc_o = 1'b1;
      m_we_o = 1'b1;
      if (m_ack_i) state_next = STATE_FLUSH3;
    end
    STATE_FLUSH3: begin
      m_dat_o = word2[lruset];
      m_cyc_o = 1'b1;
      m_we_o = 1'b1;
      if (m_ack_i) state_next = STATE_FLUSH4;
    end
    STATE_FLUSH4: begin
      m_dat_o = word3[lruset];
      m_cyc_o = 1'b1;
      m_we_o = 1'b1;
      if (m_ack_i) state_next = STATE_FLUSH5;
    end
    STATE_FLUSH5: begin
		flushreg_next = flushreg + 1'h1;
      state_next = STATE_FILL;
    end
    default: state_next = STATE_IDLE;
  endcase
end

cachemem cmem0(.clock(clk_i), .aclr(rst_i), .address((state == STATE_INIT ? initaddr : rowaddr)), .wren(wren[0]), .data(rowin[0]), .q(rowout[0]));
cachemem cmem1(.clock(clk_i), .aclr(rst_i), .address((state == STATE_INIT ? initaddr : rowaddr)), .wren(wren[1]), .data(rowin[1]), .q(rowout[1]));
cachefifo cfifo0(.clock(clk_i), .aclr(rst_i), .rdreq(fifo_read), .wrreq(fifo_write), .data({s_we_i, s_adr_i, s_dat_i, s_sel_i}),
  .full(fifo_full), .empty(fifo_empty), .q(fifo_out));
 
endmodule
