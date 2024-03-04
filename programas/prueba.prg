USE receppedidosdet
USE receppedidosdetdet
SELECT * FROM (SELECT d.idorden,d.sinc,(select SUM(cantp) FROM receppedidosdetdet as r WHERE r.idorde  FROM receppedidosdet as d WHERE exists ( select SUM(cantp) FROM 

SELECT * FROM (select r.idorden,r.orden,r.porcant,;
(select sum(cantidad) from receppedidosdetdet as d where d.idorden = r.idorden) sumcant,r.sinc from receppedidosdet as r) as tb;
WHERE tb.sinc = 0 AND tb.sumcant > 0

INNER JOIN receppedidosdetdet as r ON r.idorden = d.idorden