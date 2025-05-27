let
  factorial = x: if x == 0 then 1 else x * factorial(x - 1);
in
map factorial [1 2 3 4 5 6 7 8 9 10 11 12 13]
