--
-- Copyright 2011, Kevin Lindsey
-- See LICENSE file for licensing information
--
-- Based on code from P. P. Chu, "FPGA Prototyping by VHDL Examples: Xilinx Spartan-3 Version", 2008
-- Chapters 12-13
--
library ieee;
use ieee.std_logic_1164.all;

entity vga_generator is
	port(
		ext_clk, reset: in std_logic;
		sw: in std_logic_vector(2 downto 0);
		hsync, vsync: out std_logic;
		rgb: out std_logic_vector(2 downto 0)
	);
end vga_generator;

architecture arch of vga_generator is
	-- vga clock
	component dcm_32_to_50p35
		port(
			clkin_in : in std_logic;          
			clkfx_out : out std_logic;
			clkin_ibufg_out : out std_logic;
			clk0_out : out std_logic
		);
	end component;
	signal clk: std_logic;
	
	signal rgb_reg: std_logic_vector(2 downto 0);
	signal video_on: std_logic;
begin
	inst_dcm_32_to_50p35: dcm_32_to_50p35 port map(
		clkin_in => ext_clk,
		clkfx_out => clk,
		clkin_ibufg_out => open,
		clk0_out => open
	);
	
	vga_sync_unit: entity work.vga_sync
		port map(
			clk => clk,
			reset => reset,
			hsync => hsync,
			vsync => vsync,
			video_on => video_on,
			p_tick => open,
			pixel_x => open,
			pixel_y => open
		);
	
	process(clk, reset)
	begin
		if reset = '1' then
			rgb_reg <= (others => '0');
		elsif clk'event and clk = '1' then
			rgb_reg <= sw;
		end if;
	end process;
	
	rgb <= rgb_reg when video_on = '1' else "000";
end arch;
