interface ram_if();
	logic		clk	;
	logic		we	;
	logic [7:0]	addr	;
	logic [7:0]	wdata	;
	logic [7:0]	rdata	;
endinterface

class transaction;
	rand	logic		we	;
	rand	logic [7:0]	addr	;
	rand	logic [7:0]	wdata	;
		logic [7:0]	rdata	;
endclass

class generator;
	transaction tr;
	mailbox #(transaction) g2d;
	event e_g_n;

	function new(mailbox #(transaction) g2d, event e_g_n);
		this.g2d = g2d;
		this.e_g_n = e_g_n;
	endfunction

	task run(int count);
		repeat(count) begin
			tr = new();
			tr.randomize();
			g2d.put(tr);
			@(e_g_n);
		end
	endtask
endclass

class driver;
	transaction tr;
	mailbox #(transaction) g2d;
	virtual ram_if ramif;

	function new(mailbox #(transaction) g2d, virtual ram_if ramif);
		this.g2d = g2d;
		this.ramif = ramif;
	endfunction

	task run();
		forever begin
			g2d.get(tr);
			@(posedge ramif.clk);
			#1;
			ramif.we	= tr.we;
			ramif.addr	= tr.addr;
			ramif.wdata	= tr.wdata;
		end
	endtask
endclass

class monitor;
	transaction tr;
	mailbox #(transaction) m2s;
	virtual ram_if ramif;

	function new(mailbox #(transaction) m2s, virtual ram_if ramif);
		this.m2s = m2s;
		this.ramif = ramif;
	endfunction

	task run();
		forever begin
			tr = new();
			@(negedge ramif.clk);
			tr.we		= ramif.we;
			tr.addr		= ramif.addr;
			tr.wdata	= ramif.wdata;
			tr.rdata	= ramif.rdata;
			m2s.put(tr);
		end
	endtask
endclass

class scoreboard;
	transaction tr;
	mailbox #(transaction) m2s;
	event e_g_n;

	int pass, fail;

	logic flag;
	logic [7:0] t_addr;
	logic [7:0] vram [0:255];

	function new(mailbox #(transaction) m2s, event e_g_n);
		pass = 0;
		fail = 0;
		this.m2s = m2s;
		this.e_g_n = e_g_n;
	endfunction

	task run();
		forever begin
			m2s.get(tr);
			if (flag) begin
				if (tr.rdata === vram[t_addr]) begin
					$display("Pass! we : %d rdata = %d == tdata = %d", tr.we, tr.rdata, vram[t_addr]);
					pass++;
				end else begin
					$display("Fail! we : %d rdata = %d == tdata = %d", tr.we, tr.rdata, vram[t_addr]);
					fail++;
				end
				flag = 0;
			end
			if (tr.we) begin
				vram[tr.addr] = tr.wdata;
				flag = 0;
			end else begin
				flag = 1;
				t_addr = tr.addr;
			end
			-> e_g_n;
		end
	endtask
endclass

class environment;
	generator	gen;
	driver		drv;
	monitor		mon;
	scoreboard	scb;

	
	virtual ram_if ramif;
	mailbox #(transaction) g2d;
	mailbox #(transaction) m2s;
	event e_g_n;

	function new(virtual ram_if ramif);
		g2d = new();
		m2s = new();
		gen = new(g2d, e_g_n);
                drv = new(g2d, ramif);
                mon = new(m2s, ramif);
                scb = new(m2s, e_g_n);
	endfunction

	task run();
		fork
			gen.run(1000);
			drv.run();
			mon.run();
			scb.run();
		join_any
		$display("Total test count : %d", scb.pass + scb.fail);
		$display("FAIL		   : %d", scb.fail);
		$display("PASS		   : %d", scb.pass);

		#10;
		$finish;
	endtask
endclass

module tb_ram();

	ram_if ramif();

	ram dut(
		.clk	(ramif.clk	),
		.we	(ramif.we	),
		.addr	(ramif.addr	),
		.wdata	(ramif.wdata	),
		.rdata	(ramif.rdata	) 
	);

	environment env;

	always #5 ramif.clk = ~ramif.clk;

	initial begin
		$fsdbDumpfile("tb_wave.fsdb");
		$fsdbDumpvars(0);
	end

	initial begin
		ramif.clk = 0;
		env = new(ramif);
		env.run();
	end

endmodule
