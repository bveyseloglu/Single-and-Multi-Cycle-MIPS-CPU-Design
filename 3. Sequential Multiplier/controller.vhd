library IEEE; 
use IEEE.std_logic_1164.all;
-- use IEEE.std_logic_arith.all; -- don't use this
use IEEE.numeric_std.all; -- use that, it's a better coding guideline

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity controller is
		port(
			-- External signals
			clk   : in  std_logic;
			reset : in  std_logic;
			start : in  std_logic;
			done  : out std_logic;
			counter1 : out std_logic;
			-- Control signals
			load_multiplier   : out std_logic;
			shift_multiplier  : out std_logic;
			load_multiplicand : out std_logic;
			reset_product     : out std_logic; 
			load_product      : out std_logic; 
			shift_product     : out std_logic
		);
end controller;

architecture Behavioral of controller is
	
	type state_type is (s0, s1, s2, s3);
    signal state_reg, state_next : state_type;
	
	signal loop_counter : unsigned(2 downto 0) := "000";
	
begin

	process(clk)
	begin

		if (clk = '1' and clk'event) then
			state_reg <= state_next;
		end if;
		
		if (reset = '1') then
			state_reg <= s0;
        end if;
	
	end process;
	
	process(state_reg, start,clk)
	begin
	
		--init <= '0';
		load_multiplier <= '0';
		load_product <= '0';
		reset_product <= '0';
		shift_multiplier <= '0';
		shift_product <= '0';
		load_multiplicand <= '0';
		done <= '0';
		
		if (state_reg = s0) then
		
			load_multiplier <= '1';
			load_multiplicand <= '1';
			loop_counter <= "000";
			reset_product <= '1';
		
			if (start = '1') then
				state_next <= s1;
				--init <= '1';
			else
				state_next <= s0;
			end if;
		
		elsif (state_reg = s1) then
			
			state_next <= s2;
			load_product <= '1';
			loop_counter <= loop_counter + 1;
			
		elsif (state_reg = s2) then
			
			shift_multiplier <= '1';
			shift_product <= '1';
			
			if (std_logic_vector(loop_counter) = "000") then
				state_next <= s3;
			else
				state_next <= s1;
			end if;
		
		elsif (state_reg = s3) then
			
			state_next <= s3;
			done <= '1';
		
		end if;
	
	end process;
	

end architecture;