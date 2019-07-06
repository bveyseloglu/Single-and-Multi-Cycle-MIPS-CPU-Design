
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;


---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mcand is
	port(
			clk     : in  std_logic;
			load    : in  std_logic;
			datain  : in  std_logic_vector(7 downto 0);
			dataout : out std_logic_vector(7 downto 0)
		);
end mcand;

architecture Behavioral of mcand is

	signal data_reg : std_logic_vector(7 downto 0) := "00000000";

begin

	process(clk)
	begin
	
		if (clk = '1' and clk'event and load = '1') then
			data_reg <= datain;
		else
			data_reg <= data_reg;
		end if;
	
	end process;
	
	dataout <= data_reg;
	


end architecture;
