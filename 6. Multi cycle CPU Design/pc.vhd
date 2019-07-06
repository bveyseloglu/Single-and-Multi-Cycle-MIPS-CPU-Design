
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity pc is
   port(
		clk     : in  std_logic;
		reset_n : in  std_logic;
		en      : in  std_logic;
		sel_a   : in  std_logic;
		sel_imm : in  std_logic;
		add_imm : in  std_logic;
		imm     : in  std_logic_vector(15 downto 0);
		a       : in  std_logic_vector(15 downto 0);
		addr    : out std_logic_vector(31 downto 0)
	);
end pc;

architecture Behavioral of pc is

	signal sakla: unsigned(15 downto 0) := 0;--(others=>'0');

begin

	addr <= std_logic_vector(sakla);

	process(clk)
	begin
		if(clk'event and clk='1') then
			if (en='1') then
				sakla <= sakla + 4;
			end if;
			if (reset_n='1') then
				sakla <= 0;
			end if;
		end if;
	end process;
	
end Behavioral;

