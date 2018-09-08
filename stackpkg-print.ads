generic
package stackpkg.print is

   type Print_Item_Access is access procedure (i : ItemType);

   procedure print_stack (s: Stack; p : Print_Item_Access);
   
   procedure print_stack (s: Stack; p : access function (i : itemtype) return Integer);

end stackpkg.print;
