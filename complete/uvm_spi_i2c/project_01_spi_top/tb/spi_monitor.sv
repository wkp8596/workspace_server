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
			tr.start		= itf.mon_cb.start			;
			tr.sel_ss		= itf.mon_cb.sel_ss			;
			tr.clk_div		= itf.mon_cb.clk_div		;
			tr.cpol			= itf.mon_cb.cpol			;
			tr.cpha			= itf.mon_cb.cpha			;
			tr.m_tx_data	= itf.mon_cb.m_tx_data		;
			tr.m_rx_data	= itf.mon_cb.m_rx_data		;
			tr.s_tx_data0	= itf.mon_cb.s_tx_data0		;
			tr.s_rx_data0	= itf.mon_cb.s_rx_data0		;
			tr.s_tx_data1	= itf.mon_cb.s_tx_data1		;
			tr.s_rx_data1	= itf.mon_cb.s_rx_data1		;
			tr.s_tx_data2	= itf.mon_cb.s_tx_data2		;
			tr.s_rx_data2	= itf.mon_cb.s_rx_data2		;
			tr.s_tx_data3	= itf.mon_cb.s_tx_data3		;
			tr.s_rx_data3	= itf.mon_cb.s_rx_data3		;
			tr.m_busy		= itf.mon_cb.m_busy			;
			tr.m_done		= itf.mon_cb.m_done			;
			tr.s_busy0		= itf.mon_cb.s_busy0		;
			tr.s_done0		= itf.mon_cb.s_done0		;
			tr.s_busy1		= itf.mon_cb.s_busy1		;
			tr.s_done1		= itf.mon_cb.s_done1		;
			tr.s_busy2		= itf.mon_cb.s_busy2		;
			tr.s_done2		= itf.mon_cb.s_done2		;
			tr.s_busy3		= itf.mon_cb.s_busy3		;
			tr.s_done3		= itf.mon_cb.s_done3		;
			ap.write(tr);
		end
	endtask
endclass
