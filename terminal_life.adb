with Life;
with Terminal_Interface.Curses.Text_IO;
use Terminal_Interface.Curses;

procedure Terminal_Life is

   procedure Populate (T : in out Life.Table) is
      use Life;
   begin
      Clear (T);
      for I in Index'range loop
         for J in Index'range loop
            if I + J mod 7 = 0 or I mod 3 = 0 then
               Set (T, I, J);
            end if;
         end loop;
      end loop;
   end Populate;

   procedure Print (W : Window; T : Life.Table) is
      use Life;
   begin
      Clear (W);
      for I in Index'range loop
         for J in Index'range loop
            if Get (T, I, J) = Alive then
               Move_Cursor (W, Line_Position (I), Column_Position (J));
               Text_IO.Put (W, 'X');
            end if;
         end loop;
      end loop;
      Refresh (W);
   end Print;

   Current : Life.Table;
   Iteration : constant := 40;
   ctrl_Z : constant := 26;

begin
   Populate (Current);
   Init_Screen;
--   for i in 1  .. Iteration loop
   -- Press ctrl-Z to exit or any other key to advance.
   while Get_Keystroke /= ctrl_Z loop
      Print (Standard_Window, Current);
--      delay 1.0;
      Life.Tick (Current);
   end loop;
   End_Windows;
end Terminal_Life;
