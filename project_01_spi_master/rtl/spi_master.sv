module spi_master(
	input  logic			clk			,
	input  logic			rst			,

	input  logic			start		,
	input  logic			cpol		,
	input  logic			cpha		,
	input  logic	[7:0]	clk_div		,
	input  logic	[7:0]	tx_data		,

	output logic			busy		,
	output logic	[7:0]	rx_data		,
	output logic			done		,

	output logic			sclk		,
	output logic			mosi		,
	input  logic			miso		,
	output logic			nss			 
);

	typedef enum logic [1:0] {
		IDLE = 2'b00, START, DATA, STOP
	} spi_state_e;

	spi_state_e state;

	logic [7:0] div_cnt;
	logic [7:0]	clk_div_reg;
	logic		half_tick;
	logic [7:0]	tx_shift_reg;
	logic [7:0]	rx_shift_reg;
	logic [2:0]	bit_cnt;
	logic		step;
	logic		sclk_reg;
	logic		cpol_reg;
	logic		cpha_reg;

	assign sclk = sclk_reg;

	always_ff @(posedge clk or posedge rst) begin
		if (rst) begin
			div_cnt		<= 0;
			half_tick	<= 1'b0;
		end else begin
			if (state != IDLE) begin
				if (div_cnt == clk_div_reg) begin
					div_cnt		<= 0;
					half_tick	<= 1'b1;
				end else begin
					div_cnt		<= div_cnt + 1;
					half_tick	<= 1'b0;
				end
			end else begin
				div_cnt <= 0;
			end
		end
	end

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			state 			<= IDLE;
			step			<= 1'b0;
			mosi			<= 1'b1;
			nss				<= 1'b1;
			busy			<= 1'b0;
			done			<= 1'b0;
			tx_shift_reg	<= 0;
			rx_shift_reg	<= 0;
			bit_cnt			<= 0;
			cpol_reg		<= 1'b0;
			clk_div_reg		<= 0;
			sclk_reg		<= 1'b0;
			rx_data			<= 0;
		end else begin
			done <= 1'b0;
			case (state)
				IDLE:	begin
					mosi		<= 1'b1;
					nss			<= 1'b1;
					sclk_reg	<= cpol;
					if (start) begin
						state 			<= START;
						cpol_reg		<= cpol;
						cpha_reg		<= cpha;
						tx_shift_reg 	<= tx_data;
						clk_div_reg		<= clk_div;
						bit_cnt			<= 0;
						busy			<= 1'b1;
						step			<= 1'b0;
						nss				<= 1'b0;
					end
				end
				START:	begin
					if (cpha_reg) begin
						if (half_tick) begin
							sclk_reg 		<= ~sclk_reg;
							state 			<= DATA;
							mosi			<= tx_shift_reg[7];
							tx_shift_reg 	<= {tx_shift_reg[6:0], 1'b0};
						end
					end else begin
						state 			<= DATA;
						mosi			<= tx_shift_reg[7];
						tx_shift_reg 	<= {tx_shift_reg[6:0], 1'b0};
					end
				end
				DATA:	begin
					if (half_tick) begin
						sclk_reg <= ~sclk_reg;
						if (!step) begin
							state 			<= DATA;
							rx_shift_reg 	<= {rx_shift_reg[6:0], miso};
							step 			<= 1'b1;
						end else begin
							if (bit_cnt < 7) begin
								mosi			<= tx_shift_reg[7];
								tx_shift_reg 	<= {tx_shift_reg[6:0], 1'b0};
								step			<= 1'b0;
								bit_cnt			<= bit_cnt + 1;
							end else begin
								state 	<= STOP;
								rx_data	<= rx_shift_reg;
							end
						end
					end
				end
				STOP:	begin
					state		<= IDLE;
					nss			<= 1'b1;
					done		<= 1'b1;
					busy		<= 1'b0;
					mosi		<= 1'b1;
					sclk_reg	<= cpol_reg;
				end
				default: begin
					state 			<= IDLE;
					mosi			<= 1'b1;
					nss				<= 1'b1;
					busy			<= 1'b0;
					done			<= 1'b0;
					tx_shift_reg	<= 0;
					rx_shift_reg	<= 0;
					bit_cnt			<= 0;
					cpol_reg		<= 1'b0;
					clk_div_reg		<= 0;
					sclk_reg		<= 1'b0;
					rx_data			<= 0;
				end
			endcase
		end
	end


endmodule
