library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity font_test is
	port(
		ext_clk, reset: in std_logic;
		hsync, vsync: out std_logic;
		rgb: out std_logic_vector(2 downto 0)
	);
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

	-- font ROM
	font_gen_unit: entity work.font_generator
		port map(
			clock => pixel_tick,
			--clock => clock,
			video_on => video_on,
			pixel_x => pixel_x,
			pixel_y => pixel_y,
			rgb_text => rgb_next
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
end Behavioral;
