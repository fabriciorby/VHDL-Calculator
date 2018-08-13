LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.all;
--USE IEEE.STD_LOGIC_UNSIGNED.all;
USE IEEE.NUMERIC_STD.all;


ENTITY CALC IS
	PORT ( 
		-- PWM --
		CLOCK	: IN  STD_LOGIC;
		RESET	: IN  STD_LOGIC;
		ENABLE	: IN  STD_LOGIC;
		DUTY	: IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
		COUTP	: BUFFER STD_LOGIC;

		------------------------	Clock Input	 	------------------------
		CLOCK_24	: 	IN	STD_LOGIC_VECTOR (1 DOWNTO 0);	--	24 MHz
		CLOCK_27	:	IN	STD_LOGIC_VECTOR (1 DOWNTO 0);	--	27 MHz
		CLOCK_50	: 	IN	STD_LOGIC;						--	50 MHz
		-- CLOCKTAP	: 	OUT	STD_LOGIC;
		
		------------------------	Push Button		------------------------
		KEY 	:		IN	STD_LOGIC_VECTOR (3 DOWNTO 0);		--	PUSHBUTTON[3:0]

		------------------------	DPDT Switch		------------------------
		SW 		:		IN STD_LOGIC_VECTOR (9 DOWNTO 0);			--	TOGGLE SWITCH[9:0]
		
		------------------------	7-SEG Display	------------------------
		HEX0 	:		OUT	STD_LOGIC_VECTOR (6 DOWNTO 0);		--	SEVEN SEGMENT DIGIT 0
		HEX1 	:		OUT	STD_LOGIC_VECTOR (6 DOWNTO 0);		--	SEVEN SEGMENT DIGIT 1
		HEX2 	:		OUT	STD_LOGIC_VECTOR (6 DOWNTO 0);		--	SEVEN SEGMENT DIGIT 2
		HEX3 	:		OUT	STD_LOGIC_VECTOR (6 DOWNTO 0);		--	Seven Segment Digit 3
		
		----------------------------	LED		----------------------------
		LEDG 	:		OUT	STD_LOGIC_VECTOR (7 DOWNTO 0);		--	LED GREEN[7:0]
		LEDR 	:		OUT	STD_LOGIC_VECTOR (9 DOWNTO 0);		--	LED Red[9:0]
					
		------------------------	PS2		--------------------------------
		PS2_DAT :		INOUT	STD_LOGIC;	--	PS2 Data
		PS2_CLK	:		INOUT	STD_LOGIC	--	PS2 Clock
	);

END CALC;

ARCHITECTURE funcionamento OF CALC IS
			
	-- IMPORTANDO COMPONENTES --

	-- CONTROLADOR DE BRILHO DO DISPLAY
	COMPONENT PWM 
		PORT ( 
			CLOCK	: IN STD_LOGIC;
			RESET	: IN STD_LOGIC;
			ENABLE	: IN STD_LOGIC;
			DUTY	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			CIN		: IN STD_LOGIC_VECTOR(6 DOWNTO 0);
			COUTP	: BUFFER STD_LOGIC_VECTOR(6 DOWNTO 0)
		);
	END COMPONENT;

	-- CONVERSOR DE SCANCODE PARA VALOR DE ENTRADA
	COMPONENT conv_calc
		PORT (
			SCAN	:		IN STD_LOGIC_VECTOR (7 DOWNTO 0);
			ENTRADA	:		OUT UNSIGNED (3 DOWNTO 0)
		);
	END COMPONENT;

	-- CONVERSOR PARA 7SEG
	COMPONENT conv_7seg
		PORT (
			DIGIT	:		IN STD_LOGIC_VECTOR (3 DOWNTO 0);
			SEG		:		OUT STD_LOGIC_VECTOR (6 DOWNTO 0)
		);
	END COMPONENT;

	-- BINARY TO BCD
	COMPONENT binary_to_bcd
    	PORT (
			BINARY 		: IN  UNSIGNED (11 DOWNTO 0);
           	BCD_UNI 	: OUT  STD_LOGIC_VECTOR (3 DOWNTO 0);
           	BCD_TEN 	: OUT  STD_LOGIC_VECTOR (3 DOWNTO 0);
           	BCD_HUN 	: OUT  STD_LOGIC_VECTOR (3 DOWNTO 0);
           	BCD_THO 	: OUT  STD_LOGIC_VECTOR (3 DOWNTO 0)
        );
	END COMPONENT;


	-- BIBLIOTECA PARA CONTROLE DO TECLADO
	COMPONENT kbdex_ctrl
		GENERIC (
			CLKFREQ : INTEGER
		);
		PORT (
			PS2_DATA	:	INOUT STD_LOGIC;
			PS2_CLK		:	INOUT STD_LOGIC;
			CLK			:	IN STD_LOGIC;
			EN			:	IN STD_LOGIC;
			RESETN		:	IN STD_LOGIC;
			LIGHTS		:	IN STD_LOGIC_VECTOR(2 DOWNTO 0); -- LIGHTS(CAPS, NUN, SCROLL)		
			KEY_ON		:	OUT	STD_LOGIC_VECTOR(2 DOWNTO 0);
			KEY_CODE	:	OUT	STD_LOGIC_VECTOR(47 DOWNTO 0)
		);
	END COMPONENT;

	-- DECLARACAO DE SIGNALS

	SIGNAL ENTRADA 	: UNSIGNED (3 DOWNTO 0);
	SIGNAL BINARY 	: UNSIGNED (11 DOWNTO 0);
	SIGNAL DIGITOS 	: STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL RESETN	: STD_LOGIC;
	SIGNAL key0 	: STD_LOGIC_VECTOR (15 DOWNTO 0);
	SIGNAL lights	: STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL key_on	: STD_LOGIC_VECTOR (2 DOWNTO 0);
	SIGNAL key_code	: STD_LOGIC_VECTOR (47 DOWNTO 0);

	-- CONSTANTES DEFINIDAS EM conv_calc.vhd

	CONSTANT SUM : UNSIGNED (3 DOWNTO 0) := "1010";
	CONSTANT SUB : UNSIGNED (3 DOWNTO 0) := "1011";
	CONSTANT MUL : UNSIGNED (3 DOWNTO 0) := "1100";
	CONSTANT DIV : UNSIGNED (3 DOWNTO 0) := "1101";
	CONSTANT ENT : UNSIGNED (3 DOWNTO 0) := "1110";
	CONSTANT BKS : UNSIGNED (3 DOWNTO 0) := "1111";

	CONSTANT VAZIO : UNSIGNED (11 DOWNTO 0) := (OTHERS => '0');

	BEGIN

	-- PROCESS

	PROCESS(ENTRADA, RESET)

	VARIABLE COUNT  : INTEGER;
	VARIABLE OP		: INTEGER;
	VARIABLE A 		: UNSIGNED (11 DOWNTO 0);
	VARIABLE B 		: UNSIGNED (11 DOWNTO 0);
	VARIABLE C 		: UNSIGNED (11 DOWNTO 0);

	BEGIN
		IF (RESET = '1') THEN 
			BINARY <= BINARY*0;
			A:=VAZIO;
			B:=VAZIO;
			C:=VAZIO;
		ELSE
			CASE ENTRADA IS

				WHEN SUM =>

					COUNT := 0;
					OP := 1;

					IF (A = VAZIO) THEN 
						A := BINARY;
						--BINARY <= VAZIO;
						C := A;
					ELSIF (B = VAZIO) THEN
						B := BINARY;
						BINARY <= A + B;
						C := B;
						A := VAZIO;
						B := VAZIO;
					END IF;

				WHEN SUB =>

					COUNT := 0;
					OP := 2;

					IF (A = VAZIO) THEN 
						A := BINARY;
						--BINARY <= VAZIO;
						C := A;
					ELSIF (B = VAZIO) THEN
						B := BINARY;
						BINARY <= A - B;
						C := B;
						A := VAZIO;
						B := VAZIO;
					END IF;

				WHEN MUL =>

					COUNT := 0;
					OP := 3;

					IF (A = VAZIO) THEN 
						A := BINARY;
						--BINARY <= VAZIO;
						C := A;
					ELSIF (B = VAZIO) THEN
						B := BINARY;
						BINARY <= A * B;
						C := B;
						A := VAZIO;
						B := VAZIO;
					END IF;

				WHEN DIV =>

					COUNT := 0;
					OP := 4;

					IF (A = VAZIO) THEN 
						A := BINARY;
						--BINARY <= VAZIO;
						C := A;
					ELSIF (B = VAZIO) THEN
						B := BINARY;
						BINARY <= A / B;
						C := B;
						A := VAZIO;
						B := VAZIO;
					END IF;

				WHEN ENT =>

					COUNT := 0;

					IF (A = VAZIO) THEN 
						A := BINARY;
						BINARY <= VAZIO;
					ELSIF (B = VAZIO) THEN
						B := BINARY;
						CASE OP IS 
							WHEN 1 =>
								BINARY <= BINARY + C;
							WHEN 2 =>
								BINARY <= BINARY - C;
							WHEN 3 =>
								BINARY <= BINARY * C;
							WHEN 4 =>
								BINARY <= BINARY / C;
							WHEN OTHERS =>
						END CASE;
						BINARY <= A / B;
						A := VAZIO;
						B := VAZIO;
						C := BINARY;
					END IF;

				WHEN BKS =>
					IF NOT (COUNT = 0) THEN
						BINARY <= BINARY*0;
						COUNT := COUNT - 1;
					END IF;
				WHEN OTHERS =>
					IF NOT (BINARY = VAZIO AND ENTRADA = 0) THEN
						CASE COUNT IS
							WHEN 0 =>
								BINARY <= 0 + ENTRADA;
								COUNT := COUNT + 1;
							WHEN 1 =>
								BINARY <= BINARY * 10 + ENTRADA;
								COUNT := COUNT + 1;
							WHEN 2 =>
								BINARY <= BINARY * 100 + ENTRADA;
								COUNT := COUNT + 1;
							WHEN 3 =>
								BINARY <= BINARY * 1000 + ENTRADA;
								COUNT := COUNT + 1;
							WHEN OTHERS =>
						END CASE;
					END IF;
			END CASE;
		END IF;
	END PROCESS;

	RESETN <= KEY(0);

	--PEGA OS CLIQUES DO TECLADO

	kbd_ctrl : kbdex_ctrl GENERIC MAP(24000) PORT MAP(
		PS2_DAT, PS2_CLK, CLOCK_24(0), KEY(1), resetn, lights,
		key_on, key_code
	);

	key0 <= key_code(15 DOWNTO 0);

	--TRANSFORMA OS CLIQUES EM COMANDOS

	dig_calc: conv_calc PORT MAP (
		key0(7 DOWNTO 0), ENTRADA
	);

	--somador: somadorBinarioParalelo GENERIC MAP(12) PORT MAP (
	--	A, B, 0,
	--	BINARY, COUT
	--);

	--TRANSFORMA OS NUMEROS BINARIOS EM 4 CASAS DECIMAIS

	bin2bcd: binary_to_bcd PORT MAP (
		BINARY, 	
		DIGITOS (3 DOWNTO 0), DIGITOS (7 DOWNTO 4), DIGITOS (11 DOWNTO 8), DIGITOS (15 DOWNTO 12) 
	);

	--CONTROLA O BRILHO DO DISPLAY DE 7 SEGMENTOS

	controlador: PWM PORT MAP (
		CLOCK, RESET, ENABLE, DUTY, DIGITOS,
		COUTP
	);

	--MOSTRA OS NUMEROS NO DISPLAY DE 7 SEGMENTOS COM BRILHO CONTROLADO

	hexseg0: conv_7seg PORT MAP (
		COUTP (3 DOWNTO 0), HEX0
	);
	hexseg1: conv_7seg PORT MAP (
		COUTP (7 DOWNTO 4), HEX1
	);
	hexseg2: conv_7seg PORT MAP (
		COUTP (11 DOWNTO 8), HEX2
	);
	hexseg3: conv_7seg PORT MAP (
		COUTP (15 DOWNTO 12), HEX3
	);

END funcionamento;