

Public XNC, colorgrid1,colorgrid2,mascara_numero,colorgrid3,color_separador, color_totales,color_delete,color_cambio_pendiente,xcolor_obligatorio,color_amarillo,color_blanco
xcolor_obligatorio= RGB(255,248,202)
colorgrid1=Rgb(255,255,255)
*colorgrid2=Rgb(97,183,249)
colorgrid2=Rgb(171,201,224)
colorgrid3=Rgb(255,255,205)
color_separador=Rgb(0,145,255)
color_totales=Rgb(171,171,171)
color_delete= Rgb(105,105,105)
color_cambio_pendiente= Rgb(253,145,145)
color_blanco= RGB(255,255,255)
color_amarillo=RGB(255,246,181)
mascara_numero= "999,999,999.99"
*DO c:\ips\programas\paths.prg


DEFINE CLASS txt_modifproc as TextBox
	PROCEDURE dblclick 
		DO FORM CONTROLPIN WITH ALLTRIM(T_procesos_det.lote),ALLTRIM(T_procesos_det.proceso),T_procesos_det.ID

ENDDEFINE 

DEFINE CLASS detalle_formula AS CUSTOM
   codigo=''
   unidades=0.00
   nombre=''
   codigop=''
   flag = ''
ENDDEFINE


DEFINE CLASS txt_consulta_hora as TextBox
	PROCEDURE dblclick 
		DO FORM reporteria_produccion_detalle WITH ALLTRIM(T_procesos.lote), T_procesos.codigopersonal
ENDDEFINE 
DEFINE CLASS txt_consulta_hor as TextBox
	PROCEDURE dblclick 
		DO FORM reporteria_produccion_detalle WITH ALLTRIM(T_procesos.lote), T_procesos.codigopersonal
ENDDEFINE 
Define Class cmd_busqmat As CommandButton
	Caption="Buscar"
	Picture="filefind.gif"
	PicturePosition=14
	Height=24
	ToolTipText="Buscar Material."
	Procedure Click
		*- buscar material de producto
		DO FORM buscamatpri
		SELECT t_mermas_detalle
		replace codigo WITH xcodprod
		replace nombre WITH PSELECIONADO
		thisform.grid1.column4.text1.setfocus 
ENDDEFINE

DEFINE CLASS txt_busq_mat as TextBox
	PROCEDURE valid
		IF NOT(EMPTY(ALLTRIM(THIS.Value))) THEN
			TEXT TO lcsql TEXTMERGE NOSHOW 
				-- busqueda de materia prima por código
				select CODIGO,NOMBRE  
				from Materiaprima 
				where codigo = '<<ALLTRIM(THIS.VALUE)>>' AND EMPRESA ='<<EMPRESAACTIVACOD>>' 
			ENDTEXT 
			IF XTABLA(LCSQL,"TMATPRIMAR")>0 THEN
				SELECT t_mermas_detalle
				SELECT TMATPRIMAR
				PRIVATE xtot
				xtot= RECCOUNT()
				IF xtot= 0 THEN 
					this.Value= ""
					MESSAGEBOX("Código de Material no existe.",0+64+4096,"Requerimientos/Mermas")
				ELSE
					SELECT t_mermas_detalle
					replace codigo WITH ALLTRIM(TMATPRIMAR.CODIGO)
					replace nombre WITH ALLTRIM(TMATPRIMAR.NOMBRE)
				ENDIF 
			ENDIF 
		ENDIF 
	PROCEDURE LOSTFOCUS 
		IF EMPTY(this.Value) then
			this.setfocus 
			RETURN .f.
			
		ELSE 
			thisform.grid1.column4.text1.setfocus 
		ENDIF 		
ENDDEFINE 

*- clase para formulario costeo_lotes_prodccion/ DETALLE ESTATUS/EMPAQUE
DEFINE CLASS txt_cambios as TextBox
	valor_orig =null
	cambio=0
	PROCEDURE ProgrammaticChange
		valor_orig= this.Value
	PROCEDURE interactivechange
		if t_mermas_detalle.marcar= 1 then
			*- nuevo registro
		ELSE
			this.cambio= 1
			SELECT t_mermas_detalle
			replace marcar WITH 2
		ENDIF 
ENDDEFINE 

Define Class cmd_gmermadet As CommandButton
	Caption="Guardar"
	Picture="database_save.png"
	PicturePosition=14
	Height=24
	ToolTipText="Guardar cambios"
	Procedure Click
		TEXT TO lcsql TEXTMERGE NOSHOW 
			-- query de insertar/actualizar
			INSERT 
			INTO   t_mermas_detalle(codigo, Cantidad,codigo_mer)
			VALUES ('<<t_mermas_detalle.codigo>>',<<t_mermas_detalle.cantidad>>,'<<t_mermas_detalle.codigo_mer>>')
		ENDTEXT 
		IF xejecutar(lcsql,lcsql)>0 THEN 
			SELECT t_mermas_detalle
			replace marcar WITH 0
			thisform.grid1.refresh
			MESSAGEBOX("Registro guardado",0+64+4096,"Requerimientos/Mermas")
		ENDIF 
ENDDEFINE

Define Class cmd_costo_lote As CommandButton
	Caption="Generar"
	Picture="c:\ips\bitmaps\Wallet.ico"
	PicturePosition=14
	Height=24
	ToolTipText="Generar Costos de lote"
	Procedure Click
		xxxperiodo= ALLTRIM(thisform.fecha1.value)
		xxxlote= ALLTRIM(TLotesResumen.lote)
		xxxfechai=TLotesResumen.fechai
		xxcodigop=TLotesResumen.codigo
		*DO FORM costeo_lotes_prodccion  WITH xxxlote, xxxperiodo ,.t.,xxxfechai,xxcodigop
		DO FORM costeo_lotes_prodccion_release WITH xxxlote,xxxperiodo
ENDDEFINE




Define Class obj_cmd_checks As CommandButton
	Caption="Finalizado"
	Picture="c:\ips\bitmaps\check20s.png"
	PicturePosition=14
	Height=24
	ToolTipText="Proceso Finalizado"
	visible=.t.
	specialeffect=1
ENDDEFINE 

Define Class obj_cmd_checkn As CommandButton
	Caption="Finalizado"
	Picture="c:\ips\bitmaps\check20t.png"
	PicturePosition=14
	Height=24
	ToolTipText="Proceso Finalizado"
	visible=.t.
	specialeffect=1
ENDDEFINE 

*------------------------ objetos   personalizados
DEFINE CLASS txt_costo_lote_movimiento as TextBox
	PROCEDURE dblclick 
		PRIVATE XCODPROD 
		SELECT TRESUMEN
		STORE ALLTRIM(CODIGO) TO XCODPROD
		*- egreso po
		*SELECT T_EGRESOPO
		*- requerimiento
		*SELECT T_REQUERIMIENTO
		*- devoluciones
		*SELECT T_devoluciones
		SELECT * FROM T_EGRESOPO WHERE CODIGO = XCODPROD;
		UNION;
		SELECT * FROM T_REQUERIMIENTO WHERE CODIGO = XCODPROD;
		UNION;
		SELECT * FROM T_devoluciones WHERE CODIGO = XCODPROD ORDER BY Producto INTO CURSOR T_DETALLECST
		SELECT T_DETALLECST
		DO FORM costeo_lotes_produccion_detalle
		
		*BROWSE 
	ENDPROC 
ENDDEFINE 

*- clase para formulario costeo_lotes_prodccion/ DETALLE ESTATUS/EMPAQUE
DEFINE CLASS txt_costo_loteme as TextBox
	PROCEDURE dblclick 
		this.abrir 
	PROCEDURE click 
		this.abrir 
	PROCEDURE gotfocus 
		*this.abrir 
	PROCEDURE abrir
		PRIVATE xcodempaque 
		xcodempaque= ""
		xcodempaque= ALLTRIM(t_status_det.nuforemp)
		SELECT tresumenME
		SET FILTER TO tresumenME.nuforemp = t_status_det.nuforemp 
		SELECT tresumenME
		GO TOP 
		SELECT t_status_det
		*GO TOP 
		
		thisform.menu.status_empaque.grd_detalle.refresh 
		thisform.menu.status_empaque.grid1.Refresh
		*thisform.refresh 
ENDDEFINE 

*- clase para formulario costeo_lotes_prodccion/ DETALLE ESTATUS/EMPAQUE
DEFINE CLASS txt_costo_loteme as TextBox
	PROCEDURE dblclick 
		this.abrir 
	PROCEDURE click 
		this.abrir 
	PROCEDURE gotfocus 
		*this.abrir 
	PROCEDURE abrir
		PRIVATE xcodempaque 
		xcodempaque= ""
		xcodempaque= ALLTRIM(t_status_det.nuforemp)
		SELECT tresumenME
		SET FILTER TO tresumenME.nuforemp = t_status_det.nuforemp 
		SELECT tresumenME
		GO TOP 
		SELECT t_status_det
		*GO TOP 
		
		thisform.menu.status_empaque.grd_detalle.refresh 
		thisform.menu.status_empaque.grid1.Refresh
		*thisform.refresh 
ENDDEFINE 


DEFINE CLASS txt_costo_lote as TextBox
	PROCEDURE dblclick 
		this.abrir 
	PROCEDURE click 
		this.abrir 
	PROCEDURE gotfocus 
		*this.abrir 
	PROCEDURE abrir
		PRIVATE xcodempaque 
		xcodempaque= ""
		xcodempaque= ALLTRIM(t_status_det.nuforemp )
		SELECT tresumen
		GO TOP 
		SELECT t_status_det
		*GO TOP 
		
		SET FILTER TO tresumen.nuforemp = t_status_det.nuforemp 
		*thisform.menu.status_empaque.grd_detalle.refresh 
		thisform.menu.resumen.grid1.Refresh
		*thisform.refresh 
ENDDEFINE 

*---- monitor de procesos
DEFINE CLASS txt_pro_nombrel as TextBox
	PROCEDURE dblclick 
		thisform.txt_nombre.value= T_procesosl.nombrepersonal	
		thisform.txtlote.value= ""
		thisform.txtproducto.value= ""
		thisform.filtros
ENDDEFINE 
DEFINE CLASS txt_pro_productol as TextBox
	PROCEDURE dblclick 
		thisform.txt_nombre.value=""
		thisform.txtlote.value= ""
		thisform.txtproducto.value=  T_procesosl.producto	
		thisform.filtros
ENDDEFINE 

DEFINE CLASS txt_pro_lotel as TextBox
	PROCEDURE dblclick 
		thisform.txt_nombre.value= ""
		thisform.txtlote.value= T_procesosl.lote
		thisform.txtproducto.value= ""
		thisform.filtros
ENDDEFINE 

*-------------------------------------------------

DEFINE CLASS txt_pro_nombre as TextBox
	PROCEDURE dblclick 
		thisform.txt_nombre.value= T_procesos.nombrepersonal	
		thisform.txtlote.value= ""
		thisform.txtproducto.value= ""
		thisform.filtros
ENDDEFINE 

DEFINE CLASS txt_pro_producto as TextBox
	PROCEDURE dblclick 
		thisform.txt_nombre.value=""
		thisform.txtlote.value= ""
		thisform.txtproducto.value=  T_procesos.producto	
		thisform.filtros
ENDDEFINE 

DEFINE CLASS txt_pro_lote as TextBox
	PROCEDURE dblclick 
		thisform.txt_nombre.value= ""
		thisform.txtlote.value= T_procesos.lote
		thisform.txtproducto.value= ""
		thisform.filtros
ENDDEFINE 



DEFINE CLASS obj_prog2 as Container 
	visible= .t.
	width= 100
	height= 20
	ADD OBJECT shp as progreso
	PROCEDURE init 
		this.width= this.parent.width
	PROCEDURE porcentaje(xvalor)
		this.shp.llenado(xvalor)
	ENDPROC 	
ENDDEFINE 

DEFINE CLASS progreso as Shape
	width= 0
	height= 0
	backcolor= RGB(0,150,250)
	PROCEDURE init
		this.Height= this.Parent.width 
	ENDPROC 
	PROCEDURE llenado(xvalor)
		IF VARTYPE(xvalor) = "N" then
			IF xvalor> 0 
				this.Width= (xvalor*this.Parent.width)/100
			ELSE
				*this.Width= (xvalor*this.Parent.width)/100
			ENDIF
		ENDIF  
	ENDPROC 
ENDDEFINE 

DEFINE CLASS obj_prog as progressbar OF progressbarex.vcx
	
ENDDEFINE 
 
 *DEFINE CLASS equipox as equipo OF c:\ips\librerias\samples.vcx
 

 *ENDDEFINE 

DEFINE CLASS obj_chk_generico as CheckBox
 	caption= ""
 	marca =""
 	tabla=""
 	alignment= 2
 	PROCEDURE click
 		*IF NOT EMPTY(this.indice) then
 			PRIVATE xvalor
 			xvalor= this.Value 
	 		TEXT TO xintrucciones TEXTMERGE NOSHOW 
	 			SELECT <<this.tabla>>
	 			replace <<this.tabla>>.<<this.marca>> with <<xvalor>>
	 		ENDTEXT 
	 		EXECSCRIPT(xintrucciones)	
 			thisform.refresh
 		*ENDIF 

 ENDDEFINE 





 DEFINE CLASS obj_encabezado as Header
 	caption= ""
 	indice =""
 	tabla=""
 	orden ="ascending"
 	alignment= 2
 	picture ="c:\ips\bitmaps\arrow_sort.png"
 	PROCEDURE click
 		IF NOT EMPTY(this.indice) then
	 		TEXT TO ordenamiento TEXTMERGE NOSHOW 
	 			IF VARTYPE(<<this.tabla>>.<<this.indice>>) = "C" then
	 				INDEX ON LEFT(<<this.tabla>>.<<this.indice>>,50) TO <<this.indice>>
	 			ELSE
					INDEX ON <<this.tabla>>.<<this.indice>> Tag <<this.indice>>
				ENDIF 
 				SET ORDER TO <<this.indice>> <<this.orden>>	
 				SELECT <<this.tabla>>
 				GO TOP 
	 		ENDTEXT 
	 		EXECSCRIPT(ordenamiento)	
	 		*picture ="c:\ips\bitmaps\1uparrow.gif"
	 		IF this.orden= "ascending" then
 				this.orden= "descending"
 				this.picture ="c:\ips\bitmaps\1downarrow.gif"
 			ELSE
 				this.orden= "ascending"

 				this.picture ="c:\ips\bitmaps\1uparrow.gif"
 			ENDIF 
 			
 			thisform.refresh
 		ENDIF 

 ENDDEFINE 
 
DEFINE CLASS obj_txt_tiempo as TextBox
	PROCEDURE programmaticchange
		PRIVATE xtiempo,xhoras,xmin,xseg
		STORE 0 TO xtiempo,xhoras,xmin,xseg
		xtiempo= this.Value
		xhoras= INT(xtiempo/60)
		xmin= (xtiempo/60)- INT(xtiempo/60)
		this.Value=  STR(xhoras)+ ":"+STR(xmin)
ENDDEFINE 


DEFINE CLASS obj_txt_enter as TextBox
	PROCEDURE keypress
		LPARAMETERS nKeyCode, nShiftAltCtrl
		IF NKEYCODE=13
			THISFORM.cmdaceptar.Click
		ENDIF
ENDDEFINE 

DEFINE CLASS obj_img_conn2 as Image
	*Caption="Finalizar"
	*PicturePosition=14
	*Height=24
	*ToolTipText="Verificar conexión"
	width= 60
	stretch=1
	PROCEDURE click
	
		
ENDDEFINE 


DEFINE CLASS obj_img_conngreen2 as obj_img_conn2
	*picturePosition=14
	picture= "c:\ips\bitmaps\greendot.png"

ENDDEFINE 

DEFINE CLASS obj_img_connred2 as obj_img_conn2
	*PicturePosition=14
	picture= "c:\ips\bitmaps\reddot.png"
ENDDEFINE 

DEFINE CLASS obj_img_connyellow2 as obj_img_conn2
	*PicturePosition=14
	picture= "c:\ips\bitmaps\yellowdot.png"
ENDDEFINE 






DEFINE CLASS obj_img_conn as Image
	*Caption="Finalizar"
	*PicturePosition=14
	*Height=24
	*ToolTipText="Verificar conexión"
	width= 60
	stretch=1
	PROCEDURE click
		replace estado WITH ping(t_usuarios_con.ip)
		thisform.grd_usuarios.Refresh
ENDDEFINE 


DEFINE CLASS obj_img_conngreen as obj_img_conn
	*picturePosition=14
	picture= "c:\ips\bitmaps\greendot.png"

ENDDEFINE 

DEFINE CLASS obj_img_connred as obj_img_conn
	*PicturePosition=14
	picture= "c:\ips\bitmaps\reddot.png"
ENDDEFINE 

DEFINE CLASS obj_img_connyellow as obj_img_conn
	*PicturePosition=14
	picture= "c:\ips\bitmaps\yellowdot.png"
ENDDEFINE 

PROCEDURE colores_dinamicos()
*IIF(CONTROL=0,IIF(MOD(RECNO(),2)=1,colorgrid1,colorgrid2),IIF(CONTROL=1,IIF(MOD(RECNO(),2)=1,	colorgrid3,colorgrid3),IIF(CONTROL=2,color_separador,IIF(CONTROL=3,color_totales,IIF(control=4,color_cambio_pendiente,color_blanco)))))
	Do CASE 
	CASE control = 1
	     INSTRUCCIONG=colorgrid1
	CASE control = 2
	    INSTRUCCIONG=colorgrid1
	CASE control = 3
	    INSTRUCCIONG=colorgrid1
	CASE control = 3
	    INSTRUCCIONG=colorgrid1    
	OTHERWISE 
	    Return "img_conny"
	ENDCASE 
ENDPROC 

DEFINE CLASS obj_txt_ver_oc as TextBox
	PROCEDURE click 
		thisform.generar_detalle_oc()
	PROCEDURE gotfocus 
		thisform.generar_detalle_oc()
ENDDEFINE 

procedure Dynamic()
	Do CASE 
	CASE t_usuarios_con.estado = 1
	    Return "img_conng"
	CASE t_usuarios_con.estado = 2
	    Return "img_connr"
	CASE t_usuarios_con.estado = 3
	    Return "img_conny"
	OTHERWISE 
	    Return "img_conny"
	ENDCASE 
endproc
Define Class obj_cmd_finsesion As CommandButton
	Caption="Finalizar"
	Picture="c:\ips\bitmaps\exit.gif"
	PicturePosition=14
	Height=24
	ToolTipText="Finalizar Sesión"
	Procedure Click
		IF MESSAGEBOX("Desea finalizar sesión: " +CHR(13)+"EQ/Usuario: "+alltrim(t_usuarios_con.TERMINAL)+CHR(13)+"Empresa: "+ALLTRIM(t_usuarios_con.EMPRESA),4+32+256+4096,"Usuarios Activos")=6 then
			TEXT TO lcsql TEXTMERGE noshow
					UPDATE LOGUSUARIOS SET
					SALIDA=CURRENT_TIMESTAMP,
					IDENFORZ=<<PUSUARIOID>>
					WHERE
					TERMINAL='<<t_usuarios_con.TERMINAL>> '
					AND SALIDA IS NULL
					AND IDEN=<<t_usuarios_con.IDEN>>
					AND EMPRESA='<<t_usuarios_con.EMPRESA>>'
					AND SISTEMA='<<t_usuarios_con.SISTEMA>>'
					--WHERE TERMINAL=IDTERX AND SALIDA IS NULL AND EMPRESA=EMPRESAACTIVA AND SISTEMA=MPROGRA AND IDEN<>PUSUARIOID
			ENDTEXT
			If XEJECUTAR(LCSQL,LCSQL)>0 Then
				SELECT t_usuarios_con
				DELETE 
				thisform.grd_usuarios.refresh
				Messagebox("Usuario liberado correctamente",0+64+4096,"Gestion de usuarios")
*				THISFORM.REFRESH
				
			ENDIF
		ENDIF 
Enddefine


Define Class obj_cmd_install_vnc As CommandButton
	Caption=""
	Picture="c:\ips\bitmaps\cog_add.png"
	PicturePosition=14
	Height=24
	ToolTipText="Instalar VNC"
	Procedure Click
		IF MESSAGEBOX("Desea Instalar VNC en: " +CHR(13)+"EQ/Usuario: "+alltrim(t_usuarios_con.TERMINAL),4+32+256+4096,"Usuarios Activos")=6 then
			Select t_usuarios_con
			IF (t_usuarios_con.iden)=12 OR (t_usuarios_con.iden)=17 OR (t_usuarios_con.iden)=32 OR (t_usuarios_con.iden)=2 OR (t_usuarios_con.iden)=16 OR (t_usuarios_con.iden)=13 THEN 
				MESSAGEBOX("Este usuario esta restringido",0+48+4096,"Usuarios activos")
			ELSE
				instalar_vnc(t_usuarios_con.iden,t_usuarios_con.terminal)
			ENDIF 
		ENDIF 
Enddefine

Define Class obj_cmd_vnc As CommandButton
	Caption=""
	Picture="c:\ips\bitmaps\remoto.png"
	PicturePosition=14
	Height=24
	ToolTipText="Conectar con VNC"
	Procedure Click
	IF MESSAGEBOX("Desea conectar remotamente con: " +CHR(13)+"EQ/Usuario: "+alltrim(t_usuarios_con.TERMINAL),4+32+256+4096,"Usuarios Activos")=6 then
	
		Select t_usuarios_con
		IF (t_usuarios_con.iden)=12 OR (t_usuarios_con.iden)=17 OR (t_usuarios_con.iden)=32 OR (t_usuarios_con.iden)=2 OR (t_usuarios_con.iden)=16 OR (t_usuarios_con.iden)=13 THEN 
			MESSAGEBOX("Este usuario esta restringido",0+48+4096,"Usuarios activos")
		ELSE
			vnc(t_usuarios_con.ip)
		ENDIF 
	ENDIF 
Enddefine


Define Class obj_cmd_quitargrupos As CommandButton
	Caption="Liberar"
	Picture="c:\ips\bitmaps\editdelete.png"
	PicturePosition=14
	Height=24
	ToolTipText="Unificar"
	Procedure Click
	TEXT TO quitar_grupo TEXTMERGE NOSHOW
			UPDATE  Ordencompra
			SET     Codgrupo = NULL
			WHERE  (producto = '<<t_detalle_oc.producto>>') AND (codgrupo = '<<t_detalle_oc.codgrupo>>')
	ENDTEXT
	If XEJECUTAR(quitar_grupo,quitar_grupo) >0 Then
		Messagebox("concepto desagrupado",0+64+4096,"Detalle OC")
		Thisform.Refresh
	Endif
Enddefine

Define Class obj_cm_grupos As CommandButton
	Caption="Imprimir"
	Picture="c:\ips\bitmaps\book_open.png"
	PicturePosition=14
	Height=24
	ToolTipText="Imprimir OC"
	Procedure Click
	Do Form unifica_concepto_oc_detalle With t_conceptos_grupos.codigo_grupo, t_conceptos_grupos.nombre_grupo
ENDDEFINE





Define Class obj_chk_seleccionagrupos As Checkbox
	Height=24
	ToolTipText="Unificar"
	Procedure InteractiveChange
	If This.Value= 1 Then
		Select cur_detalle_ordenes
		Locate For orden = t_detalle_oc_u.orden
		If Not(Found())
			Append Blank
			Replace orden With t_detalle_oc_u.orden
			Replace producto With t_detalle_oc_u.producto
		Endif
	Else
		Select cur_detalle_ordenes
		Locate For orden = t_detalle_oc_u.orden
		Delete
		Set Deleted On
	Endif
Enddefine

DEFINE CLASS obj_cm_guardar_grupos as CommandButton
	caption="Guardar"
	picture="c:\ips\bitmaps\disk.png"
	pictureposition=14
	PROCEDURE click
		Select t_conceptos_grupos
		TEXT TO lcsql TEXTMERGE noshow
				UPDATE  com_grupos
				SET
				nombre_grupo =  '<<t_conceptos_grupos.nombre_grupo>>',
				descripcion  =  '<<t_conceptos_grupos.descripcion>>',
				depto = '<<t_conceptos_grupos.depto>>'
				WHERE  (idcomgrupo = <<t_conceptos_grupos.idcomgrupo>>)
		ENDTEXT
		IF XEJECUTAR(LCSQL,LCSQL)>0 then
			Select t_conceptos_grupos
			replace control WITH 0	
			thisform.grd_grupo.refresh	
		ENDIF
ENDDEFINE 

Define Class obj_txtcodgrupo As TextBox
	BorderStyle= 0
	Height= 25
	PROCEDURE interactivechange 
		Select t_conceptos_grupos
		replace control WITH 4	
Enddefine

Define Class obj_edit_generico As EditBox
	ScrollBars= 2
	BorderStyle=0

	Enabled=.T.
	Procedure DblClick
	*SELECT CUR_GASTOS_MENSUALES
	*Do Form unificacion_detalle_costo_oc With t_conceptos_oc.producto,xdpi
Enddefine


Define Class obj_edit As EditBox
	ScrollBars= 2
	BorderStyle=0

	Enabled=.T.
	Procedure DblClick
	*SELECT CUR_GASTOS_MENSUALES
	Do Form unificacion_detalle_costo_oc With t_conceptos_oc.producto,xdpi
Enddefine
	*- funcion de agregar funcionalidad de F5 y Escape
Procedure agregar_fx(xformulario)
	For Each obj  In xformulario.Controls
		Try
			Bindevent(obj, 'KeyPress',xformulario,'mitecla')
		Catch To Aerror
	*---
		Endtry
		If obj.BaseClass = 'Grid'

		Endif
	Endfor
Endproc



Define Class obj_txt_oc As TextBox
	Procedure Click
*MESSAGEBOX(thisform.grd_gasto_mensual.ActiveColumn)
ENDDEFINE

Define Class obj_txt_oc_cod As TextBox
	Procedure Click
		SELECT CUR_GASTOS_MENSUALES
		thisform.txt_busq_cod.value= CUR_GASTOS_MENSUALES.codigo
		*MESSAGEBOX(thisform.grd_gasto_mensual.ActiveColumn)
Enddefine


Define Class obj_txt_num As TextBox
	Format=mascara_numero
	InputMask=mascara_numero
	Format="Z"
	ReadOnly=.T.
	Procedure DblClick
		*SELECT CUR_GASTOS_MENSUALES
		Do Form detalle_costo_oc With CUR_GASTOS_MENSUALES.codigo,(Thisform.grd_gasto_mensual.ActiveColumn)-2,xperiodo, Alltrim(Thisform.txt_nombre.Value)
		*THISFORM.REFRESH
	PROCEDURE CLICK	
		SELECT CUR_GASTOS_MENSUALES
		thisform.txt_busq_cod.value= CUR_GASTOS_MENSUALES.codigo
Enddefine

Define Class obj_cmd_imp As CommandButton
	Caption="Imprimir"
	Picture="c:\ips\bitmaps\printer.png"
	PicturePosition=14
	Height=24
	ToolTipText="Imprimir OC"
	Procedure Click
	soloimpresion=.T.
	Select t_detalle_oc_u
*------ HABILITAR FOXYPREVIEWER
	Do FoxyPreviewer.App
*------------------------------
	Do Form correoordencompra With t_detalle_oc_u.orden
	soloimpresion=.F.
*------ IMPRESION ESTANDARD
*Para volver a ReportBehavior90
	Do FoxyPreviewer.App With "RELEASE"
*---------------------
*---- codigo para impresion de reporte
Enddefine
Define Class obj_cmd_imp1 As CommandButton
	Caption="Imprimir"
	Picture="c:\ips\bitmaps\printer.png"
	PicturePosition=14
	Height=24
	ToolTipText="Imprimir OC"
	Procedure Click
	soloimpresion=.T.
	Select t_detalle_oc
*------ HABILITAR FOXYPREVIEWER
	Do FoxyPreviewer.App
*------------------------------
	Do Form correoordencompra With t_detalle_oc.orden
	soloimpresion=.F.
*------ IMPRESION ESTANDARD
*Para volver a ReportBehavior90
	Do FoxyPreviewer.App With "RELEASE"
*---------------------
*---- codigo para impresion de reporte
Enddefine
Define Class obj_chk_empleado As Checkbox
	Caption=""
	AutoSize=.T.
	Alignment=2
	Procedure Click
*MESSAGEBOX("hola mundo")
Enddefine

Define Class obj_chk_grupo As Checkbox
	Caption=""
	AutoSize=.T.
	Alignment=2
	Procedure Click
	Select t_conceptos_grupos
*replace ALL marcar WITH 0
*this.Value= 1
	Thisform.txt_codigo.Value = t_conceptos_grupos.codigo_grupo
	Thisform.txt_concepto.Value= t_conceptos_grupos.nombre_grupo
*MESSAGEBOX("hola mundo")
Enddefine
Define Class obj_chk_costos As Checkbox
	Caption=""
	AutoSize=.T.
	Alignment=2
	Procedure interactivechange 
		Select t_detalle_oc_u
		TEXT TO upd_oc_m TEXTMERGE noshow
			UPDATE       Ordencompramaster
			SET                tipo_costo =<<STR(this.Value,1,0)>>
			WHERE        (orden= '<<t_detalle_oc_u.orden>>')
		ENDTEXT 
		IF xejecutar(upd_oc_m,upd_oc_m)>0 THEN 
			
		ENDIF 
Enddefine

Define Class obj_chk_costos2 As Checkbox
	Caption=""
	AutoSize=.T.
	Alignment=2
	Procedure interactivechange 
		Select t_detalle_oc
		TEXT TO upd_oc_m TEXTMERGE noshow
			UPDATE       Ordencompramaster
			SET                tipo_costo =<<STR(this.Value,1,0)>>
			WHERE        (orden= '<<t_detalle_oc.orden>>')
		ENDTEXT 
		IF xejecutar(upd_oc_m,upd_oc_m)>0 THEN 
			
		ENDIF 
Enddefine

Define Class obj_chk_costos3 As Checkbox
	Caption=""
	AutoSize=.T.
	Alignment=2
	Procedure interactivechange 
		Select t_conceptos_grupos
		TEXT TO upd_oc_m TEXTMERGE noshow
			UPDATE  Ordencompramaster
			SET     tipo_costo =<<STR(this.Value,1,0)>>
			FROM    Ordencompra INNER JOIN
			        Ordencompramaster ON Ordencompra.orden = Ordencompramaster.orden
			WHERE  (Ordencompra.codgrupo = '<<t_conceptos_grupos.codigo_grupo>>')
		ENDTEXT 
		IF xejecutar(upd_oc_m,upd_oc_m)>0 THEN 
			
		ENDIF 
Enddefine


Define Class obj_header_empleado As Header
	Procedure Click
*Messagebox("hola")

Enddefine
*---------------------------------------------
Procedure xfx(nKeyCode)
*!*	 Key     Alone   Shift    Ctrl    Alt
*!*	   ------------------------------------
*!*	   F1        28      84      94     104
*!*	   F2        -1      85      95     105
*!*	   F3        -2      86      96     106
*!*	   F4        -3      87      97     107
*!*	   F5        -4      88      98     108
*!*	   F6        -5      89      99     109
*!*	   F7        -6      90     100     110
*!*	   F8        -7      91     101     111
*!*	   F9        -8      92     102     112
*!*	   F10       -9      93     103     113
*!*	   F11      133     135     137     139
*!*	   F12      134     136     138     140
*!*
Do Case
Case nKeyCode = -4
	Thisform.Refresh
Endcase
Endproc

Procedure ENVIAR_SOLUCION_IT(GCORREO,GCLAVE,CORREODESTINO,XASUNTO,GTITULO,xnotas,GTEXTBODY,GARCHIVO)
TEXT to cuertpo_mensaje textmerge noshow
		<body style="height: 372px; width: 564px">
			<table cellpadding="0" cellspacing="0" class="style1">
				<tr>
					<td bgcolor="White" class="style8" rowspan="4">
						<img alt="" src="http://www.cmfinfasa.net/images/infasal.jpg" />
					</td>
					<td bgcolor="White" class="style9"
						style="font-family: Arial; font-size: 11px; font-weight: bold;">
						Industria Farmaceutica, S.A.
					</td>
					<td bgcolor="White" class="style8" rowspan="4">
						<img alt="" src="http://www.cmfinfasa.net/images/codigobarrasinfasa.png"
							style="margin-left: 42px" />
					</td>
				</tr>
				<tr>
					<td bgcolor="White" class="style9" style="font-family: Arial; font-size: 11px;">
						Km. 15.5 Calzada Roosevelt 0-80 zona 2 Mixco
					</td>
				</tr>
				<tr>
					<td bgcolor="White" class="style9" style="font-family: Arial; font-size: 11px;">
						PBX: 2411-5454
					</td>
				</tr>
				<tr>
					<td bgcolor="White" class="style9" style="font-family: Arial; font-size: 11px;">
						Sistema IPS
					</td>
				</tr>
				<tr>
					<td bgcolor="SteelBlue" class="style7" colspan="3"
						style="font-family: Arial; font-size: 12px; vertical-align: text-top; text-align: justify; color: #FFFFFF;">
						<center>
							<h3><b><<ALLTRIM(gtitulo)>></b></h3>
						</center>
					</td>
				</tr>
				<tr>
					<td bgcolor="SteelBlue" class="style7" colspan="3"
						style="font-family: Arial; font-size: 12px; vertical-align: text-top; text-align: justify; color: #FFFFFF;">
						<<ALLTRIM(GTEXTBODY)>>
					</td>
				</tr>
				<tr>
					<td bgcolor="SteelBlue" colspan="3">
						&nbsp;
					</td>
				</tr>
				<tr>
					<td bgcolor="SteelBlue" colspan="3">
						&nbsp;
					</td>
				</tr>
				<tr>
					<td bgcolor="SteelBlue" colspan="3">
						&nbsp;
					</td>
				</tr>
				<tr>
					<td bgcolor="SteelBlue" class="style7" colspan="3"
						style="font-family: Arial; font-size: 12px; vertical-align: text-top; text-align: justify; color: #FFFFFF;">
						<HR width=80% align="center">
						<b><i>Notas</i></b>
						<p><i><<ALLTRIM(xnotas)>></i></p>
					</td>
				</tr>
				<tr>
					<td bgcolor="SteelBlue" colspan="3">
						&nbsp;
					</td>
				</tr>
				<tr>
					<td bgcolor="SteelBlue" colspan="3">
						&nbsp;
					</td>
				</tr>
				<tr>
					<td bgcolor="SteelBlue" colspan="3">
						&nbsp;
					</td>
				</tr>
				<tr>
					<td bgcolor="SteelBlue" colspan="3">
						&nbsp;
					</td>
				</tr>
				<tr>
					<td bgcolor="SteelBlue" colspan="3">
						&nbsp;
					</td>
				</tr>
				<tr>
					<td bgcolor="SteelBlue" colspan="3">
						&nbsp;
					</td>
				</tr>
				<tr>
					<td bgcolor="SteelBlue" colspan="3">
						&nbsp;
					</td>
				</tr>
				<tr>
					<td bgcolor="White" colspan="3"
						style="font-family: Arial; font-size: 11px; font-weight: bold;">
						-------------------------------ESTE ES UN MENSAJE AUTOMATICO FAVOR NO
						CONTESTAR-------------------------------
					</td>
				</tr>
			</table>
		</body>
ENDTEXT

Clear
LOMAIL = Newobject("Cdo2000", "Cdo2000.fxp")
With LOMAIL
	.CSERVER = "smtp.gmail.com"
	.NSERVERPORT = 25 &&465
	.LUSESSL = .T.
	.NAUTHENTICATE = 1
	.CUSERNAME = GCORREO
	.CPASSWORD = GCLAVE
	.CFROM = GCORREO
	.CTO = GDESTINATARIO
	.CSUBJECT = XASUNTO
	.CHTMLBODY = cuertpo_mensaje
	.CTEXTBODY = GTEXTBODY
	If !Empty(GARCHIVO)
		.CATTACHMENT = GARCHIVO
	Endif
Endwith
If LOMAIL.Send() > 0
	Local IERRORES
	Store '' To IERRORES
	For I=1 To LOMAIL.GETERRORCOUNT()
		IERRORES=IERRORES+ LOMAIL.GETERROR(I)
	Endfor
	If 'NOT AVAILABLE'$Upper(IERRORES)
		Messagebox('No se pudo enviar el Correo, Usuario o Contraseña Incorrecta.',0+16+0,'Error')
	Else
		Messagebox('No se pudo enviar el Correo.  '+Chr(13)+Chr(13)+IERRORES,0+16+0,'Error')
	Endif
	LOMAIL.CLEARERRORS()
	Return 0
Else
	LOMAIL.CLEARERRORS()
	Messagebox('El correo fue enviado de forma correcta.',0+64+0,'Envio de Correo')
	Return 1
Endif
Endproc
Procedure TOTAL_adjuntos()
	Store Alltrim(Alltrim(CREadir(2))) To DIRA
	TOTALA=Adir(DIRINFO,DIRA+'*.*','H') && CANTIDAD DE ARCHIVOS
	Return TOTALA
Endproc

Procedure archivosadjuntos()
	Store Alltrim(Alltrim(CREadir(2))) To DIRA
	TOTALA=Adir(DIRINFO,DIRA+'*.*','H') && CANTIDAD DE ARCHIVOS



	Create Table C:\&PIFOLDER\ARCHIVOS.Dbf Free;
	(ARCHIVO C(200))

	For I=1 To TOTALA
		If (!("D"$DIRINFO[I,5])) And DIRINFO[I,1]<>"." And DIRINFO[I,1]<>".."
			Select ARCHIVOS
			Append Blank
			Replace ARCHIVOS.ARCHIVO With DIRA+Upper(DIRINFO[I,1])
		Endif
	Endfor
	Store "" To ADJ
	Select ARCHIVOS
	Go Top
	Scan
		ADJ=ADJ+Alltrim(ARCHIVOS.ARCHIVO)+','
	Endscan

	ADJ=Left(ADJ,Len(Alltrim(ADJ))-1)
	Return ADJ
Endproc

Procedure CREadir(op)
*	PARAMETERS OP

Store 'C:\&PIFOLDER\soluciones_it\' To APATH

If op<2
	If !Directory('&APATH')
		Md '&APATH'
	Endif

	If op=0
		Erase '&APATH'+'*.*'
	Endif
Endif

Return APATH
Endproc
Procedure creapdf()
&&&&&&&&&&&&&&&&&configuro BULLZIP
*SET STEP ON
Dimension m.MATRICE(1)
m.NUMPRINTERS=Aprinters(m.MATRICE)
Store 0 To OKBULLZIP
For m.counter=1 To m.NUMPRINTERS
	If "BULLZIP"$Upper(m.MATRICE(m.counter,1)) And !"REDIREC"$Upper(m.MATRICE(m.counter,1))
		Store 1 To OKBULLZIP
		Exit
	Endif
Endfor
If OKBULLZIP=0
	Messagebox("NO EXISTE LA IMPRESORA BULLZIP PDF EN SU SISTEMA, FAVOR INFORMAR A SISTEMAS",64,"IMPRESORA")
	Return .F.
Endif

m.numprinter=m.counter
m.DEFAULTPRINTER=Set("Printer",2)
Store m.DEFAULTPRINTER To QQDEFAULT

If !"BULLZIP"$Upper(m.DEFAULTPRINTER)
	Set Printer To Name m.MATRICE(m.numprinter,1)
Endif
*!*		SELECT IESTADOCTA
*!*		STORE '&RUTAPDFS'+UCLIENTESINE+'.JPG' TO MRUTAPDF
Store Alltrim(Str(NOORDEN)) To CNORDEN
Store "_ORDEN_&CNORDEN"+".PDF" To NPDF
Store Alltrim(Alltrim(CREadir(2))) To APATH
Store APATH + NPDF To MRUTAPDF

LCOBJ = Createobject("BullZIP.PDFPrinterSettings")
With LCOBJ
	.SETVALUE("Output",MRUTAPDF)
	.SETVALUE("ShowSettings" ,"never")
	.SETVALUE("ShowPDF" ,"no")
	.SETVALUE("ShowProgressFinished" ,"no")
	.SETVALUE("ShowProgress" ,"no")
	.SETVALUE("Linearize" ,"no")
	.WRITESETTINGS(.T.)
Endwith

If !"BULLZIP"$Upper(m.DEFAULTPRINTER)
	Store "Bullzip PDF Printer" To m.DEFAULTPRINTER
	Set Printer To Name (m.DEFAULTPRINTER)
	If ESREPLICA=.T.
		Try
			oShell = Createobject("WScript.Shell")
			oShell.Run('rundll32 PRINTUI.dll,PrintUIEntry /y /n "Bullzip PDF Printer"',0,.T.)
		Catch
		Endtry
	Endif
Endif

If File('&MRUTAPDF')
	Delete File '&MRUTAPDF'
Endif

Set Echo Off
Set Talk Off
Set Console Off
&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
Report Form ORDENDECOMPRA To Printer Noconsole
If ESREPLICA=.T. And !"BULLZIP"$Upper(QQDEFAULT)
	For m.counter=1 To m.NUMPRINTERS
		If Upper("&QQDEFAULT")$Upper(m.MATRICE(m.counter,1))
			Try
				oShell = Createobject("WScript.Shell")
				oShell.Run('rundll32 PRINTUI.dll,PrintUIEntry /y /n "&QQDEFAULT"',0,.T.)
			Catch
			Endtry
			Exit
		Endif
	Endfor
Endif
If Directory('&APATH')
	Thisform.OLEcontrol1.NAvigate2('&APATH')
	Thisform.OLEcontrol1.Visible= .T.
Else
	Thisform.OLEcontrol1.NAvigate2('')
	Thisform.OLEcontrol1.Visible= .F.
Endif
Endproc

Procedure XEJECUTAR(xinsertar,xactualizar)
	* para insertar un registro unico (ej numero_factura, dpi etc) se debe de agregar la consulta de inserción como primer parametro
	* y la de actualización como segundo, le programa intentara insertar el registro si este ya existe no devuelve el error e intentara
	* actualizar con la segunda consulta
	If SQLExec(hconn,xinsertar,"",matrizr)>0 Then
		*Return matrizr[1,2]
		Return 1
	ELSE
		
		If SQLExec(hconn,xactualizar,"",matrizr)>0 Then
			Return 1
		ELSE
			PRIVATE xsanitizar
			xsanitizar= SANITIZAR(xactualizar)
			a=Aerror(matriz)
			*MESSAGEBOX(sql_limpiar_error( matriz(2),']'),0+48+4096,"No se puede realizar operación")
			WAIT WINDOW sql_limpiar_error( matriz(2),']') NOWAIT 
			*Messagebox(matriz(2))
			*Messagebox(xactualizar)
			*_cliptext=xactualizar
			*TEXT TO lcsql TEXTMERGE NOSHOW 
			*	INSERT INTO t_errores (query,equipo)values('<<ALLTRIM(xsanitizar)>>','<<ID()>>'
			*ENDTEXT 
			*IF SQLEXEC(hconn,lcsql)>0 then
			*	WAIT WINDOW "log" 
			*ELSE
			*	a=Aerror(matriz)
			*	Messagebox(matriz(2))
			*	Messagebox(lcsql)
			*ENDIF 
			*_CLIPTEXT= xactualizar
			*set step on 
	*		MESSAGEBOX(actualizar)
			Return 0
		Endif
	Endif
Endproc

Procedure XEJECUTAR2(xinsertar,xactualizar)
	* para insertar un registro unico (ej numero_factura, dpi etc) se debe de agregar la consulta de inserción como primer parametro
	* y la de actualización como segundo, le programa intentara insertar el registro si este ya existe no devuelve el error e intentara
	* actualizar con la segunda consulta
	If SQLExec(hconn,xinsertar)>0 Then
		Return 1
	Else
		If SQLExec(hconn,xactualizar)>0 Then
			Return 1
		Else
			a=Aerror(matriz)
			*Messagebox(matriz(2))
			*_CLIPTEXT= xactualizar
			*set step on 
	*		MESSAGEBOX(actualizar)
			Return 0
		Endif
	Endif
Endproc

Procedure Xtabla(xconsulta,xnombre_cursor)
	IF USED("&xnombre_cursor") then
		USE IN &xnombre_cursor
	ENDIF 
	If SQLExec(hconn,xconsulta,'&xnombre_cursor')>0
		Return 1
	Else
		a=Aerror(matriz)
		Messagebox(matriz(2))
		SET STEP ON 
		*Messagebox(xconsulta)
		Return 0
	Endif
Endproc

Procedure correlativoauto(xprefijo,xperiodo,xcampo,nceros,xop)
	TEXT TO lcsql TEXTMERGE NOSHOW
			SELECT <<xcampo>>
			from t_correlativo_periodo
			where periodo ='<<xperiodo>>' and empresa='<<empresaactivacod>>'
	ENDTEXT
	If Xtabla(LCSQL,"t_corr")>0 Then
		Select t_corr
		TEXT TO instruccion TEXTMERGE NOSHOW
				 xnuevo_corr= t_corr.<<xcampo>>+1
		ENDTEXT
		&instruccion
		
		TEXT TO actualizar_contador TEXTMERGE noshow
				UPDATE t_correlativo_periodo SET
				<<xcampo>>= <<xnuevo_corr>> where empresa='<<empresaactivacod>>'
		ENDTEXT
		IF xop=.t. then
			If XEJECUTAR(actualizar_contador,actualizar_contador)> 0 Then
				Return xprefijo+Padl(xnuevo_corr,nceros,'0')
			Else
				Return ""
			ENDIF
		ELSE
			Return xprefijo+Padl(xnuevo_corr,nceros,'0')
		ENDIF
	Endif
Endproc

Procedure FECHA_SQL(fechavfp)
PRIVATE xfechavfp
IF VARTYPE(fechavfp)="C" then
xfechavfp= CTOD(fechavfp)
ELSE
	xfechavfp=fechavfp
ENDIF 
Store Alltrim(Str(Year(xfechavfp))) To mano
Store Padl(Alltrim(Str(Month(xfechavfp))),2,'0') To mmes
Store Padl(Alltrim(Str(Day(xfechavfp))),2,'0') To mdia
Store mano+'-'+mmes+'-'+mdia To fechasql
Return fechasql
Endproc

Procedure REDONDEOSAT2(VALOR,DECIMALES)
****SE USA CRITERIO DE APROXIMACION, SE RECIBE EL VALOR, Y EL DECIMAL SIGNIFICATIVO MAYOR QUE 5 PARA APLICAR EL CRITERIO
If Vartype(DECIMALES)='N'
Else
	DECIMALES=2
Endif
RESULTA=REDONDEAR(VALOR,2+DECIMALES)
*!*IF ROUND(RESULTA,2)-ROUND(VALOR,2)<>0
*!*		*set step on
*!*ELSE
*!*ENDIF
Return RESULTA
Endproc

Function REDONDEAR(VALORI,TOTDEC)
VALTEMP=VALORI-Int(VALORI)
Store Alltrim(Str(VALTEMP,20,TOTDEC)) To VALORTEMP2

If Val(Right(VALORTEMP2,2))>=50
	VALTRETOR=Round(VALORI,TOTDEC-2)
Else
	VALTRETOR=Round((VALORI-Mod(VALORI,1))+Val(Substr(VALORTEMP2,1,TOTDEC)),TOTDEC-2)
Endif
Return VALTRETOR
Endfunc


Procedure funcbusqueda_emp(PARBUSEMP,NOMBRETABLA,CLASIEMP,CAMPOFIL)
progbusemp(PARBUSEMP,NOMBRETABLA,CLASIEMP,CAMPOFIL)
Endproc
*----------------------------------------------

Procedure prtipo_cambio(xfecha,xtc_defecto)
Private xcontrol_eje
Store 0 To xcontrol_eje
*obtiene tipo de cambio de xfecha, si no existe TC establece uno por defecto
*xfecha: valor tipo fecha del TC
*xtc_defecto: valor con punto flotante que se establece si no existe TC para la fech
TEXT TO lcsql TEXTMERGE NOSHOW
			SELECT    fecha, tasadolar, tasadolard, id
			FROM            TipoCambio
			WHERE        (fecha = '<<FECHA_SQL(xfecha)>>')
ENDTEXT
If Xtabla(LCSQL,"t_tc")>0 Then
	If t_tc.tasadolar=0  Then
		If xtc_defecto = 0 Then
			Do While xtc_defecto= 0
*buscar un TC día anterior
				xfecha= xfecha -1
				TEXT TO lcsql TEXTMERGE NOSHOW
							SELECT    fecha, tasadolar, tasadolard, id
							FROM            TipoCambio
							WHERE        (fecha = '<<FECHA_SQL(xfecha)>>')
				ENDTEXT
				If Xtabla(LCSQL,"t_tc2")>0 Then
					xcontrol_eje=xcontrol_eje+1
					If xcontrol_eje>= 30 Then
						Messagebox("No existe TC para esta fecha y 30 días anteriores",0+48+4096,"Tipo de cambio")
						Return 0
					Endif
					xtc_defecto= t_tc2.tasadolar
				Endif
			Enddo
		Else
			Return xtc_defecto
		Endif
		Return xtc_defecto
	Else
		Return t_tc.tasadolar
	Endif
Endif
Endproc

Procedure MES_LETRA(NUMERO)
IF numero= 0 then
	RETURN "--"
ELSE

Dimension laMes [90]
*LOCAL laMes
Alines(laMes,Chrtran('Enero,Febrero,Marzo,Abril,Mayo,Junio,Julio,Agosto,Septiembre,Octubre,Noviembre,Diciembre' ,',',Chr(13)))
Return laMes[NUMERO]
ENDIF 
Endproc
Procedure assets()
Messagebox(HOMESISTEMA)
Endproc

Procedure vnc(xip)
 *COMPROBAR PING ANTES DE CONECTAR
 	WAIT WINDOW "Comprobando conexion" NOWAIT 
 	
 	IF ping(ALLTRIM(xip))= 2 then
 		*conexion
 		*WAIT WINDOW "Equipo sin conexión" NOWAIT  TIMEOUT 2
 		*RETURN .f.
 		PRIVATE xresp
 		xresp= MESSAGEBOX("Equipo no responde, Intentar conectar de todas formas?",4+32+4096,"Conexión rémota")
 		IF xresp= 7 then
 		RETURN .f.
 		ENDIF 
* 	ELSE
 	ENDIF 
 		
 		WAIT WINDOW "Intentando Conectar..." NOWAIT 
		PRIVATE MYPASS
		MYPASS= "!nF@5@"
		TEXT TO MI_VNC TEXTMERGE NOSHOW
				C:\Ips\assets\vnc\tvnviewer.exe  -host=<<xip>> -password=<<MYPASS>>
		ENDTEXT
		Run /N &MI_VNC
	
Endproc
PROCEDURE correr(xapp)
	TEXT TO xcomando TEXTMERGE NOSHOW
		<<xapp>>
	ENDTEXT
	Run /N &xcomando
ENDPROC 
PROCEDURE instalar_vnc(xid,xequipo)
	IF (xid)=12 OR (xid)=17 OR (xid)=32 OR (xid)=2 OR (xid)=16 OR (xid)=13 THEN 
		MESSAGEBOX("Este usuario esta restringido",0+48+4096,"Usuarios activos")
	ELSE
		* path de instaldores: M:\_pg
		xcomando= "M:\_PG\VNC\UltraVNC_1_2_01_X86_Setup.exe"
		xparametro= "/SP- /VERYSILENT /SUPRESSMSGBOXES /NORESTART /LOADINF=setup.inf /NOICONS"
		TEXT TO sql_insertar TEXTMERGE NOSHOW 
			INSERT
			INTO    t_comando_remoto(iden, equipo, comando, resultado, detalle, parametros)
			VALUES (<<xid>>,'<<xequipo>>','<<xCOMANDO>>',0,'','<<xparametro>>')
		ENDTEXT 
		XEJECUTAR(sql_insertar,sql_insertar)
		*crear archivo en M:
TEXT TO xml_conf TEXTMERGE NOSHOW 
<?xml version="1.0" encoding="utf-8"?>
<Data>
  <conf_usuario>
    <comando>\\it-srv-db1\c$\ips\_pg\VNC\UltraVNC_1_2_01_X86_Setup.exe</comando>
    <parametros>/SP- /VERYSILENT /SUPRESSMSGBOXES /NORESTART /LOADINF=setup.inf /NOICONS</parametros>
  </conf_usuario>
</Data>
ENDTEXT
STRTOFILE(xml_conf, "M:\_pg\user_inst\"+ALLTRIM(xequipo)+".txt")
	ENDIF 
ENDPROC 

PROCEDURE crear_conf()
	PRIVATE xruta as String
	PRIVATE xarchivo as String
	PRIVATE xcompleto as String
	xruta=GETENV("TMP")+"\control_app\"
	xarchivo= "conf.xml"
	xcompleto = ALLTRIM(xruta)+ ALLTRIM(xarchivo)
	IF DIRECTORY("&xruta") = .t. then
	ELSE
	 	MD "&xruta"
	ENDIF
	IF FILE("&xcompleto") = .t. THEN 
		*archivo ya existe, No se crea
	ELSE 
TEXT TO xml_conf TEXTMERGE NOSHOW 
<?xml version="1.0" encoding="utf-8"?>
<Data>
  <conf_usuario>
    <equipo><<ID()>></equipo>
  </conf_usuario>
</Data>
ENDTEXT
	STRTOFILE(xml_conf, "&xcompleto")
	ENDIF
ENDPROC 
PROCEDURE control_app()
	PRIVATE xruta AS STRING
	PRIVATE xarchivo AS STRING
	PRIVATE xcompleto AS STRING
	PRIVATE xsource AS STRING
	xruta=GETENV("TMP")+"\control_app\"
	xarchivo= "control_app.exe"
	xcompleto = ALLTRIM(xruta)+ ALLTRIM(xarchivo)
	xsource = "&IDMAP:\EXE\control_app.exe"
	IF FILE('&xcompleto ')
		STORE FDATE("&xcompleto") TO LOCALDATE
		STORE FTIME("&xcompleto") TO LOCALTIME
		IF FILE('&xsource')
			STORE FDATE('&xsource') TO SERVDATE
			STORE FTIME('&xsource') TO SERVTIME
		ELSE
			STORE {//} TO AUTODATE1
			STORE '00:00' TO AUTOTIME1
		ENDIF
		IF (SERVDATE<>LOCALDATE or SERVTIME<>LOCALTIME)
			TEXT TO MI_app TEXTMERGE NOSHOW
	taskkill /IM Control_app.exe /t
			ENDTEXT
			CMDRUN (mi_app,.t.)
			WAIT WINDOW "Iniciando " TIMEOUT 4
			ERASE &xcompleto
			STORE "COPY FILE &XSOURCE TO &XCOMPLETO" TO VCOPIAPP
			&VCOPIAPP
			STORE 0 TO CONTADOR
			DO WHILE !FILE('&XCOMPLETO')
				CONTADOR=CONTADOR+1
				IF CONTADOR>5000
					MESSAGEBOX("Se Ha Agotado El Tiempo De Espera, No Se Encontró El Archivo De Configuración. Reinicie El Sistema",64+0+0,"INICIO &MPROGRA")
					*QUIT
				ENDIF
			ENDDO
		ELSE
		ENDIF
	ELSE
		STORE "COPY FILE &XSOURCE TO &XCOMPLETO" TO VCOPIAPP
		&VCOPIAPP
	ENDIF
	crear_inicio_auto()
	CMDRUN('&xcompleto',.f.)
ENDPROC
*********************************************************************************************************************************************************************************************************************************
PROCEDURE CMDRUN (CMDCOMANDO,espera)
	LOCAL OWSH
	OWSH = CREATEOBJECT("WScript.Shell")
	STORE "CMD /C "+"&cmdComando" TO CMDINSTRUC
	OWSH.RUN("&cmdinstruc",0,espera)
ENDPROC
*********************************************************************************************************************************************************************************************************************************
PROCEDURE dir_startup()
	TEXT TO mi_startup TEXTMERGE noshow
<<GETENV("USERPROFILE")>>\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup
	ENDTEXT
	RETURN mi_startup 
ENDPROC 
PROCEDURE crear_inicio_auto()
	WshShell = CreateObject("WScript.Shell")
	strDesktop = dir_startup()
	TEXT TO eje TEXTMERGE noshow
	oUrlLink = WshShell.CreateShortcut("<<ALLTRIM(strDesktop)>>\control_app.lnk")
	oUrlLink.TargetPath = "<<GETENV("USERPROFILE")>>\AppData\Local\Temp\control_app\control_app.exe"
	oUrlLink.Save
	ENDTEXT 
	*&eje
	EXECSCRIPT(eje)
	*oUrlLink.TargetPath = "C:\Users\CGomez\AppData\Local\Temp\control_app\control_app.exe"

ENDPROC 
*-------------------------------------------------
*-------------------------------------------------
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

PROCEDURE entero_a_logico(xvalor)
IF VARTYPE(XVALOR)="N" THEN

	IF xvalor=1 then
		RETURN .T.
	ELSE
		RETURN .F.
	ENDIF 
ELSE
	RETURN .F.
ENDIF 
ENDPROC 

PROCEDURE logico_a_entero(xvalor)
IF VARTYPE(XVALOR)="L" THEN
	IF xvalor=.t. then
		RETURN 1
	ELSE
		RETURN 0
	ENDIF 
ELSE
	RETURN 0
ENDIF 
ENDPROC 
PROCEDURE BUSQUEDA_LIKE(XTEXTO,XCAMPO)
	XTEXTO=XTEXTO+" "
	STORE "" TO PALABRA
	STORE " (1=1" TO WH
	FOR I=1 TO LEN(XTEXTO)
		IF SUBSTR(XTEXTO,I,1)=' '
			WH=WH+" AND &XCAMPO LIKE'%&PALABRA%'"
			PALABRA=""
		ELSE
			PALABRA=PALABRA+ALLTRIM(SUBSTR(XTEXTO,I,1))
		ENDIF
	ENDFOR
	WH=WH+")"
	RETURN WH
ENDPROC 

PROCEDURE SANITIZAR(texto)
	PRIVATE filtro1, filtro2, filtrado
	filtro1= CHRTRAN(texto,['],[])
	filtro2=CHRTRAN(filtro1,["],[])
	filtro3=CHRTRAN(filtro2,[.],[-])
	filtrado = ALLTRIM(filtro3)
	RETURN filtrado
ENDPROC
PROCEDURE SANITIZAR2(texto)
	PRIVATE filtro1, filtro2, filtrado
	filtro1= CHRTRAN(texto,['],[])
	filtro2=CHRTRAN(filtro1,["],[])
	filtro3=CHRTRAN(filtro2,[.],[])
	filtrado = ALLTRIM(filtro3)
	RETURN filtrado
ENDPROC

PROCEDURE VALOR_DEFECTO(XVALOR) 
	PRIVATE XTIPO
	TEXT TO TIPOVARL_CAMPO TEXTMERGE NOSHOW 	
		XTIPO= VARTYPE(<<XVALOR>>)
	ENDTEXT 
	&TIPOVARL_CAMPO 
	DO CASE 
		CASE XTIPO= "C"
			RETURN ""
		CASE XTIPO = "N"
			RETURN 0.00
		CASE XTIPO = "D"
			RETURN {}
		OTHERWISE 
			RETURN ""
		ENDCASE 	
ENDPROC 

procedure update_regsan(xcodigo,xreg,xfechav,xcrear_nuevoreg)
	if xcrear_nuevoreg=1 then
		text to insert_regsan textmerge noshow 
			insert into RegistroSanitario (noregistros,vence,codigo,pais,laboratorio,status,noDesarrollo) 
			values('<<alltrim(xreg)>>','<<xfechav>>','<<alltrim(xcodigo)>>', '0001',0,1,'I')
		endtext, 
		if xejecutar(insert_regsan,insert_regsan)>0 then
			
		endif
	ELSE
		IF VARTYPE(xcodigo)<> "L" then
			IF not(EMPTY(xreg)) THEN
				TEXT TO lcsql TEXTMERGE noshow
					update RegistroSanitario set
					noRegistroS = '<<ALLTRIM(xreg)>>',
					vence='<<xfechav>>' ,
					noDesarrollo='I'
					where codigo ='<<ALLTRIM(xcodigo)>>' and pais= '0001'
				ENDTEXT
				IF xejecutar(lcsql, lcsql)>0 THEN
				ENDIF
			ENDIF
		else
		 *- error de registro sanitario
		endif
	ENDIF
ENDPROC

procedure update_regsan2(xcodigo,xreg,xfechav,xcrear_nuevoreg,xnombre,xcodigopro,xnombrelegal)
	IF xcrear_nuevoreg=1 THEN
		TEXT TO elim_regsan TEXTMERGE NOSHOW
			DELETE FROM registrosanitario WHERE codigo ='<<ALLTRIM(xcodigo)>>' and pais= '0001' AND nombre='<<ALLTRIM(xnombre)>>'
		ENDTEXT
		IF xejecutar(elim_regsan,elim_regsan)>0 THEN
			
		ENDIF
		TEXT TO insert_regsan TEXTMERGE NOSHOW
			INSERT INTO RegistroSanitario (noregistros,vence,codigo,pais,laboratorio,status,noDesarrollo,nombre,CODPRODUCTO,nombrelegal,aplica)
			values('<<alltrim(xreg)>>','<<xfechav>>','<<alltrim(xcodigo)>>', '0001',1123,1,'I','<<xnombre>>','<<xcodigopro>>','<<xnombrelegal>>',1)
		ENDTEXT
		IF xejecutar(insert_regsan,insert_regsan)>0 THEN
			
		ENDIF
	ENDIF
ENDPROC


PROCEDURE SPLIT_TEXT(XDATOS,XSEPARADOR)
	PUBLIC XMATRIZZ
	DIMENSION XMATRIZZ[1] 
	TEXT TO LCSQL TEXTMERGE NOSHOW
		NROWS= ALINES(XMATRIZZ, XDATOS, .F., "<<ALLTRIM(XSEPARADOR)>>")
	ENDTEXT 
	&LCSQL
	*SET STEP ON 
	RETURN @XMATRIZZ
ENDPROC

PROCEDURE zoom_cc_editar(xxfiltro)
	DO FORM zoom_cc_editar WITH xxfiltro
ENDPROC

PROCEDURE oemov(xcodigo,xpresentacion, xlote, xfempaque, xcantidad,xtipomov)
	DO FORM costeo_lotes_prodccion_oemov WITH xcodigo,xpresentacion, xlote, xfempaque, xcantidad,xtipomov
ENDPROC 

PROCEDURE nombreusr(xidusuario)
	TEXT TO xlcsql TEXTMERGE NOSHOW 
		select nombre from permisosformemp where iden= <<xidusuario>>
	ENDTEXT 
	IF xtabla(xlcsql,"t_nombusr")>0 then
		RETURN t_nombusr.nombre
	ELSE
		RETURN STR(xidusuario,0,0)
	ENDIF 
ENDPROC 
PROCEDURE nombrevisita(xidusuario)
	TEXT TO xlcsql TEXTMERGE NOSHOW 
		select nombre from Vendedores where cmf= '<<xidusuario>>'
	ENDTEXT 
	IF xtabla(xlcsql,"t_nombusr")>0 then
		RETURN t_nombusr.nombre
	ELSE
		RETURN ALLTRIM(STR(xidusuario,10,0))
	ENDIF 
ENDPROC 