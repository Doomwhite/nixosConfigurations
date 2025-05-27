let
  indexes = builtins.genList (i: i) 5;
  squares = n: builtins.genList (i: i * i) n;
in
{ inherit indexes; squares = squares 5; }
