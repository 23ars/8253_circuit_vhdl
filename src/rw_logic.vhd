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
      		CS:       IN      STD_LOGIC;
		CTRLD:	  OUT	  STD_LOGIC;
		CTRLW:	  OUT	  STD_LOGIC_VECTOR(2 downto 0)
    	);
    

END rw_logic;
ARCHITECTURE behaviour OF rw_logic IS
BEGIN
	PROCESS
		variable op:std_logic_vector(1 downto 0);
	BEGIN
	CTRLD<='Z';
	
	IF(CS='0') THEN
		op(0):=A0;
		op(1):=A1;
		IF(RD='1' and WR='0') THEN
			CTRLD<='0';--write
			case op is
				when "00"=>CTRLW<="000";
				when "01"=>CTRLW<="001";
				when "10"=>CTRLW<="010";
				when "11"=>CTRLW<="011";
				when others=>CTRLW<="ZZZ";
			end case;
		END IF;
		IF(RD='0' and WR='1') THEN
			CTRLD<='1';--read
			case op is
				when "00"=>CTRLW<="100";
				when "01"=>CTRLW<="101";
				when "10"=>CTRLW<="110";
				when others=>CTRLW<="ZZZ";-->stop counting
			end case;
		END IF;
	
	END IF;
	WAIT FOR 1 ns;
	END PROCESS;
END behaviour;  
