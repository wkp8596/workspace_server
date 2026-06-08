
`include "uvm_macros.svh"

import uvm_pkg::*;

interface ram_intf();
	logic		clk		;
	logic		we		;
	logic [7:0]	addr	;
	logic [7:0]	wdata	;
	logic [7:0]	rdata	;
endinterface

class ram_seq_item extends uvm_sequence_item;
	rand logic			we		;
	rand logic [7:0]	addr	;
	rand logic [7:0]	wdata	;
	logic 	   [7:0]	rdata	;

	function new(string name = "ram_seq_item");
		super.new(name);
	endfunction

	`uvm_object_utils_begin(ram_seq_item)
		`uvm_field_int(we, UVM_DEFAULT)
		`uvm_field_int(addr, UVM_DEFAULT)
		`uvm_field_int(wdata, UVM_DEFAULT)
		`uvm_field_int(rdata, UVM_DEFAULT)
	`uvm_object_utils_end
endclass

class ram_seq extends uvm_sequence;
	`uvm_object_utils(ram_seq)

	ram_seq_item a_seq_item;

	function new(string name = "ram_seq");
		super.new(name);
	endfunction

	virtual task body();
		a_seq_item = ram_seq_item::type_id::create("SEQ_ITEM");

		repeat(1000) begin
			start_item(a_seq_item);
			if (!a_seq_item.randomize()) begin
				`uvm_error("SEQ_ITEM", "Fail to generate random value")
			end
			`uvm_info("SEQ", "Data send to Driver", UVM_NONE);
			finish_item(a_seq_item);
		end
	endtask
endclass

class ram_drv extends uvm_driver #(ram_seq_item);
	`uvm_component_utils(ram_drv)

	virtual ram_intf ram_if;
	ram_seq_item a_seq_item;

	function new(string name = "ram_drv", uvm_component c);
		super.new(name, c);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		a_seq_item = ram_seq_item::type_id::create("SEQ_ITEM", this);
		if (!uvm_config_db#(virtual ram_intf)::get(this, "", "ram_if", ram_if)) begin
			`uvm_fatal(get_name(), "Unable to access ram interface.")
		end
	endfunction

	virtual task run_phase(uvm_phase phase);
		$display("Display run phase");
		forever begin
			seq_item_port.get_next_item(a_seq_item);
			@(posedge ram_if.clk);
			#1;
			ram_if.we 		<= a_seq_item.we   ;
			ram_if.addr 	<= a_seq_item.addr ;
			ram_if.wdata 	<= a_seq_item.wdata;
			seq_item_port.item_done();
		end
	endtask
endclass

class ram_mon extends uvm_monitor;
	`uvm_component_utils(ram_mon)

	uvm_analysis_port#(ram_seq_item) send;
	virtual ram_intf ram_if;
	ram_seq_item a_seq_item;

	function new(string name = "ram_mon", uvm_component c);
		super.new(name, c);
		send = new("send", this);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		a_seq_item = ram_seq_item::type_id::create("SEQ_ITEM", this);
		if (!uvm_config_db#(virtual ram_intf)::get(this, "", "ram_if", ram_if)) begin
			`uvm_fatal(get_name(), "Unable to access ram interface");
		end
	endfunction

	virtual task run_phase(uvm_phase phase);
		forever begin
			@(negedge ram_if.clk);
			a_seq_item.we	 	= ram_if.we		;
			a_seq_item.addr	 	= ram_if.addr	;
			a_seq_item.wdata	= ram_if.wdata	;
			a_seq_item.rdata	= ram_if.rdata	;
			`uvm_info("MON", "Send data to Scoreboard", UVM_LOW);
			send.write(a_seq_item);
		end
	endtask

endclass

class ram_scb extends uvm_scoreboard;
	`uvm_component_utils(ram_scb)

	uvm_analysis_imp#(ram_seq_item, ram_scb) recv;

	int pass, fail;
	logic flag;
	logic [7:0] t_addr;
	logic [7:0] vram[0:255];

	function new(string name = "ram_scb", uvm_component c);
		super.new(name, c);
		recv = new("READ", this);
		pass = 0;
		fail = 0;
		flag = 0;
	endfunction

	virtual function void write(ram_seq_item data);
		`uvm_info("SCB", "Data received from Monitor", UVM_LOW);
		if (flag) begin
			if (data.rdata === vram[t_addr]) begin
				`uvm_info("SCB", $sformatf("PASS!, vram[addr] : rdata = %0d, vdata = %0d", data.rdata, vram[t_addr]), UVM_LOW);
				`uvm_info("PASS", $sformatf(""), UVM_LOW);
				pass++;
			end else begin
				`uvm_error("SCB", $sformatf("FAIL!, vram[addr] : rdata = %0d, vdata = %0d", data.rdata, vram[t_addr]));
				`uvm_info("FAIL", $sformatf(""), UVM_LOW);
				fail++;
			end
			flag = 0;
		end
		if (data.we) begin
			flag = 0;
			vram[data.addr] = data.wdata;
		end else begin
			flag = 1;
			t_addr = data.addr;
		end
	endfunction
endclass

class ram_agent extends uvm_agent;
	`uvm_component_utils(ram_agent)

	ram_mon r_mon;
	ram_drv r_drv;
	uvm_sequencer#(ram_seq_item) a_sqr;

	function new(string name = "ram_agent", uvm_component c);
		super.new(name, c);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		r_mon = ram_mon::type_id::create("MON", this);
		r_drv = ram_drv::type_id::create("DRV", this);
		a_sqr = uvm_sequencer#(ram_seq_item)::type_id::create("SQR", this);
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		r_drv.seq_item_port.connect(a_sqr.seq_item_export);
	endfunction
endclass

class ram_env extends uvm_env;
	`uvm_component_utils(ram_env)

	ram_agent a_agt;
	ram_scb a_scb;

	function new(string name = "ram_env", uvm_component c);
		super.new(name, c);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		a_agt = ram_agent::type_id::create("AGT", this);
		a_scb = ram_scb::type_id::create("SCB", this);
	endfunction

	virtual function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		a_agt.r_mon.send.connect(a_scb.recv);
	endfunction
endclass

class ram_test extends uvm_test;
	`uvm_component_utils(ram_test)

	ram_seq a_seq;
	ram_env a_env;

	function new(string name = "ram_test", uvm_component c);
		super.new(name, c);
	endfunction

	virtual function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		a_seq = ram_seq::type_id::create("SEQ", this);	//	make instance
		a_env = ram_env::type_id::create("ENV", this);	//	make instance
	endfunction

	virtual task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		a_seq.start(a_env.a_agt.a_sqr);
		phase.drop_objection(this);
	endtask
endclass

module tb_ram();

	ram_intf ram_if();

	logic clk = 0;

	always #5 clk = ~clk;

	assign ram_if.clk = clk;

	ram dut(
		.clk	(ram_if.clk		),
		.we		(ram_if.we		),
		.addr	(ram_if.addr	),
		.wdata	(ram_if.wdata	),
		.rdata	(ram_if.rdata	) 
	);

	initial begin
		$fsdbDumpfile("wave.fsdb");
		$fsdbDumpvars(0);
	end

	initial begin
		uvm_config_db#(virtual ram_intf)::set(null, "*", "ram_if", ram_if);
		run_test("ram_test");
	end

endmodule
