library ieee;
use ieee.std_logic_1164.all;
library std;
use std.textio.all;

entity Testbench is
end entity;
architecture Behave of Testbench is
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

  signal A, B , Q ,R: std_logic_vector(7 downto 0);
  signal start, done: std_logic;
  signal clk: std_logic := '0';
  signal reset: std_logic := '1';

  function to_string(x: string) return string is
      variable ret_val: string(1 to x'length);
      alias lx : string (1 to x'length) is x;
  begin  
      ret_val := lx;
      return(ret_val);
  end to_string;

  function to_std_logic_vector(x: bit_vector) return std_logic_vector is
    alias lx: bit_vector(1 to x'length) is x;
    variable ret_var : std_logic_vector(1 to x'length);
  begin
     for I in 1 to x'length loop
        if(lx(I) = '1') then
           ret_var(I) :=  '1';
        else 
           ret_var(I) :=  '0';
	end if;
     end loop;
     return(ret_var);
  end to_std_logic_vector;

begin
  clk <= not clk after 5 ns; -- assume 10ns clock.

  -- reset process
  process
  begin
     wait until clk = '1';
     reset <= '0';
     wait;
  end process;

  process 
    variable err_flag : boolean := false;
    File INFILE: text open read_mode is "TRACEFILE.txt";
    FILE OUTFILE: text  open write_mode is "OUTPUTS.txt";

    ---------------------------------------------------
    -- edit the next few lines to customize
    variable divisor_var, dividend_var: bit_vector ( 7 downto 0);
    variable quotient_var, remainder_var: bit_vector ( 7 downto 0);
    ----------------------------------------------------
    variable INPUT_LINE: Line;
    variable OUTPUT_LINE: Line;
    variable LINE_COUNT: integer := 0;
    
  begin

    wait until clk = '1';

   
    while not endfile(INFILE) loop 
    	  wait until clk = '0';

          LINE_COUNT := LINE_COUNT + 1;
	
	  readLine (INFILE, INPUT_LINE);
          read (INPUT_LINE, dividend_var);
	        read (INPUT_LINE, divisor_var);
          read (INPUT_LINE, quotient_var);
          read (INPUT_LINE, remainder_var);

          --------------------------------------
          -- from input-vector to DUT inputs
	  A <= to_std_logic_vector(dividend_var);
	  B <= to_std_logic_vector(divisor_var);
          --------------------------------------

          -- set start
          start <= '1';

          -- spin waiting for done
          while (true) loop
             wait until clk = '1';
             start <= '0';
             if(done = '1') then
                exit;
             end if;
          end loop;

          --------------------------------------
	  -- check outputs.
    if (B /= "00000000") then
	  if (Q /= to_std_logic_vector(quotient_var) or R /= to_std_logic_vector(remainder_var) ) then
             write(OUTPUT_LINE,to_string("ERROR: in RESULT, line "));
             write(OUTPUT_LINE, LINE_COUNT);
             writeline(OUTFILE, OUTPUT_LINE);
             err_flag := true;
          end if;
          end if;
          --------------------------------------
    end loop;

    assert (err_flag) report "SUCCESS, all tests passed." severity note;
    assert (not err_flag) report "FAILURE, some tests failed." severity error;

    wait;
  end process;

  dut: UDivider 
     port map(A => A,
              B => B,
              clk => clk,
              reset => reset,
              Q => Q,
              R => R,
              start => start,
              done => done);

end Behave;

