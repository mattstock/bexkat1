module i2c_master(
  input clk_i,
  input rst_i,
  input [3:0] sel_i,
  input [31:0] dat_i,
  output [31:0] dat_o,
  input stb_i,
  input cyc_i,
  output ack_o,
  input we_i,
  input [1:0] adr_i,
  input rx,
  output reg tx,
  output reg scl);

parameter clkfreq = 50000000;
parameter baud = 200000; // I need 2x the bitrate to handle the transitions I want.

assign dat_o = result;
assign ack_o = (state == STATE_DONE);

wire baud_en, baudclk;

// When we run the baud clock.  If we let it free run, we can get short cycles.
assign baud_en = (state != STATE_IDLE);

localparam [3:0] STATE_IDLE = 4'h0, STATE_WRITE = 4'h1, STATE_READ = 4'h2, STATE_START = 4'h3, STATE_STOP = 4'h4, STATE_DONE = 4'h5, STATE_WRITE2 = 4'h6,
  STATE_COMPLETE = 4'h7, STATE_SLAVE_ACK = 4'h8, STATE_SLAVE_ACK2 = 4'h9, STATE_READ2 = 4'ha, STATE_MASTER_ACK = 4'hb, STATE_START2 = 4'hc, STATE_SLAVE_NAK = 4'hd;

reg [3:0] state, state_next;
reg [31:0] result, result_next;
reg [7:0] addr, addr_next, data, data_next, txbyte, txbyte_next, rxbyte, rxbyte_next;
reg scl_next;
reg tx_next;
reg err, err_next;
reg [3:0] bcnt, bcnt_next;

always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i) begin
    state <= STATE_IDLE;
    addr <= 8'h0;
	 data <= 8'h0;
    result <= 32'h0;
	 tx <= 1'h1;
	 scl <= 1'h1;
	 bcnt <= 4'h0;
	 txbyte <= 8'h0;
	 rxbyte <= 8'h0;
	 err <= 1'b0;
  end else begin
    state <= state_next;
    result <= result_next;
    addr <= addr_next;
	 data <= data_next;
	 tx <= tx_next;
	 scl <= scl_next;
	 bcnt <= bcnt_next;
	 txbyte <= txbyte_next;
	 rxbyte <= rxbyte_next;
	 err <= err_next;
  end
end

  
always @(*)
begin
  state_next = state;
  result_next = result;
  addr_next = addr;
  data_next = data;
  bcnt_next = bcnt;
  txbyte_next = txbyte;
  rxbyte_next = rxbyte;
  tx_next = tx;
  scl_next = scl;
  err_next = err;
  case (state)
    STATE_IDLE: begin
      if (cyc_i & stb_i) begin
        case (adr_i)
          2'h0: begin
            if (we_i) begin
              if (sel_i[1])
                addr_next = dat_i[15:8];
				  if (sel_i[0])
				    data_next = dat_i[7:0];
            end else
              result_next = { 16'h0, addr, rxbyte };
            state_next = STATE_DONE;
          end
			 2'h1: begin
			   if (we_i) begin
				  if (sel_i[0]) begin
				    case (dat_i[1:0])
					   2'h0: state_next = STATE_START;
						2'h1: state_next = STATE_STOP;
						2'h2: begin
						  bcnt_next = 4'h7;
						  tx_next = 1'b1;
						  state_next = STATE_READ;
						end
						2'h3: begin
						  bcnt_next = 4'h7;
						  txbyte_next = data;
						  state_next = STATE_WRITE;
						end
				    endcase
				  end else
				    state_next = STATE_DONE;
				end else begin
				  result_next = { 28'h0, scl, rx, tx, err };
				  state_next = STATE_DONE;
				end
			 end
			 default: state_next = STATE_DONE;
        endcase
      end
    end
	 STATE_START: begin // start or restart
	   err_next = 1'b0;
	   tx_next = 1'b1;
		scl_next = 1'b1;
	   if (baudclk) // we should also test for bus in use
		  state_next = STATE_START2;
	 end
	 STATE_START2: begin
	   tx_next = 1'b0;
		if (baudclk) begin
		  scl_next = 1'h0;
		  bcnt_next = 4'h7;
		  txbyte_next = addr;
		  state_next = STATE_WRITE;
	   end
    end
	 STATE_WRITE: begin // clock is low
	   tx_next = txbyte[bcnt];
 	   if (baudclk) begin
		  scl_next = 1'h1;
		  state_next = STATE_WRITE2;
		end
    end
	 STATE_WRITE2: begin // clock is high
	   if (baudclk) begin
		  scl_next = 1'h0;
		  bcnt_next = bcnt - 1'b1;
		  state_next = (bcnt ? STATE_WRITE : STATE_SLAVE_ACK);
		end
    end
	 STATE_SLAVE_ACK: begin // listen for ack
	   tx_next = 1'b1;
		if (baudclk) begin
		  scl_next = 1'h1;
		  state_next = STATE_SLAVE_ACK2;
		end
    end
	 STATE_SLAVE_ACK2: begin
	   if (baudclk) begin
		  scl_next = 1'h0;
	     state_next = (rx ? STATE_SLAVE_NAK : STATE_COMPLETE);
		end
	 end
	 STATE_SLAVE_NAK: begin
	   err_next = 1'b1;
	   state_next = STATE_COMPLETE;
	 end
	 STATE_COMPLETE: begin
	   if (baudclk) begin
		  tx_next = 1'b0;
		  state_next = STATE_DONE;
		end
	 end
	 STATE_STOP: begin
	   tx_next = 1'b0;
	   scl_next = 1'b1;
		if (baudclk) begin
		  tx_next = 1'b1;
		  state_next = STATE_DONE;
		end
	 end
    STATE_READ: begin
	   if (baudclk) begin
		  scl_next = 1'h1;
		  state_next = STATE_READ2;
		end
    end
	 STATE_READ2: begin
	   if (baudclk) begin
	     scl_next = 1'h0;
		  rxbyte_next = { rxbyte[6:0], rx };
		  bcnt_next = bcnt - 1'b1;
		  state_next = (bcnt ? STATE_READ : STATE_MASTER_ACK);
		end
	 end
	 STATE_MASTER_ACK: begin
	   tx_next = 1'h0;
		if (baudclk) begin
		  scl_next = 1'h1;
	     state_next = STATE_COMPLETE;
		end
    end
    STATE_DONE: state_next = STATE_IDLE;
  endcase
end

baudgen #(.clkfreq(clkfreq), .baud(baud)) txbaud(.clk_i(clk_i), .enable(baud_en), .baudclk(baudclk));

endmodule
