library ieee;
use ieee.std_logic_1164.all;
----------------------------------------
-- 8253 circuit
----------------------------------------

ENTITY circuit_8253 IS
----------------------------------------
-- 8253 circuit have the following ports:
-- D7-0:        7 data ports->inout
-- /CS:         chip select active on 0->in
-- /RD:         read active on 0->in
-- /WR:         write active on 0->in
-- A1 and A0:   address->in
-- CLK0:        clk0->in
-- GATE0:       gate->in
-- OUT0:        output->out
-- same for clk1,glk2
----------------------------------------
  PORT
    (
      D:        INOUT   STD_LOGIC_VECTOR(7 DOWNTO 0);   -- Used
                                                        -- std_logic_vector
                                                        -- because for some
                                                        -- values of
                                                        -- CS,RD,WR,A1 and
                                                        -- A0,data bus is in
                                                        -- the third state (ZZZZZZZZ)
      CS:       IN      BIT;
      RD:       IN      BIT;
      WR:       IN      BIT;
      A1:       IN      BIT;
      A0:       IN      BIT;
      CLK0:     IN      BIT;
      GATE0:    IN      BIT;
      OUT0:     OUT     BIT;
      CLK1:     IN      BIT;
      GATE1:    IN      BIT;
      OUT1:     OUT     BIT;
      CLK2:     IN      BIT;
      GATE2:    IN      BIT;
      OUT2:     OUT     BIT
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
  
END ARCHITECTURE dataflow;


CONFIGURATION cfg_circuit_8253 OF circuit_8253 IS
  FOR dataflow
    FOR ALL:xor_gate USE ENTITY WORK.xor_gate(behaviour);
    END FOR;        
  END FOR;
END CONFIGURATION cfg_circuit_8253;

