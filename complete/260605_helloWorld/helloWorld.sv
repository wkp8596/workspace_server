
`include "uvm_macros.svh"
import uvm_pkg::*;

class hello_test extends uvm_test;  // callee
	`uvm_component_utils(hello_test)

	function new(string name = "hello_test", uvm_component parent = null);
		super.new(name, parent);
	endfunction

	function void build_phase(uvm_phase phase);
		super.build_phase(phase);
		`uvm_info("BUILD_PHASE", "[1] build_phase run", UVM_LOW);
	endfunction

	function void connect_phase(uvm_phase phase);
		super.connect_phase(phase);
		`uvm_info("CONNECT_PHASE", "[2] connect_phase run", UVM_LOW);
	endfunction

	task run_phase(uvm_phase phase);
		phase.raise_objection(this);
		`uvm_info("RUN_PHASE", "[3] run_phase run", UVM_LOW);
		`uvm_info("HELLO", "First UVM Program is Excuted!", UVM_LOW);
		`uvm_info("RUN_PHASE", "[4] run_phase stop", UVM_LOW);
		phase.drop_objection(this);
	endtask

	function void report_phase(uvm_phase phase);
		super.report_phase(phase);
		`uvm_info("REPORT_PHASE", "[5] report_phase run", UVM_LOW);
	endfunction
endclass

module test_uvm();  // caller

	initial begin
		run_test("hello_test");
	end

endmodule
