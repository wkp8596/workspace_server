interface intf (
	input logic clk,
	input logic rst
);
	logic			start		;
	logic	[1:0]	sel_ss		;
	logic	[7:0]	clk_div		;
	logic			cpol		;
	logic			cpha		;
	logic	[7:0]	m_tx_data	;
	logic	[7:0]	m_rx_data	;
	logic	[7:0]	s_tx_data0	;
	logic	[7:0]	s_rx_data0	;
	logic	[7:0]	s_tx_data1	;
	logic	[7:0]	s_rx_data1	;
	logic	[7:0]	s_tx_data2	;
	logic	[7:0]	s_rx_data2	;
	logic	[7:0]	s_tx_data3	;
	logic	[7:0]	s_rx_data3	;
	logic			m_busy		;
	logic			m_done		;
	logic			s_busy0		;
	logic			s_done0		;
	logic			s_busy1		;
	logic			s_done1		;
	logic			s_busy2		;
	logic			s_done2		;
	logic			s_busy3		;
	logic			s_done3		;

	clocking drv_cb @(posedge clk);
		default input #1step output #0;
		output		start		;
		output		sel_ss		;
		output		clk_div		;
		output		cpol		;
		output		cpha		;

		output		m_tx_data	;
		output		s_tx_data0	;
		output		s_tx_data1	;
		output		s_tx_data2	;
		output		s_tx_data3	;

		input		m_busy		;
		input		m_done		;

		input		s_busy0		;
		input		s_done0		;
		input		s_busy1		;
		input		s_done1		;
		input		s_busy2		;
		input		s_done2		;
		input		s_busy3		;
		input		s_done3		;
	endclocking

	clocking mon_cb @(posedge clk);
		default input #1step;
		input		start		;
		input		sel_ss		;
		input		clk_div		;
		input		cpol		;
		input		cpha		;
		input		m_tx_data	;
		input		m_rx_data	;
		input		s_tx_data0	;
		input		s_rx_data0	;
		input		s_tx_data1	;
		input		s_rx_data1	;
		input		s_tx_data2	;
		input		s_rx_data2	;
		input		s_tx_data3	;
		input		s_rx_data3	;
		input		m_busy		;
		input		m_done		;
		input		s_busy0		;
		input		s_done0		;
		input		s_busy1		;
		input		s_done1		;
		input		s_busy2		;
		input		s_done2		;
		input		s_busy3		;
		input		s_done3		;
	endclocking

	modport DRV (clocking drv_cb, input clk);
	modport MON (clocking mon_cb, input clk);

endinterface
