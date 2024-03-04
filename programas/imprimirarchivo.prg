PARAMETERS archivo,namobj
*LOCAL cadimpx
*cadimpx = ALLTRIM(namobj)+".ShellExecute(ALLTRIM(archivo), SET('PRINTER',1), '', 'printto', 0 )"
&namobj= CREATEOBJECT("Shell.Application")
&namobj..ShellExecute(ALLTRIM(archivo), SET('PRINTER',1), '', 'printto', 0 )
