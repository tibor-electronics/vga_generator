library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity VGA_Palette is
	port(
		ext_clock: in std_logic;
		red: out std_logic;
      green: out  std_logic;
      blue: out  std_logic;
      hsync: out  std_logic;
      vsync: out  std_logic;
		--
		c: out std_logic
	);
end VGA_Palette;

architecture Behavioral of VGA_Palette is
	component dcm_32_to_25
		port(
			clkin_in: in std_logic;          
			clkfx_out: out std_logic;
			clkin_ibufg_out: out std_logic;
			clk0_out: out std_logic
		);
	end component;
	constant PIXEL_COUNT: integer := 800;
	constant LINE_COUNT: integer := 525;
	signal pixel_counter: unsigned(9 downto 0) := (others => '0');
	signal line_counter: unsigned(9 downto 0) := (others => '0');
	signal clock: std_logic;
begin
	vga_clock: dcm_32_to_25
		port map(
			clkin_in => ext_clock,
			clkfx_out => clock,
			clkin_ibufg_out => open,
			clk0_out => open
		);

	update_pixel_counter: process(clock)
	begin
		if clock'event and clock = '1' then
			if pixel_counter = PIXEL_COUNT - 1 then
				pixel_counter <= (others => '0');
			else
				pixel_counter <= pixel_counter + 1;
			end if;
		end if;
	end process;
	
	update_line_counter: process(clock)
	begin
		if clock'event and clock = '1' then
			if line_counter = LINE_COUNT - 1 then
				line_counter <= (others => '0');
			elsif pixel_counter = PIXEL_COUNT - 1 then
				line_counter <= line_counter + 1;
			end if;
		end if;
	end process;
	
	update_hsync: process(clock)
	begin
		if clock'event and clock = '1' then
			if pixel_counter <= 94 then
				hsync <= '0';
			else
				hsync <= '1';
			end if;
		end if;
	end process;
	
	update_vsync: process(clock)
	begin
		if clock'event and clock = '1' then
			if line_counter <= 1 then
				vsync <= '0';
			else
				vsync <= '1';
			end if;
		end if;
	end process;
	
	update_pixel: process(clock)
	begin
		if clock'event and clock = '1' then
			if pixel_counter <= 94 or line_counter <= 1 then
				red <= '0';
				green <= '0';
				blue <= '0';
			elsif (2 <= line_counter and line_counter <= 33) or (514 <= line_counter and line_counter <= 524) then
				red <= '0';
				green <= '0';
				blue <= '0';
			elsif (95 <= pixel_counter and pixel_counter <= 135) or (776 <= pixel_counter and pixel_counter <= 799) then
				red <= '0';
				green <= '0';
				blue <= '0';
			else
				red <= pixel_counter(9);
				green <= pixel_counter(6);
				blue <= line_counter(5);
			end if;
		end if;
	end process;
	
	process(clock)
	begin
		c <= clock;
	end process;

end Behavioral;
