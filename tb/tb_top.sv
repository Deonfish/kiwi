//~ `New testbench
`timescale  1ns / 1ps

module tb_TinyCore;

// TinyCore Parameters
parameter PERIOD  = 10;

reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;

longint bubble;
longint instruction;
longint flush_recovery;
longint frontend_bound;
longint backend_bound;
longint retire;
longint bad_speculation;

longint total_slots;
longint flush_cycle;

function void cal_print_tma();

	flush_recovery = flush_cycle * 4*2;
	frontend_bound = frontend_bound - flush_recovery;
	bad_speculation = instruction - retire;

	$display("| Rtire | Bad Speculation | Flush Recovery | Frontend Bound | Backend Bound |");
	$display("| %.1f  |       %.1f      |      %.1f      |      %.1f      |     %.1f      |", 
		retire/total_slots, bad_speculation/total_slots, flush_recovery/total_slots, frontend_bound/total_slots, backend_bound/total_slots);

endfunction

initial
begin
    forever #(PERIOD/2)  clk=~clk;
end

initial
begin
    #(PERIOD*2) rst_n  =  1;
end

// -------------------- dut --------------------

axi_lite_if #(64, 64) ibiu_axi_if();
axi_lite_if #(64, 64) dbiu_axi_if();

kiwi_subsys  u_kiwi_subsys (
    .clk                     ( clk     ),
    .rst_n                   ( rst_n   ),
    .ibiu_axi_if			 (ibiu_axi_if),
    .dbiu_axi_if			 (dbiu_axi_if)
);

// -------------------- axi_lite_if --------------------

axi_lite_slave_driver ibiu_axi_driver;
axi_lite_slave_driver dbiu_axi_driver;

initial begin
    ibiu_axi_driver = new();
    dbiu_axi_driver = new();
    ibiu_axi_driver.set_if(ibiu_axi_if);
    dbiu_axi_driver.set_if(dbiu_axi_if);
    fork
        ibiu_axi_driver.run();
        dbiu_axi_driver.run();
    join
end

// -------------------- init code and data memory --------------------

bit[31:0] code_mem[1024*1024];
bit[31:0] data_mem[1024*1024];

// init code and data memory
initial begin
	$readmemh("../tests/programs/hello.text.hex", code_mem);
	$readmemh("../tests/programs/hello.data.hex", data_mem);
	$display("code initing to mem...");
	for(int i=0; i<1024*1024/2; i++) begin
		ibiu_axi_driver.mem[i][31:0] = code_mem[i*2];
		dbiu_axi_driver.mem[i][31:0] = data_mem[i*2];
		ibiu_axi_driver.mem[i][63:32] = code_mem[i*2+1];
		dbiu_axi_driver.mem[i][63:32] = data_mem[i*2+1];
		//if(i<2000) begin
		//	$display("code_mem[%0d] = %0h", i, u_TinyCore.itcm.mem[i]);
		//	$display("data_mem[%0d] = %0h", i, u_TinyCore.dtcm.mem[i]);
		//end
	end
	$display("code init to mem done!");
end

// reset registers
initial begin
	bubble			= 0;
	instruction		= 0;
	flush_recovery	= 0;
	frontend_bound	= 0;
	backend_bound	= 0;
	retire			= 0;
	bad_speculation	= 0;
	total_slots		= 0;
	flush_cycle		= 0;

	for(int i=0; i<64; ++i) begin
		u_kiwi_subsys.u_CPU.u_Operands.u_regfile.registers[i] = 0;
	end
end

// sim finish control
always @(posedge clk) begin
	if(tb_TinyCore.u_kiwi_subsys.u_CPU.u_Decoder.inst0_decoder_valid_pre_o) begin
		if(tb_TinyCore.u_kiwi_subsys.u_CPU.u_Decoder.inst0_decoder_inst_o == 32'h0000_006b) begin
			cal_print_tma();
			$display("--------------- sim finished ---------------");
			$finish;
		end
	end
	if(tb_TinyCore.u_kiwi_subsys.u_CPU.u_Decoder.inst1_decoder_valid_pre_o) begin
		if(tb_TinyCore.u_kiwi_subsys.u_CPU.u_Decoder.inst1_decoder_inst_o == 32'h0000_006b) begin
			cal_print_tma();
			$display("--------------- sim finished ---------------");
			$finish;
		end
	end
end

// // TMA
// always @(posedge clk) begin
// 	if(/* decode0_vld */) begin
// 		instruction++;
// 		if(/* backend_stall */) begin
// 			backend_bound++;
// 		end
// 		else begin
// 			frontend_bound++;
// 		end
// 	end
// 	else begin
// 		bubble++;
// 	end
// 	if(/* decode1_vld */) begin
// 		instruction++;
// 		if(/* backend_stall */) begin
// 			backend_bound++;
// 		end
// 		else begin
// 			frontend_bound++;
// 		end
// 	end
// 	else begin
// 		bubble++;
// 	end

// 	if(/* flush_pipe */) begin
// 		flush_cycle++;
// 	end

// 	if(/* retire0 */) begin
// 		retire++;
// 	end
// 	if(/* retire1 */) begin
// 		retire++;
// 	end

// 	total_slots = total_slots+2;

// end


//initial begin
//	repeat(100000) @(posedge clk);
//	$finish;
//end

initial begin
	$fsdbDumpfile("wave.fsdb"); 
	$fsdbDumpMDA();
	$fsdbDumpvars(); 
end

endmodule