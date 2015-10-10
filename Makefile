GHDL_CMD=ghdl
GTKWAVE=gtkwave
PROJECT=circuit_8253
SIMOB=circuit_8253_tb
SIMDIR=obj

FILES=\
src/xor_gate.vhd\
src/circuit_8253.vhd


SIMFILES=\
testbench/circuit_8253_tb.vhd


compile:
	mkdir -p $(SIMDIR)
	$(GHDL_CMD) -a --workdir=$(SIMDIR) --work=work $(FILES)

test:
	$(GHDL_CMD) -a --workdir=$(SIMDIR) --work=work $(SIMFILES)
	$(GHDL_CMD) -e --workdir=$(SIMDIR) $(SIMOB)

run:
	$(GHDL_CMD) -r $(SIMOB) --vcd=$(SIMDIR)/$(SIMOB).vcd
view:
	$(GTKWAVE) $(SIMDIR)/$(SIMOB).vcd
clean:
	$(GHDL_CMD) --clean --workdir=$(SIMDIR)
	rm -r $(SIMDIR)
