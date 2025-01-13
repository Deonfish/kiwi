module WriteBack (
	input clk,
	input rst_n,

    input        inst0_wb_valid_i,
    input [4:0]  inst0_wb_rd_i,
    input [63:0] inst0_wb_value_i,
    input [63:0] inst0_wb_pc_i,
    input [31:0] inst0_wb_inst_i,
    input        inst0_wb_redirect_i,
    input [63:0] inst0_wb_redirect_pc_i,
    input [`SCOREBOARD_SIZE_WIDTH-1:0] inst0_wb_sid_i,
    input        inst1_wb_valid_i,
    input [4:0]  inst1_wb_rd_i,
    input [63:0] inst1_wb_value_i,
    input [63:0] inst1_wb_pc_i,
    input [31:0] inst1_wb_inst_i,
    input        inst1_wb_redirect_i,
    input [63:0] inst1_wb_redirect_pc_i,
    input [`SCOREBOARD_SIZE_WIDTH-1:0] inst1_wb_sid_i,
    
    output        inst0_wb_valid_o,
    output [4:0]  inst0_wb_rd_o,
    output [63:0] inst0_wb_value_o,
    output [63:0] inst0_wb_pc_o,
    output [31:0] inst0_wb_inst_o,
    output [`SCOREBOARD_SIZE_WIDTH-1:0] inst0_wb_sid_o,
    output        inst1_wb_valid_o,
    output [4:0]  inst1_wb_rd_o,
    output [63:0] inst1_wb_value_o,
    output [63:0] inst1_wb_pc_o,
    output [31:0] inst1_wb_inst_o,
    output [`SCOREBOARD_SIZE_WIDTH-1:0] inst1_wb_sid_o,
    output        wb_redirect_o,
    output [63:0] wb_redirect_pc_o
);

reg inst0_wb_valid_r;
reg [4:0] inst0_wb_rd_r;
reg [63:0] inst0_wb_value_r;
reg [63:0] inst0_wb_pc_r;
reg [31:0] inst0_wb_inst_r;
reg [`SCOREBOARD_SIZE_WIDTH-1:0] inst0_wb_sid_r;
reg inst1_wb_valid_r;
reg [4:0] inst1_wb_rd_r;
reg [63:0] inst1_wb_value_r;
reg [63:0] inst1_wb_pc_r;
reg [31:0] inst1_wb_inst_r;
reg [`SCOREBOARD_SIZE_WIDTH-1:0] inst1_wb_sid_r;
reg wb_redirect_r;
reg [63:0] wb_redirect_pc_r;
wire wb_redirect;
wire [63:0] wb_redirect_pc;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        inst0_wb_valid_r <= 0;
        inst1_wb_valid_r <= 0;
        wb_redirect_r <= 0;
        wb_redirect_pc_r <= 0;
    end
    else begin
        inst0_wb_valid_r <= inst0_wb_valid_i;
        inst0_wb_rd_r    <= inst0_wb_rd_i;
        inst0_wb_value_r <= inst0_wb_value_i;
        inst0_wb_pc_r    <= inst0_wb_pc_i;
        inst0_wb_inst_r  <= inst0_wb_inst_i;
        inst0_wb_sid_r   <= inst0_wb_sid_i;
        inst1_wb_valid_r <= inst1_wb_valid_i;
        inst1_wb_rd_r    <= inst1_wb_rd_i;
        inst1_wb_value_r <= inst1_wb_value_i;
        inst1_wb_pc_r    <= inst1_wb_pc_i;
        inst1_wb_inst_r  <= inst1_wb_inst_i;
        inst1_wb_sid_r   <= inst1_wb_sid_i;
        wb_redirect_r    <= wb_redirect;
        wb_redirect_pc_r <= wb_redirect_pc;
    end
end

assign wb_redirect = inst0_wb_redirect_i || inst1_wb_redirect_i;
assign wb_redirect_pc = inst0_wb_redirect_i ? inst0_wb_redirect_pc_i : inst1_wb_redirect_pc_i;

endmodule