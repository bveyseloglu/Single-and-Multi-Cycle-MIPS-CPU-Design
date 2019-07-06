
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity maindec is
  Port ( op: in STD_LOGIC_VECTOR (5 downto 0);
			memtoreg, memwrite: out STD_LOGIC;
				 branch, alusrc: out STD_LOGIC;--alusrc=extop
			  regdst, regwrite: out STD_LOGIC;
						     jump: out STD_LOGIC;--jump=nPCsel
							 aluop: out STD_LOGIC_VECTOR (1 downto 0)
							 );
end maindec;

architecture Behavioral of maindec is

begin
    memtoreg <= '1' when (op = "100011") else '0';
    memwrite <= '1' when (op = "101011") else '0';
    branch <= '1' when (op = "000100") else '0';
    alusrc <= '1' when ((op = "100011") or (op = "101011")) else '0';
    regdst <= '1' when (op = "000000") else '0';
    regwrite <= '1' when ((op = "000000") or (op = "100011") or (op = "001101")) else '0';
    jump <= '1' when (op = "000100") else '0';
    aluop <= "00" when ((op = "100011") or (op = "101011")) else
             "01" when (op = "000100") else
             "10" when (op = "000000") else
             "11";
end Behavioral;
