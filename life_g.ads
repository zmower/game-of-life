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

end Life_g;
