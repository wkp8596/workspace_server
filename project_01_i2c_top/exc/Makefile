VCS_OPTS   = -full64 -sverilog
VCS_OPTS  += -ntb_opts uvm-1.2
VCS_OPTS  += -tiemscale=1ns/1ps
VCS_OPTS  += -debug_access+all -kdb -lca
VCS_OPTS  += -cm line+cond+fsm+tgl+branch+assert
VCS_OUTPUT = -o simv
VCS_INCDIR = +incdir+../tb +incdir+../rtl
VCS_SRC_FILES = ../rtl/i2c_slave.sv ../rtl/i2c_master.sv ../tb/i2c_if.sv ../tb/i2c_pkg.sv ../tb/i2c_tb_top.sv

TEST ?=base_test
SEED ?= 1
INFO_LEVEL ?= UVM_MEDIUM

WKP_DIR ?= ./
PROJECT ?= project_

SIMV_OPTS  = +UVM_TESTNAME=$(TEST)
SIMV_OPTS += +UVM_VERBOSITY=$(INFO_LEVEL)
SIMV_OPTS += +ntb_randome_seed = $(SEED)
SIMV_OPTS += -cm line+cond+fsm+tgl+branch+assert
SIMV_OPTS += -cm_dir coverage.vdb
SIMV_OPTS += -cm_name sim1

.PHONY: all comp simv clean gen

all: simv

comp:
	@vcs $(VCS_OPTS) $(VCS_OUTPUT) $(VCS_INCDIR) $(VCS_SRC_FILES)
	@echo "target [$@]"

simv: comp
	@./simv $(SIMV_OPTS)
	@echo "dependancy target [$<]"
	@echo "target [$@]"


clean:
	@rm -rf simv* csrc *.log *.key *.h
	@echo "clean directory"

gen:
	@mkdir -p $(WKP_DIR)/rtl
	@mkdir -p $(WKP_DIR)/tb
	@mkdir -p $(WKP_DIR)/exc
	@cp Makefile $(WKP_DIR)/exc/Makefile
	@cp tb_template/agent.sv     	$(WKP_DIR)/tb/$(PROJECT)_agent.sv     
	@cp tb_template/coverage.sv  	$(WKP_DIR)/tb/$(PROJECT)_coverage.sv  
	@cp tb_template/driver.sv    	$(WKP_DIR)/tb/$(PROJECT)_driver.sv    
	@cp tb_template/env.sv       	$(WKP_DIR)/tb/$(PROJECT)_env.sv       
	@cp tb_template/if.sv        	$(WKP_DIR)/tb/$(PROJECT)_if.sv        
	@cp tb_template/monitor.sv   	$(WKP_DIR)/tb/$(PROJECT)_monitor.sv   
	@cp tb_template/pkg.sv       	$(WKP_DIR)/tb/$(PROJECT)_pkg.sv       
	@cp tb_template/scoreboard.sv	$(WKP_DIR)/tb/$(PROJECT)_scoreboard.sv
	@cp tb_template/seq_item.sv  	$(WKP_DIR)/tb/$(PROJECT)_seq_item.sv  
	@cp tb_template/sequence.sv  	$(WKP_DIR)/tb/$(PROJECT)_sequence.sv  
	@cp tb_template/test.sv      	$(WKP_DIR)/tb/$(PROJECT)_test.sv      
	@cp tb_template/tb_top.sv    	$(WKP_DIR)/tb/$(PROJECT)_tb_top.sv    
	@cp tb_template/template.sv		$(WKP_DIR)/tb/$(PROJECT)_template.sv	
