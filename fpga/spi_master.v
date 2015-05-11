module spi_master(clk, rst_n, miso, mosi, sclk, ss, data_in, data_out, write, select, address);

parameter clkfreq = 50000000;
parameter speed = 500000; // 500kHz for now

input clk;
input rst_n;
input miso;
output mosi;
output sclk;
output [1:0] ss;
input [31:0] data_in;
output [31:0] data_out;
input write;
input select;
input [3:0] address;

reg tx_start;
wire tx_done;
wire [7:0] rx_in;

reg [7:0] tx_byte, tx_byte_next;
reg [7:0] rx_byte, rx_byte_next;
reg [1:0] ss, ss_next;
reg [31:0] conf, conf_next;
reg [1:0] state, state_next;

localparam STATE_IDLE = 2'b00, STATE_BUSY = 2'b01, STATE_COMPLETE = 2'b10, STATE_RELEASE = 2'b11;

/* memory logic
    This mimics the UART logic on the memory side pretty closely.
    The main differences are that we need to have a register available for the slave select,
    which drives the outputs directly. */
always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    tx_byte <= 8'h00;
    rx_byte <= 8'h00;
    ss <= 2'b11;
    conf <= 'h0;
    state <= STATE_IDLE;
  end else begin
    tx_byte <= tx_byte_next;
    rx_byte <= rx_byte_next;
    ss <= ss_next;
    conf <= conf_next;
    state <= state_next;
  end
end

always @*
begin
  tx_byte_next = tx_byte;
  rx_byte_next = rx_byte;
  ss_next = ss;
  conf_next = conf;
  state_next = state;
  tx_start = 1'b0;
  case ({select, write})
    'b11: begin    
      data_out = 'h0;
      case (address)
        'h0: begin
          if (state == STATE_IDLE) begin
            state_next = STATE_BUSY;
            tx_start = 1'b1;
            tx_byte_next = data_in[7:0];
          end
        end
        'h2: ss_next = data_in[1:0];
        'h4: conf_next = data_in;
        default: begin end
      endcase
    end
    'b10: begin
      case (address)
        'h0: begin
          data_out = {16'h0000, state, 6'h00, rx_byte};
          if (state == STATE_COMPLETE)
            state_next = STATE_RELEASE;
        end
        'h2: data_out = { 30'h0000, ss };
        'h4: data_out = conf;
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

spi_xcvr #(.clkfreq(clkfreq), .speed(speed)) xcvr0(.clk(clk), .rst_n(rst_n), .conf(conf), .start(tx_start), .rx(rx_in), .done(tx_done), .tx(data_in[7:0]), 
  .miso(miso), .mosi(mosi), .sclk(sclk));

endmodule
