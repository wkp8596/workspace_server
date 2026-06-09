module ram (
	input  logic		clk		,
	input  logic		we		,
	input  logic [7:0]	addr	,
	input  logic [7:0]	wdata	,
	output logic [7:0]	rdata	 
);

	logic [7:0] bram[0:255];

	always @(posedge clk) begin
		if (we) begin
			bram[addr] = wdata;
		end else begin
			rdata = bram[addr];
		end
	end

endmodule
