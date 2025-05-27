with import <nixpkgs> { };
let
  pairs = [{ key = "a"; value = 1; } { key = "b"; value = 2; } { key = "c"; value = 3; }];
  toAttrSet = lib.fold (x: acc: acc // { ${x.key} = x.value; } ) {};
in
rec {
  example = lib.listToAttrs (map (x: { name = x.key; value = x.value; }) pairs); # should be { a = 1; b = 2; c = 3; }
  result = toAttrSet pairs; # should be { a = 1; b = 2; c = 3; }
}
