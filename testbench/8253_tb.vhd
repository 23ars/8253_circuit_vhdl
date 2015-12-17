LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY counter_8253_tb IS
END counter_8253_tb;


ARCHITECTURE dataflow OF counter_8253_tb IS
	SIGNAL T_D:STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL T_CS:STD_LOGIC;
	SIGNAL T_RD:STD_LOGIC;
	SIGNAL T_WR:STD_LOGIC;
	SIGNAL T_A1:STD_LOGIC;
	SIGNAL T_A0:STD_LOGIC;
	SIGNAL T_CLK0:STD_LOGIC;
	SIGNAL T_GATE0:STD_LOGIC;
	SIGNAL T_OUT0:STD_LOGIC;
	SIGNAL T_CLK1:STD_LOGIC;
	SIGNAL T_GATE1:STD_LOGIC;
	SIGNAL T_OUT1:STD_LOGIC;	
	SIGNAL T_CLK2:STD_LOGIC;
	SIGNAL T_GATE2:STD_LOGIC;
	SIGNAL T_OUT2:STD_LOGIC;
  COMPONENT circuit_8253 IS
      PORT
	(
		D:        INOUT   STD_LOGIC_VECTOR(7 DOWNTO 0);   	
	        CS:       IN      STD_LOGIC;
	        RD:       IN      STD_LOGIC;
	        WR:       IN      STD_LOGIC;
 	        A1:       IN      STD_LOGIC;
	        A0:       IN      STD_LOGIC;
 	        CLK0:     IN      STD_LOGIC;
	        GATE0:    IN      STD_LOGIC;
	        OUT0:     OUT     STD_LOGIC;
	        CLK1:     IN      STD_LOGIC;
	        GATE1:    IN      STD_LOGIC;
	        OUT1:     OUT     STD_LOGIC;
	        CLK2:     IN      STD_LOGIC;
	        GATE2:    IN      STD_LOGIC;
	        OUT2:     OUT     STD_LOGIC
	);
   END COMPONENT;

BEGIN
	counter:circuit_8253 PORT MAP
	(
		D=>T_D,
		CS=>T_CS,
		RD=>T_RD,
		WR=>T_WR,
		A1=>T_A1,
		A0=>T_A0,
		CLK0=>T_CLK0,
		GATE0=>T_GATE0,
		OUT0=>T_OUT0,
		CLK1=>T_CLK1,
		GATE1=>T_GATE1,
		OUT1=>T_OUT1,	
		CLK2=>T_CLK2,
		GATE2=>T_GATE2,
		OUT2=>T_OUT2		
	);
	PROCESS --concurrent process to generate clock
	BEGIN
	     T_CLK0<='0';
	     WAIT FOR 1 ns;
	     T_CLK0<='1';
	     WAIT FOR 1 ns;
	END PROCESS;
	
	PROCESS
	BEGIN
		T_CS<='0';
		T_RD<='1';
		T_WR<='0';
		T_GATE0<='1';


		T_A1<='1';
		T_A0<='1';--write to command register;

		T_D<="00010000";--load low nibble mode 0, counter 0
		wait for 5 ns;		
		T_A0<='0';
		T_A1<='0';
		T_D<="00001000";--low nibble 8 value
		wait for 5 ns;


		T_A1<='1';
		T_A0<='1';--write to command register;
		T_D<="00100000";--load low nibble mode 0, counter 0
		wait for 5 ns;
		T_A0<='0';
		T_A1<='0';
		T_D<="00000000";--high nibble value;
		wait for 5 ns;

		T_A1<='1';
		T_A0<='1';--write to command register;
		T_D<="00110000";--start counter
		wait for 5 ns;
		T_A0<='0';
		T_A1<='0';
		wait for 5 ns;
		
	END PROCESS;
END dataflow;
