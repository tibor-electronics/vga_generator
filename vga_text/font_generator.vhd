library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity font_generator is
	port(
		clock: in std_logic;
		video_on: in std_logic;
		pixel_x, pixel_y: std_logic_vector(9 downto 0);
		rgb_text: out std_logic_vector(2 downto 0)
	);
end font_generator;

architecture Behavioral of font_generator is
	component video_ram
		port (
			clka: in std_logic;
			wea: in std_logic_vector(0 downto 0);
			addra: in std_logic_vector(11 downto 0);
			dina: in std_logic_vector(6 downto 0);
			clkb: in std_logic;
			addrb: in std_logic_vector(11 downto 0);
			doutb: out std_logic_vector(6 downto 0)
		);
	end component;
	
	signal char_addr: std_logic_vector(6 downto 0);
	signal rom_addr: std_logic_vector(10 downto 0);
	signal row_addr: std_logic_vector(3 downto 0);
	signal bit_addr: std_logic_vector(2 downto 0);
	signal font_word: std_logic_vector(7 downto 0);
	signal font_bit: std_logic;
	
	signal addr_read: std_logic_vector(11 downto 0);
	signal dout: std_logic_vector(6 downto 0);
begin
	-- instantiate font ROM
	font_unit: entity work.font_rom
		port map(
			clock => clock,
			addr => rom_addr,
			data => font_word
		);

	-- instantiate frame buffer
	frame_buffer_unit: video_ram
		port map (
			clka => clock,
			wea => (others => '0'),
			addra => (others => '0'),
			dina => (others => '0'),
			clkb => clock,
			addrb => addr_read,
			doutb => dout
		);

	-- tile RAM read
	addr_read <= pixel_y(8 downto 4) & pixel_x(9 downto 3);
	char_addr <= dout;
	
	-- font ROM interface
	row_addr <= pixel_y(3 downto 0);
	rom_addr <= char_addr & row_addr;
	bit_addr <= std_logic_vector(unsigned(pixel_x(2 downto 0)) - 1);
	font_bit <= font_word(to_integer(unsigned(not bit_addr)));

	-- rgb multiplexing
	process(video_on, font_bit)
	begin
		if video_on = '0' then
			rgb_text <= "000";
		elsif font_bit = '1' then
			rgb_text <= "010";
		else
			rgb_text <= "000";
		end if;
	end process;
end Behavioral;
