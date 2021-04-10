-- crear tabla de datos
CREATE DATABASE prueba;
\c prueba;

-- crear tabla clientes
CREATE TABLE clientes(id SERIAL, nombre VARCHAR(30) NOT NULL, rut VARCHAR(15) NOT NULL, direccion VARCHAR (80), PRIMARY KEY(id));

--crear tabla categoria
CREATE TABLE categorias(id SERIAL, nombre VARCHAR(50) NOT NULL, descripcion VARCHAR(200), PRIMARY KEY(id));

-- crear tabla facturas
CREATE TABLE facturas(id SERIAL, fecha DATE, subtotal INT, IVA INT, total INT, cliente_id SMALLINT, PRIMARY KEY(id), FOREIGN KEY(cliente_id) REFERENCES clientes(id));

-- crear tabla productos
CREATE TABLE productos(id SERIAL, nombre VARCHAR(80) NOT NULL, descripcion VARCHAR(100), costo_unit INT, categoria_id SMALLINT, PRIMARY KEY(id), FOREIGN KEY(categoria_id) REFERENCES categorias(id));

-- crear tabla facturas_productos
CREATE TABLE facturas_productos(id SERIAL, factura_id SMALLINT, producto_id SMALLINT, cant_comprada INT, total_producto INT, PRIMARY KEY(id), FOREIGN KEY(factura_id) REFERENCES facturas(id), FOREIGN KEY(producto_id) REFERENCES productos(id));

-- Insertando 5 clientes
INSERT INTO clientes(nombre,rut,direccion) VALUES ('Jose Perez','26.123.524-4', 'Valparaiso'), ('Andres Dominguez','18.391.192-9','Concepcion'),('Juan Guaido','12.381.092-3','Punta Arenas'),('Lorenzo Mendoza','19.182.098-1','Antofagasta'),('Ronaldhino Gaucho','8.192.749-K','Zurich');

-- Insertando categorias de productos
INSERT INTO categorias(nombre,descripcion) VALUES ('lacteos','contiene lacteos y derivados de ellos'),('carnes','cortes de carnes en varias presentaciones'),('cereales y granos','contiene distintos tipos de cada uno');

-- Insertando productos
INSERT INTO productos(nombre,descripcion,costo_unit,categoria_id) VALUES ('arroz','presentacion de 1kg',2,3),('leche','1 litro',15,1),('lentejas','1/2 kilo',12,3),('Rack costillas','rack entero',70,2),('Trutros','trutos pequenos',25,2),('porotos','1 kilo',8,3),('Mantequilla','800 gr',12,1),('Crema de leche','120gr',11,1);

-- Insertando facturas 
INSERT INTO facturas(fecha,cliente_id) VALUES ('2021-3-2',1),('2021-01-25',1),('2021-02-26',2),('2021-03-15',2),('2021-04-04',2),('2021-01-29',3),('2021-03-17',4),('2021-04-08',4),('2021-02-18',4),('2021-01-26',4);

--Insertando productos a facturas
INSERT INTO facturas_productos(factura_id,producto_id,cant_comprada,total_producto) VALUES (1,2,3,45),(1,5,1,25),(2,8,3,33),(2,7,3,36),(2,1,8,16),(3,6,3,24),(3,1,3,6),(3,7,2,24),(4,3,3,36),(4,2,1,15),(5,8,4,44),(5,5,2,50),(5,1,5,10),(6,4,2,140),(7,3,2,24),(7,8,1,11),(8,1,2,4),(8,1,3,6),(8,2,3,45),(9,1,3,6),(9,6,4,32),(9,7,3,36),(9,1,8,16),(10,4,1,70);

-- Haciendo un JOIN de las tres tablas para ver cuanto es el total por producto, por factura.
SELECT facturas.id, facturas_productos.producto_id, facturas_productos.cant_comprada,productos.costo_unit,(facturas_productos.cant_comprada*productos.costo_unit) AS total_productos FROM facturas JOIN facturas_productos ON facturas.id = facturas_productos.factura_id JOIN productos ON facturas_productos.producto_id = productos.id;

-- Colocando subtotal,IVA y total a cada factura

UPDATE facturas SET subtotal = 70,iva = 13 ,total = 83 WHERE id =1;
UPDATE facturas SET subtotal = 85,iva = 16 ,total = 101 WHERE id =2;
UPDATE facturas SET subtotal = 54,iva = 10 ,total = 64 WHERE id =3;
UPDATE facturas SET subtotal = 51,iva = 10 ,total = 61 WHERE id =4;
UPDATE facturas SET subtotal = 94,iva = 18 ,total = 112 WHERE id =5;
UPDATE facturas SET subtotal = 140,iva = 27 ,total = 167 WHERE id =6;
UPDATE facturas SET subtotal = 35,iva = 7 ,total = 42 WHERE id =7;
UPDATE facturas SET subtotal = 55,iva = 10 ,total = 65 WHERE id =8;
UPDATE facturas SET subtotal = 90,iva = 17 ,total = 107 WHERE id =9;
UPDATE facturas SET subtotal = 70,iva = 13 ,total = 83 WHERE id =10;

-- Seleccionando compra mas cara
SELECT clientes.nombre,facturas.total AS compra_maxima FROM clientes JOIN facturas ON clientes.id = facturas.cliente_id WHERE facturas.total = (SELECT MAX(total) FROM facturas); 

-- Seleccionando cliente con pago mayor a 100

SELECT clientes.nombre,facturas.total FROM clientes JOIN facturas ON clientes.id = facturas.cliente_id WHERE facturas.total > 100;

-- Clientes que compraron producto 6

SELECT COUNT(nombre) FROM clientes WHERE id IN (SELECT facturas.cliente_id FROM facturas JOIN facturas_productos ON facturas.id = facturas_productos.factura_id WHERE producto_id = 6);

