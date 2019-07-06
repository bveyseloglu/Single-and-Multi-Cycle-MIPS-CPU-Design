library IEEE; 
use IEEE.std_logic_1164.all;
-- use IEEE.std_logic_arith.all; -- don't use this
use IEEE.numeric_std.all; -- use that, it's a better coding guideline

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity adder is
		port(
				a : in  std_logic_vector(7 downto 0);
				b : in  std_logic_vector(7 downto 0);
				s : out std_logic_vector(8 downto 0)
			);
end adder;

architecture Behavioral of adder is
	
begin

	s <= std_logic_vector(unsigned('0' & a) + unsigned('0' & b));

end architecture;