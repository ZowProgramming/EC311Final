=====================================================================================
									README FILE
=====================================================================================

PROJECT NAME: Team 9 T9-837X Microcontroller
-------------------------------------------------------------------------------------

TEAM MEMBERS: 
-------------------------------------------------------------------------------------
Charlie Van Hook
Soud Alkharji
Gidon Gautel
Yoan Zhao

PROJECT DEMO VIDEO LINK: https://www.youtube.com/watch?v=9FqrKM6fkw4 
-------------------------------------------------------------------------------------

PROJECT OVERVIEW:
-------------------------------------------------------------------------------------
Purpose:	In this project we sought to create a microcontroller 
			design that could be implemented on an FPGA that could
			be programmed and interface with periferals.

Specifications:	The microcontroller is built around a Harvard Architecture 
				single-cycle MIPS processor using 32 bit words and using SRAM memory. 

Functionality: The microcontroller can be programmed to support most "standard"
			   microcontroller functionalities, including digital input-output, 
			   analogue to digital conversion, and pulse width modulation.
				
Supported Assembly Instructions:
			
			R-type: Add, Subtract, And, Or, Multiply, Divide, SLT (Set Less Than)
			I-Type: ADDI (Add Immediate), SLTI (Set Less Than Immediate)
			J-type: JR (Jump Register), LW (Load Word), SW (Save Word), BEQ 
					(Branch if Equal-to), BNE (Branch if Not Equal-to), J 
					(Jump to position), JAL (Jump and Link), LHI (Load High)
					LLO (Load Low)

				
HOW TO RUN:
-------------------------------------------------------------------------------------
Push the bitstream provided in the main directory to an FPGA. Our bitstream comes with the Fibonacci program loaded on to the microcontroller. This is set up to advance one program counter with each button click. Therefore this requires two clicks per instruction, so the displayed number will increment every 11 button clicks, with 13 clicks required for the first transition because there is a buffer instruction line at the beginning of the program. 

CODE STRUCTURE:
-------------------------------------------------------------------------------------
	
/design_files/

	ALU.v: Arithmetic logic unit for the processor
	
	ALU_controller.v: Passes control signals to the ALU
					  to determine its operation (ADD, SUB, etc.)
	
	Interupt_controller.v: Handles interrupt signals from peripherals, pausing 
						   processor activity to execute interrupt tasks.
	
	controller.v: CPU control unit - generates signals to other CPU components 
				  to coordinate jump, branch, mem read/write and other instructions
	
	data_mem.v: Implements data memory - enables memory access for read/write 
				requests and returns relevant data memory
	
	debounce.v: Debouncing module for buttons and switches
	
	instr.txt
	
	instruction_mem.v: Implements instruction memory - outputs instructions based on
					   address requests from processor
	
	leds.v: Handles physical LED states of the FPGA board
	
	mips_processor.v: Top level design for MIPS processor. Orchestrates the 
					  subcomponents (e.g. ALU, instr memory, data memory etc.) in
					  order to execute MIPS instructions
	
	peripheral_bus.v: Interfaces between the processor and peripherals, allowing
					  send and receive to/from peripherals
	
	program_mem.v: Program memory register
	
	programmer.v: Enables programming of the microcontroller - takes in instructions 
				  via UART and translates these into instructions that are usable by 
				  the system
	
	regfile.v: 32 register file for the processor
	
/mips_encoder/
	encoding_sheet.ods: Overview file of our MIPS instruction encoding
	
	mips_encoder.py: Python script to encode MIPS instructions in binary
	
	input.txt: Example input for python script
	
	output.txt: Example output for python script
