library ieee;
use ieee.std_logic_1164.all;
---------------------------
-- 8253 circuit
--
---------------------------

ENTITY circuit_8253 IS
  PORT
    (
      x:  IN      BIT;
      y:  IN      BIT;
      f:  OUT     BIT
      );
END circuit_8253;

ARCHITECTURE dataflow OF circuit_8253 IS
---------------------------
-- use xor_gate
---------------------------
  COMPONENT xor_gate IS
  GENERIC(delay:TIME:=3 ns);
  PORT(
    x:    IN      BIT;
    y:    IN      BIT;
    f:    OUT     BIT
    );
  END COMPONENT xor_gate;
  SIGNAL T_x,T_y,T_f:     BIT;
  
BEGIN
  use_xor1:xor_gate PORT MAP(
    x=>T_x,
    y=>T_y,
    f=>T_f
    
    );
  T_x<=x;
  T_y<=y;
  f<=T_f;
END ARCHITECTURE dataflow;


CONFIGURATION cfg_circuit_8253 OF circuit_8253 IS
  FOR dataflow
    FOR ALL:xor_gate USE ENTITY WORK.xor_gate(behaviour);
    END FOR;        
  END FOR;
END CONFIGURATION cfg_circuit_8253;

