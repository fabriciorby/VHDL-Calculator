LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY binary4_to_bcd8_vector IS
	PORT ( BIN        : IN  STD_LOGIC_VECTOR (3 DOWNTO 0);
			 BCD0, BCD1 : OUT STD_LOGIC_VECTOR (3 DOWNTO 0) );
END binary4_to_bcd8_vector;
ARCHITECTURE data_flow OF binary4_to_bcd8_vector IS
BEGIN
	BCD0(0) <= BIN(0);
	BCD0(1) <= (BIN(3) AND BIN(2) AND (NOT BIN(1))) OR ((NOT BIN(3)) AND BIN(1));
	BCD0(2) <= ((NOT BIN(3)) AND BIN(2)) OR (BIN(2) AND BIN(1));
	BCD0(3) <= BIN(3) AND (NOT BIN(2)) AND (NOT BIN(1));
	BCD1(0) <= (BIN(3) AND BIN(2)) OR (BIN(3) AND BIN(1));
	BCD1(1) <= '0';
	BCD1(2) <= '0';
	BCD1(3) <= '0'; 
END data_flow;