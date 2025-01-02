module BIU(
    input          clk,
    input          rst_n,
    // req
    input  [0:0]   req_vld_i,
    output [0:0]   req_ack_o,
    input  [0:0]   req_rd_i,
    input  [63:0]  req_addr_i,
    input  [511:0] req_wdata_i,
    // resp
    output [0:0]   resp_vld_o,
    input  [0:0]   resp_ack_i,
    output [511:0] resp_rdata_o,
    output [0:0]   resp_err_o,
    // axi4-lite
    output [0:0]   awvalid_o,
    input  [0:0]   awready_i,
    output [63:0]  awaddr_o,
    output [0:0]   awprot_o,
    output [0:0]   wvalid_o,
    input  [0:0]   wready_i,
    output [63:0]  wdata_o,
    output [7:0]   wstrb_o,
    input  [0:0]   bvalid_i,
    output [0:0]   bready_o,
    input  [1:0]   bresp_i,
    output [0:0]   arvalid_o,
    input  [0:0]   arready_i,
    output [63:0]  araddr_o,
    output [0:0]   arprot_o,
    input  [0:0]   rvalid_i,
    output [0:0]   rready_o,
    input  [63:0]  rdata_i,
    input  [1:0]   rresp_i
);

reg [0:0]                req_vld_r;
reg [0:0]                req_ack_r;
reg [0:0]                req_rd_r;
reg [63:0]               req_addr_r;
reg [511:0]              req_wdata_r;

reg [`BIU_REQQ_SIZE-1:0] reqq_vld_r;
reg                      reqq_rd_r[`BIU_REQQ_SIZE];
reg [63:0]               reqq_addr_r[`BIU_REQQ_SIZE];
reg [63:0]               reqq_wdata_r[`BIU_REQQ_SIZE];
reg [2:0]                reqq_rptr_r;
wire                     reqq_rptr_incr;

wire ar_finished;
wire aw_finished;
wire w_finished;
reg  aw_finished_r;
reg  w_finished_r;

reg [`BIU_RESPQ_SIZE-1:0] respq_vld_r;
reg [63:0]                respq_data_r[`BIU_RESPQ_SIZE];
reg [2:0]                 respq_wptr_r;
wire                      respq_wptr_incr;

// ------------- req channel ------------- //

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        req_vld_r <= 1'b0;
    end
    else if(req_vld_r) begin
        req_vld_r <= 1'b0;
    end
    else if(req_ack_o) begin
        req_vld_r   <= req_vld_i;
        req_rd_r    <= req_rd_i;
        req_addr_r  <= req_addr_i;
        req_wdata_r <= req_wdata_i;
    end
end

assign req_ack_o = ~req_vld_r | (~|reqq_vld_r);

// write reqq

genvar i;
generate
for(i=0; i<`BIU_REQQ_SIZE; i=i+1) begin

always @(posedge clk or negedge rst_n) begin
    if(@rst_n) begin
        reqq_vld_r[i] <= 'b0;
    end
    else if(req_vld_r) begin
        reqq_vld_r[i]   <= 1'b1;
        reqq_rd_r[i]    <= req_rd_r;
        reqq_addr_r[i]  <= req_addr_r + i*8;
        reqq_wdata_r[i] <= req_wdata_r[i*64+:64];
    end
    else if(reqq_rptr_incr && reqq_rptr_r == i) begin
        reqq_vld_r[i] <= 1'b0;
    end
end

end
endgenerate

// read reqq

assign reqq_rptr_incr = reqq_rd_r[reqq_rptr_r] && ar_finished ||
                        !reqq_rd_r[reqq_rptr_r] && (aw_finished || aw_finished_r) && (w_finished || aw_finished_r);

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        reqq_rptr_r <= 'b0;
    end
    else if(reqq_rptr_incr) begin
        reqq_rptr_r <= reqq_rptr_r + 1;
    end
end

assign ar_finished = arvalid_o & arready_i;
assign aw_finished = awvalid_o & awready_i;
assign w_finished  = wvalid_o & wready_i;

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        aw_finished_r <= 1'b0;
    end
    else if(reqq_rptr_incr) begin
        aw_finished_r <= 1'b0;
    end
    else if(aw_finished) begin
        aw_finished_r <= 1'b1;
    end
end

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        w_finished_r <= 1'b0;
    end
    else if(reqq_rptr_incr) begin
        w_finished_r <= 1'b0;
    end
    else if(w_finished) begin
        w_finished_r <= 1'b1;
    end
end

assign arvalid_o = reqq_vld_r[reqq_rptr_r] & reqq_rd_r[reqq_rptr_r];
assign araddr_o  = reqq_addr_r[reqq_rptr_r];
assign arprot_o  = 0;

assign awvalid_o = reqq_vld_r[reqq_rptr_r] & ~reqq_rd_r[reqq_rptr_r];
assign awaddr_o  = reqq_addr_r[reqq_rptr_r];
assign awprot_o  = 0;

assign wvalid_o  = reqq_vld_r[reqq_rptr_r] & ~reqq_rd_r[reqq_rptr_r];
assign wdata_o  = reqq_wdata_r[reqq_rptr_r];
assign wstrb_o  = 8'hff;

// ------------- resp channel ------------- //

assign bready_o = 1'b1;

generate
for(i=0; i<`BIU_RESPQ_SIZE; i=i+1) begin

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        respq_vld_r[i] <= 'b0;
    end
    else if(rvalid_i && rready_o && i == respq_wptr_r) begin
        respq_vld_r[i] <= 1'b1;
        respq_data_r[i] <= rdata_i;
    end
    else if(resp_vld_o & resp_ack_i) begin
        respq_vld_r[i] <= 1'b0;
    end
end

end
endgenerate

always @(posedge clk or negedge rst_n) begin
    if(!rst_n) begin
        respq_wptr_r = 'b0;
    end
    else if(respq_wptr_incr) begin
        respq_wptr_r = respq_wptr_r + 1;
    end
end

assign respq_wptr_incr = rvalid_i & rready_o;

assign rready_o = ~|respq_vld_r;

assign resp_vld_o = &respq_vld_r;
assign resp_rdata_o = {respq_data_r[7], respq_data_r[6], respq_data_r[5], respq_data_r[4], respq_data_r[3], respq_data_r[2], respq_data_r[1], respq_data_r[0]};
assign resp_err_o = 'b0;

endmodule