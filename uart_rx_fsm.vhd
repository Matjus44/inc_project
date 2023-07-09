-- uart_rx_fsm.vhd: UART controller - finite state machine controlling RX side
-- Author(s): Name Surname (xjanek05)

library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity UART_RX_FSM is
    port(
       CLK : in std_logic;
       RST : in std_logic;
       DIN : in std_logic;
       CNT : in std_logic_vector(4 downto 0);
       CNT2 : in std_logic_vector(3 downto 0);
       RECIEVE : out std_logic;
       CNT_ENABLE : out std_logic;
       DOUT_VLD : out std_logic
    );
end entity;

architecture behavioral of UART_RX_FSM is

type my_state is (wait_start, wait_first, recieving, stop_bit, valid);
signal state : my_state := wait_start;

begin
	RECIEVE <= '1' when state = recieving else '0';
	CNT_ENABLE <= '1' when state = wait_first or state = recieving or state = stop_bit else '0';
	DOUT_VLD <= '1' when state = valid else '0';

	process (CLK,RST) begin
	
		if (rising_edge(CLK)) then
			if (RST = '1') then
			   state <=  wait_start;
			else
			
			case state is
			
			when wait_start => if DIN = '0' then
			state <= wait_first;
			end if;
			
			when wait_first => if CNT = "11000" then
			state <= recieving;
			end if;
			
			when recieving => if CNT2 = "1000" then
			state <= stop_bit;
			end if;
			
			when stop_bit => if CNT = "10000" then
			state <= valid;
			end if;
			
			when valid => state <= wait_start;
			
			when others => null;
			end case;
			end if;
		end if;
		
	end process;
	
end architecture;
