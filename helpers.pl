:- use_module(library(lists)).



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