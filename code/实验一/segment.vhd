----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:44:21 11/13/2016 
-- Design Name: 
-- Module Name:    segment - Behavioral 
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
use IEEE.STD_LOGIC_ARITH.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity segment is
port(
		clk : in STD_LOGIC;
		pulse : in STD_LOGIC;
		sign : in STD_LOGIC;
		rst : in STD_LOGIC;
		an : out STD_LOGIC_VECTOR(3 downto 0);
		seg : out STD_LOGIC_VECTOR(6 downto 0)
	);
end segment;

architecture Behavioral of segment is
type vector is array(3 downto 0) of integer;
signal tmp:vector ;
signal count : integer range 0 to 4;
begin

process (pulse,rst)
begin
if (rst='1') then
tmp <= (3,3,3,3);
elsif (pulse' event and pulse ='0') then
tmp <= tmp(2 downto 0) & conv_integer(sign);--shifting the output one position every time
end if;
end process;

process (clk)
variable cnt:integer range 0 to 4;
begin
-- choose the segment number
if (clk' event and clk='1' ) then
cnt := cnt + 1;
if (cnt=4) then 
cnt:=0;
end if;
end if;
count<=cnt;
end process;


seg <= "1000000" when tmp(count)=0 else
"1111001" when tmp(count)=1 else
"1111111";
an <= "1110" when count=0 else
"1101" when count=1 else
"1011" when count=2 else
"0111";
end Behavioral;

