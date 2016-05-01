module mandunit(
  input clk_i,
  input rst_i,
  input cyc_i,
  input stb_i,
  input we_i,
  output ack_o,
  input [3:0] sel_i,
  input [12:0] adr_i,
  input [31:0] dat_i,
  output [31:0] dat_o);

localparam [11:0] LATENCY = 'd30; // pipeline size for the module
localparam [2:0] STATE_IDLE = 3'h0, STATE_MEMOP = 3'h1, STATE_DONE = 3'h2, STATE_MEMOP2 = 3'h3, STATE_COPROC = 3'h4;
  
// six memory blocks:
//   1024 x 32-bit FP for x0 values
//   1024 x 32-bit FP for y0 values
//   1024 x 32-bit FP for xn values
//   1024 x 32-bit FP for yn values
//   1024 x 32 bit FP for xn+1 values
//   1024 x 32 bit FP for yn+1 values
// one register:
//   enable/indicate completion of iterations

// Workflow would be:
// 1.  CPU initializes x0, y0, based on scaled pixel position.
// 2.  CPU copies x0, y0 to xn, yn during initial loop
// 3.  Logic generates results in xn+1, yn+1 memory
// 4.  CPU polls until iterations complete
// 5.  CPU reads results from xn+1, yn+1

wire [31:0] posx_out, posy_out, xn_out, yn_out, mand_xn, mand_yn, yn1_out, xn1_out;
wire [31:0] posx_bus_out, posy_bus_out, xn_bus_out, yn_bus_out, xn1_bus_out, yn1_bus_out;
wire posx_write, posy_write, yn_write, xn_write, mand_write, active, xn1_write, yn1_write;

reg [9:0] index, index_next;
reg [2:0] state, state_next;
reg [31:0] result, result_next;

assign ack_o = (state == STATE_DONE);
assign active = (cyc_i && stb_i);
assign dat_o = result;
assign posx_write = (state == STATE_MEMOP && adr_i[12:10] == 3'h0 && we_i);
assign posy_write = (state == STATE_MEMOP && adr_i[12:10] == 3'h1 && we_i);
assign xn_write = (state == STATE_MEMOP && adr_i[12:10] == 3'h2 && we_i);
assign yn_write = (state == STATE_MEMOP && adr_i[12:10] == 3'h3 && we_i);
assign xn1_write = (state == STATE_MEMOP && adr_i[12:10] == 3'h4 && we_i);
assign yn1_write = (state == STATE_MEMOP && adr_i[12:10] == 3'h5 && we_i);
assign mand_write = (index != 0);

always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i) begin
    index <= 10'h0;
    state <= STATE_IDLE;
    result <= 32'h0;
  end else begin
    index <= index_next;
    state <= state_next;
    result <= result_next;
  end
end

always @*
begin
  if (index != 10'h0)
    index_next = index - 1'b1;
  else
    index_next = 10'h0;
  state_next = state;
  result_next = result;
  
  case (state)
    STATE_IDLE: begin
      if (active && adr_i[12:10] != 3'h7)
        state_next = STATE_MEMOP;
      if (active && adr_i[12:10] == 3'h7)
        state_next = STATE_COPROC;
    end
    STATE_MEMOP: state_next = STATE_MEMOP2;
    STATE_MEMOP2: begin
      case (adr_i[12:10])
        3'h0: result_next = posx_bus_out;
        3'h1: result_next = posy_bus_out;
        3'h2: result_next = xn_bus_out;
        3'h3: result_next = yn_bus_out;
        3'h4: result_next = xn1_bus_out;
        3'h5: result_next = yn1_bus_out;
        default: result_next = 32'hdeadbeef;
      endcase
      state_next = STATE_DONE;
    end
    STATE_COPROC: begin
      if (we_i)
        index_next = 10'h3ff;
      result_next = index;
      state_next = STATE_DONE;  
    end
    STATE_DONE: begin
       state_next = STATE_IDLE;
    end
    default: state_next = STATE_IDLE;
  endcase
end

mandmem posx(.clock(clk_i), .wren_a(posx_write), .address_a(adr_i[9:0]),
  .data_a(dat_i), .byteena_a(sel_i), .q_a(posx_bus_out),
  .address_b(index), .wren_b(1'b0), .q_b(posx_out));
mandmem posy(.clock(clk_i), .wren_a(posy_write), .address_a(adr_i[9:0]),
  .data_a(dat_i), .byteena_a(sel_i), .q_a(posy_bus_out),
  .address_b(index), .wren_b(1'b0), .q_b(posy_out));
mandmem xn(.clock(clk_i), .wren_a(xn_write), .data_a(dat_i), .address_a(adr_i[9:0]), .q_a(xn_bus_out),
  .address_b(index), .data_b(32'h0), .wren_b(1'b0), .q_b(xn_out));
mandmem yn(.clock(clk_i), .wren_a(yn_write), .data_a(dat_i), .address_a(adr_i[9:0]), .q_a(yn_bus_out),
  .address_b(index), .data_b(32'h0), .wren_b(1'b0), .q_b(yn_out));
mandmem xn1(.clock(clk_i), .wren_a(xn1_write), .address_a(adr_i[9:0]), .q_a(xn1_bus_out),
  .address_b(index), .data_b(mand_xn), .wren_b(mand_write), .q_b(xn1_out));
mandmem yn1(.clock(clk_i), .wren_a(yn1_write), .address_a(adr_i[9:0]), .q_a(yn1_bus_out),
  .address_b(index), .data_b(mand_yn), .wren_b(mand_write), .q_b(yn1_out));
mandelbrot mand0(.clock(clk_i), .rst_n(~rst_i), .x0(posx_out), .y0(posy_out), .xn(xn_out), .yn(yn_out), .xn1(mand_xn), .yn1(mand_yn));

endmodule
