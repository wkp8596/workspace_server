class agent extends uvm_agent;
	`uvm_component_utils(agent)
	
	uvm_sequencer#(seq_item)	sqr;
	driver						drv;
	monitor						mon;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		sqr = uvm_sequencer#(ram_seq_item)::type_id::create("sqr", this);
		drv = driver::type_id::create("drv", this);
		mon = monitor::type_id::create("mon", this);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		drv.item_port.connect(sqr.seq_item_export);
	endfunction

	task run_phase(uvm_phase phase);
	endtask
endclass
