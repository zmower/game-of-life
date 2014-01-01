with Ada.Text_IO;

package body Life is

   function T2I (C : Cell) return Integer is
   begin
      if C = Alive then
         return 1;
      else
         return 0;
      end if;
   end T2I;

   function Life_Rules (From : Table; I, J : Index) return Cell is
      I_Minus : Index := I - 1;
      I_Plus : Index := I + 1;
      J_Minus : Index := J - 1;
      J_Plus : Index := J + 1;
      Total : Integer;
   begin
      Total :=
        T2I (From (I_Minus, J_Minus)) + 
        T2I (From (I,       J_Minus)) + 
        T2I (From (I_Plus,  J_Minus)) + 
        T2I (From (I_Minus, J      )) + 
        T2I (From (I_Plus,  J      )) + 
        T2I (From (I_Minus, J_Plus )) + 
        T2I (From (I,       J_Plus )) + 
        T2I (From (I_Plus,  J_Plus ));
      if From (I, J) = Alive then
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
     for i in Index'range loop
        for j in Index'range loop
           Res (i, j) := Life_Rules(From, i, j);
         end loop;
      end loop;
      return Res;
   end Calc;
     
   procedure Tick (T : in out Table) is
   begin
      T := Calc (T);
   end Tick;

   procedure Clear (T : in out Table) is
   begin
      for I in Index'range loop
         for J in Index'range loop
            T (I, J) := Dead;
         end loop;
      end loop;
   end Clear;

   procedure Set (T : in out Table; X, Y : Index; Value : Cell := Alive) is
   begin
      T (X, Y) := Value;
   end Set;

   function Get (T : Table; X, Y : Index) return Cell is
   begin
      return T (X, Y);
   end Get;

   procedure Print (T : Table) is
   begin
      for I in Index'range loop
         for J in Index'range loop
            if T (I, J) = Alive then
               Ada.Text_IO.Put ('X');
            else
               Ada.Text_IO.Put (' ');
            end if;
         end loop;
         Ada.Text_IO.New_Line;
      end loop;
      Ada.Text_IO.New_Line;
      Ada.Text_IO.Put_Line ("---");
      Ada.Text_IO.New_Line;
   end Print;

end Life;
