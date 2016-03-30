library ieee;
use ieee.std_logic_1164.all;
library work;
use work.divider.all;

entity DataPath is
	port (
		T0,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11: in std_logic;
		S: out std_logic;
        -- dividend
        A: in std_logic_vector(7 downto 0);
        -- divisor
        B: in std_logic_vector(7 downto 0);
        -- quotient
        Q: out std_logic_vector(7 downto 0);
        -- remainder
        R: out std_logic_vector(7 downto 0);
		clk, reset: in std_logic
	    );
end entity;

architecture Mixed of DataPath is
    signal BREG, quotient1 , remainder1: std_logic_vector(7 downto 0);
    signal COUNT: std_logic_vector(3 downto 0);
    signal AREG: std_logic_vector(15 downto 0);
    signal comp :std_logic_vector(0 downto 0);
    signal comp_in1 : std_logic_vector(0 downto 0);

    signal comp_in :std_logic;
    signal BREG_in, quotient_in, quotient_up, remainder_in: std_logic_vector(7 downto 0);
    signal COUNT_in: std_logic_vector(3 downto 0);
    signal AREG_in: std_logic_vector(15 downto 0);
    signal AREG_dummy: std_logic_vector(15 downto 0);
   
    signal subA,subB: std_logic_vector(7 downto 0);
    signal subRESULT: std_logic_vector(7 downto 0);

    signal decrIn, decrOut, count_reg_in: std_logic_vector(3 downto 0);
    constant C17 : std_logic_vector(3 downto 0) := "1001";
    constant C0 : std_logic_vector(0 downto 0) := "0";
    constant C5 : std_logic_vector(3 downto 0) := "0000";
    constant C16 : std_logic_vector(7 downto 0) := (others => '0');
    constant C64 : std_logic_vector(63 downto 0) := (others => '0');

    signal count_enable, 
            areg_enable, breg_enable, quotient_enable, remainder_enable, comp_enable, qresult_enable: std_logic;

begin
    
    S <= '1' when (COUNT = C5) else '0';

    --------------------------------------------------------
    --  count-related logic
    --------------------------------------------------------
    -- decrementer
    decr: decrement port map (A => COUNT, B => decrOut);

    -- count register.
    count_enable <=  (T0 or T1);
    COUNT_in <= decrOut when T1 = '1' else C17;
    count_reg: DataRegister 
                   generic map (data_width => 4)
                   port map (Din => COUNT_in,
                             Dout => COUNT,
                             Enable => count_enable,
                             clk => clk);

    -------------------------------------------------
    -- AREG related logic.
    -------------------------------------------------
    areg_enable <= (T3 or T5 or T8);
    subA <= AREG(15 downto 8);
    subB <= BREG when (comp(0) = '1') else C16;
    sinst: subtractor port map (A => subA, B => subB, RESULT => subRESULT);
    AREG_dummy(15 downto 8) <= subRESULT;
    AREG_dummy(7 downto 0) <= AREG(7 downto 0);

    AREG_in <= C16 & A when T3 = '1' else
               (AREG(14 downto 0) & C0) when T5 = '1' else
               subRESULT & AREG(7 downto 0);

    ar: DataRegister
             generic map (data_width => 16)
             port map (
			 Din => AREG_in, Dout => AREG,
				Enable => areg_enable, clk => clk);
    

    
    -------------------------------------------------
    -- BREG related logic..
    -------------------------------------------------
    BREG_in <= B;  -- not really needed, just being consistent.
    breg_enable <= T2;
    br: DataRegister generic map(data_width => 8)
            port map (Din => BREG_in, Dout => BREG, Enable => breg_enable, clk => clk);
   
    -------------------------------------------------
    -- comp related logic..
    -------------------------------------------------
    comp1 : comparator port map (A => AREG(15 downto 8), B => BREG, comp => comp_in);
    comp_in1(0) <= comp_in;
    comp_enable <= T11;

    compr: DataRegister generic map(data_width => 1)
            port map (Din => comp_in1, Dout => comp, Enable => comp_enable, clk => clk);

    -------------------------------------------------
    -- RESULT related logic
    -------------------------------------------------
    quotient_in <= (quotient_up(6 downto 0) & C0) when T6 = '1' else
                   (quotient_up(7 downto 1) & comp) when T7 = '1' else
                    C16;
    quotient_enable <= (T7 or T4 or T6);
    qr: DataRegister generic map(data_width => 8)
            port map(Din => quotient_in, Dout => quotient_up, Enable => quotient_enable, clk => clk);

    quotient1 <= quotient_up;
    qresult_enable <= T9;
    rr: DataRegister generic map(data_width => 8)
            port map(Din => quotient1, Dout => Q, Enable => qresult_enable, clk => clk);


    remainder_in <= AREG(15 downto 8);
    remainder_enable <= T10;
    remr: DataRegister generic map(data_width => 8)
            port map(Din => remainder_in, Dout => R, Enable => remainder_enable, clk => clk);


end Mixed;
