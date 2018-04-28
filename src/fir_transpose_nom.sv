module fir_transpose_nom #(
    parameter DATA_WIDTH      = 5,
    parameter TAP_COEFF_WIDTH = 5,
    parameter NUM_TAPS        = 50
)(
    input                               clk,
    input                               rst,
    input  signed [DATA_WIDTH-1:0]      in,
    output signed [DATA_WIDTH-1:0]      out,
    input  signed [TAP_COEFF_WIDTH-1:0] tap_coeffs [NUM_TAPS-1:0]
);

logic signed [DATA_WIDTH-1:0] in_flopped;
logic signed [DATA_WIDTH-1:0] part_flopped [NUM_TAPS-1:0]; // [0] should be connected to out
logic signed [DATA_WIDTH-1:0] mult_out     [NUM_TAPS-1:0];
logic signed [DATA_WIDTH-1:0] add_sat_out  [NUM_TAPS-2:0];

logic signed [TAP_COEFF_WIDTH-1:0] tap_coeffs_flopped [NUM_TAPS-1:0];

always @ (posedge clk or posedge rst) begin
    if (rst) begin
        in_flopped  <= '0;
        for (integer i=0; i<NUM_TAPS; i+=1) begin
            tap_coeffs_flopped[i] <= '0;
            part_flopped[i]       <= '0;
        end // for (integer i=0; i<NUM_TAPS; i+=1)
    end // if (rst)
    else begin
        in_flopped                     <= in;
        tap_coeffs_flopped[NUM_TAPS-1] <= tap_coeffs[NUM_TAPS-1];
        for (integer i=0; i<NUM_TAPS-1; i+=1) begin
            tap_coeffs_flopped[i] <= tap_coeffs[i];
            part_flopped[i]       <= add_sat_out[i];
        end // for (integer i=1; i<NUM_TAPS; i+=1)
    end // else
end // always @ (posedge clk or posedge rst)

assign out = part_flopped[0];

genvar i;
for (i=0; i<NUM_TAPS; i=i+1) begin: mult
    mult #(
        .DATA_WIDTH(DATA_WIDTH),
        .TAP_COEFF_WIDTH(TAP_COEFF_WIDTH)
    ) mult (
        .in(in_flopped),
        .out(mult_out[i]),
        .tap_coeff(tap_coeffs_flopped[i])
    );
end // mult

for (i=0; i<NUM_TAPS-1; i=i+1) begin: add_sat
    logic signed [DATA_WIDTH-1:0] adder_in [1:0];
    assign adder_in[1] = mult_out[i];
    assign adder_in[0] = part_flopped[i+1];
    add_sat #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_TAPS(2)
    ) add_sat (
        .in(adder_in),
        .out(add_sat_out[i])
    );
end // mult

endmodule
