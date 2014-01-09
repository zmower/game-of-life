with Life;
with Terminal_Interface.Curses.Text_IO;
use Terminal_Interface.Curses;

procedure Terminal_Life is

   -- Cursor position in table
   Cursor_X, Cursor_Y : Life.Index := 0;
   Draw_Cursor : Boolean := True;

   -- Display the Life data in the Curses window.
   -- Also draws the cursor position as an X if this is enabled.
   -- (Drawn initially and when the cursor is moved.
   --  Not drawn when running the simulation.)
   procedure Display (W : Window; T : Life.Table) is
      use type Life.Cell;
   begin

      Clear (W);

      for X in Life.Index'range loop

         for Y in Life.Index'range loop

            if Life.Get (T, X, Y) = Life.Alive then

               Move_Cursor
                 (Win    => W,
                  Column => Column_Position (X),
                  Line   => Line_Position (Y));

               Text_IO.Put (W, '0');

            end if;

         end loop;

      end loop;

      if Draw_Cursor then

        Move_Cursor
          (Win    => W,
           Column => Column_Position (Cursor_X),
           Line   => Line_Position (Cursor_Y));

        Text_IO.Put (W, 'X');

      end if;

      Refresh (W);

   end Display;

   Current : Life.Table;
   ctrl_Z : constant Real_Key_Code := 26;
   Key : Key_Code;
   use type Life.Index;

begin

   Life.Kill_All (Current);

   Init_Screen;

   loop

      Display (Standard_Window, Current);

      Key := Get_Keystroke;

      case Key is

        when ctrl_Z => exit;

        when Key_Cursor_Up | Character'Pos ('w') =>

          Draw_Cursor := True;
          Cursor_Y := Cursor_Y - 1;

        when Key_Cursor_Down | Character'Pos ('s') =>

          Draw_Cursor := True;
          Cursor_Y := Cursor_Y + 1;

        when Key_Cursor_Left | Character'Pos ('a') =>

          Draw_Cursor := True;
          Cursor_X := Cursor_X - 1;

        when Key_Cursor_Right | Character'Pos ('d') =>

          Draw_Cursor := True;
          Cursor_X := Cursor_X + 1;

        when Character'Pos (' ') =>

          Draw_Cursor := False;
          Life.Set (Current, Cursor_X, Cursor_Y);

        when others =>

          Draw_Cursor := False;
          Life.Propagate (Current);

      end case;

   end loop;

   End_Windows;

end Terminal_Life;
