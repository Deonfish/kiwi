module sram_model #(
    parameter DATAWIDTH = 32,
    parameter ADDRWIDTH = 18   // default 256KB
) (
    input                       CLK,
    input                       CEN,
    input                       WEN,
    input  [DATAWIDTH-1 : 0]    D,
    input  [ADDRWIDTH-1 : 0]    A,
    output [DATAWIDTH-1 : 0]    Q
);

localparam MEMDEPTH = 1<<ADDRWIDTH;

reg [DATAWIDTH-1:0] mem[MEMDEPTH];
reg [DATAWIDTH-1:0] rdata;

// write
always @(posedge CLK) begin
    if((~CEN) && (~WEN)) begin
        mem[A] <= D;
        //$display("sram_model: write addr=%x, data=%x", A<<2, D);
    end
end

// read
always @(posedge CLK) begin
    if((~CEN) && WEN) begin
        rdata <= mem[A];
        //$display("sram_model: read addr=%x, data=%x", A<<2, mem[A]);
    end
    else begin
        rdata <= {DATAWIDTH{1'b0}};
    end
end

assign Q = rdata;

// for simulation
//integer j;
//initial begin
//    for(j=0; j<MEMDEPTH; j=j+1) begin
//        mem[j] = {DATAWIDTH{1'b0}};
//    end
//end

endmodule