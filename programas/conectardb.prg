TRY
	OKBPRUEBACONNEX=SQLEXEC(HCONN,'USE CONSIS')
	*OKBPRUEBACONNEX=SQLEXEC(HCONN,'USE CONSIS31072018')	
CATCH
	OKBPRUEBACONNEX=0
ENDTRY
IF OKBPRUEBACONNEX<>1	
		*LCDSNLESS="DRIVER={SQL Server};SERVER=IT-SRV-DB1\SQLINFASA;Database=CONSIS09062018;uid=db.user;pwd=db.user@inFasa90" && CONEXION AL SERVIDOR
		LCDSNLESS="DRIVER={SQL Server};SERVER=IT-SRV-DB1\SQLINFASA;Database=CONSIS;uid=db.user;pwd=db.user@inFasa90" && CONEXION AL SERVIDOR
		HCONN=SQLSTRINGCONNECT(LCDSNLESS,.T.)
		OKBPRUEBACONNEX2=SQLEXEC(HCONN,'USE CONSIS')		
		*OKBPRUEBACONNEX2=SQLEXEC(HCONN,'USE CONSIS31072018')				
	IF OKBPRUEBACONNEX2=1
		CONEXXX=1
	ELSE
		CONEXXX=0
	ENDIF
ELSE
	CONEXXX=1
ENDIF
RETURN CONEXXX