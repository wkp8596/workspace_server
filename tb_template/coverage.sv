class coverage extends uvm_subscriber#(seq_item);
	`uvm_component_utils(coverage)

	seq_item tr;

	covergroup cg;
		option.per_instance = 1;
	endgroup

	function new(string name, uvm_component parent);
		super.new(name, parent);
		cg = new();
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(pahse);
	endfunction

	function void write(seq_item t);
		tr = t;
		cg.sample();
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(pahse);
	endfunction

	task run_phase(uvm_phase phase);
	endtask

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info(get_type_name(), "===================================================", UVM_LOW);
		`uvm_info(get_type_name(), "=========== Functional Coverage Results ===========", UVM_LOW);
		`uvm_info(get_type_name(), $sformatf(""), UVM_LOW);
		`uvm_info(get_type_name(), "===================================================", UVM_LOW);

		if (cg.get_inst_coverage() < 99.9) begin
			`uvm_warning(get_type_name(), "Coverage is UNDER 99.9%!!, NEED MORE TEST")
		end
	endfunction
endclass
