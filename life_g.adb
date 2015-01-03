package body Life_g is

   function T2I (C : Cell) return Integer is
   begin
      return Cell'Pos (C);
   end T2I;

   function Life_Rules (From : Table; X : X_Index; Y : Y_Index) return Cell is
      X_Minus : X_Index := X - 1;
      X_Plus : X_Index := X + 1;
      Y_Minus : Y_Index := Y - 1;
      Y_Plus : Y_Index := Y + 1;
      Total : Integer;
   begin
      Total :=
        T2I (From (X_Minus, Y_Minus)) + 
        T2I (From (X,       Y_Minus)) + 
        T2I (From (X_Plus,  Y_Minus)) + 
        T2I (From (X_Minus, Y      )) + 
        T2I (From (X_Plus,  Y      )) + 
        T2I (From (X_Minus, Y_Plus )) + 
        T2I (From (X,       Y_Plus )) + 
        T2I (From (X_Plus,  Y_Plus ));
      if From (X, Y) = Alive then
         if Total < 2 or Total > 3 then
            return Dead;
         else
            return Alive;
         end if;
      else  -- Dead
         if Total = 3 then
            return Alive;
         else
            return Dead;
         end if;
      end if;
   end Life_Rules;
         
     
   function Calc (From : Table) return Table is
      Res : Table;
   begin
      for Y in Y_Index'range loop
         for X in X_Index'range loop
            Res (X, Y) := Life_Rules(From, X, Y);
         end loop;
      end loop;
      return Res;
   end Calc;
     
   procedure Propagate (T : in out Table) is
   begin
      T := Calc (T);
   end Propagate;

   procedure Kill_All (T : in out Table) is
   begin
      T := Empty_Table;
   end Kill_All;

   procedure Set
     (T : in out Table;
      X : X_Index;
      Y : Y_Index;
      Value : Cell := Alive) is
   begin
      T (X, Y) := Value;
   end Set;

   function Get (T : Table; X : X_Index; Y : Y_Index) return Cell is
   begin
      return T (X, Y);
   end Get;

   procedure Write
     (T : Table;
      To_File : Ada.Text_IO.File_Type := Ada.Text_IO.Standard_Output) is
   begin
      for Y in Y_Index'range loop
         for X in X_Index'range loop
            if T (X, Y) = Alive then
               Ada.Text_IO.Put (To_File, 'o');
            else
               Ada.Text_IO.Put (To_File, ' ');
            end if;
         end loop;
         Ada.Text_IO.New_Line (To_File);
      end loop;
   end Write;

   function Read
     (From_File : Ada.Text_IO.File_Type := Ada.Text_IO.Standard_Input)
   return Table is
      Ch : Character;
      T : Table;
   begin
      for Y in Y_Index'range loop
         for X in X_Index'range loop
            Ada.Text_IO.Get (From_File, Ch);
            if Ch = 'o' then
               T (X, Y) := Alive;
            else
               T (X, Y) := Dead;
            end if;
         end loop;
         Ada.Text_IO.Skip_Line (From_File);
      end loop;
      return T;
   end Read;

end Life_g;
