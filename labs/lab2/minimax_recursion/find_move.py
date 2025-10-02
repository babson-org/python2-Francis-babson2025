from copy import copy
from mini_max import mini_max
from game_over import game_over
def find_move(board, XsTurn):

     
    best_score = float('-inf') if XsTurn else float('inf')    
    best_move = None
    compare = max if XsTurn else min
    points = 10 if XsTurn else -10

    for square in range(9):
        new_board = copy(board)   

        if new_board[square] not in(10, -10):
            new_board[square] = points
            if game_over(new_board): return square

            score = mini_max(new_board, not XsTurn, 0)

            if compare(best_score, score) == score:
            #if (XsTurn and score > best_score) or (not XsTurn and score < best_score):    
                best_score = score
                best_move = square

    return best_move




    




