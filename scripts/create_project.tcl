
# Lab 3 - BRAM FIFO
# Zybo Z7-10

# Find the Lab3 directory
set script_dir [file dirname [file normalize [info script]]]
set lab_dir [file dirname $script_dir]

# Create Vivado project
create_project fifo_project "$lab_dir/fifo_project" \
    -part xc7z010clg400-1 -force

# Add FIFO design
add_files -fileset sources_1 \
    "$lab_dir/src/sc_fifo.v"

# Add testbench
add_files -fileset sim_1 \
    "$lab_dir/sim/tb_sc_fifo.v"

# Add Python-generated data
add_files -fileset sim_1 \
    "$lab_dir/sim/input_data.txt"

# Select top modules
set_property top sc_fifo [get_filesets sources_1]
set_property top tb_sc_fifo [get_filesets sim_1]

# Set simulation runtime
set_property xsim.simulate.runtime all [get_filesets sim_1]

# Save project
update_compile_order -fileset sources_1
update_compile_order -fileset sim_1

puts "Vivado FIFO project created successfully!"
