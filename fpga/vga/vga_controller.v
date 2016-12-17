module vga_controller(hs,vs, reset_n, clock, active, x, y, pixel);

// Simple VGA timing and cursor generator
output hs, vs;
output active;
input reset_n;
input clock;
output [15:0] x, y;
output [18:0] pixel;

// VESA 640x480 @ 60Hz, pixel clock is 25MHz
localparam [15:0]	H_SYNC_INT	=	16'd95;  // 3.8us / 40ns    
localparam [15:0] H_SYNC_BACK	=	16'd48;  // 1.9us / 40ns 
localparam [15:0] H_SYNC_ACT	=	16'd640; // 25.4us / 40ns
localparam [15:0] H_SYNC_FRONT=	16'd15;  // 0.6us / 40ns
localparam [15:0] H_SYNC_TOTAL=	H_SYNC_ACT+H_SYNC_FRONT+H_SYNC_INT+H_SYNC_BACK;
localparam [15:0] V_SYNC_INT	=	16'd2;
localparam [15:0] V_SYNC_BACK	=	16'd33;
localparam [15:0] V_SYNC_ACT	=	16'd480;
localparam [15:0] V_SYNC_FRONT=	16'd10;
localparam [15:0] V_SYNC_TOTAL=	V_SYNC_ACT+V_SYNC_FRONT+V_SYNC_INT+V_SYNC_BACK;

parameter	X_START		=	H_SYNC_INT+H_SYNC_BACK;
parameter	Y_START		=	V_SYNC_INT+V_SYNC_BACK;

reg [15:0] h_count, h_count_next;
reg [15:0] v_count, v_count_next;
reg [15:0] x, x_next;
reg [15:0] y, y_next;
reg [18:0] pixel, pixel_next;

wire v_active, h_active;

assign v_active = v_count > Y_START && v_count < Y_START+V_SYNC_ACT;
assign h_active = h_count > X_START && h_count < X_START+H_SYNC_ACT;
assign active = v_active && h_active;

assign vs = (v_count >= V_SYNC_INT);
assign hs = (h_count >= H_SYNC_INT);

always @(posedge clock or negedge reset_n)
begin
  if (!reset_n) begin
    pixel <= 19'h0;
    h_count <= 16'h0;
    v_count <= 16'h0;
    x <= 16'h0;
    y <= 16'h0;
  end else begin
    pixel <= pixel_next;
    h_count <= h_count_next;
    v_count <= v_count_next;
    x <= x_next;
    y <= y_next;
  end
end

always @(*)
begin
  pixel_next = pixel;
  h_count_next = h_count;
  v_count_next = v_count;
  x_next = x;
  y_next = y;
  
  if (h_count < H_SYNC_TOTAL) begin
    h_count_next = h_count + 1'b1;
    if (active) begin
      x_next = x + 1'b1;
      pixel_next = pixel + 1'b1;
    end else
      x_next = 16'h0;
  end else begin
    h_count_next = 16'h0;
    if (v_count < V_SYNC_TOTAL) begin
      v_count_next = v_count + 1'b1;
      if (v_active) begin
        y_next = y + 1'b1;
        pixel_next = pixel + 1'b1;
      end else begin
        y_next = 16'h0;
        pixel_next = 19'h0;
      end
    end else
      v_count_next = 16'h0;
  end
end

endmodule