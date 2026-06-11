import uvm_pkg::*;
import ram_pkg::*;

module tb_top();
	logic clk;

	initial clk = 0;
	always #5 clk = ~clk;

	ram_if r_if(clk);

	ram dut (
		.clk	(r_if.clk	),
		.we		(r_if.we	),
		.addr	(r_if.addr	),
		.wdata	(r_if.wdata	),
		.rdata	(r_if.rdata	) 
	);

	initial begin
		// delay code have to not exist
		uvm_config_db#(virtual ram_if)::set(null, "*", "r_if", r_if);
		run_test("ram_test");
	end

	initial begin
		$fsdbDumpfile("ram_tb.fsdb");
		$fsdbDumpvars(0);
		$fsdbDumpMDA();	//	Memory Array Dump
	end
endmodule

