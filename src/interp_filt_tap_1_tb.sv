`timescale 1 ns /  1 ps

module interp_filt_tap_1_tb();

reg clk, rst;
integer cycle_cnt;

localparam MAX_CYCLES      = 70;
localparam DATA_WIDTH      = 6;
localparam TAP_COEFF_WIDTH = 6;

logic signed [DATA_WIDTH-1:0]      in;
logic signed [DATA_WIDTH-1:0]      out;
logic signed [TAP_COEFF_WIDTH-1:0] tap_coeff;

assign tap_coeff = '1 >> 1;

always #(0.5*`CLOCK_PERIOD) clk <= ~clk;

always @(posedge clk) begin
    in <= in + 'b1;
    $display("cycle_cnt=%d: in=%d, tap_coeff=%d, out=%d", cycle_cnt, in, tap_coeff, out);
    cycle_cnt = cycle_cnt + 1;
    if (cycle_cnt > MAX_CYCLES) begin
        $vcdplusoff;
        $finish;
    end // if (cycle_cnt > MAX_CYCLES)
end // always @(posege clk)

interp_filt_tap_1 #(
    .DATA_WIDTH(DATA_WIDTH),
    .TAP_COEFF_WIDTH(TAP_COEFF_WIDTH)
) dut (
    .clk,
    .rst,
    .in,
    .out,
    .tap_coeff
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

