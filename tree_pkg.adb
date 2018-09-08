-- Name: Chris Rand
-- Date: April 23th, 2018
-- Course: ITEC 320 Procedural Analysis and Design
-- Implementation of tree package

pragma Ada_2012;
with ada.text_io; use ada.text_io;
with ada.integer_text_io; use ada.integer_text_io;

package body tree_pkg is
   ----------------------------------------------------------
   -- Purpose: Creates a new integer tree
   -- Parameters: i: Integer to put on tree
   -- Precondition: valid integer passed
   -- Postcondition: one element tree returned
   ----------------------------------------------------------
   function new_tree(i: Integer) return Tree is
      t: Tree; --tree to hold i and return
   begin
      t := new Node(int);
      t.intval := i;
      return t;
   end new_tree;

   ----------------------------------------------------------
   -- Purpose: Creates a new op tree
   -- Parameters: o: op for node, l,r: trees for l/r leaves
   -- Precondition: elements exist for L/R, valid opchar
   -- Postcondition: tree returned with o node and l/r leaves
   ----------------------------------------------------------
   function new_tree(o: Op_Chr; L, R : Tree) return Tree is
      t: Tree; --tree to hold new nodes/return
   begin
      t := new Node(oper);
      t.opval := o;
      t.left := L;
      t.right := R;
	t.size := 1 + L.size + R.size; -- adjusts size for large trees
      return t;
   end new_tree;

   ----------------------------------------------------------
   -- Purpose: Evaluates integers according to passed op
   -- Parameters: l,r: integers to evaluate, op: operation to use
   -- Precondition: valid op passed
   -- Postcondition: Integer returned with evaluation value
   ----------------------------------------------------------
   function evalOp(l,r: Integer; op: Character) return Integer is
   begin
      case op is
         when '+' => return (l + r);
         when '-' => return (l - r);
         when '/' => return (l / r);
         when '*' => return (l * r);
         when '^' => return (l ** r);
         when others => return 0;
      end case;
   end evalOp;

   ----------------------------------------------------------
   -- Purpose: Evaluates entire tree
   -- Parameters: n: Tree to eval
   -- Precondition: tree is not empty
   -- Postcondition: returns Integer with eval value
   ----------------------------------------------------------
   function eval(n : Tree) return Integer is
   begin
      if n.size /= 1 then --det. how to evaluate or call recursively
   	   if n.left.size = 1 and n.right.size = 1 then
   	      return evalOp(n.left.intval, n.right.intval, n.opval);
   	   elsif n.left.size /= 1 and n.right.size = 1 then
   		return evalOp(eval(n.left), n.right.intval, n.opval);
   	   elsif n.left.size = 1 and n.right.size /= 1 then
   		return evalOp(n.left.intval, eval(n.right), n.opval);
   	   else
   		return evalOp(eval(n.left), eval(n.right), n.opval);
   	   end if;
   	else
   	   return n.intval;
      end if;
   end eval;

   ----------------------------------------------------------
   -- Purpose: Gets size of tree (# of nodes)
   -- Parameters: n: tree to get size of
   -- Precondition: n is valid tree
   -- Postcondition: Integer with # of nodes returned
   ----------------------------------------------------------
   function size(n : Tree) return Integer is
   begin
      return n.size;
   end size;

   ----------------------------------------------------------
   -- Purpose: Recursive helper for pretty print
   -- Parameters: n: tree to print, d: counter for indentation
   -- Precondition: Valid tree passed
   -- Postcondition: Tree is printed to output in root first order
   ----------------------------------------------------------
   procedure pretty_print(n: Tree; d: in out Integer) is
   dCopy: Integer := d; --used to preserve count
   begin
      if n.size /= 1 then
         for i in 1..dCopy loop
            put("   ");
         end loop;
         put(n.opval);
         new_line;
         d := dCopy + 1; -- increment d
         pretty_print(n.left,d);
         d := dCopy + 1; -- adjust d after recursion
         pretty_print(n.right,d);
         d := dCopy + 1; -- adjust d after recursion
      else
         for i in 1..dCopy loop
            put("   ");
         end loop;
         put(n.intval, width => 0);
         new_line;
      end if;
   end pretty_print;

   ----------------------------------------------------------
   -- Purpose: Prints tree in root first order
   -- Parameters: n: tree to print
   -- Precondition: Valid tree passed
   -- Postcondition: Tree is printed to output in root first order
   ----------------------------------------------------------
   procedure pretty_print (n : Tree) is
   d: Integer := 0; --counter for recursive calls
   begin
      if n.size /= 1 then
         d := 1;
	   put(n.opval);
	   new_line;
	   pretty_print(n.left, d);
         d := 1;
         pretty_print(n.right, d);
	 else
	   put(n.intval, width => 0);
	 end if;
   end pretty_print;

   ----------------------------------------------------------
   -- Purpose: Prints tree in infix with parens
   -- Parameters: n: tree to print
   -- Precondition: Valid tree passed
   -- Postcondition: Tree is printed to output in infix order with paren
   ----------------------------------------------------------
   procedure infix_print (n : Tree) is
   begin
      if n.size = 1 then
	   put(n.intval, width => 0);
	else --recursively calls infix print
         put("(");
	   infix_print(n.left);
	   put(n.opval);
	   infix_print(n.right);
	   put(")");
	end if;
   end infix_print;

   ----------------------------------------------------------
   -- Purpose: Recursive helper for infix_print_no_parens
   -- Parameters: n: tree to print, d: counter for indentation
   -- Precondition: Valid tree passed
   -- Postcondition: Tree is printed to output in infix order
   ----------------------------------------------------------
   procedure infix_print_no_parens(n: Tree; d: in out Integer) is
   dCopy: Integer := d; --copy of d for recursive calls
   begin
      if n.size /= 1 then
         d := dCopy + 1; -- increment depth
         infix_print_no_parens(n.left, d);
         for i in 1..dCopy loop
	      put("   ");
	   end loop;
	   put(n.opval);
         new_line;
         d := dCopy + 1; --voodoo magic (resets d after recursion)
	   infix_print_no_parens(n.right, d);
         d := dCopy + 1; --voodoo magic (resets d after recursion)
      else
         for i in 1..dCopy loop
		put("   ");
	   end loop;
         put(n.intval, width => 0);
         new_line;
      end if;
   end infix_print_no_parens;

   ----------------------------------------------------------
   -- Purpose: Prints tree in infix order
   -- Parameters: n: tree to print
   -- Precondition: Valid tree passed
   -- Postcondition: Tree is printed to output in infix order
   ----------------------------------------------------------
   procedure infix_print_no_parens (n : Tree) is
   d: Integer := 0; --counter for recursive call
   begin
      if n.size = 1 then
         put(n.intval, width => 0);
      else --calls recursive variant of procedure
         d := 1;
         infix_print_no_parens(n.left, d);
         put(n.opval);
         new_line;
         d := 1;
         infix_print_no_parens(n.right, d);
      end if;
   end infix_print_no_parens;

   ----------------------------------------------------------
   -- Purpose: Prints tree in rpn format
   -- Parameters: n: tree to print
   -- Precondition: Valid tree passed
   -- Postcondition: Tree is printed as RPN expression
   ----------------------------------------------------------
   procedure print_rpn (n : Tree) is
   begin
      if n.size = 1 then
	   put(n.intval, width => 0);
	else --calls print rpn recursively
	   print_rpn(n.left);
	   put(" ");
	   print_rpn(n.right);
	   put(" ");
	   put(n.opval);
	end if;
   end print_rpn;

end tree_pkg;