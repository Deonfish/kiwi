
module ALU (
	input                                   clk,
	input                                   rst_n,
	// flush
	input                                   flush_i,
	// from operands
	input                                  alu_valid_i,
	input  [`SCOREBOARD_SIZE_WIDTH-1:0]    alu_sid_i,
	input  [2:0]                           alu_func3_i,
	input                                  alu_auipc_i,
	input  [63:0]                          alu_pc_i,
	input  [31:0]                          alu_inst_i,
	input  [63:0]                          rs1_value_i,
	input  [63:0]                          rs2_value_i,
	input  [3:0]                           func_code_i,
	input                                   endsim_i,
	// alu result
	output                                 alu_exe_valid_o,
	output [`SCOREBOARD_SIZE_WIDTH-1:0]    alu_sid_o,
	output [4:0]                           alu_exe_rd_o,
	output [63:0]                          alu_exe_rd_value_o
);

reg alu_valid_r;
reg [2:0] alu_func3_r;
reg alu_auipc_r;
reg [63:0] alu_pc_r;
reg [31:0] alu_inst_r;
reg [`SCOREBOARD_SIZE_WIDTH-1:0] alu_sid_r;
reg [63:0] alu_rs1_value_r;
reg [63:0] alu_rs2_value_r;
reg [3:0] alu_func_code_r;

wire add;
wire sub;
wire slt;
wire sltu;
wire shift;
wire lui;
wire auipc;
wire and_l;
wire or_l;
wire xor_l;
wire sl; // shift left
wire sr; // shift right
wire sra; // shift right arithmetic

wire op_imm;
wire op32;
wire [11:0] imm12;
wire [19:0] imm20;
wire [63:0] rs1_data64;
wire [63:0] rs2_data64;
wire [63:0] sum_data64;
wire [31:0] rs1_data32;
wire [31:0] rs2_data32;
wire [31:0] sum_data32;
wire [31:0] aupic_imm;
wire cmp_res;
wire ucmp_res;
wire [63:0] auipc_res;
wire [63:0] lui_res;
wire [63:0] and_res;
wire [63:0] or_res;
wire [63:0] xor_res;
wire [63:0] sll_res64;
wire [63:0] srl_res64;
wire [63:0] sra_res64;
wire [31:0] sll_res32;
wire [31:0] srl_res32;
wire [31:0] sra_res32;
wire [63:0] rd_data64;
wire [31:0] rd_data32;
wire [63:0] rd_data;

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		alu_valid_r <= 1'b0;
	end
	else if(flush_i) begin
		alu_valid_r <= 1'b0;
	end
	else if(alu_valid || endsim_i) begin
		alu_valid_r <= 1'b1;
		alu_func3_r <= alu_func3;
		alu_auipc_r <= alu_auipc;
		alu_pc_r <= alu_pc_i;
		alu_inst_r <= alu_inst_i;
		alu_sid_r <= alu_sid_i;
		alu_rs1_value_r <= rs1_value_i;
		alu_rs2_value_r <= rs2_value_i;
		alu_func_code_r <= func_code_i;
	end	
	else begin
		alu_valid_r <= 1'b0;
	end
end

assign op_imm = ~alu_inst_r[5];

assign imm12 = alu_inst_r[31:20];
assign imm20 = alu_inst_r[31:12];

assign rs1_data64 = alu_rs1_value_r;
assign rs1_data32 = alu_rs1_value_r[31:0];

assign rs2_data64 = op_imm ? { {52{imm12[11]}}, imm12 } : sub ? (~alu_rs2_value_r+1) : alu_rs2_value_r;
assign rs2_data32 = op_imm ? { {20{imm12[11]}}, imm12 } : sub ? (~alu_rs2_value_r[31:0]+1) : alu_rs2_value_r[31:0];

assign add    = ~lui & ~auipc & (alu_func3_r == 3'b000);
assign sub    = alu_inst_r[30];
assign slt    = ~lui & ~auipc & (alu_func3_r == 3'b010);
assign sltu   = ~lui & ~auipc & (alu_func3_r == 3'b011);
assign and_l  = ~lui & ~auipc & (alu_func3_r == 3'b111);
assign or_l   = ~lui & ~auipc & (alu_func3_r == 3'b110);
assign xor_l  = ~lui & ~auipc & (alu_func3_r == 3'b100);
assign sl     = ~lui & ~auipc & (alu_func3_r == 3'b001);
assign sr     = ~lui & ~auipc & (alu_func3_r == 3'b101);
assign sra	  = alu_inst_r[30] & sr;
assign lui 	  = alu_inst_r[6:0] == 7'b0110111;
assign auipc  = alu_auipc_r;
	
//assign cmp_res  = op_imm ? (rs1_data64 < { {52{imm12[11]}}, imm12 }) : (rs1_data64 < rs2_data64); // TODO: need to convert to signed compare
assign cmp_res = rs1_data64[63] < rs2_data64[63] ? 1'b1 : (rs1_data64 == rs2_data64) ? 1'b0 : 1'b0; // TODO
assign ucmp_res = rs1_data64 < rs2_data64;

Adder #(
	.WIDTH(32)
) u_adder32 (
	.a(rs1_data32),
	.b(rs2_data32),
	.sum(sum_data32)
);

Adder #(
	.WIDTH(64)
) u_adder64 (
	.a(rs1_data64),
	.b(rs2_data64),
	.sum(sum_data64)
);

assign aupic_imm = imm20 << 12;
assign lui_res = { {32{aupic_imm[31]}}, aupic_imm };
assign auipc_res = alu_pc_r + lui_res;

assign and_res = rs1_data64 & rs2_data64;
assign or_res  = rs1_data64 | rs2_data64;
assign xor_res = rs1_data64 ^ rs2_data64;

assign sll_res64 = rs1_data64 <<  rs2_data64[5:0];
assign srl_res64 = rs1_data64 >>  rs2_data64[5:0];
assign sra_res64 = rs1_data64 >>> rs2_data64[5:0];
assign sll_res32 = rs1_data32 <<  rs2_data32[4:0];
assign srl_res32 = rs1_data32 >>  rs2_data32[4:0];
assign sra_res32 = rs1_data32 >>> rs2_data32[4:0];

assign rd_data64 =  ({64{add}} & sum_data64)  | 
					({64{slt}} & cmp_res)     | 
					({64{sltu}} & ucmp_res)   | 
					({64{and_l}} & and_res)   | 
					({64{or_l}} & or_res)     | 
					({64{xor_l}} & xor_res)   | 
					({64{sl}} & sll_res64)    | 
					({64{sr}} & srl_res64)    | 
					({64{sra}} & sra_res64)   | 
					({64{lui}} & lui_res)  	  | 
					({64{auipc}} & auipc_res) | 
					64'h0;

assign rd_data32 =  ({32{add}} & sum_data32) |
					({32{sl}} & sll_res32) 	 |
					({32{sr}} & srl_res32)   |
					({32{sra}} & sra_res32);

assign op32 = alu_inst_r[3];

assign rd_data = op32 ? {{32{rd_data32[31]}}, rd_data32} : rd_data64;

assign alu_exe_valid_o = alu_valid_r;
assign alu_exe_rd_o = alu_inst_r[11:7];
assign alu_exe_rd_value_o = rd_data;
assign alu_sid_o = alu_sid_r;

endmodule
