#TOOL INPUT
SRC = hdl/receiver.v hdl/transmitter.v
TESTBENCH = test/serial_communication_test.v
TBOUTPUT = serial_communication_test.vcd


#TOOLS
COMPILER = iverilog
SIMULATOR = vvp
VIEWER = Scansion

#TOOL OPTIONS
COFLAGS = -v -o
SFLAGS = -v

#TOOL OUTPUT
COUTPUT = compiler.out         

############################################################################### 
simulate: $(COUTPUT)
	$(SIMULATOR) $(SFLAGS) $(COUTPUT) 

display: 
	open -a $(VIEWER) $(TBOUTPUT) 

$(COUTPUT): $(TESTBENCH) $(SRC)
	$(COMPILER) $(COFLAGS) $(COUTPUT) $(TESTBENCH) $(SRC) 

clean:
	rm *.vcd
	rm *.out