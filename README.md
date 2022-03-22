#  Serial Communication

UART is a universal serial communication protocol that transmits data serially between systems. It is an interface that sends out usually a byte at a time.
This interface is a simple way to connect an FPGA to a PC. We just need a transmitter and receiver module. The transmitter is essentially a special
shift register that loads data in parallel and then shifts it out bit by bit at a specific rate. The receiver, on the other hand, shifts in data bit by bit and then reassembles the data. 

   

## Building on macOS
1. Icarus-Verilog can be installed via Homebrew :
   <code>$ brew install icarus-verilog</code>
2. Download [Scansion](http://www.logicpoet.com/scansion/) from here.  
3. Clone the repository.
4. Run <code>$ make </code> and type MIPS code to see it in binary form in rams_init_file.hex file. 

5. <code>$ make simulate</code> will: 
* compile design+TB
* simulate the verilog design

6. <code>$ make display</code> will: 
*  display waveforms.


## Links
1. [Design and Verification of UART using System Verilog](https://www.ijeat.org/wp-content/uploads/papers/v9i5/E1135069520.pdf)
2. [FPGA Prototyping by Verilog Examples (UART)](https://academic.csuohio.edu/chu_p/rtl/fpga_vlog_book/fpga_vlog_sample_chapter.pdf)

