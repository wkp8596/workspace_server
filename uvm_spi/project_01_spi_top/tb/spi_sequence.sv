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
			if (!item.randomize() with { clk_div != 0; }) `uvm_error(get_type_name(), "Randomize Failed")
			finish_item(item);
		end
	endtask
endclass

class burst_seq extends base_seq;
	`uvm_object_utils(burst_seq)

	int num;

	function new(string name = "base_seq");
		super.new(name);
	endfunction

	task body();
		seq_item item;

		repeat (num) begin
			item = seq_item::type_id::create("item");
			start_item(item);
			if (!item.randomize() with { clk_div != 0; }) `uvm_error(get_type_name(), "Randomize Failed")
			item.start = 1'b1;
			finish_item(item);
		end
	endtask
endclass

class term_seq extends base_seq;
	`uvm_object_utils(term_seq)

	int num;

	function new(string name = "base_seq");
		super.new(name);
	endfunction

	task body();
		seq_item item;

		repeat (num) begin
			item = seq_item::type_id::create("item");
			start_item(item);
			if (!item.randomize() with {start dist {1:=1, 0:=9}; clk_div != 0;}) `uvm_error(get_type_name(), "Randomize Failed")
			finish_item(item);
		end
	endtask
endclass
