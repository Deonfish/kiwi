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
wire [DEPTH_WIDTH-1:0] wptr_val_add1;
wire [DEPTH_WIDTH-1:0] wptr_val_add2;
wire [DEPTH_WIDTH-1:0] wptr_val_add3;
wire [DEPTH_WIDTH-1:0] wptr_val_add4;
wire [DEPTH_WIDTH-1:0] wptr_val_add5;
wire [DEPTH_WIDTH-1:0] wptr_val_add6;
wire [DEPTH_WIDTH-1:0] wptr_val_add7;
wire [DEPTH_WIDTH-1:0] wptr_val_add8;
wire [DEPTH_WIDTH-1:0] wptr_val_add9;
wire [DEPTH_WIDTH-1:0] wptr_val_add10;
wire [DEPTH_WIDTH-1:0] wptr_val_add11;
wire [DEPTH_WIDTH-1:0] wptr_val_add12;
wire [DEPTH_WIDTH-1:0] wptr_val_add13;
wire [DEPTH_WIDTH-1:0] wptr_val_add14;
wire [DEPTH_WIDTH-1:0] wptr_val_add15;
wire                   rptr_hi;
wire [DEPTH_WIDTH-1:0] rptr_val;
wire [DEPTH_WIDTH-1:0] rptr_val_add1;

wire [31:0] winst0;
wire [31:0] winst1;
wire [31:0] winst2;
wire [31:0] winst3;
wire [31:0] winst4;
wire [31:0] winst5;
wire [31:0] winst6;
wire [31:0] winst7;
wire [31:0] winst8;
wire [31:0] winst9;
wire [31:0] winst10;
wire [31:0] winst11;
wire [31:0] winst12;
wire [31:0] winst13;
wire [31:0] winst14;
wire [31:0] winst15;

wire [31:0] winstq_data[DEPTH-1:0];

wire [DEPTH-1:0] write_inst_queue;
wire [DEPTH-1:0] read_inst_queue;

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
assign rptr_val_add1 = rptr_val + 1;

// full
assign instq_full_o = wptr_hi!=rptr_hi ? wptr_val - rptr_val < WRITE_WIDTH : rptr_val - wptr_val < READ_WIDTH;

// instQueue
always @(posedge clk) begin
    if(icache_valid_i && !instq_full_o) begin
        pc_r <= icache_pc_i;
    end
end

assign winst0 = icache_data_i[0*32+:32];
assign winst1 = icache_data_i[1*32+:32];
assign winst2 = icache_data_i[2*32+:32];
assign winst3 = icache_data_i[3*32+:32];
assign winst4 = icache_data_i[4*32+:32];
assign winst5 = icache_data_i[5*32+:32];
assign winst6 = icache_data_i[6*32+:32];
assign winst7 = icache_data_i[7*32+:32];
assign winst8 = icache_data_i[8*32+:32];
assign winst9 = icache_data_i[9*32+:32];
assign winst10 = icache_data_i[10*32+:32];
assign winst11 = icache_data_i[11*32+:32];
assign winst12 = icache_data_i[12*32+:32];
assign winst13 = icache_data_i[13*32+:32];
assign winst14 = icache_data_i[14*32+:32];
assign winst15 = icache_data_i[15*32+:32];

assign wptr_val_add1 = wptr_val + 1;
assign wptr_val_add2 = wptr_val + 2;
assign wptr_val_add3 = wptr_val + 3;
assign wptr_val_add4 = wptr_val + 4;
assign wptr_val_add5 = wptr_val + 5;
assign wptr_val_add6 = wptr_val + 6;
assign wptr_val_add7 = wptr_val + 7;
assign wptr_val_add8 = wptr_val + 8;
assign wptr_val_add9 = wptr_val + 9;
assign wptr_val_add10 = wptr_val + 10;
assign wptr_val_add11 = wptr_val + 11;
assign wptr_val_add12 = wptr_val + 12;
assign wptr_val_add13 = wptr_val + 13;
assign wptr_val_add14 = wptr_val + 14;
assign wptr_val_add15 = wptr_val + 15;

generate
for(i=0; i<DEPTH; i=i+1) begin

assign write_inst_queue[i] = icache_valid_i && !instq_full_o && 
                             (i==wptr_val      ||
                             i==wptr_val_add1 ||
                             i==wptr_val_add2 ||
                             i==wptr_val_add3 ||
                             i==wptr_val_add4 ||
                             i==wptr_val_add5 ||
                             i==wptr_val_add6 ||
                             i==wptr_val_add7 ||
                             i==wptr_val_add8 ||
                             i==wptr_val_add9 ||
                             i==wptr_val_add10 ||
                             i==wptr_val_add11 ||
                             i==wptr_val_add12 ||
                             i==wptr_val_add13 ||
                             i==wptr_val_add14 ||
                             i==wptr_val_add15);

assign read_inst_queue[i] = iq0_vld_o && iq1_vld_o && !stall_iq_i && 
                            (i==rptr_val ||
                             i==rptr_val_add1);

assign winstq_data[i] = {32{i==wptr_val}} & winst0 |
                        {32{i==wptr_val_add1}} & winst1 |
                        {32{i==wptr_val_add2}} & winst2 |
                        {32{i==wptr_val_add3}} & winst3 |
                        {32{i==wptr_val_add4}} & winst4 |
                        {32{i==wptr_val_add5}} & winst5 |
                        {32{i==wptr_val_add6}} & winst6 |
                        {32{i==wptr_val_add7}} & winst7 |
                        {32{i==wptr_val_add8}} & winst8 |
                        {32{i==wptr_val_add9}} & winst9 |
                        {32{i==wptr_val_add10}} & winst10 |
                        {32{i==wptr_val_add11}} & winst11 |
                        {32{i==wptr_val_add12}} & winst12 |
                        {32{i==wptr_val_add13}} & winst13 |
                        {32{i==wptr_val_add14}} & winst14 |
                        {32{i==wptr_val_add15}} & winst15;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        valid_queue[i] <= 1'b0;
    end
    if(flush_iq_i) begin
        valid_queue[i] <= 1'b0;
    end
    else if(write_inst_queue[i]) begin
        valid_queue[i] <= 1'b1;
        inst_queue[i]  <= winstq_data[i];
    end
    else if(read_inst_queue[i]) begin
        valid_queue[i] <= 1'b0;
    end
end

end
endgenerate

// output
assign iq0_vld_o = valid_queue[rptr_val];
assign iq0_pc_o  = pc_r + 0;
assign iq0_inst_o = inst_queue[rptr_val];

assign iq1_vld_o = valid_queue[rptr_val_add1];
assign iq1_pc_o  = pc_r + 4;
assign iq1_inst_o = inst_queue[rptr_val_add1];

endmodule