library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
----------------------------
-- COUNTER
----------------------------
ENTITY counter IS
-- a counter module from 8253 circuit have the next ports:
-- CLK:         clock           ->in
-- GATE:        gate            ->in
-- OUTPUT:      output          ->out
-- DATA:        8bit data       ->in
-- COUNT:       16 bit counter  ->varible/register
	PORT
	(
		CLK:        IN      STD_LOGIC;
		GATE:       IN      STD_LOGIC;
		OUTPUT:     OUT     STD_LOGIC;
		DATA:       IN	    STD_LOGIC_VECTOR(7 DOWNTO 0);
		CTRL:       IN      STD_LOGIC_VECTOR(1 DOWNTO 0);
		MODE:	    IN	    STD_LOGIC_VECTOR(2 DOWNTO 0)
	);
END counter;
ARCHITECTURE behaviour OF counter IS
BEGIN
	PROCESS(CLK) IS
		variable count:std_logic_vector(15 downto 0):="ZZZZZZZZZZZZZZZZ";
		variable mode_var:std_logic_vector(2 downto 0);
	BEGIN
		IF(CLK'event and CLK='1') THEN
			mode_var:=MODE;
			case CTRL is
				when "01"=>	
					FOR index IN 0 TO 7 LOOP
						count(index):=DATA(index);
					END LOOP;	
				when "10"=>
					FOR index IN 0 TO 7 LOOP
						count(index+8):=DATA(index);
					END LOOP;
				when "ZZ"=>
					case mode_var is
						when "000"=>
							if(GATE='1') THEN
								IF (count="0000000000000000") THEN                        
									OUTPUT<='1';                                       
                                     			                    
								ELSE
									count:=std_logic_vector(unsigned(count)- 1);
 									OUTPUT<='0';
								END IF;
							else
								OUTPUT<='1';
							end if;
						when "100"=>
							if(GATE='1') THEN
								IF(count="0000000000000000") THEN
									OUTPUT<='0';
								ELSE
									count:=std_logic_vector(unsigned(count)- 1);
									OUTPUT<='1';
								END IF;
							else
								OUTPUT<='1';
							end if;
						when "101"=>
							if(GATE='1') THEN
								IF(count="0000000000000000") THEN
									OUTPUT<='0';
								ELSE
									count:=std_logic_vector(unsigned(count)- 1);
									OUTPUT<='1';
								END IF;
							else
								OUTPUT<='1';
							end if;
						when others=>null;
					end case;		
				when others=>null;
			end case;
		end if;
	END PROCESS;
END behaviour;  


