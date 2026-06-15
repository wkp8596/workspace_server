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

		cp_tx_data : coverpoint tr.tx_data {
			bins tx_zero 	= {8'h00};
			bins tx_0		= {[8'h01:8'h19]};
			bins tx_1		= {[8'h20:8'h31]};
			bins tx_2		= {[8'h32:8'h4a]};
			bins tx_3		= {[8'h4b:8'h63]};
			bins tx_4		= {[8'h64:8'h7c]};
			bins tx_5		= {[8'h7d:8'h95]};
			bins tx_6		= {[8'h96:8'hae]};
			bins tx_7		= {[8'haf:8'hc7]};
			bins tx_8		= {[8'hc8:8'he0]};
			bins tx_9		= {[8'he1:8'hf9]};
			bins tx_10		= {[8'hfa:8'hfe]};
			bins tx_max  	= {8'hff};
		}

		cp_rx_data : coverpoint tr.rx_data {
			bins rx_zero 	= {8'h00};
			bins rx_0		= {[8'h01:8'h19]};
			bins rx_1		= {[8'h20:8'h31]};
			bins rx_2		= {[8'h32:8'h4a]};
			bins rx_3		= {[8'h4b:8'h63]};
			bins rx_4		= {[8'h64:8'h7c]};
			bins rx_5		= {[8'h7d:8'h95]};
			bins rx_6		= {[8'h96:8'hae]};
			bins rx_7		= {[8'haf:8'hc7]};
			bins rx_8		= {[8'hc8:8'he0]};
			bins rx_9		= {[8'he1:8'hf9]};
			bins rx_10		= {[8'hfa:8'hfe]};
			bins rx_max  	= {8'hff};
		}

		cx_mode_pol_pha : cross cp_pol, cp_pha;

	endgroup

	function new(string name, uvm_component parent);
		super.new(name, parent);
		cg = new();
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
	endfunction

	function void write(seq_item item);
		tr = item;
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
		`uvm_info(get_type_name(), $sformatf("	tx_data				: %6.2f %%", cg.cp_tx_data.get_inst_coverage()), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("	rx_data				: %6.2f %%", cg.cp_rx_data.get_inst_coverage()), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("	pol x pha			: %6.2f %%", cg.cx_mode_pol_pha.get_inst_coverage()), UVM_LOW);
		`uvm_info(get_type_name(), "===================================================", UVM_LOW);

		if (cg.get_inst_coverage() < 95) begin
			`uvm_warning(get_type_name(), "Coverage is UNDER 99.9%!!, NEED MORE TEST")
		end
	endfunction
endclass
