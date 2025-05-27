let
  sumList = list:
    if list == [] then
      0
    else
      (builtins.head list) + (sumList (builtins.tail list));
in
sumList [1 2 3 4 5]
