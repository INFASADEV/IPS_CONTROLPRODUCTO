***convertir fecha a formato SQL

PARAMETERS fechavfp

STORE ALLTRIM(STR(YEAR(fechavfp))) TO mano
STORE PADL(ALLTRIM(STR(MONTH(fechavfp))),2,'0') TO mmes
STORE PADL(ALLTRIM(STR(day(fechavfp))),2,'0') TO mdia

STORE mano+'-'+mmes+'-'+mdia TO fechasql

RETURN fechasql