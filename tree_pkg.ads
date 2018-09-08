pragma Ada_2012;
--  Make sure compiler uses Ada 2012 options

package tree_pkg is

   subtype Op_Chr is Character
      with Static_Predicate => Op_Chr in '+' | '-' | '*' | '/' | '^';
   --  The Static_Predicate is a 2012 option.  It can safely be removed

   
   type Tree is private;

   function new_tree(i: Integer) return Tree;
   function new_tree(o: Op_Chr; L, R : Tree) return Tree;
   --  Create some new trees

   function eval(n : Tree) return Integer;
   function size(n : Tree) return Integer;
   --  How many nodes in the tree

   procedure pretty_print (n : Tree);
   --  Print tree, with root first

   procedure infix_print (n : Tree);
   --  Print tree in infix order, with parentheses

   procedure infix_print_no_parens (n : Tree);
   --  Print tree in infix order, as a tree

   procedure print_rpn (n : Tree);
   --  Print tree in rpn order

private
   type Node(<>);
   --  Type Node will have a discriminant

   type Tree is access Node;

   type NodeKind is (int, oper);
   --  Two kinds of nodes

   --  Desciminant kind determines the fields
   type Node (kind : NodeKind) is record
      size : Natural := 1;

      -- Fields depend on discriminant
      case kind is
         when int => 
            intval: Integer;
         when oper => 
            opval: Op_Chr;
            left, right: Tree;
      end case;

   end record;

end tree_pkg;

