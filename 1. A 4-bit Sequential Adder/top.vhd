----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/18/2019 09:58:47 PM
-- Design Name: 
-- Module Name: top - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity top is
    port (
        CLK     : in std_logic;
        RESET     : in std_logic;
        STARTA     : in std_logic;
        A         : in std_logic;
        LOADB     : in std_logic;
        B         : in std_logic_vector(3 downto 0);
        STARTC     : out std_logic;
        C         : out std_logic;
        input_accepted : out std_logic;
        clock_seysi : out std_logic
    );
end top;

architecture Behavioral of top is

    component hhtoh
        Port ( clk : in STD_LOGIC;
            clk_output : out std_logic
        );
    end component;
    
    component sequential_adder 
        port (
            CLK     : in std_logic;
            RESET     : in std_logic;
            STARTA     : in std_logic;
            A         : in std_logic;
            LOADB     : in std_logic;
            B         : in std_logic_vector(3 downto 0);
            STARTC     : out std_logic;
            C         : out std_logic;
            input_accepted : out std_logic
            );
    end component;

    signal clk_out : std_logic;

begin

    ht : hhtoh port map (clk, clk_out);
    sqa : sequential_adder port map (clk_out, reset, starta, a, loadb, b, startc, c, input_accepted );
    clock_seysi <= clk_out;
    
end Behavioral;
