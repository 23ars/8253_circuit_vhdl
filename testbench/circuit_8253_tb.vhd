library ieee;
use ieee.std_logic_1164.all;
ENTITY circuit_8253_tb IS
END circuit_8253_tb;

ARCHITECTURE dataflow OF circuit_8253_tb IS
  SIGNAL T_x:   BIT;
  SIGNAL T_y:   BIT;
  SIGNAL T_f:   BIT;
  COMPONENT circuit_8253
    PORT
      (
        x,y:        IN      BIT;
        F:          OUT     BIT
        );
  END COMPONENT circuit_8253;
BEGIN
  circuit:circuit_8253 PORT MAP
    (
      x=>T_x,
      y=>T_y,
      F=>T_f
      );
  PROCESS
    BEGIN
       T_x<='0';
       T_y<='0';
       wait for 5 ns;
       assert(T_f='0') report "Expected 0" severity error;
       
       T_x<='0';
       T_y<='1';
       wait for 5 ns;
       assert(T_f='1') report "Expected 1" severity error;
       
       T_x<='1';
       T_y<='0';
       wait for 5 ns;
       assert(T_f='1') report "Expected 1" severity error;
       
       T_x<='1';
       T_y<='1';
       wait for 5 ns;
       assert(T_f='0') report "Expected 0" severity error;
       wait;
    END PROCESS;
      
END dataflow;

