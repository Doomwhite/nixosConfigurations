{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = with pkgs; [
    nodejs  # Provides Node.js and npm
  ];
  shellHook = ''
    npm install -g @angular/language-service @angular/language-server typescript
    export PATH="$HOME/.npm-global/bin:$PATH"
    echo "Angular Language Server and dependencies installed in the shell"
  '';
}
