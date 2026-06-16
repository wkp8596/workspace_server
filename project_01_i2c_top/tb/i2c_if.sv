interface intf (
	input logic clk,
	input logic rst
);
	logic       cmd_start		;
	logic       cmd_write		;
	logic       cmd_read		;
	logic       cmd_stop		;
	logic [7:0] m_tx_data		;
	logic [7:0] m_rx_data		;
	logic [7:0] s_tx_data		;
	logic [7:0] s_rx_data		;
	logic       ack_in			;
	logic       m_ack_out		;
	logic       s_ack_out		;
	logic       m_busy			;
	logic       m_done			;
	logic       s_busy			;
	logic       s_done			;
	wire       scl				;
	wire       sda				;

	clocking drv_cb @(posedge clk);
		default input #1step output #0;
		output	       cmd_start		;
		output	       cmd_write		;
		output	       cmd_read			;
		output	       cmd_stop			;
		output	  		m_tx_data		;
		output	  		s_tx_data		;
		output	       ack_in			;
		input	       m_busy			;
		input	       m_done			;
		input	       s_busy			;
		input	       s_done			;
		input	       scl				;
		input	       sda				;
	endclocking

	clocking mon_cb @(posedge clk);
		default input #1step;
		input	       cmd_start		;
		input	       cmd_write		;
		input	       cmd_read			;
		input	       cmd_stop			;
		input	  		m_tx_data		;
		input	  		m_rx_data		;
		input	  		s_tx_data		;
		input	  		s_rx_data		;
		input	       ack_in			;
		input	       m_ack_out		;
		input	       s_ack_out		;
		input	       m_busy			;
		input	       m_done			;
		input	       s_busy			;
		input	       s_done			;
		input	       scl				;
		input	       sda				;
	endclocking

	modport DRV (clocking drv_cb, input clk);
	modport MON (clocking mon_cb, input clk);

endinterface
