library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity freq_divide is
port(clk: in std_logic;  --100MHz,t=1e-8 s
		 Hclk: out std_logic; 
		 Vclk: out std_logic;  
		 cycle: out std_logic;
		 oclk : out std_logic
		 );
end freq_divide;

architecture Behavioral of freq_divide is

signal H_clk: std_logic := '1';
signal V_clk: std_logic := '1'; 
signal clk_state: std_logic := '1';
 
begin
Hclk<=H_clk; Vclk<=V_clk; cycle<=clk_state;

process(clk)
	variable count: integer range 0 to 1600:=0;
	variable count2: integer range 0 to 2:=0;
	variable count3: integer range 0 to 500000:=0;
    begin
	    if( clk'event and clk='1') then 
			if(count2=1) then 
				count2:=0;H_clk<=not H_clk;
			else 
				count2:=count2+1;
			end if;
				 
			if (count=1600-1) then
				count:=0; V_clk<=not V_clk;
			else
				count:=count+1;
			end if;
				
			if (count3=500000-1) then
				count3:=0; clk_state<=not clk_state;
			else
				count3:=count3+1;
			end if;
				 
		end if;
end process;
	
process(clk)
--the clk signal that avoid key bounce
variable v: STD_LOGIC;
variable count: integer range 0 to 50000;
begin
if (clk' event and clk= '1') then
count := count + 1;
if (count >= 50000) then
v:=not v;
count:= 0;
end if;
end if;
oclk <= v;
end process;
	  

end Behavioral;

