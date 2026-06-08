simSetSimulator "-vcssv" -exec "./simv" -args
debImport "-dbdir" "./simv.daidir/"
debLoadSimResult /home/pedu14/wkp/260605_adder_uvm_test/wave.fsdb
wvCreateWindow
verdiSetActWin -win $_nWave2
verdiWindowResize -win $_Verdi_1 "830" "370" "900" "700"
verdiSetActWin -dock widgetDock_MTB_SOURCE_TAB_1
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
verdiWindowResize -win $_Verdi_1 "995" "195" "900" "700"
debExit
