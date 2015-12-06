library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
----------------------------------------
-- 8253 circuit
----------------------------------------


ENTITY counter_8253 IS
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

-- COMMAND FORMAT:
--7->Select counter:00,01,10,11->none
--6->
--5->command:00(read),01(load low nibble),10(load high nibble),11(01+10)
--4->
--3->work mode:000,001,010,011,100,101
--2->
--1->
--0->binary/BCD:0=binary,1=bcd

----------------------------------------
	PORT
	(
		D:        IN   STD_LOGIC_VECTOR(7 DOWNTO 0);   	
	        CS:       IN      STD_LOGIC;
	        RD:       IN      STD_LOGIC;
	        WR:       IN      STD_LOGIC;
 	        A1:       IN      STD_LOGIC;
	        A0:       IN      STD_LOGIC;
 	        CLK0:     IN      STD_LOGIC;
	        GATE0:    IN      STD_LOGIC;
	        OUT0:     OUT     STD_LOGIC;
	        CLK1:     IN      STD_LOGIC;
	        GATE1:    IN      STD_LOGIC;
	        OUT1:     OUT     STD_LOGIC;
	        CLK2:     IN      STD_LOGIC;
	        GATE2:    IN      STD_LOGIC;
	        OUT2:     OUT     STD_LOGIC
	);
END counter_8253;

ARCHITECTURE dataflow OF counter_8253 IS
--	SIGNAL DATA_BUFFER:STD_LOGIC_VECTOR(7 DOWNTO 0);
--0=in programming;1=done programming,2=counting others=none
	TYPE E_ChipState IS(PROGRAMMING,LOADING,COUNTING,NONE);
	SIGNAL chip_state:E_ChipState;
----------------------------------------
-- Counters mode
----------------------------------------
	PROCEDURE mode0_count                                         --procedure for
         	                                                      --count mode 0
	(
		COUNTER:  IN      STD_LOGIC_VECTOR(15 DOWNTO 0);          --input variable
		RET_COUNT:OUT     STD_LOGIC_VECTOR(15 DOWNTO 0);          --out variable
		OUTPUT:   OUT     STD_LOGIC                               --value of
                                                                --output line
	)IS
	BEGIN
		IF (COUNTER="0000000000000000") THEN                        --if count is 0
			OUTPUT:='1';                                        --output will
                                     			                    --be 1
		ELSE
			RET_COUNT:=std_logic_vector(unsigned(COUNTER)- 1);
 
		END IF;
	END mode0_count;
	
	PROCEDURE mode4_count
	(
		COUNTER:	IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
		RET_COUNT:	OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
		OUTPUT:		OUT	STD_LOGIC
     	)IS
	BEGIN
		IF(COUNTER="0000000000000000") THEN
			OUTPUT:='0';
		ELSE
			RET_COUNT:=std_logic_vector(unsigned(COUNTER)- 1);
		END IF;
	END mode4_count;

	PROCEDURE mode5_count
	(
		COUNTER:	IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
		RET_COUNT:	OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
		OUTPUT:		OUT	STD_LOGIC
     	)IS
	BEGIN
		IF(COUNTER="0000000000000000") THEN
			OUTPUT:='0';
		ELSE
			RET_COUNT:=std_logic_vector(unsigned(COUNTER)- 1);
		END IF;
	END mode5_count;
----------------------------------------
-- General counter procedure
----------------------------------------
	PROCEDURE counter_procedure
	(
		COUNTER_MODE:	IN	STD_LOGIC_VECTOR(2 DOWNTO 0);
		GATE_IN:	IN	STD_LOGIC;
		CONST_IN:	IN	STD_LOGIC_VECTOR(15 DOWNTO 0);
		CONST_OUT:	OUT	STD_LOGIC_VECTOR(15 DOWNTO 0);
		OUTPUT:		OUT	STD_LOGIC
	)	IS
	BEGIN
		CASE COUNTER_MODE IS
			WHEN "000"=>		--mode 0 counter
				OUTPUT:='0';
				IF(GATE_IN='1') THEN
					mode0_count(CONST_IN,CONST_OUT,OUTPUT);
				END IF;
			WHEN "100"=>		--mode 1 counter
				OUTPUT:='1';
				IF(GATE_IN='1') THEN
					mode4_count(CONST_IN,CONST_OUT,OUTPUT);
				END IF;
			WHEN "101"=>		--mode 5 counter
				OUTPUT:='1';
				IF(GATE_IN='1') THEN
					mode5_count(CONST_IN,CONST_OUT,OUTPUT);
				END IF;
			WHEN OTHERS=>null;
		END CASE;		
	END counter_procedure;

  
BEGIN
	--DATA_BUFFER<=D WHEN CS='0' and WR='0' else "ZZZZZZZZ";--used parrallel reading for inout port
	--D<=DATA_BUFFER WHEN CS='0' and RD='0' else "ZZZZZZZZ";
	PROCESS(CS,A1,A0) IS
		VARIABLE DATA_BUFFER:STD_LOGIC_VECTOR(7 DOWNTO 0);
		VARIABLE mode:STD_LOGIC_VECTOR(2 DOWNTO 0);
		VARIABLE counter_id:STD_LOGIC_VECTOR(1 DOWNTO 0):="ZZ";
		VARIABLE command:STD_LOGIC_VECTOR(1 DOWNTO 0);
		VARIABLE counter0_value:STD_LOGIC_VECTOR(15 DOWNTO 0):="ZZZZZZZZZZZZZZZZ";
		VARIABLE counter1_value:STD_LOGIC_VECTOR(15 DOWNTO 0):="ZZZZZZZZZZZZZZZZ";
		VARIABLE counter2_value:STD_LOGIC_VECTOR(15 DOWNTO 0):="ZZZZZZZZZZZZZZZZ";
		VARIABLE address_op:STD_LOGIC_VECTOR(1 DOWNTO 0);

		VARIABLE gate0_var:STD_LOGIC;
		VARIABLE gate1_var:STD_LOGIC;
		VARIABLE gate2_var:STD_LOGIC;
		VARIABLE out0_var:STD_LOGIC;
		VARIABLE out1_var:STD_LOGIC;
		VARIABLE out2_var:STD_LOGIC;
	BEGIN
		IF(CS'event AND CS='0') THEN	--if chip select is active on 0, then start loading and count
			DATA_BUFFER:=D;
			address_op(0):=A0;
			address_op(1):=A1;
			IF(chip_state/=COUNTING) THEN
				OUT0<='1';
				OUT1<='1';
				OUT2<='1';
			END IF;
			IF(RD='1' AND WR='0' AND chip_state=LOADING) THEN --when write mode for constants
				--load counters values
				CASE address_op IS
					WHEN "00"=>
						IF(command="01") THEN --load low nibble
							FOR index IN 0 TO 7 LOOP
								counter0_value(index):=DATA_BUFFER(index);
							END LOOP;
							chip_state<=PROGRAMMING;
						ELSIF(command="10") THEN --load high nibble
							FOR index IN 0 TO 7 LOOP
								counter0_value(index+8):=DATA_BUFFER(index);
							END LOOP;
--						ELSE
--							FOR index IN 0 TO 7 LOOP
--								counter0_value(index):=DATA_BUFFER(index);
--							END LOOP;
--							FOR index IN 0 TO 7 LOOP
--								counter0_value(index+8):=DATA_BUFFER(index);
--							END LOOP;
							chip_state<=COUNTING;
						END IF;
					WHEN "01"=>
						IF(command="01") THEN --load low nibble
							FOR index IN 0 TO 7 LOOP
								counter1_value(index):=DATA_BUFFER(index);
							END LOOP;
							chip_state<=PROGRAMMING;
						ELSIF(command="10") THEN --load high nibble
							FOR index IN 0 TO 7 LOOP
								counter1_value(index+8):=DATA_BUFFER(index);
							END LOOP;
--						ELSE
--							FOR index IN 0 TO 7 LOOP
--								counter1_value(index):=DATA_BUFFER(index);
--							END LOOP;
--							FOR index IN 0 TO 7 LOOP
--								counter1_value(index+8):=DATA_BUFFER(index);
--							END LOOP;
							chip_state<=COUNTING;
						END IF;
					WHEN "10"=>
						IF(command="01") THEN --load low nibble
							FOR index IN 0 TO 7 LOOP
								counter2_value(index):=DATA_BUFFER(index);
							END LOOP;
							chip_state<=PROGRAMMING;
						ELSIF(command="10") THEN --load high nibble
							FOR index IN 0 TO 7 LOOP
								counter2_value(index+8):=DATA_BUFFER(index);
							END LOOP;
--						ELSE
--							FOR index IN 0 TO 7 LOOP
--								counter2_value(index):=DATA_BUFFER(index);
--							END LOOP;
--							FOR index IN 0 TO 7 LOOP
--								counter2_value(index+8):=DATA_BUFFER(index);
--							END LOOP;
							chip_state<=COUNTING;
						END IF;
					WHEN OTHERS=>null;
				
				END CASE;
			ELSIF(chip_state=COUNTING) THEN --in counting state
-- START COUNTERS HERE!!!!!!!
				CASE counter_id IS
					WHEN "00" =>
						IF(CLK0'event AND CLK0='1') THEN
							gate0_var:=GATE0;
							counter_procedure(mode,gate0_var,counter0_value,counter0_value,out0_var);
							OUT0<=out0_var;
						END IF;	
					WHEN "01" =>
						IF(CLK1'event AND CLK0='1') THEN
							gate1_var:=GATE1;
							counter_procedure(mode,gate1_var,counter1_value,counter1_value,out1_var);
							OUT1<=out1_var;
						END IF;
					WHEN "10" =>
						IF(CLK2'event AND CLK0='1' AND gate2_var='1' ) THEN
							gate2_var:=GATE2;
							counter_procedure(mode,gate2_var,counter2_value,counter2_value,out2_var);
							OUT2<=out2_var;
						END IF;
					WHEN OTHERS=>null;
				END CASE;
				chip_state<=LOADING;
			
			ELSIF(RD='0' AND WR='1' AND chip_state=LOADING) THEN --is read mode
				CASE address_op IS
					WHEN "00"=>
						IF(command="01") THEN --load low nibble
							FOR index IN 0 TO 7 LOOP
							--	DATA_BUFFER(index)<=counter0_value(index);
							END LOOP;
						ELSIF(command="10") THEN --load high nibble
							FOR index IN 0 TO 7 LOOP
							--	DATA_BUFFER(index)<=counter0_value(index+8);
							END LOOP;
							--if read is complete=> goto programming state
							chip_state<=PROGRAMMING;
						END IF;
					WHEN "01"=>
						IF(command="01") THEN --load low nibble
							FOR index IN 0 TO 7 LOOP
							--	DATA_BUFFER(index)<=counter1_value(index);
							END LOOP;
						ELSIF(command="10") THEN --load high nibble
							FOR index IN 0 TO 7 LOOP
							--	DATA_BUFFER(index)<=counter1_value(index+8);
							END LOOP;
							--if read is complete=> goto programming state
							chip_state<=PROGRAMMING;
						END IF;
					WHEN "10"=>
						IF(command="01") THEN --load low nibble
							FOR index IN 0 TO 7 LOOP
							--	DATA_BUFFER(index)<=counter2_value(index);
							END LOOP;
						ELSIF(command="10") THEN --load high nibble
							FOR index IN 0 TO 7 LOOP
							--	DATA_BUFFER(index)<=counter2_value(index+8);
							END LOOP;
							--if read is complete=> goto programming state
							chip_state<=PROGRAMMING;
						END IF;
					WHEN OTHERS=>null;
				END CASE;
			END IF;
			IF(chip_state=PROGRAMMING ) THEN --if is in no state or is it in programming state
				--get counter id, mode and command
				counter_id:=DATA_BUFFER(7 DOWNTO 6);
				mode:=DATA_BUFFER(3 DOWNTO 1);
				command:=DATA_BUFFER(5 DOWNTO 4);
				--goto done programming mode;
				chip_state<=LOADING;
			END IF;
		END IF;
	END PROCESS;
  
END ARCHITECTURE dataflow;


