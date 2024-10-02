{Se desea procesar las polizas de una compañia de seguros. De cada poliza se conoce: dni del cliente, suma asegurada, valor cuota y
fecha de vencimiento. Un cliente puede tener mas de una poliza. Las polizas se comenzaron a emitir a partir del 2000 y finalizaron
de emitirse en 2023. Realice un programa que contenga 

a) Un modulo que lea polizas hasta leer una poliza con dni -1, y las almacene en una estructura agrupadas por año de vencimiento.
En cada año las polizas deben quedar por suma asegurada.
b) Un modulo que reciba la estructura generada en a) y devuelva otra estructura con las polizas cuya suma asegurada sea menor a un
valor recibido por parametro. Esta estructura debe ser eficiente para la busqueda por dni del cliente.
c) Un modulo que reciba la estructura generada en b) y devuelva la cantidad de polizas cuyo valor de cuotas es mayor a un valor
recibido por parametro.}

program ejer;

type

sub=2000..2023;

poliza= record
	dni:integer;
	suma:real;
	cuota:real;
	anio:sub;	
end;

lista= ^nodo;

nodo= record
	dato:poliza;
	sig:lista;
end;

vector= array[2000..2023] of lista;

arbol= ^xs;

xs= record
	dato:poliza;
	hd,hi:arbol;
end;

procedure leer(var p:poliza);
begin
	writeln('dni : '); readln(p.dni);
	if(p.dni <> -1) then begin
		writeln('suma : '); readln(p.suma);
		writeln('cuota : '); readln(p.cuota);
		writeln('Introduzca el anio : '); readln(p.anio);
	end;
end;

procedure agregarOrdenado (var l:lista; p:poliza);
var
nue: lista;
act, ant: lista; 
begin
  new (nue);
  nue^.dato := p;
  act := L; 
  ant := L;
  while( act <> nil)and(p.suma < act^.dato.suma)do
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

procedure cargarVector(var v:vector);
var
	p:poliza;
begin
	leer(p);
	while(p.dni <> -1) do begin
		agregarOrdenado(v[p.anio],p);
		leer(p);
	end;
end;

procedure imprimirVector(var v:vector);
var
l:lista;
i:integer;
begin
	for i:=2000 to 2023 do begin
		writeln('Anio: ', i);
		l:=v[i];
		while(l <> nil) do begin
			writeln('dni: ',l^.dato.dni, ' suma: ',l^.dato.suma:2:0);
			l:=l^.sig;
		end;
	end;
end;

procedure insertar(var a:arbol; p:poliza);
begin
	if(a=nil) then begin
		new(a);
		a^.dato:=p;a^.hd:=nil;a^.hi:=nil;
	end
	else
		if(a^.dato.dni < p.dni) then
			insertar(a^.hd,p)
		else
			insertar(a^.hi,p);
end;

procedure cargarArbol12(var a:arbol; v:vector; x:real);
var
i:sub;
l:lista;
begin
	for i:= 2000 to 2023 do begin
		l:= v[i];
		while (l <> nil) do begin
			if(l^.dato.suma < x) then begin
				insertar(a,l^.dato);
			end;
			l:=l^.sig;
		end;
	end;
end;

procedure imprimirArbol(a:arbol);
begin
	if(a <> nil) then begin
		//writeln('entro');
		imprimirArbol(a^.hi);
		writeln('dni: ', a^.dato.dni);
		imprimirArbol(a^.hd);
	end;
end;

var
v:vector; a:arbol; x:real;
begin
	cargarVector(v);
	imprimirVector(v);
	
	a:=nil;
	writeln('ingrese un numero: '); readln(x);
	cargarArbol12(a,v,x);
	imprimirArbol(a);
end.
