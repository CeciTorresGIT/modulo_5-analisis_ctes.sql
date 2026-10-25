-- 1. Conectarse a la base de datos del ejercicio
-- Ejecutar este comando en psql si fuera necesario:
-- \c analisis_ventas_argentina

-- 2. Calcular el total de ventas por provincia
with ventas_por_region as (
    select
        r.nombre_region,
        sum(v.cantidad * v.precio_unitario) as total_ventas
    from ventas as v
    inner join clientes as c
        on v.id_cliente = c.id_cliente
    inner join regiones as r
        on c.region_id = r.region_id
    inner join productos as p
        on v.id_producto = p.id_producto
    group by r.nombre_region
)

-- 3. Mostrar las provincias cuyo total supera el promedio
select
    nombre_region,
    total_ventas
from ventas_por_region
where total_ventas > (
    select avg(total_ventas)
    from ventas_por_region
)

-- 4. Ordenar de mayor a menor total de ventas
order by total_ventas desc;
