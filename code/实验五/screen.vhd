library ieee;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity screen is
port(
	clk: in std_logic;
	btn: in std_logic_vector(4 downto 0);
	OutRed: out std_logic_vector(2 downto 0);
	OutGreen: out std_logic_vector(2 downto 0);
	OutBlue: out std_logic_vector(1 downto 0);
	an:out std_logic_vector(3 downto 0);
	seg:out std_logic_vector(6 downto 0);
	HSYNC: out std_logic;
	VSYNC: out std_logic);
end screen;

architecture Behavioral of screen is

	 signal segNum: std_logic_vector(3 downto 0):="1111";--the choice of the segment 
	 signal clk_divider : std_logic;
	 
	 signal pulse : std_logic;
	 signal bstate: std_logic:= '0';--judge whether to stop
	 signal Hclk: std_logic := '1'; --HS signal
	 signal Vclk: std_logic := '1'; --VS siganl
	 signal cycle: std_logic := '1'; 
	 signal H_sync: std_logic := '1'; 
	 signal V_sync: std_logic := '1'; 
	 signal Vdata_En: std_logic :='0'; --enable the data;

	 signal dout: std_logic_vector(7 downto 0);
	 signal RO: std_logic_vector(2 downto 0):="000";
	 signal GO: std_logic_vector(2 downto 0):="000";
	 signal BO: std_logic_vector(1 downto 0):="00";
	 signal flag: std_logic_vector(4 downto 0):="00000";--judge the input key number;
	 signal bstop: std_logic;
	 
	 signal col: std_logic_vector(9 downto 0):="0000000000"; --The current tmpx
	 signal row: std_logic_vector(8 downto 0):="000000000"; --The current tmpy
	 signal coord_x: std_logic_vector(6 downto 0):="0000000"; --The point in x side
	 signal coord_y: std_logic_vector(5 downto 0):="000000"; --The point in y side
	 signal init_x: std_logic_vector(9 downto 0):="0001000000"; -- initial tmpx
	 signal init_y: std_logic_vector(8 downto 0):="010101001"; --initial tmpy
     signal init_y2: std_logic_vector(8 downto 0):="010101001";--initial second tmpy of the point
	 signal init_x2: std_logic_vector(9 downto 0):="0001000000"; -- initial second tmpx of the point
	 
	component transfer
	port(clk: in std_logic;
		 coord_x: in std_logic_vector(6 downto 0); --0~95
		 coord_y: in std_logic_vector(5 downto 0); --0~53
		 color: out std_logic_vector(7 downto 0));
	end component;

	component debounce
	port(clk: in std_logic;
		 btn: in std_logic_vector(4 downto 0); 
		 stop : out std_logic;
		 pulse : out std_logic;
		 flag: out std_logic_vector(4 downto 0));
	end component;

	component segment
	port( number:in std_logic_vector(3 downto 0);
			an:out std_logic_vector(3 downto 0);
			seg:out std_logic_vector(6 downto 0));
	end component;

	component freq_divide
	port(clk: in std_logic;
		 Hclk: out std_logic; 
		 Vclk: out std_logic;
		 cycle: out std_logic;
		 oclk: out std_logic);
	end component;
	  
	Begin
	u1:transfer port map(Hclk,coord_X,coord_y,dout);
	u2:debounce port map(clk_divider,btn,bstop,pulse,flag);
	u3:freq_divide port map(clk,Hclk,Vclk,cycle,clk_divider);
	u4:segment port map(segNum,an,seg);

--The output signal
	HSYNC<=H_sync; VSYNC<=V_sync; OutRed<=RO; OutGreen<=GO; OutBlue<=BO;



--if press the key and then change the state of the bstate	
process(pulse)
begin
if(pulse'event and pulse = '1') then
	bstate <= not bstate;
end if;
end process;

---------------drive VGA------------

process(Vclk)
  variable count: integer range 0 to 521:=0;
	begin

	if Vclk'event and Vclk='1' then  
		if count=520 then
			count:=0;
		else
		   if count=0 then V_sync<='0'; end if;
			if count=2 then V_sync<='1'; end if;
			if count=31 then Vdata_En<='1'; end if;
			if count=511 then Vdata_En<='0'; end if;
			count:=count+1;
		end if;
	end if;
	end process;

process(Hclk, Vdata_En)
    variable count: integer range 0 to 800:=0;
	 variable count2: integer range 0 to 800:=0;
	 variable x: std_logic_vector(9 downto 0);
	 variable y: std_logic_vector(8 downto 0);
	 begin
	     if Hclk'event and Hclk='1' then
		      if count2=0 then H_sync<='0';
		      else if count2=96 then H_sync<='1'; end if; end if;
		      if count2=799 then count2:=0;
				else count2:=count2+1;
				end if;
		      if Vdata_En='0' then count:=0;
				else
				    if count=799 then count:=0;
					 if row=479 then row<=(others => '0');
                else row<=row+1;		
		          end if;
					 else
						  if count>=144 and count<784 then
						      if col=639 then col<=(others => '0');
                        else col<=col+1;		
		                  end if;
--					if(flag(2)= '0') then
--						if(row>=init_y and col > init_x) then		
								if (flag(2)='0'  and flag(0)='0') then --judge whether picture by its modes and flags
									if row>=init_y and row<=init_y+53 and col>=init_x and col<=init_x+95 then
									x:=col-init_x;
									y:=row-init_y;
									coord_x<=x(6 downto 0);
									coord_y<=y(5 downto 0);
									RO<=dout(7 downto 5);
									GO<=dout(4 downto 2);
									BO<=dout(1 downto 0);
									else
									RO<="000";
									GO<="000";
									BO<="00";
									end if;
-- two pic divided and choose the divided boundry;								
								elsif(flag ="00001") then
									if row>=init_y and row<=init_y+53 and col>=init_x and col<=init_x+47 then
									x:=col-init_x;
									y:=row-init_y;
									coord_x<=x(6 downto 0);
									coord_y<=y(5 downto 0);
									RO<=dout(7 downto 5);
									GO<=dout(4 downto 2);
									BO<=dout(1 downto 0);
									--set the boundry by using another symbol init_y2;
									--we change the second part of picture by changing the value of init_y2
									elsif row>=init_y2 and row<=init_y2+53 and col>=init_x+48 and col<=init_x+95 then
									x:=col-init_x;
									y:=row-init_y2;
									coord_x<=x(6 downto 0);
									coord_y<=y(5 downto 0);
									RO<=dout(7 downto 5);
									GO<=dout(4 downto 2);
									BO<=dout(1 downto 0);
									else
									RO<="000";
									GO<="000";
									BO<="00";
									end if;
-- the picture divided into four pieces and set the boundry				
									
								else--four parts using the method in the above
								   if ((col>=init_x and col<=init_x+23) or (col>=init_x+48 and col<=init_x+71)) 
									and row>=init_y and row<=init_y+53 then
									x:=col-init_x;
									y:=row-init_y;
									coord_x<=x(6 downto 0);
									coord_y<=y(5 downto 0);
									RO<=dout(7 downto 5);
									GO<=dout(4 downto 2);
									BO<=dout(1 downto 0);
									elsif ((col>=init_x+24 and col<=init_x+47) or (col>=init_x+72 and col<=init_x+95))
      							and row>=init_y2 and row<=init_y2+53 then
									x:=col-init_x;
									y:=row-init_y2;
								   coord_x<=x(6 downto 0);
									coord_y<=y(5 downto 0);
									RO<=dout(7 downto 5);
									GO<=dout(4 downto 2);
									BO<=dout(1 downto 0);							
									else
									RO<="000";
									GO<="000";
									BO<="00";
									end if;
								end if;
						  end if;
			           count:=count+1;
		          end if;
				end if;
			end if;
	end process;

process(cycle)
	-- variable stop:std_logic:='0';
    variable dir: std_logic:='0';--the direction of the picture
	variable dir2: std_logic:='1';
	variable dir3: std_logic := '0';
	variable x: std_logic_vector(9 downto 0); 
	variable y: std_logic_vector(8 downto 0);
	variable cnt: integer range 0 to 500:=0;
	begin
	if rising_edge(cycle) then
	   case flag is
		    -- when "00001" => cnt:=0; segNum<="0000";
			
		--divide the picture into two parts;	
			when "00001" =>
				cnt :=0;
				segNum <= "0000";
				init_y2<=init_y;
				--if the picture arrive at the boundry of x;
				if init_x="1000100000" then dir:='1';
				else if init_x="0000000000" then dir:='0'; end if;
				end if;
				--if the picture arrive at the boundry of y;
				if init_y="110101001"  then dir2:='1';
				else if init_y="000000000" then dir2:='0'; end if;
				end if;
				--the second part of the picture and its boundry;
				if init_y2="110101001"  then dir3:='1';
				else if init_y2="000000000" then dir3:='0'; end if;
				end if;
				
				--set the direction by its initial boundry
				if dir='1' then init_x<=init_x-1;
				else init_x<=init_x+1;
				end if;
				if dir2='1' then init_y<=init_y-1;
				else init_y<=init_y+1;			
				end if;
				if dir3='1' then init_y2<= init_y2-1;
				else init_y2<=init_y2+1;			
				end if;
				
				-- if init_y2<="000000010" then init_y2<="111011111";
				-- elsif init_y2<="000000001" then init_y2<="111011110";
				-- elsif init_y2<="000000000" then init_y2<="111011101";
				-- else init_y2<=init_y2-3;
				-- end if;
				
			 ---Bouncing back the picture			
			when "00010" =>
			   -- segNum<="0001";
				-- cnt:=0;
				-- if(bstop = '0') then segNum<="0000";cnt:=0;
				if(bstate = '0') then segNum<="0000";cnt:=0;--judging whether stop or not;
				else
					segNum<="0001";cnt:=0;
					if init_x="1000100000" then dir:='1';
					else if init_x="0000000000" then dir:='0'; end if;
					end if;
					if init_y="110101001"  then dir2:='1';
					else if init_y="000000000" then dir2:='0'; end if;
					end if;
					if dir='1' then init_x<=init_x-1;
					else init_x<=init_x+1; 
					end if;
					if dir2='1' then init_y<=init_y-1;
					else init_y<=init_y+1;			
					end if;
				end if;
			 --the picture can travel access the boundry
			 when "01000" =>
			   cnt:=0;
				segNum<="0010";
				if init_x="1000100000" then init_x<=(others=>'0');
					else init_x<=init_x+1; 
				end if;
				if init_y="110101001" then init_y<=(others=>'0');
					else init_y<=init_y+1; 
				end if;
			 --the picture divided into four parts;
			 when "00100" => 
				segNum<="0011";
					  cnt:=0;
					  init_y2<=init_y;
				     if init_y="111011101" then init_y<=(others=>'0');
					  elsif init_y="111011110" then init_y<="000000001";
					  elsif init_y="111011111" then init_y<="000000010";
					  else init_y<=init_y+3;
				     end if;
					  if init_y2<="000000010" then init_y2<="111011111";
					  elsif init_y2<="000000001" then init_y2<="111011110";
					  elsif init_y2<="000000000" then init_y2<="111011101";
					  else init_y2<=init_y2-3;
					  end if;

			 --Reset all the function and arrange the picture into the inital place
			 when	"10000" =>
				segNum<="1111";
				cnt:=0;
				dir:='0';
				dir2:='1';
				--bstop<='1';
				-- init_x<=(others=>'0');
				-- init_y<=(others=>'0');
				init_x<="0001000000";
				init_y<="010101001";
				init_y2<="010101001";
				dir2 := '1';
				dir3 := '0';
			
			-- when "00001" =>
			-- segNum <= "0000";
			-- cnt := 0;
			

			
			when others => null;
		end case;
	end if;
	end process;

end Behavioral;
		
		
		
