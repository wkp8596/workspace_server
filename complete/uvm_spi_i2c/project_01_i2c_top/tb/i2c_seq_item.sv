class seq_item extends uvm_sequence_item;
	rand	logic       cmd_start		;
	rand	logic       cmd_write		;
	rand	logic       cmd_read		;
	rand	logic       cmd_stop		;
	rand	logic [6:0]	addr			;
	rand	logic [7:0] m_tx_data		;
	rand	logic [7:0] m_rx_data		;
	rand	logic [7:0] s_tx_data		;
	rand	logic [7:0] s_rx_data		;
	rand	logic [3:0]	serial			;
	logic       		ack_in			;
	logic       		m_ack_out		;
	logic       		s_ack_out		;
	logic       		m_busy			;
	logic       		m_done			;
	logic       		s_busy			;
	logic       		s_done			;
	logic       		scl				;
	logic       		sda				;


	`uvm_object_utils_begin(seq_item)
		`uvm_field_int(cmd_start		, UVM_ALL_ON)
		`uvm_field_int(cmd_write		, UVM_ALL_ON)
		`uvm_field_int(cmd_read			, UVM_ALL_ON)
		`uvm_field_int(cmd_stop			, UVM_ALL_ON)
		`uvm_field_int(addr				, UVM_ALL_ON)
		`uvm_field_int(m_tx_data		, UVM_ALL_ON)
		`uvm_field_int(m_rx_data		, UVM_ALL_ON)
		`uvm_field_int(s_tx_data		, UVM_ALL_ON)
		`uvm_field_int(s_rx_data		, UVM_ALL_ON)
		`uvm_field_int(serial			, UVM_ALL_ON)
		`uvm_field_int(ack_in			, UVM_ALL_ON)
		`uvm_field_int(m_ack_out		, UVM_ALL_ON)
		`uvm_field_int(s_ack_out		, UVM_ALL_ON)
		`uvm_field_int(m_busy			, UVM_ALL_ON)
		`uvm_field_int(m_done			, UVM_ALL_ON)
		`uvm_field_int(s_busy			, UVM_ALL_ON)
		`uvm_field_int(s_done			, UVM_ALL_ON)
		`uvm_field_int(scl				, UVM_ALL_ON)
		`uvm_field_int(sda				, UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name = "seq_item");
		super.new(name);
	endfunction

	function string c2s();
	endfunction
endclass
