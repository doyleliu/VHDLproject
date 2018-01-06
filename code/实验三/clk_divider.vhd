----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:02:07 11/22/2016 
-- Design Name: 
-- Module Name:    clk_divider - Behavioral 
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

entity clk_divider is
Port ( 
		clk_in : in STD_LOGIC;	
		clk_out : out STD_LOGIC;
		Blink: out STD_LOGIC
		);
end clk_divider;

architecture Behavioral of clk_divider is

begin
process(clk_in)
variable v,v2: STD_LOGIC;
variable count: integer range 0 to 50000;
variable count2: integer range 0 to 25000000;
begin
--count the number and get the divided clk
if(clk_in' event and clk_in = '1') then
	count := count + 1;
	count2 := count2 + 1;
	if(count >= 50000) then
		v := not v;
		count := 0;
	end if;
	if(count2 >= 25000000) then
		v2 := not v2;
		count2 := 0;
	end if;
end if;
clk_out <= v;
Blink <= v2;--send the blink through a differnt frequency
end process;


end Behavioral;

