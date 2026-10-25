create database analisis_ventas_argentina;

-- 1. Crear la tabla de regiones (provincias argentinas)
create table regiones (
    region_id serial primary key,
    nombre_region varchar(100) not null unique
);

-- 2. Insertar las provincias argentinas
insert into regiones (nombre_region) values
('Buenos Aires'),
('Catamarca'),
('Chaco'),
('Chubut'),
('Córdoba'),
('Corrientes'),
('Entre Ríos'),
('Formosa'),
('Jujuy'),
('La Pampa'),
('La Rioja'),
('Mendoza'),
('Misiones'),
('Neuquén'),
('Río Negro'),
('Salta'),
('San Juan'),
('San Luis'),
('Santa Cruz'),
('Santa Fe'),
('Santiago del Estero'),
('Tierra del Fuego'),
('Tucumán'),
('Ciudad Autónoma de Buenos Aires');

-- 3. Crear la tabla de clientes
create table clientes (
    id_cliente serial primary key,
    nombre varchar(100) not null,
    email varchar(150) unique,
    edad integer,
    region_id integer references regiones(region_id)
);

-- 4. Crear la tabla de productos
create table productos (
    id_producto serial primary key,
    nombre_producto varchar(100) not null,
    categoria varchar(50),
    precio numeric(10,2) not null
);

-- 5. Crear la tabla de ventas
create table ventas (
    id_venta serial primary key,
    id_cliente integer not null references clientes(id_cliente),
    id_producto integer not null references productos(id_producto),
    cantidad integer not null,
    precio_unitario numeric(10,2) not null,
    fecha_venta date not null
);

-- 6. Insertar clientes de ejemplo
insert into clientes (nombre, email, edad, region_id) values
('Pedro', 'pedro@email.com', 32, (select region_id from regiones where nombre_region = 'Neuquén')),
('María', 'maria@email.com', 28, (select region_id from regiones where nombre_region = 'Río Negro')),
('Juan', 'juan@email.com', 45, (select region_id from regiones where nombre_region = 'Chubut')),
('Lucía', 'lucia@email.com', 36, (select region_id from regiones where nombre_region = 'Santa Cruz')),
('Sofía', 'sofia@email.com', 25, (select region_id from regiones where nombre_region = 'Tierra del Fuego')),
('Martín', 'martin@email.com', 40, (select region_id from regiones where nombre_region = 'Neuquén'));

-- 7. Insertar productos de ejemplo
insert into productos (nombre_producto, categoria, precio) values
('Notebook', 'Informática', 850000),
('Celular', 'Telefonía', 450000),
('Teclado', 'Accesorios', 45000),
('Monitor', 'Informática', 280000),
('Mouse', 'Accesorios', 25000);

-- 8. Insertar ventas de ejemplo
insert into ventas (id_cliente, id_producto, cantidad, precio_unitario, fecha_venta) values
(1, 1, 2, 850000, '2026-01-10'),
(1, 3, 3, 45000, '2026-01-15'),
(2, 2, 2, 450000, '2026-01-20'),
(2, 5, 4, 25000, '2026-02-02'),
(3, 4, 3, 280000, '2026-02-08'),
(3, 3, 2, 45000, '2026-02-12'),
(4, 1, 1, 850000, '2026-02-18'),
(4, 5, 5, 25000, '2026-02-21'),
(5, 2, 1, 450000, '2026-03-01'),
(5, 4, 2, 280000, '2026-03-05'),
(6, 1, 1, 850000, '2026-03-10'),
(6, 2, 1, 450000, '2026-03-15');

-- 9. Verificar las provincias insertadas
select * from regiones;

-- 10. Verificar los clientes y sus provincias
select
    c.id_cliente,
    c.nombre,
    c.email,
    r.nombre_region
from clientes as c
inner join regiones as r
    on c.region_id = r.region_id;

-- 11. Verificar las ventas registradas
select * from ventas;


-- 1. Crear una CTE con el total de ventas por provincia
with ventas_por_region as (
    select
        r.nombre_region,
        sum(v.cantidad * v.precio_unitario) as total_ventas
    from ventas as v
    inner join clientes as c
        on v.id_cliente = c.id_cliente
    inner join regiones as r
        on c.region_id = r.region_id
    group by r.nombre_region
)

-- 2. Filtrar las provincias cuyo total supera el promedio general
select
    nombre_region,
    total_ventas
from ventas_por_region
where total_ventas > (
    select avg(cantidad * precio_unitario)
    from ventas
)

-- 3. Ordenar los resultados de mayor a menor
order by total_ventas desc;
