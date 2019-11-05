:- include('kb.pl').
:- discontiguous state/3.
:- discontiguous stone/2.
:- discontiguous thanos/3.

state(X1,Y1,R1,result(A,S)):-
    state(X,Y,R,S),
    dimension(M,N),
    (
        (
            (
                (A = collect, member(stone(X,Y), R), delete(R, stone(X,Y), R1), X1 is X, Y1 is Y);
                (
                    (A = left, Y > 0, Y1 is Y - 1, X1 is X, R1 = R);
                    (A = right, X1 is X, Y1 is Y + 1, Y1 < M, R1 = R);
                    (A = up, X > 0, X1 is X - 1, Y1 is Y, R1 = R);
                    (A = down, Y1 is Y, X1 is X + 1, X1 < N, R1 = R)
                )
            ),
            \+ thanos(X1,Y1)
        );
        (
            (
                (A = snap, thanos(X,Y), length(R,0), R1 = R);
                (
                    (A = left, Y > 0, Y1 is Y - 1, X1 is X, R1 = R);
                    (A = right, X1 is X, Y1 is Y + 1, Y1 < M), R1 = R;
                    (A = up, X > 0, X1 is X - 1, Y1 is Y, R1 = R);
                    (A = down, Y1 is Y, X1 is X + 1, X1 < N, R1 = R)
                )
            ),
            length(R,0)
        )
    ).

snapped(S):-
    S = result(snap,_),
    state(_,_,_,S).
    
    
query_with_depth(S,N,L):-
    (
    call_with_depth_limit(snapped(S),N,L),
    \+ L = depth_limit_exceeded
    );
    (
    F is N+1,
    query_with_depth(S,F,L)
    ).
    

start(S):-
    
    query_with_depth(S,0,_).
