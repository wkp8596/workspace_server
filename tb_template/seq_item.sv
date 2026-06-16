class seq_item extends uvm_sequence_itme;


	`uvm_object_utils_begin(seq_item)
		`uvm_field_int(, UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function string c2s();
	endfunction
endclass
