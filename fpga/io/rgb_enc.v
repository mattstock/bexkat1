module rgb_enc(clk, rst_n, quad, button, rgb_out, write, address, data_in, data_out);

input clk;
input rst_n;
input [1:0] quad;
input button;
output [2:0] rgb_out;
input write;
input [1:0] address;
input [15:0] data_in;
output [15:0] data_out;

reg [15:0] data_out;
wire [5:0] value;

reg [7:0] red, red_next, green, green_next, blue, blue_next;
reg [15:0] counter;

always @*
begin
  case (address)
    'b00: data_out = { red, green };
    'b01: data_out = { blue, 8'h00 };
    'b10: data_out = { 15'h0000, button };
    'b11: data_out = { 10'h0000, value };
    default: data_out = 16'h0000;
  endcase
  rgb_out[0] = (counter[15:8] < blue);
  rgb_out[1] = (counter[15:8] < green);
  rgb_out[2] = (counter[15:8] < red);  
end

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    counter <= 16'b0;
    red <= 8'h00;
    green <= 8'h00;
    blue <= 8'h00;
  end else begin
    counter <= counter + 1'b1;
    red <= red_next;
    green <= green_next;
    blue <= blue_next;
  end
end

always @*
begin
  red_next = red;
  green_next = green;
  blue_next = blue;
  if (write)
    case (address)
      'b01: blue_next = data_in[15:8];
      'b00: begin
        red_next = data_in[15:8];
        green_next = data_in[7:0];
      end
      default: red_next = red; // just to shut the compiler up
    endcase
end

// quadrature encoder outputs 0-23
quadenc q0(.clk(clk), .rst_n(rst_n), .quadA(quad[0]), .quadB(quad[1]), .count(value));

endmodule
