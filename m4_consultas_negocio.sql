-- =============================================================================
-- PROYECTO: RetailPro / TechStore - Pre-entrega M4
-- CURSO: Data Analytics - CoderHouse
-- ESTUDIANTE: Nicolás Meritano
-- MOTOR UTILIZADO: MySQL 8.0+
-- ARCHIVO: m4_consultas_negocio.sql
-- DESCRIPCIÓN: Consultas de agregación, métricas ejecutivas y hallazgos
--              estratégicos sobre la tabla 'ventas'.
-- =============================================================================

USE Ventas_Tech_DB;

-- =============================================================================
-- CONSULTA 1: Resumen ejecutivo mensual
-- Métricas: Mes, facturación total, cantidad de pedidos y ticket promedio.
-- =============================================================================

SELECT 
    MONTH(fecha_venta) AS mes,
    SUM(cantidad * precio_unitario) AS total_facturado,
    COUNT(*) AS cantidad_pedidos,
    ROUND(AVG(cantidad * precio_unitario), 2) AS ticket_promedio
FROM ventas
GROUP BY MONTH(fecha_venta)
ORDER BY mes ASC;

-- =============================================================================
-- CONSULTA 2: Ranking Top 5 de productos por facturación
-- Métricas: id_producto, unidades vendidas (SUM) y total facturado.
-- Nota sintáctica MySQL: Se utiliza LIMIT 5 al final en lugar de TOP 5.
-- =============================================================================

SELECT 
    id_producto,
    SUM(cantidad) AS unidades_vendidas,
    SUM(cantidad * precio_unitario) AS total_facturado
FROM ventas
GROUP BY id_producto
ORDER BY total_facturado DESC
LIMIT 5;

-- =============================================================================
-- CONSULTA 3: Clientes recurrentes
-- Métricas: Clientes con más de un pedido, volumen de compras y gasto total.
-- =============================================================================

SELECT 
    id_cliente,
    COUNT(*) AS cantidad_pedidos,
    SUM(cantidad * precio_unitario) AS total_gastado
FROM ventas
GROUP BY id_cliente
HAVING COUNT(*) > 1
ORDER BY total_gastado DESC;

-- =============================================================================
-- CONSULTA 4: Meses por encima o por debajo del promedio mensual general
-- Compara la facturación de cada mes frente a la media mensual de toda la tabla.
-- =============================================================================

SELECT 
    mes_resumen.mes,
    mes_resumen.total_mes,
    CASE 
        WHEN mes_resumen.total_mes >= sub_promedio.promedio_general THEN 'Por encima'
        ELSE 'Por debajo'
    END AS clasificacion_vs_promedio
FROM (
    SELECT 
        MONTH(fecha_venta) AS mes,
        SUM(cantidad * precio_unitario) AS total_mes
    FROM ventas
    GROUP BY MONTH(fecha_venta)
) AS mes_resumen
CROSS JOIN (
    SELECT 
        AVG(total_mensual) AS promedio_general
    FROM (
        SELECT 
            SUM(cantidad * precio_unitario) AS total_mensual
        FROM ventas
        GROUP BY MONTH(fecha_venta)
    ) AS mensualidades
) AS sub_promedio
ORDER BY mes_resumen.mes ASC;

-- =============================================================================
-- BLOQUE DE CIERRE: Hallazgos analíticos y conclusiones de negocio
-- =============================================================================
/*
HALLAZGOS CONCRETOS DE NEGOCIO:

1. Concentración de facturación en el Producto 1:
   El producto con id_producto = 1 ('Laptop Pro 15') lidera ampliamente el 
   ranking de facturación con $3,600.00 recaudados en solo 3 unidades vendidas, 
   lo que representa más del 65% de la facturación global de los 10 registros.

2. Alta fidelidad en el segmento de Clientes Recurrentes:
   Los clientes con id_cliente 1, 2, 3, 4 y 5 poseen exactamente 2 órdenes 
   cada uno (100% de la cartera tiene recompra). Sin embargo, el cliente 1 
   concentra el ticket más elevado ($2,640.00) gracias a la compra de equipos 
   de alta gama.

3. Estabilidad y distribución temporal del volumen:
   Las 10 transacciones del dataset están distribuidas a lo largo del mes 3 (marzo),
   alcanzando un ticket promedio por transacción de $542.90, marcando una fuerte
   dependencia de artículos del rubro computación frente a accesorios de bajo importe 
   (como el id_producto 2 con 13 unidades pero solo $364.00 recaudados).
*/