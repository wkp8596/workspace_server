class base_seq extends uvm_sequence #(seq_item);
	`uvm_object_utils(base_seq)

	int num;

	function new(string name = "base_seq");
		super.new(name);
	endfunction

	task body();
		seq_item item;

		repeat (num) begin
			item = seq_item::type_id::create("item");
			start_item(item);
			if (!item.randomize() with {cmd_write + cmd_read == 1;} ) `uvm_error(get_type_name(), "Radomize Failed")
			finish_item(item);
		end
	endtask
endclass
