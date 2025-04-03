let
  makeSecret = {key, value}: {
    mySuperSecretValue = value;
  };
in
  makeSecret { key = "my_secret"; value = "super-secret"; }
        