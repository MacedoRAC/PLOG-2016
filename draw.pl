%prolog

:- use_module(library(lists)).

drawBoard(Board):-
	write('     1   2   3    4   5   6    7   8   9  \n'),
	write('   +---+---+---++---+---+---++---+---+---+\n'),
	drawLine(Board, 1),
	write('   +---+---+---++---+---+---++---+---+---+\n'),
	drawLine(Board, 2),
	write('   +---+---+---++---+---+---++---+---+---+\n'),
	drawLine(Board, 3),
	write('   +---+---+---++---+---+---++---+---+---+\n'),
	write('   +---+---+---++---+---+---++---+---+---+\n'),
	drawLine(Board, 4),
	write('   +---+---+---++---+---+---++---+---+---+\n'),
	drawLine(Board, 5),
	write('   +---+---+---++---+---+---++---+---+---+\n'),
	drawLine(Board, 6),
	write('   +---+---+---++---+---+---++---+---+---+\n'),
	write('   +---+---+---++---+---+---++---+---+---+\n'),
	drawLine(Board, 7),
	write('   +---+---+---++---+---+---++---+---+---+\n'),
	drawLine(Board, 8),
	write('   +---+---+---++---+---+---++---+---+---+\n'),
	drawLine(Board, 9),
	write('   +---+---+---++---+---+---++---+---+---+\n'),
	write('\n').
	
drawLine(Board, L):-
	getLineHelper(Board, 1, L, Line),
	write(L),
	write('  |'),
	drawCell(Line, 1),
	write('|'),
	drawCell(Line, 2),
	write('|'),
	drawCell(Line, 3),
	write('||'),
	drawCell(Line, 4),
	write('|'),
	drawCell(Line, 5),
	write('|'),
	drawCell(Line, 6),
	write('||'),
	drawCell(Line, 7),
	write('|'),
	drawCell(Line, 8),
	write('|'),
	drawCell(Line, 9),
	write('|\n').

drawCell(Line, C):-
	getCellHelper(Line, 1, C, Cell),
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
	