library IEEE; 
use IEEE.std_logic_1164.all;
-- use IEEE.std_logic_arith.all; -- don't use this
use IEEE.numeric_std.all; -- use that, it's a better coding guideline

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity producter is
		port(
			clk         : in  std_logic;
			reset       : in  std_logic;
			load        : in  std_logic;
			shift_right_p : in  std_logic;
			datain      : in  std_logic_vector(8 downto 0);
			dataout     : out std_logic_vector(15 downto 0)
		);
end producter;

architecture Behavioral of producter is
	
	signal data_reg : std_logic_vector(16 downto 0) := "00000000000000000";

begin
	
	
	process(clk, load, reset)
	begin
	
	   if (reset = '1') then
	       data_reg <= "00000000000000000";
	   end if;
	
	   if (clk = '1' and clk'event and load = '1') then
            data_reg <= datain & data_reg(7 downto 0);
        end if;
	
		if (clk = '1' and clk'event and shift_right_p = '1') then
				data_reg <=  STD_LOGIC_VECTOR(shift_right(unsigned(data_reg), 1));

		end if;
	
	end process;
	
	dataout <= data_reg(15 downto 0);
	


end architecture;