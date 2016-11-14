%prolog

:- use_module(library(lists)).

%getInt(+ListOfAcceptedValues, -Int)
getInt(P, I):-
	repeat,
	get(C),
	I is C - 48,
	member(I, P), ! ; fail.
%getCell(+Board, +XCoord, +YCoord, -Cell)
getCell(B, X, Y, C):-
	getLineHelper(B, 1, Y, L),
	getCellHelper(L, 1, X, C).
	
getLineHelper([H|_], Yi, Yf, L):-
	Yi == Yf,
	L = H.
getLineHelper([_|T], Yi, Yf, L):-
	Yi \= Yf,
	Yn is Yi+1,
	getLineHelper(T, Yn, Yf, L).
	
getCellHelper([H|_], Xi, Xf, C):-
	Xi == Xf,
	C = H.
getCellHelper([_|T], Xi, Xf, C):-
	Xi \= Xf,
	Xn is Xi+1,
	getCellHelper(T, Xn, Xf, C).

%getCell(+Board, +XCoord, +YCoord, +Cell, -BoardNew)	
setCell(B, X, Y, C, Bn):-
	setCellHelper(B, 1, 1, X, Y, C, Bn).

setCellHelper([],_,_,_,_,_,[]).
setCellHelper([[_|T]|L], Xi, Yi, Xf, Yf, C, [[C|T]|L]):-
	Xi == Xf,
	Yi == Yf.
setCellHelper([[H|_]|_], Xi, Yi, Xf, Yf, _, [H]):-
	Xi == 9,
	Yi == 9.
setCellHelper([[H|_]|L], Xi, Yi, Xf, Yf, C, [[H]|Ln]):-
	Xi == 9,
	Xn is 1,
	Yn is Yi+1,
	setCellHelper(L, Xn, Yn, Xf, Yf, C, Ln).
setCellHelper([[H|T]|L], Xi, Yi, Xf, Yf, C, [[H|Tn]|Ln]):-
	Xn is Xi+1,
	setCellHelper([T|L], Xn, Yi, Xf, Yf, C, [Tn|Ln]).

%parseCell(+Cell, -Player, -Direction)
parseCell(C, P, D):-
	P is C mod 10,
	D is C div 10.
%genCell(+Player, +Direction, -Cell)	
genCell(P, D, C):-
	C is D * 10 + P.

%genCoords(+XCoord, +YCoord, +Direction, +XCoordNew, +YCoordNew)
genCoords(X, Y, 7, Xn, Yn):-
	Xn is X-1,
	Yn is Y-1.
genCoords(X, Y, 8, Xn, Yn):-
	Xn is X,
	Yn is Y-1.
genCoords(X, Y, 9, Xn, Yn):-
	Xn is X+1,
	Yn is Y-1.
genCoords(X, Y, 6, Xn, Yn):-
	Xn is X+1,
	Yn is Y.
genCoords(X, Y, 3, Xn, Yn):-
	Xn is X+1,
	Yn is Y+1.
genCoords(X, Y, 2, Xn, Yn):-
	Xn is X,
	Yn is Y+1.
genCoords(X, Y, 1, Xn, Yn):-
	Xn is X-1,
	Yn is Y+1.
genCoords(X, Y, 4, Xn, Yn):-
	Xn is X-1,
	Yn is Y.