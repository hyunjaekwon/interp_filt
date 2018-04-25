`timescale 1 ns /  1 ps

module interp_filt_tb();

reg clk, rst;
integer cycle_cnt;

localparam MAX_CYCLES      = 40;
localparam DATA_WIDTH      = 5;
localparam TAP_COEFF_WIDTH = 5;
localparam NUM_TAPS        = 2;

logic signed [DATA_WIDTH-1:0]      in;
logic signed [DATA_WIDTH-1:0]      out;
logic signed [TAP_COEFF_WIDTH-1:0] tap_coeffs [NUM_TAPS-1:0];

genvar i;
for (i=0; i<NUM_TAPS; i+=1) begin
    assign tap_coeffs[i] = '1 >> 1;
end // for (i=0; i<NUM_TAPS; i+=1)

always #(0.5*`CLOCK_PERIOD) clk <= ~clk;

always @(posedge clk) begin
    in <= in + 'b1;
    $display("cycle_cnt=%d: in=%d, out=%d", cycle_cnt, in, out);
    cycle_cnt = cycle_cnt + 1;
    if (cycle_cnt > MAX_CYCLES) begin
        $vcdplusoff;
        $finish;
    end // if (cycle_cnt > MAX_CYCLES)
end // always @(posege clk)

interp_filt #(
    .DATA_WIDTH(DATA_WIDTH),
    .TAP_COEFF_WIDTH(TAP_COEFF_WIDTH),
    .NUM_TAPS(NUM_TAPS)
) dut (
    .clk,
    .rst,
    .in,
    .out,
    .tap_coeffs
);

initial begin
    clk = '0;
    cycle_cnt = 0;
    in = '1;
    rst = '1;
    $vcdpluson;
    #(1.5*`CLOCK_PERIOD);
    rst = '0;
end

endmodule

