module spi_master(
  input clk,
  input rst_n,
  input miso,
  output mosi,
  output sclk,
  output reg [7:0] selects,
  output reg [1:0] itd,
  input wp_n,
  input [3:0] be,
  input [31:0] data_in,
  output [31:0] data_out,
  input read,
  input write,
  input address);

parameter clockfreq = 50000000;

// write
// 'h0: xxxxxxdd : spi byte out
// 'h1: sscfxixx : ss = selects, cf = config byte (speedselect, cpol, cpha), i = xxbd, backlight, d/c mode
// read
// 'h0: xxxxxxdd : spi byte in (clears ready flag)
// 'h1: sscfxiptr : ss = selects, cf = config byte, p = write protect, t = transmit ready, r = recv ready


reg tx_start;
wire tx_done;
wire [7:0] rx_in;

reg [7:0] tx_byte, tx_byte_next;
reg [7:0] rx_byte, rx_byte_next;
reg [7:0] selects_next;
reg [7:0] conf, conf_next;
reg [1:0] state, state_next;
reg [1:0] itd_next;

localparam STATE_IDLE = 2'b00, STATE_BUSY = 2'b01, STATE_COMPLETE = 2'b10, STATE_RELEASE = 2'b11;

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    tx_byte <= 8'h00;
    rx_byte <= 8'h00;
    selects <= 'hff;
    conf <= 'h00;
    itd <= 2'h0;
    state <= STATE_IDLE;
  end else begin
    tx_byte <= tx_byte_next;
    rx_byte <= rx_byte_next;
    selects <= selects_next;
    conf <= conf_next;
    itd <= itd_next;
    state <= state_next;
  end
end

always @*
begin
  tx_byte_next = tx_byte;
  rx_byte_next = rx_byte;
  conf_next = conf;
  itd_next = itd;
  selects_next = selects;
  state_next = state;
  tx_start = 1'b0;
  case ({read, write})
    'b01: begin
      data_out = 'h0;
      case (address)
        'h0: begin
          if (state == STATE_IDLE && be[0]) begin
            state_next = STATE_BUSY;
            tx_start = 1'b1;
            tx_byte_next = data_in[7:0];
          end
        end
        'h1: begin
          if (be[3])
            selects_next = data_in[31:24];
          if (be[2])
            conf_next = data_in[23:16];
          if (be[1])
            itd_next = data_in[9:8];
        end 
        default: begin end
      endcase
    end
    'b10: begin
      case (address)
        'h0: begin
          data_out = {24'h000000, rx_byte};
          if (state == STATE_COMPLETE)
            state_next = STATE_RELEASE;
        end
        'h1: data_out = { selects, conf, 6'h00, itd, 5'h00, ~wp_n, (state != STATE_BUSY), (state == STATE_COMPLETE) };
        default: data_out = 'h0;
      endcase
    end
    default: begin
      data_out = 'h0;
      if (state == STATE_RELEASE)
        state_next = STATE_IDLE;
    end
  endcase
  if (tx_done && (state == STATE_BUSY)) begin
    rx_byte_next = rx_in;
    state_next = STATE_COMPLETE;
  end
end

spi_xcvr #(.clockfreq(clockfreq)) xcvr0(.clock(clk), .reset_n(rst_n), .conf(conf), .start(tx_start), .rx(rx_in), .done(tx_done), .tx(data_in[7:0]), 
  .miso(miso), .mosi(mosi), .sclk(sclk));

endmodule