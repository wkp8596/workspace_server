class driver extends uvm_driver#(seq_item);
	`uvm_component_utils(driver)

	virtual intf itf;

	bit pol;
	bit pha;

	bit neg_edge_detect;
	bit pos_edge_detect;

	bit ss_negedge_detect;

	bit sclk;

	bit ss;

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

	task drive_start(seq_item item);
		itf.drv_cb.start	<= item.start	;
		itf.drv_cb.cpol		<= item.cpol	;
		itf.drv_cb.cpha		<= item.cpha	;
		itf.drv_cb.clk_div	<= item.clk_div	;
		itf.drv_cb.tx_data	<= item.tx_data	;
		itf.drv_cb.miso		<= 1'b1			;
		pol = item.cpol;
		pha = item.cpha;
	endtask

	task drive_txrx(seq_item item);
		itf.drv_cb.start	<= item.start	;
		itf.drv_cb.cpol		<= item.cpol	;
		itf.drv_cb.cpha		<= item.cpha	;
		itf.drv_cb.clk_div	<= item.clk_div	;
		itf.drv_cb.tx_data	<= item.tx_data	;
		itf.drv_cb.miso		<= item.miso	;
	endtask

	task run_phase(uvm_phase phase);
		seq_item item;
		itf.drv_cb.start	<= 1'b0;
		itf.drv_cb.cpol		<= 1'b0;
		itf.drv_cb.cpha		<= 1'b0;
		itf.drv_cb.clk_div	<= 0;
		itf.drv_cb.tx_data	<= 0;
		itf.drv_cb.miso		<= 1'b0;
		`uvm_info(get_type_name(), "Drive Ready", UVM_LOW)

		wait(itf.rst === 1'b0);
		`uvm_info(get_type_name(), "Drive Start", UVM_LOW)

		forever begin
			pos_edge_detect = itf.drv_cb.sclk & !sclk;
			neg_edge_detect = !itf.drv_cb.sclk & sclk;

			ss_negedge_detect = !itf.drv_cb.nss & ss;
			ss = itf.drv_cb.nss;
			sclk = itf.drv_cb.sclk;

			seq_item_port.get_next_item(item);
			if (!itf.drv_cb.busy) begin
				@(itf.drv_cb);
				drive_start(item);
			end else begin
				@(itf.drv_cb);
				itf.drv_cb.start	<= 1'b0;
				if (!itf.drv_cb.nss) begin
					case ({pol, pha})
						2'b00: begin
							if (ss_negedge_detect | neg_edge_detect) begin
								drive_txrx(item);
							end
						end
						2'b01: begin
							if (pos_edge_detect) begin
								drive_txrx(item);
							end
						end
						2'b10: begin
							if (ss_negedge_detect | pos_edge_detect) begin
								drive_txrx(item);
							end
						end
						2'b11: begin
							if (neg_edge_detect) begin
								drive_txrx(item);
							end
						end
					endcase
				end 
			end
			seq_item_port.item_done();
		end
	endtask
endclass
