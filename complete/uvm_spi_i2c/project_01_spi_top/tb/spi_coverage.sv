class coverage extends uvm_subscriber#(seq_item);
	`uvm_component_utils(coverage)

	seq_item tr;

	covergroup cg;
		option.per_instance = 1;
		cp_clk_div : coverpoint tr.clk_div {
			bins div_zero 	= {8'h00};
			bins div_0		= {[8'h01:8'h19]};
			bins div_1		= {[8'h20:8'h31]};
			bins div_2		= {[8'h32:8'h4a]};
			bins div_3		= {[8'h4b:8'h63]};
			bins div_4		= {[8'h64:8'h7c]};
			bins div_5		= {[8'h7d:8'h95]};
			bins div_6		= {[8'h96:8'hae]};
			bins div_7		= {[8'haf:8'hc7]};
			bins div_8		= {[8'hc8:8'he0]};
			bins div_9		= {[8'he1:8'hf9]};
			bins div_10		= {[8'hfa:8'hfe]};
			bins div_max  	= {8'hff};
		}

		cp_pol : coverpoint tr.cpol {
			bins pol_high = {0};
			bins pol_low  = {1};
		}

		cp_pha : coverpoint tr.cpha {
			bins pha_high = {0};
			bins pha_low  = {1};
		}

		cp_ss : coverpoint tr.sel_ss {
			bins s_0 = {2'b00};
			bins s_1 = {2'b01};
			bins s_2 = {2'b10};
			bins s_3 = {2'b11};
		}

		cp_m_tx_data : coverpoint tr.m_tx_data {
			bins tx_zero 	= {8'h00};
			bins tx_0		= {[8'h01:8'h19]};
			bins tx_1		= {[8'h20:8'h31]};
			bins tx_2		= {[8'h32:8'h54]};
			bins tx_55		= {8'h55};
			bins tx_3		= {[8'h56:8'h63]};
			bins tx_4		= {[8'h64:8'h7c]};
			bins tx_5		= {[8'h7d:8'h95]};
			bins tx_6		= {[8'h96:8'ha9]};
			bins tx_aa		= {8'haa};
			bins tx_7		= {[8'hab:8'hc7]};
			bins tx_8		= {[8'hc8:8'he0]};
			bins tx_9		= {[8'he1:8'hf9]};
			bins tx_10		= {[8'hfa:8'hfe]};
			bins tx_max  	= {8'hff};
		}

		cp_s0_tx_data : coverpoint tr.s_tx_data0 {
			bins tx_zero 	= {8'h00};
			bins tx_0		= {[8'h01:8'h19]};
			bins tx_1		= {[8'h20:8'h31]};
			bins tx_2		= {[8'h32:8'h54]};
			bins tx_55		= {8'h55};
			bins tx_3		= {[8'h56:8'h63]};
			bins tx_4		= {[8'h64:8'h7c]};
			bins tx_5		= {[8'h7d:8'h95]};
			bins tx_6		= {[8'h96:8'ha9]};
			bins tx_aa		= {8'haa};
			bins tx_7		= {[8'hab:8'hc7]};
			bins tx_8		= {[8'hc8:8'he0]};
			bins tx_9		= {[8'he1:8'hf9]};
			bins tx_10		= {[8'hfa:8'hfe]};
			bins tx_max  	= {8'hff};
		}

		cp_s1_tx_data : coverpoint tr.s_tx_data1 {
			bins tx_zero 	= {8'h00};
			bins tx_0		= {[8'h01:8'h19]};
			bins tx_1		= {[8'h20:8'h31]};
			bins tx_2		= {[8'h32:8'h54]};
			bins tx_55		= {8'h55};
			bins tx_3		= {[8'h56:8'h63]};
			bins tx_4		= {[8'h64:8'h7c]};
			bins tx_5		= {[8'h7d:8'h95]};
			bins tx_6		= {[8'h96:8'ha9]};
			bins tx_aa		= {8'haa};
			bins tx_7		= {[8'hab:8'hc7]};
			bins tx_8		= {[8'hc8:8'he0]};
			bins tx_9		= {[8'he1:8'hf9]};
			bins tx_10		= {[8'hfa:8'hfe]};
			bins tx_max  	= {8'hff};
		}

		cp_s2_tx_data : coverpoint tr.s_tx_data2 {
			bins tx_zero 	= {8'h00};
			bins tx_0		= {[8'h01:8'h19]};
			bins tx_1		= {[8'h20:8'h31]};
			bins tx_2		= {[8'h32:8'h54]};
			bins tx_55		= {8'h55};
			bins tx_3		= {[8'h56:8'h63]};
			bins tx_4		= {[8'h64:8'h7c]};
			bins tx_5		= {[8'h7d:8'h95]};
			bins tx_6		= {[8'h96:8'ha9]};
			bins tx_aa		= {8'haa};
			bins tx_7		= {[8'hab:8'hc7]};
			bins tx_8		= {[8'hc8:8'he0]};
			bins tx_9		= {[8'he1:8'hf9]};
			bins tx_10		= {[8'hfa:8'hfe]};
			bins tx_max  	= {8'hff};
		}

		cp_s3_tx_data : coverpoint tr.s_tx_data3 {
			bins tx_zero 	= {8'h00};
			bins tx_0		= {[8'h01:8'h19]};
			bins tx_1		= {[8'h20:8'h31]};
			bins tx_2		= {[8'h32:8'h54]};
			bins tx_55		= {8'h55};
			bins tx_3		= {[8'h56:8'h63]};
			bins tx_4		= {[8'h64:8'h7c]};
			bins tx_5		= {[8'h7d:8'h95]};
			bins tx_6		= {[8'h96:8'ha9]};
			bins tx_aa		= {8'haa};
			bins tx_7		= {[8'hab:8'hc7]};
			bins tx_8		= {[8'hc8:8'he0]};
			bins tx_9		= {[8'he1:8'hf9]};
			bins tx_10		= {[8'hfa:8'hfe]};
			bins tx_max  	= {8'hff};
		}

		cx_mode_pol_pha : cross cp_pol, cp_pha;

		cx_mode_ss : cross cp_pol, cp_pha, cp_ss;

		cx_m_s_data	:	cross cp_m_tx_data, cp_s0_tx_data;

		//cx_tx_data_ss : cross cp_ss, cp_s0_tx_data, cp_s1_tx_data, cp_s2_tx_data, cp_s3_tx_data;
	endgroup

	function new(string name, uvm_component parent);
		super.new(name, parent);
		cg = new();
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	function void write(seq_item t);
		tr = t;
		cg.sample();
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
	endtask

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info(get_type_name(), "===================================================", UVM_LOW);
		`uvm_info(get_type_name(), "=========== Functional Coverage Results ===========", UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("	Total				: %6.2f %%", cg.get_inst_coverage()), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("	clk_div				: %6.2f %%", cg.cp_clk_div.get_inst_coverage()), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("	pol				: %6.2f %%", cg.cp_pol.get_inst_coverage()), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("	pha				: %6.2f %%", cg.cp_pha.get_inst_coverage()), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("	ss				: %6.2f %%", cg.cp_ss.get_inst_coverage()), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("	m_tx_data			: %6.2f %%", cg.cp_m_tx_data.get_inst_coverage()), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("	s_tx_data0			: %6.2f %%", cg.cp_s0_tx_data.get_inst_coverage()), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("	s_tx_data1			: %6.2f %%", cg.cp_s1_tx_data.get_inst_coverage()), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("	s_tx_data2			: %6.2f %%", cg.cp_s2_tx_data.get_inst_coverage()), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("	s_tx_data3			: %6.2f %%", cg.cp_s3_tx_data.get_inst_coverage()), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("	pol x pha			: %6.2f %%", cg.cx_mode_pol_pha.get_inst_coverage()), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("	pol x pha x ss			: %6.2f %%", cg.cx_mode_ss.get_inst_coverage()), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("	rx x tx				: %6.2f %%", cg.cx_m_s_data.get_inst_coverage()), UVM_LOW);	
		//`uvm_info(get_type_name(), $sformatf("	tx_data x ss		: %6.2f %%", cg.cx_tx_data_ss.get_inst_coverage()), UVM_LOW);
		`uvm_info(get_type_name(), "===================================================", UVM_LOW);

		if (cg.get_inst_coverage() < 95) begin
			`uvm_warning(get_type_name(), "Coverage is UNDER 99.9%!!, NEED MORE TEST")
		end
	endfunction
endclass
