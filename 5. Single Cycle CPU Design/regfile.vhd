library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity regfile is
  Port ( clk: in STD_LOGIC;
					 	 we3: in STD_LOGIC;
			ra1, ra2, wa3: in STD_LOGIC_VECTOR(4 downto 0);
						 wd3: in STD_LOGIC_VECTOR(31 downto 0);
				  rd1, rd2: out STD_LOGIC_VECTOR(31 downto 0));
end regfile;

architecture Behavioral of regfile is
    type reg_type is array(0 to 31) of std_logic_vector(31 downto 0);
	signal reg: reg_type;
begin
    reg(0) <= (others => '0');

	process(clk,ra1, ra2, wa3,we3,reg)
	begin
	
		if (we3 = '0') then 	-- read kismi
		    if (ra1 = "00000") then
		    	rd1 <= (others => '0');
		    else
		    	rd1 <= reg(conv_integer(ra1));
		    end if;

            if (ra2 = "00000") then
                rd2 <= (others => '0');
            else
                rd2 <= reg(conv_integer(ra2));
            end if;
			
		else 	-- write kismi
			if (clk = '1' and clk'event) then
				if (not(wa3 = "00000")) then
					reg(conv_integer(wa3)) <= wd3;
				end if;
			end if;
		end if;
	
	end process;

end Behavioral;
