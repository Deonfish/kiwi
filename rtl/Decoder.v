
module Decoder (
	input clk,
	input rst_n,
	// stall from scoreboard
	input stall_decoder_inst0_i,
	input stall_decoder_inst1_i,
	// flush from wb
	input flush_decoder_i,
	// from instQueue
	input [0:0]   inst0_f1_valid_i,
	input [63:0]  inst0_f1_pc_i,
	input [31:0]  inst0_f1_inst_i,
	input [0:0]   inst1_f1_valid_i,
	input [63:0]  inst1_f1_pc_i,
	input [31:0]  inst1_f1_inst_i,
	// to operands
	output [0:0]  inst0_decoder_valid_pre_o,
	output [0:0]  inst0_decoder_valid_o,
	output [63:0] inst0_decoder_pc_o,
	output [31:0] inst0_decoder_inst_o,
	output [0:0]  inst0_decoder_rs1_valid_o,
	output [4:0]  inst0_decoder_rs1_o,
	output [0:0]  inst0_decoder_rs2_valid_o,
	output [4:0]  inst0_decoder_rs2_o,
	output [0:0]  inst0_decoder_rs3_valid_o,
	output [4:0]  inst0_decoder_rs3_o,
	output [1:0]  inst0_decoder_rd_type_o,
	output [4:0]  inst0_decoder_rd_o,
	output [5:0]  inst0_decoder_exe_unit_o,
	output [3:0]  inst0_decoder_func_code_o,
	output [2:0]  inst0_decoder_func3_o,
	output [1:0]  inst0_decoder_func2_o,
	output [0:0]  inst0_decoder_endsim_o,
	output [0:0]  inst0_decoder_auipc_o,
	output [0:0]  inst1_decoder_valid_pre_o,
	output [0:0]  inst1_decoder_valid_o,
	output [63:0] inst1_decoder_pc_o,
	output [31:0] inst1_decoder_inst_o,
	output [0:0]  inst1_decoder_rs1_valid_o,
	output [4:0]  inst1_decoder_rs1_o,
	output [0:0]  inst1_decoder_rs2_valid_o,
	output [4:0]  inst1_decoder_rs2_o,
	output [0:0]  inst1_decoder_rs3_valid_o,
	output [4:0]  inst1_decoder_rs3_o,
	output [1:0]  inst1_decoder_rd_type_o,
	output [4:0]  inst1_decoder_rd_o,
	output [5:0]  inst1_decoder_exe_unit_o,
	output [3:0]  inst1_decoder_func_code_o,
	output [2:0]  inst1_decoder_func3_o,
	output [1:0]  inst1_decoder_func2_o,
	output [0:0]  inst1_decoder_endsim_o,
	output [0:0]  inst1_decoder_auipc_o
);

reg [0:0]  inst0_decoder_valid_r;
reg [63:0] inst0_decoder_pc_r;
reg [31:0] inst0_decoder_inst_r;
reg [0:0]  inst1_decoder_valid_r;
reg [63:0] inst1_decoder_pc_r;
reg [31:0] inst1_decoder_inst_r;

wire [0:0] inst0_rs1_valid;
wire [0:0] inst0_rs2_valid;
wire [0:0] inst0_rs3_valid;
wire [4:0] inst0_rs1;
wire [4:0] inst0_rs2;
wire [4:0] inst0_rs3;
wire [1:0] inst0_rd_type;
wire [4:0] inst0_rd;
wire [5:0] inst0_exe_unit;
wire [3:0] inst0_func_code;
wire [2:0] inst0_func3;
wire [1:0] inst0_func2;

wire [0:0] inst0_decoder_rs1_valid;
wire [0:0] inst0_decoder_rs2_valid;
wire [0:0] inst0_decoder_rs3_valid;
wire [4:0] inst0_decoder_rs1;
wire [4:0] inst0_decoder_rs2;
wire [4:0] inst0_decoder_rs3;
wire [1:0] inst0_decoder_rd_type;
wire [4:0] inst0_decoder_rd;
wire [5:0] inst0_decoder_exe_unit;
wire [3:0] inst0_decoder_func_code;
wire [2:0] inst0_decoder_func3;
wire [1:0] inst0_decoder_func2;
wire [0:0] inst0_decoder_endsim;
wire [0:0] inst0_decoder_auipc;

wire [0:0] inst1_decoder_rs1_valid;
wire [0:0] inst1_decoder_rs2_valid;
wire [0:0] inst1_decoder_rs3_valid;
wire [4:0] inst1_decoder_rs1;
wire [4:0] inst1_decoder_rs2;
wire [4:0] inst1_decoder_rs3;
wire [1:0] inst1_decoder_rd_type;
wire [4:0] inst1_decoder_rd;
wire [5:0] inst1_decoder_exe_unit;
wire [3:0] inst1_decoder_func_code;
wire [2:0] inst1_decoder_func3;
wire [1:0] inst1_decoder_func2;
wire [0:0] inst1_decoder_endsim;
wire [0:0] inst1_decoder_auipc;

assign inst0_decoder_valid_pre_o = inst0_decoder_valid_r;
assign inst0_decoder_valid_o = inst0_decoder_valid_pre_o & !(stall_decoder_inst0_i | flush_decoder_i);
assign inst0_decoder_pc_o = inst0_decoder_pc_r;
assign inst0_decoder_inst_o = inst0_decoder_inst_r;
assign inst1_decoder_valid_pre_o = inst1_decoder_valid_r;
assign inst1_decoder_valid_o = inst1_decoder_valid_pre_o & !(stall_decoder_inst1_i | flush_decoder_i);
assign inst1_decoder_pc_o = inst1_decoder_pc_r;
assign inst1_decoder_inst_o = inst1_decoder_inst_r;

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		inst0_decoder_valid_r 	<= 1'b0;
		inst0_decoder_pc_r 		<= 64'h0;
		inst0_decoder_inst_r 	<= 32'h0;
	end
	else if(flush_decoder_i) begin
		inst0_decoder_valid_r 	<= 1'b0;
		inst0_decoder_pc_r 		<= 64'h0;
		inst0_decoder_inst_r 	<= 32'h0;
	end
	else if(!stall_decoder_inst0_i && !stall_decoder_inst1_i && inst0_f1_valid_i) begin
		inst0_decoder_valid_r 	<= 1'b1;
		inst0_decoder_pc_r 		<= inst0_f1_pc_i;
		inst0_decoder_inst_r 	<= inst0_f1_inst_i;
	end
	else if(inst0_decoder_valid_o) begin
		inst0_decoder_valid_r <= 1'b0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		inst1_decoder_valid_r 	<= 1'b0;
		inst1_decoder_pc_r 		<= 64'h0;
		inst1_decoder_inst_r 	<= 32'h0;
	end
	else if(flush_decoder_i) begin
		inst1_decoder_valid_r 	<= 1'b0;
		inst1_decoder_pc_r 		<= 64'h0;
		inst1_decoder_inst_r 	<= 32'h0;
	end
	else if(!stall_decoder_inst0_i && !stall_decoder_inst1_i && inst1_f1_valid_i) begin
		inst1_decoder_valid_r 	<= 1'b1;
		inst1_decoder_pc_r 		<= inst1_f1_pc_i;
		inst1_decoder_inst_r 	<= inst1_f1_inst_i;
	end
	else if(inst1_decoder_valid_o) begin
		inst1_decoder_valid_r 	<= 1'b0;
	end
end

assign inst0_decoder_rs1_valid_o = inst0_decoder_rs1_valid;
assign inst0_decoder_rs2_valid_o = inst0_decoder_rs2_valid;
assign inst0_decoder_rs3_valid_o = inst0_decoder_rs3_valid;
assign inst0_decoder_rs1_o 		 = inst0_decoder_rs1;
assign inst0_decoder_rs2_o 		 = inst0_decoder_rs2;
assign inst0_decoder_rs3_o 		 = inst0_decoder_rs3;
assign inst0_decoder_rd_type_o 	 = inst0_decoder_rd_type;
assign inst0_decoder_rd_o 		 = inst0_decoder_rd;
assign inst0_decoder_exe_unit_o  = inst0_decoder_exe_unit;
assign inst0_decoder_func_code_o = inst0_decoder_func_code;
assign inst0_decoder_func3_o 	 = inst0_decoder_func3;
assign inst0_decoder_func2_o 	 = inst0_decoder_func2;

assign inst1_decoder_rs1_valid_o = inst1_decoder_rs1_valid;
assign inst1_decoder_rs2_valid_o = inst1_decoder_rs2_valid;
assign inst1_decoder_rs3_valid_o = inst1_decoder_rs3_valid;
assign inst1_decoder_rs1_o 		 = inst1_decoder_rs1;
assign inst1_decoder_rs2_o 		 = inst1_decoder_rs2;
assign inst1_decoder_rs3_o 		 = inst1_decoder_rs3;
assign inst1_decoder_rd_type_o 	 = inst1_decoder_rd_type;
assign inst1_decoder_rd_o 		 = inst1_decoder_rd;
assign inst1_decoder_exe_unit_o  = inst1_decoder_exe_unit;
assign inst1_decoder_func_code_o = inst1_decoder_func_code;
assign inst1_decoder_func3_o 	 = inst1_decoder_func3;
assign inst1_decoder_func2_o 	 = inst1_decoder_func2;

assign inst0_endsim_o = inst0_decoder_inst_r == 32'h0000_006b;
assign inst1_endsim_o = inst1_decoder_inst_r == 32'h0000_006b;

FuncDecodeEntry u_FuncDecodeEntry_0 ( 
    .inst_i          (inst0_decoder_inst_r),
    .instFunc3_i     (inst0_decoder_inst_r[14:12]),   
    .mm_i            (1'b1), // mmode is always enabled
    .um_i            (1'b0),
    .menvcfgCbie_i   (1'b0),   
    .senvcfgCbie_i   (1'b0),   
    .instAuipc_o     (inst0_auipc_o),   
    .instLink_o      (),   
    .instBranch_o    (),   
    .instFlush_o     (),   
    .instExeUnit_o   (inst0_decoder_exe_unit),   
    .instFuncCode_o  (inst0_decoder_func_code),   
    .instFunc3_o     (inst0_decoder_func3),   
    .instFunc2_o     (inst0_decoder_func2),   
    .instRdAddr_o    (inst0_decoder_rd),   
    .instRs1Addr_o   (inst0_decoder_rs1),   
    .instRs2Addr_o   (inst0_decoder_rs2),   
    .instRs3Addr_o   (inst0_decoder_rs3),   
    .instRdType_o    (inst0_decoder_rd_type),   
    .instRs1Valid_o  (inst0_decoder_rs1_valid),   
    .instRs2Valid_o  (inst0_decoder_rs2_valid),   
    .instRs3Valid_o  (inst0_decoder_rs3_valid)
);

FuncDecodeEntry u_FuncDecodeEntry_1 ( 
    .inst_i          (inst1_decoder_inst_r),
    .instFunc3_i     (inst1_decoder_inst_r[14:12]),   
    .mm_i            (1'b1), // mmode is always enabled
    .um_i            (1'b0),
    .menvcfgCbie_i   (1'b0),   
    .senvcfgCbie_i   (1'b0),  
    .instAuipc_o     (inst1_auipc_o),   
    .instLink_o      (),   
    .instBranch_o    (),   
    .instFlush_o     (),   
    .instExeUnit_o   (inst1_decoder_exe_unit),   
    .instFuncCode_o  (inst1_decoder_func_code),   
    .instFunc3_o     (inst1_decoder_func3),   
    .instFunc2_o     (inst1_decoder_func2),   
    .instRdAddr_o    (inst1_decoder_rd),   
    .instRs1Addr_o   (inst1_decoder_rs1),   
    .instRs2Addr_o   (inst1_decoder_rs2),   
    .instRs3Addr_o   (inst1_decoder_rs3),   
    .instRdType_o    (inst1_decoder_rd_type),   
    .instRs1Valid_o  (inst1_decoder_rs1_valid),   
    .instRs2Valid_o  (inst1_decoder_rs2_valid),   
    .instRs3Valid_o  (inst1_decoder_rs3_valid)
);

endmodule