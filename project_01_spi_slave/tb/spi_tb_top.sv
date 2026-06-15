import uvm_pkg::*;
import pkg::*;

module tb_top();
	logic clk;
	logic rst;

	initial clk = 0;
	initial begin
		rst = 1;
		repeat(3) @(negedge clk);
		rst = 0;
	
	end
	always #5 clk = ~clk;

	intf itf(clk, rst);

	spi_slave dut(
		.clk		(itf.clk		),
		.rst		(itf.rst		),
		.cpol		(itf.cpol		),
		.cpha		(itf.cpha		),
		.tx_data	(itf.tx_data	),
		.busy		(itf.busy		),
		.done		(itf.done		),
		.rx_data	(itf.rx_data	),
		.sclk		(itf.sclk		),
		.mosi		(itf.mosi		),
		.miso		(itf.miso		),
		.nss		(itf.nss		) 
    );


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
