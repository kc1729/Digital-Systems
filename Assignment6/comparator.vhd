library ieee;
use ieee.std_logic_1164.all;
entity comparator is
   port (A, B: in std_logic_vector(7 downto 0); comp: out std_logic);
end entity;
architecture Serial of comparator is
begin
   process(A,B)
    variable less, greater, equal: std_logic;
   begin
     less := '0';
     greater := '0';
     equal := '1';
     for I in 0 to 7 loop
        greater := greater or (equal and A(7-I) and (not B(7-I)));
        less := less or (equal and B(7-I) and (not A(7-I)));
        equal := equal and (not (A(7-I) xor B(7-I)));
     end loop;
     comp <= equal or greater;
    end process;
end Serial;