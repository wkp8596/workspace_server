class driver extends uvm_driver#(seq_item);
	`uvm_component_utils(driver)

	virtual intf itf;

	bit pol;
	bit pha;

	bit sclk;

	bit [7:0] tx_data;
	bit [7:0] rx_data;
	
	int i;

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

	task start (seq_item item);
		#(item.delay);
		itf.drv_cb.cpol		<= item.cpol;
		itf.drv_cb.cpha		<= item.cpha;
		itf.drv_cb.tx_data	<= item.tx_data;
		itf.drv_cb.mosi		<= 1'b1;
		itf.drv_cb.nss		<= 1'b0;
		itf.drv_cb.sclk		<= item.cpol;
		rx_data				<= item.rx_data;
		sclk				<= item.cpol;
		pol = item.cpol;
		pha = item.cpha;
	endtask

	task fin_idle ();
		itf.drv_cb.nss		<= 1'b1;
		itf.drv_cb.mosi		<= 1'b1;
	endtask

	task txrx_00 (seq_item item);
		case({pol, pha})
			2'b00: begin
				for (i = 0;i < 8; i++) begin
					itf.drv_cb.mosi <= rx_data[7 - i];
					repeat(item.clk_div) @(itf.drv_cb);
					sclk <= ~sclk;
					itf.drv_cb.sclk <= sclk;
					repeat(item.clk_div) @(itf.drv_cb);
					sclk <= ~sclk;
					itf.drv_cb.sclk <= sclk;
				end
				repeat(item.clk_div) @(itf.drv_cb);
				itf.drv_cb.sclk <= 1'b0;
				repeat(2) @(itf.drv_cb);
			end
			2'b01: begin
				for (i = 0;i < 8; i++) begin
					repeat(item.clk_div) @(itf.drv_cb);
					sclk <= ~sclk;
					itf.drv_cb.sclk <= sclk;
					itf.drv_cb.mosi <= rx_data[7 - i];
					repeat(item.clk_div) @(itf.drv_cb);
					sclk <= ~sclk;
					itf.drv_cb.sclk <= sclk;
				end
				repeat(item.clk_div) @(itf.drv_cb);
				itf.drv_cb.sclk <= 1'b0;
				repeat(item.clk_div) @(itf.drv_cb);
				itf.drv_cb.sclk <= 1'b1;
				repeat(item.clk_div) @(itf.drv_cb);
				itf.drv_cb.sclk <= 1'b0;
				repeat(2) @(itf.drv_cb);
			end
			2'b10: begin
				for (i = 0;i < 8; i++) begin
					itf.drv_cb.mosi <= rx_data[7 - i];
					repeat(item.clk_div) @(itf.drv_cb);
					sclk <= ~sclk;
					itf.drv_cb.sclk <= sclk;
					repeat(item.clk_div) @(itf.drv_cb);
					sclk <= ~sclk;
					itf.drv_cb.sclk <= sclk;
				end
				repeat(item.clk_div) @(itf.drv_cb);
				itf.drv_cb.sclk <= 1'b1;
				repeat(2) @(itf.drv_cb);
			end
			2'b11: begin
				for (i = 0;i < 8; i++) begin
					repeat(item.clk_div) @(itf.drv_cb);
					sclk = ~sclk;
					itf.drv_cb.sclk <= sclk;
					itf.drv_cb.mosi <= rx_data[7 - i];
					repeat(item.clk_div) @(itf.drv_cb);
					sclk = ~sclk;
					itf.drv_cb.sclk <= sclk;
				end
				repeat(item.clk_div) @(itf.drv_cb);
				itf.drv_cb.sclk <= 1'b0;
				repeat(2) @(itf.drv_cb);
			end
		endcase
	endtask

	task run_phase(uvm_phase phase);
		seq_item item;
		itf.drv_cb.cpol		<= 1'b0;
		itf.drv_cb.cpha		<= 1'b0;
		itf.drv_cb.tx_data	<= 0;
		itf.drv_cb.mosi		<= 1'b1;
		itf.drv_cb.nss		<= 1'b1;
		itf.drv_cb.sclk		<= 1'b0;
		`uvm_info(get_type_name(), "Drive Ready", UVM_LOW)

		wait(itf.rst === 1'b0);
		`uvm_info(get_type_name(), "Drive Start", UVM_LOW)

		forever begin
			if (!itf.drv_cb.busy) begin
				seq_item_port.get_next_item(item);
				start(item);
				txrx_00(item);
				fin_idle();
				seq_item_port.item_done();
			end else begin
				@(itf.drv_cb);
				fin_idle();
			end
		end
	endtask
endclass
