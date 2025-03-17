library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SevenSegmentDriver is
    Port (
        clk : in STD_LOGIC; -- Clock signal for multiplexing
        bcd : in STD_LOGIC_VECTOR (23 downto 0); -- 6 BCD digits (24 bits)
        seg : out STD_LOGIC_VECTOR (6 downto 0); -- 7-segment output
        an : out STD_LOGIC_VECTOR (7 downto 0); -- Anode control
        dp: out STD_LOGIC);
end SevenSegmentDriver;

architecture Behavioral of SevenSegmentDriver is
    signal digit : STD_LOGIC_VECTOR (3 downto 0);
    signal displaySelect : INTEGER range 0 to 5 := 0;
    signal counter : INTEGER := 0;
    
    begin
    process(clk) -- Clock divider
    begin
        if rising_edge(clk) then
            if counter = 6250 then --16 kHz total frequency for the 8 displays, 2 kHz for each display
                counter <= 0;
                displaySelect <= (displaySelect + 1) mod 6; -- Cycle through the first 6 displays
            else
                counter <= counter + 1;
            end if;
        end if;
    end process;

    -- Multiplexing logic
    process(displaySelect, bcd)
    begin
        case displaySelect is
            when 0 =>
                digit <= bcd(3 downto 0); -- Least significant digit
                an <= "11111110"; -- Activates first display
                dp <= '1';
            when 1 =>
                digit <= bcd(7 downto 4);
                an <= "11111101"; -- Activates second display
                dp <= '1';
            when 2 =>
                digit <= bcd(11 downto 8);
                an <= "11111011"; -- Activates third display
                dp <= '0';
            when 3 =>
                digit <= bcd(15 downto 12);
                an <= "11110111"; -- Activates fourth display
                dp <= '1';
            when 4 =>
                digit <= bcd(19 downto 16); 
                an <= "11101111"; -- Activates fifth display
                dp <= '0';
            when 5 =>
                digit <= bcd(23 downto 20); -- Most significant digit
                an <= "11011111"; --Activates sixth display
                dp <= '1';                
            when others =>
                digit <= "0000"; -- Default
                an <= "11111111"; -- Turns off all displays
                dp <= '1';
        end case;
    end process;

    decoder: entity work.SevenSegmentDecoder
    port map (
        digit => digit,
        segments => seg
    );
end Behavioral;