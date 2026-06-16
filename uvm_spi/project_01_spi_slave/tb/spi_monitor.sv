class monitor extends uvm_monitor;
	`uvm_component_utils(monitor)

	uvm_analysis_port#(seq_item) ap;

	virtual intf itf;

	function new(string name, uvm_component parent);
		super.new(name, parent);
		ap = new("ap", this);
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
		seq_item tr;
		@(itf.mon_cb);
		forever begin
			@(itf.mon_cb);
			tr = seq_item::type_id::create("tr");
			tr.cpol		    = itf.mon_cb.cpol		;
			tr.cpha		    = itf.mon_cb.cpha		;
			tr.tx_data		= itf.mon_cb.tx_data	;
			tr.busy		    = itf.mon_cb.busy		;
			tr.rx_data		= itf.mon_cb.rx_data	;
			tr.done		    = itf.mon_cb.done		;
			tr.sclk		    = itf.mon_cb.sclk		;
			tr.mosi		    = itf.mon_cb.mosi		;
			tr.miso		    = itf.mon_cb.miso		;
			tr.nss			= itf.mon_cb.nss		;
			ap.write(tr);
		end
	endtask
endclass
