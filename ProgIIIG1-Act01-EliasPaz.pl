% =========================================================
% Actividad 01 - Programacion III
% Estudiante: Elias Alejandro Paz Marin, Jeremy Salazar Isaza
% =========================================================

% ---------------------------------------------------------
% Ejercicio 1: Arbol genealogico (familia Simpson)
% ---------------------------------------------------------

% ---------- HECHOS: genero ----------
hombre(abraham).
hombre(clancy).
hombre(herbert).
hombre(homero).
hombre(bart).

mujer(mona).
mujer(jacqueline).
mujer(marge).
mujer(patty).
mujer(selma).
mujer(lisa).
mujer(maggie).
mujer(ling).

% ---------- HECHOS: relaciones directas ----------
padre_de(abraham, herbert).
padre_de(abraham, homero).
madre_de(mona, homero).

padre_de(clancy, marge).
madre_de(jacqueline, marge).
padre_de(clancy, patty).
madre_de(jacqueline, patty).
padre_de(clancy, selma).
madre_de(jacqueline, selma).

padre_de(homero, bart).
madre_de(marge, bart).
padre_de(homero, lisa).
madre_de(marge, lisa).
padre_de(homero, maggie).
madre_de(marge, maggie).

madre_de(selma, ling).

% ---------- REGLAS: relaciones de mas de una generacion ----------
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

% ---------- CONSULTAS DE VALIDACION ----------
% ?- abuelo(X, bart).
% ?- abuela(X, bart).
% ?- setof(X, hermano_de(X, lisa), L).
% ?- setof(X, hermana_de(X, bart), L).
% ?- tia_de(selma, bart).
% ?- setof(X, prima_de(X, bart), L).
% ?- setof(X, primo_de(X, bart), L).


% ---------------------------------------------------------
% Ejercicio 2: El Coronel West es un criminal
% ---------------------------------------------------------

% ---------- HECHOS ----------
americano(west).
enemigo(corea_del_sur, estados_unidos).
propietario(corea_del_sur, m1).
arma(m1).
vendio(west, m1, corea_del_sur).

% ---------- REGLAS ----------
hostil(X) :- enemigo(X, estados_unidos).

vende_armas(X, Y, Z) :-
    vendio(X, Y, Z),
    arma(Y),
    propietario(Z, Y).

criminal(X) :-
    americano(X),
    arma(Y),
    vende_armas(X, Y, Z),
    hostil(Z).

% ---------- CONSULTA DE VALIDACION ----------
% ?- criminal(west).
% ?- hostil(corea_del_sur).
% ?- vende_armas(west, Y, corea_del_sur).
