with Life;
with Terminal_Interface.Curses.Text_IO;
use Terminal_Interface.Curses;

procedure Terminal_Life is

   -- Cursor position in table
   X, Y : Life.Index := 0;
   Draw_Cursor : Boolean := True;

   procedure Print (W : Window; T : Life.Table) is
      use Life;
   begin
      Clear (W);
      for I in Index'range loop
         for J in Index'range loop
            if Get (T, X => I, Y => J) = Alive then
               Move_Cursor (W, Line_Position (J), Column_Position (I));
               Text_IO.Put (W, '0');
            end if;
         end loop;
      end loop;
      if Draw_Cursor then
        Move_Cursor (W, Line_Position (Y), Column_Position (X));
        Text_IO.Put (W, 'X');
      end if;
      Refresh (W);
   end Print;

   Current : Life.Table;
   Iteration : constant := 40;
   ctrl_Z : constant Real_Key_Code := 26;
   Key : Key_Code;
   use Life;

begin

   Clear (Current);

   Init_Screen;

   -- Press ctrl-Z to exit or any other key to advance.
   loop

      Print (Standard_Window, Current);

      Key := Get_Keystroke;
      case Key is
        when ctrl_Z => exit;
        when Key_Cursor_Up | Character'Pos ('w') =>
          Draw_Cursor := True;
          Y := Y - 1;
        when Key_Cursor_Down | Character'Pos ('s') =>
          Draw_Cursor := True;
          Y := Y + 1;
        when Key_Cursor_Left | Character'Pos ('a') =>
          Draw_Cursor := True;
          X := X - 1;
        when Key_Cursor_Right | Character'Pos ('d') =>
          Draw_Cursor := True;
          X := X + 1;
        when Character'Pos (' ') =>
          Draw_Cursor := False;
          Life.Set (Current, X, Y);
        when others =>
          Draw_Cursor := False;
          Life.Tick (Current);
      end case;

   end loop;

   End_Windows;

end Terminal_Life;
