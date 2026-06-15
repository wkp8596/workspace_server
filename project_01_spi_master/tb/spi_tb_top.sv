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

	spi_master dut(
		.clk		(itf.clk		),
		.rst		(itf.rst		),
    
		.start		(itf.start		),
		.cpol		(itf.cpol		),
		.cpha		(itf.cpha		),
		.clk_div	(itf.clk_div	),
		.tx_data	(itf.tx_data	),
    
		.busy		(itf.busy		),
		.rx_data	(itf.rx_data	),
		.done		(itf.done		),

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
