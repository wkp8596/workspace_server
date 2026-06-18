module i2c_slave_top (
	input  logic			clk			,
	input  logic			rst			,

	output logic			ack_out		,

	input  logic			scl			,
	inout  			sda			,

	input  logic [7:0]		tx_data		,
	output logic [7:0]		rx_data		,
	output logic			busy		,
	output logic			done		 
);
	logic sda_i, sda_o;

	assign sda_i = sda;
	assign sda = sda_o ? 1'bz : 1'b0;

	i2c_slave U_I2C_SLAVE(
		.*,
		.ack_in		(1'b0),
		.sda_i		(sda_i),
		.sda_o		(sda_o)
    );

endmodule

module i2c_slave(
	input  logic			clk			,
	input  logic			rst			,

	input  logic			ack_in		,
	output logic			ack_out		,

	input  logic			scl			,
	input  logic			sda_i		,
	output logic			sda_o		,

	input  logic [7:0]		tx_data		,
	output logic [7:0]		rx_data		,
	output logic			busy		,
	output logic			done		 
    );

	typedef enum logic [2:0] {
		IDLE = 3'b000, START, ADDR, WRITE, READ, ACK, STOP, WAIT
	} i2c_state_e;
	i2c_state_e state;

	logic [3:0] sda_sync;
	logic [3:0] scl_sync;

	logic sda_vld, scl_vld;
	logic sda_reg, scl_reg;

	logic stop_detect;
	logic start_detect;
	logic negedge_sda, posedge_sda;
	logic posedge_scl, negedge_scl;

	logic [7:0] tx_shift_reg;
	logic [7:0] rx_shift_reg;
	logic is_read;
	logic [3:0] bit_cnt;

	logic sda_r;
	logic step, add;

	assign sda_o = sda_r;

	assign sda_vld = &sda_sync;
	assign scl_vld = &scl_sync;

	assign negedge_sda = sda_reg & !sda_vld;
	assign posedge_sda = !sda_reg & sda_vld;
	assign posedge_scl = !scl_reg & scl_vld;
	assign negedge_scl = scl_reg & !scl_vld;

	assign stop_detect  = scl_vld & posedge_sda;
	assign start_detect = scl_vld & negedge_sda;

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			sda_sync <= 0;
			scl_sync <= 0;
			sda_reg  <= 0;
			scl_reg  <= 0;
		end else begin
			sda_sync <= {sda_sync[2:0], sda_i};
			scl_sync <= {scl_sync[2:0], scl};
			sda_reg  <= sda_vld;
			scl_reg  <= scl_vld;
		end
	end

	always @(posedge clk or posedge rst) begin
		if (rst) begin
			state 			<= IDLE;
			ack_out	 		<= 1'b0;
			sda_r	 		<= 1'b1;
			rx_data  		<= 0;
			busy	 		<= 1'b0;
			done	 		<= 1'b0;
			tx_shift_reg	<= 0;
			rx_shift_reg	<= 0;
			is_read			<= 1'b0;
			bit_cnt			<= 0;
			step			<= 1'b0;
			add				<= 1'b0;
		end else begin
			done <= 1'b0;
			case (state)
				IDLE:	begin
					add <= 1'b0;
					step <= 1'b0;
					sda_r <= 1'b1;
					bit_cnt <= 0;
					if (start_detect) begin
						state <= START;
					end
				end
				START:	begin
					sda_r <= 1'b1;
					if (!sda_i & !scl) begin
						state <= ADDR;
					end
				end
				ADDR:	begin
					sda_r <= 1'b1;
					if (stop_detect) begin
						state <= STOP;
						sda_r <= 1'b0;
					end else if (posedge_scl) begin
						if (bit_cnt == 7) begin
							rx_shift_reg 	<= {rx_shift_reg[6:0], sda_i};
							bit_cnt 		<= 0;
							state 			<= ACK;
							is_read			<= sda_i;
							add				<= 1'b1;
							done			<= 1'b1;
							rx_data <= {rx_shift_reg[6:0], sda_i};
						end else begin
							rx_shift_reg 	<= {rx_shift_reg[6:0], sda_i};
							bit_cnt 		<= bit_cnt + 1;
						end
					end
				end
				WRITE:	begin
					sda_r <= 1'b1;
					if (stop_detect) begin
						state <= STOP;
					end else if (posedge_scl) begin
						if (bit_cnt == 7) begin
							rx_shift_reg 	<= {rx_shift_reg[6:0], sda_i};
							rx_data 		<= {rx_shift_reg[6:0], sda_i};
							bit_cnt 		<= 0;
							state 			<= ACK;
							done			<= 1'b1;
						end else begin
							rx_shift_reg 	<= {rx_shift_reg[6:0], sda_i};
							bit_cnt 		<= bit_cnt + 1;
						end
					end
				end
				READ:	begin
					if (stop_detect) begin
						state <= STOP;
					end else if (negedge_scl) begin
						if (bit_cnt == 7) begin
							state <= ACK;
							sda_r <= 1'b1;
							done  <= 1'b1;
						end else begin
							sda_r <= tx_shift_reg[7];
							tx_shift_reg <= {tx_shift_reg[6:0], 1'b0};
							bit_cnt <= bit_cnt + 1;
						end
					end else if (!scl_vld && (bit_cnt == 0)) begin
						sda_r <= tx_data[7];
						tx_shift_reg <= {tx_data[6:0], 1'b0};
					end
				end
				ACK:	begin
					bit_cnt <= 0;
					if (add) begin
						if (stop_detect) begin
							state <= STOP;
						end else if (posedge_scl & !step) begin
							if (!is_read) begin
								rx_data <= rx_shift_reg;
								sda_r	<= ack_in;
								step <= 1'b1;
							end else begin
								sda_r	<= 1'b0;
								step <= 1'b1;
							end
						end else if (negedge_scl &step) begin
							if (!is_read) begin
								sda_r	<= ack_in;
								state	<= WRITE;
								step <= 1'b0;
								add <= 1'b0;
							end else begin
								sda_r <= 1'b1;
								state	<= READ;
								step <= 1'b0;
								add <= 1'b0;
							end
						end else if (negedge_scl & !step) begin
								sda_r	<= ack_in;
						end
					end else begin
						if (stop_detect) begin
							state <= STOP;
						end else if (posedge_scl & !step) begin
							if (!is_read) begin
								rx_data <= rx_shift_reg;
								sda_r	<= ack_in;
								step <= 1'b1;
							end else begin
								sda_r	<= 1'b1;
								ack_out <= sda_i;
								step <= 1'b1;
							end
						end else if (negedge_scl &step) begin
							if (!is_read) begin
								sda_r	<= ack_in;
								state	<= WRITE;
								step <= 1'b0;
							end else begin
								if (ack_out == 1'b1) begin
									state <= WAIT;
								end else begin
									sda_r <= 1'b1;
									state	<= READ;
									step <= 1'b0;
								end
							end
						end else if (negedge_scl & !step) begin
								sda_r	<= ack_in;
						end
					end
				end
				WAIT:	begin
					sda_r <= 1'b1;
					if (stop_detect) begin
						state <= STOP;
					end
				end
				STOP:	begin
					sda_r <= 1'b1;
					if (sda_i & scl) begin
						state <= IDLE;
					end
				end
				default:begin
				end
			endcase
		end
	end

endmodule
