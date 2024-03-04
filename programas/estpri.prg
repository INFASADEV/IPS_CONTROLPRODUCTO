&& Enumera impresoras y estado
clear
strComputer = "."
objWMIService = Getobject("winmgmts:"+ "{impersonationLevel=impersonate}!\\" + strComputer + "\root\cimv2")
colInstalledPrinters = objWMIService.ExecQuery("SELECT * FROM Win32_Printer")


For Each objPrinter In colInstalledPrinters
	?"Name: " + objPrinter.Name
	?objPrinter.PrinterStatus
	?objPrinter.Availability
	?objPrinter.PrinterState
	?objPrinter.SpoolEnabled
	?objPrinter.WorkOffline
	?objPrinter.Status
	?objPrinter.StatusInfo
	?objPrinter.PrinterStatus
	?objPrinter.PortName
	?objPrinter.Network
	?objPrinter.Location
	?objPrinter.Local
	?objPrinter.EnableBIDI
	?objPrinter.EnableDevQueryPrint
	?objPrinter.Default
	WAIT WINDOW objPrinter.Name
	clear
Next
