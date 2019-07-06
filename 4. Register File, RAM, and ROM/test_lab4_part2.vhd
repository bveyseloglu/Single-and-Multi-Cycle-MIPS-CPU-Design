--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:   20:48:48 04/01/2019
-- Design Name:   
-- Module Name:   C:/Users/pc/Desktop/ca_lab4/ca_lab4_part2_ise/test_lab4_part2.vhd
-- Project Name:  ca_lab4_part2_ise
-- Target Device:  
-- Tool versions:  
-- Description:   
-- 
-- VHDL Test Bench Created by ISE for module: sync_mem
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
 
ENTITY test_lab4_part2 IS
END test_lab4_part2;
 
ARCHITECTURE behavior OF test_lab4_part2 IS 
 
    -- Component Declaration for the Unit Under Test (UUT)
 
    COMPONENT sync_mem
    PORT(
         clk : IN  std_logic;
         r_smem : IN  std_logic;
         w_smem : IN  std_logic;
         reset : IN  std_logic;
         address : IN  std_logic_vector(15 downto 0);
         wrdata : IN  std_logic_vector(31 downto 0);
         rddata : OUT  std_logic_vector(31 downto 0)
        );
    END COMPONENT;
    

   --Inputs
   signal clk : std_logic := '1';
   signal r_smem : std_logic := '0';
   signal w_smem : std_logic := '0';
   signal reset : std_logic := '0';
   signal address : std_logic_vector(15 downto 0) := (others => '0');
   signal wrdata : std_logic_vector(31 downto 0) := (others => '0');

 	--Outputs
   signal rddata : std_logic_vector(31 downto 0);

   -- Clock period definitions
   constant clk_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
   uut: sync_mem PORT MAP (
          clk => clk,
          r_smem => r_smem,
          w_smem => w_smem,
          reset => reset,
          address => address,
          wrdata => wrdata,
          rddata => rddata
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
      
      r_smem <= '0';
      w_smem <= '1';
      address <= "0000011100000000";
      wrdata <= "10101010101010101010101010101010";
      
      wait for 13 ns;
      
      r_smem <= '0';
      w_smem <= '1';
      address <= "0000011100000100";
      wrdata <= "01010101010101010101010101010101";
      
      wait for clk_period*2;
      
      r_smem <= '1';
      w_smem <= '0';
      address <= "0000011100000000";
      
      wait for clk_period;
    
      r_smem <= '1';
      w_smem <= '0';
      address <= "0000011100000100";

      wait for clk_period*10;
      
      -- rom deneme 
      
       r_smem <= '1';
       w_smem <= '0';
       address <= "0000000000000100";

      -- insert stimulus here 

      wait;
   end process;

END;