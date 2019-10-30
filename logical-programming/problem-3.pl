/* Q3.1  run find(A) where A can be g1,g2,g3,g4.
*  Q3.2 run optimal(A) where A can be g1,g2,g3,g4
*  Q3.3 run valid(A) where A is a list.*/


/* move is for movements where we can go both forward and backwards, we can solve cyclic as in part 3*/
move(g,g1,0).
move(g,g2,0).
move(g,g3,0).
move(g,g4,0).
move(g1,g5,4).
move(g2,g5,6).
move(g3,g5,8).
move(g4,g5,9).
move(g1,g6,10).
move(g2,g6,9).
move(g3,g6,3).
move(g4,g6,5).
move(g5,g7,3).
move(g5,g10,4).
move(g5,g11,6).
move(g5,g12,7).
move(g5,g6,7).
move(g5,g8,9).
move(g6,g8,2).
move(g6,g12,3).
move(g6,g11,5).
move(g6,g10,9).
move(g6,g7,10).
move(g7,g10,2).
move(g7,g11,5).
move(g7,g12,7).
move(g7,g8,10).
move(g8,g9,3).
move(g8,g12,3).
move(g8,g11,4).
move(g8,g10,8).
move(g10,g15,5).
move(g10,g11,2).
move(g10,g12,5).
move(g11,g15,4).
move(g11,g13,5).
move(g11,g12,4).
move(g12,g13,7).
move(g12,g14,8).
move(g15,g13,3).
move(g13,g14,4).
move(g14,g17,5).
move(g14,g18,4).
move(g17,g18,8).
move(g5,g1,4).
move(g5,g2,6).
move(g5,g3,8).
move(g5,g4,9).
move(g6,g1,10).
move(g6,g2,9).
move(g6,g3,3).
move(g6,g4,5).
move(g7,g5,3).
move(g10,g5,4).
move(g11,g5,6).
move(g12,g5,7).
move(g6,g5,7).
move(g8,g5,9).
move(g8,g6,2).
move(g12,g6,3).
move(g11,g6,5).
move(g10,g6,9).
move(g7,g6,10).
move(g10,g7,2).
move(g11,g7,5).
move(g12,g7,7).
move(g8,g7,10).
move(g9,g8,3).
move(g12,g8,3).
move(g11,g8,4).
move(g10,g8,8).
move(g15,g10,5).
move(g11,g10,2).
move(g12,g10,5).
move(g15,g11,4).
move(g13,g11,5).
move(g12,g11,4).
move(g13,g12,7).
move(g14,g12,8).
move(g13,g15,3).
move(g14,g13,4).
move(g17,g14,5).
move(g18,g14,4).
move(g18,g17,8).

/*movement is for part 1, where we can't consider loops and need a definite way out so we move in only one direction */
movement(g1,g5,4).
movement(g2,g5,6).
movement(g3,g5,8).
movement(g4,g5,9).
movement(g1,g6,10).
movement(g2,g6,9).
movement(g3,g6,3).
movement(g4,g6,5).
movement(g5,g7,3).
movement(g5,g10,4).
movement(g5,g11,6).
movement(g5,g12,7).
movement(g5,g6,7).
movement(g5,g8,9).
movement(g6,g8,2).
movement(g6,g12,3).
movement(g6,g11,5).
movement(g6,g10,9).
movement(g6,g7,10).
movement(g7,g10,2).
movement(g7,g11,5).
movement(g7,g12,7).
movement(g7,g8,10).
movement(g8,g9,3).
movement(g8,g12,3).
movement(g8,g11,4).
movement(g8,g10,8).
movement(g10,g15,5).
movement(g10,g11,2).
movement(g10,g12,5).
movement(g11,g15,4).
movement(g11,g13,5).
movement(g11,g12,4).
movement(g12,g13,7).
movement(g12,g14,8).
movement(g15,g13,3).
movement(g13,g14,4).
movement(g14,g17,5).
movement(g14,g18,4).
movement(g17,g18,8).


/******************************************************************************/
/* Part.1:-
    To find number of possible paths send find_ways(g1,g17),find_ways(g2,g17) and other two */

/* way determines which way we'll be going and find the path recursively*/
way(A, B, Visited, [B|Visited]) :-
    move(A, B, _).

way(A, B, Visited, Path) :-
    move(A, C, _),
    C \== B,
    \+member(C,Visited),
    way(C, B, [C|Visited], Path).

find_ways(A, B, Path) :-
    way(A, B, [A], ReversePath),
    reverse(ReversePath, Path),
    printPath(Path),
    writef('\n').

find(A):-
    findall(Path,(member(A,[g1,g2,g3,g4]),find_ways(A,g17,Path)),PathSet),
    length(PathSet,Len),
    write(Len).


/*******************************************************************************/
/* Part.2:- Find the optimal path */

/*If the new path is better than the previous path, replace*/
shorterPath([H|Path], Dist) :-
	rpath([H|_], D), !, Dist < D,
	retract(rpath([H|_],_)),
        assert(rpath([H|Path], Dist)).

shorterPath(Path, Dist) :-
	assert(rpath(Path,Dist)).

/* Traverse to all the reachable nodes and Traverse the neighbours */
traverse(From, Path, Dist) :-
	move(From, T, D),
	not(memberchk(T, Path)),
	shorterPath([T,From|Path], Dist+D),
	traverse(T,[From|Path],Dist+D).

traverse(From) :-
	retractall(rpath(_,_)),
	traverse(From,[],0).

traverse(_).

/*Find the Optimal path by by getting the Path */
optimal(X) :-
	traverse(X),
	rpath([g17|Rp],_),
        reverse([g17|Rp], Path),
	printPath(Path).

/*******************************************************************************/
/* Print the path */
printPath([]).
printPath([X]) :-
    !, write(X).
printPath([X|T]) :-
    write(X),
    write('->'),
    printPath(T).

/*****************************************************************************/
/* Part.3:-
    Let's check if it's starting from g1 or g2 or g3 or g4 */
valid([X1|T]):-(X1==g1 -> validate(g1,T);
               X1==g2 -> validate(g2,T) ;
               X1==g3 -> validate(g3,T) ;
               X1==g4 -> validate(g4,T) ;
               fail).

/* if the last is g17 and NULL, then take as true*/
validate(g17,[]).

/* recursively find out if others follow */
validate(X4,[X5|X6]):-( move(X4,X5,_) -> validate(X5,X6);
                        fail).
