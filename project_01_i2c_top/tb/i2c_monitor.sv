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
			tr.cmd_start	= itf.mon_cb.cmd_start	;
			tr.cmd_write	= itf.mon_cb.cmd_write	;
			tr.cmd_read		= itf.mon_cb.cmd_read	;
			tr.cmd_stop		= itf.mon_cb.cmd_stop	;
			tr.m_tx_data	= itf.mon_cb.m_tx_data	;
			tr.m_rx_data	= itf.mon_cb.m_rx_data	;
			tr.s_tx_data	= itf.mon_cb.s_tx_data	;
			tr.s_rx_data	= itf.mon_cb.s_rx_data	;
			tr.ack_in		= itf.mon_cb.ack_in		;
			tr.m_ack_out	= itf.mon_cb.m_ack_out	;
			tr.s_ack_out	= itf.mon_cb.s_ack_out	;
			tr.m_busy		= itf.mon_cb.m_busy		;
			tr.m_done		= itf.mon_cb.m_done		;
			tr.s_busy		= itf.mon_cb.s_busy		;
			tr.s_done		= itf.mon_cb.s_done		;
			tr.scl			= itf.mon_cb.scl		;
			tr.sda			= itf.mon_cb.sda		;
			ap.write(tr);
		end
	endtask
endclass
