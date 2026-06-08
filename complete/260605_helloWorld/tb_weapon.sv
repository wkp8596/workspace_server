class weapon;
	string name;
	function new(string name);
		this.name = name;
	endfunction

	virtual function void shot();
		$display("	[%s]... (No Weapon)", name);
	endfunction
endclass

class M16 extends weapon;
	function new(string name);
		super.new(name);
	endfunction

	virtual function void shot();
		$display("	[%s] TANG TANG TANG !!!", name);
	endfunction
endclass

class AUG extends weapon;
	function new(string name);
		super.new(name);
	endfunction

	virtual function void shot();
		$display("	[%s] BEEEEEEE TUNG TUNG TUNG !!!", name);
	endfunction
endclass

class K2 extends weapon;
	function new(string name);
		super.new(name);
	endfunction

	virtual function void shot();
		$display("	[%s] BANG BANG BANG !!!", name);
	endfunction
endclass

module tb_weapon();

	initial begin
		weapon BlackPink = new("No Weapon");


		M16 m16 = new("M16");
		AUG aug = new("AUB");
		K2  k2 	= new("K2");

		$display("===== DEMO =====");
		BlackPink.shot();

		$display("===== Weapon Change to M16 =====");
		BlackPink = m16;
		BlackPink.shot();

		$display("===== Weapon Change to AUG =====");
		BlackPink = aug;
		BlackPink.shot();

		$display("===== Weapon Change to K2 =====");
		BlackPink = k2;
		BlackPink.shot();

		$finish;
	end

endmodule
