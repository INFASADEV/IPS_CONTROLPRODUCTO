
*-- Declare two API functions
DECLARE INTEGER GetActiveWindow IN Win32API
DECLARE INTEGER GetWindowText IN Win32API ;
 INTEGER, STRING @, INTEGER
*-- Get the handle to the main VFP window
nHandle = GetActiveWindow()
*-- Initialize variables
lcText = SPACE(100)
lnSize = LEN(lcText)
*-- Call the API function
lnSize = GetWindowText(nHandle, @lcText, lnSize)
*-- Use the resulting value
IF lnSize > 0
 ?LEFT(lcText, lnSize)
ENDIF

























**************traer un programa enfrende**************
#DEFINE SW_RESTORE 9
#DEFINE WINNAME [accesos: Bloc de notas]
#DEFINE wclass 0
************
DECLARE INTEGER GetActiveWindow IN Win32API
DECLARE INTEGER GetWindowText IN Win32API ;
***********
DECLARE INTEGER BringWindowToTop IN WIN32API ;
    LONG HWND
DECLARE INTEGER ShowWindow IN WIN32API AS APIShowWin  ;
    LONG HWND, LONG nCmdShow
DECLARE INTEGER FindWindow IN WIN32API AS GetWind STRING,STRING

apphand = GetWind(wclass, WINNAME)
nHandle = GetActiveWindow()
IF apphand <> 0
    = APIShowWin(apphand, SW_RESTORE)
    = BringWindowToTop(apphand)
    = GetActiveWindow() 
ELSE
    RUN /N Notepad.exe
ENDIF

CLEAR DLLS
