-- Name: Chris Rand
-- Date: April 20th, 2018
-- Course: ITEC 320 Procedural Analysis and Design

-- Purpose: This program implements a calculator that uses a linked list
-- stack with a linked tree structure to store and process RPN calculations
-- input from standard input with the following ops (+,-,*,/,^?) along with
-- various commands (c,C,e,E,h,H,i,I,j,J,n,N,p,P,r,R,s,S,t,T,q).
-- Input: A series of integers, operators, and command calls.
-- Output: Depends on the command called.
-- Example: Text file with following calculation and commands
-- 2 3 4 * + p q
-- 14 (output)

-- Help received: Material from 320 Course page
-- no outside help.
with ada.text_io; use ada.text_io;
with ada.integer_text_io; use ada.integer_text_io;
with tree_pkg; use tree_pkg;
with stackpkg;
with stackpkg.print;

procedure yarc is

   ----------------------------------------------------------
   -- Purpose: Removes whitespace until valid char reached
   -- Parameters: None
   -- Precondition: File contains valid chars (non whitespace)
   -- Postcondition: Input marker is on valid char
   ----------------------------------------------------------
   procedure find_next is
      c: Character; --holds current character
      eol: Boolean; --identifies end of line
   begin
      loop
         look_ahead(c, eol);
         if eol then
            skip_line;
         elsif c = ' ' then
            get(c);
         else
            exit;
         end if;
      end loop;
   end find_next;

   --putitem uses pretty print by default
   package treeStackPk is new stackpkg(Tree, putitem => pretty_print);
   use treeStackPk;

   package treeStackPkPrint is new treeStackPk.print;
   use treeStackPkPrint;

   ----------------------------------------------------------
   -- Purpose: Processes input and calls respective routines
   -- Parameters: treeStack: stack of trees to eval, quit: boolean flag to quit
   -- Precondition: treeStack is valid stack of trees
   -- Postcondition: Next input character is process and marker moved past
   ----------------------------------------------------------
   procedure process(treeStack: in out treeStackPk.Stack; quit: out Boolean) is
      c: Character; --holds current character
      i: Integer; --Integer to process digits from input
      eol: Boolean; --identifies end of line
      t,l,r: Tree; --trees for node, left, and right
   begin
      look_ahead(c, eol);
      if c in '0'..'9' then --processes pos digits
         get(i);
         t := new_tree(i);
         push(t, treeStack);
      elsif c = '_' then --processes neg digits
         get(c);
         get(i);
         t := new_tree(i * (-1));
         push(t, treeStack);
      elsif c = '+' or c = '-' or c = '*' or c = '/' or c = '^' then --op proc
         get(c);
         r := top(treeStack);
         pop(treeStack);
         l := top(treeStack);
         pop(treeStack);
         t := new_tree(c,l,r);
         push(t, treeStack);
      elsif c = 'c' then --clears top
         get(c);
         pop(treeStack);
      elsif c = 'C' then --clears stack
         get(c);
         clear(treeStack);
      elsif c = 'e' then --evaluates top
         get(c);
         put(eval(top(treeStack)), width => 0);
         new_line;
      elsif c = 'E' then --evaluates entire stack
         get(c);
         print_stack(treeStack, eval'Access);
      elsif c = 'h' then --condensed help output
         get(c);
         put_line("Top: cehijnpqrst.  Stack: CEHIJNPQRST. " &
            "Operators: +-*/^. Negative: _");
      elsif c = 'H' then --full help output
         get(c);
         put_line("cC: clear top (ie pop)/whole stack");
         put_line("eE: evaluate top/whole stack");
         put_line("hH: quick help/full help");
         put_line("iI: infix in parens for top/whole stack");
         put_line("jJ: infix tree for top/whole stack");
         put_line("nN: number tree nodes on top/whole stack");
         put_line("pP: pretty print top/whole stack (like t)");
         put_line("qQ: quit");
         put_line("rR: rpn expression for top/whole stack");
         put_line("sS: stack size");
         put_line("tT: tree on top of stack/whole stack");
         put_line("Operators: +-*/^");
         put_line("Negative Input: _");
      elsif c = 'i' then --prints infix with parens
         get(c);
         infix_print(top(treeStack));
         new_line;
      elsif c = 'I' then --prints entire stack infix paren
         get(c);
         print_stack(treeStack, infix_print'Access);
      elsif c = 'j' then --prints infix as tree
         get(c);
         infix_print_no_parens(top(treeStack));
      elsif c = 'J' then --prints entire stack as infix tree
         get(c);
         print_stack(treeStack, infix_print_no_parens'Access);
      elsif c = 'n' then --gets size of top tree
         get(c);
         put(size(top(treeStack)), width => 0);
         new_line;
      elsif c = 'N' then --gets total size of all trees
         get(c);
         print_stack(treeStack, size'Access);
         new_line;
      elsif c = 'p' or c = 't' then --pretty print for top tree
         get(c);
         pretty_print(top(treeStack));
      elsif c = 'P' or c = 'T' then --pretty print of all trees
         get(c);
         print_stack(treeStack, pretty_print'Access);
      elsif c = 'r' then --rpn top print
         get(c);
         print_rpn(top(treeStack));
         new_line;
      elsif c = 'R' then --rpn print of all trees
         get(c);
         print_stack(treeStack, print_rpn'Access);
      elsif c = 's' or c = 'S' then --stack size
         get(c);
         put(size(treeStack), width => 0);
         new_line;
      elsif c = 'q' or c = 'Q' then --quits
         get(c);
         quit := true;
      else --catch for any invalid characters entered
         get(c);
         put_line("Input invalid, consult help function with h");
      end if;
      exception
         when Constraint_Error =>
            put_line("Error: Overflow!");
   end process;

   tStack: treeStackPk.Stack; --stack for process call
   quit: Boolean := false; --boolean to hold quit flag
begin
   while not end_of_file loop
      find_next;
      process(tStack, quit);
      if quit then
         exit;
      end if;
   end loop;
   exception -- catch for missing q
      when End_Error => put_line("Error: Missing q/Q!");
end yarc;