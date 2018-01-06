
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity debounce is
port( clk: in std_logic;
		btn: in std_logic_vector(4 downto 0);
		stop: out std_logic; 
		pulse : out std_logic;
		flag: out std_logic_vector(4 downto 0));
end debounce;

architecture Behavioral of debounce is
signal state :std_logic;
begin

process(clk)
variable internal0,internal1,internal2,internal3,internal4 : STD_LOGIC_VECTOR(3 downto 0);
variable pulse0,pulse1,pulse2,pulse3,pulse4 : STD_LOGIC;
begin
--avoid vibrating
if(clk' event and clk = '1')then
--three cycles of the input clk;
	internal0 := btn(0) & internal0(3 downto 1);
	internal1 := btn(1) & internal1(3 downto 1);
	internal2 := btn(2) & internal2(3 downto 1);
	internal3 := btn(3) & internal3(3 downto 1);
	internal4 := btn(4) & internal4(3 downto 1);
	pulse0 := (internal0(0) and internal0(1) and internal0 (2) and internal0 (3));
	pulse1 := (internal1(0) and internal1(1) and internal1 (2) and internal1 (3));
	pulse2 := (internal2(0) and internal2(1) and internal2 (2) and internal2 (3));
	pulse3 := (internal3(0) and internal3(1) and internal3 (2) and internal3 (3));
	pulse4 := (internal4(0) and internal4(1) and internal4 (2) and internal4 (3));
	
	if(pulse0 = '1') then 	
		flag<="00001";
	end if;
	if(pulse1 = '1') then 	
		flag<="00010";
		state <= not state;-- change the state when pushing on the certain button
		stop <= state;
	end if;
	if(pulse2 = '1') then 	
		flag<="00100";
	end if;
	if(pulse3 = '1') then 	
		flag<="01000";
	end if;
	if(pulse4 = '1') then 	
		flag<="10000";
	end if;
pulse <= pulse1;	
end if;
end process;
	


end Behavioral;

