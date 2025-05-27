with import <nixpkgs> { };
let
  list = [1 2 3 4 5 6];
  partition = pred: list: lib.fold(x: acc:
    if (pred x) then
      acc // { yes = [x] ++ acc.yes; }
    else
      acc // { no = [x] ++ acc.no; }
  ) { yes = []; no = []; } list;
in
rec {
  example = lib.partition (x: x > 3) list; # should be { yes = [4 5 6]; no = [1 2 3]; }
  result = partition (x: x > 3) list; # should be { yes = [4 5 6]; no = [1 2 3]; }
}
