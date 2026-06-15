class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)

	uvm_analysis_imp#(seq_item, scoreboard) imp;

	int tx_pass_count = 0;
	int tx_fail_count = 0;
	int rx_pass_count = 0;
	int rx_fail_count = 0;

	bit pol;
	bit pha;

	bit [7:0] tx_data_golden;
	bit [7:0] rx_data_golden;
	bit [7:0] tx_data_test;
	bit [7:0] rx_data_test;

	bit pos_edge_detect;
	bit neg_edge_detect;

	bit sclk;

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
		if (item.done) begin
			rx_data_test = item.rx_data;
			if (tx_data_test == tx_data_golden) begin
				`uvm_info(get_type_name(), $sformatf("tx_data_test = %0d, tx_data_golden = %0d", tx_data_test, tx_data_golden), UVM_LOW)
				tx_pass_count++;
			end else begin
				`uvm_error(get_type_name(), $sformatf("tx_data_test = %0d, tx_data_golden = %0d", tx_data_test, tx_data_golden))
				tx_fail_count++;
			end
			if (rx_data_test == rx_data_golden) begin
				`uvm_info(get_type_name(), $sformatf("rx_data_test = %0d, rx_data_golden = %0d", rx_data_test, rx_data_golden), UVM_LOW)
				rx_pass_count++;
			end else begin
				`uvm_error(get_type_name(), $sformatf("rx_data_test = %0d, rx_data_golden = %0d", rx_data_test, rx_data_golden))
				rx_fail_count++;
			end
		end
		pos_edge_detect = item.sclk & !sclk;
		neg_edge_detect = !item.sclk & sclk;
		sclk = item.sclk;
		if (item.busy) begin
			if (!item.nss) begin
				case ({pol, pha})
					2'b00: begin
						if (pos_edge_detect) begin
							tx_data_test = {tx_data_test[6:0], item.miso};
							rx_data_golden = {rx_data_golden[6:0], item.mosi};
						end
					end
					2'b01: begin
						if (neg_edge_detect) begin
							tx_data_test = {tx_data_test[6:0], item.miso};
							rx_data_golden = {rx_data_golden[6:0], item.mosi};
						end
					end
					2'b10: begin
						if (neg_edge_detect) begin
							tx_data_test = {tx_data_test[6:0], item.miso};
							rx_data_golden = {rx_data_golden[6:0], item.mosi};
						end
					end
					2'b11: begin
						if (pos_edge_detect) begin
							tx_data_test = {tx_data_test[6:0], item.miso};
							rx_data_golden = {rx_data_golden[6:0], item.mosi};
						end
					end
				endcase
			end
		end else begin
			pol = item.cpol;
			pha = item.cpha;
			tx_data_golden = item.tx_data;
		end
	endfunction

	task run_phase(uvm_phase phase);
	endtask

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info(get_type_name(), "=====================================", UVM_LOW);
		`uvm_info(get_type_name(), "====== Scoreboard Final Report ======", UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("			Total 	Count : %0d", tx_pass_count + tx_fail_count + rx_pass_count + rx_fail_count), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("			RX Fail Count : %0d", rx_fail_count), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("			RX Pass Count : %0d", rx_pass_count), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("			TX Fail Count : %0d", tx_fail_count), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("			TX Pass Count : %0d", tx_pass_count), UVM_LOW);
		`uvm_info(get_type_name(), "=====================================", UVM_LOW);
		
		if ((rx_fail_count + tx_fail_count) > 0) begin
			`uvm_error(get_type_name(), $sformatf("TEST FAILED: %0d Mismatches Detected!", tx_fail_count + rx_fail_count))
		end else begin
			`uvm_info(get_type_name(), $sformatf("TEST PASSED: %0d All Matches Detected!", tx_pass_count + tx_pass_count), UVM_LOW)
		end
	endfunction
endclass
