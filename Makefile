GHDL_CMD=ghdl
GTKWAVE=gtkwave
PROJECT=circuit_8253
SIMOB=circuit_8253_tb
SIMDIR=obj

FILES=\
src/xor_gate.vhd\
src/databus_buffer.vhd\
src/ctrl_reg.vhd\
src/rw_logic.vhd\
src/counter.vhd\
src/circuit_8253.vhd


SIMFILES=\
testbench/databus_buffer_tb.vhd\
testbench/counter_tb.vhd
#testbench/circuit_8253_tb.vhd


compile:
	mkdir -p $(SIMDIR)
	$(GHDL_CMD) -a --workdir=$(SIMDIR) --work=work $(FILES) $(SIMFILES)

test:
	$(GHDL_CMD) -a --workdir=$(SIMDIR) --work=work $(SIMFILES)
	$(GHDL_CMD) -e --workdir=$(SIMDIR) $(SIMOB)

test_databuffer:
	$(GHDL_CMD) -e --workdir=$(SIMDIR) databus_buffer_tb
test_counter:
	$(GHDL_CMD) -e --workdir=$(SIMDIR) counter_tb	
run_databus:
	$(GHDL_CMD) -r databus_buffer_tb --vcd=$(SIMDIR)/databus_buffer_tb.vcd
run_counter:
	$(GHDL_CMD) -r databus_buffer_tb --vcd=$(SIMDIR)/counter_tb.vcd
view_databus:
	$(GTKWAVE) $(SIMDIR)/databus_buffer_tb.vcd
view_counter:
	$(GTKWAVE) $(SIMDIR)/counter_tb.vcd
#	$(GTKWAVE) $(SIMDIR)/$(SIMOB).vcd
clean:
	$(GHDL_CMD) --clean --workdir=$(SIMDIR)
	rm -r $(SIMDIR)
