{
La biblioteca sarmiento necesita un sistema para obtener estadisticas sobre los libros prestados. De cada prestamo se conoce: numero de 
prestamo, ISBN del libro y codigo de socio. La lectura finaliza con codigo de socio 0 y todos los prestamos realizados a un mismo socio
se leen consecutivamente.

a) implementar un modulo que lea informacion de los prestamos y genere:
	i) una estructura de datos eficiente para la busqueda por ISBN del libro.
	ii) una estructura donde se almacenen codigos de socio junto a su cantidad de prestamos.
b) Implementar un modulo que reciba la estructura generada en a) y un ISBN y retorne la cantidad de prestamos de ese ISBN.
c) Realizar un modulo recursiva que reciba la estructura generada en a) ii y un valor X y retorne la cantidad de socios
con cantidad de prestamos superior al valor X.
}

program ejer1;

type

prestamo= record
	numero,ISBN,cod:integer;
end;

arbol= ^nodo;

nodo= record
	dato:prestamo;
	HD,HI:arbol;
end;

lista= ^n;

n= record
	dato:prestamo;
	sig:lista;
	cant:integer;
end;

procedure leer(var p:prestamo);
begin
	writeln('Ingrese codigo de socio: '); readln(p.cod);
	if(p.cod <> 0) then begin
		writeln('Ingrese numero: ' ); readln(p.numero);
		writeln('Ingrese isbn: '); readln(p.ISBN);
	end;
end;

procedure crearArbol(var a:arbol; p:prestamo);
begin
	if(a = nil) then begin
		new(a);
		a^.dato:=p; a^.HD:=nil; a^.HI:=nil;
	end
	else begin
		if(a^.dato.ISBN < p.ISBN) then
			crearArbol(a^.HD,p)
		else
			crearArbol(a^.HI,p);
	end;
end;

procedure cargarArbol(var a:arbol);
var
p:prestamo;
begin
	leer(p);
	while (p.cod <> 0) do begin
		crearArbol(a,p);
		leer(p);
	end;		
end;

procedure imprimirArbol(a:arbol);
begin
	if(a <> nil) then begin
		imprimirArbol(a^.HI);
		writeln('codigo de socio: ', a^.dato.cod, ' numero de prestamo: ', a^.dato.numero, ' isbn: ' , a^.dato.ISBN);
		imprimirArbol(a^.HD);
	end;
end;

procedure agregarOrdenado(var l: lista; cod:integer);
var
  nue, act, ant: lista;
begin
  act := l;
  ant := l;

  // Buscar si el código de socio ya está en la lista
  while (act <> nil) and (act^.dato.cod <> cod) do
  begin
    ant := act;
    act := act^.sig;
  end;

  if (act <> nil) then
  begin
    // Si el socio ya existe en la lista, incrementar su contador de préstamos
    act^.cant := act^.cant + 1;
  end
  else
  begin
    // Si no existe, agregar nuevo nodo
    new(nue);
    nue^.dato.cod := cod;
    nue^.cant := 1;
    nue^.sig := nil;

    if (l = nil) or (l^.dato.cod > cod) then
    begin
      nue^.sig := l;
      l := nue;
    end
    else
    begin
      ant^.sig := nue;
      nue^.sig := act;
    end;
  end;
end;

procedure cargarLista(var l: lista; a: arbol);
begin
  if (a <> nil) then
  begin
    // Recorrer el árbol en inorden y agregar los préstamos a la lista
    cargarLista(l, a^.HI);
    agregarOrdenado(l, a^.dato.cod);
    cargarLista(l, a^.HD);
  end;
end;

procedure imprimirLista(l: lista);
begin
  while (l <> nil) do
  begin
    writeln('Codigo de socio: ', l^.dato.cod, ' Cantidad de prestamos: ', l^.cant);
    l := l^.sig;
  end;
end;

var
	a:arbol; l:lista;
begin
	a:=nil; l:=nil;
	cargarArbol(a);
	imprimirArbol(a);
	
	 cargarLista(l, a);
	 writeln('Lista de socios y cantidad de prestamos:');
	 imprimirLista(l);
end.
