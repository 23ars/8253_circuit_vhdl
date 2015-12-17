library ieee;
use ieee.std_logic_1164.all;
----------------------------------------
-- 8253 circuit
----------------------------------------

ENTITY circuit_8253 IS
----------------------------------------
-- 8253 circuit have the following ports:
-- D7-0:        7 data ports->inout
-- /CS:         chip select active on 0->in
-- /RD:         read active on 0->in
-- /WR:         write active on 0->in
-- A1 and A0:   address->in
-- CLK0:        clk0->in
-- GATE0:       gate->in
-- OUT0:        output->out
-- same for clk1,glk2
----------------------------------------
  PORT
    (
      D:        INOUT   STD_LOGIC_VECTOR(7 DOWNTO 0);   -- Used
                                                        -- std_logic_vector
                                                        -- because for some
                                                        -- values of
                                                        -- CS,RD,WR,A1 and
                                                        -- A0,data bus is in
                                                        -- the third state (ZZZZZZZZ)
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
END circuit_8253;

ARCHITECTURE dataflow OF circuit_8253 IS
	SIGNAL CTRLD:STD_LOGIC;
	SIGNAL CTRLW:STD_LOGIC_VECTOR(2 downto 0);
	SIGNAL O_D:STD_LOGIC_VECTOR(7 DOWNTO 0);
	SIGNAL CMD1:STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL CMD2:STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL CMD3:STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL C_MODE:STD_LOGIC_VECTOR(2 DOWNTO 0);
	COMPONENT databus_buffer IS
	PORT
	(
		IDATA:    INOUT   STD_LOGIC_VECTOR(7 DOWNTO 0):="ZZZZZZZZ";
		CTRL:     IN      STD_LOGIC;
		ODATA:    INOUT   STD_LOGIC_VECTOR(7 DOWNTO 0):="ZZZZZZZZ"
	);
	END COMPONENT;

	COMPONENT rw_logic IS
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

	END COMPONENT;
	
	COMPONENT ctrl_reg
	PORT
    	(
      		CTRLW:    	IN      STD_LOGIC_VECTOR(2 downto 0);
      		DATA:     	IN     	STD_LOGIC_VECTOR(7 DOWNTO 0);
		CMD_1:	 	OUT	STD_LOGIC_VECTOR(1 DOWNTO 0);
		CMD_2:		OUT	STD_LOGIC_VECTOR(1 DOWNTO 0);
		CMD_3:		OUT	STD_LOGIC_VECTOR(1 DOWNTO 0);
		MODE:		OUT	STD_LOGIC_VECTOR(2 DOWNTO 0)
    	);	
	END COMPONENT;

	COMPONENT counter
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
	databuffer:databus_buffer PORT MAP
    	(
		IDATA=>D,
		CTRL=>CTRLD,
		ODATA=>O_D
	);
	read_and_write_logic_unit:rw_logic PORT MAP
	(
		RD=>RD,
		WR=>WR,
		A0=>A0,
		A1=>A1,
		CS=>CS,
		CTRLD=>CTRLD,
		CTRLW=>CTRLW
	);
	control:ctrl_reg PORT MAP
	(
		CTRLW=>CTRLW,
		DATA=>O_D,
		CMD_1=>CMD1,
		CMD_2=>CMD2,
		CMD_3=>CMD3,
		MODE=>C_MODE
	);
	counter0:counter PORT MAP
	(
		CLK=>CLK0,
		GATE=>GATE0,
		OUTPUT=>OUT0,
		DATA=>O_D,
		CTRL=>CMD1,
		MODE=>C_MODE
	);
	counter1:counter PORT MAP
	(
		CLK=>CLK1,
		GATE=>GATE1,
		OUTPUT=>OUT1,
		DATA=>O_D,
		CTRL=>CMD2,
		MODE=>C_MODE
	);
	counter2:counter PORT MAP
	(
		CLK=>CLK2,
		GATE=>GATE2,
		OUTPUT=>OUT2,
		DATA=>O_D,
		CTRL=>CMD3,
		MODE=>C_MODE
	);
	
END ARCHITECTURE dataflow;



