----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:54:13 09/03/2009 
-- Design Name: 
-- Module Name:    ram - Behavioral 
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

entity ram is
    port(
		clk_ram    	: in  std_logic;
		cs_ram      : in  std_logic;
		read_ram    : in  std_logic;
		write_ram   : in  std_logic;
		ad_ram		: in  std_logic_vector(9 downto 0);
		wrdata  	: in  std_logic_vector(31 downto 0);
		rddata  	: out std_logic_vector(31 downto 0));
end ram;

architecture Behavioral of ram is

type ram_type is array (0 to 1023) of std_logic_vector (31 downto 0); -- 4kB RAM memory space is created.
signal mem_ram : ram_type := (	x"00556a84", --addi 		00
								x"00404015", --stw  		04
								x"00804017", --ldw  		08
								x"10c00044", --addi 		0c
								x"00c80015", --stw  		10
								x"0001a03a", --break		14									
								others => x"00000000"); -- (others => x"00000007"); -- initialize to 0 value is done. (others => '1')

 

signal read_en, write_en		: std_logic;
signal address_reg 	: std_logic_vector(9 downto 0);

begin
--
--mem_ram(0) <= x"00000004";
--mem_ram(1) <= x"00000003";
-- 
process(clk_ram)
begin
	if(clk_ram'event and clk_ram='1') then
			read_en <= cs_ram and read_ram; -- and gate is connected to the input of the FF.	
			
			address_reg <= ad_ram;
	end if;
end process;
write_en <= cs_ram and write_ram; -- and gate is connected to the input of the FF.			
-- read ram memory
process(mem_ram, read_en, address_reg)
begin
	rddata <= (others => 'Z');
	
	if(read_en = '1') then
		rddata <= mem_ram(conv_integer(address_reg));
	end if;
end process;

-- write ram memory
process(clk_ram)
begin
	if(clk_ram'event and clk_ram = '1') then
		if(write_en = '1') then
			mem_ram(conv_integer(ad_ram)) <= wrdata;
		end if;
	end if;
end process;

end Behavioral;

