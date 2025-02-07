
module LSU (
	input clk,
	input rst_n,	
	input [0:0]  stall_lsu_i,
	input [0:0]  flush_lsu_i,
	// from operands
	input [0:0]  lsu_valid_i,
	input [31:0] lsu_inst_i,
	input [`SCOREBOARD_SIZE_WIDTH:0] lsu_sid_i,
	input [2:0]  lsu_func3_i,
	input [63:0] rs1_value_i,
	input [63:0] rs2_value_i,
	input [4:0]  lsu_rd_i,
	input [63:0] rd_value_i,
	// to uncache mem
	output [0:0]  uncache_mem_vld_o,
	input  [0:0]  uncache_mem_ready_i,
	output [0:0]  uncache_mem_write_o,
	output [2:0]  uncache_mem_size_o,
	output [63:0] uncache_mem_addr_o,
	output [63:0] uncache_mem_wdata_o,
	// from uncache mem
	input  [0:0]  uncache_mem_resp_vld_i,
	output [0:0]  uncache_mem_resp_rdy_o,
	input  [63:0] uncache_mem_resp_data_i,
	// @todo: cache interface
	// to wb
	output [0:0]  lsu_exe_valid_o,
	output [4:0]  lsu_exe_rd_o,
	output [63:0] lsu_exe_rd_value_o,
	output [`SCOREBOARD_SIZE_WIDTH:0] lsu_sid_o
);

localparam IDLE = 2'b00;
localparam SEND = 2'b01;
localparam WAIT = 2'b10;
localparam WB   = 2'b11;

reg [1:0] state;
reg [1:0] next_state;

reg lsu_valid_r;
reg [31:0] lsu_inst_r;
reg [2:0] lsu_func3_r;
reg [63:0] lsu_rs1_value_r;
reg [63:0] lsu_rs2_value_r;
reg [4:0]  lsu_rd_r;
reg [63:0] lsu_rd_value_r;
reg [0:0] mem_resp_valid_r;
reg [63:0] mem_resp_data_r;

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

wire [63:0] load_rd_value;
wire [63:0] store_mem_value;

reg [`SCOREBOARD_SIZE_WIDTH:0] lsu_sid_r;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        state <= IDLE;
    end
    else begin
        state <= next_state;
    end
end

always @(*) begin
    next_state = state;
    case(state)
        IDLE: begin
            if(lsu_valid_i && !stall_lsu_i) begin
                next_state <= SEND;
            end
        end
        SEND: begin
			if(load) begin
				if(uncache_mem_vld_o && uncache_mem_ready_i) begin
					next_state <= WAIT;
				end
			end
			else begin
				if(uncache_mem_vld_o && uncache_mem_ready_i) begin
					next_state <= IDLE;
				end
			end
        end
        WAIT: begin
            if(uncache_mem_resp_vld_i && uncache_mem_resp_rdy_o) begin
                next_state <= WB;
            end
        end
		WB: begin
			if(lsu_exe_valid_o && !stall_lsu_i) begin
				next_state <= IDLE;
			end
		end
    endcase
end

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		lsu_valid_r <= 1'b0;
		lsu_inst_r <= 32'h0;
		lsu_func3_r <= 3'b0;
		lsu_rs1_value_r <= 64'h0;
		lsu_rs2_value_r <= 64'h0;
		lsu_rd_r <= 'b0;
		lsu_rd_value_r <= 'b0;
	end	
	else if(!stall_lsu_i) begin
		lsu_valid_r <= lsu_valid_i;
		lsu_inst_r <= lsu_inst_i;
		lsu_sid_r <= lsu_sid_i;
		lsu_func3_r <= lsu_func3_i;
		lsu_rs1_value_r <= rs1_value_i;
		lsu_rs2_value_r <= rs2_value_i;
		lsu_rd_r <= lsu_rd_i;
		lsu_rd_value_r <= rd_value_i;
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

assign uncache_mem_vld_o = lsu_valid_r & state==SEND;
assign uncache_mem_write_o = store;
assign uncache_mem_size_o = lsu_func3_r[1:0];
assign uncache_mem_addr_o = mem_addr;
assign uncache_mem_wdata_o = store_mem_value;

assign load_rd_value =  ({64{byteWidth}} & { lsu_rd_value_r[63:8],  mem_resp_data_r[7:0]  }) |
						({64{halfWidth}} & { lsu_rd_value_r[63:16], mem_resp_data_r[15:0] }) |
						({64{wordWidth}} & { lsu_rd_value_r[63:32], mem_resp_data_r[31:0] }) |
						({64{doubleWidth}} & { mem_resp_data_r[63:0] });

assign store_mem_value = ({64{byteWidth}} & { 56'h0,  lsu_rs2_value_r[7:0] }) |
						 ({64{halfWidth}} & { 48'h0, lsu_rs2_value_r[15:0] }) |
						 ({64{wordWidth}} & { 32'h0, lsu_rs2_value_r[31:0] }) |
						 ({64{doubleWidth}} & { lsu_rs2_value_r[63:0] });

assign uncache_mem_resp_rdy_o = 1'b1;

always @(posedge clk or negedge rst_n) begin
	if(!rst_n) begin
		mem_resp_data_r <= 64'h0;
	end
	else if(uncache_mem_resp_vld_i && uncache_mem_resp_rdy_o) begin
		mem_resp_data_r <= uncache_mem_resp_data_i;
	end
end

assign lsu_exe_valid_o = (state==SEND && store) || (state==WB && load);
assign lsu_exe_rd_o = lsu_rd_r;
assign lsu_exe_rd_value_o = load_rd_value;
assign lsu_sid_o = lsu_sid_r;

endmodule
