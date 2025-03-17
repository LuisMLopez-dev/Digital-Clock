library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BinaryToBCDTB is
end BinaryToBCDTB;

architecture Behavioral of BinaryToBCDTB is
    component BinaryToBCD is
    generic( n: integer := 6; --n = number of bits for seconds, minutes, or hours
            digits: integer := 2); --digits is the number of BCD digit
    Port (
        binary : in STD_LOGIC_VECTOR (n - 1 downto 0); -- n bits
        bcd : out STD_LOGIC_VECTOR (4 * digits - 1 downto 0) -- # of bcd digits = digits
    );
    end component;

    signal binary : STD_LOGIC_VECTOR(5 downto 0);  -- 6-bit input for seconds/minutes (which a 5 input would be for hours)
    signal bcd    : STD_LOGIC_VECTOR(7 downto 0);  -- 2-digit BCD output (8-bit)

    begin
    UUT: BinaryToBCD
        generic map (n => 6, digits => 2)  -- Testing 6-bit input (0-59)
        port map (
            binary => binary,
            bcd => bcd);

    process
    begin
        -- Test Case 1: 0 (000000 -> 00 in BCD)
        binary <= "000000";
        wait for 10 ns;
        
        -- Test Case 2: 9 (001001 -> 09 in BCD)
        binary <= "001001";
        wait for 10 ns;
        
        -- Test Case 3: 12 (001100 -> 12 in BCD)
        binary <= "001100";
        wait for 10 ns;
        
        -- Test Case 4: 23 (010111 -> 23 in BCD)
        binary <= "010111";
        wait for 10 ns;
        
        -- Test Case 5: 45 (101101 -> 45 in BCD)
        binary <= "101101";
        wait for 10 ns;
        
        -- Test Case 6: 59 (111011 -> 59 in BCD)
        binary <= "111011";
        wait for 10 ns;

        -- End Simulation
        wait;
    end process;
end Behavioral;
