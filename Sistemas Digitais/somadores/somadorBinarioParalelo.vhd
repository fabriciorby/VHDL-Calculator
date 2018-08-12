LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY somadorBinarioParalelo IS
	PORT ( 
		A, B	: IN  BIT_VECTOR (3 DOWNTO 0);
		S		: OUT BIT_VECTOR (3 DOWNTO 0);
		CIN	: IN  BIT;
		COUT	: OUT BIT
	);

END somadorBinarioParalelo;

ARCHITECTURE funcionamento OF somadorBinarioParalelo IS

	COMPONENT somadorCompleto
		PORT ( 
			A, B, CIN	: IN  BIT;
			S, COUT		: OUT BIT
		);
	END COMPONENT;
	
	--FOR ALL: somadorCompleto USE ENTITY work.somadorCompleto;

	SIGNAL X1, X2, X3 : BIT;

	BEGIN
		
		L1 : somadorCompleto PORT MAP (A(0), B(0), CIN, S(0), X1  );
		L2 : somadorCompleto PORT MAP (A(1), B(1), X1 , S(1), X2  );
		L3 : somadorCompleto PORT MAP (A(2), B(2), X2 , S(2), X3  );
		L4 : somadorCompleto PORT MAP (A(3), B(3), X3 , S(3), COUT);
		
END funcionamento;