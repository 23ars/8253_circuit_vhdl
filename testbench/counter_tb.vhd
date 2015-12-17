LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY counter_tb IS
END counter_tb;

ARCHITECTURE dataflow OF counter_tb IS
	SIGNAL T_CLK:STD_LOGIC;
	SIGNAL T_GATE:STD_LOGIC;
	SIGNAL T_OUTPUT:STD_LOGIC;
	SIGNAL T_DATA:STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL T_CTRL:STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL T_MODE:STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL T_COUNT:STD_LOGIC_VECTOR(15 DOWNTO 0);
	COMPONENT counter IS
		PORT
		(
			CLK:        IN      STD_LOGIC;
			GATE:       IN      STD_LOGIC;
			OUTPUT:     OUT     STD_LOGIC;
			DATA:       IN	    STD_LOGIC_VECTOR(7 DOWNTO 0);
			CTRL:       IN      STD_LOGIC_VECTOR(1 DOWNTO 0);
			MODE:	    IN	    STD_LOGIC_VECTOR(2 DOWNTO 0)
		);       

	END COMPONENT;
BEGIN
	cnt:counter PORT MAP
	(
		CLK=>T_CLK,
		GATE=>T_GATE,
		OUTPUT=>T_OUTPUT,
		DATA=>T_DATA,
		CTRL=>T_CTRL,
		MODE=>T_MODE
	);
	PROCESS --concurrent process to generate clock
	BEGIN
		T_CLK<='0';
		WAIT FOR 5 ns;
		T_CLK<='1';
		WAIT FOR 5 ns;
	END PROCESS;
	PROCESS
	BEGIN
		T_GATE<='1';
		T_MODE<="000";
		T_CTRL<="01";
		T_DATA<="00001000";--low nibble 8
		wait for 5 ns;
		T_CTRL<="10";
		T_DATA<="00000000";--high nibble
		wait for 5 ns;
		T_CTRL<="ZZ";
		wait for 10 ns;

	END PROCESS;
END dataflow;
