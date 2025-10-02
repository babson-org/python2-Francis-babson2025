from copy import copy
from game_over import game_over
from calc_score import calc_score

def mini_max(board, XsTurn, level):

     
    best_score = float('-inf') if XsTurn else float('inf')    
    compare = max if XsTurn else min
    points = 10 if XsTurn else -10
    

    for square in range(9):
        new_board = copy(board)   

        if new_board[square] not in(10, -10):
            new_board[square] = points
            score = calc_score(new_board)
            '''
            if game_over(new_board): return score - level if score == 30 else score + level if score == -30 else 0

            child_score = mini_max(new_board, not XsTurn, level + 1)
            '''
            if game_over(new_board):
                child_score = (score - level if score == 30 else
                            score + level if score == -30 else 0)
            else:
                child_score = mini_max(new_board, not XsTurn, level + 1)


            if compare(best_score, child_score) == child_score:
                best_score = child_score
                

    return best_score