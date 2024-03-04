PARAMETERS archivo
*!*	Declare Integer ShellExecute In shell32.Dll;
*!*	    long HWnd,String cOperation,;
*!*	    string cFile, String t cParam,;
*!*	    string cDir, Integer nShow
*!*	cRutaPDF = archivo

*!*	ShellExecute(0, "print", cRutaPDF,"", Fullpath(""),0)
loShell = CREATEOBJECT("Shell.Application")
loShell.ShellExecute(ALLTRIM(archivo), set('PRINTER',2), '', 'printto', 0 )
