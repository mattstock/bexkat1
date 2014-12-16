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
reg write_out, write_out_next;
reg [15:0] data_out, data_out_next;
reg [3:0] ccr, ccr_next;
reg [31:0] scratch, scratch_next;
reg mar_access, mar_access_next;

reg [2:0] alu_func;
reg [4:0] reg_read_addr1, reg_read_addr2, reg_write_addr;
reg [31:0] alu_in1, alu_in2;
reg [3:0] reg_write;

assign addrbus = (mar_access ? mar : pc);

wire data_access;
wire [31:0] reg_data_out1, reg_data_out2, reg_data_in;
wire carry, negative, overflow, zero;
wire [31:0] alu_out;

localparam STATE_FETCH1 = 8'h00, STATE_FETCH2 = 8'h01, STATE_MEMOP1 = 8'h02, STATE_MEMOP2 = 8'h03, STATE_STORE = 8'h04, STATE_LOAD = 8'h05, STATE_ERR = 8'h06;
// For now, my monitor memory is internal to the FPGA, and so synchronous.  We need wait states.
localparam STATE_FETCH1W = 8'h07, STATE_FETCH2W = 8'h08, STATE_MEMOP1W = 8'h09, STATE_MEMOP2W = 8'h0a, STATE_CALL1W = 8'h0b, STATE_CALL1 = 8'h0c;
localparam STATE_CALL2W = 8'h0d, STATE_CALL2 = 8'h0e, STATE_RTN1W = 8'h0f, STATE_RTN1 = 8'h10, STATE_RTN2W = 8'h11, STATE_RTN2 = 8'h12;
localparam STATE_LOAD2 = 8'h13, STATE_LOAD3 = 8'h14, STATE_STORE2 = 8'h15, STATE_STORE3 = 8'h16, STATE_STORE4 = 8'h17, STATE_STORE5 = 8'h18, STATE_STORE6 = 8'h19;
localparam STATE_LOAD4 = 8'h1a, STATE_LOAD5 = 8'h1b;

localparam REG_WRITE_NONE = 4'b0000, REG_WRITE_B0 = 4'b0001, REG_WRITE_B1 = 4'b0010, REG_WRITE_B2 = 4'b0100, REG_WRITE_B3 = 4'b1000, REG_WRITE_W0 = 4'b0011, REG_WRITE_W1 = 4'b1100;
localparam REG_WRITE_DW = 4'b1111;

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    pc <= 'hffc00000; // start boot at base of monitor for now
    state <= STATE_FETCH1;
    opcode <= 'h0000;
    data_out <= 'h0000;
    mar <= 'h00000000;
    ccr <= 'h0;
    sp <= 'h0007ffff; // top of SRAM
    scratch <= 'h00000000;
    write_out <= 1'b0;
    mar_access <= 1'b0;
  end else begin
    pc <= pc_next[31:0];
    state <= state_next;
    opcode <= opcode_next;
    data_out <= data_out_next;
    mar_access <= mar_access_next;
    mar <= mar_next[31:0];
    ccr <= ccr_next;
    sp <= sp_next;
    write_out <= write_out_next;
    scratch <= scratch_next;
  end
end

always @*
begin
  pc_next = pc;
  state_next = state;
  opcode_next = opcode;
  data_out_next = data_out;
  write_out_next = write_out;
  mar_access_next = mar_access;
  mar_next = mar;
  ccr_next = ccr;
  sp_next = sp;
  scratch_next = scratch;
  alu_func = 3'h0;
  reg_read_addr1 = 5'h00;
  reg_read_addr2 = 5'h00;
  reg_write_addr = 5'h00;
  reg_data_in = 32'h00000000;
  reg_write = REG_WRITE_NONE;
  alu_in1 = 32'h00000000;
  alu_in2 = 32'h00000000;
  case (state)
    STATE_FETCH1W: state_next = STATE_FETCH1;
    STATE_FETCH1: begin
      pc_next = pc + 'h2;
      opcode_next = data_in;
      case (data_in[15:14])
        'b11: state_next = STATE_MEMOP1W; // F3 opcodes (3 word load)
        'b10: state_next = STATE_FETCH2W; // F2 opcodes (2 word load)
        'b01: state_next = STATE_FETCH2W; // F1 opcodes (2 word load)
        'b00: begin                       // F0 opcodes (1 word load)
          case (data_in[12:5])
            'h00: state_next = STATE_FETCH1W; // nop
            'h01: begin // rts
              state_next = STATE_RTN1W;
              sp_next = sp + 'h2;
            end
            'h02: begin // rti
            end
            'h03: begin // inc R
              state_next = STATE_FETCH1W;
              reg_write_addr = data_in[4:0];
              alu_func = 'h2; // add
              reg_read_addr1 = data_in[4:0];
              alu_in1 = reg_data_out1;
              alu_in2 = 'h1;
              reg_data_in = alu_out;
              reg_write = REG_WRITE_DW;
            end
            'h04: begin //dec R
              state_next = STATE_FETCH1W;
              reg_write_addr = data_in[4:0];
              alu_func = 'h3; // sub
              reg_read_addr1 = data_in[4:0];
              alu_in1 = reg_data_out1;
              alu_in2 = 'h1;
              reg_data_in = alu_out;
              reg_write = REG_WRITE_DW;
            end
            default: state_next = STATE_ERR;
          endcase
        end
      endcase
    end
    STATE_RTN1W: begin
      state_next = STATE_RTN1;
    end
    STATE_RTN1: begin
      state_next = STATE_RTN2W;
      pc_next[31:16] = data_in;
      sp_next = sp + 'h2;
    end
    STATE_RTN2W: begin
      state_next = STATE_RTN2;
    end
    STATE_RTN2: begin
      state_next = STATE_FETCH1W;
      pc_next[15:0] = data_in;
      // check for address fault = non-0 bit 0
      sp_next = sp + 'h2;
    end
    STATE_FETCH2W: state_next = STATE_FETCH2;
    STATE_FETCH2: begin
      pc_next = pc + 'h2;
      if (opcode[15:14] == 2'b01) begin // F1 opcodes
        casex (opcode[12:5])
          'h0x: begin // rA <= rB and rC
            state_next = STATE_FETCH1W;
            {alu_func, reg_write_addr} = opcode[7:0];
            reg_read_addr1 = data_in[12:8];
            reg_read_addr2 = data_in[4:0];
            alu_in1 = reg_data_out1;
            alu_in2 = reg_data_out2;
            reg_data_in = alu_out;
            reg_write = REG_WRITE_DW;
          end
          'h10: begin // mov rA, rB
            state_next = STATE_FETCH1W;
            reg_write_addr = opcode[4:0];
            reg_read_addr1 = data_in[12:8];
            reg_data_in = reg_data_out1;
            reg_write = REG_WRITE_DW;
          end
          'h11: begin // cmp rA, rB
            state_next = STATE_FETCH1W;
            alu_func = 'h3; // sub
            reg_read_addr1 = opcode[4:0];
            reg_read_addr2 = data_in[12:8];
            alu_in1 = reg_data_out1;
            alu_in2 = reg_data_out2;
            ccr_next = {carry, negative, overflow, zero};
          end
          'h20: begin // st.l indirect
            state_next = STATE_STORE;
            reg_read_addr1 = data_in[12:8];
            mar_next = reg_data_out1;
            reg_read_addr2 = opcode[4:0];
            data_out_next = reg_data_out2[31:16];
            mar_access_next = 1'b1;
            write_out_next = 1'b1;
          end
          'h21: begin // ld.l indirect
            state_next = STATE_LOAD;
            reg_read_addr1 = data_in[12:8];
            mar_next = reg_data_out1;
          end
          'h30: begin // st indirect
            state_next = STATE_STORE;
            reg_read_addr1 = data_in[12:8];
            mar_next = reg_data_out1;
            reg_read_addr2 = opcode[4:0];
            data_out_next = reg_data_out2[15:0];
            mar_access_next = 1'b1;
            write_out_next = 1'b1;
          end
          'h31: begin // ld indirect
            state_next = STATE_LOAD;
            reg_read_addr1 = data_in[12:8];
            mar_next = reg_data_out1;
          end
          'h40: begin // st.b indirect
            state_next = STATE_STORE;
            reg_read_addr1 = data_in[12:8];
            mar_next = reg_data_out1;
            reg_read_addr2 = opcode[4:0];
            data_out_next = reg_data_out2[15:0];
            mar_access_next = 1'b1;
            write_out_next = 1'b1;
          end
          'h41: begin // ld.b indirect
            state_next = STATE_LOAD;
            reg_read_addr1 = data_in[12:8];
            mar_next = reg_data_out1;
          end
          default: begin // should trigger an invalid opcode exception
            state_next = STATE_ERR;  
          end
        endcase
      end else begin // F2 opcodes
        casex (opcode[12:5])
          'h20: begin // bra
            state_next = STATE_FETCH1W;
            pc_next = { 1'b0, pc + 'h2} + ({{16{data_in[15]}},data_in} << 1);
          end
          'h21: begin // beq
            state_next = STATE_FETCH1W;
            if (ccr[0])
              pc_next = { 1'b0, pc + 'h2} + ({{16{data_in[15]}},data_in} << 1);
          end
          'h22: begin // bne
            state_next = STATE_FETCH1W;
            if (~ccr[0])
              pc_next = { 1'b0, pc + 'h2} + ({{16{data_in[15]}},data_in} << 1);        
          end
          'h24: begin // bgt
            state_next = STATE_FETCH1W;
            if (~(ccr[0] | (ccr[2] ^ ccr[1])))
              pc_next = { 1'b0, pc + 'h2} + ({{16{data_in[15]}},data_in} << 1);
          end
          'h25: begin // bge
            state_next = STATE_FETCH1W;
            if (~(ccr[2] ^ ccr[1]))
              pc_next = { 1'b0, pc + 'h2} + ({{16{data_in[15]}},data_in} << 1);
          end
          'h26: begin // ble
            state_next = STATE_FETCH1W;
            if (ccr[0] | (ccr[2] ^ ccr[1]))
              pc_next = { 1'b0, pc + 'h2} + ({{16{data_in[15]}},data_in} << 1);
          end
          'h27: begin // blt
            state_next = STATE_FETCH1W;
            if (ccr[2] ^ ccr[1])
              pc_next = { 1'b0, pc + 'h2} + ({{16{data_in[15]}},data_in} << 1);
          end
          default: begin // should trigger an invalid opcode exception
            state_next = STATE_ERR;  
          end
        endcase
      end
    end
    STATE_MEMOP1W: state_next = STATE_MEMOP1;
    STATE_MEMOP1: begin // Read high address word from mem
      state_next = STATE_MEMOP2W;
      pc_next = pc + 'h2;
      mar_next[31:16] = data_in;
    end
    STATE_MEMOP2W: state_next = STATE_MEMOP2;
    STATE_MEMOP2: begin // Read low address word from mem
      pc_next = pc + 'h2;
      mar_next[15:0] = data_in;
      casex (opcode[12:5])
        'h20: begin // st.l
          state_next = STATE_STORE;
          reg_read_addr1 = opcode[4:0];
          data_out_next = reg_data_out1[31:16];
          mar_access_next = 1'b1;
          write_out_next = 1'b1;
        end
        'h21: begin // ld.l
          state_next = STATE_LOAD;
          mar_access_next = 1'b1;
        end
        'h30: begin  // st
          state_next = STATE_STORE;
          reg_read_addr1 = opcode[4:0];
          data_out_next = reg_data_out1[15:0];
        end
        'h31: begin // ld
          state_next = STATE_LOAD;
          mar_access_next = 1'b1;
        end
        'h40: begin // st.b
          state_next = STATE_STORE;
          reg_read_addr1 = opcode[4:0];
          data_out_next = reg_data_out1[15:0];
        end        
        'h41: begin // ld.b
          state_next = STATE_LOAD;
          mar_access_next = 1'b1;
        end
        'h50: begin // jmp
          state_next = STATE_FETCH1W;
          pc_next = { mar[31:16], data_in};
        end
        'h51: begin // jsr
          state_next = STATE_CALL1W;
        end
        'h10: begin // ldi  // 
          state_next = STATE_FETCH1W;
          reg_write_addr = opcode[4:0];
          reg_data_in = { mar[31:16], data_in };
          reg_write = REG_WRITE_DW;        
        end
        default: begin // should trigger an invalid opcode exception
          state_next = STATE_ERR;  
        end
      endcase
    end
    STATE_CALL1W: state_next = STATE_CALL1;
    STATE_CALL1: begin
      state_next = STATE_CALL2W;
    end
    STATE_CALL2W: state_next = STATE_CALL2;
    STATE_CALL2: begin
      state_next = STATE_FETCH1W;
      pc_next = mar;
    end
    STATE_STORE: begin
      write_out_next = 1'b0;
      casex (opcode[12:5])
        'h20: begin
          state_next = STATE_STORE2;
        end
        'h30: begin
          state_next = STATE_FETCH1W;
          mar_access_next = 1'b0;
        end
        'h40: begin
          state_next = STATE_FETCH1W;
          mar_access_next = 1'b0;
          // for now we ignore, but we should use the low order bit for mar to
          // select which byte is actually written - high/low indicator if we do this at all
        end
        default: state_next = STATE_ERR;
      endcase
    end
    STATE_STORE2: begin
      state_next = STATE_STORE3;
      mar_next = mar + 'h2;
      reg_read_addr1 = opcode[4:0];
      data_out_next = reg_data_out1[15:0];
      write_out_next = 1'b1;
    end
    STATE_STORE3: begin
      state_next = STATE_FETCH1W;
      mar_access_next = 1'b0;
      write_out_next = 1'b0;
    end
    STATE_LOAD: state_next = STATE_LOAD2;
    STATE_LOAD2: begin
      reg_write_addr = opcode[4:0];
      case (opcode[12:5])
        'h21: begin
          state_next = STATE_LOAD3;
          reg_data_in = { data_in, 16'h0000 };
          reg_write = REG_WRITE_W1;
          mar_next = mar + 'h2;
        end
        'h31: begin
          state_next = STATE_FETCH1W;
          mar_access_next = 1'b0;
          reg_data_in = {16'h0000, data_in};
          reg_write = REG_WRITE_W0;
        end
        'h41: begin
          state_next = STATE_FETCH1W;
          mar_access_next = 1'b0;
          reg_data_in = {24'h000000, data_in[7:0] };
          reg_write = REG_WRITE_B0;
        end 
        default: state_next = STATE_ERR;
      endcase
    end
    STATE_LOAD3: state_next = STATE_LOAD4;
    STATE_LOAD4: begin
      state_next = STATE_FETCH1W;
      mar_access_next = 1'b0;
      reg_write_addr = opcode[4:0];
      reg_data_in = { 16'h0000, data_in };
      reg_write = REG_WRITE_W0;
    end
    STATE_ERR: state_next = STATE_ERR;
  endcase
end

alu alu0(.in1(alu_in1), .in2(alu_in2), .func(alu_func), .out(alu_out),
  .c_in(1'b0), .z_in(1'b0), .c_out(carry), .n_out(negative), .v_out(overflow), .z_out(zero));
registerfile reg0(.clk(clk), .rst_n(rst_n), .read1(reg_read_addr1), .read2(reg_read_addr2), .write_addr(reg_write_addr),
  .write_data(reg_data_in), .write_en(reg_write), .data1(reg_data_out1), .data2(reg_data_out2));

endmodule
