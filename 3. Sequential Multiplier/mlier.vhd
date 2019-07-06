library IEEE; 
use IEEE.std_logic_1164.all;
-- use IEEE.std_logic_arith.all; -- don't use this
use IEEE.numeric_std.all; -- use that, it's a better coding guideline

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity mlier is
		port(
			clk         : in  std_logic;
			load        : in  std_logic;
			shift_right_m : in  std_logic;
			datain      : in  std_logic_vector(7 downto 0);
			dataout     : out std_logic
		);
end mlier;

architecture Behavioral of mlier is
	
	signal data_reg : std_logic_vector(7 downto 0) := "00000000";

begin

	process(clk)
	begin
	
		if (clk = '1' and clk'event and load = '1') then
		
                data_reg <= datain;
		end if;
		
		if (clk = '1' and clk'event and shift_right_m = '1') then
		
				data_reg <=  STD_LOGIC_VECTOR(shift_right(unsigned(data_reg), 1));

		end if;
	
	end process;
	
	dataout <= data_reg(0);
	


end architecture;