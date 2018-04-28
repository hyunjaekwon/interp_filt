module add_sat_tree #(
    parameter DATA_WIDTH = 6,
    parameter NUM_TAPS   = 2,
    parameter USE_PIPE   = 0
)(
    input clk,
    input rst,
    input  signed [DATA_WIDTH-1:0] in [NUM_TAPS-1:0],
    output signed [DATA_WIDTH-1:0] out
);

if (NUM_TAPS == 1) assign out = in[0];
else if (NUM_TAPS == 2) begin
    add_sat #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_TAPS(2)
    ) add_sat (
        .in(in),
        .out(out)
    );
end // else if (NUM_TAPS == 2)
else begin
	localparam TAPS_DIV_2 = NUM_TAPS >> 1;
	logic signed [DATA_WIDTH-1:0] sub_sum [1:0];
    add_sat_tree #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_TAPS(TAPS_DIV_2),
        .USE_PIPE(USE_PIPE)
    ) add_sat_tree_0 (
        .clk,
        .rst,
        .in(in[TAPS_DIV_2-1:0]),
        .out(sub_sum[0])
    );
    add_sat_tree #(
        .DATA_WIDTH(DATA_WIDTH),
        .NUM_TAPS(NUM_TAPS - TAPS_DIV_2),
        .USE_PIPE(USE_PIPE)
    ) add_sat_tree_1 (
        .clk,
        .rst,
        .in(in[NUM_TAPS-1:TAPS_DIV_2]),
        .out(sub_sum[1])
    );
    if (USE_PIPE == 1) begin
        logic signed [DATA_WIDTH-1:0] sub_sum_flopped [1:0];
        always @ (posedge clk or posedge rst) begin
            if (rst) begin
                for (integer i=0; i<2; i+=1) sub_sum_flopped[i] <= '0;
            end // if (rst)
            else begin
                for (integer i=0; i<2; i+=1) sub_sum_flopped[i] <= sub_sum[i];
            end // else
        end // always @ (posedge clk or posedge rst)
        add_sat #(
            .DATA_WIDTH(DATA_WIDTH),
            .NUM_TAPS(2)
        ) add_sat (
            .in(sub_sum_flopped),
            .out(out)
        );
    end // if (USE_PIPE == 1)
    else begin
        add_sat #(
            .DATA_WIDTH(DATA_WIDTH),
            .NUM_TAPS(2)
        ) add_sat (
            .in(sub_sum),
            .out(out)
        );
    end // else
end // else

endmodule
