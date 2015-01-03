with Ada.Text_IO;
with Life_g;
with System.Assertions;

procedure Test_Life is

   type Index_X is mod 16;
   type Index_Y is mod 16;
   package Life is new Life_g (Index_X, Index_Y);
   T, U, V : Life.Table := Life.Empty_Table;
   use type Life.Cell;

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

   Life.Set (T, 0, 0);
   Life.Set (T, 1, 1);
   Life.Set (T, 2, 2);
   Life.Set (T, 2, 2);
   Life.Set (T, 2, 3);
   Life.Set (T, 2, 4);
   Life.Set (T, 2, 5);

   pragma Assert (Life.Get (T, 0, 0) = Life.Alive, "Set/Get failed");
   pragma Assert (Life.Get (T, 1, 1) = Life.Alive, "Set/Get failed");
   pragma Assert (Life.Get (T, 2, 3) = Life.Alive, "Set/Get failed");
   pragma Assert (Life.Get (T, 2, 4) = Life.Alive, "Set/Get failed");
   pragma Assert (Life.Get (T, 2, 5) = Life.Alive, "Set/Get failed");

   declare
      F : Ada.Text_IO.File_Type;
   begin
      Ada.Text_IO.Create (File => F, Name => "test_output.txt");
      Life.Write (T, F);
      Ada.Text_IO.Close (F);
   end;

   U := T;

   Life.Kill_All (T);

   for X in Index_X'range loop
      for Y in Index_Y'range loop
         pragma Assert (Life.Get (T, X, Y) = Life.Dead, "Didn't kill all life");
         null;
      end loop;
   end loop;

   declare
      F : Ada.Text_IO.File_Type;
      use type Life.Table;
   begin
      Ada.Text_IO.Open
        (File => F,
         Mode => Ada.Text_IO.In_File,
         Name => "test_output.txt"); 
      V := Life.Read (F);
      pragma Assert (U = V, "Read failed");
   end;

   Life.Propagate (V);

   -- Alive and now..
   pragma Assert (Life.Get (V, 0, 0) = Life.Dead, "00 propagation error");
   pragma Assert (Life.Get (V, 1, 1) = Life.Alive, "11 propagation error");
   pragma Assert (Life.Get (V, 2, 2) = Life.Alive, "22 propagation error");
   pragma Assert (Life.Get (V, 2, 3) = Life.Alive, "23 propagation error");
   pragma Assert (Life.Get (V, 2, 4) = Life.Alive, "24 propagation error");
   pragma Assert (Life.Get (V, 2, 5) = Life.Dead, "25 propagation error");
   -- Dead and now Alive..
   pragma Assert (Life.Get (V, 1, 2) = Life.Alive, "12 propagation error");
   pragma Assert (Life.Get (V, 3, 3) = Life.Alive, "33 propagation error");
   pragma Assert (Life.Get (V, 3, 4) = Life.Alive, "34 propagation error");
   -- Dead and still Dead..
   pragma Assert (Life.Get (V, 3, 5) = Life.Dead, "35 propagation error");

end Test_Life;
