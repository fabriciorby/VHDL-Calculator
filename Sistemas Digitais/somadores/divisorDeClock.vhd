LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY divisorDeClock IS
	PORT ( 
		ENB	: IN  BIT;
		CLK	: IN  BIT;
		COUT	: BUFFER BIT
	);

END divisorDeClock;

ARCHITECTURE funcionamento OF divisorDeClock IS
		
	BEGIN
		
	PROCESS (CLK, COUT)
	
	VARIABLE COUNT : INTEGER;
		
	BEGIN
							
		IF (ENB = '0') THEN
		
			COUNT := 0;
			
			COUT <= '0';
		
		ELSE
		
			IF (CLK'EVENT AND CLK='1') THEN
			
				COUNT := COUNT + 1;
				
				IF (COUNT = 25000000) THEN
				
					COUT  <= NOT COUT;
				
					COUNT := 0;
										
				END IF;
				
			END IF;
			
		END IF;
		
	END PROCESS;
	
END funcionamento;