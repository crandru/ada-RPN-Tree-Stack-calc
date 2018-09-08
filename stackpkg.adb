-- Name: Chris Rand
-- Date: April 23th, 2018
-- Course: ITEC 320 Procedural Analysis and Design
-- Implementation of stackpkg

with Unchecked_Deallocation;

package body stackpkg is
   Stack_Empty, Stack_Full: exception;
   ----------------------------------------------------------
   -- Purpose: Disposes of pointer
   -- Parameters: Object: Pointer object, Name: Pointer to remove
   -- Precondition: Valid pointer is passed
   -- Postcondition: Pointer is removed from memory
   ----------------------------------------------------------
   procedure Dispose is
      new Unchecked_Deallocation(Object => StackNode, Name => StackNodePtr);

   ----------------------------------------------------------
   -- Purpose: Checks if the stack is empty
   -- Parameters: S: stack to evaluate
   -- Precondition: Valid stack passed
   -- Postcondition: Boolean returned of stack status
   ----------------------------------------------------------
   function is_Empty(S: Stack) return Boolean is
   begin
      if S.size = 0 then
         return true;
      else
         return false;
      end if;
   end is_Empty;

   ----------------------------------------------------------
   -- Purpose: Checks if the stack is full
   -- Parameters: S: stack to evaluate
   -- Precondition: Valid stack passed
   -- Postcondition: Boolean returned of stack status
   ----------------------------------------------------------
   function is_Full(S: Stack) return Boolean is
      Temp_Pointer : StackNodePtr; --temp pointer to test stack addition
   begin
      Temp_Pointer := new StackNode;
      Dispose(Temp_Pointer);
      return false;
   exception
      when STORAGE_ERROR => return true;
   end is_Full;

   ----------------------------------------------------------
   -- Purpose: Pushes an item onto the stack
   -- Parameters: Item: ele to push, S: stack to push onto
   -- Precondition: Valid element for stack
   -- Postcondition: Outputs stack with new element on top
   ----------------------------------------------------------
   procedure push(i: ItemType; S : in out Stack) is
   begin
      if is_Full(S) then
         raise Stack_Full;
      else
         S.head := new StackNode'(i, S.head);
         S.size := S.size + 1;
      end if;
   end push;

   ----------------------------------------------------------
   -- Purpose: Removes item from stack
   -- Parameters: S: stack to remove from
   -- Precondition: stack is not empty
   -- Postcondition: top of stack is removed and top set to next element
   ----------------------------------------------------------
   procedure pop(S : in out Stack) is
      Temp_Pointer : StackNodePtr; --temp pointer to hold new top
   begin
      if not is_Empty(S) then
         Temp_Pointer := S.head;
         S.head := S.head.all.next;
         Dispose(Temp_Pointer);
         S.size := S.size - 1;
      else
         raise Stack_Empty;
      end if;
   end pop;

   ----------------------------------------------------------
   -- Purpose: Gets top of the stack
   -- Parameters: S: stack to get top from
   -- Precondition: stack is not empty
   -- Postcondition: Returns element of itemtype
   ----------------------------------------------------------
   function top(S: Stack) return ItemType is
   begin
      if not is_Empty(S) then
         return S.head.all.Item;
      else
         raise Stack_Empty;
      end if;
   end top;

   ----------------------------------------------------------
   -- Purpose: Gets size of stack
   -- Parameters: S: stack to get size from
   -- Precondition: Stack is valid
   -- Postcondition: Returns natural of stack size
   ----------------------------------------------------------
   function size(S : Stack) return Natural is
   begin
      return S.size;
   end size;

   ----------------------------------------------------------
   -- Purpose: Clears the stack
   -- Parameters: S: stack to clear
   -- Precondition: Stack is valid
   -- Postcondition: Stack is empty of elements
   ----------------------------------------------------------
   procedure clear(S : in out Stack) is
   begin
      loop
         exit when S.size = 0;
         pop(S);
      end loop;
   end clear;

   ----------------------------------------------------------
   -- Purpose: Prints the stack
   -- Parameters: S: Stack to print
   -- Precondition: Stack is not empty
   -- Postcondition: Prints stack to output
   ----------------------------------------------------------
   procedure print_stack (S: Stack) is
      Temp_Pointer : StackNodePtr := S.head; --pointer to traverse stack
   begin
      if not is_Empty(S) then
         loop
         	putitem(Temp_Pointer.item);
            exit when Temp_Pointer.next = null;
            Temp_Pointer := Temp_Pointer.next;
         end loop;
      else
         raise Stack_Empty;
      end if;
   end print_stack;

end stackpkg;