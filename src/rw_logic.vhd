library ieee;
use ieee.std_logic_1164.all;
----------------------------
-- Read Write Control Logic Module
----------------------------
ENTITY rw_logic IS
-- Read Write control logic has the next ports
-- /RD:         read,active on 0        ->in
-- /WR:         write, active on 0      ->in
-- A0:          A0, active on 1         ->in
-- A1:          A1, active on 1         ->in
-- /CS:         chip select active on 0 ->in
-- CTRLW:       ctrl module             ->out
-- CTRLD:       ctrl data bus buffer    ->out

--/CS	/RD	/WR	A1	A0	Opera?ia
--0	1	0	0	0	Scriere în contorul 0
--0	1	0	0	1	Scriere în contorul 1
--0	1	0	1	0	Scriere în contorul 2
--0	1	0	1	1	Scriere în registrul cuvântului de comand?
--0	0	1	0	0	Citire din contorul 0
--0	0	1	0	1	Citire din contorul 1
--0 	0 	1 	1 	0 	Citire din contorul 2
	PORT
	(
		RD:       IN      STD_LOGIC;
      		WR:       IN      STD_LOGIC;
      		A0:       IN      STD_LOGIC;
      		A1:       IN      STD_LOGIC;
      		CS:       IN      STD_LOGIC
    	);
    

END rw_logic;
ARCHITECTURE behaviour OF rw_logic IS
	SIGNAL CTRLW:STD_LOGIC:='Z';
	SIGNAL CTRLD:STD_LOGIC:='Z';
	COMPONENT databus_buffer IS
	PORT
	(

      		IDATA:    INOUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
      		CTRL:     IN      STD_LOGIC;
      		ODATA:    INOUT   STD_LOGIC_VECTOR(7 DOWNTO 0)
    	);
	END COMPONENT;
	COMPONENT ctrl_reg IS
	PORT
    	(
      		CTRLW:    IN      STD_LOGIC;
      		DATA:     IN      STD_LOGIC_VECTOR(7 DOWNTO 0)
    	);	
	END COMPONENT;
	
BEGIN
	bus_buffer:databus_buffer port map
	(
		IDATA=>open,
		ODATA=>open,
		CTRL=>CTRLD
	);

	control_reg:ctrl_reg port map
	(
		 
		 DATA=>"00000000",
		 CTRLW=>CTRLW
	); 

   	PROCESS(CS,A0,A1)
	BEGIN
	IF(CS='0' AND CS'event) THEN		--only if CS=0
		--check if is read or write!
		IF(WR='0') THEN			--if is a write event
			CTRLD<='0';
			CTRLW<='1';
		ELSIF(RD='0') THEN
			CTRLD<='1';
			CTRLW<='0';
		ELSE				--nor read or write but CS is active
			CTRLD<='Z';
		END IF;		

		
	END IF;

	END PROCESS;
END behaviour;  
