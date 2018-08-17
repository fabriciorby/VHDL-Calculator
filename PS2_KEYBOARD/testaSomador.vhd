LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY TestaSomador IS
	GENERIC (N : INTEGER := 8);
	PORT ( 
		A, B	: IN  STD_LOGIC_VECTOR (N-1 DOWNTO 0);
		S		: BUFFER STD_LOGIC_VECTOR (N-1 DOWNTO 0);
		COUT	: OUT STD_LOGIC
	);

END TestaSomador;

ARCHITECTURE funcionamento OF TestaSomador IS

	COMPONENT somadorBinarioParalelo
		GENERIC (N : INTEGER);
		PORT( 
			A, B	: IN  STD_LOGIC_VECTOR (N-1 DOWNTO 0);
			CIN		: IN  STD_LOGIC;
			S		: OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0);
			COUT	: OUT STD_LOGIC
		);
	END COMPONENT;
	
	SIGNAL X, XX : STD_LOGIC_VECTOR (N-1 DOWNTO 0);
	SIGNAL Y, YY : STD_LOGIC_VECTOR (N-1 DOWNTO 0);
	SIGNAL E : STD_LOGIC_VECTOR (N-1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL OVERFLOW : STD_LOGIC_VECTOR(2 DOWNTO 0);
	
	BEGIN
	
	WITH A(N-1) SELECT
			X <=   	XX WHEN '1',
						A WHEN '0';
										
	WITH B(N-1) SELECT
			Y <=   	YY WHEN '1',
						B WHEN '0';
						
	COUT <= (A(N-1) AND B(N-1) AND NOT(S(N-1))) OR (NOT(A(N-1)) AND NOT(B(N-1)) AND S(N-1));
				
	X1: somadorBinarioParalelo GENERIC MAP(N) PORT MAP (
		NOT X, E, '1',
		XX, OVERFLOW(0)
	);
	
	Y1: somadorBinarioParalelo GENERIC MAP(N) PORT MAP (
		NOT Y, E, '1',
		YY, OVERFLOW(1)
	);
	
	somador: somadorBinarioParalelo GENERIC MAP(N) PORT MAP (
		A, B, '0',
		S, OVERFLOW(2)
	);
		
END funcionamento;