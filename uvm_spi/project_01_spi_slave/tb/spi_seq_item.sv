class seq_item extends uvm_sequence_item;
	rand	logic			cpol		;
	rand	logic			cpha		;
	rand	logic	[7:0]	clk_div		;
	rand	logic	[7:0]	delay		;
	rand	logic	[7:0]	rx_data		;
	rand	logic	[7:0]	tx_data		;
	logic					busy		;
	logic					done		;
	logic					sclk		;
	logic					mosi		;
	logic					miso		;
	logic					nss			;


	`uvm_object_utils_begin(seq_item)
		`uvm_field_int(cpol			, UVM_ALL_ON)
		`uvm_field_int(cpha			, UVM_ALL_ON)
		`uvm_field_int(clk_div		, UVM_ALL_ON)
		`uvm_field_int(delay		, UVM_ALL_ON)
		`uvm_field_int(tx_data		, UVM_ALL_ON)
		`uvm_field_int(busy			, UVM_ALL_ON)
		`uvm_field_int(rx_data		, UVM_ALL_ON)
		`uvm_field_int(done			, UVM_ALL_ON)
		`uvm_field_int(sclk			, UVM_ALL_ON)
		`uvm_field_int(mosi			, UVM_ALL_ON)
		`uvm_field_int(miso			, UVM_ALL_ON)
		`uvm_field_int(nss			, UVM_ALL_ON)
	`uvm_object_utils_end

	function new(string name = "seq_item");
		super.new(name);
	endfunction

	task run_phase(uvm_phase phase);
	endtask

	function string srt_data();
		return $sformatf("cpol : %0d, cpha : %0d, clk_div : %0d, tx_data : %0d", cpol, cpha, clk_div, tx_data);
	endfunction

	function string complete_data();
		return $sformatf("sclk : %d, mosi : %d, miso : %d, nss : %d", sclk, mosi, miso, nss);
	endfunction
endclass
