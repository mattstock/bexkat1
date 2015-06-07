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
  input sd_wp_n,
  output reg [7:0] spi_selects,
  input wp_n,
  input [15:0] sw);

reg lcd_read, lcd_write, uart1_read, uart0_read, uart1_write, uart0_write, spi_read, spi_write;
wire [31:0] spi_readdata, uart0_readdata, uart1_readdata, lcd_readdata, sw_readdata;

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
  if (address >= 11'h000 && address <= 11'h007) begin
    uart0_read = read;
    uart0_write = write;
    data_out = uart0_readdata;
  end else if (address >= 11'h008 && address <= 11'h00f) begin
    uart1_read = read;
    uart1_write = write;
    data_out = uart1_readdata;
  end else if (address >= 11'h010 && address <= 11'h013) begin
    data_out = { 16'h0000, sw }; // Trivial, so just do it.  Should it be synced?  Maybe.
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
  .data_out(uart0_readdata), .select(uart0_read|uart0_write), .write(uart0_write), .address(address[2]));
uart uart1(.clk(clk), .rst_n(rst_n), .rx(1'b0), .tx(tx1), .data_in(data_in), .be(be),
  .data_out(uart1_readdata), .select(uart1_read|uart1_write), .write(uart1_write), .address(address[2]));
spi_master spi0(.clk(clk), .rst_n(rst_n), .miso(miso), .mosi(mosi), .sclk(sclk), .selects(spi_selects), .wp_n(sd_wp_n),
  .be(be), .data_in(data_in), .data_out(spi_readdata), .read(spi_read), .write(spi_write), .address(address[2]));

endmodule
