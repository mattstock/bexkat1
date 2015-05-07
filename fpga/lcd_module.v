module lcd_module(
  input clk,
  input rst_n,
  input read,
  input write,
  input [5:0] address,
  output reg [31:0] readdata,
  input [31:0] writedata,
  input [3:0] be,
  output reg e,
  output reg [7:0] data_out,
  output reg on,
  output reg rw,
  output reg rs);

reg on_next, rs_next, rw_next, e_next;
reg [31:0] readdata_next;
reg [1:0] state, state_next;
reg [7:0] data_out_next, seq, seq_next;

localparam [1:0] STATE_IDLE = 2'h00, STATE_COMMAND = 2'h01, STATE_INIT = 2'h02, STATE_DATA = 2'h03;

// w 0x20: on/off
// w 0x21: send command
// w 0x22: init
// r 0x20: read on/off
// r 0x21: busy
// w 0x00-1f: screen pos

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    on <= 1'b0;
    readdata <= 'h0;
    state <= STATE_IDLE;
    data_out <= 8'h00;
    rw <= 1'b1;
    rs <= 1'b1;
    e <= 1'b0;
    seq <= 2'h0;
  end else begin
    on <= on_next;
    readdata <= readdata_next;
    state <= state_next;
    data_out <= data_out_next;
    rw <= rw_next;
    e <= e_next;
    rs <= rs_next;
    seq <= seq_next;
  end
end

always @*
begin
  on_next = on;
  readdata_next = readdata;
  state_next = state;
  data_out_next = data_out;
  e_next = e;
  rw_next = rw;
  rs_next = rs;
  seq_next = seq;
  if (write) begin
    case (address)
      6'h20: on_next = writedata[0];
      6'h21: begin
        if (state == STATE_IDLE) begin
          state_next = STATE_COMMAND;
          data_out_next = writedata[7:0];
        end
      end
      6'h22: begin
        if (state == STATE_IDLE)
          state_next = STATE_INIT;
      end
      default: begin
        if (state == STATE_IDLE) begin
          state_next = STATE_DATA;
          data_out_next = writedata[7:0];
        end
      end
    endcase
  end
  if (read) begin
    case (address)
      6'h20: readdata_next = { 4'h00, state, 7'h0, on };
      default: readdata_next = 32'habcd1234;
    endcase
  end
  case (state)
    STATE_IDLE: begin
    end
    STATE_COMMAND: begin
      rs_next = 1'b0;
      rw_next = 1'b0;
      case (seq)
        8'h03: begin
          e_next = 1'b1;
          seq_next = seq + 1'h1;
        end
        8'h10: begin
          e_next = 1'b0;
          seq_next = seq + 1'h1;
        end
        8'h11: begin
          seq_next = 8'h00;
          rs_next = 1'b1;
          rw_next = 1'b1;
          state_next = STATE_IDLE;
        end
        default: seq_next = seq + 1'h1; 
      endcase
    end
    STATE_INIT: begin
    end
    STATE_DATA: begin
      rw_next = 1'b0;
      case (seq)
        8'h03: begin
          e_next = 1'b1;
          seq_next = seq + 1'h1;
        end
        8'h10: begin
          e_next = 1'b0;
          seq_next = seq + 1'h1;
        end
        8'h11: begin
          seq_next = 8'h00;
          rw_next = 1'b1;
          state_next = STATE_IDLE;
        end
        default: seq_next = seq + 1'h1; 
      endcase
    end
  endcase
end

endmodule
