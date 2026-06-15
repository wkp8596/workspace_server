class base_seq extends uvm_sequence #(seq_item);
	`uvm_object_utils(base_seq)

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
endclass
