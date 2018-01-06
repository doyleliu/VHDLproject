library IEEE; 
use IEEE.STD_LOGIC_1164.ALL; 
use IEEE.STD_LOGIC_ARITH.ALL; 
use IEEE.STD_LOGIC_TEXTIO.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL; 
use STD.TEXTIO.ALL;

entity mp_tb is 
end mp_tb;
architecture rtl of  mp_tb is
  component Ram_FIFO
	generic (FIFO_Depth:integer;
			 DataWidth:integer;
			 AddrSize:integer);
    port(
		Sys_Clk,Sys_Rst: in std_logic;
		Wr_en,Rd_en: in std_logic;
		WrData: in std_logic_Vector(DataWidth-1 downto 0);
		RdData: out std_logic_vector(DataWidth-1 downto 0);
		FIFO_Full,FIFO_Empty: out std_logic);
  end component;
  
  -----------declare signals for connections-----
  constant  PERIOD :    time := 50 ns;
  signal    Sys_Clk    :    std_logic := '0';
  signal    Sys_Rst  :    std_logic;
  signal    Wr_en,Rd_en    :   std_logic;
  signal 	WrData: 	std_logic_Vector(7 downto 0) ;
  signal	RdData: 	std_logic_vector(7 downto 0);
  signal    FIFO_Full      :    std_logic;
  signal    FIFO_Empty	   :	std_logic;
begin
  -----------DUT port mapping--------------------
  DUT : Ram_FIFO
      generic map(FIFO_Depth => 16,
				  DataWidth => 8,
				  AddrSize=> 4)
      port map(
        Sys_Clk    => Sys_Clk,
		Sys_Rst	   => Sys_Rst,
		Wr_en	   => Wr_en,
		Rd_en	   => Rd_en,
		WrData     => WrData,
		RdData	   => RdData,
		FIFO_Full  => FIFO_Full,
		FIFO_Empty => FIFO_Empty
      );
  -----------clock and reset generation------------
  clock_gen   : process(Sys_Clk)
  begin
    Sys_Clk  <= not Sys_Clk after PERIOD/2;
  end process;
  
  Sys_Rst <= '1',
			 '0' after PERIOD*3;
  Wr_en <= 	'0',
			'1' after PERIOD*5,
			'0' after PERIOD*15,
			'1' after PERIOD*17,
			'0' after PERIOD*25;
  Rd_en <= 	'0', 
			'1' after PERIOD*25,
			'0' after PERIOD*35,
			'1' after PERIOD*38,
			'0' after PERIOD*46;
  
  
  process (Sys_Clk,Sys_Rst)
    --declaration of input and output files
    file data_in    : text open read_mode is "stimu.txt";
    file data_out     : text open write_mode is "data_out.txt";
    --variables for one line of the input and output files---
    variable line_in  : line;
    variable line_out   : line;
    --variables for the value in one line---
    variable data_in_tmp    : std_logic_vector(7 downto 0);
    variable data_out_tmp    : std_logic_vector(7 downto 0);
  begin
    if (Sys_Rst = '1') then
		WrData <= (others=>'0');
    elsif (Sys_Clk'event and Sys_Clk = '1') then 
      if not(endfile(data_in))  then
        readline(data_in,line_in);
        read(line_in,data_in_tmp);

        WrData <= data_in_tmp;
        
        data_out_tmp := RdData;
        
        write(line_out,data_out_tmp);
        writeline(data_out,line_out);
      else
        assert false
            report "End of File!"
        severity note;
      end if;
    end if;
    --file_close(data_in);
    --file_close(stim_bi);
    --file_close(data_out);
  end process;
end rtl;
