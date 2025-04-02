#include <iostream>
#include <cstdlib>

int main() {
    const char* command = "cowsay Hello, I am a cow!";
    int returnCode = system(command);

    if (returnCode == -1) {
        return 1;
    }

    return 0;
}