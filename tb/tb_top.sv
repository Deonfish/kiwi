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

TinyCore  u_TinyCore (
    .clk                     ( clk     ),
    .rst_n                   ( rst_n   )
);

bit[31:0] code_mem[1024*1024];
bit[31:0] data_mem[1024*1024];
bit[31:0] decoder_inst;

// init code and data memory
initial begin
	$readmemh("../tests/programs/hello.text.hex", code_mem);
	$readmemh("../tests/programs/hello.data.hex", data_mem);
	$display("code initing to mem...");
	for(int i=0; i<1024*1024; ++i) begin
		u_TinyCore.itcm.mem[i] = code_mem[i];
		u_TinyCore.dtcm.mem[i] = data_mem[i];
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
		u_TinyCore.u_Regfile.registers[i] = 0;
	end
end


// sim finish control
assign decoder_inst = u_TinyCore.u_Decoder.inst_o;

always @(posedge clk) begin
	if(u_TinyCore.u_Decoder.decoder_valid_o) begin
		if(decoder_inst == 32'h0000_006b) begin
			cal_print_tma();
			$display("--------------- sim finished ---------------");
			$finish;
		end
	end
end

// TMA
always @(posedge clk) begin
	if(/* decode0_vld */) begin
		instruction++;
		if(/* backend_stall */) begin
			backend_bound++;
		end
		else begin
			frontend_bound++;
		end
	end
	else begin
		bubble++;
	end
	if(/* decode1_vld */) begin
		instruction++;
		if(/* backend_stall */) begin
			backend_bound++;
		end
		else begin
			frontend_bound++;
		end
	end
	else begin
		bubble++;
	end

	if(/* flush_pipe */) begin
		flush_cycle++;
	end

	if(/* retire0 */) begin
		retire++;
	end
	if(/* retire1 */) begin
		retire++;
	end

	total_slots = total_slots+2;

end


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