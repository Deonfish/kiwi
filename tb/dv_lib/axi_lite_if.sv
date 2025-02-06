interface axi_lite_if();
    parameter MAX_ADDR_WIDTH = 32;
    parameter MAX_DATA_WIDTH = 32;

    logic                                aclk;
    logic                                aresetn;

    logic                                awvalid;
    logic                                awready;
    logic [MAX_ADDR_WIDTH-1:0]           awaddr;
    logic [2:0]                          awprot;

    logic                                wvalid;
    logic                                wready;
    logic [MAX_DATA_WIDTH-1:0]           wdata;
    logic [MAX_DATA_WIDTH/8-1:0]         wstrb;

    logic                                bready;
    logic                                bvalid;
    logic [1:0]                          bresp;

    logic                                arvalid;
    logic                                arready;
    logic [MAX_ADDR_WIDTH-1:0]           araddr;
    logic [2:0]                          arprot;

    logic                                rready;
    logic                                rvalid;
    logic [1:0]                          rresp;
    logic [MAX_DATA_WIDTH-1:0]           rdata;

    clocking axi_lite_master_cb @(posedge aclk);
        output      awvalid;
        input       awready;
        output      awaddr;
        output      awprot;
        output      wvalid;
        input       wready;
        output      wdata;
        output      wstrb;
        output      bready;
        input       bvalid;
        input       bresp;
        output      arvalid;
        input       arready;
        output      araddr;
        output      arprot;
        output      rready;
        input       rvalid;
        input       rresp;
        input       rdata;
    endclocking

    clocking axi_lite_slave_cb @(posedge aclk);
        input       awvalid;
        output      awready;
        input       awaddr;
        input       awprot;
        input       wvalid;
        output      wready;
        input       wdata;
        input       wstrb;
        input       bready;
        output      bvalid;
        output      bresp;
        input       arvalid;
        output      arready;
        input       araddr;
        input       arprot;
        output      rvalid;
        input       rready;
        output      rresp;
        output      rdata;
    endclocking

    clocking axi_lite_monitor_cb @(posedge aclk);
        input      awvalid;
        input      awready;
        input      awaddr;
        input      awprot;
        input      wvalid;
        input      wready;
        input      wdata;
        input      wstrb;
        input      bready;
        input      bvalid;
        input      bresp;
        input      arvalid;
        input      arready;
        input      araddr;
        input      arprot;
        input      rvalid;
        input      rready;
        input      rresp;
        input      rdata;
    endclocking
    
endinterface