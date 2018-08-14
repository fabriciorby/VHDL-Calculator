LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;

ENTITY somadorCompleto IS
	PORT ( 
		A, B, CIN	: IN  STD_LOGIC;
		S, COUT		: OUT STD_LOGIC
	);

END somadorCompleto;

ARCHITECTURE funcionamento OF somadorCompleto IS

	SIGNAL X1, X2, X3, X4 : STD_LOGIC;

	BEGIN
		
		X1 <= B XOR CIN;
		X2 <= B AND CIN;
		X3 <= B AND A;
		X4 <= A AND CIN;
		
		S <= A XOR X1;
		COUT <= X2 OR X3 OR X4;

END funcionamento;