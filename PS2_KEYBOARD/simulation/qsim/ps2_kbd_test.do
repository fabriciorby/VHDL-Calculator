onerror {quit -f}
vlib work
vlog -work work ps2_kbd_test.vo
vlog -work work ps2_kbd_test.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.testaSomador_vlg_vec_tst
vcd file -direction ps2_kbd_test.msim.vcd
vcd add -internal testaSomador_vlg_vec_tst/*
vcd add -internal testaSomador_vlg_vec_tst/i1/*
add wave /*
run -all
