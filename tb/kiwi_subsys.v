module kiwi_subsys (
    input clk,
    input rst_n,
    axi_lite_if ibiu_axi_if,
    axi_lite_if dbiu_axi_if
);

wire        ibiu_axi_awvalid;
wire [63:0] ibiu_axi_awaddr;
wire [2:0]  ibiu_axi_awprot;
wire        ibiu_axi_awready;
wire        ibiu_axi_wvalid;
wire [63:0] ibiu_axi_wdata;
wire [7:0]  ibiu_axi_wstrb;
wire        ibiu_axi_wready;
wire        ibiu_axi_bvalid;
wire [1:0]  ibiu_axi_bresp;
wire        ibiu_axi_bready;
wire        ibiu_axi_arvalid;
wire [63:0] ibiu_axi_araddr;
wire [2:0]  ibiu_axi_arprot;
wire        ibiu_axi_arready;
wire        ibiu_axi_rvalid;
wire [63:0] ibiu_axi_rdata;
wire [1:0]  ibiu_axi_rresp;
wire        ibiu_axi_rready;
wire        dbiu_axi_awvalid;
wire [63:0] dbiu_axi_awaddr;
wire [2:0]  dbiu_axi_awprot;
wire        dbiu_axi_awready;
wire        dbiu_axi_wvalid;
wire [63:0] dbiu_axi_wdata;
wire [7:0]  dbiu_axi_wstrb;
wire        dbiu_axi_wready;
wire        dbiu_axi_bvalid;
wire [1:0]  dbiu_axi_bresp;
wire        dbiu_axi_bready;
wire        dbiu_axi_arvalid;
wire [63:0] dbiu_axi_araddr;
wire [2:0]  dbiu_axi_arprot;
wire        dbiu_axi_arready;
wire        dbiu_axi_rvalid;
wire [63:0] dbiu_axi_rdata;
wire [1:0]  dbiu_axi_rresp;
wire        dbiu_axi_rready;

Kiwi u_CPU (
    .clk(clk),
    .rst_n(rst_n),
    // IBIU axi-lite interface
    .ibiu_axi_awvalid(ibiu_axi_awvalid),
    .ibiu_axi_awaddr(ibiu_axi_awaddr),
    .ibiu_axi_awprot(ibiu_axi_awprot),
    .ibiu_axi_awready(ibiu_axi_awready),
    .ibiu_axi_wvalid(ibiu_axi_wvalid),
    .ibiu_axi_wdata(ibiu_axi_wdata),
    .ibiu_axi_wstrb(ibiu_axi_wstrb),
    .ibiu_axi_wready(ibiu_axi_wready),
    .ibiu_axi_bvalid(ibiu_axi_bvalid),
    .ibiu_axi_bresp(ibiu_axi_bresp),
    .ibiu_axi_bready(ibiu_axi_bready),
    .ibiu_axi_arvalid(ibiu_axi_arvalid),
    .ibiu_axi_araddr(ibiu_axi_araddr),
    .ibiu_axi_arprot(ibiu_axi_arprot),
    .ibiu_axi_arready(ibiu_axi_arready),
    .ibiu_axi_rvalid(ibiu_axi_rvalid),
    .ibiu_axi_rdata(ibiu_axi_rdata),
    .ibiu_axi_rresp(ibiu_axi_rresp),
    .ibiu_axi_rready(ibiu_axi_rready),
    // DBIU axi-lite interface
    .dbiu_axi_awvalid(dbiu_axi_awvalid),
    .dbiu_axi_awaddr(dbiu_axi_awaddr),
    .dbiu_axi_awprot(dbiu_axi_awprot),
    .dbiu_axi_awready(dbiu_axi_awready),
    .dbiu_axi_wvalid(dbiu_axi_wvalid),
    .dbiu_axi_wdata(dbiu_axi_wdata),
    .dbiu_axi_wstrb(dbiu_axi_wstrb),
    .dbiu_axi_wready(dbiu_axi_wready),
    .dbiu_axi_bvalid(dbiu_axi_bvalid),
    .dbiu_axi_bresp(dbiu_axi_bresp),
    .dbiu_axi_bready(dbiu_axi_bready),
    .dbiu_axi_arvalid(dbiu_axi_arvalid),
    .dbiu_axi_araddr(dbiu_axi_araddr),
    .dbiu_axi_arprot(dbiu_axi_arprot),
    .dbiu_axi_arready(dbiu_axi_arready),
    .dbiu_axi_rvalid(dbiu_axi_rvalid),
    .dbiu_axi_rdata(dbiu_axi_rdata),
    .dbiu_axi_rresp(dbiu_axi_rresp),
    .dbiu_axi_rready(dbiu_axi_rready)
);

assign ibiu_axi_if.aclk     = clk;
assign ibiu_axi_if.aresetn  = rst_n;
assign ibiu_axi_if.awvalid  = ibiu_axi_awvalid;
assign ibiu_axi_if.awaddr   = ibiu_axi_awaddr;
assign ibiu_axi_if.awprot   = ibiu_axi_awprot;
assign ibiu_axi_awready     = ibiu_axi_if.awready;
assign ibiu_axi_if.wvalid   = ibiu_axi_wvalid;
assign ibiu_axi_if.wdata    = ibiu_axi_wdata;
assign ibiu_axi_if.wstrb    = ibiu_axi_wstrb;
assign ibiu_axi_wready      = ibiu_axi_if.wready;
assign ibiu_axi_if.bready   = ibiu_axi_bready;
assign ibiu_axi_bvalid      = ibiu_axi_if.bvalid;
assign ibiu_axi_bresp       = ibiu_axi_if.bresp;
assign ibiu_axi_if.arvalid  = ibiu_axi_arvalid;
assign ibiu_axi_if.araddr   = ibiu_axi_araddr;
assign ibiu_axi_if.arprot   = ibiu_axi_arprot;
assign ibiu_axi_arready     = ibiu_axi_if.arready;
assign ibiu_axi_if.rready   = ibiu_axi_rready;
assign ibiu_axi_rvalid      = ibiu_axi_if.rvalid;
assign ibiu_axi_rdata       = ibiu_axi_if.rdata;
assign ibiu_axi_rresp       = ibiu_axi_if.rresp;

assign dbiu_axi_if.aclk     = clk;
assign dbiu_axi_if.aresetn  = rst_n;
assign dbiu_axi_if.awvalid  = dbiu_axi_awvalid;
assign dbiu_axi_if.awaddr   = dbiu_axi_awaddr;
assign dbiu_axi_if.awprot   = dbiu_axi_awprot;
assign dbiu_axi_awready     = dbiu_axi_if.awready;
assign dbiu_axi_if.wvalid   = dbiu_axi_wvalid;
assign dbiu_axi_if.wdata    = dbiu_axi_wdata;
assign dbiu_axi_if.wstrb    = dbiu_axi_wstrb;
assign dbiu_axi_wready      = dbiu_axi_if.wready;
assign dbiu_axi_if.bready   = dbiu_axi_bready;
assign dbiu_axi_bvalid      = dbiu_axi_if.bvalid;
assign dbiu_axi_bresp       = dbiu_axi_if.bresp;
assign dbiu_axi_if.arvalid  = dbiu_axi_arvalid;
assign dbiu_axi_if.araddr   = dbiu_axi_araddr;
assign dbiu_axi_if.arprot   = dbiu_axi_arprot;
assign dbiu_axi_arready     = dbiu_axi_if.arready;
assign dbiu_axi_if.rready   = dbiu_axi_rready;
assign dbiu_axi_rvalid      = dbiu_axi_if.rvalid;
assign dbiu_axi_rdata       = dbiu_axi_if.rdata;
assign dbiu_axi_rresp       = dbiu_axi_if.rresp;

endmodule
