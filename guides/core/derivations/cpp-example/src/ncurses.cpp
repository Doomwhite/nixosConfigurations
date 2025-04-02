#include <iostream>
#include <cstdlib>
#include <ncurses.h>

int main()
{
    // Initialize ncurses
    initscr();
    cbreak();
    noecho();
    keypad(stdscr, TRUE);

    // Print a message
    printw("Hello, ncurses!");

    // Refresh the screen
    refresh();

    // Wait for user input
    getch();

    // Clean up and exit
    endwin();

    return 0;
}
