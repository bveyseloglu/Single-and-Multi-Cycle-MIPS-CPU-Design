# Primitive-MIPS-CPU-Design

# Projects
## A 4-bit Sequential Adder
The computer is an electronic machine that does computation work. First examples of computers were builded for doing very simple computation works based on common operations such as adding and substracting. In the heart of computers along the history, simple computation operators were held very important position. In this project, a primitive two’s complement adder were realized.

### The Design
Internal structure of the 4-bit sequential adder is shown below:

<p align="center"> 
  <img src="https://dl.dropboxusercontent.com/s/okda5jvhwf2rks8/block.png">
</p>

The controller contains the following state machine. It includes a counter used to count the 3 steps of the addition algorithm.

<p align="center"> 
  <img src="https://dl.dropboxusercontent.com/s/3zxf3zweabkszzv/fsm.png">
</p>

### The Architecture
The architecture of sequential_adder.vhd consisting by 5 process sections. All process sections are summarized below.
* *SIPO*: This process reads the A input in a serial manner at the rising edge of the clock signal for 4 times then converts the input to a paralel manner.
* REG: When the controller sends a signal, that is LATCHB, the B input loads into the system.
* PISO: Outputs the C register in serial manner. This process is governed by the controller. When the PISOC signal is high, the process saves the summation of the input. When SHIFTC signal is high, the process shifts saved summation value to the right. Also, C output is always the least significant bit of saved summation.
* FSM_COMB: This is the governor process section of the whole circuit. This section of the sequential adder behaves as the algorithm that described in the bottom of the page 3 of the laboratory paper.
* FSM_SEQ: This process advances the states of algorithm to the next state at each time the clock signal gets high. This process is also sensitive to an asynchronous reset signal that returns the system to the beginning of the calculation.

The first versions of the project was designed for our FPGA board to make more easy to enter the input numbers in serial manner by the user. For achieving this kind of design, there is also 2 more .vhd files are present in the Vivado project. The final version of the project doesn’t have these files because in the laboratory session, we used a test bench instead of a real time user input. These files are explained below.
* hhtoh.vhd: This VHDL code takes the master clock signal as an input signal and then gives a clock signal that has a period of 1 Hz. This component is used for getting serial inputs from user more easily.
* top.vhd: This is the top module of the project. It contains hhtoh.vhd and sequential_adder.vhd as a component and then connect them properly.


## License
This project was made for educational purposes only. The content owner
grants the user a non-exclusive, perpetual, personal use license to
view, download, display, and copy the content, subject to the following
restrictions:

The content is licensed for personal use only, not commercial use. The
content may not be used in any way whatsoever in which you charge money,
collect fees, or receive any form of remuneration. The content may not be
resold, relicensed, sub-licensed, rented, leased, or used in advertising.

Title and ownership, and all rights now and in the future, of and for the
content remain exclusively with the content owner.

There are no warranties, express or implied. The content is provided 'as
is.'

Neither the content owner, payment processing service, nor hosting service
will be liable for any third party claims or incidental, consequential, or
other damages arising out of this license or the buyer's use of the content
