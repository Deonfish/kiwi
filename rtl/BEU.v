
module BEU (
	input clk,
	input rst_n,

	input flush_i,

	input 		  branch_valid_i,
	input [63:0]  branch_pc_i,
	input [31:0]  branch_inst_i,
	input [`SCOREBOARD_SIZE_WIDTH-1:0] branch_sid_i,
	input [63:0]  rs1_value_i,
	input [63:0]  rs2_value_i,
	input [3:0]   func_code_i, 

	output 		  branch_redirect_o,
	output [63:0] branch_redirect_pc_o,
	output [`SCOREBOARD_SIZE_WIDTH-1:0] branch_sid_o
);

reg branch_valid_r;
reg [63:0] branch_valid_pc_r;
reg [31:0] branch_valid_inst_r;
reg [63:0] branch_rs1_value_r;
reg [63:0] branch_rs2_value_r;
reg [3:0] branch_func_code_r;
wire [4:0] branch_rd;
reg redirect;
reg [63:0] redirect_pc;

wire [2:0] func3;
wire jal;
wire [20:0] jal_imm;
wire [63:0] jal_target_pc;
wire jalr;
wire [11:0] jalr_imm;
wire [63:0] jalr_target_pc;
wire b;
wire beq;
wire bne;
wire blt;
wire bge;
wire bltu;
wire bgeu;
wire b_taken;
wire [12:0] b_imm;
wire [63:0] b_target_pc;
wire [63:0] wb_value;

reg wb_valid;
reg [4:0] wb_rd;
reg [63:0] wb_value_r;

reg branch_mnt_valid;
reg [63:0] branch_mnt_pc;
reg [31:0] branch_mnt_inst;

// branch pipe

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		branch_valid_r 		<= 'b0;
	end	
	else if(flush_i) begin
		branch_valid_r <= 1'b0;
	end
	else if(branch_valid) begin
		branch_valid_r <= 1'b1;
		branch_valid_pc_r <= branch_pc_i;
		branch_valid_inst_r <= branch_inst_i;
		branch_rs1_value_r <= rs1_value_i;
		branch_rs2_value_r <= rs2_value_i;
		branch_func_code_r <= func_code_i;
	end
	else begin
		branch_valid_r <= 1'b0;
	end
end

assign branch_rd = b ? 'b0 : branch_valid_inst_r[11:7];

assign jal = (branch_func_code_r == 4'b0111);
assign jalr = (branch_func_code_r == 4'b0101);
assign b = (branch_func_code_r == 4'b0100);

assign jal_imm = {branch_valid_inst_r[31], branch_valid_inst_r[19:12], branch_valid_inst_r[20], branch_valid_inst_r[30:21], 1'b0};
assign jal_target_pc = branch_valid_pc_r + {{43{jal_imm[20]}}, jal_imm};

assign jalr_imm = branch_valid_inst_r[31:20];
assign jalr_target_pc = branch_rs1_value_r + {{52{jalr_imm[11]}}, jalr_imm};

assign wb_value = branch_valid_pc_r + 4;

assign func3 = branch_valid_inst_r[14:12];

assign beq = (func3 == 3'b000);
assign bne = (func3 == 3'b001);
assign blt = (func3 == 3'b100);
assign bge = (func3 == 3'b101);
assign bltu = (func3 == 3'b110);
assign bgeu = (func3 == 3'b111);

assign b_imm = {branch_valid_inst_r[31], branch_valid_inst_r[7], branch_valid_inst_r[30:25], branch_valid_inst_r[11:8], 1'b0};
assign b_target_pc = branch_valid_pc_r + {{52{b_imm[12]}}, b_imm};

assign b_taken = (beq && (branch_rs1_value_r == branch_rs2_value_r)) || 
				 (bne && (branch_rs1_value_r != branch_rs2_value_r)) || 
				 (blt && (branch_rs1_value_r < branch_rs2_value_r))  || 
				 (bge && (branch_rs1_value_r >= branch_rs2_value_r)) || 
				 (bltu && (branch_rs1_value_r < branch_rs2_value_r)) || 
				 (bgeu && (branch_rs1_value_r >= branch_rs2_value_r));

assign redirect = branch_valid_r & (jal | jalr | b_taken);
assign redirect_pc = jal ? jal_target_pc : jalr ? jalr_target_pc : b_target_pc;

assign branch_redirect_o = redirect;
assign branch_redirect_pc_o = redirect_pc;
assign branch_sid_o = branch_sid_i;

endmodule
