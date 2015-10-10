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
      CTRLW:    IN      BIT;
      DATA:     IN      STD_LOGIC_VECTOR(7 DOWNTO 0);
      CMD:      OUT     BIT
    );
    

END ctrl_reg;
ARCHITECTURE behaviour OF ctrl_reg IS

BEGIN
   
END behaviour;  
