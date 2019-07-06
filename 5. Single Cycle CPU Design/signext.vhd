
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity signext is
        port( a: in STD_LOGIC_VECTOR (15 downto 0);
			y: out STD_LOGIC_VECTOR (31 downto 0));
end signext;

architecture Behavioral of signext is

begin
y <= ("0000000000000000" & a) when (a(15) = '0') else
     ("1111111111111111" & a);   

end Behavioral;
