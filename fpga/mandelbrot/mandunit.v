module mandunit(
  input clock,
  input rst_n,
  input read,
  input write,
  output wait_out,
  input [3:0] be,
  input [15:0] address,
  input [31:0] data_in,
  output [31:0] data_out);

localparam [13:0] LATENCY = 'd17; // pipeline size for the module
  
// four memory blocks:
//   128x128 x 32-bit FP for position values
//   128x128 x 32-bit FP for xn,yn values

wire [31:0] posx_out, posy_out, xn_out, yn_out, mand_xn, mand_yn;
wire [31:0] posx_bus_out, posy_bus_out, xn_bus_out, yn_bus_out;
wire posx_write, posy_write, mand_write;

reg [13:0] index, index_next;
reg [2:0] state, state_next;

assign wait_out = (state != 3'h2);

assign data_out = (address[15:14] == 2'b00 ? posx_bus_out : 'h0) |
                  (address[15:14] == 2'b01 ? posy_bus_out : 'h0) |
                  (address[15:14] == 2'b10 ? xn_bus_out : 'h0) |
                  (address[15:14] == 2'b11 ? yn_bus_out : 'h0);

always @(posedge clock or negedge rst_n)
begin
  if (!rst_n) begin
    index <= 14'h0;
    state <= 3'h0;
  end else begin
    index <= index_next;
    state <= state_next;
  end
end

always @*
begin
  index_next = index;
  state_next = state;
  
  case (state)
    'h0: begin // wait for the signal to iterate
      if (address == 16'hfffc && write)
        state_next = 'h1;
    end
    'h1: begin // run the index until we get to the end
      index_next = index + 1'b1;
      if (index == 128*128)
        state_next = 'h2;
    end
    'h2: begin // signal that we've done a pass, or maybe just keep looping until we've done 1000?
       state_next = 'h0;
    end
  endcase
end

mandmem posx(.clock(clock), .wren_a(address[15:14] == 2'b00 ? write : 1'b0), .address_a(address[13:0]+LATENCY),
  .data_a(data_in), .byteena_a(be), .q_a(posx_bus_out),
  .address_b(index+LATENCY), .wren_b(1'b0), .q_b(posx_out));
mandmem posy(.clock(clock), .wren_a(address[15:14] == 2'b01 ? write : 1'b0), .address_a(address[13:0]+LATENCY),
  .data_a(data_in), .byteena_a(be), .q_a(posy_bus_out),
  .address_b(index+LATENCY), .wren_b(1'b0), .q_b(posy_out));
mandmem xn(.clock(clock), .wren_a(1'b0), .address_a(address[13:0]), .q_a(xn_bus_out),
  .address_b(index), .data_b(mand_xn), .wren_b(mand_write), .q_b(xn_out));
mandmem yn(.clock(clock), .wren_a(1'b0), .address_a(address[13:0]), .q_a(yn_bus_out),
  .address_b(index), .data_b(mand_yn), .wren_b(mand_write), .q_b(yn_out));
mandelbrot mand0(.clock(clock), .rst_n(rst_n), .x0(posx_out), .y0(posy_out), .xn1(mand_xn), .yn1(mand_yn));

endmodule

  