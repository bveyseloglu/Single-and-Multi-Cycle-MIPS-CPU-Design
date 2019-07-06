--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   19:08:11 04/01/2019
-- Design Name:   
-- Module Name:   C:/Users/pc/Desktop/ca_lab4/ca_lab4/test_lab4.vhd
-- Project Name:  ca_lab4
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: reg_file
-- 
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
--
-- Notes: 
-- This testbench has been automatically generated using types std_logic and
-- std_logic_vector for the ports of the unit under test.  Xilinx recommends
-- that these types always be used for the top-level I/O of a design in order
-- to guarantee that the testbench will bind correctly to the post-implementation 
-- simulation model.
--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
 
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--USE ieee.numeric_std.ALL;
 
ENTITY test_lab4 IS
END test_lab4;
 
ARCHITECTURE behavior OF test_lab4 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT reg_file
    PORT(
         clk : IN  std_logic;
         aa : IN  std_logic_vector(4 downto 0);
         ab : IN  std_logic_vector(4 downto 0);
         aw : IN  std_logic_vector(4 downto 0);
         wren : IN  std_logic;
         wrdata : IN  std_logic_vector(31 downto 0);
         a : OUT  std_logic_vector(31 downto 0);
         b : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '0';
   signal aa : std_logic_vector(4 downto 0) := (others => '0');
   signal ab : std_logic_vector(4 downto 0) := (others => '0');
   signal aw : std_logic_vector(4 downto 0) := (others => '0');
   signal wren : std_logic := '0';
   signal wrdata : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal a : std_logic_vector(31 downto 0);
   signal b : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: reg_file PORT MAP (
          clk => clk,
          aa => aa,
          ab => ab,
          aw => aw,
          wren => wren,
          wrdata => wrdata,
          a => a,
          b => b
        );

   -- Clock process definitions
   clk_process :process
   begin
		clk <= '0';
		wait for clk_period/2;
		clk <= '1';
		wait for clk_period/2;
   end process;
 

   -- Stimulus process
   stim_proc: process
   begin		
      -- hold reset state for 100 ns.
      --wait for 100 ns;	

		wren <= '1';
		aw <= "00001";
		wrdata <= "10101010101010101010101010101010";
		

      wait for 12 ns;
		wren <= '0';
		aa <= "00001";
		
	  wait for clk_period;
          wren <= '0';
          aa <= "00000";
	
		
		
      -- insert stimulus here 

      wait;
   end process;

END;