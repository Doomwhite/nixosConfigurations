#include <ncurses.h>
#include <string>
#include <unistd.h>

int main() {
    // Inicializa ncurses
    initscr();
    start_color(); // Habilita cores
    cbreak();
    noecho();
    keypad(stdscr, TRUE);
    curs_set(0); // Esconde o cursor

    // Define um par de cores (texto branco, fundo azul)
    init_pair(1, COLOR_WHITE, COLOR_BLUE);

    // Dimensões da tela
    int max_y, max_x;
    getmaxyx(stdscr, max_y, max_x);

    // Mensagem a ser exibida
    std::string message = "Hello, ncurses!";
    int x = 0; // Posição inicial x
    int direction = 1; // Direção do movimento (1 = direita, -1 = esquerda)

    // Loop para animação
    while (true) {
        // Limpa a tela
        clear();

        // Aplica o par de cores
        attron(COLOR_PAIR(1));
        mvprintw(max_y / 2, x, "%s", message.c_str()); // Exibe a mensagem na linha central
        attroff(COLOR_PAIR(1));

        // Atualiza a tela
        refresh();

        // Atualiza a posição x
        x += direction;
        if (x <= 0 || x + message.length() >= max_x) {
            direction *= -1; // Inverte a direção ao atingir as bordas
        }

        // Aguarda 50ms (controla a velocidade da animação)
        usleep(50000);

        // Sai se o usuário pressionar 'q'
        if (getch() == 'q') {
            break;
        }
    }

    // Finaliza ncurses
    endwin();
    return 0;
}
