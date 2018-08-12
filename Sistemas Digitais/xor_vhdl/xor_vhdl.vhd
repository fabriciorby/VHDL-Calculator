LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY xor_vhdl IS
	PORT ( x1, x2 : IN STD_LOGIC ;
			f : OUT STD_LOGIC ) ;
END xor_vhdl ;

ARCHITECTURE LogicFunction OF xor_vhdl IS
BEGIN
	f <= (x1 AND NOT x2) OR (NOT x1 AND x2);
END LogicFunction ;