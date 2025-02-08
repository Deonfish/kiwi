module WriteBack (
	input                                  clk,
	input                                  rst_n,

	input                                  inst0_wb_valid_i,
	input  [4:0]                           inst0_wb_rd_i,
	input  [63:0]                          inst0_wb_value_i,
	input                                  inst0_wb_redirect_i,
	input  [63:0]                          inst0_wb_redirect_pc_i,
	input  [`SCOREBOARD_SIZE_WIDTH:0]      inst0_wb_sid_i,
	input                                  inst1_wb_valid_i,
	input  [4:0]                           inst1_wb_rd_i,
	input  [63:0]                          inst1_wb_value_i,
	input                                  inst1_wb_redirect_i,
	input  [63:0]                          inst1_wb_redirect_pc_i,
	input  [`SCOREBOARD_SIZE_WIDTH:0]      inst1_wb_sid_i,

	input                                  stall_inst0_wb_i,
	input                                  stall_inst1_wb_i,
	input                                  flush_inst0_wb_i,
	input                                  flush_inst1_wb_i,

	output                                 inst0_wb_valid_o,
	output [4:0]                           inst0_wb_rd_o,
	output [63:0]                          inst0_wb_value_o,
	output [`SCOREBOARD_SIZE_WIDTH:0]      inst0_wb_sid_o,
	output                                 inst1_wb_valid_o,
	output [4:0]                           inst1_wb_rd_o,
	output [63:0]                          inst1_wb_value_o,
	output [31:0]                          inst1_wb_sid_o,
	output                                 wb_redirect_o,
	output [63:0]                          wb_redirect_pc_o,
	output [`SCOREBOARD_SIZE_WIDTH:0]      wb_redirect_sid_o
);

reg inst0_wb_valid_r;
reg [4:0] inst0_wb_rd_r;
reg [63:0] inst0_wb_value_r;
reg [31:0] inst0_wb_inst_r;
reg [`SCOREBOARD_SIZE_WIDTH:0] inst0_wb_sid_r;
reg inst1_wb_valid_r;
reg [4:0] inst1_wb_rd_r;
reg [63:0] inst1_wb_value_r;
reg [31:0] inst1_wb_inst_r;
reg [`SCOREBOARD_SIZE_WIDTH:0] inst1_wb_sid_r;
reg inst0_wb_redirect_r;
reg [63:0] inst0_wb_redirect_pc_r;
reg inst1_wb_redirect_r;
reg [63:0] inst1_wb_redirect_pc_r;
wire wb_redirect;
wire [63:0] wb_redirect_pc;
reg [`SCOREBOARD_SIZE_WIDTH:0] wb_redirect_sid;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        inst0_wb_valid_r <= 1'b0;
        inst0_wb_redirect_r <= 1'b0;
    end
    else if(flush_inst0_wb_i) begin
        inst0_wb_valid_r <= 1'b0;
    end
    else if(inst0_wb_valid_i || inst1_wb_valid_i) begin
        inst0_wb_valid_r <= 1'b1;
        inst0_wb_rd_r    <= inst0_wb_rd_i;
        inst0_wb_value_r <= inst0_wb_value_i;
        inst0_wb_sid_r   <= inst0_wb_sid_i;
        inst0_wb_redirect_r <= inst0_wb_redirect_i;
        inst0_wb_redirect_pc_r <= inst0_wb_redirect_pc_i;
    end
    else if(!stall_inst0_wb_i) begin
        inst0_wb_valid_r <= 1'b0;
        inst0_wb_redirect_r <= 1'b0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        inst1_wb_valid_r <= 1'b0;
        inst1_wb_redirect_r <= 1'b0;
    end
    else if(flush_inst1_wb_i) begin
        inst1_wb_valid_r <= 1'b0;
    end
    else if(inst1_wb_valid_i) begin
        inst1_wb_valid_r <= 1'b1;
        inst1_wb_rd_r    <= inst1_wb_rd_i;
        inst1_wb_value_r <= inst1_wb_value_i;
        inst1_wb_sid_r   <= inst1_wb_sid_i;
        inst1_wb_redirect_r <= inst1_wb_redirect_i;
        inst1_wb_redirect_pc_r <= inst1_wb_redirect_pc_i;
    end
    else if(!stall_inst1_wb_i) begin
        inst1_wb_valid_r <= 1'b0;
        inst1_wb_redirect_r <= 1'b0;
    end
end

assign inst0_wb_valid_o = inst0_wb_valid_r & ~flush_inst0_wb_i;
assign inst0_wb_rd_o = inst0_wb_rd_r;
assign inst0_wb_value_o = inst0_wb_value_r;
assign inst0_wb_sid_o = inst0_wb_sid_r;
assign inst1_wb_valid_o = inst1_wb_valid_r & ~flush_inst1_wb_i;
assign inst1_wb_rd_o = inst1_wb_rd_r;
assign inst1_wb_value_o = inst1_wb_value_r;
assign inst1_wb_sid_o = inst1_wb_sid_r;

assign wb_redirect = inst0_wb_redirect_r || inst1_wb_redirect_r;
assign wb_redirect_pc = inst0_wb_redirect_r ? inst0_wb_redirect_pc_r : inst1_wb_redirect_pc_r;
assign wb_redirect_sid = inst0_wb_redirect_r ? inst0_wb_sid_r : inst1_wb_sid_r;

// assign wb_redirect_o = 1'b0;
assign wb_redirect_o = wb_redirect;
assign wb_redirect_pc_o = wb_redirect_pc;
assign wb_redirect_sid_o = wb_redirect_sid;

endmodule