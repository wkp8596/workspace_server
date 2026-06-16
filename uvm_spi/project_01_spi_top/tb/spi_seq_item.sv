class seq_item extends uvm_sequence_item;
	rand	logic			start		;
	rand	logic	[1:0]	sel_ss		;
	rand	logic	[7:0]	clk_div		;
	rand	logic			cpol		;
	rand	logic			cpha		;
	rand	logic	[7:0]	m_tx_data	;
	rand	logic	[7:0]	s_tx_data0	;
	rand	logic	[7:0]	s_tx_data1	;
	rand	logic	[7:0]	s_tx_data2	;
	rand	logic	[7:0]	s_tx_data3	;
	logic			[7:0]	m_rx_data	;
	logic			[7:0]	s_rx_data0	;
	logic			[7:0]	s_rx_data1	;
	logic			[7:0]	s_rx_data2	;
	logic			[7:0]	s_rx_data3	;
	logic					m_busy		;
	logic					m_done		;
	logic					s_busy0		;
	logic					s_done0		;
	logic					s_busy1		;
	logic					s_done1		;
	logic					s_busy2		;
	logic					s_done2		;
	logic					s_busy3		;
	logic					s_done3		;

	`uvm_object_utils_begin(seq_item)
		`uvm_field_int(start		, UVM_ALL_ON)
		`uvm_field_int(sel_ss		, UVM_ALL_ON)
		`uvm_field_int(clk_div		, UVM_ALL_ON)
		`uvm_field_int(cpol		, UVM_ALL_ON)
		`uvm_field_int(cpha		, UVM_ALL_ON)
		`uvm_field_int(m_tx_data	, UVM_ALL_ON)
		`uvm_field_int(s_tx_data0	, UVM_ALL_ON)
		`uvm_field_int(s_tx_data1	, UVM_ALL_ON)
		`uvm_field_int(s_tx_data2	, UVM_ALL_ON)
		`uvm_field_int(s_tx_data3	, UVM_ALL_ON)
		`uvm_field_int(m_rx_data	, UVM_ALL_ON)
		`uvm_field_int(s_rx_data0	, UVM_ALL_ON)
		`uvm_field_int(s_rx_data1	, UVM_ALL_ON)
		`uvm_field_int(s_rx_data2	, UVM_ALL_ON)
		`uvm_field_int(s_rx_data3	, UVM_ALL_ON)
		`uvm_field_int(m_busy		, UVM_ALL_ON)
		`uvm_field_int(m_done		, UVM_ALL_ON)
		`uvm_field_int(s_busy0		, UVM_ALL_ON)
		`uvm_field_int(s_done0		, UVM_ALL_ON)
		`uvm_field_int(s_busy1		, UVM_ALL_ON)
		`uvm_field_int(s_done1		, UVM_ALL_ON)
		`uvm_field_int(s_busy2		, UVM_ALL_ON)
		`uvm_field_int(s_done2		, UVM_ALL_ON)
		`uvm_field_int(s_busy3		, UVM_ALL_ON)
		`uvm_field_int(s_done3		, UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name = "seq_item");
		super.new(name);
	endfunction

	task run_phase(uvm_phase phase);
	endtask
endclass
