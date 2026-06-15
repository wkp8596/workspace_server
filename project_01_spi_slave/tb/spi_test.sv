class base_test extends uvm_test;
	`uvm_component_utils(base_test)

	environment env;

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		env = environment::type_id::create("env", this);
		uvm_top.set_timeout(200_000_000ns, 1);
	endfunction

	function void end_of_elaboration_phase(uvm_phase phase);
		super.end_of_elaboration_phase(phase);
		uvm_top.print_topology();
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
	endfunction

	task run_phase(uvm_phase phase);
		base_seq seq;
		phase.raise_objection(this);
		seq = base_seq::type_id::create("seq", this);
		seq.num = 100;
		seq.start(env.agt.sqr);

		#50;
		phase.drop_objection(this);
	endtask

endclass

class burst_test extends base_test;
	`uvm_component_utils(burst_test)

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	task run_phase(uvm_phase phase);
		burst_seq seq;
		phase.raise_objection(this);
		seq = burst_seq::type_id::create("seq", this);
		seq.num = 100;
		seq.start(env.agt.sqr);

		#50;
		phase.drop_objection(this);
	endtask

endclass

class term_test extends base_test;
	`uvm_component_utils(term_test)

	function new(string name, uvm_component parent);
		super.new(name, parent);
	endfunction

	task run_phase(uvm_phase phase);
		term_seq seq;
		phase.raise_objection(this);
		seq = term_seq::type_id::create("seq", this);
		seq.num = 100;
		seq.start(env.agt.sqr);

		#50;
		phase.drop_objection(this);
	endtask

endclass
