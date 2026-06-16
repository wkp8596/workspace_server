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

	top_spi dut(
		.clk		(itf.clk		),
		.rst		(itf.rst		),
		.start		(itf.start		),
		.sel_ss		(itf.sel_ss		),
		.clk_div	(itf.clk_div	),
		.cpol		(itf.cpol		),
		.cpha		(itf.cpha		),
		.m_tx_data	(itf.m_tx_data	),
		.m_rx_data	(itf.m_rx_data	),
		.s_tx_data0	(itf.s_tx_data0	),
		.s_rx_data0	(itf.s_rx_data0	),
		.s_tx_data1	(itf.s_tx_data1	),
		.s_rx_data1	(itf.s_rx_data1	),
		.s_tx_data2	(itf.s_tx_data2	),
		.s_rx_data2	(itf.s_rx_data2	),
		.s_tx_data3	(itf.s_tx_data3	),
		.s_rx_data3	(itf.s_rx_data3	),
		.m_busy		(itf.m_busy		),
		.m_done		(itf.m_done		),
		.s_busy0	(itf.s_busy0	),
		.s_done0	(itf.s_done0	),
		.s_busy1	(itf.s_busy1	),
		.s_done1	(itf.s_done1	),
		.s_busy2	(itf.s_busy2	),
		.s_done2	(itf.s_done2	),
		.s_busy3	(itf.s_busy3	),
		.s_done3	(itf.s_done3	) 
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
