library ieee;
use ieee.std_logic_1164.all;

entity rw_logic_tb is

end entity;


architecture testbench of rw_logic_tb is
	component rw_logic
	PORT
	(
		RD:       IN      STD_LOGIC;
      		WR:       IN      STD_LOGIC;
      		A0:       IN      STD_LOGIC;
      		A1:       IN      STD_LOGIC;
      		CS:       IN      STD_LOGIC;
		CTRLD:	  OUT	  STD_LOGIC;
		CTRLW:	  OUT	  STD_LOGIC_VECTOR(2 downto 0)
    	);	
	end component;
	signal t_rd:std_logic;
	signal t_wr: std_logic;
	signal t_a0: std_logic;
	signal t_a1: std_logic;
	signal t_cs: std_logic;
	signal t_ctrld: std_logic;
	signal t_ctrlw:std_logic_vector(2 downto 0);
begin
	control:rw_logic port map
	(
		RD=>t_rd,
		WR=>t_wr,
		A0=>t_a0,
		A1=>t_a1,
		CS=>t_cs,
		CTRLD=>t_ctrld,
		CTRLW=>t_ctrlw
	);
	process is
	begin
		t_cs<='0';
		t_rd<='1';
		t_wr<='0';
		t_a0<='0';
		t_a1<='0';
		
		wait for 5 ns;
		assert(t_ctrld='0') report "CTRLD is not 0; Write was not selected" severity warning;
		assert(t_ctrlw="000") report "CTRLW is not 000 so write to counter 0 was not selected" severity warning;
	end process;

end architecture;
