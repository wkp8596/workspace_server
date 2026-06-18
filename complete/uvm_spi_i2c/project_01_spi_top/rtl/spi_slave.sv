module spi_slave(
	input  logic			clk		,
	input  logic			rst		,
	
	input  logic			cpol	,
	input  logic			cpha	,

	input  logic	[7:0]	tx_data	,

	output logic			busy	,
	output logic			done	,
	output logic	[7:0]	rx_data	,

	input  logic			sclk	,
	input  logic			mosi	,
	output logic			miso	,
	input  logic			nss		 
    );

	typedef enum logic [1:0] {
		IDLE = 2'b00, START, DATA, STOP
	} spi_state_e;
	spi_state_e state;

	logic [7:0]	tx_shift_reg;
	logic [7:0]	rx_shift_reg;
	logic [2:0]	bit_cnt;
	logic		step;

	logic		cpol_reg;
	logic		cpha_reg;

	logic		sclk_reg;

	logic		edge_detect;

	assign edge_detect = sclk_reg ^ sclk;

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			sclk_reg <= 1'b0;
		end else begin
			sclk_reg <= sclk;
		end
	end

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			state			<= IDLE;

			tx_shift_reg	<= 0;
			rx_shift_reg	<= 0;
			bit_cnt			<= 0;
			step			<= 1'b0;

			busy			<= 1'b0;
			done			<= 1'b0;
			rx_data			<= 0;
			miso			<= 1'bz;

			cpol_reg		<= 1'b0;
			cpha_reg		<= 1'b0;
		end else begin
			done <= 1'b0;
			case (state)
				IDLE:	begin
					tx_shift_reg	<= 0;
					rx_shift_reg	<= 0;
					bit_cnt			<= 0;
					step			<= 1'b0;

					busy			<= 1'b0;
					done			<= 1'b0;
					miso			<= 1'bz;
					if (!nss) begin
						state	<= START;
						cpol_reg		<= cpol;
						cpha_reg		<= cpha;
						tx_shift_reg	<= tx_data;
						busy			<= 1'b1;
						miso			<= tx_data[7];
					end
				end
				START:	begin
					if (nss) begin
						state	<= IDLE;
					end else begin
						if (cpha_reg) begin
							if (edge_detect) begin
								state			<= DATA;
								miso			<= tx_shift_reg[7];
								tx_shift_reg	<= {tx_shift_reg[6:0], 1'b0};
							end
						end else  begin
							state			<= DATA;
							miso			<= tx_shift_reg[7];
							tx_shift_reg	<= {tx_shift_reg[6:0], 1'b0};
						end
					end
				end
				DATA:	begin
					if (nss) begin
						state <= IDLE;
					end else begin
						if (edge_detect) begin
							if (!step) begin
								rx_shift_reg	<= {rx_shift_reg[6:0], mosi};
								step			<= 1'b1;
							end else begin
								if (bit_cnt < 7) begin
									miso			<= tx_shift_reg[7];
									tx_shift_reg	<= {tx_shift_reg[6:0], 1'b0};
									step			<= 1'b0;
									bit_cnt			<= bit_cnt + 1;
								end else begin
									state	<= STOP;
									rx_data <= rx_shift_reg;
								end
							end
						end
					end
				end
				STOP:	begin
					state	<= IDLE;
					done	<= 1'b1;
					busy	<= 1'b0;
					miso	<= 1'b1;
				end
				default: begin
					state			<= IDLE;

					tx_shift_reg	<= 0;
					rx_shift_reg	<= 0;
					bit_cnt			<= 0;
					step			<= 1'b0;

					busy			<= 1'b0;
					done			<= 1'b0;
					rx_data			<= 0;
					miso			<= 1'b1;
					cpol_reg		<= 1'b0;
					cpha_reg		<= 1'b0;
				end
			endcase
		end
	end

endmodule
