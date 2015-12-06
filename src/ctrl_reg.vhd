library ieee;
use ieee.std_logic_1164.all;
----------------------------
-- Control Word Register
----------------------------
ENTITY ctrl_reg IS
-- Control Word Register have the next ports:
-- CTRLW:       input that come from rw_logic module    ->in
-- DATA:        8 bit data from internal bus            ->in
-- CMD:         command to counters                     ->out
	PORT
    	(
      		CTRLW:    IN      STD_LOGIC;
      		DATA:     IN      STD_LOGIC_VECTOR(7 DOWNTO 0)
    	);	
    

END ctrl_reg;
ARCHITECTURE behaviour OF ctrl_reg IS
	COMPONENT counter IS
    	PORT
      	(
        	CLK:        IN      STD_LOGIC;
        	GATE:       IN      STD_LOGIC;
        	OUTPUT:     OUT     STD_LOGIC;
        	DATA:       INOUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
        	CTRL:       IN      STD_LOGIC_VECTOR(1 DOWNTO 0)
        );        

    END COMPONENT;
	SIGNAL CMD:STD_LOGIC_VECTOR(1 DOWNTO 0);
BEGIN




	cnt0:counter port map
	(
		 CLK=>'0',
       		 GATE=>'0',
		 OUTPUT=>open,
		 DATA=>open,
		 CTRL=>CMD
	); 

	
	cnt1:counter port map
	(
		 CLK=>'0',
       		 GATE=>'0',
		 OUTPUT=>open,
		 DATA=>open,
		 CTRL=>CMD
	); 

	cnt2:counter port map
	(
		 CLK=>'0',
       		 GATE=>'0',
		 OUTPUT=>open,
		 DATA=>open,
		 CTRL=>CMD
	); 




	PROCESS
	BEGIN
		IF(CTRLW'event AND CTRLW='1') THEN
			CMD<="01";
			WAIT FOR 5 NS;
			CMD<="10";
			WAIT FOR 5 NS;
			CMD<="10";
			
			
		ELSIF(CTRLW='0') THEN
			CMD<="ZZ";
		
		END IF;
	END PROCESS;
	
   
END behaviour;  
