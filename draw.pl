%prolog

:- use_module(library(lists)).

drawBoard([H|T], 0):-
	write('\n     1   2   3    4   5   6    7   8   9  \n'),
	drawBoard([H|T], 1).
drawBoard([H|_], 9):-
	write('\n   +---+---+---++---+---+---++---+---+---+\n'),
	write(9),
	write('  |'),
	drawLine(H, 1),
	write('\n   +---+---+---++---+---+---++---+---+---+\n').
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
	Y < 9,
	write('\n   +---+---+---++---+---+---++---+---+---+\n'),
	write(Y),
	write('  |'),
	drawLine(H, 1),
	Yi is Y + 1,
	drawBoard(T, Yi).

drawLine([], _).
drawLine([H|T], X):-
	0 is X mod 3,
	X \= 9,
	drawCell(H),
	write('||'),
	Xi is X + 1,
	drawLine(T, Xi).	
drawLine([H|T], X):-
	X =< 9,
	drawCell(H),
	write('|'),
	Xi is X + 1,
	drawLine(T, Xi).

drawCell(Cell):-
	parseCell(Cell, P, Di),
	translateDir(Di, D),
	colorCell(P, D).

translateDir(0,' O ').
translateDir(7,'NW ').
translateDir(8,' N ').
translateDir(9,' NE').
translateDir(6,'  E').
translateDir(3,' SE').
translateDir(2,' S ').
translateDir(1,'SW ').
translateDir(4,'W  ').

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
	