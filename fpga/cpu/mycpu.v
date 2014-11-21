module mycpu(clk, rst_n, addrbus, data_in, data_out, write_out);

input clk;
input rst_n;
output [31:0] addrbus;
input [15:0] data_in;
output [15:0] data_out;
output write_out;

reg [31:0] pc, pc_next;
reg [31:0] mar, mar_next;
reg [7:0] state, state_next;
reg [15:0] opcode, opcode_next;
reg [15:0] data_out, data_out_next;

reg [3:0] alu_func;
reg [4:0] reg_read_addr1, reg_read_addr2, reg_write_addr;
reg [15:0] alu_in1, alu_in2;
reg reg_write;

wire [15:0] reg_data_out1, reg_data_out2, reg_data_in;

assign addrbus = (state == STATE_STORE || state == STATE_LOAD ? mar : pc);
assign write_out = (state == STATE_STORE);

wire [15:0] alu_out;

localparam STATE_FETCH1 = 8'h00, STATE_FETCH2 = 8'h01, STATE_MEMOP1 = 8'h02, STATE_MEMOP2 = 8'h03, STATE_STORE = 8'h04, STATE_LOAD = 8'h05, STATE_ERR = 8'h06;
localparam STATE_FETCH1W = 8'h07, STATE_FETCH2W = 8'h08, STATE_MEMOP1W = 8'h09, STATE_MEMOP2W = 8'h0a;

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    pc <= 'hff000000; // start boot at base of monitor for now
    state <= STATE_FETCH1;
    opcode <= 'h0000;
    data_out <= 'h0000;
    mar <= 'h00000000;
  end else begin
    pc <= pc_next;
    state <= state_next;
    opcode <= opcode_next;
    data_out <= data_out_next;
    mar <= mar_next;
  end
end

always @*
begin
  pc_next = pc;
  state_next = state;
  opcode_next = opcode;
  data_out_next = data_out;
  mar_next = mar;
  alu_func = 4'h0;
  reg_read_addr1 = 5'h00;
  reg_read_addr2 = 5'h00;
  reg_write_addr = 5'h00;
  reg_data_in = 16'h0000;
  reg_write = 1'b0;
  alu_in1 = 16'h0000;
  alu_in2 = 16'h0000;
  case (state)
    STATE_FETCH1W: state_next = STATE_FETCH1;
    STATE_FETCH1: begin
      pc_next = pc + 1'b1;
      opcode_next = data_in;
      case (opcode_next[15:14])
        'b11: state_next = STATE_MEMOP1W; // three word opcodes
        'b10: state_next = STATE_FETCH2W; // two word opcodes
        'b01: begin
          state_next = STATE_ERR;
        end
        'b00: begin
          state_next = STATE_ERR;
        end
      endcase
    end
    STATE_FETCH2W: state_next = STATE_FETCH2;
    STATE_FETCH2: begin
      pc_next = pc + 1'b1;
      case (opcode[13:10])
        'b1101: begin // three register alu op
          state_next = STATE_FETCH1W;
          {alu_func, reg_write_addr} = opcode[8:0];
          reg_read_addr1 = data_in[9:5];
          reg_read_addr2 = data_in[4:0];
          alu_in1 = reg_data_out1;
          alu_in2 = reg_data_out2;
          reg_data_in = alu_out;
          reg_write = 1'b1;
        end
        'b1001: begin // unconditional branch
          state_next = STATE_FETCH1W;
          pc_next = { 1'b0, pc + 1'b1} + {{16{data_in[15]}},data_in};
        end
        'b1000: begin // load constant
          state_next = STATE_FETCH1W;
          reg_write_addr = opcode[4:0];
          reg_data_in = data_in;
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
          data_out_next = reg_data_out1;
        end
        'b01: begin // jmp
          state_next = STATE_FETCH1W;
          pc_next = {data_in, mar[15:0]};
        end
        'b00: begin // call
          // TODO need to save state on stack, update SP, then jump
          state_next = STATE_ERR;
        end
      endcase
    end
    STATE_STORE: state_next = STATE_FETCH1W;
    STATE_LOAD: begin
      state_next = STATE_FETCH1W;
      reg_write_addr = opcode[4:0];
      reg_data_in = data_in;
      reg_write = 1'b1;
    end
    STATE_ERR: state_next = STATE_ERR;
  endcase
end

alu alu0(.in1(alu_in1), .in2(alu_in2), .func(alu_func), .out(alu_out));
registerfile reg0(.clk(clk), .rst_n(rst_n), .read1(reg_read_addr1), .read2(reg_read_addr2), .write_addr(reg_write_addr),
  .write_data(reg_data_in), .write_en(reg_write), .data1(reg_data_out1), .data2(reg_data_out2));

endmodule
