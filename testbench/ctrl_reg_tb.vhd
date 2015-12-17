library ieee;
use ieee.std_logic_1164.all;

entity ctrl_reg_tb is

end entity;


architecture testbench of ctrl_reg_tb is
	component ctrl_reg
	PORT
    	(
      		CTRLW:    	IN      STD_LOGIC_VECTOR(2 downto 0);
      		DATA:     	IN     	STD_LOGIC_VECTOR(7 DOWNTO 0);
		CMD_1:	 	OUT	STD_LOGIC_VECTOR(1 DOWNTO 0);
		CMD_2:		OUT	STD_LOGIC_VECTOR(1 DOWNTO 0);
		CMD_3:		OUT	STD_LOGIC_VECTOR(1 DOWNTO 0);
		MODE:		OUT	STD_LOGIC_VECTOR(2 DOWNTO 0)
    	);	
	end component;
	signal t_ctrlw:std_logic_vector(2 downto 0);
	signal t_data: std_logic_vector(7 downto 0);
	signal t_cmd_1: std_logic_vector(1 downto 0);
	signal t_cmd_2: std_logic_vector(1 downto 0);
	signal t_cmd_3: std_logic_vector(1 downto 0);
	signal t_mode:std_logic_vector(2 downto 0);
begin
	control:ctrl_reg port map
	(
		CTRLW=>t_ctrlw,
		DATA=>t_data,
		CMD_1=>t_cmd_1,
		CMD_2=>t_cmd_2,
		CMD_3=>t_cmd_3,
		MODE=>t_mode
	);
	process is
	begin
		t_ctrlw<="011";
		t_data<="00010000";--load low nibble mode 0, counter 0
		
		wait for 5 ns;
		assert(t_mode="000") report "Mode is not 000" severity warning;
		t_ctrlw<="000";

		wait for 5 ns;
		assert(t_cmd_1="01") report "CMD_1 is not 000" severity warning;
	end process;

end architecture;