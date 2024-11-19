module dcache(
    input           clk,
    input           rst_n,

    input [0:0]     req_vld_i,
    input [0:0]     req_rd_i,
    input [63:0]    req_addr_i,
    input [1:0]     req_wwidth_i, // 0 for byte, 1 for hw, 2 for w, 3 for dw
    input [63:0]    req_wdata_i,

    output [0:0]    ret_vld_o,
    output [511:0]  ret_data_o,

    output [0:0]    l1req_vld_o,
    input  [0:0]    l1req_ack_i,
    output [0:0]    l1req_rd_o,
    output [63:0]   l1req_addr_o,

    input [0:0]     resp_vld_i,
    input [511:0]   resp_data_i,
    
    input [0:0] flush_dc_i
);

parameter WAY_NUM = 2;
parameter WAY_WIDTH = 1;
parameter SET_NUM = 64;
parameter SET_WIDTH = 6;
parameter LINE_SIZE = 512;
parameter TAG_WIDTH = 52;
parameter IDX_WIDTH = 6;
parameter OFFSET_WIDTH = 6;

localparam IDLE  = 3'b000;
localparam TAG   = 3'b001;
localparam MISS  = 3'b010;
localparam WB    = 3'b011;
localparam RD    = 3'b100;

reg [2:0] state;
reg [2:0] next_state;

reg[WAY_NUM-1:0]        valid_array_r[SET_NUM];

wire                    req_hsk;
wire [TAG_WIDTH-1:0]    req_tag;
wire [IDX_WIDTH-1:0]    req_idx;
wire [OFFSET_WIDTH-1:0] req_offset;

reg                    tag_pipe_vld_r;
reg                    tag_pipe_rd_r;
reg [TAG_WIDTH-1:0]    tag_pipe_tag_r;
reg [IDX_WIDTH-1:0]    tag_pipe_idx_r;
reg [OFFSET_WIDTH-1:0] tag_pipe_offset_r;
reg [1:0]              tag_pipe_wwidth_r;
reg [63:0]             tag_pipe_wdata_r;
wire [LINE_SIZE-1:0]   tag_pipe_wl_data;
wire [TAG_WIDTH-1:0]   tag_pipe_tag[WAY_NUM];
wire [TAG_WIDTH-1:0]   tag_pipe_data[WAY_NUM];
wire [WAY_NUM-1:0]     hit_way;
wire                   hit[WAY_NUM];
reg                    miss_hsk_r;
reg                    tag_pipe_refill_vld_r;
reg [LINE_SIZE-1:0]    tag_pipe_refill_data_r;
wire [WAY_WIDTH-1:0]   victim_way;
wire                   wb_vld;

reg data_pipe_vld_r;
reg data_pipe_rd_r;
reg [WAY_NUM-1:0]    data_pipe_hit_way_r;
wire [LINE_SIZE-1:0] data_pipe_data[WAY_NUM];
reg                  data_pipe_refill_vld_r;
reg [LINE_SIZE-1:0]  data_pipe_refill_data_r;

// -------- req pipe -------- //

assign req_hsk = req_vld_i && !tag_pipe_vld_r || hit || tag_pipe_refill_vld_r;

assign req_tag    = f0_pc_i[OFFSET_WIDTH+IDX_WIDTH +: TAG_WIDTH];
assign req_idx    = f0_pc_i[OFFSET_WIDTH +: IDX_WIDTH];
assign req_offset = f0_pc_i[0 +: OFFSET_WIDTH];

// -------- tag pipe -------- //

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
    end
    else if(flush_dc_i) begin
        tag_pipe_vld_r <= 1'b0;
    end
    else if(!tag_pipe_vld_r || hit || tag_pipe_refill_vld_r) begin
        tag_pipe_vld_r    <= req_vld_i;
        tag_pipe_rd_r     <= req_rd_i;
        tag_pipe_tag_r    <= req_tag;
        tag_pipe_idx_r    <= req_idx;
        tag_pipe_offset_r <= req_offset;
        tag_pipe_wwidth_r <= req_wwidth_i;
        tag_pipe_wdata_r  <= req_wdata_i;
        miss_hsk_r        <= 1'b0;
    end
end

genvar i;

generate
for(i=0; i<WAY_NUM; i=i+1) begin

assign hit_way[i] = tag_pipe_vld_r && valid_array_r[tag_pipe_idx_r][i] && tag_pipe_tag[i] == tag_pipe_tag_r;

end
endgenerate

assign hit = |hit_way;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        miss_hsk_r <= 1'b0;
    end
    else if(l1req_vld_o && l1req_ack_i) begin
        miss_hsk_r <= 1'b1;
    end
end

assign l1req_vld_o = tag_pipe_vld_r & ~hit & ~miss_hsk_r; // @todo: writeback
assign l1req_rd_o = tag_pipe_rd_r;
assign l1req_addr_o = {tag_pipe_tag_r, tag_pipe_idx_r, tag_pipe_offset_r};

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        tag_pipe_refill_vld_r <= 1'b0;
    end
    else begin
        tag_pipe_refill_vld_r  <= resp_vld_i;
        tag_pipe_refill_data_r <= resp_data_i;
    end
end

// only support aligned write
generate
    for(i=0; i<LINE_SIZE/8; i=i+1) begin
        assign tag_pipe_wl_data[i*8+:8] =   tag_pipe_wwidth_r == 0 ? tag_pipe_offset_r == i                   ? tag_pipe_wdata_r[7:0]                         : tag_pipe_data[hit_way][i*8+:8]
                                            tag_pipe_wwidth_r == 1 ? tag_pipe_offset_r[OFFSET_WIDTH-1:1] == i ? tag_pipe_wdata_r[tag_pipe_offset_r[1:0]*8+:8] : tag_pipe_data[hit_way][i*8+:8]
                                            tag_pipe_wwidth_r == 2 ? tag_pipe_offset_r[OFFSET_WIDTH-1:2] == i ? tag_pipe_wdata_r[tag_pipe_offset_r[2:0]*8+:8] : tag_pipe_data[hit_way][i*8+:8]
                                                                     tag_pipe_offset_r[OFFSET_WIDTH-1:3] == i ? tag_pipe_wdata_r[tag_pipe_offset_r[3:0]*8+:8] : tag_pipe_data[hit_way][i*8+:8];
    end
endgenerate

assign victim_way = fifo_array_r[tag_pipe_idx_r][1] ? 1 : 0;

assign wb_vld = tag_pipe_vld_r & tag_pipe_refill_vld_r & valid_array_r[tag_pipe_idx_r][victim_way];

// -------- data pipe -------- //

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        data_pipe_vld_r <= 1'b0;
    end
    else if(flush_dc_i) begin
        data_pipe_vld_r <= 1'b0;
    end
    else begin
        data_pipe_vld_r <= tag_pipe_vld_r & (hit | tag_pipe_refill_vld_r) ;
        data_pipe_rd_r <= tag_pipe_rd_r;
        data_pipe_hit_way_r <= hit_way;
        data_pipe_refill_vld_r <= tag_pipe_refill_vld_r;
        data_pipe_refill_data_r <= tag_pipe_refill_data_r;
    end
end

// valid
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
    end
    else if() begin
    end
end
// fifo
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
    end
    else if() begin
    end
end

assign ret_vld_o = data_pipe_vld_r & data_pipe_rd_r;

assign ret_data_o = {DATAWIDTH{data_pipe_hit_way_r[0]}} & data_pipe_data[0] |
                    {DATAWIDTH{data_pipe_hit_way_r[1]}} & data_pipe_data[1] |
                    {DATAWIDTH{data_pipe_refill_vld_r}} & data_pipe_refill_data_r;

// -------- state machine -------- //

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
            if(/* req */)
                next_state = TAG;
        end
        TAG: begin
            if(/* hit & no req */)
                next_state = IDLE;
            else if(/* miss */)
                next_state = MISS;
        end
        MISS: begin
            if(/* refill */)
                next_state = WB;
        end
        WB: begin
            next_state = RD;
        end
        RD: begin
            if(/* no req */)
                next_state = IDLE;
            else if(/* req */)
                next_state = TAG;
        end
    endcase
end

// -------- sram -------- //

sram_model #(
	.DATAWIDTH(TAG_WIDTH),
	.ADDRWIDTH(SET_WIDTH))
tag_array0 (
	.CLK		(clk),
	.CEN		(req_hsk /* || refill_way0 */),
	.WEN		(),
	.D			(),
	.A			(req_idx),
	.Q			(tag_pipe_tag[0])
);

sram_model #(
	.DATAWIDTH(TAG_WIDTH),
	.ADDRWIDTH(SET_WIDTH))
tag_array1 (
	.CLK		(clk),
	.CEN		(req_hsk /* || refill_way1 */),
	.WEN		(),
	.D			(),
	.A			(req_idx),
	.Q			(tag_pipe_tag[1])
);

sram_model #(
	.DATAWIDTH(LINE_SIZE),
	.ADDRWIDTH(SET_WIDTH))
data_array0 (
	.CLK		(clk),
	.CEN		(req_hsk /* || refill_way1 */),
	.WEN		(),
	.D			(),
	.A			(tag_pipe_idx_r),
	.Q			(tag_pipe_data[0])
);

sram_model #(
	.DATAWIDTH(LINE_SIZE),
	.ADDRWIDTH(SET_WIDTH))
data_array1 (
	.CLK		(clk),
	.CEN		(req_hsk /* || refill_way1 */),
	.WEN		(),
	.D			(),
	.A			(tag_pipe_idx_r),
	.Q			(tag_pipe_data[1])
);

endmodule