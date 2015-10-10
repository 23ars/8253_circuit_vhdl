library ieee;
use ieee.std_logic_1164.all;
----------------------------
-- Databus Buffer
----------------------------
ENTITY databus_buffer IS
-- data bus buffer have the next ports:
-- IDATA:        8 bit bus       ->inout
-- CTRL:        1 bit control   ->in
-- ODATA:       8 bit bus       ->inout
  PORT
    (
      --IDATA represent the bus lines that comes from the uC for reading and writing;
      --ODATA represents the bus lines that communicate with the internal bus;
      IDATA:    INOUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
      CTRL:     IN      BIT;
      ODATA:    INOUT   STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
  --is a 3 state bidirection 8 bit buffer.
    

END databus_buffer;
ARCHITECTURE behaviour OF databus_buffer IS
-- behaviour of xor_gate
BEGIN
  
END behaviour;  
