:- include('kb.pl').
:- discontiguous ironman/3.
:- discontiguous stone/2.
:- discontiguous thanos/3.

/*The representation of the agent's location at some situation*/
ironman(X1,Y1,R1,result(A,S)):-
    ironman(X,Y,R,S),
    grid(M,N),
    (
        (
            (
                /*The collect clause checks if there was a stone in the stone array in the given situation that is in the same cell as Iron Man, if that was satisfied then the collect action is applicable, and the stone is removed from the array*/
                (A = collect, member(stone(X,Y), R), delete(R, stone(X,Y), R1), X1 is X, Y1 is Y);
                (
                    /*the move action allows Iron Man to transition to the cell adjacent to the one he is in if it was not out of the grid border*/
                    (A = left, Y > 0, Y1 is Y - 1, X1 is X, R1 = R);
                    (A = right, X1 is X, Y1 is Y + 1, Y1 < N, R1 = R);
                    (A = up, X > 0, X1 is X - 1, Y1 is Y, R1 = R);
                    (A = down, Y1 is Y, X1 is X + 1, X1 < M, R1 = R)
                )
            ),
            /*Checks if Iron Man was trying to transition to the cell Thanos is in*/
            \+ thanos(X1,Y1)
        );
        (
            (
                /*The snap action is applicable if Iron Man collected all the stones in the grid at situation S, and Iron Man was in Thanos' cell at situation S*/
                (A = snap, thanos(X,Y), R1 = R);
                (
                    /*the move action allows Iron Man to transition to the cell adjacent to the one he is in if it was not out of the grid border*/
                    (A = left, Y > 0, Y1 is Y - 1, X1 is X, R1 = R);
                    (A = right, X1 is X, Y1 is Y + 1, Y1 < N, R1 = R);
                    (A = up, X > 0, X1 is X - 1, Y1 is Y, R1 = R);
                    (A = down, Y1 is Y, X1 is X + 1, X1 < M, R1 = R)
                )
            ),
            /*For this clause to be satisfied all stones in the world must have been collected as stated by the problem by checking on the stone array's length*/
            length(R,0)
        )
    ).

/*The goal of the stated problem is queried on in the snapped predicate, where the situation wanted is the one that has the action snap at the head of the situational statement in the ironman predicate*/
snapped(S):-
    S = result(snap,_),
    ironman(_,_,_,S).
    
    
query_with_depth(S,N,L):-
    (
    call_with_depth_limit(snapped(S),N,L),
    \+ L = depth_limit_exceeded
    );
    (
    F is N+1,
    query_with_depth(S,F,L)
    ).
    

query(S):-
    query_with_depth(S,0,_).
