set_scan_configuration
create_test_protocol -infer_asynch -infer_clock
dft_drc
insert_dft
write_test_protocol -output simd_stil.stil
write -h -f verilog -o simd_netlist_scan.v
