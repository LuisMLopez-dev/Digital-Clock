library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity TopLevelDigitalClock is
    Port ( clk : in STD_LOGIC; --Internal FPGA Clock
           reset : in STD_LOGIC; --Reset the digital clock
           seg : out STD_LOGIC_VECTOR (6 downto 0); --Seven segments
           an : out STD_LOGIC_VECTOR (7 downto 0); --8 displays
           dp: out STD_LOGIC);
end TopLevelDigitalClock;

architecture Behavioral of TopLevelDigitalClock is
    signal sec, min: STD_LOGIC_VECTOR(5 downto 0); --Seconds and minutes
    signal hour: STD_LOGIC_VECTOR(4 downto 0); --Hours
    signal secBCD, minBCD, hourBCD: STD_LOGIC_VECTOR(7 downto 0); --BCD equivalent of the time
    signal timeBCD: STD_LOGIC_VECTOR(23 downto 0);
    signal clk1Hz: STD_LOGIC := '0'; --One second clock used for the Digital Clock Counters

    --Imported Components
    component ClockDivider is
    generic(
        divisionFactor: integer := 50000000); -- Divide 100 MHz to 1 Hz
    Port ( clkIn  : in  STD_LOGIC;
           clkOut : out STD_LOGIC);
    end component;
    
    component DigitalClockCounters is
    port(
        clk: in STD_LOGIC;
        reset: in STD_LOGIC;
        sec: out STD_LOGIC_VECTOR(5 downto 0);
        min: out STD_LOGIC_VECTOR(5 downto 0);
        hour: out STD_LOGIC_VECTOR(4 downto 0));     
    end component;
    
    component BinaryToBCD is
    generic( n: integer := 6; --n = number of bits for seconds, minutes, or hours
            digits: integer := 2); --digits is the number of BCD digit
    Port (
        binary : in STD_LOGIC_VECTOR (n - 1 downto 0); -- n bits
        bcd : out STD_LOGIC_VECTOR (4 * digits - 1 downto 0) -- # of bcd digits = digits
    );
    end component;
    
    component SevenSegmentDriver is
    Port (
        clk : in STD_LOGIC; -- Clock signal for multiplexing
        bcd : in STD_LOGIC_VECTOR (23 downto 0); -- 6 BCD digits (24 bits)
        seg : out STD_LOGIC_VECTOR (6 downto 0); -- 7-segment output
        an : out STD_LOGIC_VECTOR (7 downto 0); -- Anode control
        dp: out STD_LOGIC
    );
    end component;    
    
    begin 
    --Port Maps of Components    
    UClockDivider: ClockDivider
    port map(
        clkIn => clk,
        clkOut => clk1Hz);
        
    UDigtialClockCounters: DigitalClockCounters
    port map(
        clk => clk1Hz,
        reset => reset,
        sec => sec,
        min => min,
        hour => hour);
        
    UBinaryToBCDSec: BinaryToBCD
    port map(
        binary => sec,
        bcd => secBCD);
        
    UBinaryToBCDMin: BinaryToBCD
    port map(
        binary => min,
        bcd => minBCD);
            
    UBinaryToBCDHour: BinaryToBCD
    generic map(
        n => 5,
        digits => 2)    
    port map(
        binary => hour,
        bcd => hourBCD);
        
    timeBCD <= hourBCD & minBCD & secBCD;    
    USevenSegmentDriver: SevenSegmentDriver
    port map(
        clk => clk,
        bcd => timeBCD,
        seg => seg,
        an => an,
        dp => dp);
end Behavioral;
