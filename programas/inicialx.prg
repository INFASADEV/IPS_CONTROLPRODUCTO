*!*	PUBLIC SISTCONFIG,MPROGRA,HCONN,HOMESISTEMA,RUTAABRIR,IPSRUTAFINAL,ESTADOPER,NOMMODULO,PERMODU,EPERIOMOD,CMFCONN,ESREPLICA,MNATIVA
*!*	PUBLIC IDMAP,PASSBD,USERBD,DATAACTIV,PASSUSERUNIMAP,USERUNIMAP,RUTAUNIMAP,RUTAFOTOSEMP,OPCIONDEMENU,RUTAREPLICA,DATASQL,DATACMF
*!*	PUBLIC PUSUARIO,PUSUARIONOMBRE,USERSISX,PERADMIN,PCLAVEP,PUSUARIOID,PIFOLDER,ESSERVIDOR,RUTAINI,IDTERX,PPRINCIPAL,SERIERECIBOMAN,PERFILUSUARIO,USERNIVEL
*!*	PUBLIC EMPRESAACTIVACOD,EMPRESAACTIVALOGO,EMPRESAACTIVA,EMPRESAACTIVANIT,EMPRESAACTIVARAZON,EMPRESAACTIVADIREC,EMPRESAACTIVAPATENTE,EMPRESAACTIVALOGOFACTURA,UBIESTACION,VRUTAABRIR,INSTANCIAEXT,IMAGENREPORT

*!*	&&&&VARIABLES PUBLICAS A LIBERAR
*!*	PUBLIC IDTERMINAL,DSNNOMBRE

*!*	STORE '' TO EMPRESAACTIVACOD,EMPRESAACTIVALOGO,EMPRESAACTIVA,EMPRESAACTIVANIT,EMPRESAACTIVARAZON,EMPRESAACTIVADIREC,EMPRESAACTIVAPATENTE,EMPRESAACTIVALOGOFACTURA
*!*	STORE '' TO ESTADOPER,NOMMODULO,PERMODU,RUTAREPLICA,MNATIVA
*!*	STORE PADL(ALLTRIM(STR(MONTH(DATE()))),2,'0')+ALLTRIM(STR(YEAR(DATE()))) TO EPERIOMOD &&&&PERIODO ACTUAL, SIVE PARA CONCOCER EL PERIODO CONTABLE EN CURSO

*!*	STORE .F. TO INSTANCIAEXT
*!*	STORE 0 TO USERNIVEL

*!*	STORE "IPS" TO MPROGRA
*!*	STORE "C:\IPS" TO HOMESISTEMA
*!*	STORE "Sistema.ini" TO SISTCONFIG
*!*	STORE '&MPROGRA'+'TMP' TO XTMP

*!*	SET STRICTDATE TO 0
*!*	SET ECHO OFF
*!*	SET MULTILOCKS OFF &&&IMPORTANTISIMO
*!*	SYS(3051, 1000) &&&tiempo de tratar de bloquear otra vez el registro.
*!*	SET CONSOLE OFF
*!*	SET DELETE ON
*!*	SET STAT BAR OFF
*!*	SET EXCLUSIVE OFF
*!*	SET CURRENCY TO ('Q.')
*!*	SET CENTURY ON
*!*	SET DATE BRIT
*!*	SET HOURS TO 24
*!*	SET REPORTBEHAVIOR 80
*!*	SET OPTIMIZE ON
*!*	SET SAFETY OFF
*!*	SET TALK OFF
*!*	SYS(987,.T.)  &&&UNICODE TO ANSI

*!*	IF FILE("C:\&XTMP\USERTEMP.DBF") &&&&&&&SI EST� ABRIENDO OTRA EMPRESA, LAS CARPETAS YA EST�N CREADAS
*!*	ELSE
*!*		IF DIRECTORY("&HOMESISTEMA")
*!*		ELSE
*!*			MD &HOMESISTEMA
*!*		ENDIF
*!*		IF DIRECTORY("C:\&MPROGRA"+"TMP")
*!*		ELSE
*!*			MD "C:\&MPROGRA"+"TMP"
*!*		ENDIF
*!*		IF UPPER("&MPROGRA")$UPPER(HOMESISTEMA)
*!*		ELSE
*!*			IF DIRECTORY("C:\&MPROGRA")
*!*			ELSE
*!*				MD "C:\&MPROGRA"
*!*			ENDIF
*!*		ENDIF
*!*	ENDIF
*!*	TRY
*!*		IF DIRECTORY("&HOMESISTEMA"+"\EXE")&&&&&es posible que se est� ejecutando en el servidor y la carpeta est� oculta por eso no la encuentra y trata de crearla
*!*		ELSE
*!*			MD "&HOMESISTEMA"+"\EXE"
*!*		ENDIF
*!*		STORE .F. TO ESSERVIDOR
*!*	CATCH
*!*		STORE .T. TO ESSERVIDOR
*!*	ENDTRY

*!*	STORE LEFT(SYS(0),ATC(' ',SYS(0),1)-1) TO IDTERMINAL


*!*	STORE '&HOMESISTEMA'+'\EXE'+'\&SISTCONFIG' TO RUTAINI
*!*	IF FILE ('&RUTAINI')
*!*		PROC_INISISTEMA('&RUTAINI')
*!*	ELSE
*!*		IDMAP="M"
*!*		*!*		RUTAUNIMAP="\\it-srv-db\ips"
*!*		RUTAUNIMAP="\\SRVINF01\ips"
*!*		USERUNIMAP="Administrator"
*!*		PASSUSERUNIMAP="*!nF@5@1*"
*!*		USERBD="db.user"
*!*		PASSBD="db.user@inFasa90"
*!*		DSNNOMBRE="Infasaprod"
*!*		DATASQL='CONSIS'
*!*	ENDIF

*!*	IF ESSERVIDOR=.T.
*!*	ELSE
*!*		IF FILE("C:\&XTMP\USERTEMP.DBF") &&&&&&&SI EST� ABRIENDO OTRA EMPRESA NO REPITE PROCESOS DE CONEXION, NI PUEDE COPIAR ARCHIVO DE INICIO
*!*		ELSE
*!*			PROC_CHECKREDES()&&&&&&  VERIFICA EL ESTADO DE LAS REDES EN USO, MAPEA LA UNIDAD SI ES NECESARIO Y CONECTA, ELIMINA MAPEOS ANTIGUOS Y CONTROLA ACCESOS A REDES POR EL EXPLORADOR DE WINDOWS &&&&&&&&&CMDRUN()
*!*			PROC_COPYARCHINI() &&&COPIAR ARHCIVO DE DE CONFIGURACION SISTEMA.INI*&&&&&&&&&PROC_INISISTEMA() &&&&&&& PROC_CHECKREDES()
*!*			PROC_COPYARCHIVOS() &&&&&&COPIA ARCHIVOS DE MENU Y AUTOINSTALADOR ******PROC_COPYAUTOINSTALL()

*!*		ENDIF
*!*	ENDIF

*!*	DO DSNLISTADO  &&&&&CREAR EL DRIVER ODBC SI NO EXISTE

*!*	IF ESSERVIDOR=.T.
*!*		STORE '&HOMESISTEMA' TO IDMAP
*!*		SET PATH TO &IDMAP\DATA,C:\&MPROGRA\INFORMES\&MPROGRA,C:\&MPROGRA\INFORMES,C:\&MPROGRA\LIBRERIAS,C:\&MPROGRA\FORMULARIOS,C:\&MPROGRA\BITMAPS,C:\&MPROGRA\PROGRAMAS
*!*	ELSE
*!*		SET PATH TO  C:\&MPROGRA\INFORMES,C:\&MPROGRA\FORMULARIOS,C:\&MPROGRA\BITMAPS,C:\&MPROGRA\PROGRAMAS,C:\&MPROGRA\LIBRERIAS,&HOMESISTEMA\EXE,;
*!*			&IDMAP:\INFORMES,&IDMAP:\INFORMES\&MPROGRA,&IDMAP:\FORMULARIOS,&IDMAP:\BITMAPS,&IDMAP:\PROGRAMAS,&IDMAP:\DATA,&IDMAP:\LIBRERIAS
*!*	ENDIF

*!*	If File('C:\IPS\EXE\FoxyPreviewer.app')
*!*	Else
*!*		Copy File &IDMAP:\Exe\FoxyPreviewer.App To "C:\IPS\EXE\FoxyPreviewer.app"
*!*	Endif

*!*	IF FILE ('&HOMESISTEMA'+'\EXE'+'\&SISTCONFIG')  &&&&DESPUES DE TODO EL PROCESO, EL ARCHIVO INI DEBER�A EXISTIR EN LA MAQUINA LOCAL Y TOMAR ESOS PAR�METROS
*!*	ELSE
*!*		MESSAGEBOX("No Se Encontraron Los Par�metros De Configuraci�n En Su Equipo. Informe Al Administrador Del Sistema",64+0+0,"SISTEMA DE INICIO &MPROGRA")
*!*		QUIT
*!*	ENDIF

*!*	SORTWORK="C:\&MPROGRA"+"TMP"
*!*	PROGWORK="C:\&MPROGRA"+"TMP"
*!*	TMPFILES="C:\&MPROGRA"+"TMP"

*!*	_SCREEN.WINDOWSTATE=2
*!*	_SCREEN.SCROLLBARS= 3
*!*	MODI WINDOW SCREEN NOCLOSE
*!*	CONECTDATA(DSNNOMBRE,USERBD,PASSBD,"HCONN")  &&&&&&CONECTAR A LA BASE DE DATOS
*!*	IF HCONN>0
*!*		STORE 'C:\&MPROGRA\BITMAPS\NUEVOFONDO.JPG' TO NFONSISTEM
*!*		STORE "SELECT RUTA FROM FONDOSISTEMA WHERE SISTEMA='&MPROGRA' AND CONVERT(DATE,CURRENT_TIMESTAMP) BETWEEN FECHAINI AND FECHAFIN" TO QUENFONDO
*!*		CON =SQLEXEC(HCONN,QUENFONDO,'TABLAFONDO')
*!*		IF CON>0
*!*			SELECT TABLAFONDO
*!*			GO TOP
*!*			IF EMPTY(TABLAFONDO.RUTA) OR ALLTRIM(TABLAFONDO.RUTA)==''
*!*			ELSE
*!*				STORE ALLTRIM(TABLAFONDO.RUTA) TO NFONSISTEM
*!*			ENDIF
*!*			Use In TABLAFONDO
*!*		ELSE
*!*		ENDIF
*!*		_SCREEN.ADDOBJECT("oImg", "image")
*!*		*!*		_Screen.oImg.Picture = 'C:\CONSIS\BITMAPS\NUEVOFONDO.JPG'
*!*		_SCREEN.OIMG.PICTURE = "&NFONSISTEM"
*!*		_SCREEN.OIMG.VISIBLE = .T.
*!*		_SCREEN.OIMG.STRETCH = 2
*!*		_SCREEN.OIMG.WIDTH=_SCREEN.WIDTH
*!*		_SCREEN.OIMG.HEIGHT=_SCREEN.HEIGHT
*!*		_SCREEN.OIMG.TOP=0
*!*		_SCREEN.OIMG.LEFT=0
*!*		_SCREEN.OIMG.ANCHOR=15
*!*		READY=SQLEXEC(HCONN,'USE &DATASQL')
*!*		IF READY>0
*!*		ELSE
*!*			MESSAGEBOX('No Es Posible Conectar Con La Base De Datos, Notificar A Inform�tica',0+64+0,'Conexi�n base de Datos')
*!*			QUIT
*!*		ENDIF
*!*	ELSE
*!*		MESSAGEBOX('No Es Posible Conectar Con El Servidor De Datos, Notificar A Inform�tica',0+64+0,'Conexi�n base de Datos')
*!*		QUIT
*!*	ENDIF

*!*	*!*	Modi Window Screen Title "&MPROGRA"+Dtoc(Date())
*!*	MODI WINDOW SCREEN TITLE "SISTEMA"+DTOC(DATE())
*!*	_SCREEN.WINDOWSTATE=2
*!*	_SCREEN.SCROLLBARS= 3
*!*	MODI WINDOW SCREEN NOCLOSE

*!*	STACKSIZE = 1000
*!*	STORE SYS(0) TO IDTERX

*!*	IF ESSERVIDOR=.T.
*!*		WAIT WINDOW "ESTA TRABAJANDO EN EL SERVIDOR" NOWAIT
*!*	ELSE
*!*		*************************************BUSCANDO ACTUALIZACION********************************************
*!*		LOCAL ACTUALIZAR
*!*		STORE RIGHT(SYS(0),(LEN(SYS(0))-(ATC('#',IDTERX,1)+1))) TO USERPC
*!*		*!*		Store "&MPROGRA - "+Upper(Alltrim(USERPC)) To FORMACTIVO
*!*		STORE "&MPROGRA - " TO FORMACTIVO
*!*		ISRUNNING=VERPROGRAMAACTIVO('&FORMACTIVO','','')
*!*		IF CORRESIST=.T.
*!*			STORE .F. TO ACTUALIZAR
*!*		ELSE
*!*			STORE .T. TO ACTUALIZAR
*!*		ENDIF
*!*		RELEASE CORRESIST
*!*		*!*		ACTUALIZAR=ESTACORRIENDO("&MPROGRA..exe")
*!*		*****************************************************************************************************************************
*!*		***CODIGO PARA PODER ACTUALIZAR LOS REPLICADORES EN TIEMPO DE EJECUCION***
*!*		*****************************************************************************************************************************
*!*		DO CASE  &&&&(RP01-MAQUINA DE REPLICADOR)
*!*			CASE "RP"$UPPER(IDTERMINAL)
*!*				STORE .T. TO ESREPLICA
*!*				*!*			STORE STRTRAN(IDTERMINAL,' ','')TO USERREPLICA
*!*				*!*			STORE STRTRAN(USERREPLICA,'#','')TO USERREPLICA
*!*				*!*			STORE ALLTRIM(USERREPLICA) TO USERREPLICA
*!*				STORE SYS(0) TO IDTER
*!*				STORE RIGHT(SYS(0),(LEN(SYS(0))-(ATC('#',IDTER,1)+1))) TO USERREPLICA
*!*				STORE "C:\&MPROGRA"+"TMP\"+"&USERREPLICA" TO RUTAABRIR
*!*				WAIT WINDOW "Trabajando Con Replicador &IDTERMINAL &USERREPLICA" NOWAIT
*!*				IF DIRECTORY('&RUTAABRIR')
*!*				ELSE
*!*					WAIT WINDOW "CREANDO &RUTAABRIR"
*!*					MD &RUTAABRIR
*!*				ENDIF
*!*				STORE ALLTRIM(RUTAABRIR) TO RUTAREPLICA
*!*			OTHERWISE
*!*				STORE .F. TO ESREPLICA
*!*				STORE '&HOMESISTEMA'+'\EXE' TO RUTAABRIR
*!*		ENDCASE

*!*		STORE "&RUTAABRIR"+"\&MPROGRA"+".EXE" TO VRUTAABRIR
*!*		IF FILE("C:\&XTMP\USERTEMP.DBF") &&&&SI YA EST� ABIERTA UNA EMPRESA, NO SE PUEDE ACTUALIZAR EL ARCHIVO
*!*			WAIT WINDOW "&MPROGRA ESTABA ACTIVO" NOWAIT
*!*		ELSE
*!*			IF FILE("&IDMAP:\EXE\&SISTCONFIG")
*!*				IF FILE("&IDMAP:\EXE\&MPROGRA..EXE")
*!*					IF (ACTUALIZAR=.T.)
*!*						IF FILE("&HOMESISTEMA"+"\EXE\AUTOINSTALL"+"&MPROGRA"+".EXE")  &&&&&EL AUTOINSTALADOR SIEMPRE EST� EN LA CARPETA EXE DEL PROYECTO, SEA REPLICADOR O NO
*!*							IF FILE("&IDMAP:\EXE\AUTOINSTALL"+"&MPROGRA"+".EXE")
*!*								IF FILE("&RUTAABRIR"+"\&MPROGRA"+".EXE")
*!*									STORE FDATE("&RUTAABRIR"+"\&MPROGRA"+".EXE") TO XDATE1
*!*									STORE FTIME("&RUTAABRIR"+"\&MPROGRA"+".EXE") TO XTIME1
*!*									STORE "&RUTAABRIR"+"\&MPROGRA"+".EXE" TO VRUTAABRIR
*!*								ELSE
*!*									STORE {//} TO XDATE1
*!*									STORE '00:00' TO XTIME1
*!*								ENDIF
*!*								STORE FDATE("&IDMAP:\EXE"+"\&MPROGRA"+".EXE") TO XDATE
*!*								STORE FTIME("&IDMAP:\EXE"+"\&MPROGRA"+".EXE") TO XTIME
*!*	*!*								WAIT WINDOW XDATE
*!*	*!*								WAIT WINDOW XTIME
*!*	*!*								
*!*	*!*								WAIT WINDOW XDATE1
*!*	*!*								WAIT WINDOW XTIME1
*!*								
*!*								IF (XDATE>XDATE1) OR (XDATE=XDATE1 AND XTIME>XTIME1)
*!*									*!*					DECLARE INTEGER ShellExecute IN SHELL32.DLL ;
*!*									*!*						INTEGER lnHWnd, ;
*!*									*!*						STRING lcAction, ;
*!*									*!*						STRING lcFileName, ;
*!*									*!*						STRING lcExeParams, ;
*!*									*!*						STRING lcDefDir, ;
*!*									*!*						INTEGER lnShowWindow
*!*									*!*					LNRESULT = SHELLEXECUTE( 0, "open", "&HOMESISTEMA"+"\EXE"+"\AUTOINSTALL"+"&MPROGRA"+".EXE", "", "", 1 )
*!*									*!*									Store "!/N &HOMESISTEMA"+"\EXE"+"\AUTOINSTALL"+"&MPROGRA"+".EXE" To EXECSIS
*!*									*!*									&EXECSIS
*!*									STORE "&HOMESISTEMA"+"\EXE"+"\AUTOINSTALL"+"&MPROGRA"+".EXE" TO EXECSIS
*!*									CORRERAPLI(EXECSIS,.F.,.F.)
*!*									*!*					!/N C:\CONSIS\EXE\AUTOINSTALLCONSIS2.EXE
*!*									WAIT WINDOW "Iniciando Programa de Actualizacion... Cerrando &MPROGRA" TIMEOUT 3
*!*									QUIT
*!*								ELSE
*!*									&&&&&&&&SI ES REPLICADOR Y NO ACTUALIZA, EJECUTA EL ARCHIVO ORIGINAL DE USO COMPARTIDO, SE PUEDE OBLIGAR AQUI A QUE SE CIERRE Y AUTOMATICAMENTE ABRE EL QUE SE ENCUENTRA EN SU CARPETA DE USUARIO
*!*									WAIT WINDOW "&MPROGRA Est� Actualizado..." NOWAIT
*!*								ENDIF
*!*							ELSE
*!*								=MESSAGEBOX("El Programa De Autoinstalaci�n No Se Localiz� En El Servidor. Puede Seguir Trabajando Pero Por Favor, Notifique Al Encargado Del Sistema."+CHR(13)+""+CHR(13)+"ES NECESARIO ACTUALIZAR &MPROGRA. Puede Seguir Trabajando Pero Recuerde Que Hay Una Actualizaci�n Pendiente De Instalaci�n.",64+0+0,"FAVOR AVISAR.")
*!*							ENDIF
*!*						ELSE
*!*							=MESSAGEBOX("El Programa De Instalaci�n No Est� En Esta Computadora. Puede Seguir Trabajando, Pero La Versi�n Del Programa Podr�a Estar Desactualizada."+CHR(13)+""+CHR(13)+"ES NECESARIO ACTUALIZAR &MPROGRA. Puede Seguir Trabajando Pero Recuerde Que Hay Una Actualizaci�n Pendiente De Instalaci�n.",64+0+0,"FAVOR AVISAR.")
*!*						ENDIF
*!*					ELSE
*!*						&&&&&&&NO SE ACTUALIZA, SOLO SE EJECUTAR� EL PROGRAMA PORQUE YA EST� CORRIENDO
*!*						WAIT WINDOW "CONTINUAR" NOWAIT
*!*					ENDIF
*!*				ELSE
*!*					WAIT WINDOW "No Se Encontr� El Programa Principal En El Servidor, Puede Seguir Trabajando Pero Por Favor, Notifique Al Encargado Del Sistema" NOWAIT
*!*				ENDIF
*!*			ELSE
*!*				WAIT WINDOW "�sta Unidad No Est� Conectada Al Servidor De Archivos" NOWAIT
*!*			ENDIF
*!*		ENDIF
*!*	ENDIF
*!*	*******************************************************************************************************************************************************************************************************************************
*!*	***FINALIZA CODIGO PARA ACTUALIZAR LOS REPLICADORES EN TIEMPO DE EJECUCION***

*!*	TRY
*!*		IF OS()="Windows 6"
*!*			DECLARE INTEGER GdiSetBatchLimit IN WIN32API INTEGER
*!*			GDISETBATCHLIMIT(1)
*!*		ELSE
*!*		ENDIF
*!*	CATCH
*!*	ENDTRY

*!*	TRY &&&&&&&&&&&&&&INSTALANDO FUENTES NECESARIAS...
*!*		STORE "C:\&MPROGRA"+"\FONTS" TO DFONTS
*!*		IF FILE('&IDMAP:\fonts\3OF9.ttf')
*!*			IF DIRECTORY("&DFONTS")
*!*			ELSE
*!*				MD DFONTS
*!*			ENDIF
*!*			&&&&COPIO EL FILE
*!*			COPY FILE &IDMAP:\FONTS\3OF9.TTF TO "DFONTS"+"\3OF9.TTF"
*!*		ENDIF
*!*	CATCH
*!*	ENDTRY

*!*	USERBDC=INISISTEMA("DRIVERCMF","USER",RUTAINI)
*!*	PASSBDC=INISISTEMA("DRIVERCMF","PASSWORD",RUTAINI)
*!*	DSNNOMBREC=INISISTEMA("DRIVERCMF","DSNNOMBRE",RUTAINI)
*!*	DATACMF=INISISTEMA("DRIVERCMF","DATA",RUTAINI)

*!*	IF FILE("C:\&XTMP\USERTEMP.DBF") &&&&SI YA EST� ABIERTA LA EMPRESA, YA CREO DRIVERS DE CMF
*!*	ELSE
*!*		DO DSNLISTADOCMF  &&&&&CREAR EL DRIVER ODBC SI NO EXISTE
*!*	ENDIF

*!*	&&&&&&&&&&&&&&&&&&&&&&&&&&&&&CONEXION A CMF&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
*!*	CONECTDATA(DSNNOMBREC,USERBDC,PASSBDC,"CMFCONN")  &&&&&&CONECTAR A LA BASE DE DATOS
*!*	*!*	SERVNOMBRE
*!*	*!*	DNSDESCRIP

*!*	IF CMFCONN>0
*!*		READY=SQLEXEC(CMFCONN,'USE &DATACMF')
*!*		IF READY>0
*!*		ELSE
*!*			MESSAGEBOX('No Es Posible Conectar Con La Base De Datos CMF, Notificar A Inform�tica',0+64+0,'Conexi�n base de Datos')
*!*			QUIT
*!*		ENDIF
*!*	ELSE
*!*		MESSAGEBOX('No Es Posible Conectar Con El Servidor De Datos De CMF, Notificar A Inform�tica',0+64+0,'Conexi�n base de Datos')
*!*	*!*		QUIT
*!*	ENDIF
*!*	&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&

*!*	ON KEY LABEL ALT+F5 DO TEST
*!*	RELEASE PASSBD,USERBD,PASSUSERUNIMAP,USERUNIMAP,RUTAUNIMAP

*!*	STORE CTOT('04/09/2017 01:01:00 PM') TO FECHALIM
*!*	IF DATETIME()>=FECHALIM
*!*		STORE 'reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Internet Settings" /v ProxyEnable /t REG_DWORD /d 0 /f' TO COMANDOCMD
*!*		CMDRUN5(COMANDOCMD)
*!*	ELSE
*!*	ENDIF

*!*	DO FORM PRINCIPAL

*!*	_SCREEN.SCROLLBARS= 3
*!*	READ EVENTS


*!*	*********************************************************************************************************************************************************************************************************************************
*!*	*********************************************************************************************************************************************************************************************************************************
*!*	******************************************************************************************INICIO DE PROCEDIMIENTOS **************************************************************************************************************
*!*	PROCEDURE PROC_INISISTEMA (RUTAINI) &&&&&VARIABLES DEL ARCHIVO INI *********************************************
*!*		IDMAP=INISISTEMA("SISTEMA","MAPEOUNI",RUTAINI)  &&&&literal o unidad donde se crear� el mapeo
*!*		RUTAUNIMAP=INISISTEMA("SISTEMA","SERVIDOR",RUTAINI)   &&&&&nombre del servidor de archivos del sistema
*!*		USERUNIMAP=INISISTEMA("SISTEMA","USER",RUTAINI)   &&&&&usuario para la conexi�n con el servidor de archivos
*!*		PASSUSERUNIMAP=INISISTEMA("SISTEMA","PASSWORD",RUTAINI)  &&&&&&password para la conexi�n con el servidor de archivos
*!*		USERBD=INISISTEMA("DRIVERDB","USER",RUTAINI)
*!*		PASSBD=INISISTEMA("DRIVERDB","PASSWORD",RUTAINI)
*!*		DSNNOMBRE=INISISTEMA("DRIVERDB","DSNNOMBRE",RUTAINI)
*!*		DATASQL=INISISTEMA("DRIVERDB","DATA",RUTAINI)
*!*	ENDPROC

*!*	*********************************************************************************************************************************************************************************************************************************
*!*	*********************************************************************************************************************************************************************************************************************************

*!*	PROCEDURE PROC_COPYARCHINI &&&COPIAR ARHCIVO DE DE CONFIGURACION SISTEMA.INI*********************************
*!*		IF FILE("&IDMAP:\EXE\"+"&MPROGRA"+".EXE")  &&&&&ESTA MAPEADO Y DEBE VERIFICAR LOS ARCHIVOS
*!*			STORE '&HOMESISTEMA'+'\EXE'+'\&SISTCONFIG' TO XTFILE
*!*			IF FILE("&IDMAP:\EXE\&SISTCONFIG")
*!*				STORE FDATE("&IDMAP:\EXE\&SISTCONFIG") TO AUTODATE
*!*				STORE FTIME("&IDMAP:\EXE\&SISTCONFIG") TO AUTOTIME
*!*				IF FILE('&XTFILE')
*!*					STORE FDATE('&XTFILE') TO AUTODATE1
*!*					STORE FTIME('&XTFILE') TO AUTOTIME1
*!*				ELSE
*!*					STORE {//} TO AUTODATE1
*!*					STORE '00:00' TO AUTOTIME1
*!*				ENDIF
*!*				&&&&SI EL INI LOCAL ES MAS RECIENTE QUE EL DEL SERVIDOR ES PORQUE SE ESCRIBIERON MANUALMENTE LOS DATOS POR ALGUNA RAZON Y SE ACTUALIZAR� HASTA QUE SE MODIFIQUE EN EL SERVIDOR
*!*				IF (AUTODATE>AUTODATE1) OR (AUTODATE=AUTODATE1 AND AUTOTIME>AUTOTIME1)
*!*					ERASE &XTFILE
*!*					STORE "COPY FILE &IDMAP:\EXE\&SISTCONFIG TO &XTFILE" TO VCOPINI
*!*					&VCOPINI
*!*					STORE 0 TO CONTADOR
*!*					DO WHILE !FILE('&XTFILE')&&&&&&&Se queda en espera hasta que termine la copia del archivo y poder leer la nueva configuraci�n
*!*						CONTADOR=CONTADOR+1
*!*						IF CONTADOR>5000
*!*							MESSAGEBOX("Se Ha Agotado El Tiempo De Espera, No Se Encontr� El Archivo De Configuraci�n. Reinicie El Sistema",64+0+0,"INICIO &MPROGRA")
*!*							QUIT
*!*						ENDIF
*!*					ENDDO
*!*					PROC_INISISTEMA('&XTFILE') &&&&&CORROBORAR NUEVAMENTE LOS PARAMETROS DE CONFIGURACION PUES PUDIERON HABER CAMBIADO
*!*					PROC_CHECKREDES()&&&&&MAPEAR A LA NUEVA UNIDAD DE RED
*!*				ELSE
*!*				ENDIF
*!*			ELSE
*!*				MESSAGEBOX("No Se Encontraron Los Par�metros De Configuraci�n En El Servidor. Informe Al Administrador Del Sistema",64+0+0,"SISTEMA DE INICIO &MPROGRA")
*!*				QUIT
*!*			ENDIF
*!*		ELSE
*!*			&&&&&&NO ESTA MAPEADO, PUEDE ESTARSE CORRIENDO EN UNA TERMINAL DE PROGRAMACION
*!*			*!*	RUTAUNIMAP="\\it-srv-db\ips"
*!*			DESCARGARENWEB('http://cmfinfasa.net/AMETSIS/SISTEMA.txt',"&HOMESISTEMA\EXE","&SISTCONFIG")
*!*			IF FILE ('&RUTAINI')
*!*				MESSAGEBOX('El Programa Encontr� Cambios En El Sistema Y Deber� Reiniciarse. Abra Nuevamente La Aplicaci�n, Si El Problema Contin�a Informe Al Departamento De Inform�tica',64+0+0,'&MPROGRA')
*!*				QUIT
*!*			ELSE
*!*				MESSAGEBOX('No Se Encontr� El Archivo De Configuraci�n del Sistema &MPROGRA, Verifique Su Conexi�n De Red e Internet, Intente Nuevamente O Informe Al Departamento De Inform�tica',64+0+0,'&MPROGRA')
*!*				QUIT
*!*			ENDIF
*!*		ENDIF
*!*	ENDPROC

*!*	*********************************************************************************************************************************************************************************************************************************
*!*	*********************************************************************************************************************************************************************************************************************************

*!*	PROCEDURE PROC_COPYARCHIVOS  &&&&&&&&&&&&COPIA ARCHIVOS DE MEN� Y LLAMA EL AUTOINSTALADOR DEL SISTEMA Y OTROS 
*!*		IF ESSERVIDOR=.T.
*!*		ELSE
*!*			IF DIRECTORY("c:\&MPROGRA\Menuprincipal")
*!*			ELSE
*!*				MD "c:\&MPROGRA\Menuprincipal"
*!*			ENDIF
*!*			PROC_COPYAUTOINSTALL()
*!*			TRY
*!*				IF FILE("&IDMAP:\Menuprincipal\"+"&MPROGRA"+".xcb")
*!*					STORE "COPY FILE &IDMAP:\MENUPRINCIPAL\"+"&MPROGRA"+".XCB "+"TO &HOMESISTEMA\MENUPRINCIPAL\"+"&MPROGRA"+".XCB" TO EJ1
*!*					&EJ1
*!*					STORE "COPY FILE &IDMAP:\MENUPRINCIPAL\INICIO"+"&MPROGRA"+".XCB "+"TO &HOMESISTEMA\MENUPRINCIPAL\INICIO"+"&MPROGRA"+".XCB" TO EJ2
*!*					&EJ2
*!*					STORE "COPY FILE &IDMAP:\MENUPRINCIPAL\"+"gps"+".XCB "+"TO &HOMESISTEMA\MENUPRINCIPAL\"+"gps"+".XCB" TO EJ3
*!*					&EJ3
*!*				ENDIF
*!*				
*!*				
*!*				IF "IPS"$UPPER("&MPROGRA")
*!*					PROC_COPYECTADIG()
*!*				ELSE
*!*				ENDIF
*!*			CATCH
*!*			ENDTRY
*!*		ENDIF
*!*	ENDPROC

*!*	*********************************************************************************************************************************************************************************************************************************
*!*	*********************************************************************************************************************************************************************************************************************************

*!*	PROCEDURE PROC_COPYAUTOINSTALL &&&COPIAR AUTOINSTALADOR*******
*!*		IF FILE("&IDMAP:\EXE\AUTOINSTALL"+"&MPROGRA"+".EXE")
*!*			STORE FDATE("&IDMAP:\EXE\AUTOINSTALL"+"&MPROGRA"+".EXE") TO AUTODATE
*!*			STORE FTIME("&IDMAP:\EXE\AUTOINSTALL"+"&MPROGRA"+".EXE") TO AUTOTIME
*!*			IF VARTYPE(RUTAABRIR)='L'
*!*				STORE '&HOMESISTEMA'+'\EXE' TO RUTAABRIR
*!*			ENDIF
*!*			IF FILE("&RUTAABRIR"+"\AUTOINSTALL"+"&MPROGRA"+".EXE")
*!*				STORE FDATE("&RUTAABRIR"+"\AUTOINSTALL"+"&MPROGRA"+".EXE") TO AUTODATE1
*!*				STORE FTIME("&RUTAABRIR"+"\AUTOINSTALL"+"&MPROGRA"+".EXE") TO AUTOTIME1
*!*			ELSE
*!*				STORE {//} TO AUTODATE1
*!*				STORE '00:00' TO AUTOTIME1
*!*			ENDIF
*!*			IF (AUTODATE>AUTODATE1) OR (AUTODATE=AUTODATE1 AND AUTOTIME>AUTOTIME1)
*!*				STORE "COPY FILE &IDMAP:\EXE\AUTOINSTALL"+"&MPROGRA"+".EXE "+" TO &HOMESISTEMA"+"\EXE"+"\AUTOINSTALL"+"&MPROGRA"+".EXE" TO VCOPY
*!*				&VCOPY
*!*			ELSE
*!*				&&&&&&NO HA CAMBIADO EL AUTOINSTALADOR, NO NECESITA COPIA
*!*			ENDIF
*!*		ELSE
*!*			MESSAGEBOX("No Se Encontr� El Autoinstalador De &MPROGRA En El Servidor, Puede Seguir Trabajando Aunque Debe Notificar Al Encargado Del Sistema.",64+0+0,"SISTEMA DE INICIO &MPROGRA")
*!*		ENDIF
*!*	ENDPROC

*!*	*********************************************************************************************************************************************************************************************************************************
*!*	*********************************************************************************************************************************************************************************************************************************

*!*	PROCEDURE PROC_CHECKREDES()  &&&&&&&&&&&&&&&VERIFICA EL ESTADO DE LAS REDES EN USO, MAPEA LA UNIDAD SI ES NECESARIO Y CONECTA. ELIMINA MAPEOS ANTIGUOS Y CONTROLA ACCESOS A REDES POR EL EXPLORADOR DE WINDOWS
*!*		STORE "C:\&MPROGRA"+"TMP\NMAPS.TXT" TO VARIMAP
*!*		IF FILE ('&VARIMAP')
*!*			ERASE &VARIMAP
*!*		ENDIF
*!*		*!*	RUN NET USE >&VARIMAP
*!*		CMDRUN ("NET USE >&VARIMAP")
*!*		IF FILE("&VARIMAP")
*!*			IF USED ('REDESMAP')
*!*				USE IN REDESMAP
*!*			ENDIF
*!*			STORE "C:\&MPROGRA"+"TMP" TO PATHTEMP
*!*			CREATE TABLE &PATHTEMP\REDESMAP.DBF FREE (CAMPO1 V(150))
*!*			SELECT REDESMAP
*!*			APPEND FROM '&VARIMAP' SDF
*!*			SELECT REDESMAP
*!*			GO TOP
*!*			STORE .F. TO CONECTADO
*!*			STORE '' TO XCV2
*!*			STORE ATC('\',ALLTRIM(RUTAUNIMAP),1) TO POSX1
*!*			STORE ATC('\',ALLTRIM(RUTAUNIMAP),3) TO POSX2
*!*			STORE SUBSTR(RUTAUNIMAP,POSX1,POSX2-POSX1+1) TO RUTAUNIMAPTMP
*!*			SCAN
*!*				IF UPPER("&RUTAUNIMAPTMP")$ALLTRIM(UPPER(REDESMAP.CAMPO1)) OR  UPPER("&IDMAP:")$ALLTRIM(UPPER(REDESMAP.CAMPO1))
*!*					IF UPPER(":")$ALLTRIM(UPPER(REDESMAP.CAMPO1))  &&&&&SI EXISTE UNA UNIDAD DE RED EN EL LISTADO, LA VERIFICA
*!*						IF UPPER("&IDMAP:")$ALLTRIM(UPPER(REDESMAP.CAMPO1))  &&&&&&SI ESA UNIDAD DE RED ES LA QUE YO NECESITO Y ESTA DIRIJIDA AL MISMO SERVIDOR VERIFICA EL ESTADO
*!*							IF UPPER("CONECTADO")$ALLTRIM(UPPER(REDESMAP.CAMPO1)) AND UPPER("&RUTAUNIMAPTMP")$ALLTRIM(UPPER(REDESMAP.CAMPO1))
*!*								STORE .T. TO CONECTADO
*!*								EXIT
*!*							ELSE
*!*								*!*						RUN NET USE /DELETE &IDMAP: >NULL
*!*								CMDRUN("NET USE /DELETE &IDMAP: >NULL")
*!*							ENDIF
*!*						ELSE
*!*							STORE ATC(':',ALLTRIM(UPPER(REDESMAP.CAMPO1)),1) TO POS
*!*							STORE SUBSTR(ALLTRIM(UPPER(REDESMAP.CAMPO1)),POS-1,1) TO MAPACTUAL
*!*							*!*					RUN NET USE /DELETE &MAPACTUAL: >NULL  &&&&ESTA MAPEADO PERO NO CON LA UNIDAD DE RED QUE SE NECESITA ACTUALMENTE
*!*							CMDRUN("NET USE /DELETE &MAPACTUAL: >NULL")
*!*						ENDIF
*!*					ELSE
*!*						STORE ATC('\',ALLTRIM(UPPER(REDESMAP.CAMPO1)),1) TO POS
*!*						FOR I=POS TO LEN(ALLTRIM(REDESMAP.CAMPO1))-POS
*!*							STORE SUBSTR(ALLTRIM(REDESMAP.CAMPO1),I,1) TO XCV
*!*							IF XCV=' '
*!*								EXIT
*!*							ELSE
*!*								XCV2=XCV2+XCV
*!*							ENDIF
*!*						ENDFOR
*!*						*!*				RUN NET USE /DELETE &XCV2 >NULL  &&&SI APARECE LA DIRECCION DE RED, SIN UNIDAD DE MAPEO, HAY QUE ELIMINARLA POR NOMBRE DE SERVIDOR
*!*						CMDRUN("NET USE /DELETE &XCV2 >NULL")
*!*					ENDIF
*!*				ENDIF
*!*			ENDSCAN
*!*			IF CONECTADO=.T.
*!*			ELSE
*!*				*!*		RUN NET USE &IDMAP: &RUTAUNIMAP /USER:&USERUNIMAP &PASSUSERUNIMAP&&&&&&MAPEAR LA UNIDAD
*!*				MAPEORED=CMDRUN("NET USE &IDMAP: &RUTAUNIMAP /USER:&USERUNIMAP &PASSUSERUNIMAP")
*!*			ENDIF
*!*			USE IN REDESMAP
*!*			ERASE &PATHTEMP\REDESMAP.DBF
*!*		ELSE
*!*			MESSAGEBOX("No Se Pudieron Detectar Las Unidades De Red Activas")
*!*		ENDIF
*!*	ENDPROC
*!*	*********************************************************************************************************************************************************************************************************************************
*!*	PROCEDURE CMDRUN (CMDCOMANDO)
*!*		LOCAL OWSH
*!*		OWSH = CREATEOBJECT("WScript.Shell")
*!*		STORE "CMD /C "+"&cmdComando" TO CMDINSTRUC
*!*		OWSH.RUN("&cmdinstruc",0,.T.)
*!*	ENDPROC
*!*	*********************************************************************************************************************************************************************************************************************************

*!*	PROCEDURE CORRERAPLI('RUTAEJECUTA','CMD','WAIT')
*!*		IF CMD=.T.
*!*			STORE "CMD /C "+"&RUTAEJECUTA" TO COMMANDOK
*!*		ELSE
*!*			STORE "&RUTAEJECUTA" TO COMMANDOK
*!*		ENDIF
*!*		LOCAL OWSH
*!*		OWSH = CREATEOBJECT("WScript.Shell")
*!*		OWSH.RUN(COMMANDOK,0,WAIT)
*!*	ENDPROC

*!*	PROCEDURE PROC_COPYECTADIG() &&&COPIAR ARHCIVO DE DE CONFIGURACION SISTEMA.INI*********************************
*!*		STORE "&IDMAP:\EXE\"+"ECTADIG"+".EXE" TO XTFILE
*!*		*!*	If File("&RUTCECTADIG")  &&&&&ESTA MAPEADO Y DEBE VERIFICAR LOS ARCHIVOS
*!*		*!*		Store '&HOMESISTEMA'+'\EXE'+'\&SISTCONFIG' To XTFILE
*!*		IF FILE("&XTFILE")
*!*			STORE FDATE("&XTFILE") TO AUTODATE
*!*			STORE FTIME("&XTFILE") TO AUTOTIME
*!*			STORE '&HOMESISTEMA'+'TMP\ECTADIG.EXE' TO XTMPX
*!*			IF FILE('&XTMPX')
*!*				STORE FDATE('&XTMPX') TO AUTODATE1
*!*				STORE FTIME('&XTMPX') TO AUTOTIME1
*!*			ELSE
*!*				STORE {//} TO AUTODATE1
*!*				STORE '00:00' TO AUTOTIME1
*!*			ENDIF
*!*			&&&&SI EL INI LOCAL ES MAS RECIENTE QUE EL DEL SERVIDOR ES PORQUE SE ESCRIBIERON MANUALMENTE LOS DATOS POR ALGUNA RAZON Y SE ACTUALIZAR� HASTA QUE SE MODIFIQUE EN EL SERVIDOR
*!*			IF (AUTODATE>AUTODATE1) OR (AUTODATE=AUTODATE1 AND AUTOTIME>AUTOTIME1)
*!*				ERASE &XTMPX
*!*				STORE "COPY FILE &XTFILE TO &XTMPX" TO VCOPINI
*!*				&VCOPINI
*!*			ELSE
*!*			ENDIF
*!*		ELSE
*!*		ENDIF
*!*		*!*	Else
*!*	ENDPROC

*!*	PROCEDURE CMDRUN5 (CMDCOMANDO)
*!*		LOCAL OWSH
*!*		OWSH = CREATEOBJECT("WScript.Shell")
*!*		STORE "CMD /C "+CMDCOMANDO TO CMDINSTRUC
*!*		OWSH.RUN(CMDINSTRUC,0,0)
*!*	ENDPROC





