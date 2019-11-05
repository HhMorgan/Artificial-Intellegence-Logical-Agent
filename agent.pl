:- include('kb.pl').
:- discontiguous state/3.
:- discontiguous stone/3.
:- discontiguous thanos/3.

state(X1,Y1,result(A,S)):-
    state(X,Y,S),
    dimension(M,N),
    (
        (
            (
                (A = collect, state(X,Y,S), stone(X,Y,S), X1 is X, Y1 is Y);
                (
                    (A = left, Y > 0, Y1 is Y - 1, X1 is X);
                    (A = right, X1 is X, Y1 is Y + 1, Y1 < M);
                    (A = up, X > 0, X1 is X - 1, Y1 is Y);
                    (A = down, Y1 is Y, X1 is X + 1, X1 < N)
                )
            ),
            \+ thanos(X1,Y1,S)
        );
        (
            (
                (A = snap, thanos(X,Y,S), state(X,Y,S),\+ stone(_,_,S));
                (
                    (A = left, Y > 0, Y1 is Y - 1, X1 is X);
                    (A = right, X1 is X, Y1 is Y + 1, Y1 < M);
                    (A = up, X > 0, X1 is X - 1, Y1 is Y);
                    (A = down, Y1 is Y, X1 is X + 1, X1 < N)
                )
            ),
            \+ stone(_,_,S)
        )
    ).
stone(X,Y,result(A,S)):-
    stone(X,Y,S),
    (A = left; A = right; A = up; A = down; (A = collect, \+ state(X,Y,S))).
thanos(X,Y,result(A,S)):-
    thanos(X,Y,S),
    (A = left; A = right; A = up; A = down; A = collect).
eliminated(X,Y,result(snap,S)):-
    thanos(X,Y,S),
    state(X,Y,S),
    \+ stone(_,_,S).
    
snapped(S):-
    S = result(snap,_),
    state(_,_,S).
    %foreach(state(X,Y,s0),state(X,Y,result(snap,S))).
    %foreach(thanos(X,Y,s0),eliminated(X,Y,S)).
    %foreach(stone(X,Y,s0),collected(X,Y,S)).
    %state(X,Y,S),
    %eliminated(X,Y,S).
    
    
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
