library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity parity_generator is
    port (
        data_in  : in  std_logic_vector(7 downto 0);
        parity   : out std_logic
    );
end parity_generator;

architecture RTL of parity_generator is

begin

    -- Even parity generation
    parity <= data_in(0) xor
              data_in(1) xor
              data_in(2) xor
              data_in(3) xor
              data_in(4) xor
              data_in(5) xor
              data_in(6) xor
              data_in(7);

end RTL;
