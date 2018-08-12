LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY atividadeMoore IS
	PORT ( 
		CLOCK	: IN  BIT;
		RESET	: IN  BIT;
		w		: IN 	BIT;
		z		: BUFFER BIT_VECTOR (1 DOWNTO 0)
	);

END atividadeMoore;

ARCHITECTURE funcionamento OF atividadeMoore IS
	
	SIGNAL y : BIT_VECTOR (1 DOWNTO 0);
	
	CONSTANT A : BIT_VECTOR (1 DOWNTO 0) := "00";
	CONSTANT B : BIT_VECTOR (1 DOWNTO 0) := "01";
	CONSTANT C : BIT_VECTOR (1 DOWNTO 0) := "11";
	CONSTANT D : BIT_VECTOR (1 DOWNTO 0) := "10";

	BEGIN
		
		PROCESS (RESET, CLOCK)
								
		BEGIN
								
			IF RESET = '0' THEN
				y <= A;
			ELSIF (CLOCK'EVENT AND CLOCK = '1') THEN
				CASE y IS
					WHEN A =>
						IF w = '0' THEN Y <= D;
						ELSE y <= B;
						END IF;
					WHEN B =>
						IF w = '0' THEN y <= A;
						ELSE y <= C;
						END IF;
					WHEN C =>
						IF w = '0' THEN y <= B;
						ELSE y <= D;
						END IF;
					WHEN D =>
						IF w = '0' THEN y <= C;
						ELSE y <= A;
						END IF;
				END CASE;
			END IF;
		END PROCESS;
		
		z <= y;
	
END funcionamento;