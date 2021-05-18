import os, time, sys


# zmienne globalne
X = "X"
O = "O"
EMPTY = " "
TIE = "TIE"
NUM_SQUARES = 9
DICT_4_TRANSLATION_2D_TO_1D = {"A1" : 0, "A2" : 3, "A3" : 6,
                               "B1" : 1, "B2" : 4, "B3" : 7,
                               "C1" : 2, "C2" : 5, "C3" : 8}

active_player = O


board = '''
                            A     B     C
                         1  {0}  |  {1}  |  {2}
                          -----------------
                         2  {3}  |  {4}  |  {5}
                          -----------------
                         3  {6}  |  {7}  |  {8}
'''
board_1d = [EMPTY] * NUM_SQUARES # lista przechowująca stan planszy w jednowymiarowym formacie
                                 # (indeks równy indeksowy wpisanemu na planszy board)
                                 # początkowo wypełniona pustką

def board_to_1d_index(user_input): # tlumaczy widok gracza na liste 1d planszy ktora widzi komputer
    if len(user_input) == 2:
        if user_input [1] == "1" or user_input [1] == "2" or user_input [1] == "3":
            if user_input[0] == 'a' or user_input[0] == 'A':
                return DICT_4_TRANSLATION_2D_TO_1D["A" + user_input[1]]
            elif user_input[0] == 'b' or user_input[0] == 'B':
                return DICT_4_TRANSLATION_2D_TO_1D["B" + user_input[1]]
            elif user_input[0] == 'c' or user_input[0] == 'C':
                return DICT_4_TRANSLATION_2D_TO_1D["C" + user_input[1]]
            else:
                return -1
        else:
            return -1
    else:
        return -1

def return_board_view():
    return (board.format(*board_1d))

def get_player_move(player):
    question = "Wskaz miejsce w ktorym chcesz postawic {0}. Użyj formatu np. A1 lub B3. \nTwoj ruch: ".format(player)
    move = input(question)
    return board_to_1d_index(move)

def ask_if_X_or_O():
    question = "Chcesz byc X czy O? Pamietaj O zawsze zaczyna. \nWpisz swoj wybor: "
    choice = input(question)
    if len(choice) == 1:
        if choice == 'x' or choice == 'X':
            player = X
            computer = O
            return player, computer
        elif choice == 'o' or choice == 'O' or choice == "0":
            player = O
            computer = X
            return player, computer
        else:
            return -1, -1
    else:
        return -1, -1

def legal_moves(board):
    moves = []
    for square in range(NUM_SQUARES):
        if board[square] == EMPTY:
            moves.append(square)
    return moves

def clear_console():
    os.system("cls" if os.name == "nt" else "clear")

def winner(board):
    WAYS_TO_WIN = ((0, 1, 2),
                   (3, 4, 5),
                   (6, 7, 8),
                   (0, 3, 6),
                   (1, 4, 7),
                   (2, 5, 8),
                   (0, 4, 8),
                   (2, 4, 6))
    for row in WAYS_TO_WIN:
        if board[row[0]] == board[row[1]] == board[row[2]] != EMPTY:
            winner = board[row[0]]
            return winner
    if EMPTY not in board:
        return TIE
    return None

def player_move(player):
    print(return_board_view())
    move = get_player_move(player)
    while move == -1 or move not in legal_moves(board_1d):
        print("Niepoprawnie podane pole planszy lub pole już zajete")
        print(return_board_view())
        move = get_player_move(player)
        clear_console()
    board_1d[move] = player

def computer_caluclate_move(board, computer, player):


    board = board[:]


    BEST_MOVES = (4, 0, 2, 6, 8, 1, 3, 5, 7)


    for move in legal_moves(board):
        board[move] = computer
        if winner(board) == computer:
            return move
        board[move] = EMPTY


    for move in legal_moves(board):
        board[move] = player
        if winner(board) == player:
            return move
        board[move] = EMPTY


    for move in BEST_MOVES:
        if move in legal_moves(board):
            return move

def computer_make_move(computer, player):
    board_1d[computer_caluclate_move(board_1d, computer, player)] = computer

def next_turn(turn):
    if turn == X:
        return O
    else:
        return X


def end_of_the_line():
    temp = winner(board_1d)
    if temp is not None and temp != TIE:
        print(return_board_view())
        print("Wygrywa: {0}".format(temp))
        input("Wcisnij ENTER, aby wyjsc z programu")
        sys.exit()
    elif temp == TIE:
        print(return_board_view())
        print("Remis")
        input("Wcisnij ENTER, aby wyjsc z programu")
        sys.exit()

def mainloop():
    player = -1
    computer = -1
    turn = O
    while player == -1 and computer == -1:
        player, computer = ask_if_X_or_O()
        clear_console()

    while True:
        if turn == computer:
            computer_make_move(computer, player)
            turn = next_turn(turn)
        else:
            player_move(player)
            turn = next_turn(turn)

        end_of_the_line()
        clear_console()


if __name__ == '__main__':
    mainloop() 