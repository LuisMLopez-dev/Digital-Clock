library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ClockDivider is
    generic(
        divisionFactor: integer := 50000000); -- Divide 100 MHz to 1 Hz
    Port ( clkIn  : in  STD_LOGIC;
           clkOut : out STD_LOGIC);
end ClockDivider;

architecture Behavioral of ClockDivider is
    signal counter: integer := 0;
    signal clkToggle: STD_LOGIC := '0'; -- Initialize the divided clock
    
    begin
    process(clkIn)
    begin
        if rising_edge(clkIn) then
            if counter = divisionFactor - 1 then
                clkToggle <= not clkToggle; -- Toggle clock
                counter <= 0;
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;
    
    clkOut <= clkToggle;
end Behavioral;
