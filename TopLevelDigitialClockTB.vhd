library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TopLevelDigitalClock_TB is
end TopLevelDigitalClock_TB;

architecture Behavioral of TopLevelDigitalClock_TB is
    component TopLevelDigitalClock is
        Port ( 
            clk : in STD_LOGIC;  -- 100 MHz Clock
            reset : in STD_LOGIC; -- Reset signal
            seg : out STD_LOGIC_VECTOR (6 downto 0);  -- 7-segment output
            an : out STD_LOGIC_VECTOR (7 downto 0);   -- 8 display anodes
            dp: out STD_LOGIC);
    end component;

    signal clk : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal seg : STD_LOGIC_VECTOR (6 downto 0);
    signal an : STD_LOGIC_VECTOR (7 downto 0);
    signal dp: STD_LOGIC;
    constant clk_period : time := 10 ns;  -- 100 MHz

    begin
    process
    begin
        clk <= '0';
        wait for clk_period / 2;
        clk <= '1';
        wait for clk_period / 2;
    end process;

    UUT : TopLevelDigitalClock
        port map (
            clk => clk,
            reset => reset,
            seg => seg,
            an => an,
            dp => dp
        );

    process
    begin
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        wait for 500 ns; -- Let the digital clock run 
        
        wait;
    end process;
end Behavioral;
