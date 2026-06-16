class driver extends uvm_driver#(seq_item);
	`uvm_component_utils(driver)

	virtual intf itf;

	bit flag;
	bit nw;
	int serial;

	int i;

	function new(string name, uvm_component parent);
		super.new(name, parent);
		flag = 0;
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db#(virtual intf)::get(this, "", "itf", itf))
			`uvm_fatal(get_type_name(), "virtual interface can't find in config_db.")
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction

	task i_start();
		while (itf.drv_cb.m_done) @(itf.drv_cb);
		itf.drv_cb.cmd_start		<= 1;
		itf.drv_cb.cmd_write		<= 0;
		itf.drv_cb.cmd_read			<= 0;
		itf.drv_cb.cmd_stop			<= 0;
		@(itf.drv_cb);
		itf.drv_cb.cmd_start		<= 0;
		wait(itf.drv_cb.m_done);
		@(itf.drv_cb);
	endtask

	task i_write();
		while (itf.drv_cb.m_done) @(itf.drv_cb);
		itf.drv_cb.cmd_start		<= 0;
		itf.drv_cb.cmd_write		<= 1;
		itf.drv_cb.cmd_read			<= 0;
		itf.drv_cb.cmd_stop			<= 0;
		@(itf.drv_cb);
		itf.drv_cb.cmd_write		<= 0;
		wait(itf.drv_cb.m_done);
		@(itf.drv_cb);
	endtask

	task i_read();
		while (itf.drv_cb.m_done) @(itf.drv_cb);
		itf.drv_cb.cmd_start		<= 0;
		itf.drv_cb.cmd_write		<= 0;
		itf.drv_cb.cmd_read			<= 1;
		itf.drv_cb.cmd_stop			<= 0;
		@(itf.drv_cb);
		itf.drv_cb.cmd_read			<= 0;
		wait(itf.drv_cb.m_done);
		@(itf.drv_cb);
	endtask

	task i_stop();
		while (itf.drv_cb.m_done) @(itf.drv_cb);
		itf.drv_cb.cmd_start		<= 0;
		itf.drv_cb.cmd_write		<= 0;
		itf.drv_cb.cmd_read			<= 0;
		itf.drv_cb.cmd_stop			<= 1;
		@(itf.drv_cb);
		itf.drv_cb.cmd_stop			<= 0;
		wait(itf.drv_cb.m_done);
		@(itf.drv_cb);
	endtask

	task run_phase(uvm_phase phase);
		seq_item item;
		itf.drv_cb.cmd_start		<= 0;
		itf.drv_cb.cmd_write		<= 0;
		itf.drv_cb.cmd_read			<= 0;
		itf.drv_cb.cmd_stop			<= 0;
		itf.drv_cb.m_tx_data		<= 0;
		itf.drv_cb.s_tx_data		<= 0;
		itf.drv_cb.ack_in			<= 0;
		`uvm_info(get_type_name(), "Drive Ready", UVM_LOW)
		wait(itf.rst === 1'b0);
		`uvm_info(get_type_name(), "Drive Start", UVM_LOW)
		@(itf.drv_cb);
		@(itf.drv_cb);
		forever begin
			@(itf.drv_cb);
			if (!itf.drv_cb.m_busy) begin
				if (!flag) begin
					seq_item_port.get_next_item(item);
					nw		= item.cmd_read;
					serial	= item.serial;
					flag	= 1;
					i_start();
					itf.drv_cb.m_tx_data <= {item.addr, nw};
					i_write();
					seq_item_port.item_done();
				end else begin
					if (nw) begin
						if (serial != -1) begin
							seq_item_port.get_next_item(item);
							itf.drv_cb.s_tx_data <= item.s_tx_data;
							i_read();
							serial--;
							seq_item_port.item_done();
						end else begin
							i_stop();
							flag = 0;
						end
					end else begin
						if (serial != -1) begin
							seq_item_port.get_next_item(item);
							itf.drv_cb.m_tx_data <= item.m_tx_data;
							i_write();
							serial--;
							seq_item_port.item_done();
						end else begin
							i_stop();
							flag = 0;
						end
					end
				end
			end else begin
				itf.drv_cb.cmd_start		<= 0;
				itf.drv_cb.cmd_write		<= 0;
				itf.drv_cb.cmd_read			<= 0;
				itf.drv_cb.cmd_stop			<= 0;
			end
		end
	endtask
endclass
