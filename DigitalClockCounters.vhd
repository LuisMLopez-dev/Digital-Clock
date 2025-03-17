library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity DigitalClockCounters is
    port(
        clk: in STD_LOGIC;
        reset: in STD_LOGIC;
        sec: out STD_LOGIC_VECTOR(5 downto 0);
        min: out STD_LOGIC_VECTOR(5 downto 0);
        hour: out STD_LOGIC_VECTOR(4 downto 0));     
end DigitalClockCounters;

architecture Behavioral of DigitalClockCounters is
    signal secCount: unsigned(5 downto 0) := (others => '0');
    signal minCount: unsigned(5 downto 0) := (others => '0');
    signal hourCount: unsigned(4 downto 0) := (others => '0');
        
    begin
    process(clk, reset)
    begin
        if reset = '1' then
            secCount <= (others => '0');
            minCount <= (others => '0');
            hourCount <= (others => '0');
        elsif rising_edge(clk) then
            if secCount = "111011" then --59 Seconds
                secCount <= (others => '0');
                if minCount = "111011" then --59 Minutes
                    minCount <= (others => '0');
                    if hourCount = "10111" then --23 Hours
                        hourCount <= (others => '0');
                    else
                        hourCount <= hourCount + 1;
                    end if;
                else
                    minCount <= minCount + 1;
                end if;
            else
                secCount <=  secCount + 1;
            end if;
        end if;
    end process;
    
    sec <= STD_LOGIC_VECTOR(secCount);
    min <= STD_LOGIC_VECTOR(minCount);
    hour <= STD_LOGIC_VECTOR(hourCount);
end Behavioral;
