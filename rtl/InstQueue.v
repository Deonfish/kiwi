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
reg [63:0] pc_queue[DEPTH-1:0];
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

wire [63:0] winst_pc0;
wire [63:0] winst_pc1;
wire [63:0] winst_pc2;
wire [63:0] winst_pc3;
wire [63:0] winst_pc4;
wire [63:0] winst_pc5;
wire [63:0] winst_pc6;
wire [63:0] winst_pc7;
wire [63:0] winst_pc8;
wire [63:0] winst_pc9;
wire [63:0] winst_pc10;
wire [63:0] winst_pc11;
wire [63:0] winst_pc12;
wire [63:0] winst_pc13;
wire [63:0] winst_pc14;
wire [63:0] winst_pc15;

reg [31:0] winst0;
reg [31:0] winst1;
reg [31:0] winst2;
reg [31:0] winst3;
reg [31:0] winst4;
reg [31:0] winst5;
reg [31:0] winst6;
reg [31:0] winst7;
reg [31:0] winst8;
reg [31:0] winst9;
reg [31:0] winst10;
reg [31:0] winst11;
reg [31:0] winst12;
reg [31:0] winst13;
reg [31:0] winst14;
reg [31:0] winst15;

wire [15:0] write_vector;

wire [31:0] winstq_data[DEPTH-1:0];
wire [63:0] winstq_pc[DEPTH-1:0];

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
assign instq_full_o = wptr_hi!=rptr_hi && wptr_val == rptr_val;

// instQueue
always @(posedge clk) begin
    if(icache_valid_i && !instq_full_o) begin
        pc_r <= icache_pc_i;
    end
end

assign winst_pc0  = icache_pc_i + 4*0 ;
assign winst_pc1  = icache_pc_i + 4*1 ;
assign winst_pc2  = icache_pc_i + 4*2 ;
assign winst_pc3  = icache_pc_i + 4*3 ;
assign winst_pc4  = icache_pc_i + 4*4 ;
assign winst_pc5  = icache_pc_i + 4*5 ;
assign winst_pc6  = icache_pc_i + 4*6 ;
assign winst_pc7  = icache_pc_i + 4*7 ;
assign winst_pc8  = icache_pc_i + 4*8 ;
assign winst_pc9  = icache_pc_i + 4*9 ;
assign winst_pc10 = icache_pc_i + 4*10;
assign winst_pc11 = icache_pc_i + 4*11;
assign winst_pc12 = icache_pc_i + 4*12;
assign winst_pc13 = icache_pc_i + 4*13;
assign winst_pc14 = icache_pc_i + 4*14;
assign winst_pc15 = icache_pc_i + 4*15;

// assign winst0 = icache_data_i[0*32+:32];
// assign winst1 = icache_data_i[1*32+:32];
// assign winst2 = icache_data_i[2*32+:32];
// assign winst3 = icache_data_i[3*32+:32];
// assign winst4 = icache_data_i[4*32+:32];
// assign winst5 = icache_data_i[5*32+:32];
// assign winst6 = icache_data_i[6*32+:32];
// assign winst7 = icache_data_i[7*32+:32];
// assign winst8 = icache_data_i[8*32+:32];
// assign winst9 = icache_data_i[9*32+:32];
// assign winst10 = icache_data_i[10*32+:32];
// assign winst11 = icache_data_i[11*32+:32];
// assign winst12 = icache_data_i[12*32+:32];
// assign winst13 = icache_data_i[13*32+:32];
// assign winst14 = icache_data_i[14*32+:32];
// assign winst15 = icache_data_i[15*32+:32];

assign write_vector[0]  = 1'b1;
assign write_vector[1]  = icache_pc_i[5:2] <= 4'he;
assign write_vector[2]  = icache_pc_i[5:2] <= 4'hd;
assign write_vector[3]  = icache_pc_i[5:2] <= 4'hc;
assign write_vector[4]  = icache_pc_i[5:2] <= 4'hb;
assign write_vector[5]  = icache_pc_i[5:2] <= 4'ha;
assign write_vector[6]  = icache_pc_i[5:2] <= 4'h9;
assign write_vector[7]  = icache_pc_i[5:2] <= 4'h8;
assign write_vector[8]  = icache_pc_i[5:2] <= 4'h7;
assign write_vector[9]  = icache_pc_i[5:2] <= 4'h6;
assign write_vector[10] = icache_pc_i[5:2] <= 4'h5;
assign write_vector[11] = icache_pc_i[5:2] <= 4'h4;
assign write_vector[12] = icache_pc_i[5:2] <= 4'h3;
assign write_vector[13] = icache_pc_i[5:2] <= 4'h2;
assign write_vector[14] = icache_pc_i[5:2] <= 4'h1;
assign write_vector[15] = icache_pc_i[5:2] <= 4'h0;

always @(*) begin
    if(icache_pc_i[5:2]==4'h0) begin
        winst0  = icache_data_i[0*32+:32] ;
        winst1  = icache_data_i[1*32+:32] ;
        winst2  = icache_data_i[2*32+:32] ;
        winst3  = icache_data_i[3*32+:32] ;
        winst4  = icache_data_i[4*32+:32] ;
        winst5  = icache_data_i[5*32+:32] ;
        winst6  = icache_data_i[6*32+:32] ;
        winst7  = icache_data_i[7*32+:32] ;
        winst8  = icache_data_i[8*32+:32] ;
        winst9  = icache_data_i[9*32+:32] ;
        winst10 = icache_data_i[10*32+:32];
        winst11 = icache_data_i[11*32+:32];
        winst12 = icache_data_i[12*32+:32];
        winst13 = icache_data_i[13*32+:32];
        winst14 = icache_data_i[14*32+:32];
        winst15 = icache_data_i[15*32+:32];
    end
    else if(icache_pc_i[5:2]==4'h1) begin
        winst0  = icache_data_i[1*32+:32] ;
        winst1  = icache_data_i[2*32+:32] ;
        winst2  = icache_data_i[3*32+:32] ;
        winst3  = icache_data_i[4*32+:32] ;
        winst4  = icache_data_i[5*32+:32] ;
        winst5  = icache_data_i[6*32+:32] ;
        winst6  = icache_data_i[7*32+:32] ;
        winst7  = icache_data_i[8*32+:32] ;
        winst8  = icache_data_i[9*32+:32] ;
        winst9  = icache_data_i[10*32+:32];
        winst10 = icache_data_i[11*32+:32];
        winst11 = icache_data_i[12*32+:32];
        winst12 = icache_data_i[13*32+:32];
        winst13 = icache_data_i[14*32+:32];
        winst14 = icache_data_i[15*32+:32];
        winst15 = 'b0;
    end
    else if(icache_pc_i[5:2]==4'h2) begin
        winst0  = icache_data_i[2*32+:32] ;
        winst1  = icache_data_i[3*32+:32] ;
        winst2  = icache_data_i[4*32+:32] ;
        winst3  = icache_data_i[5*32+:32] ;
        winst4  = icache_data_i[6*32+:32] ;
        winst5  = icache_data_i[7*32+:32] ;
        winst6  = icache_data_i[8*32+:32] ;
        winst7  = icache_data_i[9*32+:32] ;
        winst8  = icache_data_i[10*32+:32];
        winst9  = icache_data_i[11*32+:32];
        winst10 = icache_data_i[12*32+:32];
        winst11 = icache_data_i[13*32+:32];
        winst12 = icache_data_i[14*32+:32];
        winst13 = icache_data_i[15*32+:32];
        winst14 = 'b0;
        winst15 = 'b0;
    end
    else if(icache_pc_i[5:2]==4'h3) begin
        winst0  = icache_data_i[3*32+:32] ;
        winst1  = icache_data_i[4*32+:32] ;
        winst2  = icache_data_i[5*32+:32] ;
        winst3  = icache_data_i[6*32+:32] ;
        winst4  = icache_data_i[7*32+:32] ;
        winst5  = icache_data_i[8*32+:32] ;
        winst6  = icache_data_i[9*32+:32] ;
        winst7  = icache_data_i[10*32+:32];
        winst8  = icache_data_i[11*32+:32];
        winst9  = icache_data_i[12*32+:32];
        winst10 = icache_data_i[13*32+:32];
        winst11 = icache_data_i[14*32+:32];
        winst12 = icache_data_i[15*32+:32];
        winst13 = 'b0;
        winst14 = 'b0;
        winst15 = 'b0;
    end
    else if(icache_pc_i[5:2]==4'h4) begin
        winst0  = icache_data_i[4*32+:32] ;
        winst1  = icache_data_i[5*32+:32] ;
        winst2  = icache_data_i[6*32+:32] ;
        winst3  = icache_data_i[7*32+:32] ;
        winst4  = icache_data_i[8*32+:32] ;
        winst5  = icache_data_i[9*32+:32] ;
        winst6  = icache_data_i[10*32+:32];
        winst7  = icache_data_i[11*32+:32];
        winst8  = icache_data_i[12*32+:32];
        winst9  = icache_data_i[13*32+:32];
        winst10 = icache_data_i[14*32+:32];
        winst11 = icache_data_i[15*32+:32];
        winst12 = 'b0;
        winst13 = 'b0;
        winst14 = 'b0;
        winst15 = 'b0;
    end
    else if(icache_pc_i[5:2]==4'h5) begin
        winst0  = icache_data_i[5*32+:32] ;
        winst1  = icache_data_i[6*32+:32] ;
        winst2  = icache_data_i[7*32+:32] ;
        winst3  = icache_data_i[8*32+:32] ;
        winst4  = icache_data_i[9*32+:32] ;
        winst5  = icache_data_i[10*32+:32];
        winst6  = icache_data_i[11*32+:32];
        winst7  = icache_data_i[12*32+:32];
        winst8  = icache_data_i[13*32+:32];
        winst9  = icache_data_i[14*32+:32];
        winst10 = icache_data_i[15*32+:32];
        winst11 = 'b0;
        winst12 = 'b0;
        winst13 = 'b0;
        winst14 = 'b0;
        winst15 = 'b0;
    end
    else if(icache_pc_i[5:2]==4'h6) begin
        winst0  = icache_data_i[6*32+:32] ;
        winst1  = icache_data_i[7*32+:32] ;
        winst2  = icache_data_i[8*32+:32] ;
        winst3  = icache_data_i[9*32+:32] ;
        winst4  = icache_data_i[10*32+:32];
        winst5  = icache_data_i[11*32+:32];
        winst6  = icache_data_i[12*32+:32];
        winst7  = icache_data_i[13*32+:32];
        winst8  = icache_data_i[14*32+:32];
        winst9  = icache_data_i[15*32+:32];
        winst10 = 'b0;
        winst11 = 'b0;
        winst12 = 'b0;
        winst13 = 'b0;
        winst14 = 'b0;
        winst15 = 'b0;
    end
    else if(icache_pc_i[5:2]==4'h7) begin
        winst0  = icache_data_i[7*32+:32] ;
        winst1  = icache_data_i[8*32+:32] ;
        winst2  = icache_data_i[9*32+:32] ;
        winst3  = icache_data_i[10*32+:32];
        winst4  = icache_data_i[11*32+:32];
        winst5  = icache_data_i[12*32+:32];
        winst6  = icache_data_i[13*32+:32];
        winst7  = icache_data_i[14*32+:32];
        winst8  = icache_data_i[15*32+:32];
        winst9  = 'b0;
        winst10 = 'b0;
        winst11 = 'b0;
        winst12 = 'b0;
        winst13 = 'b0;
        winst14 = 'b0;
        winst15 = 'b0;
    end
    else if(icache_pc_i[5:2]==4'h8) begin
        winst0  = icache_data_i[8*32+:32] ;
        winst1  = icache_data_i[9*32+:32] ;
        winst2  = icache_data_i[10*32+:32];
        winst3  = icache_data_i[11*32+:32];
        winst4  = icache_data_i[12*32+:32];
        winst5  = icache_data_i[13*32+:32];
        winst6  = icache_data_i[14*32+:32];
        winst7  = icache_data_i[15*32+:32];
        winst8  = 'b0;
        winst9  = 'b0;
        winst10 = 'b0;
        winst11 = 'b0;
        winst12 = 'b0;
        winst13 = 'b0;
        winst14 = 'b0;
        winst15 = 'b0;
    end
    else if(icache_pc_i[5:2]==4'h9) begin
        winst0  = icache_data_i[9*32+:32] ;
        winst1  = icache_data_i[10*32+:32];
        winst2  = icache_data_i[11*32+:32];
        winst3  = icache_data_i[12*32+:32];
        winst4  = icache_data_i[13*32+:32];
        winst5  = icache_data_i[14*32+:32];
        winst6  = icache_data_i[15*32+:32];
        winst7  = 'b0;
        winst8  = 'b0;
        winst9  = 'b0;
        winst10 = 'b0;
        winst11 = 'b0;
        winst12 = 'b0;
        winst13 = 'b0;
        winst14 = 'b0;
        winst15 = 'b0;
    end
    else if(icache_pc_i[5:2]==4'ha) begin
        winst0  = icache_data_i[10*32+:32];
        winst1  = icache_data_i[11*32+:32];
        winst2  = icache_data_i[12*32+:32];
        winst3  = icache_data_i[13*32+:32];
        winst4  = icache_data_i[14*32+:32];
        winst5  = icache_data_i[15*32+:32];
        winst6  = 'b0;
        winst7  = 'b0;
        winst8  = 'b0;
        winst9  = 'b0;
        winst10 = 'b0;
        winst11 = 'b0;
        winst12 = 'b0;
        winst13 = 'b0;
        winst14 = 'b0;
        winst15 = 'b0;
    end
    else if(icache_pc_i[5:2]==4'hb) begin
        winst0  = icache_data_i[11*32+:32];
        winst1  = icache_data_i[12*32+:32];
        winst2  = icache_data_i[13*32+:32];
        winst3  = icache_data_i[14*32+:32];
        winst4  = icache_data_i[15*32+:32];
        winst5  = 'b0;
        winst6  = 'b0;
        winst7  = 'b0;
        winst8  = 'b0;
        winst9  = 'b0;
        winst10 = 'b0;
        winst11 = 'b0;
        winst12 = 'b0;
        winst13 = 'b0;
        winst14 = 'b0;
        winst15 = 'b0;
    end
    else if(icache_pc_i[5:2]==4'hc) begin
        winst0  = icache_data_i[12*32+:32];
        winst1  = icache_data_i[13*32+:32];
        winst2  = icache_data_i[14*32+:32];
        winst3  = icache_data_i[15*32+:32];
        winst4  = 'b0;
        winst5  = 'b0;
        winst6  = 'b0;
        winst7  = 'b0;
        winst8  = 'b0;
        winst9  = 'b0;
        winst10 = 'b0;
        winst11 = 'b0;
        winst12 = 'b0;
        winst13 = 'b0;
        winst14 = 'b0;
        winst15 = 'b0;
    end
    else if(icache_pc_i[5:2]==4'hd) begin
        winst0  = icache_data_i[13*32+:32];
        winst1  = icache_data_i[14*32+:32];
        winst2  = icache_data_i[15*32+:32];
        winst3  = 'b0;
        winst4  = 'b0;
        winst5  = 'b0;
        winst6  = 'b0;
        winst7  = 'b0;
        winst8  = 'b0;
        winst9  = 'b0;
        winst10 = 'b0;
        winst11 = 'b0;
        winst12 = 'b0;
        winst13 = 'b0;
        winst14 = 'b0;
        winst15 = 'b0;
    end
    else if(icache_pc_i[5:2]==4'he) begin
        winst0  = icache_data_i[14*32+:32];
        winst1  = icache_data_i[15*32+:32];
        winst2  = 'b0;
        winst3  = 'b0;
        winst4  = 'b0;
        winst5  = 'b0;
        winst6  = 'b0;
        winst7  = 'b0;
        winst8  = 'b0;
        winst9  = 'b0;
        winst10 = 'b0;
        winst11 = 'b0;
        winst12 = 'b0;
        winst13 = 'b0;
        winst14 = 'b0;
        winst15 = 'b0;
    end
    else begin
        winst0  = icache_data_i[15*32+:32];
        winst1  = 'b0;
        winst2  = 'b0;
        winst3  = 'b0;
        winst4  = 'b0;
        winst5  = 'b0;
        winst6  = 'b0;
        winst7  = 'b0;
        winst8  = 'b0;
        winst9  = 'b0;
        winst10 = 'b0;
        winst11 = 'b0;
        winst12 = 'b0;
        winst13 = 'b0;
        winst14 = 'b0;
        winst15 = 'b0;
    end
end

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
                             (i==wptr_val      && write_vector[0] ||
                             i==wptr_val_add1  && write_vector[1] ||
                             i==wptr_val_add2  && write_vector[2] ||
                             i==wptr_val_add3  && write_vector[3] ||
                             i==wptr_val_add4  && write_vector[4] ||
                             i==wptr_val_add5  && write_vector[5] ||
                             i==wptr_val_add6  && write_vector[6] ||
                             i==wptr_val_add7  && write_vector[7] ||
                             i==wptr_val_add8  && write_vector[8] ||
                             i==wptr_val_add9  && write_vector[9] ||
                             i==wptr_val_add10 && write_vector[10] ||
                             i==wptr_val_add11 && write_vector[11] ||
                             i==wptr_val_add12 && write_vector[12] ||
                             i==wptr_val_add13 && write_vector[13] ||
                             i==wptr_val_add14 && write_vector[14] ||
                             i==wptr_val_add15 && write_vector[15]);

assign read_inst_queue[i] = iq0_vld_o && iq1_vld_o && !stall_iq_i && 
                            (i==rptr_val ||
                             i==rptr_val_add1);

assign winstq_pc[i] = {32{i==wptr_val}}       & winst_pc0  |
                      {32{i==wptr_val_add1}}  & winst_pc1  |
                      {32{i==wptr_val_add2}}  & winst_pc2  |
                      {32{i==wptr_val_add3}}  & winst_pc3  |
                      {32{i==wptr_val_add4}}  & winst_pc4  |
                      {32{i==wptr_val_add5}}  & winst_pc5  |
                      {32{i==wptr_val_add6}}  & winst_pc6  |
                      {32{i==wptr_val_add7}}  & winst_pc7  |
                      {32{i==wptr_val_add8}}  & winst_pc8  |
                      {32{i==wptr_val_add9}}  & winst_pc9  |
                      {32{i==wptr_val_add10}} & winst_pc10 |
                      {32{i==wptr_val_add11}} & winst_pc11 |
                      {32{i==wptr_val_add12}} & winst_pc12 |
                      {32{i==wptr_val_add13}} & winst_pc13 |
                      {32{i==wptr_val_add14}} & winst_pc14 |
                      {32{i==wptr_val_add15}} & winst_pc15 ;

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
        pc_queue[i]    <= winstq_pc[i];
    end
    else if(read_inst_queue[i]) begin
        valid_queue[i] <= 1'b0;
    end
end

end
endgenerate

// output
assign iq0_vld_o = valid_queue[rptr_val];
assign iq0_pc_o  = pc_queue[rptr_val];
assign iq0_inst_o = inst_queue[rptr_val];

assign iq1_vld_o = valid_queue[rptr_val_add1];
assign iq1_pc_o  = pc_queue[rptr_val_add1];
assign iq1_inst_o = inst_queue[rptr_val_add1];

endmodule