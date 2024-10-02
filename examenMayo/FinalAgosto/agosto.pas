{Un supermercado desea un programa para organizar la informacion de las compras de los clientes. El supermercado tiene registrada
en papel todas las compras de sus clientes, de las cuales se conoce: el dni de un cliente, cantidad de productos comprados y
monto de la compra. Un mismo cliente pudo haber hecho mas de una compra.

Realice un programa que contenga e invoque a:

a) Un modulo que lea informacion de las compras(hasta ingresar una con dni igual a cero) y genere una estructura que permita la 
busqueda eficiente por dni y que, para un mismo dni de cliente, contabilice el total de compras realizadas y el monto total 
abonado en concepto de compras.

b) Un modulo que reciba la estructura generada en a) y un numero x, y que devuelva una lista ordenada por dni que contenga todos
los clientes que hayan efectuado un numero de compras mayor a x.}

program c;

type

compra= record
	dni:integer;
	cant:integer;
	monto:real;
end;

arbol= ^nodo;

nodo= record
	dato:compra;
	HD,HI:arbol;
end;

lista= ^x;

x= record
	dato:compra;
	sig:lista;
end;

procedure leer(var c:compra);
begin
	writeln('ingrese un dni: '); readln(c.dni);
	if(c.dni <> 0) then begin
		writeln('ingrese una cantidad: '); readln(c.cant);
		writeln('ingrese un monto: '); readln(c.monto);
	end;
end;


procedure insertar(var a:arbol; c:compra);
begin
	if(a = nil) then begin
		new(a);
		a^.dato:=c; 
		a^.HD:=nil;
		a^.HI:=nil;
	end
	else begin
		if(a^.dato.dni < c.dni) then
			insertar(a^.HD,c)
		else
			if(a^.dato.dni > c.dni) then
				insertar(a^.HI,c)
			else begin
				a^.dato.cant:= a^.dato.cant + c.cant;
				a^.dato.monto:= a^.dato.monto + c.monto; 	
			end;
	end;
end;

procedure cargar(var a:arbol);
var
c:compra;
begin
	leer(c);
	while (c.dni <> 0) do begin
		insertar(a,c);
		leer(c);
	end;
end;

procedure imprimir(a:arbol);
begin
	if(a <> nil) then begin
		imprimir(a^.HD);
		writeln('dni : ', a^.dato.dni, ' cantidad: ', a^.dato.cant, ' monto: ', a^.dato.monto:2:0);
		imprimir(a^.HI);
			
	end;
end;

procedure agregarAdelante(var l:lista; dato:compra);
var
	nue: lista;
begin
	new(nue);
	nue^.dato := dato;
	nue^.sig := l;
	l := nue;
end;

procedure cargarLista(var l:lista; a:arbol; x:integer);
begin
	if(a <> nil) then begin
		cargarLista(l,a^.HD,x);
		if (a^.dato.cant > x) then
			agregarAdelante(l,a^.dato);
		cargarLista(l,a^.HI,x);
	end;
end;

procedure imprimirLista(l:lista);
begin
	while (l <> nil) do begin
		writeln('dni :' , l^.dato.dni, ' cantidad de compras: ', l^.dato.cant);
		l:=l^.sig;
	end;
end;

var
a:arbol; l:lista; y:integer;
begin
	a:=nil;
	cargar(a);
	
	writeln('Arbol');
	imprimir(a);
	
	l:=nil;
	writeln('Introduce una cantidad de compras: '); readln(y);
	cargarLista(l,a,y);
	imprimirLista(l);
end.
	
