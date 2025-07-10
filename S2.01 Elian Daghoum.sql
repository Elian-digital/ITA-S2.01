-- Nivel 01

-- 2) Utilizando JOIN realizarás las siguientes consultas:

-- Listado de los países que están generando ventas.

SELECT c.country AS 'Paises con ventas'
FROM  company c
JOIN transaction t ON c.id = t.company_id
WHERE t.declined = 0
GROUP BY c.country;

-- Desde cuántos países se generan las ventas.

SELECT COUNT(DISTINCT(c.country)) AS 'Cantidad de paises que generan ventas'
FROM  company c
JOIN transaction t ON c.id = t.company_id
WHERE t.declined = 0;

-- Identifica la compañía con la mayor media de ventas.

SELECT c.id, c.company_name AS 'Compañía con más ventas', ROUND(AVG(t.amount),2) AS 'Media de ventas'
FROM  company c
JOIN transaction t ON c.id = t.company_id
WHERE t.declined = 0
GROUP BY t.company_id
ORDER BY AVG(t.amount)DESC LIMIT 1;

-- 3) Utilizando sólo subconsultas (sin utilizar JOIN):
-- Muestra todas las transacciones realizadas por empresas de Alemania.

SELECT *
FROM transaction
WHERE company_id IN (
    SELECT id
    FROM company
    WHERE country = 'germany'  
    ) AND declined = 0
;

-- Lista las empresas que han realizado transacciones por un amount superior a la media de todas las transacciones.

SELECT c.company_name AS Empresa, MAX(t.amount) AS Venta_mas_alta
FROM transaction t
JOIN company c ON t.company_id = c.id
WHERE t.amount > (
  SELECT AVG(amount)
  FROM transaction
) AND t.declined = 0
GROUP BY c.company_name
ORDER BY Venta_mas_alta DESC;


-- Eliminarán del sistema las empresas que no tienen transacciones registradas, entrega el listado de estas empresas

SELECT c.company_name
FROM company c
WHERE c.id NOT IN 
(SELECT t.company_id
FROM transaction t
);

-- Nivel 02
-- 1) Identifica los cinco días que se generó la mayor cantidad de ingresos en la empresa por ventas. 
-- Muestra la fecha de cada transacción junto con el total de las ventas.

SELECT DATE(timestamp) AS fecha, COUNT(amount) AS total_ventas, SUM(amount) AS Beneficios
FROM transaction
WHERE declined = 0
GROUP BY fecha
ORDER BY Beneficios DESC LIMIT 5;

-- 2) ¿Cuál es el promedio de ventas por país? Presenta los resultados ordenados de mayor a menor medio.

SELECT c.country AS País, ROUND(AVG(t.amount),2) AS gasto_promedio
FROM company c
JOIN transaction t ON c.id = t.company_id
WHERE t.declined = 0
GROUP BY c.country
ORDER BY gasto_promedio DESC;

-- 3 Muestra la lista de todas las transacciones realizadas por empresas que están situadas en el mismo país que Non Institute.
-- Muestra el listado aplicando JOIN y subconsultas.

SELECT *
FROM transaction t
JOIN company c ON t.company_id = c.id 
WHERE country IN (
    Select country
    FROM company
    Where company_name =  "Non Institute"
    ) AND (c.company_name != "Non Institute") 
      AND t.declined = 0 ;

-- Muestra el listado aplicando solamente subconsultas.

SELECT *
FROM transaction
WHERE company_id IN (
  SELECT id
  FROM company
  WHERE COUNTRY IN (
    Select country
    FROM company
    Where company_name =  "Non Institute")
    AND company_name != "Non Institute"
    AND declined = 0
   
); 

-- Nivel 03
-- 1) Presenta el nombre, teléfono, país, fecha y amount, de empresas 
-- con transacciones entre 350 y 400 euros ordenadas DESC
-- con fechas '2015-04-29', '2018-07-20', '2024-03-13'

SELECT c.company_name, c.phone, c.country, DATE(t.timestamp) AS fecha, t.amount AS Ganancias
FROM company c
JOIN transaction t ON c.id = t.company_id
WHERE t.amount BETWEEN 350 AND 400
AND DATE(t.timestamp) IN ('2015-04-29', '2018-07-20', '2024-03-13')
ORDER BY Ganancias DESC
;

-- 2) Crea un listado de todas las empresas, 
-- indica cuántas transacciones ha realizado cada una
-- especifica si tiene más o menos de 400 transacciones.

SELECT c.company_name AS Empresa, COUNT(t.amount) AS Transacciones,
CASE 
    WHEN COUNT(t.amount) >= 400 THEN 'SI'
    ELSE 'NO'
  END AS 'Más de 400'
FROM company c
JOIN transaction t ON c.id = t.company_id
GROUP BY c.company_name
;