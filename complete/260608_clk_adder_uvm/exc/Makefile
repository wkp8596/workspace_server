VCS_OPTS  = -full64 -sverilog
VCS_OPTS += -ntb_opts uvm-1.2
VCS_OPTS += -tiemscale=1ns/1ps
VCS_OPTS += -debug_access+all -kdb -lca

VCS_SRC_FILES = ../rtl/adder.sv ../tb/tb_adder.sv

VCS_OUTPUT = -o simv

SIMV_OPTS  = +UVM_TESTNAME=adder_test
SIMV_OPTS += +UVM_VERBOSITY=UVM_MEDIUM
SIMV_OPTS += +ntb_randome_seed = 1234 
.PHONY: compile simv clean

compile:
	@vcs $(VCS_OPTS) $(VCS_OUTPUT) $(VCS_SRC_FILES)
	@echo "target [$@]"

simv: compile
	@./simv $(SIMV_OPTS)
	@echo "dependancy target [$<]"
	@echo "target [$@]"


clean:
	@rm -rf simv* csrc *.log *.key *.h
	@echo "clean directory"


A := hello
B := $(A) world
A ?= goodbye

test:
	@echo $(B)
