module iocontroller(
  input clk,
  input rst_n,
  input read,
  input write,
  input [10:0] address,
  output reg [31:0] data_out,
  input [31:0] data_in,
  input [3:0] be,
  output lcd_e,
  output [7:0] lcd_data,
  output lcd_on,
  output lcd_rw,
  output lcd_rs,
  output tx0,
  input rx0,
  output tx1,
  input miso,
  output mosi,
  output sclk,
  output wait_out,
  input sd_wp_n,
  input touch_in,
  output fan,
  output itd_dc,
  output itd_backlight,
  output reg [7:0] spi_selects,
  output [1:0] interrupt,
  input [15:0] sw,
  input [3:0] kbd);

reg lcd_read, lcd_write, uart1_read, uart0_read, uart1_write, uart0_write, spi_read, spi_write;
wire [31:0] spi_readdata, uart0_readdata, uart1_readdata, lcd_readdata, sw_readdata;

reg [1:0] iodelay, iodelay_next;

assign wait_out = iodelay[0];

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    iodelay <= 2'b11;
  end else begin
    iodelay <= iodelay_next;
  end
end

always @*
begin
  uart0_read = 1'b0;
  uart1_read = 1'b0;
  lcd_read = 1'b0;
  spi_read = 1'b0;
  uart0_write = 1'b0; 
  uart1_write = 1'b0;
  lcd_write = 1'b0;
  spi_write = 1'b0;
  data_out = 'h0;
  if (read|write)
    iodelay_next = { iodelay[0], 1'b0 };
  else
    iodelay_next = 2'b11;
  
  if (address >= 11'h000 && address <= 11'h007) begin
    uart0_read = read;
    uart0_write = write;
    data_out = uart0_readdata;
  end else if (address >= 11'h008 && address <= 11'h00f) begin
    uart1_read = read;
    uart1_write = write;
    data_out = uart1_readdata;
  end else if (address >= 11'h010 && address <= 11'h013) begin
    data_out = { 12'h0000, ~kbd, sw }; // Trivial, so just do it.  Should it be synced?  Maybe.
  end else if (address >= 11'h020 && address <= 11'h027) begin
    spi_read = read;
    spi_write = write;
    data_out = spi_readdata;
  end else if (address >= 11'h400 && address <= 11'h4ff) begin
    lcd_read = read;
    lcd_write = write;
    data_out = lcd_readdata;
  end
end

lcd_module lcd0(.clk(clk), .rst_n(rst_n), .read(lcd_read), .write(lcd_write), .writedata(data_in), 
  .readdata(lcd_readdata), .be(be), .address(address[8:2]),
  .e(lcd_e), .data_out(lcd_data), .rs(lcd_rs), .on(lcd_on), .rw(lcd_rw));  
uart #(.baud(115200)) uart0(.clk(clk), .rst_n(rst_n), .rx(rx0), .tx(tx0), .data_in(data_in), .be(be),
  .data_out(uart0_readdata), .select(uart0_read|uart0_write), .write(uart0_write), .address(address[2]), .interrupt(interrupt));
uart uart1(.clk(clk), .rst_n(rst_n), .rx(1'b0), .tx(tx1), .data_in(data_in), .be(be),
  .data_out(uart1_readdata), .select(uart1_read|uart1_write), .write(uart1_write), .address(address[2]));
spi_master spi0(.clk(clk), .rst_n(rst_n), .miso(miso), .mosi(mosi), .sclk(sclk), .selects(spi_selects), .wp_n(sd_wp_n),
  .be(be), .data_in(data_in), .data_out(spi_readdata), .read(spi_read), .write(spi_write), .address(address[2]), .itd({itd_backlight, itd_dc}),
  .touch(touch_in));

fan_ctrl fan0(.clk(clk), .rst_n(rst_n), .fan_pwm(fan));

endmodule
