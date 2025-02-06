class axi_lite_mem_request;

    bit       write;
    bit[63:0] addr;
    bit[63:0] data;

    bit aw;
    bit w;

endclass

class axi_lite_slave_driver;

	virtual axi_lite_if vif;

    logic [63:0] mem[1024*1024];

    axi_lite_mem_request aw_q[$];
    axi_lite_mem_request w_q[$];
    axi_lite_mem_request ar_q[$];

	function new();
	endfunction

	function set_if(virtual axi_lite_if axi_lite_vif);
		this.vif = axi_lite_vif;
	endfunction

    task idle_aw_bus();
        vif.awready = 1'b0;
    endtask

    task idle_w_bus();
        vif.wready = 1'b0;
    endtask

    task idle_b_bus();
        vif.bvalid = 1'b0;
    endtask

    task idle_ar_bus();
        vif.arready = 1'b0;
    endtask

    task idle_r_bus();
        vif.rvalid = 1'b0;
    endtask

	task idle_bus();
        idle_aw_bus();
        idle_w_bus();
        idle_b_bus();
        idle_ar_bus();
        idle_r_bus();
	endtask

    task run();
        idle_bus();
        fork
            drv_aw();
            drv_w();
            drv_b();
            drv_ar();
            drv_r();
        join
    endtask

    task drv_aw();
        axi_lite_mem_request aw_req;
        forever begin
            @(vif.axi_lite_slave_cb);
            vif.axi_lite_slave_cb.awready <= $random();
            if(vif.axi_lite_monitor_cb.awvalid && vif.axi_lite_monitor_cb.awready) begin
                if(w_q.size() > 0 && !w_q[0].aw) begin
                    aw_req = w_q[0];
                    w_q.pop_front();
                end else begin
                    aw_req = new();
                end
                aw_req.addr = vif.axi_lite_monitor_cb.awaddr;
                aw_req.write = 1;
                aw_req.aw = 1;
                aw_q.push_back(aw_req);
            end
        end
    endtask

    task drv_w();
        axi_lite_mem_request w_req;
        forever begin
            @(vif.axi_lite_slave_cb);
            vif.axi_lite_slave_cb.wready <= $random();
            if(vif.axi_lite_monitor_cb.wvalid && vif.axi_lite_monitor_cb.wready) begin
                if(aw_q.size() > 0 && !aw_q[0].w) begin
                    w_req = aw_q[0];
                    aw_q.pop_front();
                end else begin
                    w_req = new();
                end
                w_req.data = vif.axi_lite_monitor_cb.wdata;
                w_req.w = 1;
                w_q.push_back(w_req);
            end
        end
    endtask

    task drv_b();
        axi_lite_mem_request b_req;
        forever begin
            @(vif.axi_lite_slave_cb);
            idle_b_bus();

            if(aw_q.size() > 0 && aw_q[0].w && aw_q[0].aw) begin
                b_req = aw_q[0];
                aw_q.pop_front();
            end
            else if(w_q.size() > 0 && w_q[0].w && w_q[0].aw) begin
                b_req = w_q[0];
                w_q.pop_front();
            end
            else
                b_req = null;
            
            if(b_req != null) begin
                repeat($random()%10) @(vif.axi_lite_slave_cb);
                vif.axi_lite_slave_cb.bvalid <= 1'b1;
                vif.axi_lite_slave_cb.bresp <= 2'b00; // no bus error

                mem[b_req.addr] = b_req.data;
            end
        end
    endtask

    task drv_ar();
        axi_lite_mem_request ar_req;
        forever begin
            @(vif.axi_lite_slave_cb);
            // $display("ar ready = %0d", vif.axi_lite_monitor_cb.arready);
            vif.axi_lite_slave_cb.arready <= $random();
            if(vif.axi_lite_monitor_cb.arvalid && vif.axi_lite_monitor_cb.arready) begin
                ar_req = new();
                ar_req.addr = vif.axi_lite_monitor_cb.araddr;
                ar_req.write = 0;
                ar_q.push_back(ar_req);
            end
        end
    endtask

    task drv_r();
        axi_lite_mem_request r_req;
        forever begin
            @(vif.axi_lite_slave_cb);
            idle_r_bus();

            if(ar_q.size() > 0) begin
                r_req = ar_q[0];
                ar_q.pop_front();
            end
            else
                r_req = null;
            
            if(r_req != null) begin
                repeat($random()%10) @(vif.axi_lite_slave_cb);
                vif.axi_lite_slave_cb.rvalid <= 1'b1;
                vif.axi_lite_slave_cb.rresp <= 2'b00; // no bus error
                vif.axi_lite_slave_cb.rdata <= mem[r_req.addr>>3];
            end
        end
    endtask

endclass
