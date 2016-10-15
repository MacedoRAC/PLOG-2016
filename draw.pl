%prolog

:- use_module(library(lists)).

drawBoard([H|T], 0):-
	write('     1   2   3    4   5   6    7   8   9  \n'),
	drawBoard([H|T], 1).
drawBoard([H|_], 9):-
	write('\n   +---+---+---++---+---+---++---+---+---+\n'),
	write(9),
	write('  |'),
	drawLine(H, 1),
	write('\n   +---+---+---++---+---+---++---+---+---+').
drawBoard([H|T], Y):-
	0 is Y mod 3,
	write('\n   +---+---+---++---+---+---++---+---+---+\n'),
	write(Y),
	write('  |'),
	drawLine(H, 1),
	write('\n   +---+---+---++---+---+---++---+---+---+'),
	Yi is Y + 1,
	drawBoard(T, Yi).
drawBoard([H|T], Y):-
	write('\n   +---+---+---++---+---+---++---+---+---+\n'),
	write(Y),
	write('  |'),
	drawLine(H, 1),
	Yi is Y + 1,
	drawBoard(T, Yi).

drawLine([], _).
drawLine([H|T], X):-
	0 is X mod 3,
	X =\= 9,
	drawCell(H),
	write('||'),
	Xi is X + 1,
	drawLine(T, Xi).	
drawLine([H|T], X):-
	drawCell(H),
	write('|'),
	Xi is X + 1,
	drawLine(T, Xi).

drawCell(Cell):-
	parseCell(Cell, P, Di),
	translateDir(Di, D),
	colorCell(P, D).

parseCell(C, P, D):-
	atom_number(C, Cint),
	P is Cint mod 10,
	D is Cint div 10.

translateDir(0,' O ').
translateDir(1,'NW ').
translateDir(2,' N ').
translateDir(3,' NE').
translateDir(4,'  E').
translateDir(5,' SE').
translateDir(6,' S ').
translateDir(7,'SW ').
translateDir(8,'W  ').

colorCell(0, _):-
	write('   ').
colorCell(1, D):-
	ansi_format([bold,fg(green)],D,[]).
colorCell(2, D):-
	ansi_format([bold,fg(red)],D,[]).
colorCell(3, D):-
	ansi_format([bold,fg(yellow)],D,[]).
colorCell(4, D):-
	ansi_format([bold,fg(blue)],D,[]).
	