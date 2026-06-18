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

	I2C_Master_top dut_1 (
		.clk			(itf.clk			),
		.rst			(itf.rst			),
		.cmd_start		(itf.cmd_start		),
		.cmd_write		(itf.cmd_write		),
		.cmd_read		(itf.cmd_read		),
		.cmd_stop		(itf.cmd_stop		),
		.tx_data		(itf.m_tx_data		),
		.rx_data		(itf.m_rx_data		),
		.ack_in			(itf.ack_in			),
		.ack_out		(itf.m_ack_out		),
		.busy			(itf.m_busy			),
		.done			(itf.m_done			),
		.scl			(itf.scl			),
		.sda			(itf.sda			) 
	);

	i2c_slave_top dut_2 (
		.clk			(itf.clk			),
		.rst			(itf.rst			),
		.ack_out		(itf.s_ack_out		),
		.scl			(itf.scl			),
		.sda			(itf.sda			),
		.tx_data		(itf.s_tx_data		),
		.rx_data		(itf.s_rx_data		),
		.busy			(itf.s_busy			),
		.done			(itf.s_done			) 
	);

	pullup(itf.scl);
	pullup(itf.sda);

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
