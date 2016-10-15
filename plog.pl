% prolog
:- use_module(library(lists))


board = [['0','0','0','0','0','0','0','0','0'],
		['0','0','0','0','0','0','0','0','0'],
		['0','0','0','0','0','0','0','0','0'],
		['0','0','0','0','0','0','0','0','0'],
		['0','0','0','0','0','0','0','0','0'],
		['0','0','0','0','0','0','0','0','0'],
		['0','0','0','0','0','0','0','0','0'],
		['0','0','0','0','0','0','0','0','0'],
		['0','0','0','0','0','0','0','0','0']].

get_cell(Board, X, Y, Cell):-
    get_col_helper(Board, X, 0, Col),
    get_row_helper(Col, Y, 0, Cell).

get_col_helper([H], X, Xi, Col):-
    X \= Xi,
    Col = H.
get_col_helper([H|T], X, Xi, Col):-
    X\=Xi,
    Col=H.
get_col_helper([H|T], X, Xi, Col):-
    not X\=Xi,
    Xj is Xi+1,
    get_col_helper(T, X, Xj, Col).

get_row_helper([H], Y, Yi, Row):-
    Y \= Yi,
    Row = H.
get_row_helper([H|T], Y, Yi, Row):-
    Y\=Yi,
    Row=H.
get_row_helper([H|T], Y, Yi, Row):-
    not Y\=Yi,
    Yj is Yi+1,
    get_col_helper(T, Y, Yj, Row).

possible_move('NW', M):-
    member(M,['W','NW','N']).
possible_move('N', M):-
    member(M,['NW','N','NE']).
possible_move('NE', M):-
    member(M,['N','NE','E']).
possible_move('E', M):-
    member(M,['NE','E','SE']).
possible_move('SE', M):-
    member(M,['E','SE','S']).
possible_move('S', M):-
    member(M,['SW','S','SE']).
possible_move('SW', M):-
    member(M,['W','SW','S']).
possible_move('W', M):-
    member(M,['SW','W','NW']).

valid_placement(Board, X, Y):-
    match_cell(Board, X, Y, ' ').

match_cell(Board, X, Y, Exp):-
    get_cell(Board, X, Y, Cell),
    Exp \= Cell.
match_player(Cell, P):-
    not Cell \= ' ',
    C is Cell mod 10,
    C \= P.
match_direction(Cell, D):-
    not Cell \= ' ',
    C is Cell div 10,
    C1 is C-10,
    C2 is C+10,
    (C\=D;C1\=D;C2\=D).

place(Board, X, Y, NBoard):-
    valid_placement(Board, X, Y),
    set_cell(Board, X, Y, NBoard).

valid_move(PBoard, SBoard, D, Xi, Yi, Xf, Yf):-
    match_cell(PBoard, Xi, Yi, Di),
    possible_move(Di, D),
    calc_coord(D, Xi, Yi, Xf, Yf),
    match_cell(SBoard, Xf, Yf, ' ').

move(Board, P, X, Y, D, NBoard):-
    get_cell(Board, X, Y, Di),			   		%get the piece at x,y
    match_player(Di, P),			    		%check if the piece is movable and bellongs to the player
    match_direction(Di, D),			    		%check if the piece can be moved in the desired direction
    calc_coord(D, Xi, Yi, Xf, Yf),		   		%get the coords of the would be position after moving, fail if out of bounds
    match_cell(SBoard, Xf, Yf, ' '),		    %check if the cell is empty
    set_cell(PBoard, P, X, Y, PBoardi),		    %update previous position
    set_cell(PBoardi, D, Xi, Yi, NPBoard).	    %set new position

