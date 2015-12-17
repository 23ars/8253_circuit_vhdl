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



	PROCEDURE mode0_count                                         --procedure for
         	                                                      --count mode 0
	(
		COUNTER:  IN      STD_LOGIC_VECTOR(15 DOWNTO 0);          --input variable
		RET_COUNT:OUT     STD_LOGIC_VECTOR(15 DOWNTO 0);          --out variable
		OUTPUT:   OUT     STD_LOGIC                               --value of
                                                                --output line
	)IS
	BEGIN
		IF (COUNTER="0000000000000000") THEN                        --if count is 0
			OUTPUT:='1';                                        --output will
                                     			                    --be 1
		ELSE
			RET_COUNT:=std_logic_vector(unsigned(COUNTER)- 1);
 
		END IF;
	END mode0_count;

	PROCEDURE mode4_count
	(
		COUNTER:	IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
		RET_COUNT:	OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
		OUTPUT:		OUT	STD_LOGIC
     	)IS
	BEGIN
		IF(COUNTER="0000000000000000") THEN
			OUTPUT:='0';
		ELSE
			RET_COUNT:=std_logic_vector(unsigned(COUNTER)- 1);
		END IF;
	END mode4_count;
	
	PROCEDURE mode5_count
	(
		COUNTER:	IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
		RET_COUNT:	OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
		OUTPUT:		OUT	STD_LOGIC
    	)IS
	BEGIN
		IF(COUNTER="0000000000000000") THEN
			OUTPUT:='0';
		ELSE
			RET_COUNT:=std_logic_vector(unsigned(COUNTER)- 1);
		END IF;
	END mode5_count;
  
BEGIN
	PROCESS(CLK) IS
		variable count:std_logic_vector(15 downto 0):="ZZZZZZZZZZZZZZZZ";
		variable mode_var:std_logic_vector(2 downto 0);
		variable out_var:std_logic;
	BEGIN
		IF(CLK'event and CLK='1') THEN
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
								mode0_count(count,count,out_var);
								OUTPUT<=out_var;
							else
								OUTPUT<='0';
							end if;
						when "100"=>
							if(GATE='1') THEN
								mode4_count(count,count,out_var);
								OUTPUT<=out_var;
							else
								OUTPUT<='1';
							end if;
						when "101"=>
							if(GATE='1') THEN
								mode5_count(count,count,out_var);
								OUTPUT<=out_var;
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


