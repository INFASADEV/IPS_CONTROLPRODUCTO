STORE 127 TO xornum 
select * from receppedidos where ornum = xornum
select * from receppedidosdet where idrecped in (select id from receppedidos where ornum = xornum) and porcant > 0
select * from receppedidosdetdet where idrecpedde in (select id from receppedidosdet where idrecped = (select id from receppedidos where ornum = xornum))
select * from recepbultos where idordtom in (select id from receppedidosdetdet where idrecpedde in (select id from receppedidosdet where idrecped = (select id from receppedidos where ornum = xornum)))
select sum(cantidad) from recepbultos where idordtom = (select top 1 id from receppedidosdetdet where idrecpedde in (select id from receppedidosdet where idrecped = (select id from receppedidos where ornum = xornum)) ORDER  BY id desc)

*!*	UPDATE receppedidosdetdet SET cantidad = 79350.00 WHERE id = 1056

SELECT a.cantidad,(select SUM(cantidad) FROM recepbultos d WHERE d.idordtom = a.id) sumbul,c.ornum,(a.cantidad- (select SUM(cantidad) FROM recepbultos d WHERE d.idordtom = a.id)) canttot FROM receppedidosdetdet a ;
	INNER JOIN receppedidosdet b ON b.id = a.idrecpedde AND b.porcant > 0 ;
	inner join receppedidos c on c.id = b.idrecped ;
	order by c.ornum asc

*!*	STORE "" to dis
*!*	FOR x = 2 TO 18 
*!*		dis = ALLTRIM(STR(x))+"/18"
*!*		INSERT INTO bc (idordtom,nbulto,cantidad,bulto,modi) VALUES (1074,dis,2100,x,0)
*!*	next
*!*		