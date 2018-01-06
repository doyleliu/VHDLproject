----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:06:36 11/22/2016 
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
Port (
		clk : in STD_LOGIC;
		btns : in STD_LOGIC;
		pulse : out STD_LOGIC
);
end pulse;

architecture Behavioral of pulse is
--avoid vibrating
begin
process(clk)
variable wipe : STD_LOGIC_VECTOR (2 downto 0);
variable pulse_tmp: STD_LOGIC;
begin
if (clk' event and clk='1') then
--shifting and judging by a sequence of input
	wipe := btns & wipe (2 downto 1);
end if;
--if the button is pressed beyond certain times we can obtain the pulse
pulse_tmp := (wipe(0) and wipe(1) and wipe(2));
pulse <= pulse_tmp;
end process;

end Behavioral;

