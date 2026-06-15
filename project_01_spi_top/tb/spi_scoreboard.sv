class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)

	uvm_analysis_imp#(seq_item, scoreboard) imp;

	bit [7:0] m_tx_golden;
	bit [7:0] s_tx_golden;
	bit [7:0] m_rx;
	bit [7:0] r_rx;

	int m_pass = 0;
	int s_pass = 0;
	int m_fail = 0;
	int s_fail = 0;

	bit [1:0] sel;
	bit [1:0] s_sel;

	function new(string name, uvm_component parent);
		super.new(name, parent);
		imp = new("imp", this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction

	virtual function void write(seq_item item);
		if (item.m_done) begin
			if (s_tx_golden == item.m_rx_data) begin
				//`uvm_info(get_type_name(), $sformatf("Master: golden = %0d, test = %0d", s_tx_golden, item.m_rx_data), UVM_LOW)
				m_pass++;
			end else begin
				m_fail++;
				//`uvm_error(get_type_name(), $sformatf("Master: golden = %0d, test = %0d", s_tx_golden, item.m_rx_data))
			end
		end
		if (item.s_done0) begin
			if (m_tx_golden == item.s_rx_data0) begin
				s_pass++;
				`uvm_info(get_type_name(), $sformatf("Master: golden = %0d, test = %0d", m_tx_golden, item.s_rx_data0), UVM_LOW)
			end else begin
				`uvm_error(get_type_name(), $sformatf("Master: golden = %0d, test = %0d", m_tx_golden, item.s_rx_data0))
				s_fail++;
			end
		end
		if (item.s_done1) begin
			if (m_tx_golden == item.s_rx_data1) begin
				`uvm_info(get_type_name(), $sformatf("Master: golden = %0d, test = %0d", m_tx_golden, item.s_rx_data1), UVM_LOW)
				s_pass++;
			end else begin
				`uvm_error(get_type_name(), $sformatf("Master: golden = %0d, test = %0d", m_tx_golden, item.s_rx_data1))
				s_fail++;
			end
		end
		if (item.s_done2) begin
			if (m_tx_golden == item.s_rx_data2) begin
				s_pass++;
			end else begin
				s_fail++;
			end
		end
		if (item.s_done3) begin
			if (m_tx_golden == item.s_rx_data3) begin
				s_pass++;
			end else begin
				s_fail++;
			end
		end
		if (item.start & !item.m_busy) begin
			sel = item.sel_ss;
			m_tx_golden = item.m_tx_data;
			case (sel)
				2'b00: s_tx_golden = item.s_tx_data0;
				2'b01: s_tx_golden = item.s_tx_data1;
				2'b10: s_tx_golden = item.s_tx_data2;
				2'b11: s_tx_golden = item.s_tx_data3;
			endcase
		end
	endfunction

	task run_phase(uvm_phase phase);
	endtask

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info(get_type_name(), "=====================================", UVM_LOW);
		`uvm_info(get_type_name(), "====== Scoreboard Final Report ======", UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("			Total 	Count : %0d", m_pass + m_fail + s_pass + s_fail), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("			Master Pass Count : %0d", m_pass), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("			Master Fail Count : %0d", m_fail), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("			Slave  Pass Count : %0d", s_pass), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("			Slave  Fail Count : %0d", s_fail), UVM_LOW);
		`uvm_info(get_type_name(), "=====================================", UVM_LOW);
		
		if ((m_fail + s_fail) > 0) begin
			`uvm_error(get_type_name(), $sformatf("TEST FAILED: %0d Mismatches Detected!", m_fail + s_fail))
		end else begin
			`uvm_info(get_type_name(), $sformatf("TEST PASSED: %0d All Matches Detected!", m_pass + s_pass), UVM_LOW)
		end
	endfunction
endclass
