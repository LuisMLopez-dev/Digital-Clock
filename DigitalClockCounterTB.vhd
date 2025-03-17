library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DigitalClockCountersTB is
end DigitalClockCountersTB;

architecture Behavioral of DigitalClockCountersTB is
    component DigitalClockCounters
        port(
            clk : in STD_LOGIC;
            reset : in STD_LOGIC;
            sec : out STD_LOGIC_VECTOR(5 downto 0);
            min : out STD_LOGIC_VECTOR(5 downto 0);
            hour : out STD_LOGIC_VECTOR(4 downto 0));
    end component;

    -- Signals
    signal clk   : STD_LOGIC := '0';
    signal reset : STD_LOGIC := '0';
    signal sec   : STD_LOGIC_VECTOR(5 downto 0);
    signal min   : STD_LOGIC_VECTOR(5 downto 0);
    signal hour  : STD_LOGIC_VECTOR(4 downto 0);

    constant clkPeriod : time := 10 ns; --

    begin
    UUT: DigitalClockCounters
        port map(
            clk   => clk,
            reset => reset,
            sec   => sec,
            min   => min,
            hour  => hour
        );

    -- Clock Process
    process
    begin
        while now < 10 ms loop 
            clk <= '0';
            wait for clkPeriod / 2;
            clk <= '1';
            wait for clkPeriod / 2;
        end loop;
        wait;
    end process;

    process
    begin
        reset <= '1';
        wait for 20 ns;
        reset <= '0';
        
        -- Lets the clock run to observe the counting of seconds, minutes, and hours
        wait for 5 ms; 
        wait for 5 ms; 
        
        wait;
    end process;
end Behavioral;
