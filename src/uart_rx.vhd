library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity uart_rx is
    port (
        clk        : in  std_logic;
        reset      : in  std_logic;
        baud_tick  : in  std_logic;

        rx         : in  std_logic;

        rx_data    : out std_logic_vector(7 downto 0);
        rx_valid   : out std_logic;
        rx_busy    : out std_logic
    );
end uart_rx;

architecture RTL of uart_rx is

    type state_type is (
        IDLE,
        START_BIT,
        DATA_BITS,
        STOP_BIT
    );

    signal state : state_type := IDLE;

    signal data_reg  : std_logic_vector(7 downto 0) := (others => '0');
    signal bit_count : integer range 0 to 7 := 0;

    signal rx_data_reg : std_logic_vector(7 downto 0) := (others => '0');
    signal busy_reg    : std_logic := '0';

begin

    rx_data  <= rx_data_reg;
    rx_busy  <= busy_reg;

    process(clk)
    begin

        if rising_edge(clk) then

            if reset = '1' then

                state       <= IDLE;
                data_reg    <= (others => '0');
                rx_data_reg <= (others => '0');

                bit_count <= 0;

                busy_reg <= '0';
                rx_valid <= '0';

            else

                rx_valid <= '0';

                case state is

                    -- Waiting for start bit
                    when IDLE =>

                        busy_reg <= '0';

                        if rx = '0' then

                            busy_reg <= '1';
                            state    <= START_BIT;

                        end if;


                    -- Verify start bit
                    when START_BIT =>

                        if baud_tick = '1' then

                            if rx = '0' then

                                bit_count <= 0;
                                state <= DATA_BITS;

                            else

                                state <= IDLE;

                            end if;

                        end if;


                    -- Receive 8 data bits
                    when DATA_BITS =>

                        if baud_tick = '1' then

                            data_reg(bit_count) <= rx;

                            if bit_count = 7 then

                                state <= STOP_BIT;

                            else

                                bit_count <= bit_count + 1;

                            end if;

                        end if;


                    -- Verify stop bit
                    when STOP_BIT =>

                        if baud_tick = '1' then

                            if rx = '1' then

                                rx_data_reg <= data_reg;
                                rx_valid    <= '1';

                            end if;

                            busy_reg <= '0';
                            state <= IDLE;

                        end if;

                end case;

            end if;

        end if;

    end process;

end RTL;
