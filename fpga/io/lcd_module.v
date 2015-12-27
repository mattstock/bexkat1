module lcd_module(input clk_i,
		  input rst_i,
		  input we_i,
		  input stb_i,
		  input [3:0] sel_i,
		  input cyc_i,
		  input [1:0] adr_i,
      output ack_o,
		  output reg [31:0] dat_o,
		  input [31:0] dat_i,
		  output reg e,
		  output reg [7:0] data_out,
		  output reg on,
		  output reg rw,
		  output reg rs);

assign ack_o = (state == 1'b1);

reg on_next, rs_next, rw_next, e_next;
reg [31:0] dat_o_next;
reg state, state_next, op, op_next;
reg [4:0] seq, seq_next;
reg [7:0] data_out_next;

// w   0x0: on/off
// w   0x1: send command
// w   0x2: init
// r   0x0: read on/off
// r   0x2: busy
// w/r 0x3: screen pos

always @(posedge clk_i or posedge rst_i)
  begin
    if (rst_i) begin
      on <= 1'b0;
      dat_o <= 'h0;
      state <= 1'b0;
      dat_o <= 8'h00;
      rw <= 1'b1;
      rs <= 1'b1;
      op <= 1'b0;
      e <= 1'b0;
      seq <= 5'h0;
    end else begin
      on <= on_next;
      dat_o <= dat_o_next;
      state <= state_next;
      data_out <= data_out_next;
      rw <= rw_next;
      op <= op_next;
      e <= e_next;
      rs <= rs_next;
      seq <= seq_next;
    end
  end

always @(*)
  begin
    on_next = on;
    op_next = op;
    data_out_next = data_out;
    state_next = state;
    dat_o_next = dat_o;
    e_next = e;
    rw_next = rw;
    rs_next = rs;
    seq_next = seq;
    
    if (state == 1'b0) begin
	    if (cyc_i && stb_i) begin
	      case (adr_i)
	        2'h0: begin
	          if (we_i)
              on_next = dat_i[0];
            else
              dat_o_next = { 7'h00, op, 7'h0, on };
          end
          2'h1: begin
            if (we_i) begin
              rs_next = 1'b0;
              rw_next = 1'b0;
              op_next = 1'b1;
              data_out_next = dat_i[7:0];
            end else
              dat_o_next = 32'h0;
          end
          default: begin
            if (we_i) begin
              rs_next = 1'b1;
              rw_next = 1'b0;
              op_next = 1'b1;
              data_out_next = dat_i[7:0];
            end else
              dat_o_next = 32'h0;
          end
        endcase
        state_next = 1'b1;
      end
    end else
      state_next = 1'b0;

    if (op) begin
      case (seq)
        5'h03: begin
          e_next = 1'b1;
          seq_next = seq + 1'h1;
        end
        5'h10: begin
          e_next = 1'b0;
          seq_next = seq + 1'h1;
        end
        5'h11: begin
          seq_next = 5'h0;
          rw_next = 1'b1;
          op_next = 1'b0;
        end
        default: seq_next = seq + 1'h1; 
      endcase
    end
  end // always @ (*)

endmodule
