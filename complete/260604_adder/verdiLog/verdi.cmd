simSetSimulator "-vcssv" -exec "./simv" -args
debImport "-dbdir" "./simv.daidir"
debLoadSimResult /home/pedu14/wkp/260604_adder/wave.fsdb
wvCreateWindow
verdiSetActWin -win $_nWave2
verdiWindowResize -win $_Verdi_1 "1370" "483" "900" "700"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
srcDeselectAll -win $_nTrace1
wvSetCursor -win $_nWave2 3979.930844
verdiSetActWin -win $_nWave2
wvSetCursor -win $_nWave2 3196.237898
srcHBSelect "tb_adder.dut" -win $_nTrace1
verdiSetActWin -dock widgetDock_<Inst._Tree>
srcHBDrag -win $_nTrace1
wvSetPosition -win $_nWave2 {("dut" 0)}
wvRenameGroup -win $_nWave2 {G1} {dut}
wvAddSignal -win $_nWave2 "/tb_adder/dut/a\[7:0\]" "/tb_adder/dut/b\[7:0\]" \
           "/tb_adder/dut/y\[8:0\]"
wvSetPosition -win $_nWave2 {("dut" 0)}
wvSetPosition -win $_nWave2 {("dut" 3)}
wvSetPosition -win $_nWave2 {("dut" 3)}
wvSelectGroup -win $_nWave2 {G2}
verdiSetActWin -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvSelectSignal -win $_nWave2 {( "dut" 1 )} 
wvSelectSignal -win $_nWave2 {( "dut" 1 2 )} 
wvSelectSignal -win $_nWave2 {( "dut" 1 2 3 )} 
wvSelectSignal -win $_nWave2 {( "dut" 1 2 3 )} 
wvSetRadix -win $_nWave2 -format UDec
wvZoom -win $_nWave2 28120.746888 36726.002766
wvZoom -win $_nWave2 30751.122475 31965.141976
wvZoom -win $_nWave2 31023.143442 31128.929373
wvPrevView -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
verdiDockWidgetMaximize -dock windowDock_nWave_2
wvSearchNext -win $_nWave2
wvSetCursor -win $_nWave2 96655.463347 -snap {("G2" 0)}
wvSetCursor -win $_nWave2 80981.604426 -snap {("G2" 0)}
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchNext -win $_nWave2
wvSearchPrev -win $_nWave2
wvSearchNext -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
wvZoomOut -win $_nWave2
