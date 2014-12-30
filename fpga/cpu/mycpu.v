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
reg [7:0] state, state_next;
reg [15:0] ir, ir_next;
reg write_out, write_out_next;
reg [31:0] mdr, mdr_next;
reg [3:0] ccr, ccr_next;
reg [2:0] delay, delay_next;
reg addrsel, addrsel_next;

reg [2:0] alu_func;
reg [4:0] reg_read_addr1, reg_read_addr2, reg_write_addr;
reg [31:0] alu_in1, alu_in2;
reg [3:0] reg_write;

assign data_out = mdr[15:0];
assign addrbus = (addrsel ? mar : pc);

wire data_access;
wire [31:0] reg_data_out1, reg_data_out2, reg_data_in;
wire carry, negative, overflow, zero;
wire [31:0] alu_out;

localparam STATE_FETCHIR1 = 8'h00, STATE_FETCHIR2 = 8'h01, STATE_FETCHIR3 = 8'h02, STATE_EVALIR1 = 8'h03, STATE_EVALIR2 = 8'h04, STATE_EVALIR3 = 8'h05;
localparam STATE_STORE = 8'h06, STATE_STORE2 = 8'h07, STATE_STORE3 = 8'h08;
localparam STATE_LOAD = 8'h09, STATE_LOAD2 = 8'h0a, STATE_LOAD3 = 8'h0b, STATE_LOAD4 = 8'h0c, STATE_FAULT = 8'h0d, STATE_PCWAIT = 8'h0e;

localparam REG_SP = 5'b11111, REG_FP = 5'b11110;
localparam ADDR_PC = 1'b0, ADDR_MAR = 1'b1;

localparam AM_INH = 3'h0, AM_IMM = 3'h1, AM_REGIND = 3'h2, AM_REG = 3'h3, AM_DIR = 3'h4, AM_PCIND = 3'h5;

// opcode format
wire [2:0] ir_mode = ir[15:13];
wire [7:0] ir_op   = ir[12:5];
wire [4:0] ir_ra   = ir[4:0];

localparam REG_WRITE_NONE = 4'b0000, REG_WRITE_B0 = 4'b0001, REG_WRITE_B1 = 4'b0010, REG_WRITE_B2 = 4'b0100, REG_WRITE_B3 = 4'b1000, REG_WRITE_W0 = 4'b0011, REG_WRITE_W1 = 4'b1100;
localparam REG_WRITE_DW = 4'b1111;

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    pc <= 'hffc00000; // start boot at base of monitor for now
    state <= STATE_FETCHIR1;
    ir <= 'h0000;
    mdr <= 'h00000000;
    mar <= 'h00000000;
    addrsel <= ADDR_PC;
    ccr <= 'h0;
    delay <= 'h0;
    write_out <= 1'b0;
  end else begin
    pc <= pc_next[31:0];
    state <= state_next;
    delay <= delay_next;
    ir <= ir_next;
    mdr <= mdr_next;
    mar <= mar_next[31:0];
    addrsel <= addrsel_next;
    ccr <= ccr_next;
    write_out <= write_out_next;
  end
end

always @*
begin
  pc_next = pc;
  state_next = state;
  delay_next = delay;
  ir_next = ir;
  mdr_next = mdr;
  write_out_next = write_out;
  mar_next = mar;
  addrsel_next = addrsel;
  ccr_next = ccr;
  alu_func = 3'h0;
  reg_read_addr1 = 5'h00;
  reg_read_addr2 = 5'h00;
  reg_write_addr = 5'h00;
  reg_data_in = 32'h00000000;
  reg_write = REG_WRITE_NONE;
  alu_in1 = 32'h00000000;
  alu_in2 = 32'h00000000;
  case (state)
    STATE_FETCHIR1: begin
      if (delay == 'h0) begin
        addrsel_next = ADDR_PC;
        write_out_next = 1'b0;
        delay_next = 'h3;
      end else begin
        delay_next = delay - 3'b1;
        if (delay == 'h1) begin
          ir_next = data_in;
          pc_next = pc + 'h2;
          state_next = STATE_EVALIR1;
        end
      end      
    end
    STATE_EVALIR1: begin
      case ({ir_mode, ir_op})
        {AM_INH, 8'h00}: state_next = STATE_FETCHIR1; // nop
        {AM_INH, 8'h01}: state_next = STATE_FETCHIR1; // rts
        {AM_INH, 8'h02}: state_next = STATE_FETCHIR1; // rti
        {AM_REG, 8'h13}: begin // inc rA
          reg_write_addr = ir_ra;
          alu_func = 'h2; // add
          reg_read_addr1 = ir_ra;
          alu_in1 = reg_data_out1;
          alu_in2 = 'h1;
          reg_data_in = alu_out;
          reg_write = REG_WRITE_DW;
          state_next = STATE_FETCHIR1;
        end
        {AM_REG, 8'h14}: begin // dec rA
          reg_write_addr = ir_ra;
          alu_func = 'h3; // sub
          reg_read_addr1 = ir_ra;
          alu_in1 = reg_data_out1;
          alu_in2 = 'h1;
          reg_data_in = alu_out;
          reg_write = REG_WRITE_DW;
          state_next = STATE_FETCHIR1;
        end
        {AM_REG, 8'h15}: begin // push rA
          state_next = STATE_FETCHIR1;
        end
        {AM_REG, 8'h16}: begin // pop rA
          state_next = STATE_FETCHIR1;
        end
        default: state_next = STATE_FETCHIR2;
      endcase
    end
    STATE_FETCHIR2: begin
      if (delay == 'h0) begin
        addrsel_next = ADDR_PC;
        write_out_next = 1'b0;
        delay_next = 'h3;
      end else begin
        delay_next = delay - 3'b1;
        if (delay == 'h1) begin
          case (ir_mode)
            AM_PCIND : mar_next = { {16{data_in[15]}},data_in };
            AM_IMM   : mdr_next = { {16{data_in[15]}}, data_in }; // FIX only do this for signed ops
            AM_REG   : mdr_next = { 16'h0000, data_in };
            AM_REGIND: begin
              mar_next = { {21{data_in[10]}}, data_in[10:0] };
              mdr_next = { 16'h0000, data_in };
            end
            AM_DIR   : mar_next[31:16] = data_in;
            default  : mdr_next = { 16'h0000, data_in };
          endcase
          pc_next = pc + 'h2;
          state_next = STATE_EVALIR2;
        end
      end      
    end
    STATE_EVALIR2: begin
      casex ({ir_mode, ir_op})
        {AM_IMM, 8'h1x}: begin // alu rA <= rA + 0xabcd
          alu_func = ir[7:5];
          reg_write_addr = ir_ra;
          reg_read_addr1 = ir_ra;
          alu_in1 = reg_data_out1;
          alu_in2 = mdr;
          reg_data_in = alu_out;
          reg_write = REG_WRITE_DW;
          state_next = STATE_FETCHIR1;
        end
        {AM_REG, 8'h0x}: begin // alu rA <= rB + rC
          alu_func = ir[7:5];
          reg_write_addr = ir_ra;
          reg_read_addr1 = mdr[12:8];
          reg_read_addr2 = mdr[4:0];
          alu_in1 = reg_data_out1;
          alu_in2 = reg_data_out2;
          reg_data_in = alu_out;
          reg_write = REG_WRITE_DW;
          state_next = STATE_FETCHIR1;
        end
        {AM_REG, 8'h10}: begin // mov
          state_next = STATE_FETCHIR1;
          reg_write_addr = ir_ra;
          reg_read_addr1 = mdr[12:8];
          reg_data_in = reg_data_out1;
          reg_write = REG_WRITE_DW;
        end
        {AM_REG, 8'h11}: begin // cmp
          state_next = STATE_FETCHIR1;
          alu_func = 'h3; // sub
          reg_read_addr1 = ir_ra;
          reg_read_addr2 = mdr[12:8];
          alu_in1 = reg_data_out1;
          alu_in2 = reg_data_out2;
          ccr_next = {carry, negative, overflow, zero};
        end
        {AM_PCIND, 8'h20}: begin // bra
          state_next = STATE_PCWAIT;
          pc_next = { 1'b0, pc } + mar;
        end
        {AM_PCIND, 8'h21}: begin // beq
          state_next = STATE_PCWAIT;
          if (ccr[0])
            pc_next = { 1'b0, pc } + mar;
        end
        {AM_PCIND, 8'h22}: begin // bne
          state_next = STATE_PCWAIT;
          if (~ccr[0])
            pc_next = { 1'b0, pc } + mar;        
        end
        {AM_PCIND, 8'h24}: begin // bgt
          state_next = STATE_PCWAIT;
          if (~(ccr[0] | (ccr[2] ^ ccr[1])))
            pc_next = { 1'b0, pc } + mar;
        end
        {AM_PCIND, 8'h25}: begin // bge
          state_next = STATE_PCWAIT;
          if (~(ccr[2] ^ ccr[1]))
            pc_next = { 1'b0, pc } + mar;
        end
        {AM_PCIND, 8'h26}: begin // ble
          state_next = STATE_PCWAIT;
          if (ccr[0] | (ccr[2] ^ ccr[1]))
            pc_next = { 1'b0, pc } + mar;
        end
        {AM_PCIND, 8'h27}: begin // blt
          state_next = STATE_PCWAIT;
          if (ccr[2] ^ ccr[1])
            pc_next = { 1'b0, pc } + mar;
        end
        {AM_PCIND, 8'h2c}: begin // brn
          state_next = STATE_PCWAIT;
        end
        {AM_REGIND, 8'h20}: begin // st.l
            state_next = STATE_STORE;
            reg_read_addr1 = mdr[15:11]; // rB
            alu_in1 = reg_data_out1;
            alu_in2 = { {21{mdr[10]}}, mdr[10:0] };
            alu_func = 'h2;      
            mar_next = alu_out;
            addrsel_next = ADDR_MAR;
            reg_read_addr2 = ir_ra;
            mdr_next[15:0] = reg_data_out2[31:16];
            write_out_next = 1'b1;
        end
        {AM_REGIND, 8'h21}: begin // ld.l
            state_next = STATE_LOAD;
            reg_read_addr1 = mdr[15:11]; // rB
            alu_in1 = reg_data_out1;
            alu_in2 = { {21{mdr[10]}}, mdr[10:0] };
            alu_func = 'h2;      
            mar_next = alu_out;
            addrsel_next = ADDR_MAR;
        end
        {AM_REGIND, 8'h30}: begin // st
            state_next = STATE_STORE;
        end
        {AM_REGIND, 8'h31}: begin // ld
            state_next = STATE_LOAD;
        end
        {AM_REGIND, 8'h40}: begin // st.b
            state_next = STATE_STORE;
        end
        {AM_REGIND, 8'h41}: begin // ld.b
            state_next = STATE_LOAD;
        end
        default: state_next = STATE_FETCHIR3;
      endcase
    end
    STATE_FETCHIR3: begin
      if (delay == 'h0) begin
        addrsel_next = ADDR_PC;
        write_out_next = 1'b0;
        delay_next = 'h3;
      end else begin
        delay_next = delay - 3'b1;
        if (delay == 'h1) begin
          case (ir_mode)
            AM_IMM : mdr_next = { mdr[15:0], data_in };
            AM_DIR : mar_next[15:0] = data_in;
            default: mdr_next = { mdr[15:0], data_in }; 
          endcase
          pc_next = pc + 'h2;
         state_next = STATE_EVALIR3;
        end
      end      
    end
    STATE_EVALIR3: begin
      casex ({ir_mode, ir_op})
        {AM_IMM, 8'h0x}: begin // alu rA <= rB + 0xabcd
          alu_func = ir[7:5];
          reg_write_addr = ir_ra;
          reg_read_addr1 = mdr[28:24]; // rB
          alu_in1 = reg_data_out1;
          alu_in2 = { {16{mdr[15]}}, mdr[15:0] }; // FIX for signed only
          reg_data_in = alu_out;
          reg_write = REG_WRITE_DW;
          state_next = STATE_FETCHIR1;
        end
        {AM_IMM, 8'h20}: begin // ldi
          state_next = STATE_FETCHIR1;
          reg_write_addr = ir_ra;
          reg_data_in = mdr;
          reg_write = REG_WRITE_DW;        
        end
        {AM_DIR, 8'h20}: begin // st.l
          state_next = STATE_STORE;
          reg_read_addr1 = ir_ra;
          mdr_next[15:0] = reg_data_out1[31:16];
          addrsel_next = ADDR_MAR;
          write_out_next = 1'b1;
        end
        {AM_DIR, 8'h21}: begin // ld.l
          state_next = STATE_LOAD;
          addrsel_next = ADDR_MAR;
        end
        {AM_DIR, 8'h30}: begin // st
          state_next = STATE_STORE;
          write_out_next = 1'b1;
        end
        {AM_DIR, 8'h31}: begin // ld
          state_next = STATE_LOAD;
        end
        {AM_DIR, 8'h40}: begin // st.b
          state_next = STATE_STORE;
        end
        {AM_DIR, 8'h41}: begin // ld.b
          state_next = STATE_LOAD;
        end
        {AM_DIR, 8'h50}: begin // jmp
          state_next = STATE_FETCHIR1;
          pc_next = { 1'b0, mar};
        end
        {AM_DIR, 8'h51}: begin // jsr
        end
        default: state_next = STATE_FAULT;
      endcase 
    end
    STATE_STORE: begin
      write_out_next = 1'b0;
      case (ir_op)
        'h20: begin
          state_next = STATE_STORE2;
        end
        'h30: state_next = STATE_FETCHIR1;
        'h40: state_next = STATE_FETCHIR1;
        default: state_next = STATE_FAULT;
      endcase
    end
    STATE_STORE2: begin
      state_next = STATE_STORE3;
      mar_next = mar + 'h2;
      reg_read_addr1 = ir_ra;
      mdr_next[15:0] = reg_data_out1[15:0];
      write_out_next = 1'b1;
    end
    STATE_STORE3: begin
      state_next = STATE_FETCHIR1;
      addrsel_next = ADDR_PC;
      write_out_next = 1'b0;
    end
    STATE_LOAD: state_next = STATE_LOAD2;
    STATE_LOAD2: begin
      reg_write_addr = ir_ra;
      case (ir_op)
        'h21: begin
          state_next = STATE_LOAD3;
          reg_data_in = { data_in, 16'h0000 };
          reg_write = REG_WRITE_W1;
          mar_next = mar + 'h2;
        end
        'h31: begin
          state_next = STATE_FETCHIR1;
          addrsel_next = ADDR_PC;
          reg_data_in = {16'h0000, data_in};
          reg_write = REG_WRITE_W0;
        end
        'h41: begin
          state_next = STATE_FETCHIR1;
          addrsel_next = ADDR_PC;
          reg_data_in = {24'h000000, data_in[7:0] };
          reg_write = REG_WRITE_B0;
        end 
        default: state_next = STATE_FAULT;
      endcase
    end
    STATE_LOAD3: state_next = STATE_LOAD4;
    STATE_LOAD4: begin
      state_next = STATE_FETCHIR1;
      addrsel_next = ADDR_PC;
      reg_write_addr = ir_ra;
      reg_data_in = { 16'h0000, data_in };
      reg_write = REG_WRITE_W0;
    end
    STATE_PCWAIT: state_next = STATE_FETCHIR1;
    STATE_FAULT: state_next = STATE_FAULT;
  endcase
end

alu alu0(.in1(alu_in1), .in2(alu_in2), .func(alu_func), .out(alu_out),
  .c_in(1'b0), .z_in(1'b0), .c_out(carry), .n_out(negative), .v_out(overflow), .z_out(zero));
registerfile reg0(.clk(clk), .rst_n(rst_n), .read1(reg_read_addr1), .read2(reg_read_addr2), .write_addr(reg_write_addr),
  .write_data(reg_data_in), .write_en(reg_write), .data1(reg_data_out1), .data2(reg_data_out2));

endmodule
