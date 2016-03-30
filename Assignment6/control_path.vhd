library ieee;
use ieee.std_logic_1164.all;
library work;
use work.divider.all;
entity ControlPath is
	port (
		T0,T1,T2,T3,T4,T5,T6,T7,T8,T9,T10,T11: out std_logic;
		S: in std_logic;
    -- start division.
    start: in std_logic;
    -- done with division
    done: out std_logic;
		clk, reset: in std_logic
	  );
end entity;

architecture Behave of ControlPath is
   type FsmState is (rst, compare, subtract, update, donestate);
   signal fsm_state : FsmState;
begin

   process(fsm_state, start, S, clk, reset)
      variable next_state: FsmState;
      variable Tvar: std_logic_vector(0 to 11);
      variable done_var: std_logic;
   begin
       -- defaults
       Tvar := (others => '0');
       done_var := '0';
       next_state := fsm_state;

       case fsm_state is 
          when rst =>
               if(start = '1') then
                  next_state := compare;
                  Tvar(0) := '1'; Tvar(2) := '1'; Tvar(3) := '1'; Tvar(4) := '1';
               end if;
          when compare =>
               next_state := subtract;
               Tvar(1) := '1'; Tvar(6) := '1'; Tvar(11) := '1';
          when subtract =>
               next_state := update;
               Tvar(7) := '1'; Tvar(8) := '1';
          when update =>
               Tvar(5) := '1';
               if(S = '1') then
                  Tvar(9) := '1';Tvar(10) := '1';
                  next_state := donestate;
               else
                  next_state := compare;
               end if;
          when donestate =>
               done_var := '1';
               next_state := rst;
     end case;

     T0 <= Tvar(0); T1 <= Tvar(1); T2 <= Tvar(2); T3 <= Tvar(3); T4 <= Tvar(4);
     T5 <= Tvar(5); T6 <= Tvar(6); T7 <= Tvar(7); T8 <= Tvar(8); T9 <= Tvar(9);
     T10 <= Tvar(10); T11 <= Tvar(11); 
     done <= done_var;
  
     if(clk'event and (clk = '1')) then
	      if(reset = '1') then
             fsm_state <= rst;
        else
             fsm_state <= next_state;
        end if;
     end if;
   end process;
end Behave;