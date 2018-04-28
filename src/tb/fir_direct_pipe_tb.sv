`timescale 1 ns /  1 ps

module fir_direct_pipe_tb();

reg clk, rst;
integer cycle_cnt;

localparam DATA_WIDTH      = 5;
localparam TAP_COEFF_WIDTH = 5;
localparam NUM_TAPS        = 50;
localparam MAX_CYCLES      = (2 ** DATA_WIDTH) + (1.5 * NUM_TAPS);

logic signed [DATA_WIDTH-1:0]      in;
logic signed [DATA_WIDTH-1:0]      out;
logic signed [TAP_COEFF_WIDTH-1:0] tap_coeffs [NUM_TAPS-1:0];

genvar i;
for (i=2; i<NUM_TAPS/2; i+=1) begin
    logic signed [TAP_COEFF_WIDTH-1:0] coeff = 'b0;//('1 >> 2) - (i << 2);
    assign tap_coeffs[2*i]  =  (coeff < 0) ? '0 : coeff;
    assign tap_coeffs[2*i+1] = (coeff < 0) ? '0 : coeff;
end // for (i=0; i<NUM_TAPS; i+=1)
assign tap_coeffs[0] = '1 >> 3;
assign tap_coeffs[1] =  '1 >> 3;
assign tap_coeffs[2] = '1 >> 3;
assign tap_coeffs[3] =  '1 >> 3;

always #(0.5*`CLOCK_PERIOD) clk <= ~clk;
// logic signed [DATA_WIDTH-1:0] mult_out   [NUM_TAPS-1:0];
always @(posedge clk) begin
    in <= in + 'b1;
    // $display("cycle_cnt=%d: in=%d, out=%d, mult_out=%d,%d", cycle_cnt, in, out, mult_out[1], mult_out[0]);
    $display("cycle_cnt=%d: in=%d, out=%d", cycle_cnt, in, out);
    cycle_cnt = cycle_cnt + 1;
    if (cycle_cnt > MAX_CYCLES) begin
        $vcdplusoff;
        $finish;
    end // if (cycle_cnt > MAX_CYCLES)
end // always @(posege clk)

`ifdef SIM_RTL
    fir_direct_pipe #(
        .DATA_WIDTH(DATA_WIDTH),
        .TAP_COEFF_WIDTH(TAP_COEFF_WIDTH),
        .NUM_TAPS(NUM_TAPS)
    ) dut (
        .clk,
        .rst,
        .in,
        .out,
        .tap_coeffs//,
        // .mult_out
    );
`else
    logic signed [TAP_COEFF_WIDTH*NUM_TAPS-1:0] tap_coeffs_flattened;
    for (i=0; i<NUM_TAPS; i+=1) begin
        assign tap_coeffs_flattened[TAP_COEFF_WIDTH*(i+1)-1:TAP_COEFF_WIDTH*i] = tap_coeffs[i];
    end // for (i=0; i<NUM_TAPS; i+=1)
    fir_direct_pipe dut (
        .clk,
        .rst,
        .in,
        .out,
        .tap_coeffs(tap_coeffs_flattened)
    );
`endif

initial begin
    clk = '0;
    cycle_cnt = 0;
    in = '1;
    rst = '1;
    $display("Starting Sim",);
    $vcdpluson;
    #(1.5*`CLOCK_PERIOD);
    rst = '0;
end

endmodule

