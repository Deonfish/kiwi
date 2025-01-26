module Icache(
    input             clk,
    input             rst_n,
    // from Fetch0
    input   [0:0]     f0_valid_i,
    input   [63:0]    f0_pc_i,
    output  [0:0]     stall_f0_o,
    // inst to instQueue
    output  [0:0]     icache_valid_o, 
    output  [63:0]    icache_pc_o,
    output  [511:0]   icache_data_o,
    // icache miss to mem subsystem
    output  [0:0]     icache_miss_valid_o,
    input   [0:0]     icache_miss_ready_i,
    output  [63:0]    icache_miss_addr_o,
    // refill from mem subsystem
    input   [0:0]     refill_icache_valid_i,
    output  [0:0]     refill_icache_ready_o,
    input   [511:0]   refill_icache_data_i,
    // stall from instQueue
    input   [0:0]     stall_icache_i,
    // squash from backend
    input   [0:0]     squash_pipe_i
);

parameter WAY_NUM = 2;
parameter SET_NUM = 64;
parameter SET_WIDTH = 6;
parameter LINE_SIZE = 512;
parameter TAG_WIDTH = 52;
parameter IDX_WIDTH = 6;
parameter OFFSET_WIDTH = 6;

localparam IDLE  = 2'b00;
localparam TAG   = 2'b01;
localparam MISS = 2'b10;

wire f0_hsk;
wire [TAG_WIDTH-1:0]    f0_tag;
wire [IDX_WIDTH-1:0]    f0_idx;
wire [OFFSET_WIDTH-1:0] f0_offset;

reg                    fetch_vld_r;
reg [TAG_WIDTH-1:0]    fetch_tag_r;
reg [IDX_WIDTH-1:0]    fetch_idx_r;
reg [OFFSET_WIDTH-1:0] fetch_offset_r;

reg [1:0] state;
reg [1:0] next_state;

reg  valid_array_r[SET_NUM][WAY_NUM];
wire [TAG_WIDTH-1:0] tag_pipe_tag[WAY_NUM];
wire [LINE_SIZE-1:0] tag_pipe_data[WAY_NUM];
wire [WAY_NUM-1:0]   hit_way;
wire [LINE_SIZE-1:0] hit_data;
wire hit;
reg  [WAY_NUM-1:0] fifo_array_r[SET_NUM];
wire victim_way;
wire refill_way0;
wire refill_way1;

reg [0:0]   refill_icache_valid_r;
reg [511:0] refill_icache_data_r;
wire refill_vld;
wire hit_refill;

reg[15:0] outstanding_cnt;

assign f0_hsk = f0_valid_i & !stall_icache_i && state!=MISS && !squash_pipe_i;

assign f0_tag    = f0_pc_i[OFFSET_WIDTH+IDX_WIDTH +: TAG_WIDTH];
assign f0_idx    = f0_pc_i[OFFSET_WIDTH +: IDX_WIDTH];
assign f0_offset = f0_pc_i[0 +: OFFSET_WIDTH];

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        fetch_vld_r <= 1'b0;
    end
    else if(squash_pipe_i) begin
        fetch_vld_r <= 1'b0;
    end
    else if(!stall_icache_i && state!=MISS) begin
        fetch_vld_r    <= f0_valid_i;
        fetch_tag_r    <= f0_tag;
        fetch_idx_r    <= f0_idx;
        fetch_offset_r <= f0_offset;
    end
end

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
            if(f0_valid_i && !stall_icache_i && !squash_pipe_i) begin
                next_state = TAG;
            end
        end
        TAG: begin
            if(!hit && icache_miss_ready_i) begin
                next_state = MISS;
            end
            else if(squash_pipe_i || hit && !f0_valid_i) begin
                next_state = IDLE;
            end
        end
        MISS: begin
            if(hit_refill) begin
                next_state = TAG;
            end
        end
    endcase
end

// hit gen
genvar i, j;

generate
for(j=0; j<SET_NUM; j=j+1) begin
    for(i=0; i<WAY_NUM; i=i+1) begin

        always @(posedge clk or negedge rst_n) begin
            if(!rst_n) begin
                valid_array_r[j][i] <= 1'b0;
            end
            else if(refill_vld && fetch_idx_r==j && victim_way==i) begin
                valid_array_r[j][i] <= 1'b1;
            end
        end

    end
end
endgenerate

generate
for(j=0; j<SET_NUM; j=j+1) begin
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n) begin
            fifo_array_r[j] <= 'b0;
        end
        else if(refill_vld && j==fetch_idx_r) begin
            if(!(|fifo_array_r[j])) begin
                fifo_array_r[j][~victim_way] <= 1'b1;
            end
            else begin
                fifo_array_r[j] = ~fifo_array_r[j];
            end
        end
    end
end
endgenerate

generate
for(i=0; i<WAY_NUM; i=i+1) begin
    assign hit_way[i] = state == TAG && ~hit_refill && 
           valid_array_r[fetch_idx_r][i] && 
           tag_pipe_tag[i] == fetch_tag_r;
end
endgenerate


assign hit_data = {LINE_SIZE{hit_way[0]}} & tag_pipe_data[0] | 
                  {LINE_SIZE{hit_way[1]}} & tag_pipe_data[1];

assign hit = |hit_way;

// icache hit output gen
assign icache_valid_o = state == TAG && (hit || hit_refill);
assign icache_pc_o = {fetch_tag_r, fetch_idx_r, fetch_offset_r};
assign icache_data_o = {LINE_SIZE{hit}}        & hit_data |
                       {LINE_SIZE{hit_refill}} & refill_icache_data_r;

// stall f0
assign stall_f0_o = (state == TAG && ~hit) || state == MISS;

// icache miss output gen
assign icache_miss_valid_o = state == TAG && ~hit && ~hit_refill;
assign icache_miss_addr_o = {fetch_tag_r, fetch_idx_r, fetch_offset_r};

// refill logic
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        refill_icache_valid_r <= 1'b0;
    end
    else begin
        refill_icache_valid_r <= refill_icache_valid_i;
        refill_icache_data_r <= refill_icache_data_i;
    end
end

assign refill_icache_ready_o = 1'b1;

assign refill_vld = refill_icache_valid_r && state == MISS;

assign hit_refill = refill_icache_valid_r && outstanding_cnt == 1;

assign victim_way = fifo_array_r[fetch_idx_r][1] ? 1 : 0;

assign refill_way0 = refill_vld & victim_way == 0;
assign refill_way1 = refill_vld & victim_way == 1;

// outstanding cnt
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        outstanding_cnt <= 16'd0;
    end
    else if(icache_miss_valid_o && icache_miss_ready_i && refill_vld) begin
        outstanding_cnt <= outstanding_cnt;
    end
    else if(icache_miss_valid_o && icache_miss_ready_i) begin
        outstanding_cnt <= outstanding_cnt + 1;
    end
    else if(refill_vld) begin
        outstanding_cnt <= outstanding_cnt - 1;
    end
end

// sram model

sram_model #(
	.DATAWIDTH(TAG_WIDTH),
	.ADDRWIDTH(SET_WIDTH))
tag_array0 (
	.CLK		(clk),
	.CEN		(f0_hsk || refill_way0),
	.WEN		(refill_way0),
	.D			(fetch_tag_r),
	.A			(f0_idx),
	.Q			(tag_pipe_tag[0])
);

sram_model #(
	.DATAWIDTH(TAG_WIDTH),
	.ADDRWIDTH(SET_WIDTH))
tag_array1 (
	.CLK		(clk),
	.CEN		(f0_hsk || refill_way1),
	.WEN		(refill_way1),
	.D			(fetch_tag_r),
	.A			(f0_idx),
	.Q			(tag_pipe_tag[1])
);

sram_model #(
	.DATAWIDTH(LINE_SIZE),
	.ADDRWIDTH(SET_WIDTH))
data_array0 (
	.CLK		(clk),
	.CEN		(f0_hsk || refill_way0),
	.WEN		(refill_way0),
	.D			(refill_icache_data_i),
	.A			(f0_idx),
	.Q			(tag_pipe_data[0])
);

sram_model #(
	.DATAWIDTH(LINE_SIZE),
	.ADDRWIDTH(SET_WIDTH))
data_array1 (
	.CLK		(clk),
	.CEN		(f0_hsk || refill_way1),
	.WEN		(refill_way1),
	.D			(refill_icache_data_i),
	.A			(f0_idx),
	.Q			(tag_pipe_data[1])
);

endmodule