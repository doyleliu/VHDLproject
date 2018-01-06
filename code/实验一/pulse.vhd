----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:36:29 11/13/2016 
-- Design Name: 
-- Module Name:    pulse - Behavioral 
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

entity pulse is
port(
		btnl : in STD_LOGIC;
		btnr : in STD_LOGIC;
		clk : in STD_LOGIC;
		sign_out : out STD_LOGIC;
		pulse_out : out STD_LOGIC
	);
end pulse;

architecture Behavioral of pulse is

begin
process(clk)
variable internal0, internal1 : STD_LOGIC_VECTOR(2 downto 0);
variable wipe0, wipe1 : STD_LOGIC;
begin
--avoid vibrating
if(clk' event and clk = '1')then
	--shifting and judging by a sequence of input
	internal0 := btnl & internal0(2 downto 1);
	internal1 := btnr & internal1(2 downto 1);
end if;
--if the button is pressed beyond certain times we can obtain the pulse
wipe0 := (internal0(0) and internal0(1) and internal0 (2));
wipe1 := (internal1(0) and internal1(1) and internal1 (2));
if(wipe0 = '1') then 	
	sign_out <= '0';-- the signal represent the input of '1' or '0'
end if;
if(wipe1 = '1') then
	sign_out <= '1';
end if;
pulse_out <= wipe0 or wipe1;
end process;
end Behavioral;

