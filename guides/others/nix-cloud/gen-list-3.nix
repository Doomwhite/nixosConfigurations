let
  sumList = list: len: if len == 0 then 0 else (builtins.elemAt list (len - 1)) + (sumList list (len - 1));
  numbers = builtins.genList (i: i + 1) 5; # Generates [1, 2, 3, 4, 5]
in
sumList numbers 5
