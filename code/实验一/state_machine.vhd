----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:42:40 11/13/2016 
-- Design Name: 
-- Module Name:    state_machine - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
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
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity state_machine is
port(
		clk : in STD_LOGIC;
		input_s : in STD_LOGIC;--input whether '0' or '1'
		pulse_in : in STD_LOGIC;
		rst : in STD_LOGIC;
		led : out STD_LOGIC_VECTOR(3 downto 0)
	);
end state_machine;

architecture Behavioral of state_machine is
type state is (zero,one,two,three,four);
signal pr_state, nx_state: state;
begin

process (rst,pulse_in)
--reset the function or execute the function
begin
if (rst ='1') then
pr_state <= zero;
elsif (pulse_in' event and pulse_in= '0') then
pr_state <= nx_state;
end if;
if(pr_state = four) then led <= "0001";
else led <= "0000";
end if;
end process;

process (input_s, pr_state)
begin
--juding by the state machine
case pr_state is
when zero =>
		if (input_s='1') then nx_state <= one;
		else nx_state <= zero;
		end if;
when one =>
		if (input_s='1') then nx_state <= two;
		else nx_state <=zero;
		end if;
when two =>
		if (input_s='1') then nx_state <= two;
		else nx_state <=three;
		end if;
when three =>
		if (input_s='1') then nx_state <= four;
		else nx_state <=zero;
		end if;
when four =>
		if (input_s='1') then nx_state <= two;
		else nx_state <=zero;
		end if;
end case;
end process;
end Behavioral;

