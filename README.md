# Primitive-MIPS-CPU-Design

# Projects
## 1. A 4-bit Sequential Adder
The computer is an electronic machine that does computation work. First examples of computers were builded for doing very simple computation works based on common operations such as adding and substracting. In the heart of computers along the history, simple computation operators were held very important position. In this project, a primitive two’s complement adder were realized.

### The Design
Internal structure of the 4-bit sequential adder is shown below:

<p align="center"> 
  <img src="https://dl.dropboxusercontent.com/s/ssjhm5tkmq8j9yr/block_seq.png">
</p>

The controller contains the following state machine. It includes a counter used to count the 3 steps of the addition algorithm.

<p align="center"> 
  <img src="https://dl.dropboxusercontent.com/s/3zxf3zweabkszzv/fsm.png">
</p>

### The Architecture
The architecture of sequential_adder.vhd consisting by 5 process sections. All process sections are summarized below.
* **SIPO**: This process reads the A input in a serial manner at the rising edge of the clock signal for 4 times then converts the input to a paralel manner.
* **REG**: When the controller sends a signal, that is LATCHB, the B input loads into the system.
* **PISO**: Outputs the C register in serial manner. This process is governed by the controller. When the PISOC signal is high, the process saves the summation of the input. When SHIFTC signal is high, the process shifts saved summation value to the right. Also, C output is always the least significant bit of saved summation.
* **FSM_COMB**: This is the governor process section of the whole circuit. This section of the sequential adder behaves as the algorithm that described in the bottom of the page 3 of the laboratory paper.
* **FSM_SEQ**: This process advances the states of algorithm to the next state at each time the clock signal gets high. This process is also sensitive to an asynchronous reset signal that returns the system to the beginning of the calculation.

The first versions of the project was designed for our FPGA board to make more easy to enter the input numbers in serial manner by the user. For achieving this kind of design, there is also 2 more .vhd files are present in the Vivado project. The final version of the project doesn’t have these files because in the laboratory session, we used a test bench instead of a real time user input. These files are explained below.
* **hhtoh.vhd**: This VHDL code takes the master clock signal as an input signal and then gives a clock signal that has a period of 1 Hz. This component is used for getting serial inputs from user more easily.
* **top.vhd**: This is the top module of the project. It contains hhtoh.vhd and sequential_adder.vhd as a component and then connect them properly.

### Known Bugs
"hhtoh.vhd" may written incorrectly.

## 2. 32-Bit MIPS ALU Design
In this project, a 32-bit MIPS ALU was implemented. ALU is an example of a combinational circuit inside the microprocessor and is one of the main component inside a microprocessor that is responsible for performing arithmetic and logic operations such as addition, subtraction, logical AND, and logical OR.

Arithmetic circuits are the central building blocks of computers. Computers and digital logic perform many arithmetic functions. This section describes hardware implementations for all of these operations.

A simple ALU has two inputs for the operands, one input for a control signal that selects the function to perform, and one output for the function result.

The 6-bit Opcode is a control signal which can select one of the above functions. As you may notice that, the 2 most significant bits can select the operation type (e.g. Add / Sub, Comparison, Logical, Shift / Rotate). Opcode(3) bit is used to activate the subtraction mode of the Add/Sub unit. Notice that the subtraction mode is always activated for the comparisons and ignored for logical and shift / rotate unit. The remaining bits can select a specific operation of the units. The following figure shows the connections between internal components inside the ALU.

<p align="center"> 
  <img src="https://dl.dropboxusercontent.com/s/vsapwk6vrym9ffu/alu-funcs.PNG">
</p>

The block design is shown in following figure.

<p align="center"> 
  <img src="https://dl.dropboxusercontent.com/s/bdi2zw202harx8u/block_alu.PNG">
</p>

### Specifications
#### Add-Sub Unit
The Add/Sub unit performs 32-bit additions and subtractions. The sub input signal activates the subtraction mode. The carry output signal gives the carry out from the adder inside the unit. The zero output signal indicates whether the result is equal to 0.

When the subtraction mode is activated, we have to replace the B operand by its two's complement. According to the sub signal value, the two's complement of B input can be taken as followed. When the sub signal is high, B input is inverted; otherwise it keeps its original value. In case of a subtraction mode, Increment by 1 due to 2's complement can be done by connecting the sub signal directly to the carry in of the adder, then we will have A + not B +1 which is equivalent to A − B.

#### Comparison Unit
The Comparison unit performs equal, not equal, signed or unsigned greater or equal and less than comparisons. It uses the subtraction result to compare the 2 operands. Therefore the Add/Sub unit has to be in subtraction mode to calculate the difference between these operands.

The 3-bit input op can select the type of comparison. The 1-bit output R gives the result of the comparison as 0=false, 1=true. In order to be compatible with 32-bit multiplexer inside the ALU, The result of the comparison unit should be extended to 32-bit. The 31 most significant bit is set to 0. The zero, carry, A31, B31, and diff31 input signals are used to do the comparison.

##### Equal and not equal
The equal and not equal comparisons result is directly driven by the zero input signal. If A equals B, then subtraction result will be zero.

##### Unsigned greater or equal and less than
The greater or equal and less than unsigned comparisons depend only on the carry signal. If the carry is high, then A is greater or equal to B; otherwise A is less than B. The result of these comparisons is driven by carry input signal.

##### Signed greater or equal and less than
For these two signed comparisons, we need a little more logic to calculate the result. We have A31, B31, and diff31 the most significant bits of the ALU inputs A and B, and of the subtraction result.

If A is positive and B is negative, quickly we can say that A ≥ B. If subtraction result is positive and A and B signs are the same, we have also that A ≥ B. In any other case, A is less than B.

#### Logical Unit
The Logical Unit performs and, or, nor and xor logical bitwise operations

#### Shift / Rotate Unit
The Shift / Rotate unit performs 5 different shift operations on the operand A by B bits. The input B defines by how many position we should shift A. Only the 5 least significant bits of B are used in this shift unit.

When shift operations are performed, operand A is shifted to the left or right by a number of position defined by B. The bits shifted out are dismissed. For logical shifts (e.g. sll, srl) zeros are shifted in. In right arithmetic shifts (sra) the sign bit is replicated to keep the sign of the operand. For the rotation operations (rol and ror) the bits shifted out are reinjected at the other end of the operand. As you may notice that, A rotated left by B is equivalent to A rotated right by (-B).

## The Architecture
The architecture of ALU.vhd consisting by 5 components that 4 of them does the arithmetic and logic operations and one of them seperates the requested result from them. All operations done concurrently. The components of ALU architecture are summarized below. 
* **Add_Sub.vhd**: This module takes the A and B inputs and the some bits of opcode. In addition to that, the module converts the B input into two’s complement form, and then calculates the substraction result. The carry and zero flags are also changes after the calculation.
* **Comparator.vhd**: This module takes the carry and zero flags, the some bits of the opcode, the most significant bits of A and B inputs and then returns the comparison result. Opcodes that runs this component are also set the add_sub.vhd to calculate the carry and zero flags as in substraction mode.
* **Logic_Unit.vhd**: This module takes the A and B inputs and the some bits of opcode and then simply returns logical result of desired operation. It is the logical part of ALU.
* **Shift_Unit.vhd**: This module takes the A and B inputs and the some bits of opcode and then simply returns the result of desired operation. The input A is the number that desired to apply an operation to it, and B is the number that indicates how many bits that the desired operation will done. It can shift arithmetically and logically and rotate the input. If opcode is incorrect, the module outputs 32 bits of 0.
* **multiplexer.vhd**: This module selects the output of a component in consideration of opcode. The output of this component is also the output of the entire ALU architecture.


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
