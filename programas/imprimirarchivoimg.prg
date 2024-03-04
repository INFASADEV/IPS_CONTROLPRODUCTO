PARAMETERS archivo
*!*	STORE "C:\IPSTMP\Elmerrivera0001\ADJUNTOSDOCSPICK\0001.png" TO archivo
*!*	DECLARE INTEGER ShellExecute IN "Shell32.dll" ;
*!*	    long HWnd,String cOperation,;
*!*	    string cFile, String t cParam,;
*!*	    string cDir, Integer nShow
*!*	cRutaPDF = archivo

*!*	=ShellExecute(0, "print", cRutaPDF ,"", Fullpath(""),0)


loShell = CREATEOBJECT("Shell.Application")
loShell.ShellExecute(ALLTRIM(archivo), set('PRINTER',2), '', 'printto', 0 )

*!*	STORE "C:\IPSTMP\Elmerrivera0001\ADJUNTOSDOCSPICK\0001.png" TO archivo
*!*	DECLARE INTEGER ShellExecute IN "Shell32.dll" ;
*!*	INTEGER hwnd, ;
*!*	STRING lpVerb, ;
*!*	STRING lpFile, ;
*!*	STRING lpParameters, ;
*!*	STRING lpDirectory, ;
*!*	LONG nShowCmd

*!*	=Shellexecute(0,set('PRINTER',2),archivo,'printto',"",0)


*!*	STORE "C:\IPSTMP\Elmerrivera0001\ADJUNTOSDOCSPICK\0001.png" TO archivo
*!*	DECLARE INTEGER ShellExecute IN "Shell32.dll" ;
*!*	    long HWnd,String cOperation,;
*!*	    string cFile, String tcParam,;
*!*	    string cDir, Integer nShow

*!*	=ShellExecute(0, set('PRINTER',2), archivo ,"printto", Fullpath(""),0)