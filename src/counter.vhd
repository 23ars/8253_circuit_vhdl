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
-- CTRL:        1 bit control   ->in
  PORT
    (
      CLK:        IN      BIT;
      GATE:       IN      BIT;
      OUTPUT:     OUT     BIT;
      DATA:       INOUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
      CTRL:       IN      BIT
      );
END counter;
ARCHITECTURE behaviour OF counter IS
-- behaviour of counter
BEGIN

END behaviour;  
