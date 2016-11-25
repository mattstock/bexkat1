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
  output reg scl,
  input clkin);

parameter clkfreq = 50000000;
parameter baud = 200000; // 4x the desired bitrate so that I can handle timing.

assign dat_o = result;
assign ack_o = (state == DONE);

wire baud_en, baudclk;

// When we run the baud clock.  If we let it free run, we can get short cycles.
assign baud_en = (state != IDLE);

localparam [4:0] IDLE = 'h0, WRITE = 'h1, WRITE2 = 'h2, WRITE3 = 'h3, WRITE4 = 'h4, READ = 'h5, READ2 = 'h6, READ3 = 'h7, READ4 = 'h8,
  START = 'h9, START2 = 'ha, START3 = 'hb, START4 = 'hc,
  STOP = 'hd, STOP2 = 'he, STOP3 = 'hf, STOP4 = 'h10, DONE = 'h11, 
  SLAVE_ACK = 'h12, SLAVE_ACK2 = 'h13, SLAVE_ACK3 = 'h14, SLAVE_ACK4 = 'h15,
  MASTER_ACK = 'h16, MASTER_ACK2 = 'h17, MASTER_ACK3 = 'h18, MASTER_ACK4 = 'h19, SLAVE_NAK ='h1a;

reg [4:0] state, state_next;
reg [31:0] result, result_next;
reg [7:0] addr, addr_next, data, data_next, txbyte, txbyte_next, rxbyte, rxbyte_next;
reg scl_next;
reg tx_next;
reg err, err_next;
reg mack, mack_next;
reg [3:0] bcnt, bcnt_next;

always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i) begin
    state <= IDLE;
    addr <= 8'h0;
	 data <= 8'h0;
    result <= 32'h0;
	 tx <= 1'h1;
	 scl <= 1'h1;
	 bcnt <= 4'h0;
	 txbyte <= 8'h0;
	 rxbyte <= 8'h0;
	 err <= 1'b0;
	 mack <= 1'b0;
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
	 mack <= mack_next;
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
  mack_next = mack;
  case (state)
    IDLE: begin
      if (cyc_i & stb_i) begin
        case (adr_i)
          2'h0: begin
            if (we_i) begin
				  if (sel_i[2])
				    mack_next = dat_i[16];
              if (sel_i[1])
                addr_next = dat_i[15:8];
				  if (sel_i[0])
				    data_next = dat_i[7:0];
            end else
              result_next = { 16'h0, addr, rxbyte };
            state_next = DONE;
          end
			 2'h1: begin
			   if (we_i) begin
				  if (sel_i[0]) begin
				    case (dat_i[1:0])
					   2'h0: state_next = START;
						2'h1: state_next = STOP;
						2'h2: begin
						  bcnt_next = 4'h7;
						  tx_next = 1'b1;
						  state_next = READ;
						end
						2'h3: begin
						  bcnt_next = 4'h7;
						  txbyte_next = data;
						  state_next = WRITE;
						end
				    endcase
				  end else
				    state_next = DONE;
				end else begin
				  result_next = { 27'h0, mack, scl, rx, tx, err };
				  state_next = DONE;
				end
			 end
			 default: state_next = DONE;
        endcase
      end
    end
	 START: begin // start or restart
	   err_next = 1'b0;
	   scl_next = 1'b1;
	   tx_next = 1'b1;
	   if (baudclk) // we should also test for bus in use
		  state_next = START2;
	 end
	 START2: begin
	   if (baudclk) begin
	     tx_next = 1'b0;
		  state_next = START3;
		end
    end
	 START3: begin
		if (baudclk)
		  state_next = START4;
    end
	 START4: begin
		if (baudclk) begin
		  scl_next = 1'h0;
		  bcnt_next = 4'h7;
		  txbyte_next = addr;
		  state_next = WRITE;
	   end
    end
	 WRITE: begin // start of low
 	   if (baudclk) begin
		  tx_next = txbyte[bcnt];
		  state_next = WRITE2;
		end
    end
	 WRITE2: begin // low
	   if (baudclk) begin
		  scl_next = 1'h1;
		  state_next = WRITE3;
		end
	 end
	 WRITE3: begin // start of high
	   if (baudclk) begin
		  state_next = WRITE4;
		end
    end
	 WRITE4: begin // high
	   if (baudclk) begin
		  scl_next = 1'h0;
		  bcnt_next = bcnt - 1'b1;
		  state_next = (bcnt ? WRITE : SLAVE_ACK);
		end
    end
	 SLAVE_ACK: begin
	   tx_next = 1'b1;
		if (baudclk) begin
		  state_next = SLAVE_ACK2;
		end
    end
	 SLAVE_ACK2: begin
	   if (baudclk) begin
		  scl_next = 1'h1;
		  state_next = SLAVE_ACK3;
		end
	 end
	 SLAVE_ACK3: begin
	   if (baudclk) begin
		  state_next = SLAVE_ACK4;
		end
    end
	 SLAVE_ACK4: begin
	   if (baudclk) begin
		  scl_next = 1'h0;
	     state_next = (rx ? SLAVE_NAK : DONE);
		end
	 end
	 SLAVE_NAK: begin
	   err_next = 1'b1;
	   state_next = DONE;
	 end
	 STOP: begin
	   tx_next = 1'b0;
		if (baudclk) begin
		  state_next = STOP2;
		end
	 end
	 STOP2: begin
		if (baudclk) begin
		  scl_next = 1'b1;
		  state_next = STOP3;
		end
	 end
	 STOP3: begin
	   if (baudclk) begin
		  tx_next = 1'b1;
		  state_next = STOP4;
		end
	 end
	 STOP4: begin
	   if (baudclk) begin
		  state_next = DONE;
		end
	 end
    READ: begin
	   if (baudclk) begin
		  state_next = READ2;
		end
    end
	 READ2: begin
	   if (baudclk) begin
		  scl_next = 1'b1;
		  state_next = READ3;
		end
	 end
	 READ3: begin
	   if (baudclk) begin
		  rxbyte_next = { rxbyte[6:0], rx };
		  state_next = READ4;
		end
	 end
	 READ4: begin
	   if (baudclk) begin
		  state_next = (bcnt ? READ : MASTER_ACK);
		  bcnt_next = bcnt - 1'b1;
		  scl_next = 1'b0;
		end
	 end
	 MASTER_ACK: begin
	   if (baudclk) begin
		  tx_next = mack;
		  state_next = MASTER_ACK2;
		end
    end
	 MASTER_ACK2: begin
		if (baudclk) begin
		  scl_next = 1'h1;
	     state_next = MASTER_ACK3;
		end
    end
    MASTER_ACK3: begin
	   if (baudclk & clkin) begin
		  state_next = MASTER_ACK4;
		end
    end
	 MASTER_ACK4: begin
	   if (baudclk) begin
		  scl_next = 1'h0;
		  state_next = DONE;
		end
	 end
    DONE: state_next = IDLE;
  endcase
end

baudgen #(.clkfreq(clkfreq), .baud(baud)) txbaud(.clk_i(clk_i), .enable(baud_en), .baudclk(baudclk));

endmodule
