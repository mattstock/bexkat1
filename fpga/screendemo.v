module screendemo(clk, rst_n, write, pixel, row, col);

input clk;
input rst_n;
output write;
output [23:0] pixel;
output [3:0] row;
output [4:0] col;

reg [9:0] count, count_next;
reg [23:0] pixel, pixel_next;
reg [1:0] state, state_next;
reg [23:0] delay, delay_next;
reg [4:0] highcol, highcol_next;
reg pingpong, pingpong_next;

assign write = (state == STATE_WRITE);
assign col = count[4:0];
assign row = count[8:5];

parameter [5:0] COLS = 32;
parameter [5:0] ROWS = 16;
localparam [1:0] STATE_LOAD = 2'b00, STATE_WRITE = 2'b01, STATE_DONE = 2'b10;

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    count <= 1'b0;
    pixel <= 24'hffffff;
    state <= STATE_LOAD;
    delay <= 24'h000000;
    highcol <= 5'b10000;
    pingpong <= 1'b0;
  end else begin
    state <= state_next;
    pixel <= pixel_next;
    count <= count_next;
    delay <= delay_next;
    highcol <= highcol_next;
    pingpong <= pingpong_next;
  end
end

reg [7:0] suba, subb;

function [7:0] gradient;
input [4:0] a, b;
case (a < b ? b-a : a-b)
  'h00: gradient = 'hff;
  'h01: gradient = 'hdf;
  'h02: gradient = 'haf;
  'h03: gradient = 'h8f;
  'h04: gradient = 'h5f;
  'h05: gradient = 'h3f;
  'h06: gradient = 'h24;
  'h07: gradient = 'h13;
  'h08: gradient = 'h0f;
  'h09: gradient = 'h0e;
  'h0a: gradient = 'h0c;
  'h0b: gradient = 'h08;
  'h0c: gradient = 'h04;
  default: gradient = 'h00;
endcase
endfunction

always @*
begin
  state_next = state;
  count_next = count;
  pixel_next = pixel;
  delay_next = delay;
  highcol_next = highcol;
  pingpong_next = pingpong;
  case (state)
    STATE_LOAD: begin
      suba = gradient(highcol, col);
      case (row)
        'h0: pixel_next = { 16'h0000, suba };
        'h1: pixel_next = { suba >> 1, suba, suba >> 2 };
        'h2: pixel_next = { suba, 8'h00, suba >> 2 };
        'h3: pixel_next = { suba >> 2, suba, 8'h00 };
        'h4: pixel_next = { suba >> 2, 16'h00 };
        'h5: pixel_next = { suba >> 3, suba >> 2, suba };
        'h6: pixel_next = { suba >> 2, suba >> 2, suba };
        'h7: pixel_next = { 16'h00, suba >> 3 };
        'h8: pixel_next = { suba, suba, 8'h00 };
        'h9: pixel_next = { suba >> 1, suba >> 1, suba >> 3 };
        'ha: pixel_next = { suba >> 2, suba >> 1, suba >> 3 };
        'hb: pixel_next = { suba >> 1, suba >> 2, suba >> 3 };
        'hc: pixel_next = { suba >> 3, suba >> 1, suba >> 3 };
        'hd: pixel_next = { suba >> 3, suba >> 2, suba >> 3 };
        'he: pixel_next = { suba, suba >> 1, suba >> 3 };
        'hf: pixel_next = { suba, suba >> 1, suba >> 3 };
        default: pixel_next = { 8'h00, suba >> 1, 8'h00 };
      endcase
      if (count < 512)
        state_next = STATE_WRITE;
      else begin
        state_next = STATE_DONE;
        delay_next = 'h1fffff;
      end
    end
    STATE_WRITE: begin
      state_next = STATE_LOAD;
      count_next = count + 1'b1;
    end
    STATE_DONE: begin
      if (delay == 24'h00000) begin
        state_next = STATE_LOAD;
        count_next = 1'b0;
        if (highcol == 5'h00 || highcol == 5'h1f) begin
          pingpong_next = ~pingpong;
          highcol_next = (pingpong ? highcol + 1'b1 : highcol - 1'b1);
        end else
          highcol_next = (pingpong ? highcol - 1'b1 : highcol + 1'b1);
      end else
        delay_next = delay - 1'b1;  
    end
  endcase
end

endmodule
