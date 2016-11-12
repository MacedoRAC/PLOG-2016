%prolog

:- use_module(library(lists)).

%getInt(+ListOfAcceptedValues, -Int)
getInt(P, I):-
	repeat,
	get(C),
	I is C - 48,
	member(I, P), ! ; fail.

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
	
setCell(B, X, Y, C, Bn):-
	setCellHelper(B, 1, 1, X, Y, C, Bn).
	
setCellHelper([],_,_,_,_,_,[]).
setCellHelper([[_|T]|L], Xi, Yi, Xf, Yf, C, [[Hn|Tn]|Ln]):-
	Xi == Xf,
	Yi == Yf,
	Hn is C,
	Xn is Xi+1,
	setCellHelper([T|L], Xn, Yi, Xf, Yf, C, [Tn|Ln]).
setCellHelper([[H|T]|L], Xi, Yi, Xf, Yf, C, [[Hn|Tn]|Ln]):-
	Xi \= Xf,
	Yi \= Yf,
	Hn is H,
	Xn is Xi+1,
	setCellHelper([T|L], Xn, Yi, Xf, Yf, C, [Tn|Ln]).
setCellHelper([[_|_]|L], Xi, Yi, Xf, Yf, C, [[Hn]|Ln]):-
	Xi == 9,
	Xi == Xf,
	Yi == Yf,
	Hn is C,
	Xn is 0,
	Yn is Yi+1,
	setCellHelper([L], Xn, Yn, Xf, Yf, C, [Ln]).
setCellHelper([[H|_]|L], Xi, Yi, Xf, Yf, C, [[Hn]|Ln]):-
	Xi == 9,
	Xi \= Xf,
	Yi \= Yf,
	Hn is H,
	Xn is 0,
	Yn is Yi+1,
	setCellHelper([L], Xn, Yn, Xf, Yf, C, [Ln]).
setCellHelper([[_|_]|_], Xi, Yi, Xf, Yf, C, [Hn]):-
	Xi == 9,
	Yi == 9,
	Xi == Xf,
	Yi == Yf,
	Hn is C.
setCellHelper([[H|_]|_], Xi, Yi, Xf, Yf, _, [Hn]):-
	Xi == 9,
	Yi == 9,
	Xi \= Xf,
	Yi \= Yf,
	Hn is H.

%parseCell(+Cell, -Player, -Direction)
parseCell(C, P, D):-
	P is C mod 10,
	D is C div 10.
