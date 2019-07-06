
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mux2 is
generic (wid: integer);
	port ( d0, d1: in STD_LOGIC_VECTOR(wid-1 downto 0);
					s: in STD_LOGIC;
					y: out STD_LOGIC_VECTOR(wid-1 downto 0)
					 );
end mux2;

architecture Behavioral of mux2 is

begin
y <= d0 when (s = '0') else d1;

end Behavioral;
