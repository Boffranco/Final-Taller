procedure agregarAtras(var l: lista; var ult: lista; dato: integer);
var
    nue:lista;
begin
	new(nue);
	nue^.dato := dato;
	nue^.sig := nil;
	if (l = nil) then
		l := nue
	else
		ult^.sig := nue;
	ult := nue;	
end;