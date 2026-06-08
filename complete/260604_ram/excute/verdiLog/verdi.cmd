simSetSimulator "-vcssv" -exec "./simv" -args
debImport "-dbdir" "./simv.daidir/"
debLoadSimResult /home/pedu14/wkp/260604_ram/wave.fsdb
wvCreateWindow
verdiSetActWin -win $_nWave2
verdiWindowResize -win $_Verdi_1 "245" "269" "1227" "902"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
srcHBSelect "tb_ram.dut" -win $_nTrace1
verdiSetActWin -dock widgetDock_<Inst._Tree>
srcHBDrag -win $_nTrace1
wvSetPosition -win $_nWave2 {("dut" 0)}
wvRenameGroup -win $_nWave2 {G1} {dut}
wvAddSignal -win $_nWave2 "/tb_ram/dut/clk" "/tb_ram/dut/we" \
           "/tb_ram/dut/addr\[7:0\]" "/tb_ram/dut/wdata\[7:0\]" \
           "/tb_ram/dut/rdata\[7:0\]"
wvSetPosition -win $_nWave2 {("dut" 0)}
wvSetPosition -win $_nWave2 {("dut" 5)}
wvSetPosition -win $_nWave2 {("dut" 5)}
wvSetCursor -win $_nWave2 157479.717949 -snap {("G2" 0)}
verdiSetActWin -win $_nWave2
wvSetCursor -win $_nWave2 9961300.364615 -snap {("dut" 5)}
wvZoomIn -win $_nWave2
debExit
