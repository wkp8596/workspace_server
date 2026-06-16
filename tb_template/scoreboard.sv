class scoreboard extends uvm_scoreboard;
	`uvm_component_utils(scoreboard)

	uvm_analysis_imp#(seq_item, scoreboard) imp;

	int pass_count;
	int fail_count;

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

	virtual void function void write(seq_item item);
	endfunction

	task run_phase(uvm_phase phase);
	endtask

	function report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info(get_type_name(), "=====================================", UVM_LOW);
		`uvm_info(get_type_name(), "====== Scoreboard Final Report ======", UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("			Total Count : %0d", pass_count + fail_count), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("			Fail  Count : %0d", fail_count), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("			Pass  Count : %0d", pass_count), UVM_LOW);
		`uvm_info(get_type_name(), "=====================================", UVM_LOW);
		
		if (fail_count > 0) begin
			`uvm_error(get_type_name(), $sformatf("TEST FAILED: %0d Mismatches Detected!", fail_count))
		end else begin
			`uvm_info(get_type_name(), $sformatf("TEST PASSED: %0d All Matches Detected!", pass_count), UVM_LOW)
		end
	endfunction
endclass
