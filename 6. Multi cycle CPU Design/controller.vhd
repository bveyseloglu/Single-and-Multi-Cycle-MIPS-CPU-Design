----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    15:03:30 09/11/2009 
-- Design Name: 
-- Module Name:    controller - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller is --state machine of the CPU
	port(
		clk        : in  std_logic;
		reset_n    : in  std_logic;
		-- instruction opcode
		op         : in  std_logic_vector(5 downto 0);
		opx        : in  std_logic_vector(5 downto 0);
		-- activates branch condition
		branch_op  : out std_logic;
		-- immediate value sign extention
		imm_signed : out std_logic;
		-- instruction register enable
		ir_en      : out std_logic;
		-- PC control signals
		pc_add_imm : out std_logic;
		pc_en      : out std_logic;
		pc_sel_a   : out std_logic;
		pc_sel_imm : out std_logic;
		-- register file enable
		rf_wren    : out std_logic;
		-- multiplexers selections
		sel_addr   : out std_logic;
		sel_b      : out std_logic;
		sel_mem    : out std_logic;
		sel_pc     : out std_logic;
		sel_ra     : out std_logic;
		sel_rC     : out std_logic;
		-- write memory output
		rstart      : out std_logic;
		wstart      : out std_logic;
		-- alu op
		op_alu     : out std_logic_vector(5 downto 0)
	);	
end controller;

architecture Behavioral of controller is	

	type state_type is(fetch1, fetch2, decode, r_op, store, break, load1, load2, i_op);
	signal next_state, state : state_type;

begin


	with state select -- next_state may be used here. Control wheter is true.
		  sel_b <= '0' when i_op | load1 | store,  -- may be put here load 2 ? control it.
				  '1' when others;
						 
	with state select -- next_state may be used here. Control wheter is true.
		  sel_rC <= '0' when i_op, '0' when load2, '0' when store, -- I-type may be put here load 2 ? control it.
						 '1' when others;

	with state select -- next_state may be used here. Control wheter is true.
		  wstart <= '1' when store, 
						 '0' when others;
						 
	--combinational part of the state machine
	fsm_comb: process (state, op, opx)
	begin
		next_state <= state;
		rstart <= '0';
		ir_en <= '0';
		pc_en <= '0';
		rf_wren  <= '0';
		imm_signed <= '0';
		sel_addr <= '0';
		sel_mem <= '0'; 
		sel_pc <= '0';
		sel_ra <= '0';


			case state is
				when fetch1 =>
					rstart <= '1';
					
					next_state <= fetch2;
				when fetch2 =>
					pc_en <= '1'; -- ?????????????????????????????????????????????????????????????
					
					next_state <= decode;
				when decode =>
					if (op = x"3a" and opx = x"0e") then
						next_state <= r_op;
					elsif (op = x"3a" and opx = x"1b") then
						next_state <= r_op;
					elsif (op = x"04") then
						next_state <= i_op;
					elsif (op = x"17") then
						next_state <= load1;
					elsif (op = x"15") then
						next_state <= store;
					elsif (op = x"3a" and opx = x"34") then
						next_state <= break;
					end if;
				when r_op =>
					rf_wren  <= '1';
					
					if (op = x"3a" and opx = x"0e") then -- and 
						op_alu <= "100001"
					elsif (op = x"3a" and opx = x"1b") then -- srl
						op_alu <= "110011"
					end if;
					
					next_state <= fetch1;
				when store =>
					imm_signed <= '1';
					
					op_alu <= "000000"
					
					next_state <= fetch1;
				when break => --break instruction used to stop CPU execution DEAD END
					
					next_state <= break;
				when load1 =>
					sel_addr <= '1';
					rstart <= '1';
					imm_signed <= '1';
				
					op_alu <= "000000"
				
					next_state <= load2;
				when load2 =>
					rf_wren  <= '1';
					sel_mem <= '1'; 
				
					next_state <= fetch1;
				when i_op =>
					rf_wren <= '1';
					imm_signed <= '1';
					
					if (op = x"04") then -- if addi
						op_alu <= "000000"
					end if;
					
					next_state <= fetch1;
				when others =>
				
			end case;

	end process;

	--sequential part of the state machine
	fsm_seq: process (clk, reset_n)
	begin
		if (reset_n = '1') then
			state <= fetch1; 
		elsif (clk'event and clk = '1') then
			state <= next_state;
		end if;
	end process;



end Behavioral;

