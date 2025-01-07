module Scoreboard(
    input        clk,
    input        rst_n,
    // from decoder
    input  [0:0] decoder_inst0_vld_i,
    input  [5:0] decoder_inst0_exe_unit_i,
    input  [4:0] decoder_inst0_rd_i,
    input  [4:0] decoder_inst0_rs1_i,
    input  [4:0] decoder_inst0_rs2_i,
    input  [0:0] decoder_inst1_vld_i,
    input  [5:0] decoder_inst1_exe_unit_i,
    input  [4:0] decoder_inst1_rd_i,
    input  [4:0] decoder_inst1_rs1_i,
    input  [4:0] decoder_inst1_rs2_i,
    // to decoder
    output [0:0] stall_decoder_inst0_o,
    output [0:0] stall_decoder_inst1_o,
    output [`SCOREBOARD_SIZE_WIDTH:0] decoder_inst0_sid_o,
    output [`H_EXE_UNIT_WIDTH-1:0]    decoder_inst0_h_exe_unit_o,
    output [`SCOREBOARD_SIZE_WIDTH:0] decoder_inst1_sid_o,
    output [`H_EXE_UNIT_WIDTH-1:0]    decoder_inst1_h_exe_unit_o,
    // from operands
    input  [0:0]                      op_inst0_vld_i,
    input  [`SCOREBOARD_SIZE_WIDTH:0] op_inst0_sid_i,
    input  [4:0]                      op_inst0_rd_i,
    input  [4:0]                      op_inst0_rs1_i,
    input  [4:0]                      op_inst0_rs2_i,
    input  [0:0]                      op_inst1_vld_i,
    input  [`SCOREBOARD_SIZE_WIDTH:0] op_inst1_sid_i,
    input  [4:0]                      op_inst1_rd_i,
    input  [4:0]                      op_inst1_rs1_i,
    input  [4:0]                      op_inst1_rs2_i,
    // to operands
    output [0:0]                      op_stall_inst0_o,
    output [0:0]                      op_stall_inst1_o,
    // from execute
    input  [0:0]                      alu0_exe_vld_i,
    input  [0:0]                      alu1_exe_vld_i,
    input  [0:0]                      beu_exe_vld_i,
    input  [0:0]                      lsu_exe_vld_i,
    // to execute
    output [0:0]                      alu0_exe_stall_o,
    output [0:0]                      alu1_exe_stall_o,
    output [0:0]                      beu_exe_stall_o,
    output [0:0]                      lsu_exe_stall_o,
    // from write back
    input  [0:0]                      wb_inst0_vld_i,
    input  [`SCOREBOARD_SIZE_WIDTH:0] wb_inst0_sid_i,
    input  [4:0]                      wb_inst0_rd_i,
    input  [0:0]                      wb_inst1_vld_i,
    input  [`SCOREBOARD_SIZE_WIDTH:0] wb_inst1_sid_i,
    input  [4:0]                      wb_inst1_rd_i,
    // to write back
    output [0:0]                      wb_stall_inst0_o,
    output [0:0]                      wb_stall_inst1_o
);

    reg                              scb_alu0_busy_r;
    reg [4:0]                        scb_alu0_rd_r;
    reg [4:0]                        scb_alu0_rs1_r;
    reg [4:0]                        scb_alu0_rs2_r;
    reg [`SCOREBOARD_SIZE_WIDTH:0]   scb_alu0_sid_r;
    reg                              scb_alu1_busy_r;
    reg [4:0]                        scb_alu1_rd_r;
    reg [4:0]                        scb_alu1_rs1_r;
    reg [4:0]                        scb_alu1_rs2_r;
    reg [`SCOREBOARD_SIZE_WIDTH:0]   scb_alu1_sid_r;
    reg                              scb_beu_busy_r;
    reg [4:0]                        scb_beu_rd_r;
    reg [4:0]                        scb_beu_rs1_r;
    reg [4:0]                        scb_beu_rs2_r;
    reg [`SCOREBOARD_SIZE_WIDTH:0]   scb_beu_sid_r;
    reg                              scb_lsu_busy_r;
    reg [4:0]                        scb_lsu_rd_r;
    reg [4:0]                        scb_lsu_rs1_r;
    reg [4:0]                        scb_lsu_rs2_r;
    reg [`SCOREBOARD_SIZE_WIDTH:0]   scb_lsu_sid_r;

    reg [`SCOREBOARD_SIZE_WIDTH:0]  cur_sid_r;
    wire [`SCOREBOARD_SIZE_WIDTH:0] cur_sid_add1;
    wire [`SCOREBOARD_SIZE_WIDTH:0] inst0_sid;
    wire [`SCOREBOARD_SIZE_WIDTH:0] inst1_sid;

    wire inst0_sel_alu0;
    wire inst0_sel_alu1;
    wire inst0_sel_beu;
    wire inst0_sel_lsu;
    wire inst0_waw;
    wire inst0_wr_alu0;
    wire inst0_wr_alu1;
    wire inst0_wr_beu;
    wire inst0_wr_lsu;
    wire inst1_sel_alu0;
    wire inst1_sel_alu1;
    wire inst1_sel_beu;
    wire inst1_sel_lsu;
    wire inst1_waw;
    wire inst1_wr_alu0;
    wire inst1_wr_alu1;
    wire inst1_wr_beu;
    wire inst1_wr_lsu;
    wire inst0_wr_scb;
    wire inst1_wr_scb;

    // ----------------- decoder -----------------

    assign inst0_sel_alu0 = decoder_inst0_vld_i && decoder_inst0_exe_unit_i[`RV_ALU];
    assign inst0_sel_alu1 = decoder_inst0_vld_i && decoder_inst0_exe_unit_i[`RV_ALU];
    assign inst0_sel_beu  = decoder_inst0_vld_i && decoder_inst0_exe_unit_i[`RV_BEU];
    assign inst0_sel_lsu  = decoder_inst0_vld_i && decoder_inst0_exe_unit_i[`RV_LSU];

    assign inst0_waw = (scb_alu0_busy_r && scb_alu0_rd_r == decoder_inst0_rd_i) ||
                       (scb_alu1_busy_r && scb_alu1_rd_r == decoder_inst0_rd_i) ||
                       (scb_beu_busy_r  && scb_beu_rd_r  == decoder_inst0_rd_i) ||
                       (scb_lsu_busy_r  && scb_lsu_rd_r  == decoder_inst0_rd_i);

    assign inst0_wr_alu0 = inst0_sel_alu0 && !scb_alu0_busy_r && !inst0_waw;
    assign inst0_wr_alu1 = inst0_sel_alu1 && (scb_alu0_busy_r && !scb_alu1_busy_r) && !inst0_waw;
    assign inst0_wr_beu  = inst0_sel_beu  && !scb_beu_busy_r  && !inst0_waw;
    assign inst0_wr_lsu  = inst0_sel_lsu  && !scb_lsu_busy_r  && !inst0_waw;

    assign inst1_sel_alu0 = decoder_inst1_vld_i && decoder_inst1_exe_unit_i == `RV_ALU;
    assign inst1_sel_alu1 = decoder_inst1_vld_i && decoder_inst1_exe_unit_i == `RV_ALU;
    assign inst1_sel_beu  = decoder_inst1_vld_i && decoder_inst1_exe_unit_i == `RV_BEU;
    assign inst1_sel_lsu  = decoder_inst1_vld_i && decoder_inst1_exe_unit_i == `RV_LSU;

    assign inst1_waw = (scb_alu0_busy_r && scb_alu0_rd_r == decoder_inst1_rd_i) ||
                       (scb_alu1_busy_r && scb_alu1_rd_r == decoder_inst1_rd_i) ||
                       (scb_beu_busy_r  && scb_beu_rd_r  == decoder_inst1_rd_i) ||
                       (scb_lsu_busy_r  && scb_lsu_rd_r  == decoder_inst1_rd_i);

    assign inst1_wr_alu0 = inst1_sel_alu0 && !scb_alu0_busy_r && !inst1_waw && !inst0_wr_alu0;
    assign inst1_wr_alu1 = inst1_sel_alu1 && (scb_alu0_busy_r && !scb_alu1_busy_r) && !inst1_waw && !inst0_wr_alu1;
    assign inst1_wr_beu  = inst1_sel_beu  && !scb_beu_busy_r  && !inst1_waw && !inst0_wr_beu;
    assign inst1_wr_lsu  = inst1_sel_lsu  && !scb_lsu_busy_r  && !inst1_waw && !inst0_wr_lsu;

    assign cur_sid_add1 = cur_sid_r + 1;
    assign inst0_sid = cur_sid_r;
    assign inst1_sid = cur_sid_add1;

    assign inst0_wr_scb = inst0_wr_alu0 || inst0_wr_alu1 || inst0_wr_beu || inst0_wr_lsu;
    assign inst1_wr_scb = inst1_wr_alu0 || inst1_wr_alu1 || inst1_wr_beu || inst1_wr_lsu;

    assign stall_decoder_inst0_o = inst0_wr_scb || op_stall_inst0_o;
    assign stall_decoder_inst1_o = inst1_wr_scb || op_stall_inst1_o || stall_decoder_inst0_o;

    assign decoder_inst0_sid_o = inst0_sid;
    assign decoder_inst1_sid_o = inst1_sid;

    assign decoder_inst0_h_exe_unit_o = inst0_wr_lsu<<3 | inst0_wr_beu<<2 | inst0_wr_alu1<<1 | inst0_wr_alu0<<0;
    assign decoder_inst1_h_exe_unit_o = inst1_wr_lsu<<3 | inst1_wr_beu<<2 | inst1_wr_alu1<<1 | inst1_wr_alu0<<0;

    // sid
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            cur_sid_r <= 0;
        end
        else if(inst1_wr_alu0 || inst1_wr_alu1 || inst1_wr_beu || inst1_wr_lsu) begin
            cur_sid_r <= cur_sid_r + 2;
        end
    end

    // ----------------- operands -----------------

    wire op_inst0_raw_alu0;
    wire op_inst0_newer_alu0;
    wire op_inst0_raw_alu1;
    wire op_inst0_newer_alu1;
    wire op_inst0_raw_beu;
    wire op_inst0_newer_beu;
    wire op_inst0_raw_lsu;
    wire op_inst0_newer_lsu;
    wire op_inst1_raw_alu0;
    wire op_inst1_newer_alu0;
    wire op_inst1_raw_alu1;
    wire op_inst1_newer_alu1;
    wire op_inst1_raw_beu;
    wire op_inst1_newer_beu;
    wire op_inst1_raw_lsu;
    wire op_inst1_newer_lsu;

    wire op_inst0_newer_inst1;
    wire op_inst1_newer_inst0;
    wire op_inst0_raw_inst1;
    wire op_inst1_raw_inst0;

    wire op_inst0_raw;
    wire op_inst1_raw;

    assign op_inst0_newer_alu0 = op_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH] == scb_alu0_sid_r[`SCOREBOARD_SIZE_WIDTH] ? 
                                    op_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] > scb_alu0_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0] : 
                                    op_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] < scb_alu0_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0];
    assign op_inst0_newer_alu1 = op_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH] == scb_alu1_sid_r[`SCOREBOARD_SIZE_WIDTH] ? 
                                    op_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] > scb_alu1_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0] : 
                                    op_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] < scb_alu1_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0];
    assign op_inst0_newer_beu = op_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH] == scb_beu_sid_r[`SCOREBOARD_SIZE_WIDTH] ? 
                                    op_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] > scb_beu_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0] : 
                                    op_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] < scb_beu_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0];
    assign op_inst0_newer_lsu = op_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH] == scb_lsu_sid_r[`SCOREBOARD_SIZE_WIDTH] ? 
                                    op_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] > scb_lsu_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0] : 
                                    op_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] < scb_lsu_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0];

    assign op_inst1_newer_alu0 = op_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH] == scb_alu0_sid_r[`SCOREBOARD_SIZE_WIDTH] ? 
                                    op_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] > scb_alu0_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0] : 
                                    op_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] < scb_alu0_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0];
    assign op_inst1_newer_alu1 = op_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH] == scb_alu1_sid_r[`SCOREBOARD_SIZE_WIDTH] ? 
                                    op_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] > scb_alu1_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0] : 
                                    op_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] < scb_alu1_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0];
    assign op_inst1_newer_beu = op_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH] == scb_beu_sid_r[`SCOREBOARD_SIZE_WIDTH] ? 
                                    op_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] > scb_beu_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0] : 
                                    op_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] < scb_beu_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0];
    assign op_inst1_newer_lsu = op_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH] == scb_lsu_sid_r[`SCOREBOARD_SIZE_WIDTH] ? 
                                    op_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] > scb_lsu_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0] : 
                                    op_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] < scb_lsu_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0];

    assign op_inst0_raw_alu0 = op_inst0_vld_i && scb_alu0_busy_r && (scb_alu0_rd_r == op_inst0_rs1_i || scb_alu0_rd_r == op_inst0_rs2_i) && op_inst0_newer_alu0;
    assign op_inst0_raw_alu1 = op_inst0_vld_i && scb_alu1_busy_r && (scb_alu1_rd_r == op_inst0_rs1_i || scb_alu1_rd_r == op_inst0_rs2_i) && op_inst0_newer_alu1;
    assign op_inst0_raw_beu = op_inst0_vld_i && scb_beu_busy_r && (scb_beu_rd_r == op_inst0_rs1_i || scb_beu_rd_r == op_inst0_rs2_i) && op_inst0_newer_beu;
    assign op_inst0_raw_lsu = op_inst0_vld_i && scb_lsu_busy_r && (scb_lsu_rd_r == op_inst0_rs1_i || scb_lsu_rd_r == op_inst0_rs2_i) && op_inst0_newer_lsu;

    assign op_inst1_raw_alu0 = op_inst1_vld_i && scb_alu0_busy_r && (scb_alu0_rd_r == op_inst1_rs1_i || scb_alu0_rd_r == op_inst1_rs2_i) && op_inst1_newer_alu0;
    assign op_inst1_raw_alu1 = op_inst1_vld_i && scb_alu1_busy_r && (scb_alu1_rd_r == op_inst1_rs1_i || scb_alu1_rd_r == op_inst1_rs2_i) && op_inst1_newer_alu1;
    assign op_inst1_raw_beu = op_inst1_vld_i && scb_beu_busy_r && (scb_beu_rd_r == op_inst1_rs1_i || scb_beu_rd_r == op_inst1_rs2_i) && op_inst1_newer_beu;
    assign op_inst1_raw_lsu = op_inst1_vld_i && scb_lsu_busy_r && (scb_lsu_rd_r == op_inst1_rs1_i || scb_lsu_rd_r == op_inst1_rs2_i) && op_inst1_newer_lsu;

    assign op_inst0_newer_inst1 = op_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH] == op_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH] ? 
                                    op_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] > op_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] : 
                                    op_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] < op_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0];
    assign op_inst1_newer_inst0 = op_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH] == op_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH] ? 
                                    op_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] > op_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] : 
                                    op_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] < op_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0];

    assign op_inst0_raw_inst1 = op_inst0_vld_i && op_inst1_vld_i && (op_inst1_rd_i == op_inst0_rs1_i || op_inst1_rd_i == op_inst0_rs2_i) && op_inst0_newer_inst1;
    assign op_inst1_raw_inst0 = op_inst1_vld_i && op_inst0_vld_i && (op_inst0_rd_i == op_inst1_rs1_i || op_inst0_rd_i == op_inst1_rs2_i) && op_inst1_newer_inst0;

    assign op_inst0_raw = op_inst0_raw_alu0 || op_inst0_raw_alu1 || op_inst0_raw_beu || op_inst0_raw_lsu || op_inst0_raw_inst1;
    assign op_inst1_raw = op_inst1_raw_alu0 || op_inst1_raw_alu1 || op_inst1_raw_beu || op_inst1_raw_lsu || op_inst1_raw_inst0;

    assign op_stall_inst0_o = op_inst0_raw;
    assign op_stall_inst1_o = op_inst1_raw;

    // ----------------- execute -----------------

    // ----------------- write back -----------------

    wire wb_inst0_newer_alu0;
    wire wb_inst0_newer_alu1;
    wire wb_inst0_newer_beu;
    wire wb_inst0_newer_lsu;
    wire wb_inst1_newer_alu0;
    wire wb_inst1_newer_alu1;
    wire wb_inst1_newer_beu;
    wire wb_inst1_newer_lsu;

    wire wb_inst0_war_alu0;
    wire wb_inst0_war_alu1;
    wire wb_inst0_war_beu;
    wire wb_inst0_war_lsu;
    wire wb_inst1_war_alu0;
    wire wb_inst1_war_alu1;
    wire wb_inst1_war_beu;
    wire wb_inst1_war_lsu;

    wire wb_inst0_newer_inst1;
    wire wb_inst1_newer_inst0;

    wire wb_inst0_war;
    wire wb_inst1_war;

    assign wb_inst0_newer_alu0 = wb_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH] == scb_alu0_sid_r[`SCOREBOARD_SIZE_WIDTH] ? 
                                    wb_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] > scb_alu0_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0] : 
                                    wb_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] < scb_alu0_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0];
    assign wb_inst0_newer_alu1 = wb_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH] == scb_alu1_sid_r[`SCOREBOARD_SIZE_WIDTH] ? 
                                    wb_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] > scb_alu1_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0] : 
                                    wb_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] < scb_alu1_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0];
    assign wb_inst0_newer_beu = wb_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH] == scb_beu_sid_r[`SCOREBOARD_SIZE_WIDTH] ? 
                                    wb_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] > scb_beu_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0] : 
                                    wb_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] < scb_beu_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0];
    assign wb_inst0_newer_lsu = wb_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH] == scb_lsu_sid_r[`SCOREBOARD_SIZE_WIDTH] ? 
                                    wb_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] > scb_lsu_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0] : 
                                    wb_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] < scb_lsu_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0];

    assign wb_inst1_newer_alu0 = wb_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH] == scb_alu0_sid_r[`SCOREBOARD_SIZE_WIDTH] ? 
                                    wb_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] > scb_alu0_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0] : 
                                    wb_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] < scb_alu0_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0];
    assign wb_inst1_newer_alu1 = wb_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH] == scb_alu1_sid_r[`SCOREBOARD_SIZE_WIDTH] ? 
                                    wb_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] > scb_alu1_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0] : 
                                    wb_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] < scb_alu1_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0];
    assign wb_inst1_newer_beu = wb_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH] == scb_beu_sid_r[`SCOREBOARD_SIZE_WIDTH] ? 
                                    wb_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] > scb_beu_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0] : 
                                    wb_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] < scb_beu_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0];
    assign wb_inst1_newer_lsu = wb_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH] == scb_lsu_sid_r[`SCOREBOARD_SIZE_WIDTH] ? 
                                    wb_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] > scb_lsu_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0] : 
                                    wb_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] < scb_lsu_sid_r[`SCOREBOARD_SIZE_WIDTH-1:0];

    assign wb_inst0_war_alu0 = wb_inst0_vld_i && scb_alu0_busy_r && (scb_alu0_rs1_r == wb_inst0_rd_i || scb_alu0_rs2_r == wb_inst0_rd_i) && wb_inst0_newer_alu0;
    assign wb_inst0_war_alu1 = wb_inst0_vld_i && scb_alu1_busy_r && (scb_alu1_rs1_r == wb_inst0_rd_i || scb_alu1_rs2_r == wb_inst0_rd_i) && wb_inst0_newer_alu1;
    assign wb_inst0_war_beu  = wb_inst0_vld_i && scb_beu_busy_r  && (scb_beu_rs1_r == wb_inst0_rd_i  || scb_beu_rs2_r  == wb_inst0_rd_i) && wb_inst0_newer_beu;
    assign wb_inst0_war_lsu  = wb_inst0_vld_i && scb_lsu_busy_r  && (scb_lsu_rs1_r == wb_inst0_rd_i  || scb_lsu_rs2_r  == wb_inst0_rd_i) && wb_inst0_newer_lsu;

    assign wb_inst1_war_alu0 = wb_inst1_vld_i && scb_alu0_busy_r && (scb_alu0_rs1_r == wb_inst1_rd_i || scb_alu0_rs2_r == wb_inst1_rd_i) && wb_inst1_newer_alu0;
    assign wb_inst1_war_alu1 = wb_inst1_vld_i && scb_alu1_busy_r && (scb_alu1_rs1_r == wb_inst1_rd_i || scb_alu1_rs2_r == wb_inst1_rd_i) && wb_inst1_newer_alu1;
    assign wb_inst1_war_beu  = wb_inst1_vld_i && scb_beu_busy_r  && (scb_beu_rs1_r == wb_inst1_rd_i  || scb_beu_rs2_r  == wb_inst1_rd_i) && wb_inst1_newer_beu;
    assign wb_inst1_war_lsu  = wb_inst1_vld_i && scb_lsu_busy_r  && (scb_lsu_rs1_r == wb_inst1_rd_i  || scb_lsu_rs2_r  == wb_inst1_rd_i) && wb_inst1_newer_lsu;

    assign wb_inst0_newer_inst1 = wb_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH] == wb_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH] ? 
                                    wb_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] > wb_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] : 
                                    wb_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] < wb_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0];
    assign wb_inst1_newer_inst0 = wb_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH] == wb_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH] ? 
                                    wb_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] > wb_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] : 
                                    wb_inst1_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0] < wb_inst0_sid_i[`SCOREBOARD_SIZE_WIDTH-1:0];

    assign wb_inst0_war = wb_inst0_vld_i && wb_inst1_vld_i && (wb_inst1_rd_i == wb_inst0_rd_i) && wb_inst0_newer_inst1;
    assign wb_inst1_war = wb_inst1_vld_i && wb_inst0_vld_i && (wb_inst0_rd_i == wb_inst1_rd_i) && wb_inst1_newer_inst0;

    assign wb_stall_inst0_o = wb_inst0_war;
    assign wb_stall_inst1_o = wb_inst1_war;

    // ----------------- scoreboard -----------------

    // write alu0
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            scb_alu0_busy_r <= 0;
        end
        else if(inst0_wr_alu0) begin
            scb_alu0_busy_r <= 1;
            scb_alu0_rd_r <= decoder_inst0_rd_i;
            scb_alu0_rs1_r <= decoder_inst0_rs1_i;
            scb_alu0_rs2_r <= decoder_inst0_rs2_i;
            scb_alu0_sid_r <= inst0_sid;
        end
        else if(inst1_wr_alu0) begin
            scb_alu0_busy_r <= 1;
            scb_alu0_rd_r <= decoder_inst1_rd_i;
            scb_alu0_rs1_r <= decoder_inst1_rs1_i;
            scb_alu0_rs2_r <= decoder_inst1_rs2_i;
            scb_alu0_sid_r <= inst1_sid;
        end
        else if(wb_inst0_vld_i && wb_inst0_sid_i == scb_alu0_sid_r && !wb_stall_inst0_o) begin
            scb_alu0_busy_r <= 0;
        end
        else if(wb_inst1_vld_i && wb_inst1_sid_i == scb_alu0_sid_r && !wb_stall_inst1_o) begin
            scb_alu0_busy_r <= 0;
        end
    end

    // write alu1
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            scb_alu1_busy_r <= 0;
        end
        else if(inst0_wr_alu1) begin
            scb_alu1_busy_r <= 1;
            scb_alu1_rd_r <= decoder_inst0_rd_i;
            scb_alu1_rs1_r <= decoder_inst0_rs1_i;
            scb_alu1_rs2_r <= decoder_inst0_rs2_i;
            scb_alu1_sid_r <= inst0_sid;
        end
        else if(inst1_wr_alu1) begin
            scb_alu1_busy_r <= 1;
            scb_alu1_rd_r <= decoder_inst1_rd_i;
            scb_alu1_rs1_r <= decoder_inst1_rs1_i;
            scb_alu1_rs2_r <= decoder_inst1_rs2_i;
            scb_alu1_sid_r <= inst1_sid;
        end
        else if(wb_inst0_vld_i && wb_inst0_sid_i == scb_alu1_sid_r && !wb_stall_inst0_o) begin
            scb_alu1_busy_r <= 0;
        end
        else if(wb_inst1_vld_i && wb_inst1_sid_i == scb_alu1_sid_r && !wb_stall_inst1_o) begin
            scb_alu1_busy_r <= 0;
        end
    end

    // write beu
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            scb_beu_busy_r <= 0;
        end
        else if(inst0_wr_beu) begin
            scb_beu_busy_r <= 1;
            scb_beu_rd_r <= decoder_inst0_rd_i;
            scb_beu_rs1_r <= decoder_inst0_rs1_i;
            scb_beu_rs2_r <= decoder_inst0_rs2_i;
            scb_beu_sid_r <= inst0_sid;
        end
        else if(inst1_wr_beu) begin
            scb_beu_busy_r <= 1;
            scb_beu_rd_r <= decoder_inst1_rd_i;
            scb_beu_rs1_r <= decoder_inst1_rs1_i;
            scb_beu_rs2_r <= decoder_inst1_rs2_i;
            scb_beu_sid_r <= inst1_sid;
        end
        else if(wb_inst0_vld_i && wb_inst0_sid_i == scb_beu_sid_r && !wb_stall_inst0_o) begin
            scb_beu_busy_r <= 0;
        end
        else if(wb_inst1_vld_i && wb_inst1_sid_i == scb_beu_sid_r && !wb_stall_inst1_o) begin
            scb_beu_busy_r <= 0;
        end
    end

    // write lsu
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            scb_lsu_busy_r <= 0;
        end
        else if(inst0_wr_lsu) begin
            scb_lsu_busy_r <= 1;
            scb_lsu_rd_r <= decoder_inst0_rd_i;
            scb_lsu_rs1_r <= decoder_inst0_rs1_i;
            scb_lsu_rs2_r <= decoder_inst0_rs2_i;
            scb_lsu_sid_r <= inst0_sid;
        end
        else if(inst1_wr_lsu) begin
            scb_lsu_busy_r <= 1;
            scb_lsu_rd_r <= decoder_inst1_rd_i;
            scb_lsu_rs1_r <= decoder_inst1_rs1_i;
            scb_lsu_rs2_r <= decoder_inst1_rs2_i;
            scb_lsu_sid_r <= inst1_sid;
        end
        else if(wb_inst0_vld_i && wb_inst0_sid_i == scb_lsu_sid_r && !wb_stall_inst0_o) begin
            scb_lsu_busy_r <= 0;
        end
        else if(wb_inst1_vld_i && wb_inst1_sid_i == scb_lsu_sid_r && !wb_stall_inst1_o) begin
            scb_lsu_busy_r <= 0;
        end
    end

endmodule
