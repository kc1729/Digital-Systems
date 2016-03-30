library std;
library ieee;
use ieee.std_logic_1164.all;

library work;
use work.divider.all;
entity UDivider is
		port (
		-- dividend
		A: in std_logic_vector(7 downto 0);
		-- divisor
		B: in std_logic_vector(7 downto 0);
		-- quotient
		Q: out std_logic_vector(7 downto 0);
		-- remainder
		R: out std_logic_vector(7 downto 0);
		-- start division.
		start: in std_logic;
		-- done with division
		done: out std_logic;
		-- clock (use rising edge), reset-active-high.
		clk, reset: in std_logic
		);
end entity UDivider;

architecture Struct of UDivider is
   signal T0,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11, S: std_logic;
begin

    CP: ControlPath 
	     port map(T0 => T0,
			T1 => T1, 
			T2 => T2,
			T3 => T3,
			T4 => T4,
 			T5 => T5,
			T6 => T6,
			T7 => T7,
			T8 => T8,
			T9 => T9,
			T10 => T10,
			T11 => T11,
			S => S,
			start => start,
			done => done,
			reset => reset,
			clk => clk);

    DP: DataPath
	     port map (A => A,
	     	B => B,
	     	Q => Q,
	     	R => R,
	     	T0 => T0,
			T1 => T1, 
			T2 => T2,
			T3 => T3,
			T4 => T4,
 			T5 => T5,
			T6 => T6,
			T7 => T7,
			T8 => T8,
			T9 => T9,
			T10 => T10,
			T11 => T11,
			S => S,
			reset => reset,
			clk => clk);
end Struct;