library ieee;
use ieee.std_logic_1164.all;
----------------------------
-- COUNTER
----------------------------
ENTITY counter IS
-- a counter module from 8253 circuit have the next ports:
-- CLK:         clock           ->in
-- GATE:        gate            ->in
-- OUTPUT:      output          ->out
-- DATA:        8bit data       ->inout
-- CTRL:        2 bit control   ->in
  -- 00 means read counter
  -- 01 means load mode
  -- 10 means read lower byte of data
  -- 11 means read higher byte of data
  -- ZZ means start counting
-- COUNT:       16 bit counter  ->varible/register
  PORT
    (
      CLK:        IN      STD_LOGIC;
      GATE:       IN      STD_LOGIC;
      OUTPUT:     OUT     STD_LOGIC;
      DATA:       INOUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
      CTRL:       IN      STD_LOGIC_VECTOR(1 DOWNTO 0)
      );
END counter;
ARCHITECTURE behaviour OF counter IS
-- behaviour of counter

  --MODE 0;
  --after programming OUT->0 until counter will be 0. 
 
  SIGNAL MODE:STD_LOGIC_VECTOR(2 DOWNTO 0):="ZZZ";

  PROCEDURE mode0_count
    ( COUNTER:  IN      STD_LOGIC_VECTOR(15 DOWNTO 0);
      RET_COUNT:OUT     STD_LOGIC_VECTOR(15 DOWNTO 0)
      )IS
  BEGIN
    IF (COUNTER="0000000000000000") THEN
      OUTPUT<='1';
    ELSE 
      RET_COUNT:=COUNTER-1;
    END IF;
  END mode0_count;
  
BEGIN
  
  PROCESS(CLK,CTRL) IS
-- if ctrl=1 then counter is in programming mode. this means that will read
-- data from external bus;
    VARIABLE COUNT:STD_LOGIC_VECTOR(15 DOWNTO 0):="ZZZZZZZZZZZZZZZZ";
  BEGIN
    
    IF (CTRL="01") THEN
      MODE(0)<=DATA(0);
      MODE(1)<=DATA(1);
      MODE(2)<=DATA(2);
    ELSIF (CTRL="10") THEN
      FOR index IN 0 TO 7 LOOP
        COUNT(index):=DATA(index);
      END LOOP;
    ELSIF (CTRL="11") THEN
      FOR index IN 0 TO 7 LOOP
        COUNT(index+8):=DATA(index);
      END LOOP;
    ELSIF (CTRL="00") THEN
      --data=count;
    END IF;         
  
    IF (CLK'EVENT AND CLK='1' AND GATE='0' AND CTRL="ZZ") THEN
      OUTPUT<='0';
      CASE MODE IS
        WHEN "000"=>mode0_count(COUNT,COUNT);
        WHEN OTHERS => null;        
      END CASE ; 
    END IF;

  END PROCESS;


  
END behaviour;  


