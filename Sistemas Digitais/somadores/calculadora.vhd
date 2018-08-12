LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
USE IEEE.std_logic_unsigned.all;


ENTITY PWM IS
	PORT ( 
		CLOCK	: IN  STD_LOGIC;
		RESET	: IN  STD_LOGIC;
		ENABLE: IN  STD_LOGIC;
		DUTY	: IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		COUT	: BUFFER STD_LOGIC
	);

END PWM;

ARCHITECTURE funcionamento OF pwm IS
		
	SIGNAL COUNT : STD_LOGIC_VECTOR (7 DOWNTO 0);
	
	BEGIN
	
	PROCESS (RESET, CLOCK, ENABLE)
										
	BEGIN
							
		IF RESET = '1' THEN
		
			COUNT <= "00000000";
			
			COUT <= '0';
			
		ELSIF (ENABLE = '0') THEN
						
			COUT <= '0';
			
		ELSIF (CLOCK'EVENT AND CLOCK = '1') THEN				
			
			COUNT <= COUNT + '1';
			
			IF (COUNT <= DUTY) THEN
			
			COUT <= '1';
			
			ELSIF (COUNT = "11111111") THEN
			
			COUNT <= "00000000";
			
			ELSE
			
			COUT <= '0';
			
			END IF;
			
		END IF;
		
	END PROCESS;
			
END funcionamento;