module mycpu(clk, rst_n, addrbus, data_in, data_out, write_out, ccr);

input clk;
input rst_n;
output [31:0] addrbus;
input [15:0] data_in;
output [15:0] data_out;
output write_out;
output [3:0] ccr;

reg [31:0] pc;
reg [32:0] pc_next;
reg [31:0] mar;
reg [32:0] mar_next;
reg [31:0] sp, sp_next;
reg [7:0] state, state_next;
reg [15:0] opcode, opcode_next;
reg [15:0] data_out, data_out_next;
reg [3:0] ccr, ccr_next;
reg [31:0] scratch, scratch_next;

reg [3:0] alu_func;
reg [1:0] alu_in_width;
reg [4:0] reg_read_addr1, reg_read_addr2, reg_write_addr;
reg [31:0] alu_in1, alu_in2;
reg reg_write;
reg [31:0] addrbus;
reg write_out;

wire [31:0] reg_data_out1, reg_data_out2, reg_data_in;
wire carry, negative, overflow, zero;
wire [31:0] alu_out;

localparam STATE_FETCH1 = 8'h00, STATE_FETCH2 = 8'h01, STATE_MEMOP1 = 8'h02, STATE_MEMOP2 = 8'h03, STATE_STORE = 8'h04, STATE_LOAD = 8'h05, STATE_ERR = 8'h06;
// For now, my monitor memory is internal to the FPGA, and so synchronous.  We need wait states.
localparam STATE_FETCH1W = 8'h07, STATE_FETCH2W = 8'h08, STATE_MEMOP1W = 8'h09, STATE_MEMOP2W = 8'h0a, STATE_CALL1W = 8'h0b, STATE_CALL1 = 8'h0c;
localparam STATE_CALL2W = 8'h0d, STATE_CALL2 = 8'h0e, STATE_RTN1W = 8'h0f, STATE_RTN1 = 8'h10, STATE_RTN2W = 8'h11, STATE_RTN2 = 8'h12;

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    pc <= 'hff000000; // start boot at base of monitor for now
    state <= STATE_FETCH1;
    opcode <= 'h0000;
    data_out <= 'h0000;
    mar <= 'h00000000;
    ccr <= 'h0;
    sp <= 'h0003ffff; // top of SRAM
    scratch <= 'h00000000;
  end else begin
    pc <= pc_next[31:0];
    state <= state_next;
    opcode <= opcode_next;
    data_out <= data_out_next;
    mar <= mar_next[31:0];
    ccr <= ccr_next;
    sp <= sp_next;
    scratch <= scratch_next;
  end
end

always @*
begin
  pc_next = pc;
  state_next = state;
  opcode_next = opcode;
  data_out_next = data_out;
  mar_next = mar;
  ccr_next = ccr;
  sp_next = sp;
  scratch_next = scratch;
  alu_func = 4'h0;
  alu_in_width = 2'b00;
  reg_read_addr1 = 5'h00;
  reg_read_addr2 = 5'h00;
  reg_write_addr = 5'h00;
  reg_data_in = 32'h00000000;
  reg_write = 1'b0;
  alu_in1 = 32'h00000000;
  alu_in2 = 32'h00000000;
  addrbus = pc;
  write_out = 1'b0;
  case (state)
    STATE_FETCH1W: state_next = STATE_FETCH1;
    STATE_FETCH1: begin
      pc_next = pc + 1'b1;
      opcode_next = data_in;
      case (data_in[15:14])
        'b11: state_next = STATE_MEMOP1W; // three word opcodes
        'b10: state_next = STATE_FETCH2W; // two word opcodes
        'b01: begin
          state_next = STATE_ERR;
        end
        'b00: begin  // one work opcodes
          case (data_in[13:0])
            'h0000: state_next = STATE_FETCH1W; // nop
            'h0001: begin // rtn
              state_next = STATE_RTN1W;
              sp_next = sp + 1'b1;
              addrbus = sp_next;
            end
            default: state_next = STATE_ERR;
          endcase
        end
      endcase
    end
    STATE_RTN1W: begin
      state_next = STATE_RTN1;
      addrbus = sp;
    end
    STATE_RTN1: begin
      state_next = STATE_RTN2W;
      pc_next[15:0] = data_in;
      sp_next = sp + 1'b1;
      addrbus = sp_next;
    end
    STATE_RTN2W: begin
      state_next = STATE_RTN2;
      addrbus = sp;
    end
    STATE_RTN2: begin
      state_next = STATE_FETCH1W;
      pc_next[31:0] = data_in;
      sp_next = sp + 1'b1;
    end
    STATE_FETCH2W: state_next = STATE_FETCH2;
    STATE_FETCH2: begin
      pc_next = pc + 1'b1;
      case (opcode[13:10])
        'b0000: begin // cmp R,R
          state_next = STATE_FETCH1W;
          alu_func = opcode[8:5]; // sub
          reg_read_addr1 = data_in[9:5];
          reg_read_addr2 = data_in[4:0];
          alu_in1 = reg_data_out1;
          alu_in2 = reg_data_out2;
          ccr_next = {carry, negative, overflow, zero};
        end
        'b0001: begin // bgt
          state_next = STATE_FETCH1W;
          if (~(ccr[0] | (ccr[2] ^ ccr[1])))
            pc_next = { 1'b0, pc + 1'b1} + {{16{data_in[15]}},data_in};
        end
        'b0010: begin // bgte
          state_next = STATE_FETCH1W;
          if (~(ccr[2] ^ ccr[1]))
            pc_next = { 1'b0, pc + 1'b1} + {{16{data_in[15]}},data_in};
        end
        'b0011: begin // blte
          state_next = STATE_FETCH1W;
          if (ccr[0] | (ccr[2] ^ ccr[1]))
            pc_next = { 1'b0, pc + 1'b1} + {{16{data_in[15]}},data_in};
        end
        'b1000: begin // ld R,#
          state_next = STATE_FETCH1W;
          reg_write_addr = opcode[4:0];
          reg_data_in = data_in;
          reg_write = 1'b1;
        end 
        'b1001: begin // bra
          state_next = STATE_FETCH1W;
          pc_next = { 1'b0, pc + 1'b1} + {{16{data_in[15]}},data_in};
        end
        'b1010: begin // beq
          state_next = STATE_FETCH1W;
          if (ccr[0])
            pc_next = { 1'b0, pc + 1'b1} + {{16{data_in[15]}},data_in};
        end
        'b1011: begin // blt
          state_next = STATE_FETCH1W;
          if (ccr[2] ^ ccr[1])
            pc_next = { 1'b0, pc + 1'b1} + {{16{data_in[15]}},data_in};
        end
        'b1100: begin // bne
          state_next = STATE_FETCH1W;
          if (~ccr[0])
            pc_next = { 1'b0, pc + 1'b1} + {{16{data_in[15]}},data_in};        
        end
        'b1101: begin // R <- R op R
          state_next = STATE_FETCH1W;
          {alu_func, reg_write_addr} = opcode[8:0];
          reg_read_addr1 = data_in[9:5];
          reg_read_addr2 = data_in[4:0];
          alu_in1 = reg_data_out1;
          alu_in2 = reg_data_out2;
          reg_data_in = alu_out;
          reg_write = 1'b1;
        end
        default: begin // should trigger an invalid opcode exception
          state_next = STATE_ERR;  
        end
      endcase
    end
    STATE_MEMOP1W: state_next = STATE_MEMOP1;
    STATE_MEMOP1: begin // Read low address word from mem
      state_next = STATE_MEMOP2W;
      pc_next = pc + 1'b1;
      mar_next[15:0] = data_in;
    end
    STATE_MEMOP2W: state_next = STATE_MEMOP2;
    STATE_MEMOP2: begin // Read high address word from mem
      pc_next = pc + 1'b1;
      mar_next[31:16] = data_in;
      case (opcode[13:12])
        'b11: state_next = STATE_LOAD;
        'b10: begin
          state_next = STATE_STORE;
          reg_read_addr1 = opcode[4:0];
          data_out_next = reg_data_out1[15:0];
        end
        'b01: begin // jmp
          state_next = STATE_FETCH1W;
          pc_next = {data_in, mar[15:0]};
        end
        'b00: begin // call
          state_next = STATE_CALL1W;
          addrbus = sp;
          sp_next = sp - 1'b1;
          data_out_next = pc_next[15:0];
          write_out = 1'b1;
        end
      endcase
    end
    STATE_CALL1W: state_next = STATE_CALL1;
    STATE_CALL1: begin
      state_next = STATE_CALL2W;
      addrbus = sp;
      sp_next = sp - 1'b1;
      data_out_next = pc[31:16];
      write_out = 1'b1;
    end
    STATE_CALL2W: state_next = STATE_CALL2;
    STATE_CALL2: begin
      state_next = STATE_FETCH1W;
      pc_next = mar;
    end
    STATE_STORE: begin
      state_next = STATE_FETCH1W;
      addrbus = mar;
      write_out = 1'b1;
    end
    STATE_LOAD: begin
      state_next = STATE_FETCH1W;
      addrbus = mar;
      reg_write_addr = opcode[4:0];
      // TODO allow different opcodes to  
      reg_data_in = {16'h0000, data_in};
      reg_write = 1'b1;
    end
    STATE_ERR: state_next = STATE_ERR;
  endcase
end

doublealu alu0(.in1(alu_in1), .in2(alu_in2), .func(alu_func), .path_width(alu_in_width), .out(alu_out),
  .c_in(1'b0), .z_in(1'b0), .c_out(carry), .n_out(negative), .v_out(overflow), .z_out(zero));
registerfile reg0(.clk(clk), .rst_n(rst_n), .read1(reg_read_addr1), .read2(reg_read_addr2), .write_addr(reg_write_addr),
  .write_data(reg_data_in), .write_en(reg_write), .data1(reg_data_out1), .data2(reg_data_out2));

endmodule
