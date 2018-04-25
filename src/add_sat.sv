module add_sat #(
    parameter DATA_WIDTH = 6,
    parameter NUM_TAPS   = 2
)(
    input  signed [DATA_WIDTH-1:0] in [NUM_TAPS-1:0],
    output signed [DATA_WIDTH-1:0] out
);

localparam PAD_WIDTH = $clog2(NUM_TAPS);

logic signed [PAD_WIDTH+DATA_WIDTH-1:0] sum;
logic signed [DATA_WIDTH-1:0] sum_sat;

always @(*) begin
	sum = '0;
	for (integer i=0; i<NUM_TAPS; i+=1) begin
		sum += in[i];
	end // for (integer i=0; i<NUM_TAPS; i+=1)
end // always @(*)

always @(*) begin
	if      (sum >= $signed(  'b1 << (DATA_WIDTH-1)))  sum_sat = ~('b1 << (DATA_WIDTH-1));
	else if (sum <  $signed(-('b1 << (DATA_WIDTH-1)))) sum_sat =   'b1 << (DATA_WIDTH-1) ;
	else                                               sum_sat = sum[DATA_WIDTH-1:0];
end // always @(*)

assign out = sum_sat;

endmodule
