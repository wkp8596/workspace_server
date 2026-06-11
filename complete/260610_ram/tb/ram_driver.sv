class ram_driver extends uvm_driver#(ram_seq_item);
	`uvm_component_utils(ram_driver)

	virtual ram_if r_if;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db#(virtual ram_if)::get(this, "", "r_if", r_if))
			`uvm_fatal(get_type_name(), "virtual interface(vif) can't find in config_db.")
	endfunction

	task run_phase(uvm_phase phase);
		r_if.drv_cb.we		<= 1'b0;
		r_if.drv_cb.addr	<= 0;
		r_if.drv_cb.wdata	<= 0;
		forever begin
		seq_item_port.get_next_item(req);
		@(r_if.drv_cb);	//	interface's clocking block is used
		r_if.drv_cb.we		<=	req.we;
		r_if.drv_cb.addr	<=	req.addr;
		r_if.drv_cb.wdata	<=	req.wdata;
		`uvm_info(get_type_name(), $sformatf("excution: %s", req.c2s()), UVM_HIGH)
		seq_item_port.item_done();
		end
	endtask
endclass
