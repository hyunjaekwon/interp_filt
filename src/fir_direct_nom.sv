module fir_direct_nom #(
    parameter DATA_WIDTH      = 5,
    parameter TAP_COEFF_WIDTH = 5,
    parameter NUM_TAPS        = 50
)(
    input                               clk,
    input                               rst,
    input  signed [DATA_WIDTH-1:0]      in,
    output signed [DATA_WIDTH-1:0]      out,
    input  signed [TAP_COEFF_WIDTH-1:0] tap_coeffs [NUM_TAPS-1:0]//,
    // output signed [DATA_WIDTH-1:0] mult_out   [NUM_TAPS-1:0]
);

logic signed [DATA_WIDTH-1:0] in_flopped [NUM_TAPS-1:0];
logic signed [DATA_WIDTH-1:0] mult_out   [NUM_TAPS-1:0];
logic signed [DATA_WIDTH-1:0] out_pre_flopped, out_flopped;

logic signed [TAP_COEFF_WIDTH-1:0] tap_coeffs_flopped [NUM_TAPS-1:0];
// logic rst_flopped;

always @ (posedge clk or posedge rst) begin
    // rst_flopped   <= rst;
    if (rst) begin
        out_flopped <= '0;
        for (integer i=0; i<NUM_TAPS; i+=1) begin
            tap_coeffs_flopped[i] <= '0;
            in_flopped[i]         <= '0;
        end // for (integer i=0; i<NUM_TAPS; i+=1)
    end // if (rst)
    else begin
        in_flopped[0]         <= in;
        out_flopped           <= out_pre_flopped;
        tap_coeffs_flopped[0] <= tap_coeffs[0];
        for (integer i=1; i<NUM_TAPS; i+=1) begin
            tap_coeffs_flopped[i] <= tap_coeffs[i];
            in_flopped[i]         <= in_flopped[i-1];
        end // for (integer i=1; i<NUM_TAPS; i+=1)
    end // else

    // in_flopped[0] <= rst_flopped ? '0 : in;
    // out_flopped   <= rst_flopped ? '0 : out_pre_flopped;

    // tap_coeffs_flopped[0] <= rst_flopped ? '0 : tap_coeffs[0];
    // for (integer i=1; i<NUM_TAPS; i+=1) begin
    //     tap_coeffs_flopped[i] <= rst_flopped ? '0 : tap_coeffs[i];
    //     in_flopped[i]         <= rst_flopped ? '0 : in_flopped[i-1];
    // end // for (integer i=1; i<NUM_TAPS; i+=1)
end // always @ (posedge clk or posedge rst)

assign out = out_flopped;

genvar i;
for (i=0; i<NUM_TAPS; i=i+1) begin: mult
    mult #(
        .DATA_WIDTH(DATA_WIDTH),
        .TAP_COEFF_WIDTH(TAP_COEFF_WIDTH)
    ) mult (
        .in(in_flopped[i]),
        .out(mult_out[i]),
        .tap_coeff(tap_coeffs_flopped[i])
    );
end // mult

add_sat #(
    .DATA_WIDTH(DATA_WIDTH),
    .NUM_TAPS(NUM_TAPS)
) add_sat (
    .in(mult_out),
    .out(out_pre_flopped)
);

endmodule
