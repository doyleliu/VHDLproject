LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity Ram_FIFO is
generic(
FIFO_Depth : integer :=16;
DataWidth : integer := 8;
AddrSize : integer :=  4
);
port(
Sys_Clk : in STD_LOGIC;
Sys_Rst : in STD_LOGIC;
WrData : in STD_LOGIC_VECTOR(DataWidth-1 downto 0);
Wr_en : in STD_LOGIC;
Rd_en : in STD_LOGIC;
RdData : out STD_LOGIC_VECTOR(DataWidth-1 downto 0);
FIFO_Full : out STD_LOGIC;
FIFO_Empty : out STD_LOGIC
);
end Ram_FIFO;

architecture Behavioral of Ram_FIFO is
signal Sys_Clk_r,Sys_Rst_r,Wr_en_ram,Rd_en_ram : STD_LOGIC;--the output of the FIFO connected to the ram
signal Wr_Addr_r,Rd_Addr_r : INTEGER RANGE 0 TO FIFO_Depth-1;



component FIFO is
port(
Sys_Clk : in STD_LOGIC;
Sys_Rst : in STD_LOGIC;
Wr_en : in STD_LOGIC;
Rd_en : in STD_LOGIC;
FIFO_Full : out STD_LOGIC;
FIFO_Empty : out STD_LOGIC;
Wr_en_ram : out STD_LOGIC;
Wr_Addr_r : out INTEGER RANGE 0 TO FIFO_Depth-1;
Rd_en_ram : out STD_LOGIC;
Rd_Addr_r : out INTEGER RANGE 0 TO FIFO_Depth-1
);
end component;

component RAM is
Port(
WrData : in STD_LOGIC_VECTOR(DataWidth-1 downto 0);
Sys_Clk : in STD_LOGIC;
Sys_Rst : in STD_LOGIC;
Wr_en : in STD_LOGIC;
Wr_Addr : in INTEGER RANGE 0 TO 2**AddrSize-1;
RdData : out STD_LOGIC_VECTOR(DataWidth-1 downto 0);
Rd_en : in STD_LOGIC;
Rd_Addr : in INTEGER RANGE 0 TO 2**AddrSize-1
);
end component;

begin
U1 : component FIFO port map(Sys_Clk,Sys_Rst,Wr_en,Rd_en,FIFO_Full,FIFO_Empty,Wr_en_ram,Wr_Addr_r,Rd_en_ram,Rd_Addr_r);
U2 : component RAM port map(WrData,Sys_Clk,Sys_Rst,Wr_en_ram,Wr_Addr_r,RdData,Rd_en_ram,Rd_Addr_r);

end Behavioral;

