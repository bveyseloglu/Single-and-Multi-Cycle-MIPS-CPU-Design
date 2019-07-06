LIBRARY ieee;
USE ieee.std_logic_1164.all; 
use IEEE.NUMERIC_STD.ALL;

LIBRARY work;

entity add_sub is
	generic(n : INTEGER);
	PORT(sub_mode : IN STD_LOGIC; --0: topla, 1: cikar
		 a : IN STD_LOGIC_VECTOR(31 downto 0);
		 b : IN STD_LOGIC_VECTOR(31 downto 0);
		 carry : OUT STD_LOGIC;
		 zero : OUT STD_LOGIC;
		 r : OUT STD_LOGIC_VECTOR(31 downto 0)
	);
end add_sub;


architecture arc of add_sub is

	signal r_sub, r_add, b_twosc : STD_LOGIC_VECTOR(32 downto 0);

begin

	b_twosc <= std_logic_vector(signed(not('0' & b)) + 1);
    r_add <= std_logic_vector(signed('0' &a) + signed('0' &b));
    r_sub <= std_logic_vector(signed('0' &a) + signed(b_twosc));
    
    with sub_mode select r <=
        r_add(31 downto 0) when '0',
        r_sub(31 downto 0) when others;
        
    with sub_mode select carry <=
        r_add(32) when '0',
        r_sub(32) when others;
    
    zero  <= '1' when (sub_mode = '1' and r_sub = "000000000000000000000000000000000") else 
             '1' when (sub_mode = '0' and r_add = "000000000000000000000000000000000") else
             '0';


end arc;