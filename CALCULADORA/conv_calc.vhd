LIBRARY ieee ;
USE ieee.std_logic_1164.all ;

ENTITY conv_calc IS
	port(	SCAN	: in STD_LOGIC_VECTOR (3 downto 0);
			ENTRADA	: out STD_LOGIC_VECTOR (6 downto 0));
END conv_calc;

ARCHITECTURE structural OF conv_calc IS
BEGIN
	WITH SCAN SELECT
	ENTRADA <=   "0000" WHEN "01110000", -- 0	70
				 "0001" WHEN "01101001", -- 1	69
				 "0010" WHEN "01110010", -- 2	72
				 "0011" WHEN "01111010", -- 3	7A
				 "0100" WHEN "01101011", -- 4	6B
				 "0101" WHEN "01110011", -- 5	73
				 "0110" WHEN "01110100", -- 6	74
				 "0111" WHEN "01101100", -- 7	6C
				 "1000" WHEN "01110101", -- 8	75
				 "1001" WHEN "01111101", -- 9	7D
				 "1010" WHEN "01111001", -- +	79
				 "1011" WHEN "01111011", -- -	7B
				 "1100" WHEN "01111100", -- *	7C
				 "1101" WHEN "01001010", -- /	4A
				 "1110" WHEN "01011010", -- En	5A
				 "1111" WHEN "01100110"; -- BK	66
END structural;