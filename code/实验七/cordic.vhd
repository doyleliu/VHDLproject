library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cordic is
	port(
	clk: in std_logic;
	btn0: in std_logic;
	btn1: in std_logic;
	btn2: in std_logic;
	btn3: in std_logic;
	sw0: in std_logic;
	sw1: in std_logic;
	qdrt: in std_logic_vector(1 downto 0);
	segsel:out bit_vector(3 downto 0);
	seg:out std_logic_vector(0 to 6);
	sign: out std_logic_vector(1 downto 0));
end cordic;

architecture Behavioral of cordic is
	 signal clk1: std_logic := '1';
	 signal clk2: std_logic := '1';
	 signal clk3: std_logic := '1';
	 -- signal clk4: std_logic:='1'; 
	 -- signal init_x: std_logic:='1'; 
	 -- signal init_y: std_logic:='1';
	 signal p: integer range 0 to 2400:=0;
	 signal q: integer range 0 to 900000:=0;
	 signal word_num: std_logic_vector(0 to 3):="0000";
	 signal tmp: std_logic_vector(0 to 6):="1111111";
	 signal sel: bit_vector(3 downto 0):="1110";
	 signal count: std_logic_vector(3 downto 0):="0000";
	 signal count2: std_logic_vector(3 downto 0):="0000";
	 signal count3: std_logic_vector(3 downto 0):="0000";
	 signal count4: std_logic_vector(3 downto 0):="0000";
	 signal count_1: std_logic_vector(15 downto 0):="0000000000000000";
	 signal sin: std_logic_vector(15 downto 0):="0000000000000000";	--sin
	 signal cos: std_logic_vector(15 downto 0):="0000000000000000";	--cos
	 signal ck1: std_logic := '0';	--judge the input key number;
	 signal ck2: std_logic := '0';
	 signal ck3: std_logic := '0';
	 signal ck4: std_logic := '0';
	 type arctan is array(0 to 20) of integer;	--use arctan(1/2**n) function
	 signal T: arctan;
	 signal led:std_logic_vector(1 downto 0);
begin
			segsel <= sel;
			seg<=tmp;	
			sign<=led;
	process(clk)
	begin
		case qdrt is
			when "00"=> led<="11";
			when "01"=> led<="10";
			when "10"=> led<="00";
			when "11"=> led<="01";
			when others=> null;
		end case;
	end process;

	
process(clk1) -- count the number of each input key to avoid vibrating
begin
if (clk1'event and clk1='1')	then
	if (ck1='1') then	
		count<=count+1;
	end if;
			
	if (ck2='1') then	
		count2<=count2+1;
	end if;
			
	if (ck3='1') then	
		count3<=count3+1;
	end if;
			
	if (ck4='1') then	
		count4<=count4+1;
	end if;
end if;		
end process;
	
	
process(clk) -- the process is used to count clk and determine the key number

variable number1: integer range 0 to 16000000;
variable number2: integer range 0 to 16000000;
variable number3: integer range 0 to 16000000;
variable number4: integer range 0 to 16000000;
begin
if clk'event and clk='1' then 
		  
	if(btn0='1')	then
		if (number1/=16000000)	then	--avoid vibrating
			number1:=number1+1;
			if (number1=99999)		then	ck1<='1';	ck2<='0';	ck3<='0';	ck4<='0';	end if;
			if (number1=589999)	then	ck1<='0';	end if;
		end if;
	else
		number1:=0;	ck1<='0';
	end if;
				
	if (btn1='1') then
		if (number2/=16000000)	then
			number2:=number2+1;
			if (number2=99999)		then	ck1<='0';	ck2<='1';	ck3<='0';	ck4<='0';	end if;
			if (number2=589999)	then	ck2<='0';	end if;
		end if;
	else
		number2:=0;	ck2<='0';
	end if;
				
	if (btn2='1')	then
		if (number3/=16000000)	then
			number3:=number3+1;
			if (number3=99999)		then	ck1<='0';	ck2<='0';	ck3<='1';	ck4<='0';	end if;
			if (number3=589999)	then	ck3<='0';	end if;
		end if;
	else
		number3:=0;	ck3<='0';
	end if;
				
	if (btn3='1')	then
		if (number4/=16000000)	then
			number4:=number4+1;
			if (number4=99999)		then	ck1<='0';	ck2<='0';	ck3<='0';	ck4<='1';	end if;
			if (number4=589999)	then	ck4<='0';	end if;
		end if;
	else
		number4:=0;	ck4<='0';
	end if;
					 
	if (p=2399) then
		p<=0; clk2<=not clk2;
	else
		p<=p+1;
	end if;
				 
	if (q=239999) then
		q<=0; clk1<=not clk1;clk3<=not clk3;
	else
		q<=q+1;
	end if;			 
end if;
end process;
			
process(clk2)
begin 
if (clk2'event and clk2='1') then
sel <= sel rol 1; 
if (sw0='0')	then				--choose the output mode
	case sel is				--segment 
			when "1110" => word_num<=count;
			when "1101" => word_num<=count2;
			when "1011" => word_num<=count3;
			when "0111" => word_num<=count4;
			when others => null;
			end case;
elsif	(sw0='1')	then
	if	(sw1='0')	then		--choose sin or cos
		if(qdrt="00" or qdrt="10") then
							
			case sel is
					when "1110" => word_num<=sin(3 downto 0);
					when "1101" => word_num<=sin(7 downto 4);
					when "1011" => word_num<=sin(11 downto 8);
					when "0111" => word_num<=sin(15 downto 12);
					when others => null;
			end case;
		else 
			case sel is
					when "1110" => word_num<=cos(3 downto 0);
					when "1101" => word_num<=cos(7 downto 4);
					when "1011" => word_num<=cos(11 downto 8);
					when "0111" => word_num<=cos(15 downto 12);
				when others => null;
			end case;
		end if;
						
	elsif	(sw1='1')	then     --choose sin or cos
		if(qdrt="00" or qdrt="10") then
						
			case sel is
					when "1110" => word_num<=cos(3 downto 0);
					when "1101" => word_num<=cos(7 downto 4);
					when "1011" => word_num<=cos(11 downto 8);
					when "0111" => word_num<=cos(15 downto 12);
					when others => null;
			end case;
		else
			case sel is
					when "1110" => word_num<=sin(3 downto 0);
					when "1101" => word_num<=sin(7 downto 4);
					when "1011" => word_num<=sin(11 downto 8);
					when "0111" => word_num<=sin(15 downto 12);
					when others => null;
			end case;
		end if;

	end if;
end if;

-- process(clk4)
-- begin 
-- if (clk4'event and clk4='1') then
-- sel <= sel rol 1; 
-- if (sw2='0')	then				--choose the output mode
	-- case sel is				--segment 
			-- when "1110" => led<=led_count;
			-- when "1101" => led<=led_count2;
			-- when "1011" => led<=led_count3;
			-- when "0111" => led<=led_count4;
			-- when others => null;
			-- end case;
-- elsif	(sw2='1')	then
						
	-- end if;
-- end if;
			
			
process(clk3)

variable x: std_logic_vector(20 downto 0):="000000000000000000000";
variable y: std_logic_vector(20 downto 0):="000000000000000000000";
variable tempx: std_logic_vector(20 downto 0):="000000000000000000000";
variable tempy: std_logic_vector(20 downto 0):="000000000000000000000";
variable temp1: std_logic_vector(20 downto 0):="000000000000000000000";
variable temp2: std_logic_vector(20 downto 0):="000000000000000000000";
variable temp: std_logic_vector(20 downto 0):="000000000000000000000";
-- variable tmpp1: std_logic_vector(20 downto 0):="000000000000000000000";
-- variable tmpp2: std_logic_vector(20 downto 0):="000000000000000000000";
variable v: std_logic_vector(20 downto 0):="000000000000000000000";
variable z: integer:=0;
variable s: integer range 0 to 1:=1;
variable i: integer range 0 to 20:=0;
begin					--use the arctan as inference
	T(0)<=1048560;
	T(1)<=619010;
	T(2)<=327068;
	T(3)<=166025;
	T(4)<=83335;
	T(5)<=41708;
	T(6)<=20859;
	T(7)<=10430;
	T(8)<=5215;
	T(9)<=2608;
	T(10)<=1304;
	T(11)<=652;
	T(12)<=326;
	T(13)<=163;
	T(14)<=81;
	T(15)<=41;
	T(16)<=20;
	T(17)<=10;
	T(18)<=5;
	T(19)<=3;
	T(20)<=1;
	if (clk3'event and clk3='1') then
		x:="100110110111011100000";
		y:="000000000000000000000";
		v:="000000000000000000000";
		z:=0;
		if count4(3)='1'	then	z:=z+32768;	end if;	--convert the std_logic_vector into the integer
		if count4(2)='1'	then	z:=z+16384;	end if;
		if count4(1)='1'	then	z:=z+8192;	end if;
		if count4(0)='1'	then	z:=z+4096;	end if;
		if count3(3)='1'	then	z:=z+2048;	end if;
		if count3(2)='1'	then	z:=z+1024;	end if;
		if count3(1)='1'	then	z:=z+512;	end if;
		if count3(0)='1'	then	z:=z+256;	end if;
		if count2(3)='1'	then	z:=z+128;	end if;
		if count2(2)='1'	then	z:=z+64;		end if;
		if count2(1)='1'	then	z:=z+32;		end if;
		if count2(0)='1'	then	z:=z+16;		end if;
		if count(3)='1'	then	z:=z+8;		end if;
		if count(2)='1'	then	z:=z+4;		end if;
		if count(1)='1'	then	z:=z+2;		end if;
		if count(0)='1'	then	z:=z+1;		end if;
			
		z:=z*32;
		--within one degree£¬use the equotion of "sinx=x"
		-- if z<32016 then
		-- sin(3 donwto 0) <= count;
		if z<32016 	then	
			sin(15 downto 12)<=count4;
			sin(11 downto 8)<=count3;
			sin(7 downto 4)<=count2;
			sin(3 downto 0)<=count;
			cos(15 downto 12)<="1111"-count4;
			cos(11 downto 8)<="1111"-count3;
			cos(7 downto 4)<="1111"-count2;
			cos(3 downto 0)<="1111"-count;
			
		elsif z>2065104	then	--if the angle is more then 89 degree£¬use the equotion of "sinx=x"
			sin(15 downto 12)<=count4;
			sin(11 downto 8)<=count3;
			sin(7 downto 4)<=count2;
			sin(3 downto 0)<=count;
			cos(15 downto 12)<="1111"-count4;
			cos(11 downto 8)<="1111"-count3;
			cos(7 downto 4)<="1111"-count2;
			cos(3 downto 0)<="1111"-count;

			
		else
			s:=1;
			-- tmpy := x-tmpp2;
			-- tmpx = y - tmpp1;
			tempx:=x-y;
			tempy:=x+y;
			x:=tempx;
			y:=tempy;
			z:=z-T(0);
						
			for i in 0 to 19 loop	--use cordic method
				if (z>0)	then	s:=1;	z:=z-T(i+1);
				else	s:=0;	z:=z+T(i+1);
				end if;
							
			temp1(20 downto 20-i):=v(20 downto 20-i);
			temp1(19-i downto 0):=x(20 downto i+1);
			temp2(20 downto 20-i):=v(20 downto 20-i);
			temp2(19-i downto 0):=y(20 downto i+1);
				
			-- temp1(20 downto 20-i):=v(20 downto 20-i);
			-- temp1(19-i downto 0):=x(20 downto i+1);
			-- temp2(20 downto 20-i):=v(20 downto 20-i);
			-- temp2(19-i downto 0):=y(20 downto i+1);	
			
			if	s=1	then
			tempx:=x-temp2;
			tempy:=temp1+y;
			elsif(s=0)	then
				tempx:=x+temp2;
				tempy:=y-temp1;
			end if;
			x:=tempx;
			y:=tempy;
		end loop;
		sin<=x(20 downto 5);
		cos<=y(20 downto 5);
		end if;
	end if;
end process;
			
case word_num is		--0~F represented by the segment
	when "0000" => tmp<="0000001";
	when "0001" => tmp<="1001111";
	when "0010" => tmp<="0010010";
	when "0011" => tmp<="0000110";
	when "0100" => tmp<="1001100";
	when "0101" => tmp<="0100100";
	when "0110" => tmp<="0100000";
	when "0111" => tmp<="0001111";
	when "1000" => tmp<="0000000";
	when "1001" => tmp<="0000100";
	when "1010" => tmp<="0001000";
	when "1011" => tmp<="1100000";
	when "1100" => tmp<="0110001";
	when "1101" => tmp<="1000010";
	when "1110" => tmp<="0110000";
	when "1111" => tmp<="0111000";
	when others => null;
end case;
         			
end if;
end process;

end Behavioral;

