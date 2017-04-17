library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity font_test is
    Port (
    CLK,reset : in  STD_LOGIC;
--    TX : inout std_logic;
--    RX : in std_logic;

    ARDUINO_RESET : out  STD_LOGIC;
    DUO_SW1 : in  STD_LOGIC;
--  DUO_LED : out std_logic;

    SW_LEFT : in  STD_LOGIC;
    SW_UP : in  STD_LOGIC;
    SW_DOWN : in  STD_LOGIC;
    SW_RIGHT : in  STD_LOGIC;

    LED1 : inout  STD_LOGIC;
    LED2 : inout  STD_LOGIC;
    LED3 : inout  STD_LOGIC;
    LED4 : inout  STD_LOGIC;

    VGA_HSYNC : out  STD_LOGIC;
    VGA_VSYNC : out  STD_LOGIC;
    VGA_BLUE : out std_logic_vector(3 downto 0);
    VGA_GREEN : out std_logic_vector(3 downto 0);
    VGA_RED : out std_logic_vector(3 downto 0)

--    sram_addr : out std_logic_vector(20 downto 0);
--    sram_data : inout std_logic_vector(7 downto 0);
--    sram_ce : out std_logic;
--    sram_we : out std_logic;
--    sram_oe : out std_logic
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
	signal clkfb: std_logic;
	
	signal pixel_x, pixel_y: std_logic_vector(9 downto 0);
	signal video_on, pixel_tick: std_logic;
	signal rgb_reg, rgb_next: std_logic_vector(2 downto 0);
	signal hsync, vsync: std_logic;
	signal rgb: std_logic_vector(2 downto 0);
	signal buttons: std_logic_vector(3 downto 0);
begin
	-- pixel clock
    inst_dcm_32_to_50p35 : entity work.clk_wiz_v3_6
      port map
        (-- Clock in ports
         CLK_IN1 => clk,
         CLKFB_IN => clkfb,
         -- Clock out ports
         CLK_OUT1 => clock
        ,CLKFB_OUT => clkfb
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
--	butled0: entity work.wingbutled 
--	Port map(
--		io => w2c(15 downto 8),
--		buttons => buttons,
--		leds => buttons
--	);
	ARDUINO_RESET <= not(DUO_SW1);
	buttons <= sw_left & sw_right & sw_up & sw_down;
	led1 <= buttons(0);
	led2 <= buttons(1);
	led3 <= buttons(2);
	led4 <= buttons(3);

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
	vga_hsync <= hsync;
	vga_vsync <= vsync;
	vga_blue <= (others => rgb(0));--blue
	vga_green <= (others => rgb(1));--green
	vga_red <= (others => rgb(2));--red

end Behavioral;
