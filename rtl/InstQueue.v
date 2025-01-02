module InstQueue(
    input         clk,
    input         rst_n,
    // from Icache
    input [0:0]   icache_valid_i,
    input [63:0]  icache_pc_i,
    input [511:0] icache_data_i,
    output [0:0]  instq_full_o,
    // to Fetch0
    output [0:0]  iq0_vld_o,
    output [63:0] iq0_pc_o,
    output [31:0] iq0_inst_o,
    output [0:0]  iq1_vld_o,
    output [63:0] iq1_pc_o,
    output [31:0] iq1_inst_o,
    // stall from backend
    input [0:0]   stall_iq_i,
    // squash from backend
    input [0:0]   flush_iq_i
);

parameter DEPTH = 32;
parameter DEPTH_WIDTH = 5;
parameter WRITE_WIDTH = 16;
parameter READ_WIDTH = 2;

reg [31:0] inst_queue [DEPTH-1:0];
reg [DEPTH-1:0] valid_queue;
reg [63:0] pc_r;

reg [DEPTH_WIDTH:0]    wptr;
reg [DEPTH_WIDTH:0]    rptr;
wire                   wptr_hi;
wire [DEPTH_WIDTH-1:0] wptr_val;
wire [DEPTH_WIDTH-1:0] wptr_val_add[WRITE_WIDTH-1:0];
wire                   rptr_hi;
wire [DEPTH_WIDTH-1:0] rptr_val;
wire [DEPTH_WIDTH-1:0] rptr_val_add[READ_WIDTH-1:0];

wire [DEPTH_WIDTH:0] wptr_next = wptr + WRITE_WIDTH;
wire [DEPTH_WIDTH:0] rptr_next = rptr + READ_WIDTH;

genvar i;

// wptr
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        wptr <= 'b0;
    end
    else if(icache_valid_i && !instq_full_o) begin
        wptr <= wptr_next;
    end
end

assign wptr_hi = wptr[DEPTH_WIDTH];
assign wptr_val = wptr[DEPTH_WIDTH-1:0];

generate
for(i=0; i<WRITE_WIDTH; i=i+1) begin

assign wptr_val_add[i] = wptr_val + i;

end
endgenerate

// rptr
always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        rptr <= 'b0;
    end
    else if(iq0_vld_o && iq1_vld_o && !stall_iq_i) begin
        rptr <= rptr_next;
    end
end

assign rptr_hi = rptr[DEPTH_WIDTH];
assign rptr_val = rptr[DEPTH_WIDTH-1:0];

generate
for(i=0; i<READ_WIDTH; i=i+1) begin

assign rptr_val_add = rptr_val + i;

end
endgenerate

// full
assign instq_full_o = wptr_hi!=rptr_hi ? wptr_val - rptr_val < WRITE_WIDTH : rptr_val - wptr_val < READ_WIDTH;

// instQueue
always @(posedge clk) begin
    if(icache_valid_i && !instq_full_o) begin
        pc_r <= icache_pc_i;
    end
end

generate
for(i=0; i<DEPTH; i=i+1) begin

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        valid_queue[i] <= 1'b0;
    end
    if(flush_iq_i) begin
        valid_queue[i] <= 1'b0;
    end
    else if(icache_valid_i && !instq_full_o && i==wptr_val_add[i]) begin
        valid_queue[i] <= 1'b1;
        inst_queue[i]  <= icache_data_i[i*32+:32];
    end
    else if(iq0_vld_o && iq1_vld_o && !stall_iq_i && i==rptr_val_add[i]) begin
        valid_queue[i] <= 1'b0;
    end
end

end
endgenerate

// output
assign iq0_vld_o = valid_queue[rptr_val_add[0]];
assign iq0_pc_o  = pc_r + 0;
assign iq0_inst_o = inst_queue[rptr_val_add[0]];

assign iq1_vld_o = valid_queue[rptr_val_add[1]];
assign iq1_pc_o  = pc_r + 4;
assign iq1_inst_o = inst_queue[rptr_val_add[1]];

endmodule