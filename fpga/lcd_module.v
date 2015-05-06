module lcd_module(
  input clk,
  input rst_n,
  input read,
  input write,
  input [5:0] address,
  output reg [31:0] readdata,
  input [31:0] writedata,
  input [3:0] be,
  output e,
  output [7:0] data_out,
  output reg on,
  output rw,
  output rs);

reg on_next;
reg [31:0] readdata_next;
  
// w 0x20: on/off
// w 0x21: send command
// r 0x20: read on/off
// r 0x21: busy
// w 0x00-1f: screen pos

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    on <= 1'b0;
    readdata <= 'h0;
  end else begin
    on <= on_next;
    readdata <= readdata_next;
  end
end

always @*
begin
  on_next = on;
  readdata_next = readdata;
  if (read) begin
    case (address)
      6'h20: on_next = writedata[0];
      6'h21: begin
        // submit command
      end
      default: begin
        // submit data
      end
    endcase
  end
  if (write) begin
    case (address)
      6'h20: readdata_next = { 30'h0, on };
      default: readdata_next = 32'habcd1234;
    endcase
  end
end

endmodule
