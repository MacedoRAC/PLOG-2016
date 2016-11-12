%prolog

:- use_module(library(lists)).

greeter():-
	write('Welcome to Shacru!\n').

gameOptions(O):-
	write('Please choose a game mode:\n'),
	write('\t1 Human vs Human\n'),
	write('\t2 Human vs CPU\n'),
	write('\t3 CPU vs CPU\n'),
	write('\t0 Exit\n'),
	write('Option: '),
	getInt([0,1,2,3], O).

cpuOptions(O):-
	write('Choose the CPU dificulty:\n'),
	write('\t1 Easy\n'),
	write('\t2 Hard\n'),
	write('Option: '),
	getInt([1,2], O).
	
moveInput(X, Y, D):-
	write('Input the X position of the piece you want to move [1-9]:\n'),
	getInt([1,2,3,4,5,6,7,8,9], X),
	write('Input the Y position of the piece you want to move [1-9]:\n'),
	getInt([1,2,3,4,5,6,7,8,9], Y),
	write('Input the Direction in which you want to move (use numpad for reference):\n'),
	getInt([7,8,9,6,3,2,1,4], D).

rotateInput(D):-
	write('You can rotate the piece you moved 90º CW or CCW. Input the desired direction:\n'),
	getInt([7,8,9,6,3,2,1,4], D).