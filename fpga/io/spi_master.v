module spi_master(
  input clk_i,
  input rst_i,
  input miso,
  input cyc_i,
  input stb_i,
  output mosi,
  output sclk,
  output ack_o,
  output reg [7:0] selects,
  input codec_irq,
  input wp,
  input [3:0] sel_i,
  input [31:0] dat_i,
  output reg [31:0] dat_o,
  input we_i,
  input adr_i);

parameter clockfreq = 50000000;

// write
// 'h0: xxxxxxdd : spi byte out
// 'h1: sscfxixx : ss = selects, cf = config byte (speedselect, cpol, cpha)
// read
// 'h0: xxxxxxdd : spi byte in (clears ready flag)
// 'h1: sscfxiptr : ss = selects, cf = config byte, p = write protect, t = transmit ready, r = recv ready


reg tx_start;
wire tx_done;
wire [7:0] rx_in;

reg [7:0] rx_byte, rx_byte_next;
reg [7:0] selects_next;
reg [7:0] conf, conf_next;
reg state, state_next;
reg rx_unread, rx_unread_next;
reg tx_busy, tx_busy_next;
reg [31:0] dat_o_next;

assign ack_o = (state == STATE_DONE);

localparam STATE_IDLE = 1'h0, STATE_DONE = 1'h1;

always @(posedge clk_i or posedge rst_i)
begin
  if (rst_i) begin
    rx_byte <= 8'h00;
    selects <= 'hff;
    conf <= 'h00;
    dat_o <= 32'h0;
    rx_unread <= 1'b0;
    tx_busy <= 1'b0;
    state <= STATE_IDLE;
  end else begin
    rx_byte <= rx_byte_next;
    selects <= selects_next;
    conf <= conf_next;
    dat_o <= dat_o_next;
    state <= state_next;
    tx_busy <= tx_busy_next;
    rx_unread <= rx_unread_next;
  end
end

always @(*)
begin
  rx_byte_next = rx_byte;
  conf_next = conf;
  selects_next = selects;
  dat_o_next = dat_o;
  state_next = state;
  tx_busy_next = tx_busy;
  rx_unread_next = rx_unread;
  tx_start = 1'b0;
  
  case (state)
    STATE_IDLE: begin
      if (cyc_i & stb_i)
        case (adr_i)
          1'h0: begin
            if (we_i) begin
              if (~tx_busy) begin
                tx_start = 1'b1;
                tx_busy_next = 1'b1;
              end
              state_next = STATE_DONE;
            end else begin
              dat_o_next[7:0] = rx_byte;
              rx_unread_next = 1'b0;
              state_next = STATE_DONE;
            end
          end
          1'h1: begin
            if (we_i) begin
              if (sel_i[3])
                selects_next = dat_i[31:24];
              if (sel_i[2])
                conf_next = dat_i[23:16];
            end else
//              dat_o_next = { selects, conf, 12'h00, codec_irq, wp, tx_busy, rx_unread };
                dat_o_next = { selects, conf, 12'h00, 1'b1, wp, tx_busy, rx_unread };
            state_next = STATE_DONE;
          end
        endcase
    end
    STATE_DONE: state_next = STATE_IDLE;
  endcase
  if (tx_done && tx_busy) begin
    rx_byte_next = rx_in;
    tx_busy_next = 1'b0;
    rx_unread_next = 1'b1;
  end
end

spi_xcvr #(.clockfreq(clockfreq)) xcvr0(.clk_i(clk_i), .rst_i(rst_i), .conf(conf), .start(tx_start), .rx(rx_in), .done(tx_done), .tx(dat_i[7:0]), 
  .miso(miso), .mosi(mosi), .sclk(sclk));

endmodule