class coverage extends uvm_subscriber#(seq_item);
	`uvm_component_utils(coverage)

	seq_item tr;

	covergroup cg;
		option.per_instance = 1;

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

		cp_s_tx_data : coverpoint tr.s_tx_data {
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
		`uvm_info(get_type_name(), $sformatf("	s_tx_data				: %6.2f %%", cg.cp_m_tx_data.get_inst_coverage()), UVM_LOW);
		`uvm_info(get_type_name(), $sformatf("	m_tx_data				: %6.2f %%", cg.cp_s_tx_data.get_inst_coverage()), UVM_LOW);
		`uvm_info(get_type_name(), "===================================================", UVM_LOW);

		if (cg.get_inst_coverage() < 99.9) begin
			`uvm_warning(get_type_name(), "Coverage is UNDER 99.9%!!, NEED MORE TEST")
		end
	endfunction
endclass
