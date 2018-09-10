# Tree based Reverse Polish Notation (RPN) Calculator (Ada)
Ada interactive RPN calculator that uses a linked list stack with a linked tree structure to store and process RPN calculations. Various commands provide formatted output according to their descriptions such as printing as a tree, in RPN order, and so forth.

# Available operation commands, negative input uses underscore (_):
- Addition (+)
- Subtraction (-)
- Multiplication (*)
- Division (/)
- Exponential (^)
* For the following commands, upper and lower case provide differing functions separated by /
- Clear top/whole stack (cC)
- Evaluate top/whole stack (eE)
- Quick help/full help (hH)
- Infix in parenthesis for top/whole stack (iI)
- Infix tree for top/whole stack (jJ)
- Number of tree nodes on top/whole stack (nN)
- Pretty print top/whole stack (pP)
- Quit (qQ)
- RPN expression for top/whole stack (rR)
- Stack size (sS)
- Tree on top of stack/whole stack (tT)

Sample input that would be processed:

- 2 3 4 * + 14 RTIJ q

# Instructions for use from command line
- gnatmake yarc.adb
- yarc
- OR yarc < filename (to use input from appropriate text file)

# Input/Output
By supplying the respective equations and commands, the program will output the following:
```
--INPUT--
2 3 4 * + 14 RTIJ q

--OUTPUT--
2 3 4 *  +
14
+
   2
   *
      3
      4
14
(2+(3*4))
14
   2
+
      3
   *
      4
14
```

**Ada compiler can be found here**
[GNAT Community Edition](https://www.adacore.com/download)
