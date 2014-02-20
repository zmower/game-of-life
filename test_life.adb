with Ada.Text_IO;
with Life_g;
with System.Assertions;

procedure Test_Life is

   type Index_X is mod 16;
   type Index_Y is mod 16;
   package Life is new Life_g (Index_X, Index_Y);

begin

   begin
      pragma Assert (False, "Assert Failed");
      Ada.Text_IO.Put_Line ("Not compiled with -gnata (asserts)");
      return;
   exception
      when  System.Assertions.Assert_Failure => null;
   end;

   pragma Assert (Life.Cell'Pos (Life.Dead) = 0, "Life.Dead has wrong value");

   pragma Assert (Life.Cell'Pos (Life.Alive) = 1, "Life.Alive has wrong value");

end Test_Life;
