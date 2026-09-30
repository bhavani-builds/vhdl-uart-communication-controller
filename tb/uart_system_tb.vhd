library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uart_system_tb is
end uart_system_tb;

architecture TB of uart_system_tb is

    constant CLOCK_PERIOD : time := 20 ns;

    signal clk   : std_logic := '0';
    signal reset : std_logic := '1';

    signal tx_start : std_logic := '0';
    signal tx_data  : std_logic_vector(7 downto 0) := (others => '0');

    signal tx      : std_logic;
    signal tx_busy : std_logic;
    signal tx_done : std_logic;

    signal rx       : std_logic;
    signal rx_data  : std_logic_vector(7 downto 0);
    signal rx_valid : std_logic;
    signal rx_busy  : std_logic;

begin

    -- Clock generation
    clk <= not clk after CLOCK_PERIOD / 2;

    -- UART loopback connection
    rx <= tx;


    -- Device Under Test
    DUT : entity work.uart_controller
        generic map (
            CLOCK_FREQ => 50_000_000,
            BAUD_RATE  => 9_600
        )
        port map (
            clk      => clk,
            reset    => reset,

            tx_start => tx_start,
            tx_data  => tx_data,

            tx       => tx,
            tx_busy  => tx_busy,
            tx_done  => tx_done,

            rx       => rx,
            rx_data  => rx_data,
            rx_valid => rx_valid,
            rx_busy  => rx_busy
        );


    -- Test process
    process
    begin

        report "====================================";
        report "       UART SYSTEM TEST";
        report "====================================";


        -- =================================
        -- RESET
        -- =================================

        reset <= '1';

        wait for 200 ns;

        reset <= '0';

        wait for 200 ns;


        -- =================================
        -- TEST 1: SEND ASCII 'A'
        -- =================================

        report "TEST 1: Transmitting 0x41";

        tx_data  <= x"41";
        tx_start <= '1';

        wait for CLOCK_PERIOD;

        tx_start <= '0';


        -- Wait for receiver
        wait until rx_valid = '1';


        -- Verify received data
        assert rx_data = x"41"
            report "TEST 1 FAILED: Expected 0x41"
            severity error;


        if rx_data = x"41" then

            report "TEST 1 PASSED: Received 0x41"
                severity note;

        end if;


        -- =================================
        -- TEST 2: SEND ASCII 'Z'
        -- =================================

        wait for 1 ms;

        report "TEST 2: Transmitting 0x5A";

        tx_data  <= x"5A";
        tx_start <= '1';

        wait for CLOCK_PERIOD;

        tx_start <= '0';


        wait until rx_valid = '1';


        -- Verify received data
        assert rx_data = x"5A"
            report "TEST 2 FAILED: Expected 0x5A"
            severity error;


        if rx_data = x"5A" then

            report "TEST 2 PASSED: Received 0x5A"
                severity note;

        end if;


        -- =================================
        -- TEST COMPLETE
        -- =================================

        report "====================================";
        report "       ALL UART TESTS PASSED";
        report "===================================="
            severity note;


        wait;

    end process;

end TB;
