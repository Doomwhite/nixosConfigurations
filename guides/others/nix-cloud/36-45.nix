with import <nixpkgs> { };
let
  # Exercise 36
  countIf = pred: list: lib.fold (x: acc: if pred x then acc + 1 else acc) 0 list;
  list36 = [1 3 5 7 2 4 6];

  # Exercise 37
  partition = pred: list: lib.fold (x: acc: if pred x then { yes = acc.yes ++ [x]; no = acc.no; } else { yes = acc.yes; no = acc.no ++ [x]; }) { yes = []; no = []; } list;
  list37 = [1 2 3 4 5 6];

  # Exercise 38
  pairs = [{ key = "a"; value = 1; } { key = "b"; value = 2; } { key = "c"; value = 3; }];
  toAttrSet = lib.fold (pair: acc: acc // { ${pair.key} = pair.value; }) {};

  # Exercise 39
  dropWhile = pred: list: (lib.fold (x: acc: if acc.dropping && pred x then { dropping = true; result = acc.result; } else { dropping = false; result = acc.result ++ [x]; }) { dropping = true; result = []; } list).result;
  list39 = [1 2 3 4 5 6];

  # Exercise 40
  takeWhile = pred: list: (lib.fold (x: acc: if acc.taking && pred x then { taking = true; result = acc.result ++ [x]; } else { taking = false; result = acc.result; }) { taking = true; result = []; } list).result;
  list40 = [1 2 3 4 5 6];

  # Exercise 41
  range = start: end: (lib.foldl' (acc: _: {
    result = acc.result ++ [ (start + acc.count) ];
    count = acc.count + 1;
  }) { result = []; count = 0; } (lib.replicate (end - start + 1) null)).result;

  # Exercise 42
  findFirst = pred: list: (lib.fold (x: acc: if acc.found then acc else if pred x then { found = true; result = x; } else { found = false; result = null; }) { found = false; result = null; } list).result;
  list42 = [1 2 3 4 5];

  # Exercise 43
  foldWithIndex = f: init: list: (lib.fold (x: acc: { index = acc.index + 1; result = f x acc.index acc.result; }) { index = 0; result = init; } list).result;
  list43 = ["a" "b" "c"];

  # Exercise 44
  interleave = l1: l2: lib.flatten (lib.zipListsWith (x: y: [x y]) l1 l2);
  list44a = [1 3 5];
  list44b = [2 4 6];

  # Exercise 45
  compose = f: g: x: f (g x);
  doubleThenString = compose toString (x: x * 2);
  list45 = [1 2 3];
in
rec {
  ex36 = countIf (x: x > 4) list36; # should be 4
  ex37 = partition (x: x > 3) list37; # should be { yes = [4 5 6]; no = [1 2 3]; }
  ex38 = toAttrSet pairs; # should be { a = 1; b = 2; c = 3; }
  ex39 = dropWhile (x: x < 4) list39; # should be [4 5 6]
  ex40 = takeWhile (x: x < 4) list40; # should be [1 2 3]
  ex41 = range 1 5; # should be [1 2 3 4 5]
  ex42 = findFirst (x: x > 3) list42; # should be 4
  ex43 = foldWithIndex (x: i: acc: acc ++ ["${x}${toString i}"]) [] list43; # should be ["a0" "b1" "c2"]
  ex44 = interleave list44a list44b; # should be [1 2 3 4 5 6]
  ex45 = map doubleThenString list45; # should be ["2" "4" "6"]
}
