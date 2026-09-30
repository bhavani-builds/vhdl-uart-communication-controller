library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity uart_tx is
    port (
        clk       : in  std_logic;
        reset     : in  std_logic;
        baud_tick : in  std_logic;

        tx_start  : in  std_logic;
        tx_data   : in  std_logic_vector(7 downto 0);

        tx        : out std_logic;
        busy      : out std_logic;
        tx_done   : out std_logic
    );
end uart_tx;

architecture RTL of uart_tx is

    type state_type is (
        IDLE,
        START_BIT,
        DATA_BITS,
        PARITY_BIT,
        STOP_BIT
    );

    signal state : state_type := IDLE;

    signal data_reg  : std_logic_vector(7 downto 0) := (others => '0');
    signal parity_reg : std_logic := '0';

    signal bit_count : integer range 0 to 7 := 0;

    signal tx_reg   : std_logic := '1';
    signal busy_reg : std_logic := '0';

begin

    tx   <= tx_reg;
    busy <= busy_reg;

    process(clk)
    begin

        if rising_edge(clk) then

            if reset = '1' then

                state      <= IDLE;
                data_reg   <= (others => '0');
                parity_reg <= '0';

                bit_count <= 0;

                tx_reg   <= '1';
                busy_reg <= '0';
                tx_done  <= '0';

            else

                tx_done <= '0';

                case state is

                    -- =========================
                    -- IDLE
                    -- =========================

                    when IDLE =>

                        tx_reg   <= '1';
                        busy_reg <= '0';

                        if tx_start = '1' then

                            data_reg <= tx_data;

                            -- Even parity
                            parity_reg <=
                                tx_data(0) xor
                                tx_data(1) xor
                                tx_data(2) xor
                                tx_data(3) xor
                                tx_data(4) xor
                                tx_data(5) xor
                                tx_data(6) xor
                                tx_data(7);

                            bit_count <= 0;

                            busy_reg <= '1';

                            state <= START_BIT;

                        end if;


                    -- =========================
                    -- START BIT
                    -- =========================

                    when START_BIT =>

                        if baud_tick = '1' then

                            tx_reg <= '0';

                            state <= DATA_BITS;

                        end if;


                    -- =========================
                    -- DATA BITS
                    -- =========================

                    when DATA_BITS =>

                        if baud_tick = '1' then

                            tx_reg <= data_reg(bit_count);

                            if bit_count = 7 then

                                state <= PARITY_BIT;

                            else

                                bit_count <= bit_count + 1;

                            end if;

                        end if;


                    -- =========================
                    -- PARITY BIT
                    -- =========================

                    when PARITY_BIT =>

                        if baud_tick = '1' then

                            tx_reg <= parity_reg;

                            state <= STOP_BIT;

                        end if;


                    -- =========================
                    -- STOP BIT
                    -- =========================

                    when STOP_BIT =>

                        if baud_tick = '1' then

                            tx_reg   <= '1';
                            busy_reg <= '0';
                            tx_done  <= '1';

                            state <= IDLE;

                        end if;

                end case;

            end if;

        end if;

    end process;

end RTL;
