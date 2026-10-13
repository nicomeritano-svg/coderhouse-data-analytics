-- =============================================================================
-- PROYECTO: Ventas_Tech_DB
-- CURSO: Data Analytics - CoderHouse
-- ESTUDIANTE: Nicolás Meritano
-- MOTOR UTILIZADO: MySQL 8.0+
-- ARCHIVO: ventas_tech_db.sql
-- DESCRIPCIÓN: Script DDL y DML para la creación, población y validación
--              de la base de datos relacional de TechStore (RetailPro).
-- =============================================================================

-- Creación y selección de la base de datos
CREATE DATABASE IF NOT EXISTS Ventas_Tech_DB;
USE Ventas_Tech_DB;

-- =============================================================================
-- SECCIÓN 1: DROP TABLES
-- Se eliminan las tablas en orden inverso a sus dependencias referenciales
-- para evitar errores de Foreign Key y asegurar la repetibilidad del script.
-- =============================================================================

DROP TABLE IF EXISTS ventas;
DROP TABLE IF EXISTS productos;
DROP TABLE IF EXISTS clientes;
DROP TABLE IF EXISTS categorias;

-- =============================================================================
-- SECCIÓN 2: CREATE TABLES
-- Se crean las tablas respetando la normalización 3NF y restricciones estrictas.
-- Orden: Dimensiones independientes primero, luego dimensiones con dependencias
-- y finalmente la tabla de hechos.
-- =============================================================================

-- 1. Dimensión: categorias
CREATE TABLE categorias (
    id_categoria INT NOT NULL,
    nombre_categoria VARCHAR(50) NOT NULL,
    descripcion VARCHAR(200) NULL,
    CONSTRAINT pk_categorias PRIMARY KEY (id_categoria)
) ENGINE=InnoDB;

-- 2. Dimensión: clientes
CREATE TABLE clientes (
    id_cliente INT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    ciudad VARCHAR(50) NULL,
    fecha_registro DATE NOT NULL,
    CONSTRAINT pk_clientes PRIMARY KEY (id_cliente),
    CONSTRAINT uq_clientes_email UNIQUE (email)
) ENGINE=InnoDB;

-- 3. Dimensión: productos
-- Nota sintáctica MySQL: booleano modelado con TINYINT(1) DEFAULT 1
CREATE TABLE productos (
    id_producto INT NOT NULL,
    nombre_producto VARCHAR(100) NOT NULL,
    id_categoria INT NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL DEFAULT 0,
    activo TINYINT(1) NOT NULL DEFAULT 1,
    CONSTRAINT pk_productos PRIMARY KEY (id_producto),
    CONSTRAINT fk_productos_categorias FOREIGN KEY (id_categoria)
        REFERENCES categorias (id_categoria)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- 4. Tabla de hechos: ventas
CREATE TABLE ventas (
    id_venta INT NOT NULL,
    id_cliente INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    fecha_venta DATE NOT NULL,
    CONSTRAINT pk_ventas PRIMARY KEY (id_venta),
    CONSTRAINT fk_ventas_clientes FOREIGN KEY (id_cliente)
        REFERENCES clientes (id_cliente)
        ON UPDATE CASCADE
        ON DELETE RESTRICT,
    CONSTRAINT fk_ventas_productos FOREIGN KEY (id_producto)
        REFERENCES productos (id_producto)
        ON UPDATE CASCADE
        ON DELETE RESTRICT
) ENGINE=InnoDB;

-- =============================================================================
-- SECCIÓN 3: INSERT DATA
-- Carga exacta de los 25 registros en orden estricto de integridad referencial.
-- =============================================================================

-- Carga en categorias (4 registros)
INSERT INTO categorias (id_categoria, nombre_categoria, descripcion) VALUES
  (1, 'Computación',    'Laptops, PCs y monitores'),
  (2, 'Accesorios',     'Periféricos y complementos'),
  (3, 'Audio',          'Auriculares y parlantes'),
  (4, 'Almacenamiento', 'Discos y memorias');

-- Carga en clientes (5 registros)
INSERT INTO clientes (id_cliente, nombre, email, ciudad, fecha_registro) VALUES
  (1, 'María López',  'maria@mail.com',  'Buenos Aires', '2024-01-05'),
  (2, 'Carlos Ruiz',  'carlos@mail.com', 'Córdoba',      '2024-01-10'),
  (3, 'Ana Gómez',    'ana@mail.com',    'Rosario',      '2024-02-01'),
  (4, 'Pedro Sanz',   'pedro@mail.com',  'Mendoza',      '2024-02-15'),
  (5, 'Laura Torres', 'laura@mail.com',  'Tucumán',      '2024-03-01');

-- Carga en productos (6 registros)
INSERT INTO productos (id_producto, nombre_producto, id_categoria, precio, stock, activo) VALUES
  (1, 'Laptop Pro 15',      1, 1200.00, 15, 1),
  (2, 'Mouse Inalámbrico',  2,   28.00, 80, 1),
  (3, 'Monitor 4K 27',      1,  450.00, 12, 1),
  (4, 'Auriculares BT Pro', 3,  120.00, 35, 1),
  (5, 'SSD Externo 1TB',    4,  130.00, 18, 1),
  (6, 'Teclado Mecánico',   2,   95.00, 40, 1);

-- Carga en ventas (10 registros)
INSERT INTO ventas (id_venta, id_cliente, id_producto, cantidad, precio_unitario, fecha_venta) VALUES
  ( 1, 1, 1, 2, 1200.00, '2024-03-05'),
  ( 2, 2, 2, 5,   28.00, '2024-03-06'),
  ( 3, 3, 3, 1,  450.00, '2024-03-07'),
  ( 4, 1, 4, 2,  120.00, '2024-03-08'),
  ( 5, 4, 5, 3,  130.00, '2024-03-10'),
  ( 6, 2, 6, 4,   95.00, '2024-03-11'),
  ( 7, 5, 1, 1, 1200.00, '2024-03-12'),
  ( 8, 3, 2, 8,   28.00, '2024-03-13'),
  ( 9, 4, 4, 1,  120.00, '2024-03-14'),
  (10, 5, 3, 2,  450.00, '2024-03-15');

-- =============================================================================
-- SECCIÓN 4: VALIDACIÓN
-- Consultas de verificación para confirmar la carga íntegra.
-- =============================================================================

SELECT * FROM categorias;   -- Filas esperadas: 4
SELECT * FROM clientes;     -- Filas esperadas: 5
SELECT * FROM productos;    -- Filas esperadas: 6
SELECT * FROM ventas;       -- Filas esperadas: 10