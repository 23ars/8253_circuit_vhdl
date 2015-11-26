LIBRARY ieee;
USE ieee.std_logic_1164.all;
ENTITY databus_buffer_tb IS
END databus_buffer_tb;


ARCHITECTURE dataflow OF databus_buffer_tb IS
  SIGNAL T_Idata:STD_LOGIC_VECTOR(7 DOWNTO 0):="00000000";
  SIGNAL T_Odata:STD_LOGIC_VECTOR(7 DOWNTO 0):="00000000";
  SIGNAL T_Ctrl:STD_LOGIC:='0';
  COMPONENT databus_buffer IS
      PORT
         (
           --IDATA represent the bus lines that comes from the uC for reading and writing;
           --ODATA represents the bus lines that communicate with the internal bus;
           IDATA:    INOUT   STD_LOGIC_VECTOR(7 DOWNTO 0);
           CTRL:     IN      STD_LOGIC;
           ODATA:    INOUT   STD_LOGIC_VECTOR(7 DOWNTO 0)
     );
   END COMPONENT;

BEGIN
  databuffer:databus_buffer PORT MAP
    (
      IDATA=>T_Idata,
      CTRL=>T_Ctrl,
      ODATA=>T_Odata
      );
  PROCESS
  BEGIN
    T_Idata<="00000000";
    T_Odata<="00000000";
    T_Ctrl<='0';

    T_Idata<="00001111";
    T_Ctrl<='0';
    WAIT FOR 5 ns;
    assert(T_Odata="00001111") REPORT "Expected 00001111" SEVERITY error;
    
    T_Odata<="11110000";
    T_Ctrl<='1';
    WAIT FOR 5 ns;
    assert(T_Idata="11110000") REPORT "Expected 11110000" SEVERITY error;
    
    T_IData<="00000000";
    T_OData<="00000000";    
    T_Ctrl<='Z';
    WAIT FOR 5 ns;
    assert(T_Idata="ZZZZZZZZ") REPORT "Expected Z FOR T_Idata" SEVERITY error;
    assert(T_Odata="ZZZZZZZZ") REPORT "Expected Z FOR T_Odata" SEVERITY error;
    wait;
  END PROCESS;
END dataflow;
