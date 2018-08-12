onerror {quit -f}
vlib work
vlog -work work binary4_to_bcd8_vector.vo
vlog -work work binary4_to_bcd8_vector.vt
vsim -novopt -c -t 1ps -L cycloneii_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.binary4_to_bcd8_vector_vlg_vec_tst
vcd file -direction binary4_to_bcd8_vector.msim.vcd
vcd add -internal binary4_to_bcd8_vector_vlg_vec_tst/*
vcd add -internal binary4_to_bcd8_vector_vlg_vec_tst/i1/*
add wave /*
run -all
