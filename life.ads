with Ada.Text_IO;

package Life is

   type Cell is (Dead, Alive);

   --  Because Index is a modular type, both edges of the table wrap around.
   --  i.e. (0 - 1) = 15 and (15 + 1) = 0
   type Index is mod 16;

   type Table is private;

   procedure Kill_All (T : in out Table);

   procedure Set (T : in out Table; X, Y : Index; Value : Cell := Alive);

   function Get (T : Table; X, Y : Index) return Cell;

   procedure Propagate (T : in out Table);
     
   procedure Write
     (T : Table;
      To_File : Ada.Text_IO.File_Type := Ada.Text_IO.Standard_Output);

private

   type Table is array (Index, Index) of Cell;

end Life;
