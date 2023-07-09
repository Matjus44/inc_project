-- uart_rx.vhd: UART controller - receiving (RX) side
-- Author(s): Name Surname (xjanek05)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

-- Entity declaration (DO NOT ALTER THIS PART!)
entity UART_RX is
    port(
        CLK      : in std_logic;
        RST      : in std_logic;
        DIN      : in std_logic;
        DOUT     : out std_logic_vector(7 downto 0);
        DOUT_VLD : out std_logic
    );
end entity;


-- Architecture implementation (INSERT YOUR IMPLEMENTATION HERE)
architecture behavioral of UART_RX is

signal cnt : std_logic_vector(4 downto 0);
signal cnt2 : std_logic_vector(3 downto 0);
signal recieve : std_logic;
signal cnt_en : std_logic;
signal data_valid : std_logic;

begin

-- Instance of RX FSM
fsm: entity work.UART_RX_FSM
port map (
	CLK => CLK,
	RST => RST,
	CNT => cnt,
	CNT2 => cnt2,
	DIN => DIN,
	RECIEVE => recieve,
	CNT_ENABLE => cnt_en,
	DOUT_VLD => data_valid
);

    DOUT_VLD <= data_valid;
    
    process (CLK,RST,recieve,cnt2,DIN,cnt) begin
    
    	if (RST = '1') then
    		
    		DOUT <= "00000000";
    	
    	elsif (RST = '1' or cnt_en = '0') then
    	
    		cnt2 <= "0000";
    		cnt <= "00000";
    
    	elsif (rising_edge(CLK)) then 
    		
    		cnt <= cnt + 1;
    		
    		if (recieve = '1') then
    		
    			if (cnt(4) = '1') then
				
				cnt <= "00001";
	    			case cnt2 is
	    			when "0000" => DOUT(0) <= DIN; 
	    			when "0001" => DOUT(1) <= DIN; 
	    			when "0010" => DOUT(2) <= DIN; 
	    			when "0011" => DOUT(3) <= DIN; 
	    			when "0100" => DOUT(4) <= DIN; 
	    			when "0101" => DOUT(5) <= DIN;
	    			when "0110" => DOUT(6) <= DIN;  
	    			when "0111" => DOUT(7) <= DIN; 
	    			when others => null;	
    				end case;
    				cnt2 <= cnt2 + 1;
    			end if;
    		end if;
    	end if;
    		
    end process;

end architecture;
