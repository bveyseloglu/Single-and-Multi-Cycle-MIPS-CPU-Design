library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;

entity sequential_adder is
	port (
		CLK 	: in std_logic;
		RESET 	: in std_logic;
		STARTA 	: in std_logic;
		A 		: in std_logic;
		LOADB 	: in std_logic;
		B 		: in std_logic_vector(3 downto 0);
		STARTC 	: out std_logic;
		C 		: out std_logic;
		input_accepted : out std_logic
		);
end sequential_adder;

architecture synth of sequential_adder is

    --component adder_n_bit
    --	generic (n : INTEGER:=4);
    --Port (     in1 : in  STD_LOGIC_VECTOR (3 downto 0);
    --           in2 : in  STD_LOGIC_VECTOR (3 downto 0);
    --           sout : out  STD_LOGIC_VECTOR (3 downto 0);
    --           cout : out  STD_LOGIC);
    --end component;
   
    
    type state_type is (WaitB, WaitA, GetA, Comp, OutC);
    signal NEXT_STATE, STATE : state_type;
    
    signal NEXT_COUNT, COUNT : integer range 0 to 3;
    signal REGB, PISOC, A_par : std_logic_vector(3 downto 0);
    signal s3 : unsigned(4 downto 0);
    signal SIPOA : std_logic_vector(3 downto 0);
    signal SUM, s1, s2  : std_logic_vector(4 downto 0);
    signal SHIFTA : std_logic;
    signal LATCHB : std_logic;
    signal LATCHC : std_logic;
    signal SHIFTC : std_logic;
    
    begin
    
    --A is sent to the adder correctly.
    SIPO : process (CLK, RESET)
        begin
            if(RESET = '1') then
                SIPOA <= (others => '0');
            elsif(CLK'event and CLK = '1') then
                if(SHIFTA = '1') then
                    SIPOA <= SIPOA(2 downto 0) & A ;
                end if;
            end if;
    end process SIPO;
    
    
    
    --B is taken register when loadb signal goes high
    REG: process (CLK, RESET)
    begin
        if(RESET = '1') then
           REGB <= (others => '0');
        elsif(CLK'event and CLK = '1') then
           if(LATCHB = '1') then
           REGB <= B;
           end if;
        end if;
    end process REG;
    
    -- addition correctly works
    --addition: adder_n_bit
    --    generic map (n => 4)
    --	port map( );
    s1 <= '0' & REGB;
    s2 <= '0' & SIPOA;
    s3 <= unsigned(s1) + unsigned(s2);
    SUM <= std_logic_vector(s3);
    --Parallel to Serial conversion
    PISO: process (CLK, RESET)
    begin
        if(RESET = '1')then
            PISOC <= (others => '0');
        elsif(CLK'event and CLK = '1')then
            if(LATCHC = '1')then 
                PISOC <= SUM(3 downto 0);
            elsif(SHIFTC = '1')then
            PISOC <= '0' & PISOC(3 downto 1);
            end if;
        end if;
    end process PISO;
    C <= PISOC(0);
    
    --FSM combinational
    FSM_COMB: process (STATE, COUNT, STARTA, LOADB)
    begin
    
    NEXT_STATE <= STATE;
    NEXT_COUNT <= COUNT;
    SHIFTA <= '0';
    LATCHB <= '0';
    LATCHC <= '0';
    SHIFTC <= '0';
    STARTC <= '0';
    input_accepted <= '0';
    
        case state is
            when WaitB =>
              
              if(LOADB = '1') then
                  NEXT_STATE <= WaitA;
                  LATCHB <= '1';
              end if;	
                
            when WaitA =>
                if(STARTA = '1')then
                     NEXT_STATE <= GetA;
                     NEXT_COUNT <= 0;
                     SHIFTA <= '1';
                 end if;
            when GetA =>
                input_accepted <= '1';
                SHIFTA <= '1';
                if(COUNT = 2) then
                    NEXT_STATE <= Comp;    
                else 
                    NEXT_COUNT <= COUNT + 1;
                end if;
            when Comp =>
                NEXT_STATE <= OutC;
                NEXT_COUNT <= 0;
                LATCHC <= '1';	
            when OutC =>
                --STARTC <= '1';
                if(COUNT=3)then
                    NEXT_STATE <= WaitB;
                else
                     STARTC <= '1';
                     NEXT_COUNT <= COUNT + 1;
                     SHIFTC <= '1';
                     --if(COUNT = 0) then
                        --STARTC <= '1';
                     --end if;
                end if;     
        end case;
        
    end process FSM_COMB;
    
    --FSM Sequential
    FSM_SEQ: process (CLK, RESET)
    begin
        if (RESET = '1') then
            STATE <= WaitB;
            COUNT <= 0;
        elsif (CLK'event and CLK = '1') then
            STATE <= NEXT_STATE;
            COUNT <= NEXT_COUNT;
        end if;
    end process FSM_SEQ;

end synth;