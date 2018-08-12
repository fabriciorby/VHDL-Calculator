LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY conv_7seg IS
	port( digit	: in STD_LOGIC_VECTOR (3 downto 0);
			seg	: out STD_LOGIC_VECTOR (6 downto 0));
END conv_7seg;

ARCHITECTURE structural OF conv_7seg IS
BEGIN
	WITH digit SELECT
		seg <= "1000000" WHEN "0000",
				 "1111001" WHEN "0001",
				 "0100100" WHEN "0010",
				 "0110000" WHEN "0011",
				 "0011001" WHEN "0100",
				 "0010010" WHEN "0101",
				 "0000010" WHEN "0110",
				 "1011000" WHEN "0111",
				 "0000000" WHEN "1000",
				 "0010000" WHEN "1001",
				 "0001000" WHEN "1010",
				 "0000011" WHEN "1011",
				 "1000110" WHEN "1100",
				 "0100001" WHEN "1101",
				 "0000110" WHEN "1110",
				 "0001110" WHEN "1111";
END structural;