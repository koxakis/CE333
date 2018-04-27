set_scan_configuration
create_test_protocol -infer_asynch -infer_clock
set_dft_configuration -fix_reset enable -fix_clock enable
dft_drc -coverage_estimate 
preview_dft
insert_dft
write_test_protocol -output simd_stil.stil
write -h -f verilog -o simd_netlist_scan.v
