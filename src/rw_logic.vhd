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
  PORT
    (
      RD:       IN      BIT;
      WR:       IN      BIT;
      A0:       IN      BIT;
      A1:       IN      BIT;
      CS:       IN      BIT;
      CTRLW:    OUT     BIT;
      CTRLD:    OUT     BIT
    );
    

END rw_logic;
ARCHITECTURE behaviour OF rw_logic IS

BEGIN
   
END behaviour;  
