----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:53:50 11/13/2016 
-- Design Name: 
-- Module Name:    clk_devider - Behavioral 
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

entity clk_devider is
port(
		iclk : in STD_LOGIC;
		oclk : out STD_LOGIC
	);
end clk_devider;

architecture Behavioral of clk_devider is

begin
process (iclk)
variable v: STD_LOGIC;
variable count: integer range 0 to 50000; --count the number and get the divided clk
begin
if (iclk' event and iclk= '1') then
count := count + 1;
if (count >= 50000) then
v:=not v;
count:= 0;
end if;
end if;
oclk <= v;
end process;


end Behavioral;

