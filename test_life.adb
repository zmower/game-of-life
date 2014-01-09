with Ada.Text_IO;
with Life;

procedure Test_Life is

   A : Life.Cell;

begin

   A := Life.Dead;
   Ada.Text_IO.Put_Line (Integer'Image (Life.Cell'Pos (A)));

   A := Life.Alive;
   Ada.Text_IO.Put_Line (Integer'Image (Life.Cell'Pos (A)));

end Test_Life;
