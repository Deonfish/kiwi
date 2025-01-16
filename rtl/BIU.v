module BIU(
    input                   clk,
    input                   rst_n,
    // cache req
    input      [0:0]       cache_req_vld_i,
    output reg [0:0]       cache_req_rdy_o,
    input      [0:0]       cache_req_rd_i,
    input      [63:0]      cache_req_addr_i,
    input      [511:0]     cache_req_wdata_i,
    // cache resp
    output reg [0:0]       cache_resp_vld_o,
    input      [0:0]       cache_resp_rdy_i,
    output reg [511:0]     cache_resp_rdata_o,
    output reg [0:0]       cache_resp_err_o,
    // uncache req
    input      [0:0]       uncache_req_vld_i,
    output reg [0:0]       uncache_req_rdy_o,
    input      [0:0]       uncache_req_rd_i,
    input      [63:0]      uncache_req_addr_i,
    input      [63:0]      uncache_req_wdata_i,
    // uncache resp
    output reg [0:0]       uncache_resp_vld_o,
    input      [0:0]       uncache_resp_rdy_i,
    output reg [63:0]      uncache_resp_rdata_o,
    output reg [0:0]       uncache_resp_err_o,
    // axi3-lite
    output reg [0:0]       awvalid_o,
    input      [0:0]       awready_i,
    output reg [63:0]      awaddr_o,
    output reg [2:0]       awprot_o,
    output reg [0:0]       wvalid_o,
    input      [0:0]       wready_i,
    output reg [63:0]      wdata_o,
    output reg [7:0]       wstrb_o,
    input      [0:0]       bvalid_i,
    output reg [0:0]       bready_o,
    input      [1:0]       bresp_i,
    output reg [0:0]       arvalid_o,
    input      [0:0]       arready_i,
    output reg [63:0]      araddr_o,
    output reg [2:0]       arprot_o,
    input      [0:0]       rvalid_i,
    output reg [0:0]       rready_o,
    input      [63:0]      rdata_i,
    input      [1:0]       rresp_i
);

localparam  ST_IDLE         = 3'd0,
            ST_SEND_ADDR    = 3'd1,
            ST_SEND_WRITE   = 3'd2,
            ST_WAIT_RESP    = 3'd3,
            ST_RESP         = 3'd4;

reg [2:0]  cur_state, next_state;

reg [2:0]  beat_count;  // cache request beat count

reg [63:0] req_addr;
reg [511:0] req_wdata;
reg [0:0]   req_is_read;    // read=1 / write=0
reg [0:0]   req_is_cache;   // cache=1 / uncache=0

reg [511:0] read_data_accum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cur_state <= ST_IDLE;
    end else begin
        cur_state <= next_state;
    end
end

always @(*) begin
    next_state = cur_state;
    case (cur_state)
        ST_IDLE: begin
            if (cache_req_vld_i) begin
                next_state = ST_SEND_ADDR;
            end else if (uncache_req_vld_i) begin
                next_state = ST_SEND_ADDR;
            end
        end

        ST_SEND_ADDR: begin
            if(req_is_cache) begin
                if(beat_count == 3'd7 && (req_is_read && arready_i || !req_is_read && awready_i)) begin
                    next_state = ST_WAIT_RESP;
                end else begin
                    next_state = ST_SEND_ADDR;
                end
            end else begin
                if(req_is_read && arready_i || !req_is_read && awready_i) begin
                    next_state = ST_WAIT_RESP;
                end else begin
                    next_state = ST_SEND_ADDR;
                end
            end
        end

        ST_SEND_WRITE: begin
            if(beat_count == 3'd7 && awready_i) begin
                next_state = ST_RESP;
            end else begin
                next_state = ST_SEND_WRITE;
            end
        end

        ST_WAIT_RESP: begin
            if(req_is_cache) begin
                if(beat_count == 3'd7 && rvalid_i) begin
                    next_state = ST_RESP;
                end
                else begin
                    next_state = ST_WAIT_RESP;
                end
            end
            else begin
                if(rvalid_i) begin
                    next_state = ST_RESP;
                end else begin
                    next_state = ST_WAIT_RESP;
                end
            end
        end

        ST_RESP: begin
            if(req_is_cache && cache_resp_vld_o || !req_is_cache && uncache_resp_rdy_i) begin
                next_state = ST_IDLE;
            end
            else begin
                next_state = ST_RESP;
            end
        end

        default: next_state = ST_IDLE;
    endcase
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        cache_req_rdy_o   <= 1'b0;
        uncache_req_rdy_o <= 1'b0;
        arvalid_o         <= 1'b0;
        awvalid_o         <= 1'b0;
        wvalid_o          <= 1'b0;
        bready_o          <= 1'b1;
        rready_o          <= 1'b1;
        cache_resp_vld_o  <= 1'b0;
        uncache_resp_vld_o<= 1'b0;
        read_data_accum   <= 512'b0;
        beat_count        <= 3'd0;
    end else begin
        // Defaults
        cache_req_rdy_o    <= 1'b0;
        uncache_req_rdy_o  <= 1'b0;
        cache_resp_vld_o   <= 1'b0;
        uncache_resp_vld_o <= 1'b0;

        case (cur_state)
            ST_IDLE: begin
                cache_req_rdy_o   <= 1'b1;
                uncache_req_rdy_o <= 1'b1;
                beat_count        <= 3'd0;
                if (cache_req_vld_i) begin
                    req_is_cache <= 1'b1;
                    req_is_read  <= cache_req_rd_i;
                    req_addr     <= cache_req_addr_i;
                    req_wdata    <= cache_req_wdata_i;
                end else if (uncache_req_vld_i) begin
                    req_is_cache <= 1'b0;
                    req_is_read  <= uncache_req_rd_i;
                    req_addr     <= uncache_req_addr_i;
                    req_wdata    <= {448'b0, {uncache_req_wdata_i}};
                end
            end

            ST_SEND_ADDR: begin
                if (req_is_read) begin
                    arvalid_o <= 1'b1;
                    araddr_o  <= req_addr + (beat_count << 3);
                    if(req_is_cache && arvalid_o && arready_i) begin
                        beat_count <= beat_count + 1'b1;
                    end
                end else begin
                    awvalid_o <= 1'b1;
                    awaddr_o  <= req_addr + (beat_count << 3);
                    if(req_is_cache && awvalid_o && awready_i) begin
                        beat_count <= beat_count + 1'b1;
                    end
                end
            end

            ST_SEND_WRITE: begin
                wvalid_o <= 1'b1;
                wdata_o <= req_wdata[ (beat_count*64) +: 64];
                wstrb_o <= 8'hFF;
                if(req_is_cache && wvalid_o && wready_i) begin
                    beat_count <= beat_count + 1'b1;
                end
            end

            ST_WAIT_RESP: begin
                if (rvalid_i) begin
                    read_data_accum[(beat_count*64) +: 64] <= rdata_i;
                    if (req_is_cache) begin
                        beat_count <= beat_count + 1'b1;
                    end
                end
            end

            ST_RESP: begin
                if (req_is_cache) begin
                    cache_resp_vld_o   <= 1'b1;
                    cache_resp_rdata_o <= read_data_accum; 
                end else begin
                    uncache_resp_vld_o   <= 1'b1;
                    uncache_resp_rdata_o <= read_data_accum[63:0];
                end
            end

            default: ;
        endcase
    end
end

endmodule