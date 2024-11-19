
module Fetch0 (
	input clk,
	input rst_n,
	input [63:0] reset_vec,
	input stall_f0_i,
	input redir_i,
	input [63:0] redir_pc_i,
	output f0_valid_o,
	output [63:0] f0_pc_o
);

reg  [63:0] pc;
reg  [63:0] pc_r;

assign f0_pc_o = pc;

always @(*) begin
	if(redir_i)
		pc = redir_pc_i;
	else
		pc = pc_r;	
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n)
		pc_r <= reset_vec;
	else if(redir_i)
		pc_r <= redir_pc_i;
	else if(!stall_f0_i)
		pc_r <= pc + 4;
end

assign f0_valid_o = ~stall_f0_i;

endmodule