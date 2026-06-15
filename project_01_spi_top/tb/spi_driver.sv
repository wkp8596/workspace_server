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
		seq_item item;
		itf.drv_cb.start		<=	0;
		itf.drv_cb.sel_ss		<=	0;
		itf.drv_cb.clk_div		<=	0;
		itf.drv_cb.cpol			<=	0;
		itf.drv_cb.cpha			<=	0;
		itf.drv_cb.m_tx_data	<=	0;
		itf.drv_cb.s_tx_data0	<=	0;
		itf.drv_cb.s_tx_data1	<=	0;
		itf.drv_cb.s_tx_data2	<=	0;
		itf.drv_cb.s_tx_data3	<=	0;
		`uvm_info(get_type_name(), "Drive Ready", UVM_LOW)

		wait(itf.rst === 1'b0);
		`uvm_info(get_type_name(), "Drive Start", UVM_LOW)

		forever begin
			@(itf.drv_cb);
			if (!itf.drv_cb.m_busy) begin
				seq_item_port.get_next_item(item);
				itf.drv_cb.start		<=	item.start		;
				itf.drv_cb.sel_ss		<=	item.sel_ss		;
				itf.drv_cb.clk_div		<=	item.clk_div	;
				itf.drv_cb.cpol			<=	item.cpol		;
				itf.drv_cb.cpha			<=	item.cpha		;
				itf.drv_cb.m_tx_data	<=	item.m_tx_data	;
				itf.drv_cb.s_tx_data0	<=	item.s_tx_data0	;
				itf.drv_cb.s_tx_data1	<=	item.s_tx_data1	;
				itf.drv_cb.s_tx_data2	<=	item.s_tx_data2	;
				itf.drv_cb.s_tx_data3	<=	item.s_tx_data3	;
				seq_item_port.item_done();
				@(itf.drv_cb);
			end else begin
				itf.drv_cb.start		<=	1'b0			;
			end
		end
	endtask
endclass
