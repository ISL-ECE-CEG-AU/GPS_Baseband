`timescale 1ns / 1ps
module signmag_twocomp_vv(data_in,data_out);

input [4:0] data_in;
output[4:0] data_out;

wire [4:0] data_in;
reg [4:0] data_out;



always @(data_in)
	begin
	if (data_in[4] == 1'b1) begin
		data_out <= ~(data_in ^ 5'b10000) + 5'b00001;
	end else begin
		data_out <= data_in;
	end
	end

endmodule



