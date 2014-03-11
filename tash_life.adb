with Ada.Text_IO;
with CArgv;
with Interfaces.C;
with Life_g;
with Tcl.Ada;
with Tcl.Tk.Ada;

procedure Tash_Life is

   Dquot : constant Character := '"';

   type Index_X is mod 40;
   type Index_Y is mod 16;
   package Life is new Life_G (Index_X, Index_Y);
   Tash_Table : Life.Table := Life.Empty_Table;

   package Index_X_IO is new Ada.Text_IO.Modular_IO(Index_X);

   function To_String (X : Index_X) return String is
     Xs : String (1..2);
   begin
      Index_X_IO.Put (Xs, X);
      if X < 10 then
         return Xs (2..2);
      else
         return Xs;
      end if;
   end To_String;

   package Index_Y_IO is new Ada.Text_IO.Modular_IO(Index_Y);

   function To_String (Y : Index_Y) return String is
     Ys : String (1..2);
   begin
      Index_Y_IO.Put (Ys, Y);
      if Y < 10 then
         return Ys (2..2);
      else
         return Ys;
      end if;
   end To_String;

   package CreateCommands is new Tcl.Ada.Generic_Command (Integer);

   Argc : Interfaces.C.int;
   Argv : CArgv.Chars_Ptr_Ptr;
   Interp : Tcl.Tcl_Interp;
   Command : Tcl.Tcl_Command;
   pragma Unreferenced (Command);

   -- Life's widgets
   Toggle_Btns : array (Index_X, Index_Y) of Tcl.Tk.Ada.Button;
   Propagate_Btn : Tcl.Tk.Ada.Button;

   function Propagate_Command
     (ClientData : in Integer;
      Interp     : in Tcl.Tcl_Interp;
      Argc       : in Interfaces.C.int;
      Argv       : in CArgv.Chars_Ptr_Ptr)
      return       Interfaces.C.int;
   pragma Convention (C, Propagate_Command);
   --  Declare a procedure, suitable for creating a Tcl command,
   --  which will Generate Life when the Generate button is pressed.

   function Propagate_Command
     (ClientData : in Integer;
      Interp     : in Tcl.Tcl_Interp;
      Argc       : in Interfaces.C.int;
      Argv       : in CArgv.Chars_Ptr_Ptr)
      return       Interfaces.C.int is

      pragma Unreferenced (ClientData, Interp, Argc, Argv);

   begin

      Life.Propagate (Tash_Table);

      for Y in Index_Y'range loop

         for X in Index_X'range loop

            declare
              C : Life.Cell := Life.Get (Tash_Table, X, Y);
              NV : String (1..1);
              use Life;
            begin

               if C = Dead then
                  NV (1) := ' ';
               else
                  NV (1) := 'o';
               end if;

               Tcl.Tk.Ada.Configure
                 (Toggle_Btns (X, Y),
                  "-text " & Dquot & NV & Dquot);

            end;

         end loop;

      end loop;

      return Tcl.TCL_OK;

   end Propagate_Command;


   function Toggle_Command
     (ClientData : in Integer;
      Interp     : in Tcl.Tcl_Interp;
      Argc       : in Interfaces.C.int;
      Argv       : in CArgv.Chars_Ptr_Ptr)
      return       Interfaces.C.int;
   pragma Convention (C, Toggle_Command);
   --  Declare a procedure, suitable for creating a Tcl command,
   --  which will toggle the state of individual life buttons

   function Toggle_Command
     (ClientData : in Integer;
      Interp     : in Tcl.Tcl_Interp;
      Argc       : in Interfaces.C.int;
      Argv       : in CArgv.Chars_Ptr_Ptr)
      return       Interfaces.C.int is

      pragma Unreferenced (ClientData, Interp, Argc);

      Widget_Name : String := CArgv.Arg (Argv, 1);
      X_Str : String := CArgv.Arg (Argv, 2);
      Y_Str : String := CArgv.Arg (Argv, 3);
      X : Index_X := Index_X'Value (X_Str);
      Y : Index_Y := Index_Y'Value (Y_Str);
      C : String := Tcl.Tk.Ada.CGet (Toggle_Btns (X, Y), "-text");
      NV : String (1..1);

   begin

      if C = "o" then
         NV (1) := ' ';
         Life.Set (Tash_Table, X, Y, Life.Dead);
      else
         NV (1) := 'o';
         Life.Set (Tash_Table, X, Y, Life.Alive);
      end if;

      Tcl.Tk.Ada.Configure (Toggle_Btns (X, Y), "-text " & Dquot & NV & Dquot);

      return Tcl.TCL_OK;

   end Toggle_Command;

   use type Interfaces.C.int;

begin

   --  Get command-line arguments and put them into C-style "argv"
   --------------------------------------------------------------
   CArgv.Create (Argc, Argv);

   --  Tcl needs to know the path name of the executable
   --  otherwise Tcl.Tcl_Init below will fail.
   ----------------------------------------------------
   Tcl.Tcl_FindExecutable (Argv.all);

   --  Create one Tcl interpreter
   -----------------------------
   Interp := Tcl.Tcl_CreateInterp;

   --  Initialize Tcl
   -----------------
   if Tcl.Tcl_Init (Interp) = Tcl.TCL_ERROR then
      Ada.Text_IO.Put_Line
        ("Tash_Life: Tcl.Tcl_Init failed: " &
         Tcl.Ada.Tcl_GetStringResult (Interp));
      return;
   end if;

   --  Initialize Tk
   ----------------
   if Tcl.Tk.Tk_Init (Interp) = Tcl.TCL_ERROR then
      Ada.Text_IO.Put_Line ("Cannot run GUI version of Tash_Life: ");
      Ada.Text_IO.Put_Line ("   " & Tcl.Ada.Tcl_GetStringResult (Interp));
      return;
   end if;

   --  Set the Tk context so that we may use shortcut Tk
   --  calls that require reference to the interpreter.
   ----------------------------------------------------
   Tcl.Tk.Ada.Set_Context (Interp);

   --  Create several new Tcl commands to call Ada subprograms
   ----------------------------------------------------------
   Command :=
      CreateCommands.Tcl_CreateCommand
        (Interp,
         "Propagate",
         Propagate_Command'Access,
         0,
         null);

   Command :=
      CreateCommands.Tcl_CreateCommand
        (Interp,
         "Toggle",
         Toggle_Command'Access,
         0,
         null);

   -- Create the grid of buttons upon which life is created.
   for Y in Index_Y'range loop

      for X in Index_X'range loop

         declare
            X_Str : String := To_String (X);
            Y_Str : String := To_String (Y);
            Name : String := ".b" & X_Str & "_" & Y_Str;
            Params : String := " " & X_Str & " " & Y_Str;
         begin

            Toggle_Btns (X, Y) := Tcl.Tk.Ada.Create
              (Name,
               "-text " & Dquot & " " & Dquot &
               " -padx 0 -pady 0" &
               " -command " & Dquot & "Toggle " & Name & Params & Dquot);

            Tcl.Ada.Tcl_Eval
              (Interp,
               "grid " & Name &
               " -row " & To_String (Y) &
               " -column " & To_String (X));

         end;

      end loop;

   end loop;

   Propagate_Btn := Tcl.Tk.Ada.Create
                      (".prop", "-text Propagate -command Propagate");

   Tcl.Ada.Tcl_Eval (Interp, "grid .prop -row 20 -column 17 -columnspan 8");

   Tcl.Tk.Tk_MainLoop;

end Tash_Life;
