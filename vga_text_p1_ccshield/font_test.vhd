library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity font_test is
    Port ( rx : in  STD_LOGIC;
           tx : inout  STD_LOGIC;
           W1A : inout  STD_LOGIC_VECTOR (15 downto 0);
           W1B : inout  STD_LOGIC_VECTOR (15 downto 0);
           W2C : inout  STD_LOGIC_VECTOR (15 downto 0);
           ext_clk, reset : in  STD_LOGIC);
end font_test;

architecture Behavioral of font_test is
	-- vga clock
	component dcm_32_to_50p35
		port(
			clkin_in : in std_logic;          
			clkfx_out : out std_logic;
			clkin_ibufg_out : out std_logic;
			clk0_out : out std_logic
		);
	end component;
	signal clock: std_logic;
	
	signal pixel_x, pixel_y: std_logic_vector(9 downto 0);
	signal video_on, pixel_tick: std_logic;
	signal rgb_reg, rgb_next: std_logic_vector(2 downto 0);
	signal hsync, vsync: std_logic;
	signal rgb: std_logic_vector(2 downto 0);
	signal buttons: std_logic_vector(3 downto 0);
begin
	-- pixel clock
	inst_dcm_32_to_50p35: dcm_32_to_50p35
		port map(
			clkin_in => ext_clk,
			clkfx_out => clock,
			clkin_ibufg_out => open,
			clk0_out => open
		);

	-- VGA signals
	vga_sync_unit: entity work.vga_sync
		port map(
			clock => clock,
			reset => reset,
			hsync => hsync,
			vsync => vsync,
			video_on => video_on,
			pixel_tick => pixel_tick,
			pixel_x => pixel_x,
			pixel_y => pixel_y
		);

	-- font generator
	font_gen_unit: entity work.font_generator
		port map(
			clock => pixel_tick,
			video_on => video_on,
			buttons => buttons,
			pixel_x => pixel_x,
			pixel_y => pixel_y,
			rgb_text => rgb_next
		);
	butled0: entity work.wingbutled 
	Port map(
		io => w2c(15 downto 8),
		buttons => buttons,
		leds => buttons
	);

	-- rgb buffer
	process(clock)
	begin
		if clock'event and clock = '1' then
			if pixel_tick = '1' then
				rgb_reg <= rgb_next;
			end if;
		end if;
	end process;
	
	rgb <= rgb_reg;
	w1a(0) <= hsync;
	w1a(1) <= vsync;

	w1a(2) <= rgb(0);--b1
	w1a(5) <= rgb(0);--b2
	w1a(6) <= rgb(0);--b3
	w1a(7) <= rgb(0);--b4

	w1a(8) <= rgb(1);--g1
	w1a(9) <= rgb(1);--g2
	w1a(10) <= rgb(1);--g3
	w1a(11) <= rgb(1);--g4

	w1a(12) <= rgb(2);--r4
	w1a(13) <= rgb(2);--r3
	w1a(14) <= rgb(2);--r2
	w1a(15) <= rgb(2);--r1

end Behavioral;
