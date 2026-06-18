interface intf (
	input logic clk,
	input logic rst
);
	logic			start		;
	logic			cpol		;
	logic			cpha		;

	logic	[7:0]	clk_div		;
	logic	[7:0]	tx_data		;

	logic			busy		;
	logic	[7:0]	rx_data		;
	logic			done		;

	logic			sclk		;
	logic			mosi		;
	logic			miso		;
	logic			nss			;

	clocking drv_cb @(posedge clk);
		default input #1step output #0;
		output	start		;
		output	cpol		;
		output	cpha		;

		output	clk_div		;
		output	tx_data		;

		input	busy		;
		input	rx_data		;
		input	done		;

		input	sclk		;
		input	mosi		;
		output	miso		;
		input	nss			;
	endclocking

	clocking mon_cb @(posedge clk);
		default input #1step;
		input	start		;
		input	cpol		;
		input	cpha		;

		input	clk_div		;
		input	tx_data		;

		input	busy		;
		input	rx_data		;
		input	done		;

		input	sclk		;
		input	mosi		;
		input	miso		;
		input	nss			;
	endclocking

	modport DRV (clocking drv_cb, input clk);
	modport MON (clocking mon_cb, input clk);

endinterface
