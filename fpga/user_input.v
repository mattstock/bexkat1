module user_input(clk, ps2_clock, ps2_data, rst_n, data_read, data_ready, data_out);

input clk;
input ps2_clock;
input ps2_data;
input rst_n;
output data_ready;
output [7:0] data_out;
input data_read;

wire kbd_event;
wire [7:0] kbd_byte;
wire [7:0] ascii_byte;
wire fifo_empty;

assign data_ready = ~fifo_empty;

localparam [7:0] KEY_EXT = 8'he0, KEY_ESC = 8'h76, KEY_BACK = 8'h66, KEY_BREAK = 8'hf0;
localparam [7:0] KEY_UP = 8'h75, KEY_DOWN = 8'h72, KEY_LEFT = 8'h6b, KEY_RIGHT = 8'h74;

reg [3:0] state, state_next;
reg ext_key, ext_key_next;
reg store, store_next;

localparam [3:0] STATE_IDLE = 4'h0, STATE_EXT = 4'h1, STATE_BREAK = 4'h2, STATE_MAKE = 4'h3;

always @(posedge clk or negedge rst_n)
begin
  if (!rst_n) begin
    state <= STATE_IDLE;
    ext_key <= 1'b0;
    store <= 1'b0;
  end else begin
    state <= state_next;
    ext_key <= ext_key_next;
    store <= store_next;
  end
end

always @(*)
begin
  state_next = state;
  ext_key_next = ext_key;
  store_next = store;
  case (state)
    STATE_IDLE:  begin
      store_next = 1'b0;
      if (kbd_event) begin
        case (kbd_byte)
          KEY_EXT: state_next = STATE_EXT;
          KEY_BREAK: state_next = STATE_BREAK;
          default: state_next = STATE_MAKE; // Translate the key to ascii
        endcase
      end
    end
    STATE_EXT: begin
      if (kbd_event)
        case (kbd_byte)
          8'hf0: state_next = STATE_BREAK;
          default: state_next = STATE_IDLE; // Don't handle any extended keys right now
        endcase
    end
    STATE_BREAK: if (kbd_event) state_next = STATE_IDLE;
    STATE_MAKE: begin
      state_next = STATE_IDLE;
      if (ascii_byte != 8'h00)
        store_next = 1'b1;
    end
  endcase
end

ps2_kbd kbd0(.sys_clock(clk), .reset_n(rst_n), .ps2_clock(ps2_clock), .ps2_data(ps2_data),
  .event_ready(kbd_event), .event_data(kbd_byte));

scancodes mem1(.clock(clk), .address(kbd_byte), .q(ascii_byte));
keyfifo mem2(.clock(clk), .aclr(~rst_n), .data(ascii_byte), .rdreq(data_read), .wrreq(store), .empty(fifo_empty), .q(data_out));

endmodule



