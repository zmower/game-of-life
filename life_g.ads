--  This generic is OK as long as you know the size of the area you want.
--  Something like finding the screen size at runtime and creating a table
--  that size doesn't work well in Ada (well, it would require pointers
--  and dynamic memory allocation).  An exercise for the reader...

with Ada.Text_IO;

generic
   -- Because Index is a modular type, both edges of the table wrap around.
   -- X aka Column varies from 0 to Width - 1
   type X_Index is mod <>;
   -- Y aka Row varies from 0 to Height - 1
   type Y_Index is mod <>;
package Life_g is

   type Cell is (Dead, Alive);

   type Table is private;

   Empty_Table : constant Table;

   procedure Kill_All (T : in out Table);

   procedure Set
     (T : in out Table;
      X : X_Index;
      Y : Y_Index;
      Value : Cell := Alive);

   function Get (T : Table; X : X_Index; Y : Y_Index) return Cell;

   procedure Propagate (T : in out Table);
     
   procedure Write
     (T : Table;
      To_File : Ada.Text_IO.File_Type := Ada.Text_IO.Standard_Output);

private

   type Table is array (X_Index, Y_Index) of Cell;

   Empty_Table : constant Table  := (others => (others => Dead));

end Life_g;
