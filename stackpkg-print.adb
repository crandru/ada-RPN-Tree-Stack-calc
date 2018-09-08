-- Name: Chris Rand
-- Date: April 23th, 2018
-- Course: ITEC 320 Procedural Analysis and Design
-- Implementation of stackpkg-print extension of stackpkg

with ada.text_io; use ada.text_io;
with ada.integer_text_io; use ada.integer_text_io;

package body stackpkg.print is
   Stack_Empty: exception;
   ----------------------------------------------------------
   -- Purpose: Prints the stack according to passed procedure
   -- Parameters: S: stack to print, p: procedure to use
   -- Precondition: procedure is appropriate for stack
   -- Postcondition: procedure run for each stack element
   ----------------------------------------------------------
   procedure print_stack(S: Stack; p: Print_Item_Access) is
      Temp_Pointer: StackNodePtr := S.head; --pointer for traversal
   begin
      if not is_Empty(S) then
         loop
            p(Temp_Pointer.item); --calls proc
		Set_Col(1); --sneaky way to det. if new line
            exit when Temp_Pointer.next = null;
            Temp_Pointer := Temp_Pointer.next;
         end loop;
      else
         raise Stack_Empty;
      end if;
   end print_stack;

   ----------------------------------------------------------
   -- Purpose: Prints the stack according to passed function
   -- Parameters: S: stack to print, p: procedure to use
   -- Precondition: function is appropriate for stack
   -- Postcondition: function run for each stack element
   ----------------------------------------------------------
   procedure print_stack(S: Stack; p: access function (i: itemtype)
	return Integer) is
      Temp_Pointer: StackNodePtr := S.head; --pointer for traversal
   begin
      if not is_Empty(S) then
         loop
            put(p(Temp_Pointer.item), width => 0); --calls func
		new_line;
            exit when Temp_Pointer.next = null;
            Temp_Pointer := Temp_Pointer.next;
         end loop;
      else
         raise Stack_Empty;
      end if;
   end print_stack;

end stackpkg.print;