class ram_scoreboard extends uvm_scoreboard;
	`uvm_component_utils(ram_scoreboard)

	uvm_analysis_imp #(ram_seq_item, ram_scoreboard) imp;

	logic [7:0] mem_model[0:2**8-1];
	int write_count = 0;
	int read_count 	= 0;
	int pass_count	= 0;
	int fail_count	= 0;
	int skip_count	= 0;

	bit empty[255];

	function new(string name, uvm_component parent);
		super.new(name, parent);
		imp = new("imp", this);
	endfunction

	function write(ram_seq_item tr);
		if (tr.we) begin
			write_count++;
			mem_model[tr.addr] = tr.wdata;
			empty[tr.addr] = 1'b1;
		end else begin
			read_count++;
			if (tr.rdata === mem_model[tr.addr]) begin
				if (empty[tr.addr]) begin
					pass_count++;
					`uvm_info(get_type_name(), $sformatf("PASS: %s (Expactation Value = 0x%02h)", tr.c2s(), mem_model[tr.addr]), UVM_HIGH)
				end else begin
					skip_count++;
				end
			end else begin
				fail_count++;
				`uvm_error(get_type_name(), $sformatf("FAIL: %s (Expactation Value = 0x%02h)", tr.c2s(), mem_model[tr.addr]))
			end
		end
	endfunction

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info("SCB", "===============================================", UVM_LOW)
		`uvm_info("SCB", "=========== Scoreboard Final Report ===========", UVM_LOW)
		`uvm_info("SCB", $sformatf("		write count : %0d", write_count), UVM_LOW)
		`uvm_info("SCB", $sformatf("		read  count : %0d", read_count), UVM_LOW)
		`uvm_info("SCB", $sformatf("		pass  count : %0d", pass_count), UVM_LOW)
		`uvm_info("SCB", $sformatf("		fail  count : %0d", fail_count), UVM_LOW)
		`uvm_info("SCB", $sformatf("		skip  count : %0d", skip_count), UVM_LOW)
		`uvm_info("SCB", "===============================================", UVM_LOW)
	endfunction
endclass
