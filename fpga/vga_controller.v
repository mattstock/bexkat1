module vga_controller(hs,vs, reset_n, clock, active, x, y);

// Simple VGA timing and cursor generator
output hs, vs;
output active;
input reset_n;
input clock;
output [9:0] x, y;

// VESA 640x480 @ 72Hz, pixel clock is 31.5MHz
localparam [9:0]	H_SYNC_INT	=	10'd64;   
localparam [9:0] H_SYNC_BACK	=	10'd120;   
localparam [9:0] H_SYNC_ACT	=	10'd640;
localparam [9:0] H_SYNC_FRONT=	10'd16;  
localparam [9:0] H_SYNC_TOTAL=	H_SYNC_ACT+H_SYNC_FRONT+H_SYNC_INT+H_SYNC_BACK;
localparam [9:0] V_SYNC_INT	=	10'd3;
localparam [9:0] V_SYNC_BACK	=	10'd16;
localparam [9:0] V_SYNC_ACT	=	10'd480;
localparam [9:0] V_SYNC_FRONT=	10'd1;
localparam [9:0] V_SYNC_TOTAL=	V_SYNC_ACT+V_SYNC_FRONT+V_SYNC_INT+V_SYNC_BACK;

parameter	X_START		=	H_SYNC_INT+H_SYNC_BACK;
parameter	Y_START		=	V_SYNC_INT+V_SYNC_BACK;

reg [9:0] h_count, h_count_next;
reg [9:0] v_count, v_count_next;
reg [9:0] x, x_next;
reg [9:0] y, y_next;

assign active = h_count > X_START && h_count < X_START+H_SYNC_ACT && v_count > Y_START && v_count < Y_START+V_SYNC_ACT;

assign vs = (v_count >= V_SYNC_INT);
assign hs = (h_count >= H_SYNC_INT);

always @(posedge clock or negedge reset_n)
begin
  if (!reset_n) begin
    h_count <= 10'h0;
    v_count <= 10'h0;
    x <= 10'h0;
    y <= 10'h0;
  end else begin
    h_count <= h_count_next;
    v_count <= v_count_next;
    x <= x_next;
    y <= y_next;
  end
end

always @(*)
begin
  h_count_next = h_count;
  v_count_next = v_count;
  x_next = x;
  y_next = y;
  if (h_count > X_START && h_count < X_START+H_SYNC_ACT)
    x_next = x + 1'b1;
  if (h_count == H_SYNC_TOTAL) begin
    x_next = 10'h0;
    h_count_next = 10'h0;
    if (v_count > Y_START && v_count < Y_START+V_SYNC_ACT)
      y_next = y + 1'b1;
    if (v_count < V_SYNC_TOTAL)
      v_count_next = v_count + 1'b1;
    else begin
      v_count_next = 10'h0;
      y_next = 10'h0;
    end
  end else
    h_count_next = h_count + 1'b1;
end

endmodule