library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity baud_generator is
    generic (
        CLOCK_FREQ : integer := 50_000_000;
        BAUD_RATE  : integer := 9_600
    );

    port (
        clk       : in  std_logic;
        reset     : in  std_logic;
        baud_tick : out std_logic
    );
end baud_generator;

architecture RTL of baud_generator is

    constant DIVISOR : integer := CLOCK_FREQ / BAUD_RATE;

    signal counter : integer range 0 to DIVISOR - 1 := 0;

begin

    process(clk)
    begin
        if rising_edge(clk) then

            if reset = '1' then
                counter   <= 0;
                baud_tick <= '0';

            elsif counter = DIVISOR - 1 then
                counter   <= 0;
                baud_tick <= '1';

            else
                counter   <= counter + 1;
                baud_tick <= '0';
            end if;

        end if;
    end process;

end RTL;
