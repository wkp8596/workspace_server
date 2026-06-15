interface intf (
	input logic clk,
	input logic rst
);
	logic			cpol		;
	logic			cpha		;

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
		output	cpol		;
		output	cpha		;

		output	tx_data		;

		input	busy		;
		input	rx_data		;
		input	done		;

		output	sclk		;
		output	mosi		;
		input	miso		;
		output	nss			;
	endclocking

	clocking mon_cb @(posedge clk);
		default input #1step;
		input	cpol		;
		input	cpha		;

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
