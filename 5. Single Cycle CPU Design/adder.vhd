
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity adder is
port (a, b: in STD_LOGIC_VECTOR(31 downto 0);
				y: out STD_LOGIC_VECTOR(31 downto 0));
end adder;

architecture Behavioral of adder is
signal toplam : std_logic_vector(32 downto 0);
begin
toplam <= std_logic_vector(unsigned('0' & a) + unsigned('0' & b));
y <= toplam(31 downto 0);
end Behavioral;
