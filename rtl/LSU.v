
module LSU (
	input clk,
	input rst_n,	

	input 		 lsu_valid_i,
	input [63:0] lsu_pc_i,
	input [31:0] lsu_inst_i,
	input [2:0]  lsu_func3_i,
    input        rs1_bypass_en_i,
    input [63:0] rs1_bypass_data_i,
	input [63:0] rs1_value_i,
    input        rs2_bypass_en_i,
    input [63:0] rs2_bypass_data_i,
	input [63:0] rs2_value_i,
	input [4:0]  lsu_rd_i,
	input [63:0] rd_value_i,

	output access_mem_o,
	output write_mem_o,
	output [63:0] mem_addr_o,
	output [63:0] mem_wdata_o,
	input  [63:0] mem_rdata_i,

    output lsu_exe_valid_o,
    output lsu_exe_load_o,
    output [4:0] lsu_exe_rd_o,

	output lsu_wb_valid_o,
	output [4:0] lsu_wb_rd_o,
	output [63:0] lsu_wb_data_o,
    output lsu_wb_load_o,

	output lsu_mnt_valid_o,
	output [63:0] lsu_mnt_pc_o,
	output [31:0] lsu_mnt_inst_o
);

reg lsu_valid_r;
reg [63:0] lsu_pc_r;
reg [31:0] lsu_inst_r;
reg [2:0] lsu_func3_r;
reg [63:0] lsu_rs1_value_r;
reg [63:0] lsu_rs2_value_r;
reg [4:0]  lsu_rd_r;
reg [63:0] lsu_rd_value_r;

wire [4:0] opcode;
wire store;
wire load;
wire uload;
wire byteWidth;
wire halfWidth;
wire wordWidth;
wire doubleWidth;
wire [11:0] imm12;
wire [63:0] mem_addr;

reg store_valid_r;
reg [63:0] store_addr_r;
reg [63:0] store_rs2_value_r;
wire [63:0] store_dest_value;

reg [63:0] lsu_rd_value_delay_r;
wire [63:0] load_mem_value;
wire [63:0] load_rd_value;
wire [63:0] store_mem_value;
reg lsu_wb_valid_r;
reg [4:0] lsu_wb_rd_r;
reg lsu_load_wb_r;

reg lsu_mnt_valid_r;
reg [63:0] lsu_mnt_pc_r;
reg [31:0] lsu_mnt_inst_r;

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		lsu_valid_r <= 1'b0;
		lsu_pc_r <= 64'h0;
		lsu_inst_r <= 32'h0;
		lsu_func3_r <= 3'b0;
		lsu_rs1_value_r <= 64'h0;
		lsu_rs2_value_r <= 64'h0;
		lsu_rd_r <= 'b0;
		lsu_rd_value_r <= 'b0;
	end	
	else if(lsu_valid_i) begin
		lsu_valid_r <= 1'b1;
		lsu_pc_r <= lsu_pc_i;
		lsu_inst_r <= lsu_inst_i;
		lsu_func3_r <= lsu_func3_i;
		lsu_rs1_value_r <= rs1_bypass_en_i ? rs1_bypass_data_i : rs1_value_i;
		lsu_rs2_value_r <= rs2_bypass_en_i ? rs2_bypass_data_i : rs2_value_i;
		lsu_rd_r <= lsu_rd_i;
		lsu_rd_value_r <= rd_value_i;
	end
	else begin
		lsu_valid_r <= 1'b0;
	end
end

assign opcode = lsu_inst_r[6:2];

assign store = opcode == `RV_OP_STORE;
assign load  = opcode == `RV_OP_LOAD;
assign uload = load && lsu_func3_r[2];

assign byteWidth   = lsu_func3_r[1:0] == 2'b00;
assign halfWidth   = lsu_func3_r[1:0] == 2'b01;
assign wordWidth   = lsu_func3_r[1:0] == 2'b10;
assign doubleWidth = lsu_func3_r[1:0] == 2'b11;

assign imm12 = load ? lsu_inst_r[31:20] : {lsu_inst_r[31:25] , lsu_inst_r[11:7]};
assign mem_addr = lsu_rs1_value_r + { {52{imm12[11]}}, imm12 };

assign access_mem_o = lsu_valid_r | store_valid_r;
assign write_mem_o = store_valid_r;
assign mem_addr_o = ({64{lsu_valid_r}} & mem_addr) |
					({64{store_valid_r}} & store_addr_r);
assign mem_wdata_o = store_mem_value;

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		store_valid_r <= 1'b0;
		store_addr_r <= 'b0;
		store_rs2_value_r <= 'b0;
	end	
	else if(lsu_valid_r && store) begin
		store_valid_r <= 1'b1;
		store_addr_r <= mem_addr;
		store_rs2_value_r <= lsu_rs2_value_r;
	end
	else begin
		store_valid_r <= 1'b0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		lsu_rd_value_delay_r <= 'b0;
	end	
	else
		lsu_rd_value_delay_r <= lsu_rd_value_r;
end

assign load_mem_value = mem_rdata_i;
assign load_rd_value =  ({64{byteWidth}} & { lsu_rd_value_delay_r[63:8],  load_mem_value[7:0]  }) |
						({64{halfWidth}} & { lsu_rd_value_delay_r[63:16], load_mem_value[15:0] }) |
						({64{wordWidth}} & { lsu_rd_value_delay_r[63:32], load_mem_value[31:0] }) |
						({64{doubleWidth}} & { load_mem_value[63:0] });

assign store_mem_value = ({64{byteWidth}} & { load_mem_value[63:8],  store_rs2_value_r[7:0] }) |
						 ({64{halfWidth}} & { load_mem_value[63:16], store_rs2_value_r[15:0] }) |
						 ({64{wordWidth}} & { load_mem_value[63:32], store_rs2_value_r[31:0] }) |
						 ({64{doubleWidth}} & { store_rs2_value_r[63:0] });

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		lsu_wb_valid_r <= 1'b0;
		lsu_wb_rd_r <= 'b0;
	end	
	else if(lsu_valid_r) begin
		lsu_wb_valid_r <= 1'b1;
		if(load) begin
			lsu_wb_rd_r <= lsu_rd_r;
			lsu_load_wb_r <= 1'b1;
		end
		else begin
			lsu_wb_rd_r <= 'b0;
			lsu_load_wb_r <= 1'b0;
		end
	end
	else begin
		lsu_wb_valid_r <= 1'b0;
	end
end

assign lsu_wb_valid_o = lsu_wb_valid_r;
assign lsu_wb_rd_o = lsu_load_wb_r ? lsu_wb_rd_r : 'b0;
assign lsu_wb_data_o = lsu_load_wb_r ? load_rd_value : 'b0;

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		lsu_mnt_valid_r <= 1'b0;
	end
	else if(lsu_valid_r) begin
		lsu_mnt_valid_r <= 1'b1;
		lsu_mnt_inst_r <= lsu_inst_r;
		lsu_mnt_pc_r <= lsu_pc_r; 
	end
	else begin
		lsu_mnt_valid_r <= 1'b0;
	end
end

assign lsu_mnt_valid_o = lsu_mnt_valid_r;
assign lsu_mnt_inst_o  = lsu_mnt_inst_r;
assign lsu_mnt_pc_o    = lsu_mnt_pc_r;
	

assign lsu_exe_valid_o = lsu_valid_r;
assign lsu_exe_load_o = lsu_valid_r & load;
assign lsu_exe_rd_o = lsu_rd_r;

assign lsu_wb_load_o = lsu_load_wb_r;

endmodule
