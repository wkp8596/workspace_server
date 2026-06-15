interface intf (
	input logic clk
);

	clocking drv_cb @(posedge clk);
		default input #1step output #0;
	endclocking

	clocking mon_cb @(posedge clk);
		default input #1step;
	endclocking

	modport DRV (clocking drv_cb, input clk);
	modport MON (clocking mon_cb, input clk);

endinterface
