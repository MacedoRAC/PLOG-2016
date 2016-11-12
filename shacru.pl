%prolog

:- consult('helper.pl').
:- consult('interface.pl').
:- consult('draw.pl').
:- use_module(library(lists)).
:- use_module(library(random)).
	
start:-
	gameOptions(O),
	newGame(O),
	start.

newGame(0):-
	halt.
newGame(1):-
	initBoard2P(B),
	gameLoop(B, 1, false, false, 0).
newGame(2):-
	cpuOptions(O),
	initBoard2P(B),
	gameLoop(B, false, true, O).
newGame(3):-
	cpuOptions(O),
	initBoard2P(B),
	gameLoop(B, true, true, O).
	
initBoard2P([[31,22,0,0,0,0,21,0,0],
		[0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0],
		[62,0,0,0,0,0,0,0,41],
		[0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0],
		[0,0,82,0,0,0,81,0,72]]).




%gameLoop(+Board, +CurrentPlayer, +P1IsCPU, +P2IsCPU, +CPUDificulty)
gameLoop(B, 0, _, _, _):-
	drawBoard(B, 0),
	score(B).
gameLoop(B, 1, false, P2IsCPU, CPUDificulty):-
	drawBoard(B, 0),
	takeTurn(B, 1, Bn),
	nextPlayer(Bn, 1, Pn),
	gameLoop(Bn, Pn, false, P2IsCPU, CPUDificulty).
gameLoop(B, 1, true, P2IsCPU, CPUDificulty):-
	drawBoard(B, 0),
	takeTurnCPU(B, 1, CPUDificulty, Bn),
	nextPlayer(Bn, 1, Pn),
	gameLoop(Bn, Pn, true, P2IsCPU, CPUDificulty).
gameLoop(B, 2, P1IsCPU, false, CPUDificulty):-
	drawBoard(B, 0),
	takeTurn(B, 2, Bn),
	nextPlayer(Bn, 2, Pn),
	gameLoop(Bn, Pn, P1IsCPU, false, CPUDificulty).
gameLoop(B, 2, P1IsCPU, true, CPUDificulty):-
	drawBoard(B, 0),
	takeTurnCPU(B, 2, CPUDificulty, Bn),
	nextPlayer(Bn, 2, Pn),
	gameLoop(Bn, Pn, P1IsCPU, true, CPUDificulty).
	
%takeTurn(+Board, +CurrentPlayer, -BoardNew)
takeTurn(B, P, Bn):-
	repeat,
	moveInput(X, Y, D),
	validateMove(B, P, X, Y, D), ! ; fail,
	move(B, P, X, Y, D, Bn).

%takeTurnCPU(+Board, +CurrentPlayer, +CPUDificulty, -BoardNew)
takeTurnCPU(B, P, CPUDificulty, Bn):-
	repeat,
	CPUDificulty == 0, ! ; fail,
	turnCoordsDumCPU(X, Y),
	moveInput(X, Y, D),
	validateMove(B, P, X, Y, D), ! ; fail,
	move(B, P, X, Y, D, Bn).

%takeTurnCPU(+Board, +CurrentPlayer, +CPUDificulty, -BoardNew)
takeTurnCPU(B, P, CPUDificulty, Bn):-
	repeat,
	turnCoordsSmartCPU(B, X, Y),
	moveInput(X, Y, D),
	validateMove(B, P, X, Y, D), ! ; fail,
	move(B, P, X, Y, D, Bn).

%turnCoordsDumCPU(-CoordX, -CoordY)
turnCoordsDumCPU(X, Y):-
	random_between(1, 9, X),
	random_between(1, 9, Y).

%turnCoordsSmartCPU(+Board, -CoordX, -CoordY)
turnCoordsSmartCPU(B, X, Y):-
	fail.


%validateMove(+Board, +Player, +XCoord, +YCoord, +Direction)
validateMove(B, P, X, Y, D):-
	getCell(B, X, Y, C),
	parseCell(C, Pi, Di),
	P == Pi,
	validateDirection(D, Di),
	validatePosition(B, X, Y, Di).

%validatePosition(+DirectionFromUser, +DirectionFromCell)
validateDirection(7, Di):-
	member(Di,[4,7,8]).
validateDirection(8, Di):-
	member(Di,[7,8,9]).
validateDirection(9, Di):-
	member(Di,[8,9,6]).
validateDirection(6, Di):-
	member(Di,[9,6,3]).
validateDirection(3, Di):-
	member(Di,[6,3,2]).
validateDirection(2, Di):-
	member(Di,[3,2,1]).
validateDirection(1, Di):-
	member(Di,[2,1,4]).
validateDirection(4, Di):-
	member(Di,[1,4,7]).

%validatePosition(+Board, +XCoord, +YCoord, +DirectionParsed)
validatePosition(B, X, Y, D):-
	genCoords(X, Y, D, Xn, Yn),
	Xn >= 1, Xn =< 9,
	Yn >= 1, Yn =< 9,
	getCell(B, Xn, Yn, C),
	C == 0.

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
	Xn is X,
	Yn is Y+1.
genCoords(X, Y, 3, Xn, Yn):-
	Xn is X+1,
	Yn is Y+1.
genCoords(X, Y, 2, Xn, Yn):-
	Xn is X+1,
	Yn is Y.
genCoords(X, Y, 1, Xn, Yn):-
	Xn is X+1,
	Yn is Y-1.
genCoords(X, Y, 4, Xn, Yn):-
	Xn is X,
	Yn is Y-1.
	
%move(+Board, +Player, +XCoord, +YCoord, +Direction, -BoardNew)
move(B, P, X, Y, D, Bn):-
	genCoords(X, Y, D, Xn, Yn),
	setCell(B, X, Y, P, Bi),
	genCell(P, D, C),
	setCell(Bi, Xn, Yn, C, Bi2).
	rotation(Bi2, X, Y, Xn, Yn, P, D, Bn).
	
%rotation(+Board, +XCoord, +YCoord, +XCoordNew, +YCoordNew, +Player, +Direction, -BoardNew)
rotation(B, X, Y, Xn, Yn, P, D, Bn):-
	(member([X, Xn], [[3,4],[4,3],[6,7],[7,6]]) ; member([Y, Yn], [[3,4],[4,3],[6,7],[7,6]])),
	repeat,
	rotationInput(Di),
	(validateDirection(D, Di), ! ; fail),
	genCell(P, Di, C),
	setCell(B, Xn, Yn, C, Bn).
rotation(B,_,_,_,_,_,_,B).
	
%nextPlayer(+Board, +CurrentPlayer, -NextPlayer)
nextPlayer(B, 1, Pn):-
	canPlay(B, P1, P2),
	(P2 == true, Pn is 2);(P1 == true, Pn is 1);(Pn is 0).
nextPlayer(B, 2, Pn):-
	canPlay(B, P1, P2),
	(P1 == true, Pn is 1);(P2 == true, Pn is 2);(Pn is 0).
	
%canPlay(B, P1, P2):-


