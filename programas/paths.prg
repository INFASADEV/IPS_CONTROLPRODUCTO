PUBLIC titulox,pusuarioid,pusuario,pnomuser,autper 
titulox = ""
Set Path To C:\controlEntradaProducto\INFORMES,C:\controlEntradaProducto\Data,C:\controlEntradaProducto\FORMULARIOS,C:\controlEntradaProducto\BITMAPS,C:\controlEntradaProducto\PROGRAMAS,C:\controlEntradaProducto\LIBRERIAS,C:\controlEntradaProducto\Menus
Public IPSRUTAFINAL,CONSISDATABASE,HCONN,LNRESULT,PSBTOTAL,EMPRESAACTIVA,MODULOPROGRAMA,EMPRESAACTIVANIT,EMPRESAACTIVADIREC,USERSISX,MPROGRA,RCONN,CRESULT,EMPRESAACTIVALOGOFACTURA,opctipx,provact
provact = ''
autper = 0
CMFCONN=0
Store 190 To PUSUARIOID
PUSUARIONOMBRE="Elmer Rivera"
USUARIOINGRESO="Elmer Rivera"
PUSUARIO="elmerrivera"
Store 'C:\controlEntradaProducto\BITMAPS\INFASA02.JPG' To EMPRESAACTIVALOGO
STORE 'C:\controlEntradaProducto\BITMAPS\LOGO2INFASA.jpg' TO EMPRESAACTIVALOGOFACTURA
Public LCDSNLESS

Store .F. To Serv
Store .T. To ESPRUEBA

If Serv=.T.
Else
	If ESPRUEBA=.T.
		*LCDSNLESS="DRIVER={SQL Server};SERVER=IT-SRV-DB1\SQLINFASA;Database=CONSIS31072018;uid=db.user;pwd=db.user@inFasa90" && CONEXION AL SERVIDOR
		LCDSNLESS="DRIVER={SQL Server};SERVER=IT-SRV-DB1\SQLINFASA;Database=CONSIS;uid=db.user;pwd=db.user@inFasa90" && CONEXION AL SERVIDOR
	Else
		LCDSNLESS="DRIVER={SQL Server};SERVER=ERivera-it;Database=CONSIS;Trusted_Connection=True" &&&NATIVE CLIENTE CONSIS SERVIDOR SQL SERVER 2014
	Endif
Endif

If "SISCONSIS"$LCDSNLESS
	Store Atc(';',LCDSNLESS) To PYCOMA
	Store Substr(LCDSNLESS,5,PYCOMA-5) To DRIVERACTIVO
	Store '' To SERVIDORACTIVO,INSTANCIAACTIVA
Else
	Store Atc('=',LCDSNLESS,2) To SIGIGUAL
	Store Atc(';',LCDSNLESS,2) To PYCOMA
	Store Substr(LCDSNLESS,SIGIGUAL+1,PYCOMA-(SIGIGUAL+1)) To INSTANCIAACTIVA
	Store '' To DRIVERACTIVO
Endif
*!*	WAIT WINDOW driveractivo
IF FILE('\\it-srv-db1\C$\IPS\exe\tmparc.txt') = .t. 
	HCONN=Sqlstringconnect(LCDSNLESS,.T.)
	RCONN=HCONN
endif

PUBLIC valx
valx = 0
Store "controlEntradaProducto" To MPROGRA

Set Default To C:\controlEntradaProducto


Store "INFASA" To EMPRESAACTIVA
Store "0001" To EMPRESAACTIVACOD
Store "INDUSTRIA FARMACEUTICA SOCIEDAD ANONIMA" To EMPRESAACTIVARAZON
Store "IPSTMP\Elmerrivera0001" To PIFOLDER
Store "KM. 15.5 CARRETERA ROOSEVELT 0-80 ZONA 2 MIXCO,GUATEMALA" To EMPRESAACTIVADIREC
FORMSOLOLECTURA=0
LATASA=8.3
PCAMBIOCLA=.T.
RIBBONTHEME=1
PPRINCIPAL=.T.
OPCIONENCURSO=""
PGRUPOUSUARIO='0001'
IDMAP = "M"
Set Safety Off
Set StrictDate To 0
Set Echo Off
Set Multilocks Off &&&IMPORTANTISIMO
Sys(3051, 1000) &&&tiempo de tratar de bloquear otra vez el registro.
Set Console Off
Set Delete On
Set Stat Bar Off
Set Talk Off
Set Exclusive Off
Set Currency To ('Q.')
Set Century On
Set Date BRIT
Set Hours To 24
Set REPORTBEHAVIOR 80
Set Optimize On
SET PROCEDURE TO imprimirArchivo

