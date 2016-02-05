module cache(
  input clk_i,
  input rst_i,
  input s_cyc_i,
  input s_we_i,
  input [ADR-1:0] s_adr_i,
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
  
parameter ADR = 21;
localparam TAGW = ADR - (8 + 2);
localparam CACHEW = (4 * 32) + TAGW + 4 + 1;

logic [CACHEW-1:0] rowin, rowin_next, rowout;

reg [31:0] s_dat_o_next;
reg [4:0] state, state_next;
reg [7:0] initaddr, initaddr_next;

wire [TAGW-1:0] tag_in, tag_cache;
wire [7:0] rowaddr;
wire [1:0] wordsel;
wire [3:0] dirty;
wire valid, wren;
wire [31:0] word0, word1, word2, word3;

localparam VALID = CACHEW-1, 
  DIRTY0 = CACHEW-5, DIRTY1 = CACHEW-4,
  DIRTY2 = CACHEW-3, DIRTY3 = CACHEW-2,
  TAG_END = CACHEW-6, TAG_START = TAG_END - TAGW + 1;

assign cache_status = { state == STATE_HIT, state == STATE_MISS };
assign { tag_in, rowaddr, wordsel } = s_adr_i;
assign { valid, dirty, tag_cache, word3, word2, word1, word0 } = rowout;

wire hit = (tag_cache == tag_in) & valid;

assign m_stb_o = m_cyc_o;
assign m_sel_o = 4'hf;
assign s_ack_o = (state == STATE_DONE);

localparam [4:0] STATE_IDLE = 5'h0, STATE_BUSY = 5'h1, STATE_HIT = 5'h2, STATE_MISS = 5'h3,
  STATE_FILL = 5'h4, STATE_FILL2 = 5'h5, STATE_FILL3 = 5'h6, STATE_FILL4 = 5'h7, STATE_FILL5 = 5'h8,
  STATE_FILL6 = 5'h9, STATE_FILL7 = 5'ha, STATE_FILL8 = 5'hb, STATE_FLUSH = 5'hc, STATE_FLUSH2 = 5'hd,
  STATE_FLUSH3 = 5'he, STATE_FLUSH4 = 5'hf, STATE_FLUSH5 = 5'h10, STATE_FLUSH6 = 5'h11, STATE_FLUSH7 = 5'h12,
  STATE_FLUSH8 = 5'h13, STATE_DONE = 5'h14, STATE_INIT = 5'h15;

always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i) begin
    state <= STATE_INIT;
    rowin <= 'h0;
    s_dat_o <= 32'h0;
    initaddr <= 8'hff;
  end else begin
    state <= state_next;
    rowin <= rowin_next;
    s_dat_o <= s_dat_o_next;
    initaddr <= initaddr_next;
  end
end

always_comb
begin
  state_next = state;
  rowin_next = rowin;
  initaddr_next = initaddr;
  s_dat_o_next = s_dat_o;
  m_we_o = 1'h0;
  m_cyc_o = 1'h0;
  m_dat_o = 32'h0;
  m_adr_o = 'h0;
  wren = 1'b0;
  
  case (state)
    STATE_INIT: begin
      rowin_next[VALID] = 1'b0;
      wren = 1'b1;
      initaddr_next = initaddr - 1'b1;
      if (initaddr == 8'h00)
        state_next = STATE_IDLE;
    end
    STATE_IDLE: begin
      if (s_cyc_i & s_stb_i)
        state_next = STATE_BUSY;
    end
    STATE_BUSY: state_next = (hit ? STATE_HIT : STATE_MISS);
    STATE_HIT: begin
      if (s_we_i) begin
        rowin_next = rowout;
        case (wordsel)
          2'h0: begin
            rowin_next[DIRTY0] = 1'b1;
            rowin_next[7:0] = (s_sel_i[0] ? s_dat_i[7:0] : word0[7:0]);
            rowin_next[15:8] = (s_sel_i[1] ? s_dat_i[15:8] : word0[15:8]);
            rowin_next[23:16] = (s_sel_i[2] ? s_dat_i[23:16] : word0[23:16]);
            rowin_next[31:24] = (s_sel_i[3] ? s_dat_i[31:24] : word0[31:24]);
          end
          2'h1: begin
            rowin_next[DIRTY1] = 1'b1;
            rowin_next[39:32] = (s_sel_i[0] ? s_dat_i[7:0] : word1[7:0]);
            rowin_next[47:40] = (s_sel_i[1] ? s_dat_i[15:8] : word1[15:8]);
            rowin_next[55:48] = (s_sel_i[2] ? s_dat_i[23:16] : word1[23:16]);
            rowin_next[63:56] = (s_sel_i[3] ? s_dat_i[31:24] : word1[31:24]);
          end
          2'h2: begin
            rowin_next[DIRTY2] = 1'b1;
            rowin_next[71:64] = (s_sel_i[0] ? s_dat_i[7:0] : word2[7:0]);
            rowin_next[79:72] = (s_sel_i[1] ? s_dat_i[15:8] : word2[15:8]);
            rowin_next[87:80] = (s_sel_i[2] ? s_dat_i[23:16] : word2[23:16]);
            rowin_next[95:88] = (s_sel_i[3] ? s_dat_i[31:24] : word2[31:24]);
          end
          2'h3: begin
            rowin_next[DIRTY3] = 1'b1;
            rowin_next[103:96] = (s_sel_i[0] ? s_dat_i[7:0] : word3[7:0]);
            rowin_next[111:104] = (s_sel_i[1] ? s_dat_i[15:8] : word3[15:8]);
            rowin_next[119:112] = (s_sel_i[2] ? s_dat_i[23:16] : word3[23:16]);
            rowin_next[127:120] = (s_sel_i[3] ? s_dat_i[31:24] : word3[31:24]);
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
      if (s_we_i)
        wren = 1'b1;
      state_next = STATE_IDLE;
    end
    STATE_MISS: begin
      state_next = (valid ? STATE_FLUSH : STATE_FILL);
    end
    STATE_FILL: begin
      rowin_next[VALID] = 1'b1;
      rowin_next[DIRTY0] = 1'b0; // clean
      rowin_next[TAG_END:TAG_START] = tag_in;
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

endmodule
