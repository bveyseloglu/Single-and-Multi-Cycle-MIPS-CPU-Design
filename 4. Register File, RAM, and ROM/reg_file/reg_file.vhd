library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity reg_file is
	port(
		clk					: in std_logic;
		aa, ab, aw  		: in std_logic_vector(4 downto 0);
		wren 				: in std_logic;
		wrdata 				: in std_logic_vector(31 downto 0);
		a,b 				: out std_logic_vector(31 downto 0)
		);
end reg_file;

architecture Behavioral of reg_file is

	type reg_type is array(0 to 31) of std_logic_vector(31 downto 0);
	signal reg: reg_type;

begin

	--data <= reg(conv_integer(address));

    reg(0) <= (others => '0');

	process(clk,aa,ab,aw,wren)
	begin
	
		if (wren = '0') then 	-- read kismi
		    if (aa = "00000") then
		    	a <= (others => '0');
		    else
		    	a <= reg(conv_integer(aa));
		    end if;

            if (ab = "00000") then
                b <= (others => '0');
            else
                b <= reg(conv_integer(ab));
            end if;
			
		else 	-- write kismi
			if (clk = '1' and clk'event) then
				if (not(aw = "00000")) then
					reg(conv_integer(aw)) <= wrdata;
				end if;
			end if;
		end if;
	
	end process;

	
end Behavioral;