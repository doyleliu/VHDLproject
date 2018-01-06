----------------------------------------------------------------------------------
-- Company: 	NERV
-- Engineer: 	Asuka
-- 
-- Create Date:    16:09:40 11/24/2015 
-- Design Name: 
-- Module Name:    statemachine - Behavioral 
-- Project Name: 	jinruihokankehaku
-- Target Devices: 	EVANGELION 02
-- Tool versions: MAGI
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;


-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity statemachine is
	port
	(
		
		clk: in STD_LOGIC;
		sw: in STD_LOGIC_VECTOR(7 downto 0);
		btns: in STD_LOGIC;
		btnu: in STD_LOGIC;
		btnl: in STD_LOGIC;
		btnr: in STD_LOGIC;
		btnd: in STD_LOGIC;
		
		
		an: out STD_LOGIC_VECTOR(3 downto 0);
		seg: out STD_LOGIC_VECTOR(7 downto 0);
		led: out STD_LOGIC_VECTOR(7 downto 0)
	
	);
	
end statemachine;

architecture Behavioral of statemachine is
	type ProcessState is (s0,s1,s2,s3,s4);
	signal state:ProcessState;
	
	signal Counter: STD_LOGIC_VECTOR(16 downto 0);
	
	signal btn0,btn1,btn2,btn3,btnres: STD_LOGIC;
	signal code:STD_LOGIC_VECTOR(7 downto 0);
	signal input:STD_LOGIC_VECTOR(7 downto 0);
	signal SegNum0,SegNum1,SegNum2,SegNum3: STD_LOGIC_VECTOR(7 downto 0):="11111111";
    
	
	signal counter0,counter1,counter2,counter3,counter_rst:integer range 0 to 500000;
	
begin
	process(clk)
	begin
		if rising_edge(clk) then
			Counter <= Counter + 1;	---------:= <=	
		end if;
	end process;
	
	process(clk, sw(7 downto 0))
	begin
		if rising_edge(clk) then
			code(7 downto 0) <= sw(7 downto 0);
		end if;
	end process;
	
--异步时钟 四个button 0000---------------------------------------------------	

	process(clk,btnr)
	begin
		if rising_edge(clk) then
			if btnr = '1' then
				if counter0 = 500000 then
					counter0 <= counter0;
				else
					counter0 <= counter0 + 1;
				end if;
				if counter0 = 499999 then
					btn0 <= '1';
				else
					btn0 <= '0';
				end if;
			else
				counter0 <= 0;
			end if;
		end if;
	end process;
	
	process(clk,btns)
	begin
		if rising_edge(clk) then
			if btns = '1' then
				if counter1 = 500000 then
					counter1 <= counter1;
				else
					counter1 <= counter1 + 1;
				end if;
				if counter1 = 499999 then
					btn1 <= '1';
				else
					btn1 <= '0';
				end if;
			else
				counter1 <= 0;
			end if;
		end if;
	end process;
	
	process(clk,btnl)
	begin
		if rising_edge(clk) then
			if btnl = '1' then
				if counter2 = 500000 then
					counter2 <= counter2;
				else
					counter2 <= counter2 + 1;
				end if;
				if counter2 = 499999 then
					btn2 <= '1';
				else
					btn2 <= '0';
				end if;
			else
				counter2 <= 0;
			end if;
		end if;
	end process;
	
	process(clk,btnu)
	begin
		if rising_edge(clk) then
			if btnu = '1' then
				if counter3 = 500000 then
					counter3 <= counter3;
				else
					counter3 <= counter3 + 1;
				end if;
				if counter3 = 499999 then
					btn3 <= '1';
				else
					btn3 <= '0';
				end if;
			else
				counter3 <= 0;
			end if;
		end if;
	end process;
	
	
	process(clk,btnd)
	begin
		if rising_edge(clk) then
			if btnd = '1' then
				if counter_rst = 500000 then
					counter_rst <= counter_rst;
				else
					counter_rst <= counter_rst + 1;
				end if;
				if counter_rst = 499999 then
					btnres <= '1';
				else
					btnres <= '0';
				end if;
			else
				counter_rst <= 0;
			end if;
		end if;
	end process;
--异步时钟 5个button 11111---------------------------------------------------	
----四个数码管轮流显示 0000-----------------------------------------------------
	process(Counter(16 downto 15))
	begin
		case (Counter(16 downto 15)) is
			when "00" =>
				an <= "1110";
				seg <= SegNum3(7 downto 0);
			when "01" =>
				an <= "1101";
				seg <= SegNum2(7 downto 0);
			when "10" =>
				an <= "1011";
				seg <= SegNum1(7 downto 0);
			when "11" =>
				an <= "0111";
				seg <= SegNum0(7 downto 0);
			when others =>
				an <= "1111";
		end case;
	end process;
----四个数码管轮流显示 1111------------------------------------是不是需要四个segnum！！！-----------------	
	
	process(clk,state,btnres)
	begin
	   if btnres = '1' then
				state <= s0;
				input(7 downto 0) <= "00000000";
				SegNum0(7 downto 0) <= "11111111";
				SegNum1(7 downto 0) <= "11111111";
				SegNum2(7 downto 0) <= "11111111";
				SegNum3(7 downto 0) <= "11111111";
		end if;
		
		if rising_edge(clk) then
			case state is
				when s0 =>
					if btn0 = '1' then
						state <= s1;
						input(7 downto 6) <= "00";
						SegNum0(7 downto 0) <= "00000011";
					elsif btn1 = '1' then
						state <= s1;
						input(7 downto 6) <= "01";
						SegNum0(7 downto 0) <= "10011111";
					elsif btn2 = '1' then
						state <= s1;
						input(7 downto 6) <= "10";
						SegNum0(7 downto 0) <= "00100101";	
					elsif btn3 = '1' then
						state <= s1;
						input(7 downto 6) <= "11";
						SegNum0(7 downto 0) <= "00001101";	
						
					
					end if;
				when s1 =>
					if btn0 = '1' then
						state <= s2;
						input(5 downto 4) <= "00";
						SegNum1(7 downto 0) <= "00000011";
					elsif btn1 = '1' then
						state <= s2;
						input(5 downto 4) <= "01";
						SegNum1(7 downto 0) <= "10011111";
					elsif btn2 = '1' then
						state <= s2;
						input(5 downto 4) <= "10";
						SegNum1(7 downto 0) <= "00100101";	
					elsif btn3 = '1' then
						state <= s2;
						input(5 downto 4) <= "11";
						SegNum1(7 downto 0) <= "00001101";	
					
					end if;
				when s2 =>
					if btn0 = '1' then
						state <= s3;
						input(3 downto 2) <= "00";
						SegNum2(7 downto 0) <= "00000011";
					elsif btn1 = '1' then
						state <= s3;
						input(3 downto 2) <= "01";
						SegNum2(7 downto 0) <= "10011111";
					elsif btn2 = '1' then
						state <= s3;
						input(3 downto 2) <= "10";
						SegNum2(7 downto 0) <= "00100101";	
					elsif btn3 = '1' then
						state <= s3;
						input(3 downto 2) <= "11";
						SegNum2(7 downto 0) <= "00001101";	
						
					
					end if;
				when s3 =>
					if btn0 = '1' then
						state <= s4;
						input(1 downto 0) <= "00";
						SegNum3(7 downto 0) <= "00000011";
					elsif btn1 = '1' then
						state <= s4;
						input(1 downto 0) <= "01";
						SegNum3(7 downto 0) <= "10011111";
					elsif btn2 = '1' then
						state <= s4;
						input(1 downto 0) <= "10";
						SegNum3(7 downto 0) <= "00100101";	
					elsif btn3 = '1' then
						state <= s4;
						input(1 downto 0) <= "11";
						SegNum3(7 downto 0) <= "00001101";	

					end if;
				when s4=>
				   state <= s0;
				   
			end case;
		end if;
	end process;
	

		
	
	process(clk,btnres)
	begin
	   
		if rising_edge(clk) then
		   if btnres='1' then 
				led(7 downto 0) <= "00000000";
			end if;
		
			if state = s4 then
				if (
					input(7 downto 0) = code(7 downto 0) 
					
					)
				then
					led(0) <= '1';
					led(7) <= '0';
				else
					led(0) <= '0';
					--led(1) <= '1';
					led(7) <= '1';
				end if;
			
			end if;
		
		end if;
	end process;

end Behavioral;