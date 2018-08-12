LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY somadorBinarioParalelo IS
	PORT ( 
		A, B	: IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
		CIN		: IN  STD_LOGIC;
		S		: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
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
	
	SIGNAL C : STD_LOGIC_VECTOR (2 DOWNTO 0);

	BEGIN
		
		L1 : somadorCompleto PORT MAP (A(0), B(0), CIN,  S(0), C(1));
		L2 : somadorCompleto PORT MAP (A(1), B(1), C(1), S(1), C(2));
		L3 : somadorCompleto PORT MAP (A(2), B(2), C(2), S(2), C(3));
		L4 : somadorCompleto PORT MAP (A(3), B(3), C(3), S(3), COUT);
		
END funcionamento;