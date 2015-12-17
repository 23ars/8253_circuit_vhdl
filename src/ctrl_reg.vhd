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

-- COMMAND FORMAT:
--7->Select counter:00,01,10,11->none
--6->
--5->command:00(read),01(load low nibble),10(load high nibble),11(01+10)
--4->
--3->work mode:000,001,010,011,100,101
--2->
--1->
--0->binary/BCD:0=binary,1=bcd
	PORT
    	(
      		CTRLW:    	IN      STD_LOGIC_VECTOR(2 downto 0);
      		DATA:     	IN     	STD_LOGIC_VECTOR(7 DOWNTO 0);
		CMD_1:	 	OUT	STD_LOGIC_VECTOR(1 DOWNTO 0);
		CMD_2:		OUT	STD_LOGIC_VECTOR(1 DOWNTO 0);
		CMD_3:		OUT	STD_LOGIC_VECTOR(1 DOWNTO 0);
		MODE:		OUT	STD_LOGIC_VECTOR(2 DOWNTO 0)
    	);	
 END ctrl_reg;
ARCHITECTURE behaviour OF ctrl_reg IS
	
BEGIN

	PROCESS(CTRLW) IS
		variable ctrl_w_cmd:std_logic_vector(2 downto 0);
		variable data_bus:std_logic_vector(7 downto 0);
		variable c_md:std_logic_vector(1 downto 0);
		variable counter:std_logic_vector(1 downto 0);
	BEGIN
		ctrl_w_cmd:=CTRLW;
		if(ctrl_w_cmd="011" )then
			data_bus:=DATA;
			MODE<=data_bus(3 DOWNTO 1);
			c_md:=data_bus(5 DOWNTO 4);
		end if;
			
		case c_md is
			when "00"=>null;
			when "01"=>counter:="01";--select operation 
			when "10"=>counter:="10";
			when "11"=>counter:="ZZ";
			when others=>null;
		end case;
		case ctrl_w_cmd is
			when "000"=>CMD_1<=counter;--send operation to counter
			when "001"=>CMD_2<=counter;
			when "010"=>CMD_3<=counter;
			when "100"=>null;
			when "101"=>null;
			when "110"=>null;
			when others=>null;
		end case;

	END PROCESS;
	
   
END behaviour;  
