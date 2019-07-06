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

### The Architecture
The architecture of ALU.vhd consisting by 5 components that 4 of them does the arithmetic and logic operations and one of them seperates the requested result from them. All operations done concurrently. The components of ALU architecture are summarized below. 
* **Add_Sub.vhd**: This module takes the A and B inputs and the some bits of opcode. In addition to that, the module converts the B input into two’s complement form, and then calculates the substraction result. The carry and zero flags are also changes after the calculation.
* **Comparator.vhd**: This module takes the carry and zero flags, the some bits of the opcode, the most significant bits of A and B inputs and then returns the comparison result. Opcodes that runs this component are also set the add_sub.vhd to calculate the carry and zero flags as in substraction mode.
* **Logic_Unit.vhd**: This module takes the A and B inputs and the some bits of opcode and then simply returns logical result of desired operation. It is the logical part of ALU.
* **Shift_Unit.vhd**: This module takes the A and B inputs and the some bits of opcode and then simply returns the result of desired operation. The input A is the number that desired to apply an operation to it, and B is the number that indicates how many bits that the desired operation will done. It can shift arithmetically and logically and rotate the input. If opcode is incorrect, the module outputs 32 bits of 0.
* **multiplexer.vhd**: This module selects the output of a component in consideration of opcode. The output of this component is also the output of the entire ALU architecture.

## 3. Sequential Multiplier
In this project, an 8-bit sequential multiplier was implemented.

A sequential multiplier needs some extra signals for synchronization purpose.

**Input clk**: clock signal to synchronize the system.\
**Input reset:** asynchronous reset signal to initialize the system.\
**Input start:** synchronous signal that must be high to start a new operation.\
**Output ready:** synchronous signal that is set during 1 cycle by the multiplier when the result of the operation is available.

Shift and add algorithm is as follows; you sequentially multiply the multiplicand (B) by each digit of the multiplier (A) and then summing up the partial products which are properly shifted to get the final result.

There is an architecture view of the multiplier.

<p align="center"> 
  <img src="https://dl.dropboxusercontent.com/s/mtzjiiwjgiy51xg/block_seq_multp.PNG">
</p>

The expressions of the components are listed below.
**8-bit register Multiplicand:**
* Operand B is loaded into internal register inside the multiplicand component when load signal is high.

**8-bit shift register Multiplier:**
* Operand A is loaded into internal register inside the multiplier component when load signal is high.
* Register which keeps the value of A is shifted to the right when shift_right signal is high.
* The dataout output signal of this component is 1-bit signal. It is the least significant bit of the register.

**17-bit shift register Product:**
* Register is initialized to 0 when reset signal is high.
* Register loads the addition result from adder in its most significant bits when load signal is high.
* Register is shifted to the right when shift input is high.
* The dataout output signal bits are its 16 least significant bits.

**AND component:**
* The block diagram consists of 8 AND gates logically.
* It performs the AND logical operation on each multiplicand bits with the least significant bit of the multiplier.

**8-bit Adder:**
* The component sums the result of the AND gates with the 8 most significant bits of the Product output.

**The system Controller:**
* It includes a state machine and it produces control signals of all other components at right time.

### The State Machine
The state machine is shown below.

<p align="center"> 
  <img src="https://dl.dropboxusercontent.com/s/kmby96hv5fxy6wa/fsm_seq_multp.png">
</p>

The asynchronous reset signal is initialized to state machine to s0.

**State s0:** Waits in this state till start signal is high before going into state s1 and initializing the register in which:
* The multiplicand and multiplier registers load the input values.
* The product register and the loop counter are initialized to 0.

**State s1:** The next state is always s2.
* In this state, Adder result is loaded into the product register.
* The loop counter is always incremented by 1.

**State s2:** If the loop counter reaches the end value, continue with state s3, otherwise return to the state s1.
* In both cases, the multiplier and product registers are shifted. Therefore, necessary control signals must be produced in this state.

**State s3:** The next state is always s0.
* In this state, multiplication operation is complete. ready output signal must be set active to indicate operation is done.

### The Architecture
The architecture of top_multiplier.vhd consisting by 7 components that 6 of them does the arithmetic and logic operations and one of them controls the whole circuit. All operations done sequently. The components of binary multiplication architecture are summarized below. 
* **top_multiplier.vhd:** The top module of the binary multiplicatiob circuit. Makes the connection of each sub-part.
* **mcand.vhd:** This module hold the multiplicant value in an internal register if the load signal is high.
* **mlier.vhd:** This module logically shifts right the multiplier. This operation is required for the shifting illustrated in the Illustration 1.
* **producter.vhd:** Does the multiplying operation.
* **adder.vhd:** Adds the inputs of the block.
* **ander.vhd:** Does the logical and operation of second input’s all digits with the first input seperately. Then, concatenates the result to a 8 bit std_logic_vector.
* **controller.vhd:** This is a finite state machine that controls the whole multiplication operation.

## 4. Register File, RAM, and ROM

The processor communicates with the memory system over a memory interface. Figure 1 show the simple memory interface used in our singlecycle and multicycle MIPS processor. The processor sends an address over the address bus to the memory system. For a read, write is 0, read is 1 and the memory returns the data on the rddata bus. For a write, write is 1, read is 0 and the processor sends data to the memory on the wrdata bus.

### Register File
The first component that you will implement in this lab is a Register File. The Register File has 32 registers which all have length of 32-bits. You will use it in the CPU which you will implement on next labs. There is a figure below which shows the Register File entity.

<p align="center"> 
  <img src="https://dl.dropboxusercontent.com/s/0axmuiy2pnu5qxy/block_regfile.PNG">
</p>

The Register File has two read ports and one write port. The read ports take 5-bit address inputs, aa and ab, each specifying one of 2^5=32 registers as source operands. They read the 32-bit register values onto read data outputs a and b, respectively. The write port takes a 5-bit address input aw, and a 32-bit write data input wrdata, a write enable input wren and a clock clk.

The final design of the register file that was made in this laboratory session has 32 registers that can store 32 bits of information. The signal type of the registers are standart logic vectors. The initial values of the registers are all the same, that is, 0x00000000. The register file can not write any value different than 0 to $zero register. Also, if an external factor causes an unwanted change to the register, the reading part of the hardware is also returns always zero to avoid any fault.

#### Read from the Register File
The read process is asynchronous. The 5-bit inputs aa and ab selects the registers to be read. The read values are put respectively on the 32-bit outputs a and b. In CPU, the synchronous operations are needed. Therefore, a clock must be added to the unit. The address is set by the controller at the beginning of cycle, and the result is available before the end of this cycle.

#### Write to the Register File
The write process is synchronous. The wren input signal activates the writing of the value defined by the 32-bit wrdata input to the register at the address specified by the 5-bit aw input. If the write enable is 1, the register file writes the data into the specified register on the rising edge of the clock.
Writing a value to the register at address 0 has no effect, the value of this register is always 0. The address, the data and the wren input signals are set during a cycle. At the rising edge of the clock signal, the data is written to the register in the Register File.

### Decoder
The decoder activates one of the modules on the memory system at a time. It selects the module according to the address value.

For example, with the address 0x10F0, the selected module would be the RAM. The decoder will activate the cs_ram output signal. Recall that at most one chip select (cs) signal can be activated at the same time.

In the design, the decoder checks the adress for activating the correct RAM or ROM component. If the adress is less than 1024 the RAM is activated, if the adress is equal or greater than 1024 and less than 2048 then, the ROM is activated. Also, decoder hardware disables both RAM and ROM if the adress is greater than 2048.

### RAM and ROM
The synchronous RAM and ROM have a size of 4KB. These memories should be word aligned, the 2 least significant bits of the address are ignored. Note that: There is a tri-state buffer on their rddata output. The FPGA has several synchronous memory blocks (SRAM) that we 
will use for the RAM and ROM.

Both RAM and ROM hardwares that were designed in the laboratory session can hold 1024 different 32-bit standart logic vectors. The initial values of these memory values are U. The main process of the harwares are sensitive to clock, read, and write signal (if available).

## 5. Single Cycle CPU Design
In this project, a single-cycle MIPS CPU was implemented. 
**IMPORTANT NOTICE:** This project may not work properly.

### Single-cycle CPU Description
The single-cycle microarchitecture executes an entire instruction in one cycle. So, the cycle time is limited by the slowest instruction.
We will divide our microarchitecture into two interacting parts: the datapath and the control. The datapath operates on words of data. It contains structures such as memories, registers, ALUs, and multiplexers. The state elements of the datapath are introduced in Figure 1. MIPS is a 32-bit architecture, so we will use a 32-bit datapath. The control unit receives the current instruction from the datapath and tells the datapath how to execute that instruction. Specifically, the control unit produces multiplexer select, register enable, and memory write signals to control the operation of the datapath.

We will start designing the CPU by connecting the state elements from Figure 1 with combinational logic that can execute the various instructions. Control signals determine which specific instruction is carried out by the datapath at any given time. The controller contains combinational logic that generates the required control signals based on the current instruction.

#### Program Counter
The program counter is an ordinary 32-bit register. Its output, PC, indicates to the current instruction. Its input, PC’, indicates the address of the next instruction. The reset input signal provides us to reset the PC register asynchronously. If reset input is 1 then PC is equal to 0. Otherwise, on the rising edge of the clock, input is loaded to the output.

#### Instruction Memory
The instruction memory has a single read port.1 It takes a 6-bit instruction address input, a, and reads the 32-bit data, instruction, from that address onto the read data output, rd. It consists of array of std_logic_vector. If there is a change on the address, the data on this address is loaded to the rd output. You can define an array as following.
type ROM_Array is array (0 to 63) of std_logic_vector(31 downto 0);

#### Register File
The 32-element x 32-bit register file has two read ports and one write port. The read ports take 5-bit address inputs, ra1 and ra2, each specifying one of 2^5= 32 registers as source operands. They read the 32-bit register values onto read data outputs rd1 and rd2, respectively. The write port takes a 5-bit address input, wa3, a 32-bit write data input, wd3, a write enable input, we3 and lastly a clock. If the write enable is 1, the register file writes the data into the specified register on the rising edge of the clock. The register file is read combinationally. If there is a change on the address, the new data is written on the output rd buses. The read process does not wait the rising edge of the clock.

#### Data Memory
The data memory has a single read/write port. If the write enable, we, is 1, it writes data wd into address a on the rising edge of the clock. If the write enable is 0, it reads address a onto rd. Read operation is performed combinationally. You can easily define a memory array as following for the data memory.

type ram_type is array (0 to 255) of std_logic_vector(31 downto 0);

#### Read and Write Process
The instruction memory, register file, and data memory are all read as combinational. In other words, if the address changes, the new data appears at rd after some propagation delay. No clock is involved. They are written only on the rising edge of the clock. The state of the system is changed only at the clock edge. The address, data, and write enable must setup sometime before the clock edge and must remain stable until a hold time after the clock edge.

### Single-Cycle Datapath

The figure given below shows the datapath of the MIPS processor. After you finish writing the components inside the datapath,
you will connect them according to the figure. The datapath given here provides just a few instructions.

<p align="center"> 
  <img src="https://dl.dropboxusercontent.com/s/nvsf6hz2ko6u1sw/single_cycle_datapath.PNG">
</p>

#### Multiplexers
The datapath consists of 2x1 components. The multiplexers are combinational circuits that select binary information from one of the inputs according to the select input and direct it to a single output line. The selection of a particular input line is controlled by a set of selection lines. Normally, there are 2𝑛𝑛 input lines and n selection lines whose bit combinations determine which input is selected.

#### ADDER
Adder performs addition operation on its operands combinationally. The figure given below shows the entity of the ADDER component.

#### Shift Left 2 Unit (SL2 Component)
The unit performs 2-bit shift left operation on its operand. The operation result is written on the output combinationally. The result means actually that input operand is multiplied by 4.

#### Sign Extender Unit (SIGNEXT Component)
Sign Extender Unit extends the 16-bit signal to the 32-bit signal. It assigns the 16 most significant bits of the output signal to the 0 or 1 depends on the sign bit of the input. If the sign bit, most significant bit, of the input is 1, then It puts 1 to the 16 most significant bits of the output signal. If the sign bit, most significant bit, of the input is 0, then It puts 0 to the 16 most significant bits of the output signal.

#### ALU
The ALU component performs some arithmetic operations on its input operands depends on the Table 1. It shows which operation is done according to the F(2:0). You are familiar to write the vhdl description of an ALU from previous labs. Zero input is necessary for branch instructions. It indicates whether result of the ALU is zero or not.

<p align="center"> 
  <img src="https://dl.dropboxusercontent.com/s/dlqq118ze1r8h93/single_cycle_alu_funcs.PNG">
</p>

### Single-Cycle Control

<p align="center"> 
  <img src="https://www.dropbox.com/s/o2ueuz1j4tky0u2/single_cycle_block_cu.PNG"> 
</p>

The control unit computes the control signals depends on the opcode and funct fields of the instruction, Instr (31:26) and Instr (5:0) You can see necessary control signals attached to the datapath on the Figure.

Most of the control information comes from the opcode, however for R-type instructions also the funct field is used to determine the ALU operation. Therefore, we will simplify our design by dividing our control unit design into two blocks of combinational logic. The main decoder generates most of the output signals from the opcode. It also determines a 2-bit ALUOp signal. The ALU decoder uses this ALUOp signal together with the funct field to generate ALUControl. The meaning of the ALUOp signal is given in Table below. Table 2 is a truth table for the ALU decoder.

<p align="center"> 
  <img src="https://www.dropbox.com/s/izk3vyu030m7shf/single_cycle_alu_encoding.PNG">
</p>

<p align="center"> 
  <img src="https://www.dropbox.com/s/cwwwfcazthg44o3/single_cycle_alu_dec_tt.PNG">
</p>

The meanings of the three ALUControl signals are given in Table. Because ALUOp is never 11, the truth table can use don’t care’s X1 and 1X instead of 01 and 10 to simplify the logic. When ALUOp is 00 or 01, the ALU should add or subtract, respectively. When ALUOp is 10, the decoder examines the funct field to determine the ALUControl. Note that, for the R-type instructions we implement, the first two bits of the funct field are always 10, so we may ignore them to simplify the decoder.

Table below is a truth table for the main decoder that summarizes the control signals as a function of the opcode. All R-type instructions use the same main decoder values; they differ only in the ALU decoder output. For instructions that do not write to the register file such as sw and beq nstructions, the RegDst and MemtoReg control signals are don’t cares (X). The address and data to the register write port do not matter because RegWrite is not asserted. The logic for the decoder can be designed using your favorite techniques for combinational logic design.

<p align="center"> 
  <img src="https://www.dropbox.com/s/x2i0sg2qyh9mp28/single_cycle_alu_main_dec_tt.PNG">
</p>

### MIPS Processor
The datapath and controller units of the MIPS processor are connected as shown in the Figure below.

<p align="center"> 
  <img src="https://www.dropbox.com/s/4fkub8yib2yy2rg/mips_proc.PNG">
</p>

# License
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
