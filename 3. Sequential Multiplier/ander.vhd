library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.NUMERIC_STD.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity ander is
		port(
			a : in  std_logic;
			b : in  std_logic_vector(7 downto 0);
			s : out std_logic_vector(7 downto 0)
		);
end ander;

architecture Behavioral of ander is
	
	signal concatanated : std_logic_vector(7 downto 0);
	
begin

	concatanated <= a & a & a & a & a & a & a & a;
	s <= b and concatanated;

end architecture;