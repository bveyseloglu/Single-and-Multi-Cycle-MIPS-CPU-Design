library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity hhtoh is
Port ( clk : in STD_LOGIC;
	clk_output : out std_logic
);
end hhtoh;

architecture Behavioral of hhtoh is
signal count : unsigned (31 downto 0) := x"00000000";
begin
process (clk)
begin
    if (clk = '1' and clk'event) then
                if (count =150000000) then
                    clk_output <= '1';
                    count <= (others => '0');
				elsif (count < 75000000) then
                    clk_output <= '0';
                    count <= count + 1;
                else
                    clk_output <= '1';
                    count <= count + 1;
                end if ;
    end if;
end process;

--clk_output <= '1' when count=50000000 else
--             '0' ;
             
             

end Behavioral;
