#----------------------------------*-tcl-*-

# Define reload command for UVM testbench
proc reload {} {
  do comp.do
  do uvm_sim.do
}
setenv PATH "C:/msys64/mingw64/bin;$env(PATH)"
# Define top entity of the design (use your UVM testbench top)
set top top

# Load design into simulation
echo "UVM Sim: load design"
vsim -wlfdeleteonquit work.top

# Load wave file configuration
echo "UVM Sim: load wave-file(s)"
catch {do wave.do}

# Set all signals to be logged
echo "UVM Sim: log signals"
log -r /*

# Run simulation
echo "UVM Sim: run ..."
run -all

# Restore wave file.
catch {do wave-restore.do}