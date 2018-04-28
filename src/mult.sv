module mult #(
    parameter DATA_WIDTH      = 6,
    parameter TAP_COEFF_WIDTH = 6
)(
    input  signed [DATA_WIDTH-1:0]      in,
    output signed [DATA_WIDTH-1:0]      out,
    input  signed [TAP_COEFF_WIDTH-1:0] tap_coeff
);

logic signed [TAP_COEFF_WIDTH + DATA_WIDTH - 2 : 0] mult_out; // -1 because signed multiplication
assign mult_out = ($signed(in) * $signed(tap_coeff));
assign out = $signed(mult_out[TAP_COEFF_WIDTH + DATA_WIDTH - 2 : TAP_COEFF_WIDTH - 1]);

endmodule
