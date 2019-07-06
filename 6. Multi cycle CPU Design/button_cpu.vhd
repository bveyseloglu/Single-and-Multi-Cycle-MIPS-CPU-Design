----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:54:13 09/03/2009 
-- Design Name: 
-- Module Name:    button_cpu - Behavioral 
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

entity button_cpu is
    port(
		clk, reset, r_button, w_button, cs_button	: in std_logic;
		address										: in std_logic;
		rddata  									: out std_logic_vector(31 downto 0);
		wrdata  									: in  std_logic_vector(31 downto 0);
		buttons										: in std_logic_vector(3 downto 0)
	);
end button_cpu;

architecture Behavioral of button_cpu is

constant DATA 	: std_logic := '0';
constant CHANGE : std_logic := '1';

signal ad_reg 	: std_logic;
signal r_reg    : std_logic;
signal but_reg 	: std_logic_vector(3 downto 0);
signal changes	: std_logic_vector(3 downto 0);

begin

-- address and buttons registers
process(clk, reset)
begin
if (reset = '1') then
  ad_reg	<= '0';
  r_reg   	<= '0';
  but_reg 	<= (others => '1');
elsif (clk'event and clk = '1') then
  ad_reg 	<= address;
  r_reg    	<= r_button and cs_button;
  but_reg   <= buttons;
end if;
end process;

-- read operation
process(r_reg,ad_reg, changes, buttons)
begin
	rddata <= (others => 'Z');
	if(r_reg = '1') then
		rddata <= (others => '0');
		case ad_reg is		
			when DATA =>
				rddata(3 downto 0) <= buttons; 
			when CHANGE =>
				rddata(3 downto 0) <= changes; 
			when others =>
		
		end case;
	end if;
end process;

--changes catched
process(clk, reset)
begin
	if(reset = '1') then
		changes <= (others => '0');		
	elsif(clk'event and clk = '1') then
		--edges are detected
		changes <= changes or (not buttons and but_reg);
		if (cs_button = '1' and w_button = '1') then
			if (address = CHANGE) then
			  changes <= (others => '0');
			end if;
		end if;
	end if;
end process;


end Behavioral;

