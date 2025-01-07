module Exe_sequencer(
    // from operands
	input [0:0]                        inst0_operands_valid_i,
	input [63:0]                       inst0_operands_pc_i,
	input [31:0]                       inst0_operands_inst_i,
	input [0:0]                        inst0_operands_rs1_valid_i,
	input [4:0]                        inst0_operands_rs1_i,
	input [63:0]                       inst0_operands_rs1_value_i,
	input [0:0]                        inst0_operands_rs2_valid_i,
	input [4:0]                        inst0_operands_rs2_i,
	input [63:0]                       inst0_operands_rs2_value_i,
	input [0:0]                        inst0_operands_rs3_valid_i,
	input [4:0]                        inst0_operands_rs3_i,
	input [63:0]                       inst0_operands_rs3_value_i,
	input [1:0]                        inst0_operands_rd_type_i,
	input [4:0]                        inst0_operands_rd_i,
	input [`H_EXE_UNIT_WIDTH-1:0]      inst0_operands_h_exe_unit_i,
	input [3:0]                        inst0_operands_func_code_i,
	input [2:0]                        inst0_operands_func3_i,
	input [1:0]                        inst0_operands_func2_i,
	input [0:0]                        inst0_operands_endsim_i,
	input [0:0]                        inst0_operands_auipc_i,
    input [`SCOREBOARD_SIZE_WIDTH:0]   inst0_operands_sid_i,
	input [0:0]                        inst1_operands_valid_i,
	input [63:0]                       inst1_operands_pc_i,
	input [31:0]                       inst1_operands_inst_i,
	input [0:0]                        inst1_operands_rs1_valid_i,
	input [4:0]                        inst1_operands_rs1_i,
	input [63:0]                       inst1_operands_rs1_value_i,
	input [0:0]                        inst1_operands_rs2_valid_i,
	input [4:0]                        inst1_operands_rs2_i,
	input [63:0]                       inst1_operands_rs2_value_i,
	input [0:0]                        inst1_operands_rs3_valid_i,
	input [4:0]                        inst1_operands_rs3_i,
	input [63:0]                       inst1_operands_rs3_value_i,
	input [1:0]                        inst1_operands_rd_type_i,
	input [4:0]                        inst1_operands_rd_i,
	input [`H_EXE_UNIT_WIDTH-1:0]      inst1_operands_h_exe_unit_i,
	input [3:0]                        inst1_operands_func_code_i,
	input [2:0]                        inst1_operands_func3_i,
	input [1:0]                        inst1_operands_func2_i,
	input [0:0]                        inst1_operands_endsim_i,
	input [0:0]                        inst1_operands_auipc_i,
    input [`SCOREBOARD_SIZE_WIDTH:0]   inst1_operands_sid_i,

    // to execute
    output [0:0]                      exe_alu0_valid_o,
    output [0:0]                      exe_alu0_rs1_valid_o,
    output [63:0]                     exe_alu0_rs1_value_o,
    output [4:0]                      exe_alu0_rs1_o,
    output [0:0]                      exe_alu0_rs2_valid_o,
    output [63:0]                     exe_alu0_rs2_value_o,
    output [4:0]                      exe_alu0_rs2_o,
    output [0:0]                      exe_alu0_rs3_valid_o,
    output [63:0]                     exe_alu0_rs3_value_o,
    output [4:0]                      exe_alu0_rs3_o,
    output [0:0]                      exe_alu0_rd_valid_o,
    output [4:0]                      exe_alu0_rd_o,
    output [1:0]                      exe_alu0_rd_type_o,
    output [3:0]                      exe_alu0_rd_func_code_o,
    output [2:0]                      exe_alu0_rd_func3_o,
    output [1:0]                      exe_alu0_rd_func2_o,
    output [0:0]                      exe_alu0_rd_endsim_o,
    output [0:0]                      exe_alu0_rd_auipc_o,
    output [`SCOREBOARD_SIZE_WIDTH:0] exe_alu0_rd_sid_o,

    output [0:0]                      exe_alu1_valid_o,
    output [0:0]                      exe_alu1_rs1_valid_o,
    output [63:0]                     exe_alu1_rs1_value_o,
    output [4:0]                      exe_alu1_rs1_o,
    output [0:0]                      exe_alu1_rs2_valid_o,
    output [63:0]                     exe_alu1_rs2_value_o,
    output [4:0]                      exe_alu1_rs2_o,
    output [0:0]                      exe_alu1_rs3_valid_o,
    output [63:0]                     exe_alu1_rs3_value_o,
    output [4:0]                      exe_alu1_rs3_o,
    output [0:0]                      exe_alu1_rd_valid_o,
    output [4:0]                      exe_alu1_rd_o,
    output [1:0]                      exe_alu1_rd_type_o,
    output [3:0]                      exe_alu1_rd_func_code_o,
    output [2:0]                      exe_alu1_rd_func3_o,
    output [1:0]                      exe_alu1_rd_func2_o,
    output [0:0]                      exe_alu1_rd_endsim_o,
    output [0:0]                      exe_alu1_rd_auipc_o,
    output [`SCOREBOARD_SIZE_WIDTH:0] exe_alu1_rd_sid_o,

    output [0:0]                      exe_beu_valid_o,
    output [0:0]                      exe_beu_rs1_valid_o,
    output [63:0]                     exe_beu_rs1_value_o,
    output [4:0]                      exe_beu_rs1_o,
    output [0:0]                      exe_beu_rs2_valid_o,
    output [63:0]                     exe_beu_rs2_value_o,
    output [4:0]                      exe_beu_rs2_o,
    output [0:0]                      exe_beu_rs3_valid_o,
    output [63:0]                     exe_beu_rs3_value_o,
    output [4:0]                      exe_beu_rs3_o,
    output [0:0]                      exe_beu_rd_valid_o,
    output [4:0]                      exe_beu_rd_o,
    output [1:0]                      exe_beu_rd_type_o,
    output [3:0]                      exe_beu_rd_func_code_o,
    output [2:0]                      exe_beu_rd_func3_o,
    output [1:0]                      exe_beu_rd_func2_o,
    output [0:0]                      exe_beu_rd_endsim_o,
    output [0:0]                      exe_beu_rd_auipc_o,
    output [`SCOREBOARD_SIZE_WIDTH:0] exe_beu_rd_sid_o,
    
    output [0:0]                      exe_lsu_valid_o,
    output [0:0]                      exe_lsu_rs1_valid_o,
    output [63:0]                     exe_lsu_rs1_value_o,
    output [4:0]                      exe_lsu_rs1_o,
    output [0:0]                      exe_lsu_rs2_valid_o,
    output [63:0]                     exe_lsu_rs2_value_o,
    output [4:0]                      exe_lsu_rs2_o,
    output [0:0]                      exe_lsu_rs3_valid_o,
    output [63:0]                     exe_lsu_rs3_value_o,
    output [4:0]                      exe_lsu_rs3_o,
    output [0:0]                      exe_lsu_rd_valid_o,
    output [4:0]                      exe_lsu_rd_o,
    output [1:0]                      exe_lsu_rd_type_o,
    output [3:0]                      exe_lsu_rd_func_code_o,
    output [2:0]                      exe_lsu_rd_func3_o,
    output [1:0]                      exe_lsu_rd_func2_o,
    output [0:0]                      exe_lsu_rd_endsim_o,
    output [0:0]                      exe_lsu_rd_auipc_o,
    output [`SCOREBOARD_SIZE_WIDTH:0] exe_lsu_rd_sid_o

);

wire inst0_sel_alu0;
wire inst0_sel_alu1;
wire inst0_sel_beu;
wire inst0_sel_lsu;
wire inst1_sel_alu0;
wire inst1_sel_alu1;
wire inst1_sel_beu;
wire inst1_sel_lsu;

assign inst0_sel_alu0 = inst0_operands_valid_i & inst0_operands_h_exe_unit_i[`H_ALU0];
assign inst0_sel_alu1 = inst0_operands_valid_i & inst0_operands_h_exe_unit_i[`H_ALU1];
assign inst0_sel_beu  = inst0_operands_valid_i & inst0_operands_h_exe_unit_i[`H_BEU];
assign inst0_sel_lsu  = inst0_operands_valid_i & inst0_operands_h_exe_unit_i[`H_LSU];
assign inst1_sel_alu0 = inst1_operands_valid_i & inst1_operands_h_exe_unit_i[`H_ALU0];
assign inst1_sel_alu1 = inst1_operands_valid_i & inst1_operands_h_exe_unit_i[`H_ALU1];
assign inst1_sel_beu  = inst1_operands_valid_i & inst1_operands_h_exe_unit_i[`H_BEU];
assign inst1_sel_lsu  = inst1_operands_valid_i & inst1_operands_h_exe_unit_i[`H_LSU];

assign exe_alu0_valid_o = inst0_sel_alu0 | inst1_sel_alu0;
assign exe_alu0_rs1_valid_o = inst0_sel_alu0 ? inst0_operands_rs1_valid_i : inst1_operands_rs1_valid_i;
assign exe_alu0_rs1_o = inst0_sel_alu0 ? inst0_operands_rs1_i : inst1_operands_rs1_i;
assign exe_alu0_rs1_value_o = inst0_sel_alu0 ? inst0_operands_rs1_value_i : inst1_operands_rs1_value_i;
assign exe_alu0_rs2_valid_o = inst0_sel_alu0 ? inst0_operands_rs2_valid_i : inst1_operands_rs2_valid_i;
assign exe_alu0_rs2_o = inst0_sel_alu0 ? inst0_operands_rs2_i : inst1_operands_rs2_i;
assign exe_alu0_rs2_value_o = inst0_sel_alu0 ? inst0_operands_rs2_value_i : inst1_operands_rs2_value_i;
assign exe_alu0_rs3_valid_o = inst0_sel_alu0 ? inst0_operands_rs3_valid_i : inst1_operands_rs3_valid_i;
assign exe_alu0_rs3_o = inst0_sel_alu0 ? inst0_operands_rs3_i : inst1_operands_rs3_i;
assign exe_alu0_rs3_value_o = inst0_sel_alu0 ? inst0_operands_rs3_value_i : inst1_operands_rs3_value_i;
assign exe_alu0_rd_valid_o  = inst0_sel_alu0 ? inst0_operands_rd_valid_i : inst1_operands_rd_valid_i;
assign exe_alu0_rd_o = inst0_sel_alu0 ? inst0_operands_rd_i : inst1_operands_rd_i;
assign exe_alu0_rd_type_o = inst0_sel_alu0 ? inst0_operands_rd_type_i : inst1_operands_rd_type_i;
assign exe_alu0_rd_func_code_o = inst0_sel_alu0 ? inst0_operands_func_code_i : inst1_operands_func_code_i;
assign exe_alu0_rd_func3_o = inst0_sel_alu0 ? inst0_operands_func3_i : inst1_operands_func3_i;
assign exe_alu0_rd_func2_o = inst0_sel_alu0 ? inst0_operands_func2_i : inst1_operands_func2_i;
assign exe_alu0_rd_endsim_o = inst0_sel_alu0 ? inst0_operands_endsim_i : inst1_operands_endsim_i;
assign exe_alu0_rd_auipc_o = inst0_sel_alu0 ? inst0_operands_auipc_i : inst1_operands_auipc_i;
assign exe_alu0_rd_sid_o = inst0_sel_alu0 ? inst0_operands_sid_i : inst1_operands_sid_i;

assign exe_alu1_valid_o = inst0_sel_alu1 | inst1_sel_alu1;
assign exe_alu1_rs1_valid_o = inst0_sel_alu1 ? inst0_operands_rs1_valid_i : inst1_operands_rs1_valid_i;
assign exe_alu1_rs1_o = inst0_sel_alu1 ? inst0_operands_rs1_i : inst1_operands_rs1_i;
assign exe_alu1_rs1_value_o = inst0_sel_alu1 ? inst0_operands_rs1_value_i : inst1_operands_rs1_value_i;
assign exe_alu1_rs2_valid_o = inst0_sel_alu1 ? inst0_operands_rs2_valid_i : inst1_operands_rs2_valid_i;
assign exe_alu1_rs2_o = inst0_sel_alu1 ? inst0_operands_rs2_i : inst1_operands_rs2_i;
assign exe_alu1_rs2_value_o = inst0_sel_alu1 ? inst0_operands_rs2_value_i : inst1_operands_rs2_value_i;
assign exe_alu1_rs3_valid_o = inst0_sel_alu1 ? inst0_operands_rs3_valid_i : inst1_operands_rs3_valid_i;
assign exe_alu1_rs3_o = inst0_sel_alu1 ? inst0_operands_rs3_i : inst1_operands_rs3_i;
assign exe_alu1_rs3_value_o = inst0_sel_alu1 ? inst0_operands_rs3_value_i : inst1_operands_rs3_value_i;
assign exe_alu1_rd_valid_o  = inst0_sel_alu1 ? inst0_operands_rd_valid_i : inst1_operands_rd_valid_i;
assign exe_alu1_rd_o = inst0_sel_alu1 ? inst0_operands_rd_i : inst1_operands_rd_i;
assign exe_alu1_rd_type_o = inst0_sel_alu1 ? inst0_operands_rd_type_i : inst1_operands_rd_type_i;
assign exe_alu1_rd_func_code_o = inst0_sel_alu1 ? inst0_operands_func_code_i : inst1_operands_func_code_i;
assign exe_alu1_rd_func3_o = inst0_sel_alu1 ? inst0_operands_func3_i : inst1_operands_func3_i;
assign exe_alu1_rd_func2_o = inst0_sel_alu1 ? inst0_operands_func2_i : inst1_operands_func2_i;
assign exe_alu1_rd_endsim_o = inst0_sel_alu1 ? inst0_operands_endsim_i : inst1_operands_endsim_i;
assign exe_alu1_rd_auipc_o = inst0_sel_alu1 ? inst0_operands_auipc_i : inst1_operands_auipc_i;
assign exe_alu1_rd_sid_o = inst0_sel_alu1 ? inst0_operands_sid_i : inst1_operands_sid_i;

assign exe_beu_valid_o  = inst0_sel_beu  | inst1_sel_beu;
assign exe_beu_rs1_valid_o = inst0_sel_beu ? inst0_operands_rs1_valid_i : inst1_operands_rs1_valid_i;
assign exe_beu_rs1_o = inst0_sel_beu ? inst0_operands_rs1_i : inst1_operands_rs1_i;
assign exe_beu_rs1_value_o = inst0_sel_beu ? inst0_operands_rs1_value_i : inst1_operands_rs1_value_i;
assign exe_beu_rs2_valid_o = inst0_sel_beu ? inst0_operands_rs2_valid_i : inst1_operands_rs2_valid_i;
assign exe_beu_rs2_o = inst0_sel_beu ? inst0_operands_rs2_i : inst1_operands_rs2_i;
assign exe_beu_rs2_value_o = inst0_sel_beu ? inst0_operands_rs2_value_i : inst1_operands_rs2_value_i;
assign exe_beu_rs3_valid_o = inst0_sel_beu ? inst0_operands_rs3_valid_i : inst1_operands_rs3_valid_i;
assign exe_beu_rs3_o = inst0_sel_beu ? inst0_operands_rs3_i : inst1_operands_rs3_i;
assign exe_beu_rs3_value_o = inst0_sel_beu ? inst0_operands_rs3_value_i : inst1_operands_rs3_value_i;
assign exe_beu_rd_valid_o  = inst0_sel_beu ? inst0_operands_rd_valid_i : inst1_operands_rd_valid_i;
assign exe_beu_rd_o = inst0_sel_beu ? inst0_operands_rd_i : inst1_operands_rd_i;
assign exe_beu_rd_type_o = inst0_sel_beu ? inst0_operands_rd_type_i : inst1_operands_rd_type_i;
assign exe_beu_rd_func_code_o = inst0_sel_beu ? inst0_operands_func_code_i : inst1_operands_func_code_i;
assign exe_beu_rd_func3_o = inst0_sel_beu ? inst0_operands_func3_i : inst1_operands_func3_i;
assign exe_beu_rd_func2_o = inst0_sel_beu ? inst0_operands_func2_i : inst1_operands_func2_i;
assign exe_beu_rd_endsim_o = inst0_sel_beu ? inst0_operands_endsim_i : inst1_operands_endsim_i;
assign exe_beu_rd_auipc_o = inst0_sel_beu ? inst0_operands_auipc_i : inst1_operands_auipc_i;
assign exe_beu_rd_sid_o = inst0_sel_beu ? inst0_operands_sid_i : inst1_operands_sid_i;

assign exe_lsu_valid_o  = inst0_sel_lsu  | inst1_sel_lsu;
assign exe_lsu_rs1_valid_o = inst0_sel_lsu ? inst0_operands_rs1_valid_i : inst1_operands_rs1_valid_i;
assign exe_lsu_rs1_o = inst0_sel_lsu ? inst0_operands_rs1_i : inst1_operands_rs1_i;
assign exe_lsu_rs1_value_o = inst0_sel_lsu ? inst0_operands_rs1_value_i : inst1_operands_rs1_value_i;
assign exe_lsu_rs2_valid_o = inst0_sel_lsu ? inst0_operands_rs2_valid_i : inst1_operands_rs2_valid_i;
assign exe_lsu_rs2_o = inst0_sel_lsu ? inst0_operands_rs2_i : inst1_operands_rs2_i;
assign exe_lsu_rs2_value_o = inst0_sel_lsu ? inst0_operands_rs2_value_i : inst1_operands_rs2_value_i;
assign exe_lsu_rs3_valid_o = inst0_sel_lsu ? inst0_operands_rs3_valid_i : inst1_operands_rs3_valid_i;
assign exe_lsu_rs3_o = inst0_sel_lsu ? inst0_operands_rs3_i : inst1_operands_rs3_i;
assign exe_lsu_rs3_value_o = inst0_sel_lsu ? inst0_operands_rs3_value_i : inst1_operands_rs3_value_i;
assign exe_lsu_rd_valid_o  = inst0_sel_lsu ? inst0_operands_rd_valid_i : inst1_operands_rd_valid_i;
assign exe_lsu_rd_o = inst0_sel_lsu ? inst0_operands_rd_i : inst1_operands_rd_i;
assign exe_lsu_rd_type_o = inst0_sel_lsu ? inst0_operands_rd_type_i : inst1_operands_rd_type_i;
assign exe_lsu_rd_func_code_o = inst0_sel_lsu ? inst0_operands_func_code_i : inst1_operands_func_code_i;
assign exe_lsu_rd_func3_o = inst0_sel_lsu ? inst0_operands_func3_i : inst1_operands_func3_i;
assign exe_lsu_rd_func2_o = inst0_sel_lsu ? inst0_operands_func2_i : inst1_operands_func2_i;
assign exe_lsu_rd_endsim_o = inst0_sel_lsu ? inst0_operands_endsim_i : inst1_operands_endsim_i;
assign exe_lsu_rd_auipc_o = inst0_sel_lsu ? inst0_operands_auipc_i : inst1_operands_auipc_i;
assign exe_lsu_rd_sid_o = inst0_sel_lsu ? inst0_operands_sid_i : inst1_operands_sid_i;

endmodule