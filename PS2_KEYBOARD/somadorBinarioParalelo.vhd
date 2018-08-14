LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY somadorBinarioParalelo IS
	GENERIC (n : INTEGER := 4);
	PORT ( 
		A, B	: IN  STD_LOGIC_VECTOR (N-1 DOWNTO 0);
		CIN		: IN  STD_LOGIC;
		S		: OUT STD_LOGIC_VECTOR (N-1 DOWNTO 0);
		COUT	: OUT STD_LOGIC
	);

END somadorBinarioParalelo;

ARCHITECTURE funcionamento OF somadorBinarioParalelo IS

	COMPONENT somadorCompleto
		PORT ( 
			A, B, CIN	: IN  STD_LOGIC;
			S, COUT		: OUT STD_LOGIC
		);
	END COMPONENT;
	
	SIGNAL C : STD_LOGIC_VECTOR (n DOWNTO 0);

	BEGIN
		
		C(0) <= CIN;
		COUT <= C(n);

		ABC: FOR i IN 0 TO n-1 GENERATE
			SOMA: somadorCompleto PORT MAP (A(i), B(i), C(i), S(i), C(i+1));
		END GENERATE ABC;
		
END funcionamento;