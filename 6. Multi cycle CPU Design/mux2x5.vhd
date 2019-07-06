
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;



entity mux2x5 is
	PORT(sel : IN STD_LOGIC;
		 i0 : IN STD_LOGIC_VECTOR(4 downto 0);
		 i1 : IN STD_LOGIC_VECTOR(4 downto 0);
		 o : OUT STD_LOGIC_VECTOR(4 downto 0)
	);
end mux2x5;

architecture Behavioral of mux2x5 is


begin

	o <= i0 when sel = '0' else 
	     i1 when sel = '1' else;

	
end Behavioral;

