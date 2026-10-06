% =========================================================
% Actividad 02 - Backtracking / grafo dirigido
% Programacion III
% Estudiante: Elias Alejandro Paz Marin, Jeremy Salazar Isaza
% =========================================================
% Grafo dirigido y ponderado (Vancouver -> Winnipeg), tomado
% del material anexo "03-Backtraking y SLD.pdf"

% ---------- HECHOS: arco(Origen, Destino, Costo) ----------
arco(vancouver, edmonton, 16).
arco(vancouver, calgary, 13).
arco(edmonton, saskatoon, 12).
arco(saskatoon, calgary, 9).
arco(calgary, edmonton, 4).
arco(calgary, regina, 14).
arco(regina, saskatoon, 7).
arco(saskatoon, winnipeg, 20).
arco(regina, winnipeg, 4).

% =========================================================
% REGLA 1: existe conexion (camino) entre dos nodos.
% Se usa backtracking con lista de visitados para evitar
% ciclos infinitos (el grafo tiene el ciclo
% calgary -> edmonton -> saskatoon -> calgary).
% =========================================================
conectado(X, Y) :- conectado(X, Y, [X]).

conectado(X, Y, _) :- arco(X, Y, _).
conectado(X, Y, Visitados) :-
    arco(X, Z, _),
    \+ member(Z, Visitados),
    conectado(Z, Y, [Z|Visitados]).

% =========================================================
% REGLA 2: con que nodos esta conectado un nodo (entrante o
% saliente) y cual es el costo de cada conexion directa.
% =========================================================
conexion_de(Nodo, Vecino, Costo) :- arco(Nodo, Vecino, Costo).
conexion_de(Nodo, Vecino, Costo) :- arco(Vecino, Nodo, Costo).

% =========================================================
% REGLA 3: un nodo "tiene aristas" si aparece en al menos un
% arco, ya sea como origen o como destino.
% =========================================================
tiene_aristas(X) :- arco(X, _, _).
tiene_aristas(X) :- arco(_, X, _).

% =========================================================
% REGLA 4: costo de ir de X a Z pasando obligatoriamente por
% un nodo intermedio Y (arco directo X->Y y luego Y->Z).
% =========================================================
costo_via(X, Y, Z, Costo) :-
    arco(X, Y, C1),
    arco(Y, Z, C2),
    Costo is C1 + C2.

% =========================================================
% CONSULTAS DE VALIDACION (se ejecutan mas abajo con initialization)
% =========================================================
:- initialization(main).

main :-
    nl, write('--- 1) Existe conexion entre Saskatoon y Vancouver? ---'), nl,
    ( conectado(saskatoon, vancouver)
    -> write('Resultado: true')
    ;  write('Resultado: false')
    ), nl,

    nl, write('--- 2) Nodos conectados con Regina y costo de cada conexion ---'), nl,
    forall(conexion_de(regina, Vecino, Costo),
           format('regina -- ~w  (costo: ~w)~n', [Vecino, Costo])),

    nl, write('--- 3) La regla tiene_aristas/1 aplicada a cada nodo ---'), nl,
    forall(member(N, [vancouver, edmonton, calgary, saskatoon, regina, winnipeg]),
           ( tiene_aristas(N)
           -> format('tiene_aristas(~w) = true~n', [N])
           ;  format('tiene_aristas(~w) = false~n', [N])
           )),

    nl, write('--- 4) Costo de ir de Vancouver a Saskatoon pasando por Edmonton ---'), nl,
    ( costo_via(vancouver, edmonton, saskatoon, C1)
    -> format('costo_via(vancouver, edmonton, saskatoon, ~w)~n', [C1])
    ;  write('No existe ese camino'), nl
    ),

    nl, write('--- 4b) Costo de ir de Calgary a Winnipeg pasando por Regina ---'), nl,
    ( costo_via(calgary, regina, winnipeg, C2)
    -> format('costo_via(calgary, regina, winnipeg, ~w)~n', [C2])
    ;  write('No existe ese camino'), nl
    ),

    nl, write('--- 5) Pregunta mas interesante: se puede viajar de Edmonton a Calgary? ---'), nl,
    ( conectado(edmonton, calgary)
    -> write('Resultado: true (no hay arco directo, pero si un camino indirecto)')
    ;  write('Resultado: false')
    ), nl,

    nl, halt.
