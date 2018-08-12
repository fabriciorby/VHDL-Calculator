LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY test IS
	PORT (
		switch				: IN STD_LOGIC;
		clk27M				: IN STD_LOGIC;
		reset				: IN STD_LOGIC;
		VGA_R, VGA_G, VGA_B	: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
		VGA_HS, VGA_VS		: OUT STD_LOGIC
	);
END ENTITY;

ARCHITECTURE behavior OF TEST IS
	COMPONENT vgacon IS
		GENERIC (
			NUM_HORZ_PIXELS : NATURAL := 128;	-- Number of horizontal pixels
			NUM_VERT_PIXELS : NATURAL := 96		-- Number of vertical pixels
		);
		PORT (
			clk27M, rstn              : IN STD_LOGIC;
			write_clk, write_enable   : IN STD_LOGIC;
			write_addr                : IN INTEGER RANGE 0 TO NUM_HORZ_PIXELS * NUM_VERT_PIXELS - 1;
			data_in                   : IN STD_LOGIC_VECTOR (2 DOWNTO 0);
			red, green, blue          : OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
			hsync, vsync              : OUT STD_LOGIC
		);
	END COMPONENT;
	
	CONSTANT CONS_CLOCK_DIV : INTEGER := 1000000;
	CONSTANT HORZ_SIZE : INTEGER := 160;
	CONSTANT VERT_SIZE : INTEGER := 120;
	
	SIGNAL slow_clock : STD_LOGIC;
	
	SIGNAL clear_video_address	,
		normal_video_address	,
		video_address			: INTEGER RANGE 0 TO HORZ_SIZE * VERT_SIZE - 1;
	
	SIGNAL clear_video_word		,
		normal_video_word		,
		video_word				: STD_LOGIC_VECTOR (2 DOWNTO 0);
	
	TYPE VGA_STATES IS (NORMAL, CLEAR);
	SIGNAL state : VGA_STATES;
BEGIN
	vga_component: vgacon
	GENERIC MAP (
		NUM_HORZ_PIXELS => HORZ_SIZE,
		NUM_VERT_PIXELS => VERT_SIZE
	) PORT MAP (
		clk27M			=> clk27M		,
		rstn			=> reset		,
		write_clk		=> clk27M		,
		write_enable	=> '1'			,
		write_addr      => video_address,
		data_in         => video_word	,
		red				=> VGA_R		,
		green			=> VGA_G		,
		blue			=> VGA_B		,
		hsync			=> VGA_HS		,
		vsync			=> VGA_VS		
	);
	
	video_word <= normal_video_word WHEN state = NORMAL ELSE clear_video_word;
	
	video_address <= normal_video_address WHEN state = NORMAL ELSE clear_video_address;

	clock_divider:
	PROCESS (clk27M, reset)
		VARIABLE i : INTEGER := 0;
	BEGIN
		IF (reset = '0') THEN
			i := 0;
			slow_clock <= '0';
		ELSIF (rising_edge(clk27M)) THEN
			IF (i <= CONS_CLOCK_DIV/2) THEN
				i := i + 1;
				slow_clock <= '0';
			ELSIF (i < CONS_CLOCK_DIV-1) THEN
				i := i + 1;
				slow_clock <= '1';
			ELSE		
				i := 0;
			END IF;	
		END IF;
	END PROCESS;
	
	vga_clear:
	PROCESS(clk27M, reset, clear_video_address)
	BEGIN
		IF (reset = '0') THEN
			state <= CLEAR;
			clear_video_address <= 0;
			clear_video_word <= "000";
		ELSIF (rising_edge(clk27M)) THEN
			CASE state IS
				WHEN CLEAR =>
					clear_video_address <= clear_video_address + 1;
					clear_video_word <= "000";
					IF (clear_video_address < HORZ_SIZE * VERT_SIZE-1) THEN
						state <= CLEAR;
					ELSE
						state <= NORMAL;
					END IF;
				WHEN NORMAL =>
					state <= NORMAL;
			END CASE;
		END IF;	
	END PROCESS;
		
	vga_writer:
	PROCESS (slow_clock, reset, normal_video_address)
	BEGIN
		IF (reset = '0') THEN
			normal_video_address <= 0;
			normal_video_word <= "000";
		ELSIF (rising_edge(slow_clock)) THEN
			CASE switch IS
				WHEN '1' =>
					normal_video_address <= normal_video_address + 1;
					normal_video_word <= "001";
				WHEN OTHERS =>
					normal_video_word <= "010";
			END CASE;
		END IF;	
	END PROCESS;
END ARCHITECTURE;