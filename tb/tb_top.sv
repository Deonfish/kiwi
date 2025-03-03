//~ `New testbench
`timescale  1ns / 1ps

module tb_TinyCore;

// TinyCore Parameters
parameter PERIOD  = 10;

reg   clk                                  = 0 ;
reg   rst_n                                = 0 ;

longint inst_commited;
longint total_cycles;

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

	$display("-----------------------------------------------------------------------------");
	$display("| Rtire | Bad Speculation | Flush Recovery | Frontend Bound | Backend Bound |");
	$display("| %.1f   |       %.1f       |      %.1f       |      %.1f       |     %.1f       |", 
		retire/total_slots, bad_speculation/total_slots, flush_recovery/total_slots, frontend_bound/total_slots, backend_bound/total_slots);
	$display("-----------------------------------------------------------------------------");

endfunction

function void print_ipc();
	real ipc;
	ipc = real'(inst_commited) / real'(total_cycles);
	$display("-----------------------------------------------------------------------------");
	$display("ipc=%.2f", ipc);
	$display("-----------------------------------------------------------------------------");
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
	$readmemh("../tests/programs/coremark.text.hex", code_mem);
	$readmemh("../tests/programs/coremark.data.hex", data_mem);
	$display("code initing to mem...");
	// FLASH (rx) : ORIGIN = 0x70000000, LENGTH = 0x100000    /* 1MB for .text and .rodata */
	for(int i=0; i<1024*1024/8; i++) begin
		ibiu_axi_driver.mem[i][31:0]  = code_mem[i*2];
		ibiu_axi_driver.mem[i][63:32] = code_mem[i*2+1];
	end
	// RAM (rw)  : ORIGIN = 0x70100000, LENGTH = 0x100000 /* 1MB for .data, .bss, heap, stack */
	for(int i=1024*1024/8; i<1024*1024/8*2; i++) begin
		dbiu_axi_driver.mem[i][63:32] = data_mem[i*2+1];
		dbiu_axi_driver.mem[i][31:0]  = data_mem[i*2];
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
			print_ipc();
			cal_print_tma();
			$display("--------------- sim finished ---------------");
			$finish;
		end
	end
	if(tb_TinyCore.u_kiwi_subsys.u_CPU.u_Decoder.inst1_decoder_valid_pre_o) begin
		if(tb_TinyCore.u_kiwi_subsys.u_CPU.u_Decoder.inst1_decoder_inst_o == 32'h0000_006b) begin
			print_ipc();
			cal_print_tma();
			$display("--------------- sim finished ---------------");
			$finish;
		end
	end
end

// ipc
always @(posedge clk) begin
	total_cycles++;
	if(tb_TinyCore.u_kiwi_subsys.u_CPU.u_Scoreboard.u_instMonitor0.inst_valid_i) begin
		inst_commited++;
	end
	if(tb_TinyCore.u_kiwi_subsys.u_CPU.u_Scoreboard.u_instMonitor1.inst_valid_i) begin
		inst_commited++;
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