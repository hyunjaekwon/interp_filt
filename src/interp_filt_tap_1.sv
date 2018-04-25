module interp_filt_tap_1 #(
    parameter DATA_WIDTH      = 5,
    parameter TAP_COEFF_WIDTH = 5
)(
    input                               clk,
    input                               rst,
    input  signed [DATA_WIDTH-1:0]      in,
    output signed [DATA_WIDTH-1:0]      out,
    input  signed [TAP_COEFF_WIDTH-1:0] tap_coeff
);

logic signed [DATA_WIDTH-1:0] in_flopped, out_pre_flopped, out_flopped;
logic signed [TAP_COEFF_WIDTH-1:0] tap_coeff_flopped;
logic rst_flopped;

always @ (posedge clk) begin
    rst_flopped       <= rst;
    in_flopped        <= rst_flopped ? '0 : in;
    out_flopped       <= rst_flopped ? '0 : out_pre_flopped;
    tap_coeff_flopped <= rst_flopped ? '0 : tap_coeff;
end // always @ (posedge clk)
assign out = out_flopped;

mult #(
    .DATA_WIDTH(DATA_WIDTH),
    .TAP_COEFF_WIDTH(TAP_COEFF_WIDTH)
) mult (
    .in(in_flopped),
    .out(out_pre_flopped),
    .tap_coeff(tap_coeff_flopped)
);

endmodule
