library ieee;
use ieee.std_logic_1164.all;
entity subtractor is
   port (A, B: in std_logic_vector(7 downto 0); RESULT: out std_logic_vector(7 downto 0));
end entity;
architecture Serial of subtractor is
begin
   process(A,B)
     variable borrow: std_logic;
   begin
     borrow := '0';
     for I in 0 to 7 loop
        RESULT(I) <= (A(I) xor B(I)) xor borrow;
        borrow := (borrow and ((not A(I)) or B(I))) or ((not A(I)) and B(I));
     end loop;
   end process;
end Serial;
