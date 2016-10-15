%prolog

:- use_module(library(lists)).

getLineHelper([H|_], Li, Lf, L):-
	Li =:= Lf,
	L = H.
getLineHelper([_|T], Li, Lf, L):-
	Li =\= Lf,
	Lj is Li+1,
	getLineHelper(T, Lj, Lf, L).
	
getCellHelper([H|_], Ci, Cf, C):-
	Ci =:= Cf,
	C = H.
getCellHelper([_|T], Ci, Cf, C):-
	Ci =\= Cf,
	Cj is Ci+1,
	getCellHelper(T, Cj, Cf, C).