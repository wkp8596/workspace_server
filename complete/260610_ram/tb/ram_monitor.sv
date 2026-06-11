class ram_monitor extends uvm_monitor;
	`uvm_component_utils(ram_monitor)

	uvm_analysis_port#(ram_seq_item) ap;

	virtual ram_if r_if;

	function new(string name, uvm_component parent);
		super.new(name, parent);
		ap = new("ap", this);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		if (!uvm_config_db#(virtual ram_if)::get(this, "", "r_if", r_if))
			`uvm_fatal(get_type_name(), "virtual interface(f_if) can't find in config_db.")
	endfunction

	task run_phase(uvm_phase phase);
		ram_seq_item tr;
		ram_seq_item pending_rd = null;
		@(r_if.mon_cb);
		forever begin
			@(r_if.mon_cb);
			if (pending_rd != null) begin
				pending_rd.rdata = r_if.mon_cb.rdata;
				`uvm_info(get_type_name(), $sformatf("%s", tr.c2s()), UVM_HIGH)
				ap.write(pending_rd);
				pending_rd = null;
			end
			tr = ram_seq_item::type_id::create("tr");
			tr.we		=	r_if.mon_cb.we;
			tr.addr		=	r_if.mon_cb.addr;
			tr.wdata	=	r_if.mon_cb.wdata;

			if (tr.we) begin
				ap.write(tr);
				`uvm_info(get_type_name(), $sformatf("%s", tr.c2s()), UVM_HIGH)
			end else begin
				pending_rd = tr;
			end
		end
	endtask
endclass
