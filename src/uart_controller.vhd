library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uart_controller is
    generic (
        CLOCK_FREQ : integer := 50_000_000;
        BAUD_RATE  : integer := 9_600
    );

    port (
        clk       : in  std_logic;
        reset     : in  std_logic;

        -- Transmitter interface
        tx_start  : in  std_logic;
        tx_data   : in  std_logic_vector(7 downto 0);
        tx        : out std_logic;
        tx_busy   : out std_logic;
        tx_done   : out std_logic;

        -- Receiver interface
        rx        : in  std_logic;
        rx_data   : out std_logic_vector(7 downto 0);
        rx_valid  : out std_logic;
        rx_busy   : out std_logic
    );
end uart_controller;

architecture RTL of uart_controller is

    signal baud_tick : std_logic;

begin

    -- Baud rate generator
    BAUD_GEN : entity work.baud_generator
        generic map (
            CLOCK_FREQ => CLOCK_FREQ,
            BAUD_RATE  => BAUD_RATE
        )
        port map (
            clk       => clk,
            reset     => reset,
            baud_tick => baud_tick
        );


    -- UART transmitter
    UART_TX_INST : entity work.uart_tx
        port map (
            clk       => clk,
            reset     => reset,
            baud_tick => baud_tick,

            tx_start  => tx_start,
            tx_data   => tx_data,

            tx        => tx,
            busy      => tx_busy,
            tx_done   => tx_done
        );


    -- UART receiver
    UART_RX_INST : entity work.uart_rx
        port map (
            clk       => clk,
            reset     => reset,
            baud_tick => baud_tick,

            rx        => rx,

            rx_data   => rx_data,
            rx_valid  => rx_valid,
            rx_busy   => rx_busy
        );

end RTL;
