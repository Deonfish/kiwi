
module InstMonitor(
	input clk,
	input inst_valid_i,
	input [63:0] inst_pc_i,
	input [31:0] inst_i,
	input [`SCOREBOARD_SIZE_WIDTH:0] inst_sid
);

always @(posedge clk) begin
	if(inst_valid_i) begin
		$display("[%t][WB] sid: %0d, pc: %08h, inst: %08h", $time, 
			inst_sid, inst_pc_i, inst_i);
	end
end

endmodule