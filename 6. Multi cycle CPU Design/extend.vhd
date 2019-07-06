
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity extend is
	PORT(signed_out : IN STD_LOGIC;
		 imm16 : IN STD_LOGIC_VECTOR(15 downto 0);
		 imm32 : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
end extend;

architecture Behavioral of extend is

	signal extended : std_logic_vector(31 downto 0);

begin

	extended <=  x"0000" & imm16 when (imm16(15)='0') else  x"ffff" & imm16;

	imm32 <= x"0000" & imm16 when signed_out = '0' else 
			 extended when signed_out = '1' else;

	
end Behavioral;

