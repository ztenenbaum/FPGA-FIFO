`timescale 1ns/1ps

module fifo_tb();

  // Parameters
  localparam WIDTH = 8;
  localparam LOGDEPTH = 3; // depth = 8

  reg clk;
  reg reset;

  reg enq_val;
  reg [WIDTH-1:0] enq_data;
  wire enq_rdy;

  wire deq_val;
  wire [WIDTH-1:0] deq_data;
  reg deq_rdy;

  // Instantiate 
  fifo #(.WIDTH(WIDTH), .LOGDEPTH(LOGDEPTH)) dut (
    .clk(clk),
    .reset(reset),
    .enq_val(enq_val),
    .enq_data(enq_data),
    .enq_rdy(enq_rdy),
    .deq_val(deq_val),
    .deq_data(deq_data),
    .deq_rdy(deq_rdy)
  );

  initial clk = 0;
  always #5 clk = ~clk; // 100MHz clock (10ns period)

  integer i;
  reg [WIDTH-1:0] expected_value;

  initial begin
    $dumpfile("fifo_tb.vcd"); // Dump waves
    $dumpvars(0, fifo_tb);

    enq_val = 0;
    enq_data = 0;
    deq_rdy = 0;
    reset = 1;
    #20;
    reset = 0;

    for (i = 0; i < 8; i = i + 1) begin
      @(negedge clk);
      if (enq_rdy) begin
        enq_val = 1;
        enq_data = i + 8'hA0; // some recognizable values
        $display("[%0t] Enqueue: %h", $time, enq_data);
      end
      @(negedge clk);
      enq_val = 0;
    end

    repeat (3) @(negedge clk);

    deq_rdy = 1;
    for (i = 0; i < 8; i = i + 1) begin
      @(posedge clk);
      if (deq_val) begin
        expected_value = i + 8'hA0;
        if (deq_data !== expected_value)
          $display("[%0t] ERROR: Expected %h, got %h", $time, expected_value, deq_data);
        else
          $display("[%0t] Dequeue: %h (PASSED)", $time, deq_data);
      end
    end

    deq_rdy = 0;
    @(negedge clk);
    $display("[%0t] ALL TESTS PASSED", $time);
    $finish;
  end

endmodule
