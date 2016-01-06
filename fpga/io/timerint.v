module timerint(
  input clk_i,
  input rst_i,
  output [3:0] interrupt,
  input we_i,
  input cyc_i,
  input stb_i,
  input [3:0] sel_i,
  output ack_o,
  input [3:0] adr_i,
  input [31:0] dat_i,
  output [31:0] dat_o);
    
assign dat_o = result;
assign ack_o = (state == STATE_DONE);
assign interrupt = { status[3] & control[7], status[2] & control[6], status[1] & control[5], status[0] & control[4] };

localparam [1:0] STATE_IDLE = 2'h0, STATE_BUSY = 2'h1, STATE_DONE = 2'h2;

logic [31:0] control, control_next, counter, counter_next, result, result_next, status, status_next;
logic [31:0] compareval [3:0], compareval_next [3:0];
logic [31:0] counterval [3:0], counterval_next [3:0];
logic [1:0] state, state_next;

always_ff @(posedge clk_i, posedge rst_i)
  begin
    if (rst_i) begin
      for (int i=0; i < 4; i = i + 1)
      begin
        counterval[i] <= 32'h0;
        compareval[i] <= 32'h0;
      end
      control <= 32'h0;
      counter <= 32'h0;
      result <= 32'h0;
      status <= 32'h0;
      state <= STATE_IDLE;
    end else begin
      for (int i=0; i < 4; i = i + 1)
      begin
        counterval[i] <= counterval_next[i];
        compareval[i] <= compareval_next[i];
      end
      control <= control_next;
      status <= status_next;
      counter <= counter + 1'h1;
      result <= result_next;
      state <= state_next;
    end
  end

always_comb
begin
  for (int i=0; i < 4; i = i + 1)
    begin
      counterval_next[i] = counterval[i];
      compareval_next[i] = compareval[i];
    end
  control_next = control;
  result_next = result;
  status_next = status;
  state_next = state;

  case (state)
    STATE_IDLE: begin
      if (cyc_i & stb_i)
        state_next = STATE_BUSY;
    end
    STATE_BUSY: begin
      casex (adr_i)
        4'b0000: begin
          if (we_i)
            begin
              control_next[7:0] = (sel_i[0] ? dat_i[7:0] : control[7:0]);
              control_next[15:8] = (sel_i[1] ? dat_i[15:8] : control[15:8]);
              control_next[23:16] = (sel_i[2] ? dat_i[23:16] : control[23:16]);
              control_next[31:24] = (sel_i[3] ? dat_i[31:24] : control[31:24]);
            end
          else
            result_next = control;
        end
        4'b0001: begin
          if (we_i)
            begin
              status_next[7:0] = (sel_i[0] ? dat_i[7:0] : status[7:0]);
              status_next[15:8] = (sel_i[1] ? dat_i[15:8] : status[15:8]);
              status_next[23:16] = (sel_i[2] ? dat_i[23:16] : status[23:16]);
              status_next[31:24] = (sel_i[3] ? dat_i[31:24] : status[31:24]);
            end
          else
            result_next = status;
        end
        4'b01xx: begin
          if (we_i)
            begin
              compareval_next[adr_i[1:0]][7:0] = (sel_i[0] ? dat_i[7:0] : compareval[adr_i[1:0]][7:0]);
              compareval_next[adr_i[1:0]][15:8] = (sel_i[1] ? dat_i[15:8] : compareval[adr_i[1:0]][15:8]);
              compareval_next[adr_i[1:0]][23:16] = (sel_i[2] ? dat_i[23:16] : compareval[adr_i[1:0]][23:16]);
              compareval_next[adr_i[1:0]][31:24] = (sel_i[3] ? dat_i[31:24] : compareval[adr_i[1:0]][31:24]);
            end
          else
            result_next = compareval[adr_i[1:0]];
        end
        4'b10xx: begin
          if (we_i)
            begin
              counterval_next[adr_i[1:0]][7:0] = (sel_i[0] ? dat_i[7:0] : counterval[adr_i[1:0]][7:0]);
              counterval_next[adr_i[1:0]][15:8] = (sel_i[1] ? dat_i[15:8] : counterval[adr_i[1:0]][15:8]);
              counterval_next[adr_i[1:0]][23:16] = (sel_i[2] ? dat_i[23:16] : counterval[adr_i[1:0]][23:16]);
              counterval_next[adr_i[1:0]][31:24] = (sel_i[3] ? dat_i[31:24] : counterval[adr_i[1:0]][31:24]);
            end
          else
            result_next = counterval[adr_i[1:0]];
        end
        4'b1100: result_next = counter;
        default: result_next = 32'h0;
      endcase
      state_next = STATE_DONE;
    end
    STATE_DONE: state_next = STATE_IDLE;
    default: state_next = STATE_IDLE;
  endcase

  // Handle any new timer events
  for (int i=0; i < 4; i = i + 1)
    if (control[i] & (compareval[i] == counter))
      begin
        status_next[i] = 1'b1;
        counterval_next[i] = counterval[i] + 1'b1;
      end
end

endmodule // timerint
