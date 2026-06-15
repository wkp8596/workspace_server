import uvm_pkg::*;
import pkg::*;

module tb_top();
	logic clk;

	initial clk = 0;
	always #5 clk = ~clk;

	intf itf(clk);


	initial begin
		uvm_config_db#(virtual intf)::set(null, "*", "itf", itf);
		run_test();
	end

	initial begin
		$fsdbDumpfile("wave.fsdb");
		$fsdbDumpvars(0);
		$fsdbDumpMDA();
	end


endmodule
