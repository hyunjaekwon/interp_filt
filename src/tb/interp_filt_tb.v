`timescale 1 ns /  1 ps

module interp_filt_tb();

reg [3:0] A;
wire [15:0] Z;
reg clk;

// Fake clock does nothing
interp_filt DUT0 (.A(A), .Z(Z), .clk(clk));

initial begin

$vcdpluson;
  A <= 4'd0;
 #`CLOCK_PERIOD A<= 4'd1;
  $display($time,": A=%b, Z=%b", A, Z);
 #`CLOCK_PERIOD A<= 4'd2;
  $display($time,": A=%b, Z=%b", A, Z);
 #`CLOCK_PERIOD A<= 4'd3;
  $display($time,": A=%b, Z=%b", A, Z);
 #`CLOCK_PERIOD A<= 4'd4;
  $display($time,": A=%b, Z=%b", A, Z);
 #`CLOCK_PERIOD A<= 4'd5;
  $display($time,": A=%b, Z=%b", A, Z);
 #`CLOCK_PERIOD A<= 4'd6;
  $display($time,": A=%b, Z=%b", A, Z);
 #`CLOCK_PERIOD A<= 4'd7;
  $display($time,": A=%b, Z=%b", A, Z);
 #`CLOCK_PERIOD A<= 4'd8;
  $display($time,": A=%b, Z=%b", A, Z);
 #`CLOCK_PERIOD A<= 4'd9;
  $display($time,": A=%b, Z=%b", A, Z);
 #`CLOCK_PERIOD A<= 4'd10;
  $display($time,": A=%b, Z=%b", A, Z);
 #`CLOCK_PERIOD A<= 4'd11;
  $display($time,": A=%b, Z=%b", A, Z);
 #`CLOCK_PERIOD A<= 4'd12;
  $display($time,": A=%b, Z=%b", A, Z);
 #`CLOCK_PERIOD A<= 4'd13;
  $display($time,": A=%b, Z=%b", A, Z);
 #`CLOCK_PERIOD A<= 4'd14;
  $display($time,": A=%b, Z=%b", A, Z);
 #`CLOCK_PERIOD A<= 4'd15;
  $display($time,": A=%b, Z=%b", A, Z);
 #`CLOCK_PERIOD;
  $display($time,": A=%b, Z=%b", A, Z);
$vcdplusoff;

end


endmodule

