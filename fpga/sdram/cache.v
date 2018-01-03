`include "../../../fpgalib/bexkat1/bexkat1.vh"

module cache(input 	  clk_i,
	     input 	  rst_i,
	     if_wb.slave  sysbus,
	     if_wb.master rambus,
	     output [1:0] cache_status,
	     input 	  stats_stb_i);
  
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

   typedef enum 	  bit [1:0] { BS_IDLE, BS_DONE, BS_READ_WAIT, BS_READ } bs_state_t;
   typedef enum 	  bit [4:0] { S_IDLE, S_BUSY, S_HIT, S_MISS, S_FILL, S_FILL2, S_FILL3, S_FILL4, S_FILL5, S_FLUSH, S_FLUSH2, S_FLUSH3, S_FLUSH4, S_FLUSH5, S_DONE, S_INIT, S_BUSY2 } state_t;

   logic [31:0]   s_dat_o_next;
   state_t state, state_next;
   logic [INDEXSIZE-1:0]  initaddr, initaddr_next;
   logic [31:0] 	  hitreg, hitreg_next;
   logic [31:0] 	  flushreg, flushreg_next;
   logic [31:0] 	  fillreg, fillreg_next;
   bs_state_t bus_state, bus_state_next;
   logic [ROWSIZE-1:0] 	  rowin [1:0], rowin_next [1:0];
   logic 		  lruset, lruset_next;
   logic 		  hitset, hitset_next;
   
   logic [TAGSIZE-1:0] 	  tag_in;
   logic [TAGSIZE-1:0] 	  tag_cache [1:0];
   logic [ROWSIZE-1:0] 	  rowout [1:0];
   logic [INDEXSIZE-1:0]  rowaddr;
   logic [1:0] 		  wordsel;
   logic [ROWWIDTH-1:0]   dirty [1:0];
   logic [1:0] 		  valid, wren, hit, lru;
   logic 		  anyhit;
   logic [WORDSIZE-1:0]   word0 [1:0], word1 [1:0], word2 [1:0], word3 [1:0];
   logic 		  fifo_empty, fifo_full, fifo_write;
   logic [WORDSIZE-1:0]   fifo_dat_i;
   logic [BUSWIDTH-1:0] 	  fifo_adr_i;
   logic [3:0] 			  fifo_sel_i;
   logic 			  fifo_we_i;
   logic 			  mem_stb;
   logic 			  fifo_read = (state == S_IDLE & ~fifo_empty);
   logic [61:0] 		  fifo_out;

   assign fifo_write = (bus_state == BS_IDLE) & ~fifo_full &
		       sysbus.cyc & sysbus.stb & ~stats_stb_i;
   assign cache_status = hit;
   assign tag_in = fifo_adr_i[24:12];
   assign rowaddr = fifo_adr_i[11:2];
   assign wordsel = fifo_adr_i[1:0];
   assign { fifo_we_i, fifo_adr_i, fifo_dat_i, fifo_sel_i } = fifo_out;
   assign rambus.stb = sysbus.stb;
   assign rambus.sel = 4'hf;
   assign sysbus.ack = (bus_state == BS_DONE);
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

   always_ff @(posedge clk_i or posedge rst_i)
     if (rst_i)
       begin
	  state <= S_INIT;
	  bus_state <= BS_IDLE;
	  for (int i=0; i < 2; i = i + 1)
	    rowin[i] <= 'h0;
	  s_dat_o <= 32'h0;
	  initaddr <= 10'h3ff;
	  hitreg <= 32'h0;
	  flushreg <= 32'h0;
	  fillreg <= 32'h0;
	  hitset <= 1'h0;
	  lruset <= 1'h0;
       end
     else
       begin
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

   always_comb
     begin
	bus_state_next = bus_state;
	case (bus_state)
	  BS_IDLE:
	    begin
	       if (sysbus.cyc & sysbus.stb)
		 if (~fifo_full | stats_stb_i)
		   bus_state_next = (sysbus.we ? BS_DONE : BS_READ_WAIT);
	    end
	  BS_READ_WAIT: // reads need to block until all transactions are complete
	    if (fifo_empty & state == S_DONE)
	      bus_state_next = BS_DONE;
	  BS_DONE: 
	    bus_state_next = BS_IDLE;
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
	s_dat_o_next = sysbus.dat_o;
	hitreg_next = hitreg;
	flushreg_next = flushreg;
	fillreg_next = fillreg;
	lruset_next = lruset;
	hitset_next = hitset;
	rambus.we = 1'h0;
	rambus.cyc = 1'h0;
	rambus.dat_o = 32'h0;
	rambus.adr = 32'h0;
  
	case (state)
	  S_INIT: 
	    begin
	       for (int i=0; i < 2; i = i + 1)
		 begin
		    rowin_next[i][VALID] = 1'b0;
		    wren[i] = 1'b1;
		 end
	       initaddr_next = initaddr - 1'b1;
	       if (initaddr == 10'h00)
		 state_next = S_IDLE;
	    end
	  S_IDLE:
	    if (sysbus.cyc & sysbus.stb & stats_stb_i)
	      begin
		 case (sysbus.adr[3:0])
		   'h0: s_dat_o_next = hitreg;
		   'h1: s_dat_o_next = flushreg;
		   'h2: s_dat_o_next = fillreg;
		   default: s_dat_o_next = 32'h0;
		 endcase
		 state_next = S_DONE;
	      end
	    else  
	      if (~fifo_empty) state_next = S_BUSY;
	  S_BUSY: 
	    state_next = S_BUSY2;
	  S_BUSY2:
	    begin
	       for (int i=0; i < 2; i = i + 1)
		 rowin_next[i] = rowout[i];
	       hitset_next = hit[1];
	       lruset_next = lru[1];
	       state_next = (anyhit ? S_HIT : S_MISS);
	    end
	  STATE_HIT:
	    begin
	       if (hitset)
		 begin
		    rowin_next[1][LRU] = 1'b0;
		    rowin_next[0][LRU] = 1'b1;
		 end
	       else
		 begin
		    rowin_next[0][LRU] = 1'b0;
		    rowin_next[1][LRU] = 1'b1;
		 end
	       if (fifo_we_i)
		 begin
		    case (wordsel)
		      2'h0:
			begin
			   rowin_next[hitset][DIRTY0] = 1'b1;
			   rowin_next[hitset][7:0] = (fifo_sel_i[0] ? fifo_dat_i[7:0] : word0[hitset][7:0]);
			   rowin_next[hitset][15:8] = (fifo_sel_i[1] ? fifo_dat_i[15:8] : word0[hitset][15:8]);
			   rowin_next[hitset][23:16] = (fifo_sel_i[2] ? fifo_dat_i[23:16] : word0[hitset][23:16]);
			   rowin_next[hitset][31:24] = (fifo_sel_i[3] ? fifo_dat_i[31:24] : word0[hitset][31:24]);
			end
		      2'h1:
			begin
			   rowin_next[hitset][DIRTY1] = 1'b1;
			   rowin_next[hitset][39:32] = (fifo_sel_i[0] ? fifo_dat_i[7:0] : word1[hitset][7:0]);
			   rowin_next[hitset][47:40] = (fifo_sel_i[1] ? fifo_dat_i[15:8] : word1[hitset][15:8]);
			   rowin_next[hitset][55:48] = (fifo_sel_i[2] ? fifo_dat_i[23:16] : word1[hitset][23:16]);
			   rowin_next[hitset][63:56] = (fifo_sel_i[3] ? fifo_dat_i[31:24] : word1[hitset][31:24]);
			end
		      2'h2:
			begin
			   rowin_next[hitset][DIRTY2] = 1'b1;
			   rowin_next[hitset][71:64] = (fifo_sel_i[0] ? fifo_dat_i[7:0] : word2[hitset][7:0]);
			   rowin_next[hitset][79:72] = (fifo_sel_i[1] ? fifo_dat_i[15:8] : word2[hitset][15:8]);
			   rowin_next[hitset][87:80] = (fifo_sel_i[2] ? fifo_dat_i[23:16] : word2[hitset][23:16]);
			   rowin_next[hitset][95:88] = (fifo_sel_i[3] ? fifo_dat_i[31:24] : word2[hitset][31:24]);
			end
		      2'h3:
			begin
			   rowin_next[hitset][DIRTY3] = 1'b1;
			   rowin_next[hitset][103:96] = (fifo_sel_i[0] ? fifo_dat_i[7:0] : word3[hitset][7:0]);
			   rowin_next[hitset][111:104] = (fifo_sel_i[1] ? fifo_dat_i[15:8] : word3[hitset][15:8]);
			   rowin_next[hitset][119:112] = (fifo_sel_i[2] ? fifo_dat_i[23:16] : word3[hitset][23:16]);
			   rowin_next[hitset][127:120] = (fifo_sel_i[3] ? fifo_dat_i[31:24] : word3[hitset][31:24]);
			end
		    endcase
		 end
	       else
		 begin
		    case (wordsel)
		      2'h0: s_dat_o_next = word0[hitset];
		      2'h1: s_dat_o_next = word1[hitset];
		      2'h2: s_dat_o_next = word2[hitset];
		      2'h3: s_dat_o_next = word3[hitset];
		    endcase
		 end
	       hitreg_next = hitreg + 1'h1;
	       state_next = S_DONE;
	    end
	  S_DONE:
	    begin
	       if (~stats_stb_i)
		 for (int i=0; i < 2; i = i + 1)
		   wren[i] = 1'h1;
	       state_next = S_IDLE;
	    end
	  S_MISS:
	    begin
	       rowin_next[lruset][140:128] = tag_in;
	       state_next = (valid[lruset] & |dirty[lruset]  ? S_FLUSH : S_FILL);
	    end
	  S_FILL:
	    begin
	       if (lruset)
		 begin
		    rowin_next[1][LRU] = 1'b0;
		    rowin_next[0][LRU] = 1'b1;
		 end
	       else
		 begin
		    rowin_next[0][LRU] = 1'b0;
		    rowin_next[1][LRU] = 1'b1;
		 end
	       rowin_next[lruset][VALID] = 1'b1;
	       rowin_next[lruset][DIRTY0] = 1'b0; // clean
	       rambus.adr = { tag_in, rowaddr, 2'h0 };
	       rambus.cyc = 1'b1;
	       rowin_next[lruset][31:0] = rambus.dat_i;
	       if (rambus.ack)
		 state_next = S_FILL2;
	    end
	  S_FILL2:
	    begin
	       rambus.cyc = 1'b1;
	       rowin_next[lruset][DIRTY1] = 1'b0; // clean
	       rowin_next[lruset][63:32] = rambus.dat_i;
	       if (rambus.ack)
		 state_next = S_FILL3;
	    end
	  S_FILL3:
	    begin
	       rambus.cyc = 1'b1;
	       rowin_next[lruset][DIRTY2] = 1'b0; // clean
	       rowin_next[lruset][95:64] = rambus.dat_i;
	       if (rambus.ack)
		 state_next = S_FILL4;
	    end
	  S_FILL4:
	    begin
	       rambus.cyc = 1'b1;
	       rowin_next[lruset][DIRTY3] = 1'b0; // clean
	       rowin_next[lruset][127:96] = rambus.dat_i;
	       if (rambus.ack)
		 state_next = S_FILL5;
	    end
	  S_FILL5:
	    begin
	       for (int i=0; i < 2; i = i + 1)
		 wren[i] = 1'b1;
	       fillreg_next = fillreg + 1'h1;
	       state_next = S_BUSY;
	    end
	  S_FLUSH: begin
	     rambus.adr = { tag_cache[lruset], rowaddr, 2'h0 };
	     rambus.dat_o = word0[lruset];
	     rambus.cyc = 1'b1;
	     rambus.we = 1'b1;
	     if (rambus.ack)
	       state_next = S_FLUSH2;
	  end
	  S_FLUSH2:
	    begin
	       rambus.dat_o = word1[lruset];
	       rambus.cyc = 1'b1;
	       rambus.we = 1'b1;
	       if (rambus.ack)
		 state_next = S_FLUSH3;
	    end
	  S_FLUSH3: begin
	     rambus.dat_o = word2[lruset];
	     rambus.cyc = 1'b1;
	     rambus.we = 1'b1;
	     if (rambus.ack) 
	       state_next = S_FLUSH4;
	  end
	  S_FLUSH4:
	    begin
	       rambus.dat_o = word3[lruset];
	       rambus.cyc = 1'b1;
	       rambus.we = 1'b1;
	       if (rambus.ack)
		 state_next = S_FLUSH5;
	    end
	  S_FLUSH5:
	    begin
	       flushreg_next = flushreg + 1'h1;
	       state_next = S_FILL;
	    end
	  default:
	    state_next = S_IDLE;
	endcase
     end

   cachemem cmem0(.clock(clk_i), .aclr(rst_i),
		  .address((state == S_INIT ? initaddr : rowaddr)),
		  .wren(wren[0]), .data(rowin[0]), .q(rowout[0]));
   cachemem cmem1(.clock(clk_i), .aclr(rst_i),
		  .address((state == S_INIT ? initaddr : rowaddr)),
		  .wren(wren[1]), .data(rowin[1]), .q(rowout[1]));
   cachefifo cfifo0(.clock(clk_i), .aclr(rst_i),
		    .rdreq(fifo_read), .wrreq(fifo_write),
		    .data({sysbus.we,
			   sysbus.adr[26:2],
			   sysbus.dat_i,
			   sysbus.sel}),
		    .full(fifo_full), .empty(fifo_empty), .q(fifo_out));
   
endmodule
