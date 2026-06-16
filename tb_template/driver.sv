class driver extends uvm_driver#(seq_item);
	`uvm_component_utils(driver)

	virtual intf itf;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db#(virtual intf)::get(this, "", "itf", itf))
			`uvm_fatal(get_type_name(), "virtual interface can't find in config_db.")
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
	endtask
endclass
