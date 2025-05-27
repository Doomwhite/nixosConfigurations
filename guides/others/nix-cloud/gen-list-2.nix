let
  numbers = builtins.genList (i: i + 1) 6; # Generates [1, 2, 3, 4, 5, 6]
  first = builtins.elemAt numbers 0;       # Gets element at index 0
  third = builtins.elemAt numbers 2;       # Gets element at index 2
in
{ inherit first; inherit third; }
