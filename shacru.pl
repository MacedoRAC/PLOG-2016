%prolog

:- consult('helper.pl').
:- consult('interface.pl').
:- consult('draw.pl').
:- use_module(library(lists)).
:- use_module(library(random)).
:- use_module(library(apply)).
	
%main menu
start:-
	gameOptions(O),
	newGame(O),
	sleep(5),
	start.
test:-
	newGame(3).
	
%newGame(+GameType)
%start a new game (PvP, PvCPU, CPUvsCPU)
newGame(0):-
	halt.
newGame(1):-
	initP1Pieces(P1P),
	initP2Pieces(P2P),
	initBoard2P(B),
	gameLoop(B, 1, P1P, P2P, false, false).
newGame(2):-
	initP1Pieces(P1P),
	initP2Pieces(P2P),
	initBoard2P(B),
	gameLoop(B, 1, P1P, P2P,  false, true).
newGame(3):-
	initP1Pieces(P1P),
	initP2Pieces(P2P),
	initBoard2P(B),
	gameLoop(B, 1, P1P, P2P, true, true).
	
	
%initialize game data
initP1Pieces([[1,1,3],[7,1,2],[9,5,4],[7,9,8]]).
initP2Pieces([[2,1,2],[1,5,6],[3,9,8],[9,9,7]]).
initBoard2P([[31,22,0,0,0,0,21,0,0],
		[0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0],
		[62,0,0,0,0,0,0,0,41],
		[0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0],
		[0,0,0,0,0,0,0,0,0],
		[0,0,82,0,0,0,81,0,72]]).

%gameLoop(+Board, +CurrentPlayer, +P1Pieces, +P2Pieces +P1IsCPU, +P2IsCPU)
%repeats while any player has possible moves left
%when CurrentPlayer is 0, the score is calculated instead and the game ends
gameLoop(B, 0, _, _, _, _):-
	clear,
	drawBoard(B, 0),
	score(B).
gameLoop(B, 1, P1P, P2P, false, P2IsCPU):-
	clear,
	drawBoard(B, 0),
	showPlayer(1),
	takeTurn(B, 1, P1P, Bn, P1Pn),
	nextPlayer(Bn, 1, P1Pn, P2P, Pn),
	gameLoop(Bn, Pn, P1Pn, P2P, false, P2IsCPU).
gameLoop(B, 1, P1P, P2P, true, P2IsCPU):-
	clear,
	drawBoard(B, 0),
	showPlayer(1),
	takeTurnCPU(B, 1, P1P, Bn, P1Pn),
	nextPlayer(Bn, 1, P1Pn, P2P, Pn),
	gameLoop(Bn, Pn, P1Pn, P2P, true, P2IsCPU).
gameLoop(B, 2, P1P, P2P, P1IsCPU, false):-
	clear,
	drawBoard(B, 0),
	showPlayer(2),
	takeTurn(B, 2, P2P, Bn, P2Pn),
	nextPlayer(Bn, 2, P1P, P2Pn, Pn),
	gameLoop(Bn, Pn, P1P, P2Pn, P1IsCPU, false).
gameLoop(B, 2, P1P, P2P, P1IsCPU, true):-
	clear,
	drawBoard(B, 0),
	showPlayer(2),
	takeTurnCPU(B, 2, P2P, Bn, P2Pn),
	nextPlayer(Bn, 2, P1P, P2Pn, Pn),
	gameLoop(Bn, Pn, P1P, P2Pn, P1IsCPU, true).
	
%takeTurn(+Board, +CurrentPlayer, +PlayerPieces, -BoardNew, -PlayerPiecesNew)
%ask player input, validate and act
%will loop until a valid play is received
takeTurn(B, P, PP, Bn, PPn):-
	repeat,
	moveInput(X, Y, D),
	(validateMove(B, P, X, Y, D), ! ; fail),
	move(B, P, X, Y, D, PP, Bn, PPn).
	
%takeTurnCPU(+Board, +CurrentPlayer, +PlayerPieces, -BoardNew, -PlayerPiecesNew)
%get an attempted move from CPU, validate and act
%will loop until a valid play is received
takeTurnCPU(B, P, PP, Bn, PPn):-
	repeat,
	moveInputCPU(PP, X, Y, D),
	(validateMove(B, P, X, Y, D), ! ; fail),
	moveCPU(B, P, X, Y, D, PP, Bn, PPn).
	
%validateMove(+Board, +Player, +XCoord, +YCoord, +Direction)
%verify if the mentioned piece belongs to the player
%verify that it is moving in a valid direction
%verify that it is moving to an empty space
validateMove(B, P, X, Y, D):-
	getCell(B, X, Y, C),
	parseCell(C, Pi, Di),
	P == Pi,
	validateDirection(D, Di),
	validatePosition(B, X, Y, D).

%validatePosition(+DirectionFromUser, +DirectionFromCell)
%validate direction in which the piece is trying to move based on the current direction
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
%validate destination cell if empty
validatePosition(B, X, Y, D):-
	genCoords(X, Y, D, Xn, Yn),
	Xn >= 1, Xn =< 9,
	Yn >= 1, Yn =< 9,
	getCell(B, Xn, Yn, C),
	C == 0.
	
%move(+Board, +Player, +XCoord, +YCoord, +Direction, +PlayerPieces, -BoardNew, -PlayerPiecesNew)
%calculate the new position
%modify previous and current position in the board
%update the list that contains the positions of the 4 pieces that belong to the player 
move(B, P, X, Y, D, PP, Bn, PPn):-
	genCoords(X, Y, D, Xn, Yn),
	setCell(B, X, Y, P, Bi),
	member([X, Y, Di], PP),
	delete(PP, [X, Y, Di], PPi),
	genCell(P, D, C),
	setCell(Bi, Xn, Yn, C, Bi2),
	append(PPi, [[Xn, Yn, D]], PPn),
	rotation(Bi2, X, Y, Xn, Yn, P, D, Bn).

%rotation(+Board, +XCoord, +YCoord, +XCoordNew, +YCoordNew, +Player, +Direction, -BoardNew)
%check if moved across sub areas (9 sets of 3x3)
%ask the player to rotate, validate the input and act if valid
%loops the request until valid input is received
rotation(B, X, Y, Xn, Yn, P, D, Bn):-
	(member([X, Xn], [[3,4],[4,3],[6,7],[7,6]]) ; member([Y, Yn], [[3,4],[4,3],[6,7],[7,6]])),
	repeat,
	rotateInput(Di),
	(validateDirection(D, Di), ! ; fail),
	genCell(P, Di, C),
	setCell(B, Xn, Yn, C, Bn).
rotation(B,_,_,_,_,_,_,B).

%moveInputCPU(+PlayerPieces, -XCoord, -YCoord, -Direction)
%randomize movements
moveInputCPU(PP, X, Y, D):-
	random_between(1, 4, P),
	nth1(P, PP, [X, Y, _]),
	random_between(1, 9, D).
	
%move(+Board, +Player, +XCoord, +YCoord, +Direction, +PlayerPieces, -BoardNew, -PlayerPiecesNew)
%calculate the new position
%modify previous and current position in the board
%update the list that contains the positions of the 4 pieces that belong to the player
%print the movement
moveCPU(B, P, X, Y, D, PP, Bn, PPn):-
	genCoords(X, Y, D, Xn, Yn),
	setCell(B, X, Y, P, Bi),
	member([X, Y, Di], PP),
	delete(PP, [X, Y, Di], PPi),
	genCell(P, D, C),
	setCell(Bi, Xn, Yn, C, Bi2),
	append(PPi, [[Xn, Yn, D]], PPn),
	describeMoveCPU(X, Y, Xn, Yn),
	rotationCPU(Bi2, X, Y, Xn, Yn, P, D, Bn),
	sleep(1).
	
%rotation(+Board, +XCoord, +YCoord, +XCoordNew, +YCoordNew, +Player, +Direction, -BoardNew)
%check if moved across sub areas (9 sets of 3x3)
%randomize rotation, validate the input and act if valid
%loops the request until a valid randomization is achieved
rotationCPU(B, X, Y, Xn, Yn, P, D, Bn):-
	(member([X, Xn], [[3,4],[4,3],[6,7],[7,6]]) ; member([Y, Yn], [[3,4],[4,3],[6,7],[7,6]])),
	repeat,
	random_between(1, 9, Di),
	(validateDirection(D, Di), ! ; fail),
	genCell(P, Di, C),
	setCell(B, Xn, Yn, C, Bn),
	describeRotationCPU(Di).
rotationCPU(B,_,_,_,_,_,_,B).
	
%nextPlayer(+Board, +CurrentPlayer, -NextPlayer)
%verify if players still have any possible moves
%swap players if opponents have options left, keeps the same player otherwise
%if no player has moves left, the next is 0 and the game ends
nextPlayer(B, 1, P1P, P2P, Pn):-
	(canPlay(B, P2P), Pn is 2);
	(canPlay(B, P1P), Pn is 1);
	Pn is 0,!.
nextPlayer(B, 2, P1P, P2P, Pn):-
	(canPlay(B, P1P), Pn is 1);
	(canPlay(B, P2P), Pn is 2);
	Pn is 0,!.
%canPlay(+Board, +PlayerPieces)
canPlay(B, [PP1, PP2, PP3, PP4]):-
	hasMoves(B, PP1);
	hasMoves(B, PP2);
	hasMoves(B, PP3);
	hasMoves(B, PP4),
	!.
%hasMoves(+Board, +PlayerPiece (single))
hasMoves(B, [X, Y, 7]):-
	hasMovesHelper(B, X, Y, 4);
	hasMovesHelper(B, X, Y, 7);
	hasMovesHelper(B, X, Y, 8), !.
hasMoves(B, [X, Y, 8]):-
	hasMovesHelper(B, X, Y, 7);
	hasMovesHelper(B, X, Y, 8);
	hasMovesHelper(B, X, Y, 9), !.
hasMoves(B, [X, Y, 9]):-
	hasMovesHelper(B, X, Y, 8);
	hasMovesHelper(B, X, Y, 9);
	hasMovesHelper(B, X, Y, 6), !.
hasMoves(B, [X, Y, 6]):-
	hasMovesHelper(B, X, Y, 9);
	hasMovesHelper(B, X, Y, 6);
	hasMovesHelper(B, X, Y, 3), !.
hasMoves(B, [X, Y, 3]):-
	hasMovesHelper(B, X, Y, 6);
	hasMovesHelper(B, X, Y, 3);
	hasMovesHelper(B, X, Y, 2), !.
hasMoves(B, [X, Y, 2]):-
	hasMovesHelper(B, X, Y, 3);
	hasMovesHelper(B, X, Y, 2);
	hasMovesHelper(B, X, Y, 1), !.
hasMoves(B, [X, Y, 1]):-
	hasMovesHelper(B, X, Y, 2);
	hasMovesHelper(B, X, Y, 1);
	hasMovesHelper(B, X, Y, 4), !.
hasMoves(B, [X, Y, 4]):-
	hasMovesHelper(B, X, Y, 1);
	hasMovesHelper(B, X, Y, 4);
	hasMovesHelper(B, X, Y, 7), !.
	
hasMovesHelper(B, X, Y, D):-
	genCoords(X, Y, D, Xn, Yn),
	getCell(B, Xn, Yn, C),
	C == 0.
%score(+Board)
%flattens the board, removes the free cell references (zeros) and counts the number of occurrences of players references (ones and twos)
score(B):-
	flatten(B, Bf),
	maplist(scoreHelper, Bf, S),
	subtract(S, [0], Si),
	subtract(Si, [2], S1),
	length(S1, SP1),
	subtract(Si, [1], S2),
	length(S2, SP2),
	printScore(SP1, SP2).
	
scoreHelper(C, P):-
	P is C mod 10.
