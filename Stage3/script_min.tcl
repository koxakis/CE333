analyze -library WORK -format verilog { ./simd_top_level.v ./alu.v ./single_port_ram.v ./core_control.v ./mem_ctrl.v }
elaborate simd_top_level -architecture verilog -library WORK
set_design_top simd_top_level
create_clock "clk" -period 80
create_clock "clk_2" -period 20
set_drive 1.08263 [all_inputs]
set_load 0.006006 [all_outputs]
set_false_path -from reset 
uniquify
compile -no_design_rule
report_timing -delay_type min
write_sdf simd_sdf_min.sdf
write_sdc simd_sdc_min.sdc
write -h -f verilog -o simd_netlist_min.v
