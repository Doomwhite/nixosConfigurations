with import <nixpkgs> { };
let
  list1 = [2 4 6 8 10];
  list2 = [1 3 5 7 9 11];
  recurse = x: y: if x != nil (
    (builtins.head x)
  );
  zipListsWith = l1: l2: ;
in
rec {
  output = lib.zipListsWith (x: y: x + y) (lib.filter (x: x > 5) list1) (lib.filter (x: x > 5) list2);  # Should be [13 17 21]
  result = zipListsWith list1 list2;
}
