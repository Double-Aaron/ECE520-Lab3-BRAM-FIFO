ECE 520/L -Lab 3: BRAM FIFO

1. Introduction
The objective of the BRAM lab is to create and utilize a single clock FIFO memory using Verilog. The FIFO uses block
RAM for internal data storage and can read and write data. 

2.Design Specifications
The FIFO was implemented using these parameters

WIDTH = 16 Bits
DEPTH = 32 WORD
ALMOST_EMPTY_THRESHOLD 1
ALMOST_FULL_ THRESHOLD 31
READ_LATENCY 1

The FIFO will be able to synchronously reset when active high.

3.Implementation
The design uses a 32 bit memory array that holds 16 bits of word data. The write pointer will identify the next
memory storage location and the read pointer will identify the data location. The FIFO word counter will track
the number of stored words and will determine the status flag. Read and write are controlled by seprate signals.
Writes will be ignored when FIFO is full and read will be ignored when FIFO empty.

4. Testbench
A testbench was created that utilizes a 50Mhz clock with a 20ns period. I tested 4 major functions of the design

1. Reset test that verifys that the FIFO is empty when rst is enabled
2. Data Pattern test that wrote a data pattern into the FIFO
3. Full and empty test that verifys the use of all memory locations 
4. Enable test which checked the FIFO behavior whe read and write where off

5.Python Data generation
A python script was created that generated 32 random 16 bit hexadecimal values that would be stored in the BRAM
The fixed seed of 520 was used to verify functionality on input data.

6.TCL Automation
A TCl script was created to automated the vivado project creation. The script configures the ZYBO Z7-10 FPGA,
adds the verilog design and simulation sources.

8. Synthesis report

Resources

Slice LUTS = 25
SLice Registers = 17
LUTS as Memory = 0.5
BLOCK RAM Tile = 1
 
