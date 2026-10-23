-- =============================================================================
-- PROYECTO: TechStore / RetailPro - Pre-entrega M5
-- CURSO: Data Analytics - CoderHouse
-- ESTUDIANTE: Nicolás Meritano
-- MOTOR UTILIZADO: MySQL 8.0+
-- ARCHIVO: m5_consultas_joins.sql
-- DESCRIPCIÓN: Consultas avanzadas con INNER JOIN, LEFT JOIN y UNION ALL
--              para consolidar la vista analítica del negocio.
-- =============================================================================

USE Ventas_Tech_DB;

-- -----------------------------------------------------------------------------
-- Registros adicionales de prueba (para verificar casos sin ventas en CRM y Producto)
-- -----------------------------------------------------------------------------
INSERT IGNORE INTO clientes (id_cliente, nombre, email, ciudad, fecha_registro) 
VALUES (6, 'Martín Silva', 'martin@mail.com', 'Rosario', '2024-03-20');

INSERT IGNORE INTO productos (id_producto, nombre_producto, id_categoria, precio, stock, activo) 
VALUES (7, 'Webcam HD 1080p', 2, 75.00, 25, 1);


-- =============================================================================
-- CONSULTA 1: Vista base del proyecto (INNER JOIN)
-- Propósito: Consolidar una vista analítica completa de las transacciones 
-- combinando hechos y dimensiones (clientes, productos y categorías) para Power BI.
-- =============================================================================

SELECT 
    v.id_venta,
    v.fecha_venta,
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.ciudad,
    p.nombre_producto,
    cat.nombre_categoria,
    v.cantidad,
    v.precio_unitario,
    (v.cantidad * v.precio_unitario) AS total_venta
FROM ventas AS v
INNER JOIN clientes AS c 
    ON v.id_cliente = c.id_cliente
INNER JOIN productos AS p 
    ON v.id_producto = p.id_producto
INNER JOIN categorias AS cat 
    ON p.id_categoria = cat.id_categoria
ORDER BY v.fecha_venta ASC;

-- Hallazgo: El cruce evidencia que las transacciones de mayor volumen económico corresponden a la categoría 'Computación' (Laptop Pro 15), comercializadas a clientes de Buenos Aires y Tucumán, mientras que 'Accesorios' concentra la mayor frecuencia transaccional.


-- =============================================================================
-- CONSULTA 2: Clientes sin ventas (LEFT JOIN)
-- Propósito: Identificar clientes registrados en la base de datos que aún no 
-- concretaron compras para que el equipo de CRM active campañas de bienvenida.
-- =============================================================================

SELECT 
    c.id_cliente,
    c.nombre AS nombre_cliente,
    c.email,
    c.fecha_registro
FROM clientes AS c
LEFT JOIN ventas AS v 
    ON c.id_cliente = v.id_cliente
WHERE v.id_venta IS NULL;

-- Hallazgo: 1 de los 6 clientes registrados ('Martín Silva', dado de alta el 20/03) no registra órdenes de compra; CRM debe disparar una campaña con cupón de primera compra para incentivar su conversión.


-- =============================================================================
-- CONSULTA 3: Productos sin ventas (LEFT JOIN)
-- Propósito: Identificar artículos del catálogo activo sin movimiento transaccional 
-- para que el área de producto evalúe visibilidad, precio o rotación de stock.
-- =============================================================================

SELECT 
    p.id_producto,
    p.nombre_producto,
    cat.nombre_categoria,
    p.precio,
    p.stock
FROM productos AS p
INNER JOIN categorias AS cat 
    ON p.id_categoria = cat.id_categoria
LEFT JOIN ventas AS v 
    ON p.id_producto = v.id_producto
WHERE v.id_venta IS NULL;

-- Hallazgo: El artículo 'Webcam HD 1080p' (Accesorios, $75.00 con 25 unidades en inventario) no posee transacciones asociadas; el área de producto debe evaluar promociones cruzadas o combos con laptops para evitar stock inmovilizado.


-- =============================================================================
-- CONSULTA 4: Consolidado por canal (UNION ALL)
-- Propósito: Unificar y totalizar las ventas segmentadas por canal de origen 
-- ('Online' vs 'Presencial') mediante valores literales en subconsultas apiladas.
-- Criterio aplicado: Ventas de primera quincena (hasta el 10/03) asignadas a 'Online'
-- y ventas posteriores (desde el 11/03) asignadas a 'Presencial'.
-- =============================================================================

SELECT 
    consolidado.canal,
    COUNT(*) AS cantidad_pedidos,
    SUM(consolidado.total) AS total_canal
FROM (
    SELECT 
        fecha_venta,
        (cantidad * precio_unitario) AS total,
        'Online' AS canal
    FROM ventas
    WHERE fecha_venta <= '2024-03-10'

    UNION ALL

    SELECT 
        fecha_venta,
        (cantidad * precio_unitario) AS total,
        'Presencial' AS canal
    FROM ventas
    WHERE fecha_venta > '2024-03-10'
) AS consolidado
GROUP BY consolidado.canal
ORDER BY total_canal DESC;

-- Hallazgo: El canal 'Online' concentró la mayor facturación ($3,180.00 en 5 operaciones) frente a 'Presencial' ($2,249.00 en 5 operaciones), señalando una mayor predisposición a comprar artículos de mayor ticket en plataformas digitales.