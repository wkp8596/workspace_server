module top_spi(
	input  logic			clk			,
	input  logic			rst			,
	input  logic			start		,

	input  logic	[1:0]	sel_ss		,
	input  logic	[7:0]	clk_div		,

	input  logic			cpol		,
	input  logic			cpha		,

	input  logic	[7:0]	m_tx_data	,
	output logic	[7:0]	m_rx_data	,

	input  logic	[7:0]	s_tx_data0	,
	output logic	[7:0]	s_rx_data0	,
	input  logic	[7:0]	s_tx_data1	,
	output logic	[7:0]	s_rx_data1	,
	input  logic	[7:0]	s_tx_data2	,
	output logic	[7:0]	s_rx_data2	,
	input  logic	[7:0]	s_tx_data3	,
	output logic	[7:0]	s_rx_data3	,

	output logic			m_busy		,
	output logic			m_done		,
	output logic			s_busy0		,
	output logic			s_done0		,
	output logic			s_busy1		,
	output logic			s_done1		,
	output logic			s_busy2		,
	output logic			s_done2		,
	output logic			s_busy3		,
	output logic			s_done3		 
    );

	logic [3:0] nss;
	logic sclk;
	wire miso;
	logic mosi;

	spi_master U_MASTER(
		.clk		(clk		),
		.rst		(rst		),

		.sel_ss		(sel_ss		),
                                
		.start		(start		),
		.cpol		(cpol		),
		.cpha		(cpha		),
		.clk_div	(clk_div	),
		.tx_data	(m_tx_data	),
                                
		.busy		(m_busy),
		.rx_data	(m_rx_data	),
		.done		(m_done),
                                
		.sclk		(sclk		),
		.mosi		(mosi		),
		.miso		(miso		),
		.nss		(nss		) 
	);

	spi_slave U_SLAVE0(
		.clk	(clk	),
		.rst	(rst	),
                        
		.cpol	(cpol	),
		.cpha	(cpha	),
                        
		.tx_data(s_tx_data0),
                        
		.busy	(s_busy0),
		.done	(s_done0),
		.rx_data(s_rx_data0),
                        
		.sclk	(sclk	),
		.mosi	(mosi	),
		.miso	(miso	),
		.nss	(nss[0]	) 
	);

	spi_slave U_SLAVE1(
		.clk	(clk	),
		.rst	(rst	),
                        
		.cpol	(cpol	),
		.cpha	(cpha	),
                        
		.tx_data(s_tx_data1),
                        
		.busy	(s_busy1),
		.done	(s_done1),
		.rx_data(s_rx_data1),
                        
		.sclk	(sclk	),
		.mosi	(mosi	),
		.miso	(miso	),
		.nss	(nss[1]	) 
	);

	spi_slave U_SLAVE2(
		.clk	(clk	),
		.rst	(rst	),
                        
		.cpol	(cpol	),
		.cpha	(cpha	),
                        
		.tx_data(s_tx_data2),
                        
		.busy	(s_busy2),
		.done	(s_done2),
		.rx_data(s_rx_data2),
                        
		.sclk	(sclk	),
		.mosi	(mosi	),
		.miso	(miso	),
		.nss	(nss[2]	) 
	);

	spi_slave U_SLAVE3(
		.clk	(clk	),
		.rst	(rst	),
                        
		.cpol	(cpol	),
		.cpha	(cpha	),
                        
		.tx_data(s_tx_data3),
                        
		.busy	(s_busy3),
		.done	(s_done3),
		.rx_data(s_rx_data3),
                        
		.sclk	(sclk	),
		.mosi	(mosi	),
		.miso	(miso	),
		.nss	(nss[3]	) 
	);
endmodule
