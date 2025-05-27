with import <nixpkgs> { };
let
  list = [1 3 5 7 2 4 6];
  countIf = pred: list: lib.fold (acc: x: if pred x then acc + 1 else acc) 0 list;
in
rec {
  example = lib.length (lib.filter (x: x > 4) list); # should be 4
  result = countIf (x: x > 4) list; # should be 4
}
