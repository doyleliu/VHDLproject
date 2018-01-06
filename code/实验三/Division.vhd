----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    11:12:32 11/22/2016 
-- Design Name: 
-- Module Name:    Division - Behavioral 
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
use IEEE.STD_LOGIC_arith.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Division is
Port (
		clk : in STD_LOGIC;
		btns : in STD_LOGIC;
		Blink : in STD_LOGIC;
		pulse : in STD_LOGIC;
		dividend : in STD_LOGIC_VECTOR (3 downto 0);
		divisor : in STD_LOGIC_VECTOR (3 downto 0);
		quot : out STD_LOGIC_VECTOR (3 downto 0);
		remain : out STD_LOGIC_VECTOR (3 downto 0)
		);
end Division;

architecture Behavioral of Division is
signal sign_flag: std_logic;

begin
process(pulse)
variable i:integer range 0 to 7;
variable var1,var2,count: STD_LOGIC_VECTOR (3 downto 0);
variable temp1,temp2,result1,result2:STD_LOGIC_VECTOR (3 downto 0);
begin 
if (pulse = '1') then-- when there is input
if (divisor(2 downto 0)="000") then
	sign_flag<='1';-- mention the divisor is '0'
	quot(2 downto 0)<="000";
	remain<="0000";
else
	sign_flag<='0';
if(dividend(3)='1') then -- if the number was negative and using its complement
	var1:=(not dividend) + "0001";
else var1:= dividend;
end if;
if (divisor(3)='1') then  -- if the number was negative and using its complement
	var2:=(not divisor) + "0001";
else var2:=divisor;
end if;
count:="0000";
for i in 0 to 7 loop--work out the result by doing arithmetic
if (var1>=var2) then 
	var1 :=var1-var2;
	count:=count+'1';
else 
	result1:=count;
	result2:=var1;
	exit;
end if;
end loop;
if ((dividend(3) xor divisor(3)) ='1') then--if one of the num is negative 
	result1:= (not result1)+'1'; 
end if;
if ((divisor(3) xor result1(3))='1') then -- if one of the num is negative
	result2:=(not result2) + '1'; 
end if;
quot<=result1; 
remain<=result2;
end if;
end if;
if (sign_flag='1') then 
	quot(3)<=Blink; 
end if;
end process;

end Behavioral;

