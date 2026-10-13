% =========================================================
% Actividad 03 - Casos con listas
% Programacion III
% Estudiantes: Elias Alejandro Paz Marin, Jeremy Salazar Isaza
% =========================================================
% Se retoman el numeral 1 de la Actividad 01 (familia Simpson) y
% el ejercicio del grafo dirigido de ciudades de Canada
% (Actividad 02), reescribiendo los hechos como UNA lista de
% estructuras (en vez de muchos hechos sueltos) y modificando
% las reglas para que recorran esas listas (member/2, findall/3,
% sort/2, etc.) y sigan resolviendo exactamente las mismas
% consultas que antes.


% =========================================================
% PARTE 1: Arbol genealogico (familia Simpson) con listas
% =========================================================

% ---------- HECHO UNICO: lista de estructuras persona/4 ----------
% persona(Nombre, Genero, Padre, Madre)
% 'desconocido' se usa cuando ese progenitor no aparece en el
% arbol genealogico original.
familia([
    persona(abraham,    m, desconocido, desconocido),
    persona(mona,       f, desconocido, desconocido),
    persona(clancy,     m, desconocido, desconocido),
    persona(jacqueline, f, desconocido, desconocido),
    persona(herbert,    m, abraham,     desconocido),
    persona(homero,     m, abraham,     mona),
    persona(marge,      f, clancy,      jacqueline),
    persona(patty,      f, clancy,      jacqueline),
    persona(selma,      f, clancy,      jacqueline),
    persona(bart,       m, homero,      marge),
    persona(lisa,       f, homero,      marge),
    persona(maggie,     f, homero,      marge),
    persona(ling,       f, desconocido, selma)
]).

% ---------- Acceso a la lista mediante member/2 ----------
persona_info(Nombre, Genero, Padre, Madre) :-
    familia(Lista),
    member(persona(Nombre, Genero, Padre, Madre), Lista).

hombre(X) :- persona_info(X, m, _, _).
mujer(X)  :- persona_info(X, f, _, _).

% Relaciones directas, ahora obtenidas de la lista en vez de
% ser hechos independientes como en la Actividad 01.
padre_de(P, H) :- persona_info(H, _, P, _), P \= desconocido.
madre_de(M, H) :- persona_info(H, _, _, M), M \= desconocido.

% ---------- REGLAS (sin cambios en la logica, solo en el origen
%            de los datos, que ahora viene de la lista) ----------
progenitor_de(X, Y) :- padre_de(X, Y).
progenitor_de(X, Y) :- madre_de(X, Y).

abuelo(X, Y) :- hombre(X), progenitor_de(X, P), progenitor_de(P, Y).
abuela(X, Y) :- mujer(X), progenitor_de(X, P), progenitor_de(P, Y).

hermano_de(X, Y) :-
    hombre(X), progenitor_de(P, X), progenitor_de(P, Y), X \= Y.
hermana_de(X, Y) :-
    mujer(X), progenitor_de(P, X), progenitor_de(P, Y), X \= Y.

tio_de(X, Y) :- hombre(X), progenitor_de(P, Y), hermano_de(X, P).
tia_de(X, Y) :- mujer(X), progenitor_de(P, Y), hermana_de(X, P).

primo_de(X, Y) :-
    hombre(X), progenitor_de(P, X), (tio_de(P, Y) ; tia_de(P, Y)).
prima_de(X, Y) :-
    mujer(X), progenitor_de(P, X), (tio_de(P, Y) ; tia_de(P, Y)).

% Regla nueva que aprovecha listas: todos los hijos de una
% persona, devueltos como una unica lista ordenada.
hijos_de(Padre, Hijos) :-
    findall(H, progenitor_de(Padre, H), Hijos0),
    sort(Hijos0, Hijos).


% =========================================================
% PARTE 2: Grafo dirigido de ciudades (Canada) con listas
% =========================================================

% ---------- HECHO UNICO: lista de estructuras nodo/2 ----------
% nodo(Nombre, ListaDeVecinos), ListaDeVecinos es una lista de
% estructuras par(Destino, Costo) -> lista de listas/estructuras
% en lugar de los 9 hechos arco/3 sueltos de la Actividad 02.
grafo([
    nodo(vancouver,  [par(edmonton, 16), par(calgary, 13)]),
    nodo(edmonton,   [par(saskatoon, 12)]),
    nodo(calgary,    [par(edmonton, 4), par(regina, 14)]),
    nodo(saskatoon,  [par(calgary, 9), par(winnipeg, 20)]),
    nodo(regina,     [par(saskatoon, 7), par(winnipeg, 4)]),
    nodo(winnipeg,   [])
]).

% ---------- Acceso a la lista mediante member/2 ----------
vecinos_de(Nodo, Vecinos) :-
    grafo(G),
    member(nodo(Nodo, Vecinos), G).

arco(X, Y, Costo) :-
    vecinos_de(X, Vecinos),
    member(par(Y, Costo), Vecinos).

% ---------- REGLAS (misma logica que en la Actividad 02, ahora
%            leyendo arco/3 desde las listas de vecinos) ----------
conectado(X, Y) :- conectado(X, Y, [X]).

conectado(X, Y, _) :- arco(X, Y, _).
conectado(X, Y, Visitados) :-
    arco(X, Z, _),
    \+ member(Z, Visitados),
    conectado(Z, Y, [Z|Visitados]).

conexion_de(Nodo, Vecino, Costo) :- arco(Nodo, Vecino, Costo).
conexion_de(Nodo, Vecino, Costo) :- arco(Vecino, Nodo, Costo).

tiene_aristas(X) :- arco(X, _, _).
tiene_aristas(X) :- arco(_, X, _).

costo_via(X, Y, Z, Costo) :-
    arco(X, Y, C1),
    arco(Y, Z, C2),
    Costo is C1 + C2.


% =========================================================
% CONSULTAS DE VALIDACION (mismas consultas que en Act. 01 y 02)
% =========================================================
:- initialization(main).

main :-
    nl, write('========== PARTE 1: Familia Simpson (con listas) =========='), nl,

    nl, write('--- abuelo(X, bart) ---'), nl,
    forall(abuelo(X1, bart), format('abuelo(~w, bart)~n', [X1])),

    nl, write('--- abuela(X, bart) ---'), nl,
    forall(abuela(X2, bart), format('abuela(~w, bart)~n', [X2])),

    nl, write('--- hermanos de lisa ---'), nl,
    ( setof(H, hermano_de(H, lisa), LH) -> true ; LH = [] ),
    format('hermano_de(X, lisa) = ~w~n', [LH]),

    nl, write('--- hermanas de bart ---'), nl,
    ( setof(H2, hermana_de(H2, bart), LH2) -> true ; LH2 = [] ),
    format('hermana_de(X, bart) = ~w~n', [LH2]),

    nl, write('--- tia_de(selma, bart) ---'), nl,
    ( tia_de(selma, bart) -> write('true') ; write('false') ), nl,

    nl, write('--- primas de bart ---'), nl,
    ( setof(P, prima_de(P, bart), LP) -> true ; LP = [] ),
    format('prima_de(X, bart) = ~w~n', [LP]),

    nl, write('--- primos de bart ---'), nl,
    ( setof(P2, primo_de(P2, bart), LP2) -> true ; LP2 = [] ),
    format('primo_de(X, bart) = ~w~n', [LP2]),

    nl, write('--- hijos_de(homero, Lista) ---'), nl,
    hijos_de(homero, HijosHomero),
    format('hijos_de(homero, ~w)~n', [HijosHomero]),

    nl, write('========== PARTE 2: Grafo de ciudades (con listas) =========='), nl,

    nl, write('--- Existe conexion entre Saskatoon y Vancouver? ---'), nl,
    ( conectado(saskatoon, vancouver) -> write('true') ; write('false') ), nl,

    nl, write('--- Nodos conectados con Regina y costo de cada conexion ---'), nl,
    forall(conexion_de(regina, Vecino, Costo),
           format('regina -- ~w  (costo: ~w)~n', [Vecino, Costo])),

    nl, write('--- tiene_aristas/1 por nodo ---'), nl,
    forall(member(N, [vancouver, edmonton, calgary, saskatoon, regina, winnipeg]),
           ( tiene_aristas(N)
           -> format('tiene_aristas(~w) = true~n', [N])
           ;  format('tiene_aristas(~w) = false~n', [N])
           )),

    nl, write('--- costo_via(vancouver, edmonton, saskatoon, C) ---'), nl,
    costo_via(vancouver, edmonton, saskatoon, C1),
    format('Costo = ~w~n', [C1]),

    nl, write('--- costo_via(calgary, regina, winnipeg, C) ---'), nl,
    costo_via(calgary, regina, winnipeg, C2),
    format('Costo = ~w~n', [C2]),

    nl, write('--- Es posible viajar de Edmonton a Calgary? ---'), nl,
    ( conectado(edmonton, calgary) -> write('true') ; write('false') ), nl,

    nl, halt.
