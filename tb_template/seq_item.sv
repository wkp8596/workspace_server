class seq_item extends uvm_sequence_itme;


	`uvm_object_utils_begin(seq_item)
		`uvm_field_int(, UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(pahse);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(pahse);
	endfunction

	task run_phase(uvm_phase phase);
	endtask

	function string c2s();
	endfunction
endclass
