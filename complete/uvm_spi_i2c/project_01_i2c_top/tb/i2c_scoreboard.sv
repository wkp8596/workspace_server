class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)

	uvm_analysis_imp#(seq_item, scoreboard) imp;

	int tx_pass_count;
	int tx_fail_count;
	int rx_pass_count;
	int rx_fail_count;

	bit pending_tx;
	bit pending_rx;
	bit address_phase;
	bit m_done_d;
	bit s_done_d;
	bit cmd_start_d;
	bit cmd_write_d;
	bit cmd_read_d;
	bit cmd_stop_d;
	bit scl_d;
	bit sda_d;
	bit addr_pending;
	bit read_transaction;
	bit [7:0] tx_data_golden;
	bit [7:0] rx_data_golden;

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
		bit cmd_start_pulse;
		bit cmd_write_pulse;
		bit cmd_read_pulse;
		bit cmd_stop_pulse;
		bit bus_start;

		cmd_start_pulse = item.cmd_start && !cmd_start_d;
		cmd_write_pulse = item.cmd_write && !cmd_write_d;
		cmd_read_pulse  = item.cmd_read  && !cmd_read_d;
		cmd_stop_pulse  = item.cmd_stop  && !cmd_stop_d;
		bus_start       = item.scl && sda_d && !item.sda;

		if (item.s_done && !s_done_d) begin
			if (addr_pending) begin
				addr_pending = 1'b0;
				pending_tx = 1'b0;
			end else if (pending_tx) begin
				if (item.s_rx_data == tx_data_golden) begin
					`uvm_info(get_type_name(), $sformatf("TX PASS: m_tx_data = 0x%0h, s_rx_data = 0x%0h", tx_data_golden, item.s_rx_data), UVM_LOW)
					tx_pass_count++;
				end else begin
					`uvm_error(get_type_name(), $sformatf("TX FAIL: m_tx_data = 0x%0h, s_rx_data = 0x%0h", tx_data_golden, item.s_rx_data))
					tx_fail_count++;
				end
				pending_tx = 1'b0;
			end else begin
				pending_tx = 1'b0;
			end
		end

		if (item.m_done && !m_done_d) begin
			if (pending_rx) begin
				if (item.m_rx_data == rx_data_golden) begin
					`uvm_info(get_type_name(), $sformatf("RX PASS: s_tx_data = 0x%0h, m_rx_data = 0x%0h", rx_data_golden, item.m_rx_data), UVM_LOW)
					rx_pass_count++;
				end else begin
					`uvm_error(get_type_name(), $sformatf("RX FAIL: s_tx_data = 0x%0h, m_rx_data = 0x%0h", rx_data_golden, item.m_rx_data))
					rx_fail_count++;
				end
				pending_rx = 1'b0;
			end
		end

		if (cmd_start_pulse || bus_start) begin
			address_phase = 1'b1;
			addr_pending = 1'b1;
			read_transaction = 1'b0;
			pending_tx = 1'b0;
			pending_rx = 1'b0;
		end

		if (cmd_write_pulse) begin
			if (address_phase) begin
				read_transaction = item.m_tx_data[0];
				address_phase = 1'b0;
			end else if (!read_transaction) begin
				tx_data_golden = item.m_tx_data;
				pending_tx = 1'b1;
				pending_rx = 1'b0;
			end
		end else if (cmd_read_pulse) begin
			rx_data_golden = item.s_tx_data;
			pending_rx = 1'b1;
			pending_tx = 1'b0;
		end else if (cmd_stop_pulse) begin
			address_phase = 1'b0;
		end

		m_done_d = item.m_done;
		s_done_d = item.s_done;
		cmd_start_d = item.cmd_start;
		cmd_write_d = item.cmd_write;
		cmd_read_d  = item.cmd_read;
		cmd_stop_d  = item.cmd_stop;
		scl_d = item.scl;
		sda_d = item.sda;
	endfunction

	task run_phase(uvm_phase phase);
	endtask

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info(get_type_name(), "=====================================", UVM_LOW);
		`uvm_info(get_type_name(), "====== Scoreboard Final Report ======", UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("			Total Count   : %0d", tx_pass_count + tx_fail_count + rx_pass_count + rx_fail_count), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("			TX Pass Count : %0d", tx_pass_count), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("			TX Fail Count : %0d", tx_fail_count), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("			RX Pass Count : %0d", rx_pass_count), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("			RX Fail Count : %0d", rx_fail_count), UVM_LOW);
		`uvm_info(get_type_name(), "=====================================", UVM_LOW);
		
		if ((tx_fail_count + rx_fail_count) > 0) begin
			`uvm_error(get_type_name(), $sformatf("TEST FAILED: %0d Mismatches Detected!", tx_fail_count + rx_fail_count))
		end else begin
			`uvm_info(get_type_name(), $sformatf("TEST PASSED: %0d All Matches Detected!", tx_pass_count + rx_pass_count), UVM_LOW)
		end
	endfunction
endclass
