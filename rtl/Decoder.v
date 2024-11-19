
module Decoder (
	input clk,
	input rst_n,
	input stall_decoder_i,
	input flush_decoder_i,
	input f1_valid_i,
	input [63:0] f1_pc_i,
	input [31:0] f1_inst_i,
	output decoder_valid_o,
	output [63:0] pc_o,
	output [31:0] inst_o,
	output rs1_valid_o,
	output rs2_valid_o,
	output rs3_valid_o,
	output [4:0] rs1_o,
	output [4:0] rs2_o,
	output [4:0] rs3_o,
	output [1:0] rd_type_o,
	output [4:0] rd_o,
	output [5:0] exe_unit_o,
	output [3:0] func_code_o,
	output [2:0] func3_o,
	output [1:0] func2_o,
	output endsim_o,
	output auipc_o
);
	
reg decoder_valid_r;
reg [63:0] decoder_pc_r;
reg [31:0] decoder_inst_r;

wire rs1_valid;
wire rs2_valid;
wire rs3_valid;
wire [4:0] rs1;
wire [4:0] rs2;
wire [4:0] rs3;
wire [1:0] rd_type;
wire [4:0] rd;
wire [5:0] exe_unit;
wire [3:0] func_code;
wire [2:0] func3;
wire [1:0] func2;

assign decoder_valid_o = decoder_valid_r & !(stall_decoder_i | flush_decoder_i);
assign pc_o = decoder_pc_r;
assign inst_o = decoder_inst_r;

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		decoder_valid_r <= 1'b0;
		decoder_pc_r <= 64'h0;
		decoder_inst_r <= 32'h0;
	end
	else if(flush_decoder_i) begin
		decoder_valid_r <= 1'b0;
		decoder_pc_r <= 64'h0;
		decoder_inst_r <= 32'h0;
	end
	else if(!stall_decoder_i) begin
		decoder_valid_r <= f1_valid_i;
		decoder_pc_r <= f1_pc_i;
		decoder_inst_r <= f1_inst_i;
	end	
end

assign rs1_valid_o = rs1_valid;
assign rs2_valid_o = rs2_valid;
assign rs3_valid_o = rs3_valid;
assign rs1_o = rs1;
assign rs2_o = rs2;
assign rs3_o = rs3;
assign rd_type_o = rd_type;
assign rd_o = rd;
assign exe_unit_o = exe_unit;
assign func_code_o = func_code;
assign func3_o = func3;
assign func2_o = func2;

assign endsim_o = decoder_inst_r == 32'h0000_006b;

FuncDecodeEntry u_FuncDecodeEntry ( 
    .inst_i          (decoder_inst_r),
    .instFunc3_i     (decoder_inst_r[14:12]),   
    .mm_i            (1'b1), // mmode is always enabled
    .um_i            (1'b0),
    .menvcfgCbie_i   (1'b0),   
    .senvcfgCbie_i   (1'b0),   
    .instAuipc_o     (auipc_o),   
    .instLink_o      (),   
    .instBranch_o    (),   
    .instFlush_o     (),   
    .instExeUnit_o   (exe_unit),   
    .instFuncCode_o  (func_code),   
    .instFunc3_o     (func3),   
    .instFunc2_o     (func2),   
    .instRdAddr_o    (rd),   
    .instRs1Addr_o   (rs1),   
    .instRs2Addr_o   (rs2),   
    .instRs3Addr_o   (rs3),   
    .instRdType_o    (rd_type),   
    .instRs1Valid_o  (rs1_valid),   
    .instRs2Valid_o  (rs2_valid),   
    .instRs3Valid_o  (rs3_valid)
);

endmodule