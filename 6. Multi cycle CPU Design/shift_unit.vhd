LIBRARY ieee;
USE ieee.std_logic_1164.all; 
use IEEE.NUMERIC_STD.ALL;

LIBRARY work;

entity shift_unit is
    generic(n : INTEGER := 32);
    PORT(a : IN STD_LOGIC_VECTOR(31 downto 0);
         b : IN STD_LOGIC_VECTOR(4 downto 0);
         op : IN STD_LOGIC_VECTOR(2 downto 0);
         r : OUT STD_LOGIC_VECTOR(31 downto 0)
    );
end shift_unit;

architecture arc of shift_unit is

    signal r_rol, r_ror, r_sll, r_srl, r_sra : STD_LOGIC_VECTOR(31 downto 0);

begin

    r_sll <=  STD_LOGIC_VECTOR(shift_left(unsigned(a), to_integer(unsigned(b))));
    r_srl <=  STD_LOGIC_VECTOR(shift_right(unsigned(a), to_integer(unsigned(b))));
    
    r_sra <=  STD_LOGIC_VECTOR(shift_right(signed(a), to_integer(signed(b(4 downto 0)))));
    
    r_ror <= STD_LOGIC_VECTOR(rotate_right(unsigned(a), to_integer(unsigned(b))));
    r_rol <= STD_LOGIC_VECTOR(rotate_left(unsigned(a), to_integer(unsigned(b))));
    
    with op select r <=
            r_rol when "000",
            r_ror when "001",
            r_sll when "010",
            r_srl when "011",
            r_sra when "111",
            "00000000000000000000000000000000" when others;

end arc;