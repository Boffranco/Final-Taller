{La oficina de mantenimiento de una mepresa recibe llamadas telefonicas con problemas reportados por distintos empleados de la 
empresa. En cada llamada recibe: nivel de la importancia del problema (numero entre 1..5), sector de la empresa donde se detecto
el problema (numero entre 1..50), numero de empleados afectados por el problema.

Implemente en Pascal un programa que invoque a:

a) Un modulo que simule la recepcion de 10 llamadas en total con problemas reportados (puede generar numeros random) y almacene
toda la informacion generada en una estructrua agrupada por nivel de importancia y ordenada por sector de la empresa donde se
detecto el problema.

b) Un modulo que reciba la estructura generada en a) y un nivel de importancia N y devuelva una estructura eficiente para la busqueda
, ordenada por numero de empleados afectados, con todos los problemas del nivel N.

c) Un modulo que reciba la estructura generada en b) y devuelva el numero de sector del problema con mayor cantidad de empleados
afectados.}

program c;

type

sub= 1..5;
rango= 1..50;

llamada= record
	nivel:sub;
	sector:rango;
	numero:integer;
end;

lista= ^nodo;

nodo= record
	dato:llamada;
	sig:lista;
end;

vector = array [sub] of lista;

arbol= ^ai;

ai= record
	dato:llamada;
	HD:arbol;
	HI:arbol;
end;

sec= array [rango] of integer;

procedure leer(var l:llamada);
begin
	l.nivel := random(5) + 1;
	writeln('sector de 1 a 50: '); readln(l.sector);
	writeln('numero: '); readln(l.numero);
end;

procedure agregarOrdenado (var l:lista; p:llamada);
var
nue: lista;
act, ant: lista; 
begin
  new (nue);
  nue^.dato := p;
  act := L; 
  ant := L;
  while( act <> nil)and(p.sector < act^.dato.sector)do
  begin
    ant := act;
    act:= act^.sig;
  end;
  if (act = ant) then 
    L:= nue
  else 
    ant^.sig:= nue;
  nue^.sig:= act;
end;

procedure cargar(var v:vector);
var
	l:llamada;
	i:integer;
begin
	for i:= 1 to 10 do begin
		leer(l);
		agregarOrdenado(v[l.nivel],l);
	end;
end;

procedure imprimirLista(l:lista);
begin
	while l <> nil do begin
		writeln ('nivel: ', l^.dato.nivel, ' sector: ', l^.dato.sector);
		l:=l^.sig;
	end;
end;

procedure imprimirVector(v:vector);
var
i:integer;
begin
	for i:= 1 to 5 do begin
		writeln('nivel: ', i);
		imprimirLista(v[i]);
		writeln('-----------------------------------');
	end;
end;

//b

procedure cargarArbol (var a:arbol; l:llamada);
begin
	
	if (a = nil) then begin
		new(a);
		a^.dato:=l;
		a^.HD:=nil;
		a^.HI:=nil;
	end
	else 
		if (a^.dato.numero > l.numero) then
			cargarArbol(a^.HD, l)
	else
		cargarArbol(a^.HI, l);		
end;

procedure hacerB (var a:arbol; n:sub; v:vector);
var
    l: lista;
begin
	l:= v[n];
	while (l <> nil) do begin
		cargarArbol(a,l^.dato);
		l:= l^.sig;
	end;
end;

procedure imprimirArbol(a: arbol);
begin
    if a <> nil then
    begin
        imprimirArbol(a^.HI);
        writeln('Numero de empleados afectados: ', a^.dato.numero);
        imprimirArbol(a^.HD);
    end;
end;

//c

procedure hacerC (a:arbol; var s:sec);
begin
	if (a <> nil) then begin
		s[a^.dato.sector]:= s[a^.dato.sector] + a^.dato.numero;
		hacerC(a^.HD,s);
		hacerC(a^.HI,s);
	end;
end;

procedure maximo (s:sec);
var
i:rango; max:integer; maxSec:integer;
begin
	max:=0; maxSec:=0;
	for i:= 1 to 50 do begin
		if(max < s[i]) then begin
			max:= s[i];
			maxSec:= i;
		end;
	end;
	writeln('El sector con mayor cantidad de empleados afectados es: ', maxSec, ' con ', max, ' empleados afectados.');
end;

procedure imprimir(s:sec);
var
	i:rango;
begin
	for i:= 1 to 50 do 
		writeln('sector: ', i, ' cantidad de personas afectadas: ', s[i]);
end;

var
v:vector;
n:sub;
a:arbol;
s:sec;
begin
	randomize;
	cargar(v);
	imprimirVector(v);
	
	writeln('ingrese un numero de 1 a 5: '); readln(n);
	hacerB(a,n,v);
	imprimirArbol(a);
	
	hacerC(a,s);
	maximo(s);
	imprimir(s);
end.
