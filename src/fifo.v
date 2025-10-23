module fifo #(parameter WIDTH = 8, parameter LOGDEPTH = 3) (
    input clk,
    input reset,

    input enq_val,
    input [WIDTH-1:0] enq_data,
    output enq_rdy,

    output deq_val,
    output [WIDTH-1:0] deq_data,
    input deq_rdy

);

localparam DEPTH = (1 << LOGDEPTH);

reg [WIDTH-1:0] buffer [DEPTH-1:0];
reg [LOGDEPTH-1:0] rptr, wptr;

reg [LOGDEPTH:0] count;

wire full;
wire empty;

assign full = (count == DEPTH);
assign empty = (count == 0);
assign enq_rdy = !full;
assign deq_val = !empty;
assign deq_data = buffer[rptr];

wire enq_time = enq_val & enq_rdy;
wire deq_time = deq_val & deq_rdy;

integer i;
initial begin

  for (i = 0; i < DEPTH; i = i + 1) begin
    buffer[i] = 0;
  end

  rptr = 0;
  wptr = 0;
  count = 0;

end

always @(posedge clk) begin
  if (reset) begin
    for (i = 0; i < DEPTH; i = i + 1) begin
      buffer[i] <= 0;
    end
    rptr <= 0;
    wptr <= 0;
    count <= 0;
  end else begin
    if (enq_time) begin
      buffer[wptr] <= enq_data;
      if (wptr == (DEPTH - 1))
        wptr <= 0;
      else
        wptr <= wptr + 1;
    end

    if (deq_time) begin
      if (rptr == (DEPTH - 1))
        rptr <= 0;
      else
        rptr <= rptr + 1;
    end

    case ({enq_time, deq_time})
      2'b10: count <= count + 1;
      2'b01: count <= count - 1;
      default: count <= count;
    endcase
  end
end

endmodule
