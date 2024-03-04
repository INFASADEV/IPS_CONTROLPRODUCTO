PROCEDURE llenardiario(mes)
MESSAGEBOX(mes)
ENDPROC

PROCEDURE filtrardatos(tabla,dato,vector,objeto)
STORE "" TO cadenafil
SELECT &tabla
IF EMPTY(dato)
	SET FILTER TO 
	GO top
	_SCREEN.repcostotiempogeneral.&objeto.Refresh 
ELSE
FOR ln = 1 TO ALEN(vector)
  cadenafil = cadenafil + vector(ln)+ ","
*  ? ln, la(ln)
ENDFOR
WAIT windows cadenafil
ENDIF
endproc

PROCEDURE llamarviewpicking(titulo,cunicox)
DO FORM viewpicking WITH titulo,cunicox
endproc

PROCEDURE crearpdf (rutadest,nombrearch,reportevfp)
&&&&&&&&&&&&&&&&&configuro BULLZIP
*SET STEP ON 
DIMENSION m.MATRICE(1)
m.NUMPRINTERS=APRINTERS(m.MATRICE)
STORE 0 TO OKBULLZIP
FOR m.counter=1 TO m.NUMPRINTERS
	IF "BULLZIP"$UPPER(m.MATRICE(m.counter,1)) AND !"REDIREC"$UPPER(m.MATRICE(m.counter,1))
		STORE 1 TO OKBULLZIP
		EXIT
	ENDIF
ENDFOR
IF OKBULLZIP=0
	MESSAGEBOX("NO EXISTE LA IMPRESORA BULLZIP PDF EN SU SISTEMA, FAVOR INFORMAR A SISTEMAS",64,"IMPRESORA")
	RETURN .F.
ENDIF

m.numprinter=m.counter
m.DEFAULTPRINTER=SET("Printer",2)
STORE m.DEFAULTPRINTER TO QQDEFAULT

IF !"BULLZIP"$UPPER(m.DEFAULTPRINTER)
	SET PRINTER TO NAME m.MATRICE(m.numprinter,1)
ENDIF
*!*		SELECT IESTADOCTA
*!*		STORE '&RUTAPDFS'+UCLIENTESINE+'.JPG' TO MRUTAPDF
*!*	STORE ALLTRIM(STR(NOORDEN)) TO CNORDEN
STORE ALLTRIM(nombrearch)+".PDF" TO NPDF
STORE ALLTRIM(rutadest) TO APATH
STORE APATH + NPDF TO MRUTAPDF

LCOBJ = CREATEOBJECT("BullZIP.PDFPrinterSettings")
WITH LCOBJ
	.SETVALUE("Output",MRUTAPDF)
	.SETVALUE("ShowSettings" ,"never")
	.SETVALUE("ShowPDF" ,"no")
	.SETVALUE("ShowProgressFinished" ,"no")
	.SETVALUE("ShowProgress" ,"no")
	.SETVALUE("Linearize" ,"no")
	.WRITESETTINGS(.T.)
ENDWITH

IF !"BULLZIP"$UPPER(m.DEFAULTPRINTER)
	STORE "Bullzip PDF Printer" TO m.DEFAULTPRINTER
	SET PRINTER TO NAME (m.DEFAULTPRINTER)
	IF ESREPLICA=.T.
		TRY
			oShell = CREATEOBJECT("WScript.Shell")
			oShell.RUN('rundll32 PRINTUI.dll,PrintUIEntry /y /n "Bullzip PDF Printer"',0,.T.)
		CATCH
		ENDTRY
	ENDIF
ENDIF

IF FILE('&MRUTAPDF')
	DELETE FILE '&MRUTAPDF'
ENDIF

SET ECHO OFF
SET TALK OFF
SET CONSOLE OFF
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
REPORT FORM &reportevfp TO PRINTER NOCONSOLE
IF ESREPLICA=.T. AND !"BULLZIP"$UPPER(QQDEFAULT)
	FOR m.counter=1 TO m.NUMPRINTERS
		IF UPPER("&QQDEFAULT")$UPPER(m.MATRICE(m.counter,1))
			TRY
				oShell = CREATEOBJECT("WScript.Shell")
				oShell.RUN('rundll32 PRINTUI.dll,PrintUIEntry /y /n "&QQDEFAULT"',0,.T.)
			CATCH
			ENDTRY
			EXIT
		ENDIF
	ENDFOR
ENDIF


*!*	IF DIRECTORY('&APATH')
*!*		THISFORM.OLEcontrol1.NAvigate2('&APATH')
*!*		THISFORM.OLEcontrol1.VISIBLE= .T.
*!*	ELSE
*!*		THISFORM.OLEcontrol1.NAvigate2('')
*!*		THISFORM.OLEcontrol1.VISIBLE= .F.
*!*	ENDIF
ENDPROC
PROCEDURE crearpdf2 (rutadest,nombrearch,reportevfp)
	SET STEP ON 
	DIMENSION m.MATRICE(1)
	m.NUMPRINTERS=APRINTERS(m.MATRICE)
	FOR m.COUNTER=1 TO m.NUMPRINTERS
		IF ATC("BULLZIP",m.MATRICE(m.COUNTER,1))>0
			EXIT
		ENDIF
	ENDFOR
	m.NUMPRINTER=m.COUNTER
	m.DEFAULTPRINTER=SET("Printer",2)
	IF ATC("BULLZIP",m.DEFAULTPRINTER)=0
		SET PRINTER TO NAME m.MATRICE(m.NUMPRINTER,1)
	ENDIF
	*SELECT FACTURAS
	STORE ALLTRIM(nombrearch)+".PDF" TO NPDF
	STORE ALLTRIM(rutadest) TO APATH
	STORE APATH + NPDF TO MRUTAPDF
	
*	STORE '&RUTAPDFS'+FACTURAS.FACTURA+'.PDF' TO MRUTAPDF
	LCOBJ = CREATEOBJECT("BullZIP.PDFPrinterSettings")
	WITH LCOBJ
		.SETVALUE("Output",MRUTAPDF)
		.SETVALUE("ShowSettings" ,"never")
		.SETVALUE("ShowPDF" ,"no")
		.SETVALUE("ShowProgressFinished" ,"no")
		.SETVALUE("ShowProgress" ,"no")
		.SETVALUE("Linearize" ,"yes")
		.WRITESETTINGS(.T.)
	ENDWITH
	IF ATC("BULLZIP",m.DEFAULTPRINTER)=0
		STORE 'Bullzip PDF Printer' TO m.DEFAULTPRINTER
		SET PRINTER TO NAME (m.DEFAULTPRINTER)
	ENDIF
*!*		SET ECHO OFF
*!*		SET TALK OFF
*!*		SET CONSOLE OFF
	&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
*	SELECT FACTUREPO
*	REPORT FORM facturalasertextopickegresos TO PRINTER NOCONSOLE
	LABEL FORM &reportevfp TO PRINTER NOCONSOLE 
	*REPORT FORM FACTURALASERTEXTOr TO PRINTER NOCONSOLE
	WAIT WINDOW 'Exportacion de Factura '+facturas.factura+' en '+mrutapdf TIMEOUT 1
ENDPROC

PROCEDURE estabPredPrinter(nombreimpr)
	STORE ALLTRIM(nombreimpr) TO respx
	IF .not. EMPTY(respx)
		ws = Createobject("WScript.Network")
		ws.SetDefaultPrinter(Alltrim(respx))
		RELEASE ws && lo libero de memoria.
		SET PRINTER TO NAME ((SET("PRINTER",2)))
	ENDIF
ENDPRO

PROCEDURE impresoraDeterminada()
	STORE "" TO predex
	For lnI = 1 To Aprinters(aPrintArray)
		aPrintArray[lnI,1] = Space(1) + aPrintArray[lnI,1]
	Endfor
	For i = 1 To Alen(aPrintArray)
		lnPos = i
		If Upper(Set('PRINTER',2))$Upper(aPrintArray[i])
			predex = Upper(Set('PRINTER',2))
			Exit
		Endif
	ENDFOR
	RETURN predex
ENDPROC

PROCEDURE verEstadoImpresora(nomimp)
	STORE ALLTRIM(nomimp) TO NOMBREIMPRESORA
	STORE .T. TO PRINTERON
	strComputer = "."
	objWMIService = Getobject("winmgmts:"+ "{impersonationLevel=impersonate}!\\" + strComputer + "\root\cimv2")
	colInstalledPrinters = objWMIService.ExecQuery("SELECT * FROM Win32_Printer")
	For Each objPrinter In colInstalledPrinters
		IF ALLTRIM(objPrinter.Name) ==  ALLTRIM(NOMBREIMPRESORA)
*!*				?"Name: " + objPrinter.Name
*!*				?objPrinter.PrinterStatus
*!*				?objPrinter.Availability
*!*				?objPrinter.PrinterState
*!*				?objPrinter.SpoolEnabled
*!*				?objPrinter.WorkOffline
*!*				?objPrinter.Status
*!*				?objPrinter.StatusInfo
*!*				?objPrinter.PrinterStatus
*!*				?objPrinter.PortName
*!*				?objPrinter.Network
*!*				?objPrinter.Location
*!*				?objPrinter.Local
*!*				?objPrinter.EnableBIDI
*!*				?objPrinter.EnableDevQueryPrint
*!*				?objPrinter.Default
		PRINTERON = objPrinter.WorkOffline
		ENDIF
	NEXT
	RETURN PRINTERON
ENDPROC

PROCEDURE ping(iHost)
	Declare Integer GetRTTAndHopCount In Iphlpapi;
		Integer DestIpAddress, Long @HopCount,;
		Integer MaxHops, Long @RTT
	Declare Integer inet_addr In ws2_32 String cp
	Local nDst, nHop, nRTT
	nDst = inet_addr(iHost)
	Store 0 To nHop, nRTT
	If GetRTTAndHopCount(nDst, @nHop, 1, @nRTT) <> 0
		Return 1
	Else
		Return 2
	Endif
ENDPROC 

PROCEDURE BatteryStat
	DECLARE INTEGER GetSystemPowerStatus IN kernel32;
	STRING @lpSystemPowerStatus
	PUBLIC vPorcenBat,vAcLine
	*!*	En FoxPro
	*|typedef struct _SYSTEM_POWER_STATUS {
	*|  BYTE ACLineStatus;         1:1
	*|  BYTE BatteryFlag;          2:1
	*|  BYTE BatteryLifePercent;   3:1
	*|  BYTE Reserved1;            4:1
	*|  DWORD BatteryLifeTime;     5:4
	*|  DWORD BatteryFullLifeTime; 9:4
	*|} SYSTEM_POWER_STATUS, *LPSYSTEM_POWER_STATUS; total 12 bytes

	LOCAL cBuffer
	cBuffer = REPLI(CHR(0), 12)
	IF GetSystemPowerStatus(@cBuffer) = 0
		RETURN
	ENDIF
	LOCAL nStatus
	vAcLine = ASC(SUBSTR(cBuffer,1,1))
	vPorcenBat = ASC(SUBSTR(cBuffer,3,1))
ENDPROC

PROCEDURE imprimirArchivoExt(archivo,promptact,impreactx)
*STORE 0 TO resultesp
	IF FILE(archivo)
	ELSE
		MESSAGEBOX("Archivo No Encontrado",0+64,"Archivo No Existe")
		RETURN 0
	endif
	IF promptact = 1
		respx= ALLTRIM(impreactx)
		IF .not. EMPTY(respx)
			ws = Createobject("WScript.Network")
			ws.SetDefaultPrinter(Alltrim(respx))
			RELEASE ws && lo libero de memoria.
			SET PRINTER TO NAME ((SET("PRINTER",2)))
		ELSE
			RETURN 0		
		endif
	ENDIF
		loShell = CREATEOBJECT("Shell.Application")
		loShell.ShellExecute(ALLTRIM(archivo), SET('PRINTER',1), '', 'printto', 0 )
ENDPROC

PROCEDURE estpreprinterx(impnomx)
	respx= ALLTRIM(impnomx)
	IF .not. EMPTY(respx)
		ws = Createobject("WScript.Network")
		ws.SetDefaultPrinter(Alltrim(respx))
		RELEASE ws && lo libero de memoria.
		SET PRINTER TO NAME ((SET("PRINTER",2)))
	ELSE
		RETURN 0		
	ENDIF
ENDPROC

PROCEDURE esperarTiempo(timex,menwait)
	LOCAL ltMessageTimeOut
	m.ltMessageTimeOut = DATETIME() + timex
	DO WHILE DATETIME() < m.ltMessageTimeOut
	    WAIT WINDOW menwait NOCLEAR TIMEOUT 1
	ENDDO
	WAIT clear
ENDPROC
***********************************ENVIAR CORREO CON CSS***********************************************
PROCEDURE sendEmailwithCSS(GCORREO,GCLAVE,CORREODESTINO,GTITULO,GCONTENIDO,GTEXTBODY,GARCHIVO,XCCO,CSSX)
	IF VARTYPE(XCCO)="L" then
		XCCO=""
	ENDIF 

	TEXT TO xtext
	<body style="height: 500px; width: 1000px">
	    <table cellpadding="0" cellspacing="0" class="style1">
	        <tr>
	            <td bgcolor="White" class="style8" rowspan="4">
	                <img alt="" src="http://www.cmfinfasa.net/images/infasal.jpg" /></td>
	            <td bgcolor="White" class="style9"
	                style="font-family: Arial; font-size: 11px; font-weight: bold;">
	                Industria Farmaceutica, S.A.</td>
	            <td bgcolor="White" class="style8" rowspan="4">
	                <img alt="" src="http://www.cmfinfasa.net/images/codigobarrasinfasa.png"
	                    style="margin-left: 42px" /></td>
	        </tr>
	        <tr>
	            <td bgcolor="White" class="style9" style="font-family: Arial; font-size: 11px;">
	                Km. 15.5 Calzada Roosevelt 0-80 zona 2 Mixco</td>
	        </tr>
	        <tr>
	            <td bgcolor="White" class="style9" style="font-family: Arial; font-size: 11px;">
	                PBX: 2411-5454</td>
	        </tr>
	        <tr>
	            <td bgcolor="White" class="style9" style="font-family: Arial; font-size: 11px;">
	                Sistema IPS</td>
	        </tr>
	        <tr>
	            <td bgcolor="SteelBlue" class="style7" colspan="3"
	                style="font-family: Arial; font-size: 12px; vertical-align: text-top; text-align: justify; color: #FFFFFF;">
	            
	ENDTEXT
	STORE ALLTRIM(GTEXTBODY)+"</td>" TO XTEXTPER
*	STORE "" TO XTEXTPER

	IF 'IPS@'$UPPER(GCORREO)
		TEXT TO xtext2
	        </tr>
	        <tr>
	            <td bgcolor="SteelBlue" colspan="3">
	                &nbsp;</td>
	        </tr>
	        <tr>
	            <td bgcolor="SteelBlue" colspan="3">
	                &nbsp;</td>
	        </tr>
	        <tr>
	            <td bgcolor="SteelBlue" colspan="3">
	                &nbsp;</td>
	        </tr>
	        <tr>
	            <td bgcolor="SteelBlue" colspan="3">
	                &nbsp;</td>
	        </tr>
	        <tr>
	            <td bgcolor="SteelBlue" colspan="3">
	                &nbsp;</td>
	        </tr>
	        <tr>
	            <td bgcolor="SteelBlue" colspan="3">
	                &nbsp;</td>
	        </tr>
	        <tr>
	            <td bgcolor="SteelBlue" colspan="3">
	                &nbsp;</td>
	        </tr>
	        <tr>
	            <td bgcolor="SteelBlue" colspan="3">
	                &nbsp;</td>
	        </tr>
	        <tr>
	            <td bgcolor="SteelBlue" colspan="3">
	                &nbsp;</td>
	        </tr>
	        <tr>
	            <td bgcolor="SteelBlue" colspan="3">
	                &nbsp;</td>
	        </tr>
	        <tr>
	            <td bgcolor="White" colspan="3"
	                style="font-family: Arial; font-size: 11px; font-weight: bold;">
	                -------------------------------ESTE ES UN MENSAJE AUTOMATICO FAVOR NO
	                CONTESTAR-------------------------------</td>
	        </tr>
	    </table>
	</body>
		ENDTEXT
	ELSE
		TEXT TO xtext2
	        </tr>
	        <tr>
	            <td bgcolor="SteelBlue" colspan="3">
	                &nbsp;</td>
	        </tr>
	        <tr>
	            <td bgcolor="SteelBlue" colspan="3">
	                &nbsp;</td>
	        </tr>
	        <tr>
	            <td bgcolor="SteelBlue" colspan="3">
	                &nbsp;</td>
	        </tr>
	        <tr>
	            <td bgcolor="SteelBlue" colspan="3">
	                &nbsp;</td>
	        </tr>
	        <tr>
	            <td bgcolor="SteelBlue" colspan="3">
	                &nbsp;</td>
	        </tr>
	        <tr>
	            <td bgcolor="SteelBlue" colspan="3">
	                &nbsp;</td>
	        </tr>
	        <tr>
	            <td bgcolor="SteelBlue" colspan="3">
	                &nbsp;</td>
	        </tr>
	        <tr>
	            <td bgcolor="SteelBlue" colspan="3">
	                &nbsp;</td>
	        </tr>
	        <tr>
	            <td bgcolor="SteelBlue" colspan="3">
	                &nbsp;</td>
	        </tr>
	        <tr>
	            <td bgcolor="SteelBlue" colspan="3">
	                &nbsp;</td>
	        </tr>
	    </table>
	</body>
		ENDTEXT
	ENDIF
	CLEAR
	LOMAIL = NEWOBJECT("Cdo2000", "Cdo2000.fxp")
	WITH LOMAIL
		.CSERVER = "smtp.gmail.com"
		.NSERVERPORT = 25 &&465 &&25 
		.LUSESSL = .T.
		.NAUTHENTICATE = 1
		.CUSERNAME = GCORREO
		.CPASSWORD = GCLAVE
		.CFROM = GCORREO
		.CTO = GDESTINATARIO
		.CSUBJECT = GTITULO
		.CHTMLBODY = XTEXT+XTEXTPER+XTEXT2
		.CTEXTBODY = GTEXTBODY
		.cBCC =XCCO
		IF !EMPTY(GARCHIVO)
			.CATTACHMENT = GARCHIVO
		ENDIF
	ENDWITH
	IF LOMAIL.SEND() > 0
		LOCAL IERRORES
		STORE '' TO IERRORES
		FOR I=1 TO LOMAIL.GETERRORCOUNT()
			IERRORES=IERRORES+ LOMAIL.GETERROR(I)
		ENDFOR
		IF 'NOT AVAILABLE'$UPPER(IERRORES)
			MESSAGEBOX('No se pudo enviar el Correo, Usuario o Contraseña Incorrecta.',0+16+0,'Error')
		ELSE
			MESSAGEBOX('No se pudo enviar el Correo.  '+CHR(13)+CHR(13)+IERRORES,0+16+0,'Error')
		ENDIF
		LOMAIL.CLEARERRORS()
		RETURN .F.
	ELSE
		LOMAIL.CLEARERRORS()
		*MESSAGEBOX('El correo fue enviado de forma correcta.',0+64+0,'Envio de Correo')
		RETURN .T.
	ENDIF
ENDPROC
