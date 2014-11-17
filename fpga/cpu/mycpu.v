module mycpu(clk, rst_n, addrbus, data_in, data_out);

input clk;
input rst_n;
output [31:0] addrbus;
input [15:0] data_in;
output [15:0] data_out;

reg [31:0] pc, pc_next;
reg [7:0] state, state_next;
reg [31:0] opcode, opcode_next;

assign addrbus = (state == STATE_FETCH1 | state == STATE_FETCH2 ? pc : 32'h00000000);
assign data_out = (state == STATE_DECODE_OP ? data_in : 16'h0000);

localparam STATE_FETCH1 = 8'h00, STATE_FETCH2 = 8'h01, STATE_DECODE_OP = 8'h02;

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    pc <= 'hff000000; // start boot at base of monitor for now
    state <= STATE_FETCH1;
    opcode <= 'h00000000;
  end else begin
    pc <= pc_next;
    state <= state_next;
    opcode <= opcode_next;
  end
end

always @*
begin
  pc_next = pc;
  state_next = state;
  opcode_next = opcode;
  case (state)
    STATE_FETCH1: begin
      state_next = (data_in[15] ? STATE_FETCH2 : STATE_DECODE_OP);
      opcode_next[31:16] = data_in;
      pc_next = pc + 1'b1;
    end
    STATE_FETCH2: begin
      state_next = STATE_DECODE_OP;
      pc_next = pc + 1'b1;
      opcode_next[15:0] = data_in;
    end
    STATE_DECODE_OP: begin
      case (opcode[31:30])
        'b00: state_next = STATE_FETCH1;
        'b01: state_next = STATE_FETCH1;
        'b10: state_next = STATE_FETCH1;
        'b11: state_next = STATE_FETCH1;
       endcase
    end
  endcase
end


endmodule
