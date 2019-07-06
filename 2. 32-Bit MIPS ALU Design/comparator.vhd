LIBRARY ieee;
USE ieee.std_logic_1164.all; 
use IEEE.NUMERIC_STD.ALL;

LIBRARY work;

entity comparator is
    PORT(carry : IN STD_LOGIC;
         zero : IN STD_LOGIC;
         a_31 : IN STD_LOGIC;
         b_31 : IN STD_LOGIC;
         diff_31 : IN STD_LOGIC;
         op : IN STD_LOGIC_VECTOR(2 downto 0);
         r : OUT STD_LOGIC_VECTOR(31 downto 0)
    );
end comparator;

architecture arc of comparator is

    signal res : std_logic;

begin

            -- equal
    res  <= '1' when (zero = '1' and op = "100") else
            '1' when (zero = '0' and op = "011") else
            -- signed greater or equal and less than
            '1' when (zero = '1' or (a_31 = '0' and b_31 = '1') or (a_31 = '0' and b_31 = '0' and diff_31 = '0') or (a_31 = '1' and b_31 = '1' and diff_31 = '0')) and op = "001" else
            '1' when not(zero = '1' or (a_31 = '0' and b_31 = '1') or (a_31 = '0' and b_31 = '0' and diff_31 = '0') or (a_31 = '1' and b_31 = '1' and diff_31 = '0')) and op = "010" else
            -- unsigned greater or equal and less than
            '1' when (carry = '1' and op = "101") else
            '1' when (carry = '0' and op = "110") else
            -- else
            '0';
            
    r <= "0000000000000000000000000000000" & res;      

end arc;