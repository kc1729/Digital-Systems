library ieee;
use ieee.std_logic_1164.all;
entity decrement is
   port (A: in std_logic_vector(3 downto 0); B: out std_logic_vector(3 downto 0));
end entity decrement;

architecture Serial of decrement is
begin
  process(A)
    variable borrow: std_logic;
  begin 
    borrow := '1';
    for I in 0 to 3 loop
       B(I) <= A(I) xor borrow;
       borrow := borrow and (not A(I));
    end loop;
  end process; 
end Serial;