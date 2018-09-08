generic
    type ItemType is private;
    --  What the stack will contain
    
    with procedure putitem(item: itemtype);
    --  How to print a stack element

package stackpkg is

   type Stack is limited private;

   function is_empty(s : Stack) return Boolean;
   function is_full(s : Stack) return Boolean;
   
   function top(s : Stack) return ItemType;
   function size(s : Stack) return Natural;
   --  Number of elements currently on the stack

   procedure push(i: ItemType; s : in out Stack);

   procedure pop(s : in out Stack);
   procedure clear(s : in out Stack);
   --  Remove all elements from the stack

   procedure print_stack  (s: Stack);
   --  Print all elements from the stack, using put_item

private
   type StackNode;
   type StackNodePtr is access StackNode;

   type StackNode is record
      item : ItemType;
      next : StackNodePtr;
   end record;

   type Stack is record
      size : Natural := 0;
      head : StackNodePtr;
   end record;
end stackpkg;
