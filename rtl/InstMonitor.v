
module InstMonitor(
	input clk,
	input inst_valid_i,
	input [63:0] inst_pc_i,
	input [31:0] inst_i,
	input wb_valid_i,
	input [4:0] wb_rd_i,
	input [63:0] wb_data_i
);

always @(posedge clk) begin
	if(inst_valid_i) begin
		$display("[%t][WB] pc: %08h, inst: %08h, rd: %02d, rd_data: %016h", $time, 
			inst_pc_i, inst_i, wb_valid_i ? wb_rd_i : 0, wb_valid_i && wb_rd_i!=0 ? wb_data_i : 0);
	end
end

endmodule