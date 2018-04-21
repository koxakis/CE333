analyze -library WORK -format verilog { ./simd_top_level.v ./alu.v ./single_port_ram.v ./core_control.v ./mem_ctrl.v }
elaborate simd_top_level -architecture verilog -library WORK
set_design_top simd_top_level
create_clock "clk" -period 80
create_clock "clk_2" -period 20
set_drive 3.1117 [all_inputs]
set_load 0.006109 [all_outputs]
set_false_path -from reset 
uniquify
compile -map_effort high -scan -incremental_mapping
write_sdf simd_sdf.sdf
write_sdc simd_sdc.sdc
write -h -f verilog -o simd_netlist.v
