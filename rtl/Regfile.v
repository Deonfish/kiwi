
module Regfile (
	input 		  clk,
	input 		  rst_n,
	// read
	input [4:0]   inst0_rs1_addr_i,
	input [4:0]   inst0_rs2_addr_i,
	input [4:0]   inst0_rd_addr_i,
	output [63:0] inst0_rs1_rdata_o,
	output [63:0] inst0_rs2_rdata_o,
	output [63:0] inst0_rd_rdata_o,
	input [4:0]   inst1_rs1_addr_i,
	input [4:0]   inst1_rs2_addr_i,
	input [4:0]   inst1_rd_addr_i,
	output [63:0] inst1_rs1_rdata_o,
	output [63:0] inst1_rs2_rdata_o,
	output [63:0] inst1_rd_rdata_o,
	// write
	input [0:0]  inst0_rd_wvalid_i,
	input [4:0]  inst0_rd_waddr_i,
	input [63:0] inst0_rd_wdata_i,
	input [0:0]  inst1_rd_wvalid_i,
	input [4:0]  inst1_rd_waddr_i,
	input [63:0] inst1_rd_wdata_i
);

reg [63:0] registers[64];

assign inst0_rs1_rdata_o = inst0_rs1_addr_i!=0 ? registers[inst0_rs1_addr_i] : 0;
assign inst0_rs2_rdata_o = inst0_rs2_addr_i!=0 ? registers[inst0_rs2_addr_i] : 0;
assign inst0_rd_rdata_o  = inst0_rd_addr_i!=0  ? registers[inst0_rd_addr_i]  : 0;
assign inst1_rs1_rdata_o = inst1_rs1_addr_i!=0 ? registers[inst1_rs1_addr_i] : 0;
assign inst1_rs2_rdata_o = inst1_rs2_addr_i!=0 ? registers[inst1_rs2_addr_i] : 0;
assign inst1_rd_rdata_o  = inst1_rd_addr_i!=0  ? registers[inst1_rd_addr_i]  : 0;

always @(posedge clk) begin
	if(inst0_rd_wvalid_i && inst0_rd_waddr_i!=0)
		registers[inst0_rd_waddr_i] <= inst0_rd_wdata_i;
	if(inst1_rd_wvalid_i && inst1_rd_waddr_i!=0)
		registers[inst1_rd_waddr_i] <= inst1_rd_wdata_i;
end

// for sim
initial begin
	integer i;
	for (i = 0; i < 64; i = i + 1) begin
		registers[i] = 64'b0;
	end
end

endmodule