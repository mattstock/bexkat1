module adapt32to16(
  input clk_i,
  input rst_i,
  input s_cyc_i,
  input s_we_i,
  input [20:0] s_adr_i,
  input [3:0] s_sel_i,
  input [31:0] s_dat_i,
  output [31:0] s_dat_o,
  input s_stb_i,
  output s_ack_o,
  output reg m_cyc_o,
  output m_we_o,
  output [21:0] m_adr_o,
  output reg [1:0] m_sel_o,
  input [15:0] m_dat_i,
  output [15:0] m_dat_o,
  output reg m_stb_o,
  input m_ack_i);

// This assumes big endian
  
assign m_we_o = s_we_i;
assign s_ack_o = (state == STATE_DONE);
assign m_adr_o = { s_adr_i, wordadr };
assign s_dat_o = result;
assign wordadr = (state == STATE_W1);
assign m_cyc_o = (state == STATE_W0) | (state == STATE_W1);
assign m_stb_o = (state == STATE_W0) | (state == STATE_W1);
assign m_sel_o = ((state == STATE_W0) ? s_sel_i[3:2] : s_sel_i[1:0]);
assign m_dat_o = ((state == STATE_W0) ? s_dat_i[31:16] : s_dat_i[15:0]);

localparam [2:0] STATE_IDLE = 3'h0, STATE_W0 = 3'h1, STATE_W0I = 3'h2, STATE_W1 = 3'h3, STATE_DONE = 3'h4;

logic [31:0] result, result_next;
logic wordadr;
logic [2:0] state, state_next;

always_ff @(posedge clk_i or posedge rst_i)
begin
  if (rst_i)
    begin
      result <= 32'h0;
      state <= STATE_IDLE;
    end
  else
    begin
      result <= result_next;
      state <= state_next;
    end
end


always_comb
begin
  result_next = result;
  state_next = state;
  case (state)
    STATE_IDLE: if (s_cyc_i && s_stb_i) state_next = STATE_W0;
    STATE_W0:
      begin
        if (s_we_i && (s_sel_i[3:2] == 2'b0)) state_next = STATE_W1;
        if (m_ack_i)
          begin
            if (!s_we_i)
              result_next[31:16] = m_dat_i;
            state_next = STATE_W0I;
          end
      end
    STATE_W0I: state_next = STATE_W1;
    STATE_W1:
      begin
        if (s_we_i && (s_sel_i[1:0] == 2'b0)) state_next = STATE_W1;
        if (m_ack_i)
          begin
            if (!s_we_i)
              result_next[15:0] = m_dat_i;
            state_next = STATE_DONE;
          end
      end
    STATE_DONE: state_next = STATE_IDLE;
  endcase 
end
  
endmodule
