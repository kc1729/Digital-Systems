library ieee;
use ieee.std_logic_1164.all;
package divider is
  component UDivider is
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
  end component UDivider;

  component ControlPath is
  port (
    T0,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11: out std_logic;
    S: in std_logic;
    -- start division.
    start: in std_logic;
    -- done with division
    done: out std_logic;
    clk, reset: in std_logic
    );
  end component;

  component DataPath is
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
  end component;

  component dataregister is
    generic (data_width:integer);
    port (Din: in std_logic_vector(data_width-1 downto 0);
        Dout: out std_logic_vector(data_width-1 downto 0);
        clk, enable: in std_logic);
  end component;

  -- produces sum with carry (included in result).
  component subtractor is
        port (A, B: in std_logic_vector(7 downto 0); RESULT: out std_logic_vector(7 downto 0));
  end component subtractor;
  
  -- 6-std_logic decrementer.
  component decrement is
        port (A: in std_logic_vector(3 downto 0); B: out std_logic_vector(3 downto 0));
  end component decrement;

  component comparator is
   port (A, B: in std_logic_vector(7 downto 0); comp: out std_logic);
  end component;
end package;