library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;


--use IEEE.NUMERIC_STD.ALL;


entity Register_File is
    Port ( clk : in  STD_LOGIC;
           wren : in  STD_LOGIC;
           aa : in  STD_LOGIC_VECTOR (4 downto 0);
           ab : in  STD_LOGIC_VECTOR (4 downto 0);
           aw : in  STD_LOGIC_VECTOR (4 downto 0);
           a : out  STD_LOGIC_VECTOR (31 downto 0);
           b : out  STD_LOGIC_VECTOR (31 downto 0);
           wrdata : in  STD_LOGIC_VECTOR (31 downto 0));
end Register_File;

architecture Behavioral of Register_File is

type ram_type is array(0 to 31) of std_logic_vector(31 downto 0);
signal ram : ram_type;
begin
	
	process(clk)
	begin
		if(clk'event and clk='1') then
				if (wren='1') then
					ram(conv_integer(aw))<=wrdata;
				end if;
		end if;
	end process;
	
	process(aa,ab)
	begin
		if( conv_integer(aa)=0) then a<=x"00000000";
		else a<=ram(conv_integer(aa));
		end if;
		if(conv_integer(ab)=0) then b<=x"00000000";
		else b<=ram(conv_integer(ab));
		end if;
	end process;
	
end Behavioral;

