library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_TEXTIO.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL; 

entity my_test is 
end my_test;

architecture Behavioral of my_test is
component Ram_FIFO
	generic(FIFO_Depth : integer :=16;
			DataWidth : integer := 8;
			AddrSize : integer :=  4);
    port(
		Sys_Clk,Sys_Rst: in std_logic;
		Wr_en,Rd_en: in std_logic;
		WrData: in std_logic_Vector(DataWidth-1 downto 0);
		RdData: out std_logic_vector(DataWidth-1 downto 0);
		FIFO_Full,FIFO_Empty: out std_logic);
end component;

signal    Sys_Clk    :    std_logic := '0';
signal    Sys_Rst  :    std_logic;
signal    Wr_en,Rd_en    :   std_logic;
signal 	  WrData: 	STD_LOGIC_VECTOR(7 downto 0) := (others => '0');
signal	  RdData: 	std_logic_vector(7 downto 0);
signal    FIFO_Full      :    std_logic;
signal    FIFO_Empty	   :	std_logic;
constant  PERIOD :    time := 10 ns;

begin
uut : Ram_FIFO Port map(
	Sys_Clk => Sys_Clk,
	Sys_Rst => Sys_Rst,
	Wr_en => Wr_en,
	WrData => WrData,
	Rd_en => Rd_en,
	RdData => RdData,
	FIFO_Full => FIFO_Full,
	FIFO_Empty => FIFO_Empty
);

clock_Process  : process(Sys_Clk)
begin
   Sys_Clk  <= not Sys_Clk after PERIOD/2;
end process;

Stimulation_process : process
begin
Sys_Rst <= '1';wait for 1 ns; Sys_Rst <= '0';
Wr_en <= '1';wait for 2 ns;
for i in 0 to 20 loop
	WrData <= WrData + '1';
	wait for 10 ns;
end loop;

Wr_en <= '0'; wait for 15 ns;
Rd_en <= '1'; wait for 200 ns;
Rd_en <= '0'; 
Sys_Rst<='1'; wait for 10 ns; 
Sys_Rst <= '0';

Wr_en <= '1'; --wait for 0 ns;
for i in 0 to 10 loop
	WrData <= WrData + '1';
	wait for 10 ns;
end loop;
Wr_en <= '0'; wait for 15 ns;
Rd_en <= '1'; wait for 50 ns;
Sys_Rst <= '1'; --wait for 0 ns;

wait;
end process;
end Behavioral;
