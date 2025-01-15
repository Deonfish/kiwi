module Kiwi(
	input clk,
	input rst_n,
    // IBIU axi-lite interface
    output        ibiu_axi_awvalid,
    output [63:0] ibiu_axi_awaddr,
    output [2:0]  ibiu_axi_awprot,
    input         ibiu_axi_awready,
    output        ibiu_axi_wvalid,
    output [63:0] ibiu_axi_wdata,
    output [7:0]  ibiu_axi_wstrb,
    input         ibiu_axi_wready,
    input         ibiu_axi_bvalid,
    input [1:0]   ibiu_axi_bresp,
    output        ibiu_axi_bready,
    output        ibiu_axi_arvalid,
    output [63:0] ibiu_axi_araddr,
    output [2:0]  ibiu_axi_arprot,
    input         ibiu_axi_arready,
    input         ibiu_axi_rvalid,
    input [63:0]  ibiu_axi_rdata,
    input [1:0]   ibiu_axi_rresp,
    output        ibiu_axi_rready,
	// DBIU axi-lite interface
    output        dbiu_axi_awvalid,
    output [63:0] dbiu_axi_awaddr,
    output [2:0]  dbiu_axi_awprot,
    input         dbiu_axi_awready,
    output        dbiu_axi_wvalid,
    output [63:0] dbiu_axi_wdata,
    output [7:0]  dbiu_axi_wstrb,
    input         dbiu_axi_wready,
    input         dbiu_axi_bvalid,
    input [1:0]   dbiu_axi_bresp,
    output        dbiu_axi_bready,
    output        dbiu_axi_arvalid,
    output [63:0] dbiu_axi_araddr,
    output [2:0]  dbiu_axi_arprot,
    input         dbiu_axi_arready,
    input         dbiu_axi_rvalid,
    input [63:0]  dbiu_axi_rdata,
    input [1:0]   dbiu_axi_rresp,
    output        dbiu_axi_rready,
);

wire [63:0] f0_pc;
wire f0_valid;
wire [63:0] reset_vec;
wire [0:0] icache_valid;
wire [63:0] icache_pc;
wire [511:0] icache_data;
wire [0:0] icache_miss_valid;
wire [0:0] icache_miss_ready;
wire [0:0] refill_icache_ready;
wire [63:0] icache_miss_addr;
wire [0:0] instq_full;
wire [0:0] iq0_vld;
wire [63:0] iq0_pc;
wire [31:0] iq0_inst;
wire [0:0] iq1_vld;
wire [63:0] iq1_pc;
wire [31:0] iq1_inst;
wire [0:0] inst0_decoder_valid;
wire [63:0] inst0_pc;
wire [31:0] inst0_inst;
wire [0:0] inst1_decoder_valid;
wire [63:0] inst1_pc;
wire [31:0] inst1_inst;
wire [0:0] inst0_decoder_rs1_valid;
wire [4:0] inst0_decoder_rs1;
wire [0:0] inst0_decoder_rs2_valid;
wire [4:0] inst0_decoder_rs2;
wire [0:0] inst0_decoder_rs3_valid;
wire [4:0] inst0_decoder_rs3;
wire [1:0] inst0_decoder_rd_type;
wire [4:0] inst0_decoder_rd;
wire [3:0] inst0_decoder_func_code;
wire [2:0] inst0_decoder_func3;
wire [1:0] inst0_decoder_func2;
wire [0:0] inst0_decoder_endsim;
wire [0:0] inst0_decoder_auipc;
wire [0:0] inst1_decoder_rs1_valid;
wire [4:0] inst1_decoder_rs1;
wire [0:0] inst1_decoder_rs2_valid;
wire [4:0] inst1_decoder_rs2;
wire [0:0] inst1_decoder_rs3_valid;
wire [4:0] inst1_decoder_rs3;
wire [1:0] inst1_decoder_rd_type;
wire [4:0] inst1_decoder_rd;
wire [5:0] inst1_decoder_h_exe_unit;
wire [3:0] inst1_decoder_func_code;
wire [2:0] inst1_decoder_func3;
wire [1:0] inst1_decoder_func2;
wire [0:0] inst1_decoder_endsim;
wire [0:0] inst1_decoder_auipc;
wire [0:0] stall_decoder_inst0;
wire [0:0] stall_decoder_inst1;
wire [`SCOREBOARD_SIZE_WIDTH:0] inst0_decoder_sid;
wire [`H_EXE_UNIT_WIDTH-1:0] inst0_decoder_h_exe_unit;
wire [`SCOREBOARD_SIZE_WIDTH:0] inst1_decoder_sid;
wire [`H_EXE_UNIT_WIDTH-1:0] inst1_decoder_h_exe_unit;
wire [0:0]  inst0_operands_valid;
wire [63:0] inst0_operands_pc;
wire [31:0] inst0_operands_inst;
wire [0:0]  inst0_operands_rs1_valid;
wire [4:0]  inst0_operands_rs1;
wire [63:0] inst0_operands_rs1_value;
wire [0:0]  inst0_operands_rs2_valid;
wire [4:0]  inst0_operands_rs2;
wire [63:0] inst0_operands_rs2_value;
wire [0:0]  inst0_operands_rs3_valid;
wire [4:0]  inst0_operands_rs3;
wire [63:0] inst0_operands_rs3_value;
wire [1:0]  inst0_operands_rd_type;
wire [4:0]  inst0_operands_rd;
wire [5:0]  inst0_operands_h_exe_unit;
wire [3:0]  inst0_operands_func_code;
wire [2:0]  inst0_operands_func3;
wire [1:0]  inst0_operands_func2;
wire [0:0]  inst0_operands_endsim;
wire [0:0]  inst0_operands_auipc;
wire [`SCOREBOARD_SIZE_WIDTH:0] inst0_operands_sid;
wire [0:0]  inst1_operands_valid;
wire [63:0] inst1_operands_pc;
wire [31:0] inst1_operands_inst;
wire [0:0]  inst1_operands_rs1_valid;
wire [4:0]  inst1_operands_rs1;
wire [63:0] inst1_operands_rs1_value;
wire [0:0]  inst1_operands_rs2_valid;
wire [4:0]  inst1_operands_rs2;
wire [63:0] inst1_operands_rs2_value;
wire [0:0]  inst1_operands_rs3_valid;
wire [4:0]  inst1_operands_rs3;
wire [63:0] inst1_operands_rs3_value;
wire [1:0]  inst1_operands_rd_type;
wire [4:0]  inst1_operands_rd;
wire [5:0]  inst1_operands_h_exe_unit;
wire [3:0]  inst1_operands_func_code;
wire [2:0]  inst1_operands_func3;
wire [1:0]  inst1_operands_func2;
wire [0:0]  inst1_operands_endsim;
wire [0:0]  inst1_operands_auipc;
wire [`SCOREBOARD_SIZE_WIDTH:0] inst1_operands_sid;

wire [0:0] 						alu0_op_valid;
wire [0:0] 						alu0_op_rs1_valid;
wire [63:0] 					alu0_op_rs1_value;
wire [4:0] 						alu0_op_rs1;
wire [0:0] 						alu0_op_rs2_valid;
wire [63:0] 					alu0_op_rs2_value;
wire [4:0] 						alu0_op_rs2;
wire [0:0] 						alu0_op_rs3_valid;
wire [63:0] 					alu0_op_rs3_value;
wire [4:0] 						alu0_op_rs3;
wire [0:0] 						alu0_op_rd_valid;
wire [4:0] 						alu0_op_rd;
wire [1:0] 						alu0_op_rd_type;
wire [3:0] 						alu0_op_func_code;
wire [2:0] 						alu0_op_func3;
wire [1:0] 						alu0_op_func2;
wire [0:0] 						alu0_op_endsim;
wire [0:0] 						alu0_op_auipc;
wire [63:0] 					alu0_op_pc;
wire [31:0] 					alu0_op_inst;
wire [`SCOREBOARD_SIZE_WIDTH-1:0] alu0_op_sid;

wire [0:0] 						alu1_op_valid;
wire [0:0] 						alu1_op_rs1_valid;
wire [63:0] 					alu1_op_rs1_value;
wire [4:0] 						alu1_op_rs1;
wire [0:0] 						alu1_op_rs2_valid;
wire [63:0] 					alu1_op_rs2_value;
wire [4:0] 						alu1_op_rs2;
wire [0:0] 						alu1_op_rs3_valid;
wire [63:0] 					alu1_op_rs3_value;
wire [4:0] 						alu1_op_rs3;
wire [0:0] 						alu1_op_rd_valid;
wire [4:0] 						alu1_op_rd;
wire [1:0] 						alu1_op_rd_type;
wire [3:0] 						alu1_op_func_code;
wire [2:0] 						alu1_op_func3;
wire [1:0] 						alu1_op_func2;
wire [0:0] 						alu1_op_endsim;
wire [0:0] 						alu1_op_auipc;
wire [63:0] 					alu1_op_pc;
wire [31:0] 					alu1_op_inst;
wire [`SCOREBOARD_SIZE_WIDTH-1:0] alu1_op_sid;

wire [0:0] 						beu_op_valid;
wire [0:0] 						beu_op_rs1_valid;
wire [63:0] 					beu_op_rs1_value;
wire [4:0] 						beu_op_rs1;
wire [0:0] 						beu_op_rs2_valid;
wire [63:0] 					beu_op_rs2_value;
wire [4:0] 						beu_op_rs2;
wire [0:0] 						beu_op_rs3_valid;
wire [63:0] 					beu_op_rs3_value;
wire [4:0] 						beu_op_rs3;
wire [0:0] 						beu_op_rd_valid;
wire [4:0] 						beu_op_rd;
wire [1:0] 						beu_op_rd_type;
wire [3:0] 						beu_op_func_code;
wire [2:0] 						beu_op_func3;
wire [1:0] 						beu_op_func2;
wire [0:0] 						beu_op_endsim;
wire [0:0] 						beu_op_auipc;
wire [63:0] 					beu_op_pc;
wire [31:0] 					beu_op_inst;
wire [`SCOREBOARD_SIZE_WIDTH-1:0] beu_op_sid;

wire [0:0] 						lsu_op_valid;
wire [0:0] 						lsu_op_rs1_valid;
wire [63:0] 					lsu_op_rs1_value;
wire [4:0] 						lsu_op_rs1;
wire [0:0] 						lsu_op_rs2_valid;
wire [63:0] 					lsu_op_rs2_value;
wire [4:0] 						lsu_op_rs2;
wire [0:0] 						lsu_op_rs3_valid;
wire [63:0] 					lsu_op_rs3_value;
wire [4:0] 						lsu_op_rs3;
wire [0:0] 						lsu_op_rd_valid;
wire [4:0] 						lsu_op_rd;
wire [63:0] 					lsu_op_rd_value;
wire [1:0] 						lsu_op_rd_type;
wire [3:0] 						lsu_op_func_code;
wire [2:0] 						lsu_op_func3;
wire [1:0] 						lsu_op_func2;
wire [0:0] 						lsu_op_endsim;
wire [0:0] 						lsu_op_auipc;
wire [63:0] 					lsu_op_pc;
wire [31:0] 					lsu_op_inst;
wire [`SCOREBOARD_SIZE_WIDTH-1:0] lsu_op_sid;

wire [0:0] 	alu0_exe_valid;
wire [`SCOREBOARD_SIZE_WIDTH-1:0] alu0_exe_sid;
wire [4:0] 	alu0_exe_rd;
wire [63:0] alu0_exe_rd_value;
wire [0:0] 	alu1_exe_valid;
wire [`SCOREBOARD_SIZE_WIDTH-1:0] alu1_exe_sid;
wire [4:0] 	alu1_exe_rd;
wire [63:0] alu1_exe_rd_value;
wire [0:0] 	beu_exe_valid;
wire [4:0] 	beu_exe_rd;
wire [63:0] beu_exe_rd_value;
wire [0:0] 	beu_exe_redirect;
wire [63:0] beu_exe_redirect_pc;
wire [`SCOREBOARD_SIZE_WIDTH-1:0] beu_exe_sid;
wire [0:0] 	lsu_exe_valid;
wire [`SCOREBOARD_SIZE_WIDTH-1:0] lsu_exe_sid;
wire [4:0] 	lsu_exe_rd;
wire [63:0] lsu_exe_rd_value;

wire [0:0] 	exe_inst0_valid;
wire [63:0] exe_inst0_rd_value;
wire [4:0] 	exe_inst0_rd;
wire [0:0] 	exe_inst0_redirect;
wire [63:0] exe_inst0_redirect_pc;
wire [`SCOREBOARD_SIZE_WIDTH-1:0] exe_inst0_sid;
wire [0:0] 	exe_inst1_valid;
wire [63:0] exe_inst1_rd_value;
wire [4:0] 	exe_inst1_rd;
wire [0:0] 	exe_inst1_redirect;
wire [63:0] exe_inst1_redirect_pc;
wire [`SCOREBOARD_SIZE_WIDTH-1:0] exe_inst1_sid;

wire [0:0] 	lsu_uncache_mem_vld;
wire [0:0] 	lsu_uncache_mem_ready;
wire [0:0] 	lsu_uncache_mem_write;
wire [2:0] 	lsu_uncache_mem_size;
wire [63:0] lsu_uncache_mem_addr;
wire [63:0] lsu_uncache_mem_wdata;
wire [63:0] lsu_uncache_mem_rdata;

wire [0:0] 	lsu_uncache_mem_resp_vld;
wire [0:0] 	lsu_uncache_mem_resp_rdy;
wire [63:0] lsu_uncache_mem_resp_data;

wire [0:0] 	wb_inst0_valid;
wire [`SCOREBOARD_SIZE_WIDTH:0] wb_inst0_sid;
wire [63:0] wb_inst0_rd_value;
wire [4:0] 	wb_inst0_rd;
wire [0:0] 	wb_inst0_redirect;
wire [63:0] wb_inst0_redirect_pc;

wire [0:0] 	wb_inst1_valid;
wire [`SCOREBOARD_SIZE_WIDTH:0] wb_inst1_sid;
wire [63:0] wb_inst1_rd_value;
wire [4:0] 	wb_inst1_rd;
wire [0:0] 	wb_inst1_redirect;
wire [63:0] wb_inst1_redirect_pc;

assign reset_vec = 64'h0;

Fetch0 u_Fetch0 (
	.clk(clk),
	.rst_n(rst_n),
	.reset_vec(reset_vec),
    // flush from wb
	.redir_i(wb_redirect),
	.redir_pc_i(wb_redirect_pc),
    // stall from instQueue
	.stall_f0_i(instq_full),
    // to Icache
	.f0_valid_o(f0_valid),
	.f0_pc_o(f0_pc)
);

Icache u_Icache (
	.clk(clk),
	.rst_n(rst_n),
    // from Fetch0
	.f0_valid_i(f0_valid),
	.f0_pc_i(f0_pc),
    // inst to instQueue
	.icache_valid_o(icache_valid),
	.icache_pc_o(icache_pc),
	.icache_data_o(icache_data),
    // icache miss to mem subsystem
	.icache_miss_valid_o(icache_miss_valid),
	.icache_miss_ready_i(icache_miss_ready),
	.icache_miss_addr_o(icache_miss_addr),
	.refill_icache_valid_i(refill_icache_valid),
	.refill_icache_ready_o(refill_icache_ready),
	.refill_icache_data_i(refill_icache_data),
    // stall from instQueue
	.stall_icache_i(instq_full),
    // squash from backend
	.squash_pipe_i(wb_redirect)
);

BIU u_IBIU (
	.clk(clk),
	.rst_n(rst_n),
	// cache req
    .cache_req_vld_i(icache_miss_valid),
    .cache_req_rdy_o(icache_miss_ready),
    .cache_req_rd_i(1'b1),
    .cache_req_addr_i(icache_miss_addr),
    .cache_req_wdata_i('b0),
    // cache resp
    .cache_resp_vld_o(refill_icache_valid),
    .cache_resp_rdy_i(refill_icache_ready),
    .cache_resp_rdata_o(refill_icache_data),
    .cache_resp_err_o(),
    // uncache req
    .uncache_req_vld_i(1'b0),
    .uncache_req_rdy_o(),
    .uncache_req_rd_i('b0),
    .uncache_req_addr_i('b0),
    .uncache_req_wdata_i('b0),
    // uncache resp
    .uncache_resp_vld_o(),
    .uncache_resp_rdy_i(1'b0),
    .uncache_resp_rdata_o(),
    .uncache_resp_err_o(),
    // axi3-lite
	.awvalid_o(ibiu_axi_awvalid),
	.awready_i(ibiu_axi_awready),
	.awaddr_o(ibiu_axi_awaddr),
	.awprot_o(ibiu_axi_awprot),
	.wvalid_o(ibiu_axi_wvalid),
	.wready_i(ibiu_axi_wready),
	.wdata_o(ibiu_axi_wdata),
	.wstrb_o(ibiu_axi_wstrb),
	.bvalid_i(ibiu_axi_bvalid),
	.bready_o(ibiu_axi_bready),
	.bresp_i(ibiu_axi_bresp),
	.arvalid_o(ibiu_axi_arvalid),
	.arready_i(ibiu_axi_arready),
	.araddr_o(ibiu_axi_araddr),
	.arprot_o(ibiu_axi_arprot),
	.rvalid_i(ibiu_axi_rvalid),
	.rready_o(ibiu_axi_rready),
	.rdata_i(ibiu_axi_rdata),
	.rresp_i(ibiu_axi_rresp),
	.rlast_i(ibiu_axi_rlast)
);

InstQueue u_InstQueue (
	.clk(clk),
	.rst_n(rst_n),
    // from Icache
	.icache_valid_i(icache_valid),
	.icache_pc_i(icache_pc),
	.icache_data_i(icache_data),
	.instq_full_o(instq_full),
    // to Fetch0
	.iq0_vld_o(iq0_vld),
	.iq0_pc_o(iq0_pc),
	.iq0_inst_o(iq0_inst),
	.iq1_vld_o(iq1_vld),
	.iq1_pc_o(iq1_pc),
	.iq1_inst_o(iq1_inst),
    // stall from backend
	.stall_iq_i(stall_decoder_inst0 | stall_decoder_inst1),
    // squash from backend
	.flush_iq_i(wb_redirect)
);

Decoder u_Decoder (
	.clk(clk),
	.rst_n(rst_n),
    // stall from scoreboard
	.stall_decoder_inst0_i(stall_decoder_inst0),
	.stall_decoder_inst1_i(stall_decoder_inst1),
    // flush from wb
	.flush_decoder_i(wb_redirect),
    // from instQueue
	.inst0_f1_valid_i(iq0_vld),
	.inst0_f1_pc_i(iq0_pc),
	.inst0_f1_inst_i(iq0_inst),
	.inst1_f1_valid_i(iq1_vld),
	.inst1_f1_pc_i(iq1_pc),
	.inst1_f1_inst_i(iq1_inst),
    // to operands
	.inst0_decoder_valid_o      (inst0_decoder_valid),
	.inst0_decoder_pc_o         (inst0_decoder_pc),
	.inst0_decoder_inst_o       (inst0_decoder_inst),
    .inst0_decoder_rs1_valid_o  (inst0_decoder_rs1_valid),
    .inst0_decoder_rs1_o        (inst0_decoder_rs1),
    .inst0_decoder_rs2_valid_o  (inst0_decoder_rs2_valid),
    .inst0_decoder_rs2_o        (inst0_decoder_rs2),
    .inst0_decoder_rs3_valid_o  (inst0_decoder_rs3_valid),
    .inst0_decoder_rs3_o        (inst0_decoder_rs3),
    .inst0_decoder_rd_type_o    (inst0_decoder_rd_type),
    .inst0_decoder_rd_o         (inst0_decoder_rd),
    .inst0_decoder_exe_unit_o   (inst0_decoder_exe_unit),
    .inst0_decoder_func_code_o  (inst0_decoder_func_code),
    .inst0_decoder_func3_o      (inst0_decoder_func3),
    .inst0_decoder_func2_o      (inst0_decoder_func2),
    .inst0_decoder_endsim_o     (inst0_decoder_endsim),
    .inst0_decoder_auipc_o      (inst0_decoder_auipc),
    .inst1_decoder_valid_o      (inst1_decoder_valid),
    .inst1_decoder_pc_o         (inst1_decoder_pc),
    .inst1_decoder_inst_o       (inst1_decoder_inst),
    .inst1_decoder_rs1_valid_o  (inst1_decoder_rs1_valid),
    .inst1_decoder_rs1_o        (inst1_decoder_rs1),
    .inst1_decoder_rs2_valid_o  (inst1_decoder_rs2_valid),
    .inst1_decoder_rs2_o        (inst1_decoder_rs2),
    .inst1_decoder_rs3_valid_o  (inst1_decoder_rs3_valid),
    .inst1_decoder_rs3_o        (inst1_decoder_rs3),
    .inst1_decoder_rd_type_o    (inst1_decoder_rd_type),
    .inst1_decoder_rd_o         (inst1_decoder_rd),
    .inst1_decoder_exe_unit_o   (inst1_decoder_exe_unit),
    .inst1_decoder_func_code_o  (inst1_decoder_func_code),
    .inst1_decoder_func3_o      (inst1_decoder_func3),
    .inst1_decoder_func2_o      (inst1_decoder_func2),
    .inst1_decoder_endsim_o     (inst1_decoder_endsim),
    .inst1_decoder_auipc_o      (inst1_decoder_auipc)
);

Operands u_Operands (
	.clk                           (clk),
	.rst_n                         (rst_n),
	// stall from scoreboard
	.stall_operands_inst0_i        (op_stall_inst0),
	.stall_operands_inst1_i        (op_stall_inst1),
	// flush from wb
	.flush_operands_i              (wb_redirect),
	// from decoder
	.inst0_decoder_valid_i         (inst0_decoder_valid),
	.inst0_decoder_rs1_valid_i     (inst0_decoder_rs1_valid),
	.inst0_decoder_rs1_i           (inst0_decoder_rs1),
	.inst0_decoder_rs2_valid_i     (inst0_decoder_rs2_valid),
	.inst0_decoder_rs2_i           (inst0_decoder_rs2),
	.inst0_decoder_rs3_valid_i     (inst0_decoder_rs3_valid),
	.inst0_decoder_rs3_i           (inst0_decoder_rs3),
	.inst0_decoder_rd_type_i       (inst0_decoder_rd_type),
	.inst0_decoder_rd_i            (inst0_decoder_rd),
	.inst0_decoder_h_exe_unit_i    (inst0_decoder_h_exe_unit),
	.inst0_decoder_func_code_i     (inst0_decoder_func_code),
	.inst0_decoder_func3_i         (inst0_decoder_func3),
	.inst0_decoder_func2_i         (inst0_decoder_func2),
	.inst0_decoder_endsim_i        (inst0_decoder_endsim),
	.inst0_decoder_auipc_i         (inst0_decoder_auipc),
	.inst0_decoder_sid_i           (inst0_decoder_sid),
	.inst1_decoder_valid_i         (inst1_decoder_valid),
	.inst1_decoder_rs1_valid_i     (inst1_decoder_rs1_valid),
	.inst1_decoder_rs1_i           (inst1_decoder_rs1),
	.inst1_decoder_rs2_valid_i     (inst1_decoder_rs2_valid),
	.inst1_decoder_rs2_i           (inst1_decoder_rs2),
	.inst1_decoder_rs3_valid_i     (inst1_decoder_rs3_valid),
	.inst1_decoder_rs3_i           (inst1_decoder_rs3),
	.inst1_decoder_rd_type_i       (inst1_decoder_rd_type),
	.inst1_decoder_rd_i            (inst1_decoder_rd),
	.inst1_decoder_h_exe_unit_i    (inst1_decoder_h_exe_unit),
	.inst1_decoder_func_code_i     (inst1_decoder_func_code),
	.inst1_decoder_func3_i         (inst1_decoder_func3),
	.inst1_decoder_func2_i         (inst1_decoder_func2),
	.inst1_decoder_endsim_i        (inst1_decoder_endsim),
	.inst1_decoder_auipc_i         (inst1_decoder_auipc),
	.inst1_decoder_sid_i           (inst1_decoder_sid),
	// to execute
	.inst0_operands_valid_o        (inst0_operands_valid),
	.inst0_operands_rs1_valid_o    (inst0_operands_rs1_valid),
	.inst0_operands_rs1_o          (inst0_operands_rs1),
	.inst0_operands_rs1_value_o    (inst0_operands_rs1_value),
	.inst0_operands_rs2_valid_o    (inst0_operands_rs2_valid),
	.inst0_operands_rs2_o          (inst0_operands_rs2),
	.inst0_operands_rs2_value_o    (inst0_operands_rs2_value),
	.inst0_operands_rs3_valid_o    (inst0_operands_rs3_valid),
	.inst0_operands_rs3_o          (inst0_operands_rs3),
	.inst0_operands_rs3_value_o    (inst0_operands_rs3_value),
	.inst0_operands_rd_type_o      (inst0_operands_rd_type),
	.inst0_operands_rd_o           (inst0_operands_rd),
	.inst0_operands_h_exe_unit_o   (inst0_operands_h_exe_unit),
	.inst0_operands_func_code_o    (inst0_operands_func_code),
	.inst0_operands_func3_o        (inst0_operands_func3),
	.inst0_operands_func2_o        (inst0_operands_func2),
	.inst0_operands_endsim_o       (inst0_operands_endsim),
	.inst0_operands_auipc_o        (inst0_operands_auipc),
	.inst0_operands_sid_o          (inst0_operands_sid),
	.inst1_operands_valid_o        (inst1_operands_valid),
	.inst1_operands_rs1_valid_o    (inst1_operands_rs1_valid),
	.inst1_operands_rs1_o          (inst1_operands_rs1),
	.inst1_operands_rs1_value_o    (inst1_operands_rs1_value),
	.inst1_operands_rs2_valid_o    (inst1_operands_rs2_valid),
	.inst1_operands_rs2_o          (inst1_operands_rs2),
	.inst1_operands_rs2_value_o    (inst1_operands_rs2_value),
	.inst1_operands_rs3_valid_o    (inst1_operands_rs3_valid),
	.inst1_operands_rs3_o          (inst1_operands_rs3),
	.inst1_operands_rs3_value_o    (inst1_operands_rs3_value),
	.inst1_operands_rd_type_o      (inst1_operands_rd_type),
	.inst1_operands_rd_o           (inst1_operands_rd),
	.inst1_operands_h_exe_unit_o   (inst1_operands_h_exe_unit),
	.inst1_operands_func_code_o    (inst1_operands_func_code),
	.inst1_operands_func3_o        (inst1_operands_func3),
	.inst1_operands_func2_o        (inst1_operands_func2),
	.inst1_operands_endsim_o       (inst1_operands_endsim),
	.inst1_operands_auipc_o        (inst1_operands_auipc),
	.inst1_operands_sid_o          (inst1_operands_sid),
	// write reg from wb
	.inst0_wb_valid_i              (wb_inst0_valid),
	.inst0_wb_rd_i                 (wb_inst0_rd),
	.inst0_wb_value_i              (wb_inst0_rd_value),
	.inst1_wb_valid_i              (wb_inst1_valid),
	.inst1_wb_rd_i                 (wb_inst1_rd),
	.inst1_wb_value_i              (wb_inst1_rd_value)
);

Op_exe_sequencer u_Op_exe_sequencer (
    .clk                        (clk),
    .rst_n                      (rst_n),
    .inst0_operands_valid_i     (inst0_operands_valid),
    .inst0_operands_inst_i      (inst0_operands_inst),
    .inst0_operands_rs1_valid_i (inst0_operands_rs1_valid),
    .inst0_operands_rs1_i       (inst0_operands_rs1),
    .inst0_operands_rs1_value_i (inst0_operands_rs1_value),
    .inst0_operands_rs2_valid_i (inst0_operands_rs2_valid),
    .inst0_operands_rs2_i       (inst0_operands_rs2),
    .inst0_operands_rs2_value_i (inst0_operands_rs2_value),
    .inst0_operands_rs3_valid_i (inst0_operands_rs3_valid),
    .inst0_operands_rs3_i       (inst0_operands_rs3),
    .inst0_operands_rs3_value_i (inst0_operands_rs3_value),
    .inst0_operands_rd_type_i   (inst0_operands_rd_type),
    .inst0_operands_rd_i        (inst0_operands_rd),
    .inst0_operands_h_exe_unit_i(inst0_operands_h_exe_unit),
    .inst0_operands_func_code_i (inst0_operands_func_code),
    .inst0_operands_func3_i     (inst0_operands_func3),
    .inst0_operands_func2_i     (inst0_operands_func2),
    .inst0_operands_endsim_i    (inst0_operands_endsim),
    .inst0_operands_auipc_i     (inst0_operands_auipc),
    .inst0_operands_sid_i       (inst0_operands_sid),
    .inst1_operands_valid_i     (inst1_operands_valid),
    .inst1_operands_inst_i      (inst1_operands_inst),
    .inst1_operands_rs1_valid_i (inst1_operands_rs1_valid),
    .inst1_operands_rs1_i       (inst1_operands_rs1),
    .inst1_operands_rs1_value_i (inst1_operands_rs1_value),
    .inst1_operands_rs2_valid_i (inst1_operands_rs2_valid),
    .inst1_operands_rs2_i       (inst1_operands_rs2),
    .inst1_operands_rs2_value_i (inst1_operands_rs2_value),
    .inst1_operands_rs3_valid_i (inst1_operands_rs3_valid),
    .inst1_operands_rs3_i       (inst1_operands_rs3),
    .inst1_operands_rs3_value_i (inst1_operands_rs3_value),
    .inst1_operands_rd_type_i   (inst1_operands_rd_type),
    .inst1_operands_rd_i        (inst1_operands_rd),
    .inst1_operands_h_exe_unit_i(inst1_operands_h_exe_unit),
    .inst1_operands_func_code_i (inst1_operands_func_code),
    .inst1_operands_func3_i     (inst1_operands_func3),
    .inst1_operands_func2_i     (inst1_operands_func2),
    .inst1_operands_endsim_i    (inst1_operands_endsim),
    .inst1_operands_auipc_i     (inst1_operands_auipc),
    .inst1_operands_sid_i       (inst1_operands_sid),

    .exe_alu0_valid_o          (alu0_op_valid),
    .exe_alu0_rs1_valid_o      (alu0_op_rs1_valid),
    .exe_alu0_rs1_value_o      (alu0_op_rs1_value),
    .exe_alu0_rs1_o            (alu0_op_rs1),
    .exe_alu0_rs2_valid_o      (alu0_op_rs2_valid),
    .exe_alu0_rs2_value_o      (alu0_op_rs2_value),
    .exe_alu0_rs2_o            (alu0_op_rs2),
    .exe_alu0_rs3_valid_o      (alu0_op_rs3_valid),
    .exe_alu0_rs3_value_o      (alu0_op_rs3_value),
    .exe_alu0_rs3_o            (alu0_op_rs3),
    .exe_alu0_rd_valid_o       (alu0_op_rd_valid),
    .exe_alu0_rd_o             (alu0_op_rd),
    .exe_alu0_rd_type_o        (alu0_op_rd_type),
    .exe_alu0_rd_func_code_o   (alu0_op_func_code),
    .exe_alu0_rd_func3_o       (alu0_op_func3),
    .exe_alu0_rd_func2_o       (alu0_op_func2),
    .exe_alu0_rd_endsim_o      (alu0_op_endsim),
    .exe_alu0_rd_auipc_o       (alu0_op_auipc),
    .exe_alu0_rd_sid_o         (alu0_op_sid),

    .exe_alu1_valid_o          (alu1_op_valid),
    .exe_alu1_rs1_valid_o      (alu1_op_rs1_valid),
    .exe_alu1_rs1_value_o      (alu1_op_rs1_value),
    .exe_alu1_rs1_o            (alu1_op_rs1),
    .exe_alu1_rs2_valid_o      (alu1_op_rs2_valid),
    .exe_alu1_rs2_value_o      (alu1_op_rs2_value),
    .exe_alu1_rs2_o            (alu1_op_rs2),
    .exe_alu1_rs3_valid_o      (alu1_op_rs3_valid),
    .exe_alu1_rs3_value_o      (alu1_op_rs3_value),
    .exe_alu1_rs3_o            (alu1_op_rs3),
    .exe_alu1_rd_valid_o       (alu1_op_rd_valid),
    .exe_alu1_rd_o             (alu1_op_rd),
    .exe_alu1_rd_type_o        (alu1_op_rd_type),
    .exe_alu1_rd_func_code_o   (alu1_op_func_code),
    .exe_alu1_rd_func3_o       (alu1_op_func3),
    .exe_alu1_rd_func2_o       (alu1_op_func2),
    .exe_alu1_rd_endsim_o      (alu1_op_endsim),
    .exe_alu1_rd_auipc_o       (alu1_op_auipc),
    .exe_alu1_rd_sid_o         (alu1_op_sid),

    .exe_beu_valid_o           (beu_op_valid),
    .exe_beu_rs1_valid_o       (beu_op_rs1_valid),
    .exe_beu_rs1_value_o       (beu_op_rs1_value),
    .exe_beu_rs1_o             (beu_op_rs1),
    .exe_beu_rs2_valid_o       (beu_op_rs2_valid),
    .exe_beu_rs2_value_o       (beu_op_rs2_value),
    .exe_beu_rs2_o             (beu_op_rs2),
    .exe_beu_rs3_valid_o       (beu_op_rs3_valid),
    .exe_beu_rs3_value_o       (beu_op_rs3_value),
    .exe_beu_rs3_o             (beu_op_rs3),
    .exe_beu_rd_valid_o        (beu_op_rd_valid),
    .exe_beu_rd_o              (beu_op_rd),
    .exe_beu_rd_type_o         (beu_op_rd_type),
    .exe_beu_rd_func_code_o    (beu_op_func_code),
    .exe_beu_rd_func3_o        (beu_op_func3),
    .exe_beu_rd_func2_o        (beu_op_func2),
    .exe_beu_rd_endsim_o       (beu_op_endsim),
    .exe_beu_rd_auipc_o        (beu_op_auipc),
    .exe_beu_rd_sid_o          (beu_op_sid),

    .exe_lsu_valid_o           (lsu_op_valid),
    .exe_lsu_rs1_valid_o       (lsu_op_rs1_valid),
    .exe_lsu_rs1_value_o       (lsu_op_rs1_value),
    .exe_lsu_rs1_o             (lsu_op_rs1),
    .exe_lsu_rs2_valid_o       (lsu_op_rs2_valid),
    .exe_lsu_rs2_value_o       (lsu_op_rs2_value),
    .exe_lsu_rs2_o             (lsu_op_rs2),
    .exe_lsu_rs3_valid_o       (lsu_op_rs3_valid),
    .exe_lsu_rs3_value_o       (lsu_op_rs3_value),
    .exe_lsu_rs3_o             (lsu_op_rs3),
    .exe_lsu_rd_valid_o        (lsu_op_rd_valid),
    .exe_lsu_rd_o              (lsu_op_rd),
    .exe_lsu_rd_type_o         (lsu_op_rd_type),
    .exe_lsu_rd_func_code_o    (lsu_op_func_code),
    .exe_lsu_rd_func3_o        (lsu_op_func3),
    .exe_lsu_rd_func2_o        (lsu_op_func2),
    .exe_lsu_rd_endsim_o       (lsu_op_endsim),
    .exe_lsu_rd_auipc_o        (lsu_op_auipc),
    .exe_lsu_rd_sid_o          (lsu_op_sid)
);

ALU u_ALU0 (
	.clk                  (clk),
	.rst_n                (rst_n),
	// flush
	.flush_i              (wb_redirect),
	// from operands
	.alu_valid_i          (alu0_op_valid),
	.alu_func3_i          (alu0_op_func3), 
	.alu_auipc_i          (alu0_op_auipc),
	.alu_pc_i             (alu0_op_pc),
	.alu_inst_i           (alu0_op_inst),
	.alu_sid_i            (alu0_op_sid),
	.rs1_value_i          (alu0_op_rs1_value),
	.rs2_value_i          (alu0_op_rs2_value),
	.func_code_i          (alu0_op_func_code),
	.endsim_i             (alu0_op_endsim),
	// alu result
	.alu_exe_valid_o      (alu0_exe_valid),
	.alu_sid_o            (alu0_exe_sid),
	.alu_exe_rd_o         (alu0_exe_rd),
	.alu_exe_rd_value_o   (alu0_exe_rd_value)
);

ALU u_ALU1 (
	.clk                  (clk),
	.rst_n                (rst_n),
	// flush
	.flush_i              (wb_redirect),
	// from operands
	.alu_valid_i          (alu1_op_valid),
	.alu_func3_i          (alu1_op_func3),
	.alu_auipc_i          (alu1_op_auipc), 
	.alu_pc_i             (alu1_op_pc),
	.alu_inst_i           (alu1_op_inst),
	.alu_sid_i            (alu1_op_sid),
	.rs1_value_i          (alu1_op_rs1_value),
	.rs2_value_i          (alu1_op_rs2_value),
	.func_code_i          (alu1_op_func_code),
	.endsim_i             (alu1_op_endsim),
	// alu result
	.alu_exe_valid_o      (alu1_exe_valid),
	.alu_sid_o            (alu1_exe_sid),
	.alu_exe_rd_o         (alu1_exe_rd),
	.alu_exe_rd_value_o   (alu1_exe_rd_value)
);

BEU u_BEU (
    .clk                    (clk),
    .rst_n                  (rst_n),
	// flush
	.flush_i                (wb_redirect),
    // from operands
    .branch_valid_i         (beu_op_valid),
    .branch_pc_i            (beu_op_pc),
    .branch_inst_i          (beu_op_inst), 
    .branch_sid_i           (beu_op_sid),
    .rs1_value_i            (beu_op_rs1_value),
    .rs2_value_i            (beu_op_rs2_value),
    .func_code_i            (beu_op_func_code),
    // beu result
    .branch_redirect_o      (beu_exe_redirect),
    .branch_redirect_pc_o   (beu_exe_redirect_pc),
    .branch_sid_o           (beu_exe_sid)
);

LSU u_LSU (
	.clk                         (clk),
	.rst_n                       (rst_n),
	.stall_lsu_i                 (lsu_exe_stall),
	.flush_lsu_i                 (wb_redirect),
	// from operands
	.lsu_valid_i                 (lsu_op_valid),
	.lsu_pc_i                    (lsu_op_pc),
	.lsu_inst_i                  (lsu_op_inst),
	.lsu_sid_i                   (lsu_op_sid),
	.lsu_func3_i                 (lsu_op_func3),
	.rs1_value_i                 (lsu_op_rs1_value),
	.rs2_value_i                 (lsu_op_rs2_value),
	.lsu_rd_i                    (lsu_op_rd),
	.rd_value_i                  (lsu_op_rd_value),
	// to uncache mem
	.uncache_mem_vld_o           (lsu_uncache_mem_vld),
	.uncache_mem_ready_i         (lsu_uncache_mem_ready),
	.uncache_mem_write_o         (lsu_uncache_mem_write),
	.uncache_mem_size_o          (lsu_uncache_mem_size),
	.uncache_mem_addr_o          (lsu_uncache_mem_addr),
	.uncache_mem_wdata_o         (lsu_uncache_mem_wdata),
	// from uncache mem
	.uncache_mem_resp_vld_i      (lsu_uncache_mem_resp_vld),
	.uncache_mem_resp_rdy_o      (lsu_uncache_mem_resp_rdy),
	.uncache_mem_resp_data_i     (lsu_uncache_mem_resp_data),
	// to wb
	.lsu_exe_valid_o             (lsu_exe_valid),
	.lsu_exe_rd_o                (lsu_exe_rd),
	.lsu_exe_rd_value_o          (lsu_exe_rd_value),
	.lsu_sid_o                   (lsu_exe_sid)
);

BIU u_DBIU (
    .clk                     (clk),
    .rst_n                   (rst_n),
    // cache req
    .cache_req_vld_i         (1'b0),
    .cache_req_rdy_o         (),
    .cache_req_rd_i          ('b0),
    .cache_req_addr_i        ('b0),
    .cache_req_wdata_i       ('b0),
    // cache resp
    .cache_resp_vld_o        (),
    .cache_resp_rdy_i        (1'b0),
    .cache_resp_rdata_o      (),
    .cache_resp_err_o        (),
    // uncache req
    .uncache_req_vld_i       (lsu_uncache_mem_vld),
    .uncache_req_rdy_o       (lsu_uncache_mem_ready),
    .uncache_req_rd_i        (lsu_uncache_mem_write),
    .uncache_req_addr_i      (lsu_uncache_mem_addr),
    .uncache_req_wdata_i     (lsu_uncache_mem_wdata),
    // uncache resp
    .uncache_resp_vld_o      (lsu_uncache_mem_resp_vld),
    .uncache_resp_rdy_i      (lsu_uncache_mem_resp_rdy),
    .uncache_resp_rdata_o    (lsu_uncache_mem_resp_data),
    .uncache_resp_err_o      (lsu_uncache_mem_resp_err),
    // axi3-lite
    .awvalid_o              (dbiu_axi_awvalid),
    .awready_i              (dbiu_axi_awready),
    .awaddr_o               (dbiu_axi_awaddr),
    .awprot_o               (dbiu_axi_awprot),
    .wvalid_o               (dbiu_axi_wvalid),
    .wready_i               (dbiu_axi_wready),
    .wdata_o                (dbiu_axi_wdata),
    .wstrb_o                (dbiu_axi_wstrb),
    .bvalid_i               (dbiu_axi_bvalid),
    .bready_o               (dbiu_axi_bready),
    .bresp_i                (dbiu_axi_bresp),
    .arvalid_o              (dbiu_axi_arvalid),
    .arready_i              (dbiu_axi_arready),
    .araddr_o               (dbiu_axi_araddr),
    .arprot_o               (dbiu_axi_arprot),
    .rvalid_i               (dbiu_axi_rvalid),
    .rready_o               (dbiu_axi_rready),
    .rdata_i                (dbiu_axi_rdata),
    .rresp_i                (dbiu_axi_rresp)
);

Exe_wb_sequencer u_Exe_wb_sequencer (
	// from execute
	.alu0_exe_valid_i          (alu0_exe_valid),
	.alu0_exe_stall_i          (alu0_exe_stall),
	.alu0_exe_rd_value_i       (alu0_exe_rd_value),
	.alu0_exe_rd_i             (alu0_exe_rd),
	.alu0_exe_sid_i            (alu0_exe_sid),
	.alu1_exe_valid_i          (alu1_exe_valid),
	.alu1_exe_stall_i          (alu1_exe_stall),
	.alu1_exe_rd_value_i       (alu1_exe_rd_value),
	.alu1_exe_rd_i             (alu1_exe_rd),
	.alu1_exe_sid_i            (alu1_exe_sid),
	.beu_exe_valid_i           (beu_exe_valid),
	.beu_exe_stall_i           (beu_exe_stall),
	.beu_exe_rd_value_i        (beu_exe_rd_value),
	.beu_exe_rd_i              (beu_exe_rd),
	.beu_exe_sid_i             (beu_exe_sid),
	.lsu_exe_valid_i           (lsu_exe_valid),
	.lsu_exe_stall_i           (lsu_exe_stall),
	.lsu_exe_rd_value_i        (lsu_exe_rd_value),
	.lsu_exe_rd_i              (lsu_exe_rd),
	.lsu_exe_sid_i             (lsu_exe_sid),
	// to wb
	.wb_inst0_valid_o          (exe_inst0_valid),
	.wb_inst0_data_o           (exe_inst0_rd_value),
	.wb_inst0_rd_o             (exe_inst0_rd),
	.wb_inst0_redirect_o       (exe_inst0_redirect),
	.wb_inst0_redirect_pc_o    (exe_inst0_redirect_pc),
	.wb_inst0_sid_o            (exe_inst0_sid),
	.wb_inst1_valid_o          (exe_inst1_valid),
	.wb_inst1_data_o           (exe_inst1_rd_value),
	.wb_inst1_rd_o             (exe_inst1_rd),
	.wb_inst1_redirect_o       (exe_inst1_redirect),
	.wb_inst1_redirect_pc_o    (exe_inst1_redirect_pc),
	.wb_inst1_sid_o            (exe_inst1_sid)
);

WriteBack u_WriteBack (
    .clk                        (clk),
    .rst_n                      (rst_n),
    // from execute
    .inst0_wb_valid_i          (exe_inst0_valid),
    .inst0_wb_rd_i             (exe_inst0_rd),
    .inst0_wb_value_i          (exe_inst0_rd_value), 
    .inst0_wb_pc_i             (exe_inst0_pc),
    .inst0_wb_redirect_i       (exe_inst0_redirect),
    .inst0_wb_redirect_pc_i    (exe_inst0_redirect_pc),
    .inst1_wb_valid_i          (exe_inst1_valid),
    .inst1_wb_rd_i             (exe_inst1_rd),
    .inst1_wb_value_i          (exe_inst1_rd_value),
    .inst1_wb_pc_i             (exe_inst1_pc),
    .inst1_wb_redirect_i       (exe_inst1_redirect),
    .inst1_wb_redirect_pc_i    (exe_inst1_redirect_pc),
    // to wb
    .inst0_wb_valid_o          (wb_inst0_valid),
    .inst0_wb_rd_o             (wb_inst0_rd),
    .inst0_wb_value_o          (wb_inst0_rd_value),
    .inst0_wb_pc_o             (wb_inst0_pc),
    .inst0_wb_sid_o            (wb_inst0_sid),
    .inst1_wb_valid_o          (wb_inst1_valid),
    .inst1_wb_rd_o             (wb_inst1_rd),
    .inst1_wb_value_o          (wb_inst1_rd_value),
    .inst1_wb_pc_o             (wb_inst1_pc),
    .inst1_wb_sid_o            (wb_inst1_sid),
    .wb_redirect_o             (wb_redirect),
    .wb_redirect_pc_o          (wb_redirect_pc)
);

Scoreboard u_Scoreboard (
    .clk                        (clk),
    .rst_n                      (rst_n),
    // from decoder
    .decoder_inst0_vld_i        (inst0_decoder_valid),
    .decoder_inst0_exe_unit_i   (inst0_decoder_exe_unit),
    .decoder_inst0_rd_i         (inst0_decoder_rd),
    .decoder_inst0_rs1_i        (inst0_decoder_rs1),
    .decoder_inst0_rs2_i        (inst0_decoder_rs2),
    .decoder_inst1_vld_i        (inst1_decoder_valid),
    .decoder_inst1_exe_unit_i   (inst1_decoder_exe_unit),
    .decoder_inst1_rd_i         (inst1_decoder_rd),
    .decoder_inst1_rs1_i        (inst1_decoder_rs1),
    .decoder_inst1_rs2_i        (inst1_decoder_rs2),
    // to decoder
    .stall_decoder_inst0_o      (stall_decoder_inst0),
    .stall_decoder_inst1_o      (stall_decoder_inst1),
    .decoder_inst0_sid_o        (inst0_decoder_sid),
    .decoder_inst1_sid_o        (inst1_decoder_sid),
    .decoder_inst0_h_exe_unit_o (inst0_decoder_h_exe_unit),
    .decoder_inst1_h_exe_unit_o (inst1_decoder_h_exe_unit),
    // from operands
    .op_inst0_vld_i            (inst0_operands_valid),
    .op_inst0_sid_i            (inst0_operands_sid),
    .op_inst0_rd_i             (inst0_operands_rd),
    .op_inst0_rs1_i            (inst0_operands_rs1),
    .op_inst0_rs2_i            (inst0_operands_rs2),
    .op_inst1_vld_i            (inst1_operands_valid),
    .op_inst1_sid_i            (inst1_operands_sid),
    .op_inst1_rd_i             (inst1_operands_rd),
    .op_inst1_rs1_i            (inst1_operands_rs1),
    .op_inst1_rs2_i            (inst1_operands_rs2),
    // to operands
    .op_stall_inst0_o          (op_stall_inst0),
    .op_stall_inst1_o          (op_stall_inst1),
    // from execute
    .alu0_exe_vld_i            (alu0_exe_valid),
    .alu1_exe_vld_i            (alu1_exe_valid),
    .beu_exe_vld_i             (beu_exe_valid),
    .lsu_exe_vld_i             (lsu_exe_valid),
    // to execute
    .alu0_exe_stall_o          (alu0_exe_stall),
    .alu1_exe_stall_o          (alu1_exe_stall),
    .beu_exe_stall_o           (beu_exe_stall),
    .lsu_exe_stall_o           (lsu_exe_stall),
    // from write back
    .wb_inst0_vld_i            (wb_inst0_valid),
    .wb_inst0_sid_i            (wb_inst0_sid),
    .wb_inst0_rd_i             (wb_inst0_rd),
    .wb_inst1_vld_i            (wb_inst1_valid),
    .wb_inst1_sid_i            (wb_inst1_sid),
    .wb_inst1_rd_i             (wb_inst1_rd),
    // to write back
    .wb_stall_inst0_o          (wb_stall_inst0),
    .wb_stall_inst1_o          (wb_stall_inst1)
);

endmodule
