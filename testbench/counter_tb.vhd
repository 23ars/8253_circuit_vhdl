LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY counter_tb IS
END counter_tb;

ARCHITECTURE dataflow OF counter_tb IS
  SIGNAL T_CLK:STD_LOGIC;
  SIGNAL T_GATE:STD_LOGIC;
  SIGNAL T_OUTPUT:STD_LOGIC;
  SIGNAL T_DATA:STD_LOGIC(7 DOWNTO 0);
  SIGNAL T_CTRL:STD_LOGIC(1 DOWNTO 0);
  SIGNAL T_COUNT:STD_LOGIC(15 DOWNTO 0);
  COMPONENT counter IS
    PORT
      (
        CLK:        IN      STD_LOGIC;
        GATE:       IN      STD_LOGIC;
        OUTPUT:     OUT     STD_LOGIC;
        DATA:       INOUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
        CTRL:       IN      STD_LOGIC_VECTOR(1 DOWNTO 0)
        );        

    END COMPONENT;
 BEGIN
   cnt:counter PORT MAP
     (
       CLK=>T_CLK,
       GATE=>T_GATE,
       OUTPUT=>T_OUTPUT,
       DATA=>T_DATA,
       CTRL=>T_CTRL
       );
 
