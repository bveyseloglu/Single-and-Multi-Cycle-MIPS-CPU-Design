library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity rom is
    Port ( clk_rom 		: in  STD_LOGIC;
		   cs_rom 		: in  STD_LOGIC;
           read_rom 	: in  STD_LOGIC;
           ad_rom 		: in  STD_LOGIC_VECTOR (12 downto 0);
           rddata 		: out  STD_LOGIC_VECTOR (31 downto 0)
		   );
end rom;


architecture Behavioral of rom is

	type reg_type is array(0 to 1023) of std_logic_vector(31 downto 0);
	signal reg: reg_type;

begin

	--data <= reg(conv_integer(address));

    reg(1) <= "11111111111111110000000000000000";
    reg(4) <= "00000000000000001111111111111111";

	process(clk_rom)
	begin
	
		if (clk_rom = '1' and clk_rom'event) then
			if (cs_rom = '1' and read_rom = '1') then
				rddata <= reg(conv_integer(ad_rom));
			end if;
		end if;
	
	end process;

end Behavioral;