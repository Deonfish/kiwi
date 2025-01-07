module Operands(
	input clk,
	input rst_n,
	// stall from scoreboard
	input stall_operands_inst0_i,
	input stall_operands_inst1_i,
	// flush from wb
	input flush_operands_i,
	// from decoder
	input [0:0]                      inst0_decoder_valid_i,
	input [63:0]                     inst0_decoder_pc_i,
	input [31:0]                     inst0_decoder_inst_i,
	input [0:0]                      inst0_decoder_rs1_valid_i,
	input [4:0]                      inst0_decoder_rs1_i,
	input [0:0]                      inst0_decoder_rs2_valid_i,
	input [4:0]                      inst0_decoder_rs2_i,
	input [0:0]                      inst0_decoder_rs3_valid_i,
	input [4:0]                      inst0_decoder_rs3_i,
	input [1:0]                      inst0_decoder_rd_type_i,
	input [4:0]                      inst0_decoder_rd_i,
	input [5:0]                      inst0_decoder_h_exe_unit_i,
	input [3:0]                      inst0_decoder_func_code_i,
	input [2:0]                      inst0_decoder_func3_i,
	input [1:0]                      inst0_decoder_func2_i,
	input [0:0]                      inst0_decoder_endsim_i,
	input [0:0]                      inst0_decoder_auipc_i,
    input [`SCOREBOARD_SIZE_WIDTH:0] inst0_decoder_sid_i,
	input [0:0]                      inst1_decoder_valid_i,
	input [63:0]                     inst1_decoder_pc_i,
	input [31:0]                     inst1_decoder_inst_i,
	input [0:0]                      inst1_decoder_rs1_valid_i,
	input [4:0]                      inst1_decoder_rs1_i,
	input [0:0]                      inst1_decoder_rs2_valid_i,
	input [4:0]                      inst1_decoder_rs2_i,
	input [0:0]                      inst1_decoder_rs3_valid_i,
	input [4:0]                      inst1_decoder_rs3_i,
	input [1:0]                      inst1_decoder_rd_type_i,
	input [4:0]                      inst1_decoder_rd_i,
	input [5:0]                      inst1_decoder_h_exe_unit_i,
	input [3:0]                      inst1_decoder_func_code_i,
	input [2:0]                      inst1_decoder_func3_i,
	input [1:0]                      inst1_decoder_func2_i,
	input [0:0]                      inst1_decoder_endsim_i,
	input [0:0]                      inst1_decoder_auipc_i,
    input [`SCOREBOARD_SIZE_WIDTH:0] inst1_decoder_sid_i,
	// to execute
	output [0:0]                        inst0_operands_valid_o,
	output [63:0]                       inst0_operands_pc_o,
	output [31:0]                       inst0_operands_inst_o,
	output [0:0]                        inst0_operands_rs1_valid_o,
	output [4:0]                        inst0_operands_rs1_o,
	output [63:0]                       inst0_operands_rs1_value_o,
	output [0:0]                        inst0_operands_rs2_valid_o,
	output [4:0]                        inst0_operands_rs2_o,
	output [63:0]                       inst0_operands_rs2_value_o,
	output [0:0]                        inst0_operands_rs3_valid_o,
	output [4:0]                        inst0_operands_rs3_o,
	output [63:0]                       inst0_operands_rs3_value_o,
	output [1:0]                        inst0_operands_rd_type_o,
	output [4:0]                        inst0_operands_rd_o,
	output [5:0]                        inst0_operands_h_exe_unit_o,
	output [3:0]                        inst0_operands_func_code_o,
	output [2:0]                        inst0_operands_func3_o,
	output [1:0]                        inst0_operands_func2_o,
	output [0:0]                        inst0_operands_endsim_o,
	output [0:0]                        inst0_operands_auipc_o,
    output [`SCOREBOARD_SIZE_WIDTH:0]   inst0_operands_sid_o,
	output [0:0]                        inst1_operands_valid_o,
	output [63:0]                       inst1_operands_pc_o,
	output [31:0]                       inst1_operands_inst_o,
	output [0:0]                        inst1_operands_rs1_valid_o,
	output [4:0]                        inst1_operands_rs1_o,
	output [63:0]                       inst1_operands_rs1_value_o,
	output [0:0]                        inst1_operands_rs2_valid_o,
	output [4:0]                        inst1_operands_rs2_o,
	output [63:0]                       inst1_operands_rs2_value_o,
	output [0:0]                        inst1_operands_rs3_valid_o,
	output [4:0]                        inst1_operands_rs3_o,
	output [63:0]                       inst1_operands_rs3_value_o,
	output [1:0]                        inst1_operands_rd_type_o,
	output [4:0]                        inst1_operands_rd_o,
	output [5:0]                        inst1_operands_h_exe_unit_o,
	output [3:0]                        inst1_operands_func_code_o,
	output [2:0]                        inst1_operands_func3_o,
	output [1:0]                        inst1_operands_func2_o,
	output [0:0]                        inst1_operands_endsim_o,
	output [0:0]                        inst1_operands_auipc_o,
    output [`SCOREBOARD_SIZE_WIDTH:0]   inst1_operands_sid_o,
    // write reg from wb
    input [0:0]  inst0_wb_valid_i,
    input [4:0]  inst0_wb_rd_i,
    input [63:0] inst0_wb_value_i,
    input [0:0]  inst1_wb_valid_i,
    input [4:0]  inst1_wb_rd_i,
    input [63:0] inst1_wb_value_i
);

reg [0:0]  inst0_operands_valid_r;
reg [63:0] inst0_operands_pc_r;
reg [31:0] inst0_operands_inst_r;
reg [0:0]  inst1_operands_valid_r;
reg [63:0] inst1_operands_pc_r;
reg [31:0] inst1_operands_inst_r;
reg [0:0]  inst0_operands_rs1_valid_r;
reg [4:0]  inst0_operands_rs1_r;
reg [63:0] inst0_operands_rs1_value_r;
reg [0:0]  inst0_operands_rs2_valid_r;
reg [4:0]  inst0_operands_rs2_r;
reg [63:0] inst0_operands_rs2_value_r;
reg [0:0]  inst0_operands_rs3_valid_r;
reg [4:0]  inst0_operands_rs3_r;
reg [63:0] inst0_operands_rs3_value_r;
reg [1:0]  inst0_operands_rd_type_r;
reg [4:0]  inst0_operands_rd_r;
reg [5:0]  inst0_operands_h_exe_unit_r;
reg [3:0]  inst0_operands_func_code_r;
reg [2:0]  inst0_operands_func3_r;
reg [1:0]  inst0_operands_func2_r;
reg [0:0]  inst0_operands_endsim_r;
reg [0:0]  inst0_operands_auipc_r;
reg [`SCOREBOARD_SIZE_WIDTH:0] inst0_operands_sid_r;
reg [0:0]  inst1_operands_valid_r;
reg [63:0] inst1_operands_pc_r;
reg [31:0] inst1_operands_inst_r;
reg [0:0]  inst1_operands_valid_r;
reg [63:0] inst1_operands_pc_r;
reg [31:0] inst1_operands_inst_r;
reg [0:0]  inst1_operands_rs1_valid_r;
reg [4:0]  inst1_operands_rs1_r;
reg [63:0] inst1_operands_rs1_value_r;
reg [0:0]  inst1_operands_rs2_valid_r;
reg [4:0]  inst1_operands_rs2_r;
reg [63:0] inst1_operands_rs2_value_r;
reg [0:0]  inst1_operands_rs3_valid_r;
reg [4:0]  inst1_operands_rs3_r;
reg [63:0] inst1_operands_rs3_value_r;
reg [1:0]  inst1_operands_rd_type_r;
reg [4:0]  inst1_operands_rd_r;
reg [5:0]  inst1_operands_h_exe_unit_r;
reg [3:0]  inst1_operands_func_code_r;
reg [2:0]  inst1_operands_func3_r;
reg [1:0]  inst1_operands_func2_r;
reg [0:0]  inst1_operands_endsim_r;
reg [0:0]  inst1_operands_auipc_r;
reg [`SCOREBOARD_SIZE_WIDTH:0] inst1_operands_sid_r;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        inst0_operands_valid_r <= 0;
    end
    else if(flush_operands_i) begin
        inst0_operands_valid_r <= 0;
    end
    else if(!stall_operands_inst0_i) begin
        inst0_operands_valid_r <= inst0_decoder_valid_i;
        inst0_operands_pc_r <= inst0_decoder_pc_i;
        inst0_operands_inst_r <= inst0_decoder_inst_i;
        inst0_operands_rs1_valid_r <= inst0_decoder_rs1_valid_i;
        inst0_operands_rs1_r <= inst0_decoder_rs1_i;
        inst0_operands_rs2_valid_r <= inst0_decoder_rs2_valid_i;
        inst0_operands_rs2_r <= inst0_decoder_rs2_i;
        inst0_operands_rs3_valid_r <= inst0_decoder_rs3_valid_i;
        inst0_operands_rs3_r <= inst0_decoder_rs3_i;
        inst0_operands_rd_type_r <= inst0_decoder_rd_type_i;
        inst0_operands_rd_r <= inst0_decoder_rd_i;
        inst0_operands_h_exe_unit_r <= inst0_decoder_h_exe_unit_i;
        inst0_operands_func_code_r <= inst0_decoder_func_code_i;
        inst0_operands_func3_r <= inst0_decoder_func3_i;
        inst0_operands_func2_r <= inst0_decoder_func2_i;
        inst0_operands_endsim_r <= inst0_decoder_endsim_i;
        inst0_operands_auipc_r <= inst0_decoder_auipc_i;
        inst0_operands_sid_r <= inst0_decoder_sid_i;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        inst1_operands_valid_r <= 0;
    end
    else if(flush_operands_i) begin
        inst1_operands_valid_r <= 0;
    end
    else if(!stall_operands_inst1_i) begin
        inst1_operands_valid_r <= inst1_decoder_valid_i;
        inst1_operands_pc_r <= inst1_decoder_pc_i;
        inst1_operands_inst_r <= inst1_decoder_inst_i;
        inst1_operands_rs1_valid_r <= inst1_decoder_rs1_valid_i;
        inst1_operands_rs1_r <= inst1_decoder_rs1_i;
        inst1_operands_rs2_valid_r <= inst1_decoder_rs2_valid_i;
        inst1_operands_rs2_r <= inst1_decoder_rs2_i;
        inst1_operands_rs3_valid_r <= inst1_decoder_rs3_valid_i;
        inst1_operands_rs3_r <= inst1_decoder_rs3_i;
        inst1_operands_rd_type_r <= inst1_decoder_rd_type_i;
        inst1_operands_rd_r <= inst1_decoder_rd_i;
        inst1_operands_h_exe_unit_r <= inst1_decoder_h_exe_unit_i;
        inst1_operands_func_code_r <= inst1_decoder_func_code_i;
        inst1_operands_func3_r <= inst1_decoder_func3_i;
        inst1_operands_func2_r <= inst1_decoder_func2_i;
        inst1_operands_endsim_r <= inst1_decoder_endsim_i;
        inst1_operands_auipc_r <= inst1_decoder_auipc_i;
        inst1_operands_sid_r <= inst1_decoder_sid_i;
    end
end

assign inst0_operands_valid_o = inst0_operands_valid_r;
assign inst0_operands_pc_o = inst0_operands_pc_r;
assign inst0_operands_inst_o = inst0_operands_inst_r;
assign inst0_operands_rs1_valid_o = inst0_operands_rs1_valid_r;
assign inst0_operands_rs1_o = inst0_operands_rs1_r;
assign inst0_operands_rs2_valid_o = inst0_operands_rs2_valid_r;
assign inst0_operands_rs2_o = inst0_operands_rs2_r;
assign inst0_operands_rs3_valid_o = inst0_operands_rs3_valid_r;
assign inst0_operands_rs3_o = inst0_operands_rs3_r;
assign inst0_operands_rd_type_o = inst0_operands_rd_type_r;
assign inst0_operands_rd_o = inst0_operands_rd_r;
assign inst0_operands_h_exe_unit_o = inst0_operands_h_exe_unit_r;
assign inst0_operands_func_code_o = inst0_operands_func_code_r;
assign inst0_operands_func3_o = inst0_operands_func3_r;
assign inst0_operands_func2_o = inst0_operands_func2_r;
assign inst0_operands_endsim_o = inst0_operands_endsim_r;
assign inst0_operands_auipc_o = inst0_operands_auipc_r;
assign inst0_operands_sid_o = inst0_operands_sid_r;

assign inst1_operands_valid_o = inst1_operands_valid_r;
assign inst1_operands_pc_o = inst1_operands_pc_r;
assign inst1_operands_inst_o = inst1_operands_inst_r;
assign inst1_operands_rs1_valid_o = inst1_operands_rs1_valid_r;
assign inst1_operands_rs1_o = inst1_operands_rs1_r;
assign inst1_operands_rs2_valid_o = inst1_operands_rs2_valid_r;
assign inst1_operands_rs2_o = inst1_operands_rs2_r;
assign inst1_operands_rs3_valid_o = inst1_operands_rs3_valid_r;
assign inst1_operands_rs3_o = inst1_operands_rs3_r;
assign inst1_operands_rd_type_o = inst1_operands_rd_type_r;
assign inst1_operands_rd_o = inst1_operands_rd_r;
assign inst1_operands_h_exe_unit_o = inst1_operands_h_exe_unit_r;
assign inst1_operands_func_code_o = inst1_operands_func_code_r;
assign inst1_operands_func3_o = inst1_operands_func3_r;
assign inst1_operands_func2_o = inst1_operands_func2_r;
assign inst1_operands_endsim_o = inst1_operands_endsim_r;
assign inst1_operands_auipc_o = inst1_operands_auipc_r;
assign inst1_operands_sid_o = inst1_operands_sid_r;

Regfile u_regfile(
    .clk(clk),
    .rst_n(rst_n),
    .inst0_rs1_addr_i(inst0_decoder_rs1_i),
    .inst0_rs2_addr_i(inst0_decoder_rs2_i),
    .inst0_rd_addr_i(inst0_decoder_rd_i),
    .inst1_rs1_addr_i(inst1_decoder_rs1_i),
    .inst1_rs2_addr_i(inst1_decoder_rs2_i),
    .inst1_rd_addr_i(inst1_decoder_rd_i),
    .inst0_rd_wvalid_i(inst0_wb_valid_i),
    .inst0_rd_waddr_i(inst0_wb_rd_i),
    .inst0_rd_wdata_i(inst0_wb_value_i),
    .inst1_rd_wvalid_i(inst1_wb_valid_i),
    .inst1_rd_waddr_i(inst1_wb_rd_i),
    .inst1_rd_wdata_i(inst1_wb_value_i)
)

endmodule