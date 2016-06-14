USE GD2C2015;
CREATE SCHEMA [NEPAirlines]
GO
--Drop de tablas si ya existen
IF OBJECT_ID('NEPAIRLINES.TransaccionMillas', 'U') IS NOT NULL
		DROP TABLE NEPAIRLINES.TransaccionMillas;
IF OBJECT_ID('NEPAIRLINES.ProductoCanje', 'U') IS NOT NULL
		DROP TABLE NEPAIRLINES.ProductoCanje;
IF OBJECT_ID('NEPAIRLINES.Cancelacion', 'U') IS NOT NULL
		DROP TABLE NEPAIRLINES.Cancelacion;
IF OBJECT_ID('NEPAIRLINES.Pago', 'U') IS NOT NULL
		DROP TABLE NEPAIRLINES.Pago;
IF OBJECT_ID('NEPAIRLINES.Encomienda', 'U') IS NOT NULL
		DROP TABLE NEPAIRLINES.Encomienda;
IF OBJECT_ID('NEPAIRLINES.Pasaje', 'U') IS NOT NULL
		DROP TABLE NEPAIRLINES.Pasaje;
IF OBJECT_ID('NEPAIRLINES.Viaje', 'U') IS NOT NULL
		DROP TABLE NEPAIRLINES.Viaje;
IF OBJECT_ID('NEPAIRLINES.Butaca', 'U') IS NOT NULL
		DROP TABLE NEPAIRLINES.Butaca;
IF OBJECT_ID('NEPAIRLINES.TipoButaca', 'U') IS NOT NULL
		DROP TABLE NEPAIRLINES.TipoButaca;
IF OBJECT_ID('NEPAIRLINES.Aeronave', 'U') IS NOT NULL
		DROP TABLE NEPAIRLINES.Aeronave;
IF OBJECT_ID('NEPAIRLINES.Modelo', 'U') IS NOT NULL
		DROP TABLE NEPAIRLINES.Modelo;
IF OBJECT_ID('NEPAIRLINES.Fabricante', 'U') IS NOT NULL
		DROP TABLE NEPAIRLINES.Fabricante;
IF OBJECT_ID('NEPAIRLINES.Ruta', 'U') IS NOT NULL
		DROP TABLE NEPAIRLINES.Ruta;
IF OBJECT_ID('NEPAIRLINES.Servicio', 'U') IS NOT NULL
		DROP TABLE NEPAIRLINES.Servicio;
IF OBJECT_ID('NEPAIRLINES.Ciudad', 'U') IS NOT NULL
		DROP TABLE NEPAIRLINES.Ciudad;
IF OBJECT_ID('NEPAIRLINES.Cliente', 'U') IS NOT NULL
		DROP TABLE NEPAIRLINES.Cliente;
IF OBJECT_ID('NEPAIRLINES.Usuario', 'U') IS NOT NULL
		DROP TABLE NEPAIRLINES.Usuario;
IF OBJECT_ID('NEPAIRLINES.RolFuncionalidad', 'U') IS NOT NULL
		DROP TABLE NEPAIRLINES.RolFuncionalidad;
IF OBJECT_ID('NEPAIRLINES.Funcionalidad', 'U') IS NOT NULL
		DROP TABLE NEPAIRLINES.Funcionalidad;
IF OBJECT_ID('NEPAIRLINES.Rol', 'U') IS NOT NULL
		DROP TABLE NEPAIRLINES.Rol;
GO

--Creación de tablas
CREATE TABLE NEPAIRLINES.Rol
(
		IdRol			int IDENTITY(1,1) PRIMARY KEY,
		Nombre			nvarchar(255) NOT NULL,
		EstaHabilitado	bit NOT NULL
);


CREATE TABLE NEPAIRLINES.Usuario
(
		IdUsuario		int IDENTITY(1,1) PRIMARY KEY,
		Nombre			nvarchar(255) UNIQUE NOT NULL,
		Clave			varbinary(4000) NOT NULL,
		EstaHabilitado	bit NOT NULL,		
		IdRol			int NOT NULL,
		LoginFallidos int NOT NULL DEFAULT 0,
		CONSTRAINT FK_Usuario_Rol FOREIGN KEY (IdRol) REFERENCES NEPAIRLINES.Rol (IdRol)
);


CREATE TABLE NEPAIRLINES.Funcionalidad
(
		IdFuncionalidad	int IDENTITY(1,1) PRIMARY KEY,
		Nombre			nvarchar(255) NOT NULL
);


CREATE TABLE NEPAIRLINES.RolFuncionalidad
(
		IdRol			int,
		IdFuncionalidad	int,
		TienePermisos	bit NOT NULL,
		CONSTRAINT FK_RolFuncionalidad_Rol FOREIGN KEY (IdRol) REFERENCES NEPAIRLINES.Rol (IdRol),
		CONSTRAINT FK_RolFuncionalidad_Funcionalidad FOREIGN KEY (IdFuncionalidad) REFERENCES NEPAIRLINES.Funcionalidad (IdFuncionalidad),
		PRIMARY KEY (IdRol, IdFuncionalidad)
);


CREATE TABLE NEPAIRLINES.Cliente
(
		IdCliente		int IDENTITY(1,1) PRIMARY KEY,
		Nombre			nvarchar(255) NOT NULL,
		Apellido		nvarchar(255) NOT NULL,
		Dni				numeric(18,0) NOT NULL,
		FechaNac		date NOT NULL,
		Dir				nvarchar(255) NOT NULL,
		Telefono		numeric(18,0) NOT NULL,
		Mail			nvarchar(255)
);


CREATE TABLE NEPAIRLINES.Servicio
(
		IdServicio		int IDENTITY(1,1) PRIMARY KEY,
		Nombre			nvarchar(255)
);


CREATE TABLE NEPAIRLINES.Ciudad
(
		IdCiudad		int IDENTITY(1,1) PRIMARY KEY,
		Nombre			nvarchar(255) NOT NULL,
		EstaHabilitada	bit NOT NULL
);


CREATE TABLE NEPAIRLINES.Ruta
(
		IdRuta			int IDENTITY(1,1) PRIMARY KEY,
		Codigo			numeric(18,0) NOT NULL,
		IdServicio		int NOT NULL,
		IdCiudadOrigen	int NOT NULL,
		IdCiudadDestino int NOT NULL,
		EstaHabilitada	bit NOT NULL,
		PrecioBaseKg	numeric(18,2),
		PrecioBasePasaje numeric(18,2),
		CONSTRAINT FK_Ruta_Servicio FOREIGN KEY (IdServicio) REFERENCES NEPAIRLINES.Servicio (IdServicio),
		CONSTRAINT FK_Ruta_Ciudad_Origen FOREIGN KEY (IdCiudadOrigen) REFERENCES NEPAIRLINES.Ciudad (IdCiudad),
		CONSTRAINT FK_Ruta_Ciudad_Destino FOREIGN KEY (IdCiudadDestino) REFERENCES NEPAIRLINES.Ciudad (IdCiudad)
);


CREATE TABLE NEPAIRLINES.Fabricante
(
		IdFabricante	int IDENTITY(1,1) PRIMARY KEY,
		Nombre			nvarchar(255) NOT NULL
);


CREATE TABLE NEPAIRLINES.Modelo
(
		IdModelo		int IDENTITY(1,1) PRIMARY KEY,
		Nombre			nvarchar(255) NOT NULL,
		IdFabricante	int NOT NULL,
		CONSTRAINT FK_Modelo_Fabricante FOREIGN KEY (IdFabricante) REFERENCES NEPAIRLINES.Fabricante (IdFabricante)
);


CREATE TABLE NEPAIRLINES.Aeronave
(
		IdAeronave		int IDENTITY(1,1) PRIMARY KEY,
		Matricula		nvarchar(255) UNIQUE NOT NULL,
		IdModelo		int NOT NULL,
		IdServicio		int NOT NULL,
		KgDisponibles	numeric(18,0) NOT NULL,
		Estado			int NOT NULL, --0 para Inactiva, 1 para Fuera de Servicio, 2 para Activa
		FechaInicio		datetime,
		FechaFin		datetime,
		FechaAlta		datetime,
		CONSTRAINT FK_Aeronave_Modelo FOREIGN KEY (IdModelo) REFERENCES NEPAIRLINES.Modelo (IdModelo),
		CONSTRAINT FK_Aeronave_Servicio FOREIGN KEY (IdServicio) REFERENCES NEPAIRLINES.Servicio (IdServicio)
);


CREATE TABLE NEPAIRLINES.Viaje
(
		IdViaje			int IDENTITY(1,1) PRIMARY KEY,
		IdRuta			int NOT NULL,
		IdAeronave		int NOT NULL,
		FechaSalida		datetime NOT NULL,
		FechaLlegada	datetime,
		FechaEstimada	datetime,
		CONSTRAINT FK_Viaje_Ruta FOREIGN KEY (IdRuta) REFERENCES NEPAIRLINES.Ruta (IdRuta),
		CONSTRAINT FK_Viaje_Aeronave FOREIGN KEY (IdAeronave) REFERENCES NEPAIRLINES.Aeronave (IdAeronave)
);


CREATE TABLE NEPAIRLINES.TipoButaca
(
		IdTipoButaca	int IDENTITY(1,1) PRIMARY KEY,
		Nombre			nvarchar(255) UNIQUE NOT NULL
);


CREATE TABLE NEPAIRLINES.Butaca
(
		IdButaca		int IDENTITY(1,1) PRIMARY KEY,
		IdAeronave		int NOT NULL,
		Nro				numeric(18,0) NOT NULL,
		IdTipoButaca	int NOT NULL,
		Piso			numeric(18,0) NOT NULL,
		CONSTRAINT FK_Butaca_Aeronave FOREIGN KEY (IdAeronave) REFERENCES NEPAIRLINES.Aeronave (IdAeronave),
		CONSTRAINT FK_Butaca_TipoButaca FOREIGN KEY (IdTipoButaca) REFERENCES NEPAIRLINES.TipoButaca (IdTipoButaca)
);


CREATE TABLE NEPAIRLINES.Pasaje
(
		IdPasaje		int IDENTITY(1,1) PRIMARY KEY,
		IdCliente		int NOT NULL,
		Codigo			numeric(18,0) NOT NULL,
		Precio			numeric(18,2) NOT NULL,
		FechaCompra		datetime NOT NULL,
		IdViaje			int NOT NULL,
		IdButaca		int NOT NULL,
		CONSTRAINT FK_Pasaje_Cliente FOREIGN KEY (IdCliente) REFERENCES NEPAIRLINES.Cliente (IdCliente),
		CONSTRAINT FK_Pasaje_Viaje FOREIGN KEY (IdViaje) REFERENCES NEPAIRLINES.Viaje (IdViaje),
		CONSTRAINT FK_Pasaje_Butaca FOREIGN KEY (IdButaca) REFERENCES NEPAIRLINES.Butaca (IdButaca)
);


CREATE TABLE NEPAIRLINES.Encomienda
(
		IdEncomienda	int IDENTITY(1,1) PRIMARY KEY,
		IdCliente		int NOT NULL,
		Codigo			numeric(18,0) NOT NULL,
		Precio			numeric(18,2) NOT NULL,
		Kg				numeric(18,2) NOT NULL,
		FechaCompra		datetime NOT NULL,
		IdViaje			int NOT NULL,
		CONSTRAINT FK_Encomienda_Cliente FOREIGN KEY (IdCliente) REFERENCES NEPAIRLINES.Cliente (IdCliente),
		CONSTRAINT FK_Encomienda_Viaje FOREIGN KEY (IdViaje) REFERENCES NEPAIRLINES.Viaje (IdViaje)
);


CREATE TABLE NEPAIRLINES.Pago
(
		IdPago			int IDENTITY(1,1) PRIMARY KEY,
		IdPasaje		int, --NULL si se está pagando una encomienda
		IdEncomienda	int, --NULL si se está pagando un pasaje
		MedioPago		nvarchar(255) NOT NULL, --E para efectivo, TD para tarjeta de débito, TC para tarjeta de crédito
		Nro				numeric(16,0),
		CodSeguridad	numeric(3,0),
		FechaVenc		nvarchar(255),
		Dni				numeric(18,0),
		Cuotas			int,
		CONSTRAINT FK_Pago_Pasaje FOREIGN KEY (IdPasaje) REFERENCES NEPAIRLINES.Pasaje (IdPasaje),
		CONSTRAINT FK_Pago_Encomienda FOREIGN KEY (IdEncomienda) REFERENCES NEPAIRLINES.Encomienda (IdEncomienda)
);


CREATE TABLE NEPAIRLINES.Cancelacion
(
		IdCancelacion	int IDENTITY(1,1) PRIMARY KEY,
		IdPago			int NOT NULL,
		Fecha			datetime NOT NULL,
		Motivo			nvarchar(4000) NOT NULL
		CONSTRAINT FK_Cancelacion_Pago FOREIGN KEY (IdPago) REFERENCES NEPAIRLINES.Pago (IdPago)
);


CREATE TABLE NEPAIRLINES.ProductoCanje
(
		IdProducto		int IDENTITY(1,1) PRIMARY KEY,
		Nombre			nvarchar(255) NOT NULL,
		CantMillas		int NOT NULL,
		Stock			int NOT NULL,
);


CREATE TABLE NEPAIRLINES.TransaccionMillas
(
		IdTransaccion	int IDENTITY(1,1) PRIMARY KEY,
		IdCliente		int NOT NULL, 
		IdViaje			int DEFAULT NULL, --NULL si Movito == Canje
		IdProducto		int DEFAULT NULL, --NULL si Motivo != Canje
		CantMillas		int NOT NULL,
		Fecha			datetime NOT NULL,
		Motivo			nvarchar(4000) NOT NULL, --Compra de pasaje/encomienda, Cancelación, Canje de artículo
		CONSTRAINT FK_TransaccionMillas_Cliente FOREIGN KEY (IdCliente) REFERENCES NEPAIRLINES.Cliente (IdCliente),
		CONSTRAINT FK_TransaccionMillas_Viaje FOREIGN KEY (IdViaje) REFERENCES NEPAIRLINES.Viaje (IdViaje),
		CONSTRAINT FK_TransaccionMillas_Producto FOREIGN KEY (IdProducto) REFERENCES NEPAIRLINES.ProductoCanje (IdProducto)
);
GO

--Ingreso/Migración de datos
BEGIN TRANSACTION	

INSERT INTO NEPAIRLINES.Cliente (Nombre, Apellido, Dni, FechaNac, Dir, Telefono, Mail)
		SELECT	M.Cli_Nombre, M.Cli_Apellido, M.Cli_Dni, M.Cli_Fecha_Nac, M.Cli_Dir, M.Cli_Telefono, M.Cli_Mail
		FROM	gd_esquema.Maestra AS M
		GROUP BY M.Cli_Nombre, M.Cli_Apellido, M.Cli_Dni, M.Cli_Fecha_Nac, M.Cli_Dir, M.Cli_Telefono, M.Cli_Mail;


INSERT INTO	NEPAIRLINES.Rol (Nombre, EstaHabilitado) VALUES
		('Administrador', 1),
		('Cliente', 1);

INSERT INTO NEPAIRLINES.Funcionalidad(Nombre) VALUES
		('ABM Aeronaves'),
		('ABM Ciudad'),
		('ABM Rol'),
		('ABM Ruta'),
		('Canje Millas'),
		('Compra'),
		('Consulta Millas'),
		('Devolucion'),
		('Geneacion Viaje'),
		('Listado Estadistico'),
		('Registro de Usuario'),
		('Registro de Llegada');


INSERT INTO NEPAIRLINES.RolFuncionalidad(IdRol, IdFuncionalidad, TienePermisos)
	SELECT		(
			SELECT		R.IdRol
			FROM		NEPAIRLINES.Rol AS R
			WHERE		R.Nombre = 'Administrador') AS IdRol, F.IdFuncionalidad, 1
	FROM		NEPAIRLINES.Funcionalidad AS F


INSERT INTO NEPAIRLINES.RolFuncionalidad(IdRol, IdFuncionalidad, TienePermisos) VALUES
		(2, 5, 1),
		(2, 6, 1),
		(2, 7 ,1),
		(2, 10, 1);


INSERT INTO NEPAIRLINES.Usuario (Nombre, Clave, EstaHabilitado, IdRol) VALUES
		('admin', HASHBYTES('SHA2_256','w23e'), 1, 1);


INSERT INTO	NEPAIRLINES.Ciudad (Nombre, EstaHabilitada)
		(SELECT	DISTINCT M.Ruta_Ciudad_Origen, '1' AS EstaHabilitada
		FROM		gd_esquema.Maestra AS M)
		UNION
		(SELECT		DISTINCT M.Ruta_Ciudad_Destino, '1' AS EstaHabilitada
		FROM		gd_esquema.Maestra AS M);


INSERT INTO NEPAIRLINES.Servicio (Nombre)
		SELECT DISTINCT M.Tipo_servicio
		FROM		gd_esquema.Maestra AS M;


INSERT INTO NEPAIRLINES.Fabricante (Nombre)
		SELECT		M.Aeronave_Fabricante
		FROM		gd_esquema.Maestra AS M
		GROUP BY	M.Aeronave_Fabricante;


INSERT INTO NEPAIRLINES.Modelo (Nombre, IdFabricante)
		SELECT		M.Aeronave_Modelo, (
				SELECT		F.IdFabricante
				FROM		NEPAIRLINES.Fabricante AS F
				WHERE		M.Aeronave_Fabricante = F.Nombre) AS IdFabricante
		FROM		gd_esquema.Maestra AS M
		GROUP BY	M.Aeronave_Fabricante, M.Aeronave_Modelo;


INSERT INTO NEPAIRLINES.Aeronave (Matricula, IdModelo, IdServicio, KgDisponibles, Estado, FechaInicio, FechaFin, FechaAlta)
		SELECT		M.Aeronave_Matricula, (
				SELECT		Md.IdModelo
				FROM		NEPAIRLINES.Modelo AS Md
				WHERE		M.Aeronave_Fabricante = (
						SELECT		F.Nombre
						FROM		NEPAIRLINES.Fabricante AS F
						WHERE		Md.IdFabricante = F.IdFabricante)
				AND			M.Aeronave_Modelo = Md.Nombre) AS IdModelo, (
				SELECT		S.IdServicio
				FROM		NEPAIRLINES.Servicio AS S
				WHERE		M.Tipo_Servicio = S.Nombre) AS IdServicio, M.Aeronave_KG_Disponibles, 2, NULL, NULL, NULL
		FROM		gd_esquema.Maestra AS M
		GROUP BY	M.Aeronave_Matricula, M.Aeronave_Fabricante, M.Aeronave_Modelo, M.Aeronave_KG_Disponibles, M.Tipo_Servicio;


INSERT INTO NEPAIRLINES.TipoButaca (Nombre)
		SELECT		M.Butaca_Tipo
		FROM		gd_esquema.Maestra AS M
		WHERE		M.Butaca_Tipo != '0'
		GROUP BY	M.Butaca_Tipo;


INSERT INTO NEPAIRLINES.Butaca (IdAeronave, Nro, IdTipoButaca, Piso)
		SELECT		(
				SELECT		A.IdAeronave
				FROM		NEPAIRLINES.Aeronave AS A
				WHERE		M.Aeronave_Matricula = A.Matricula) AS IdAeronave, M.Butaca_Nro, (
				SELECT		TB.IdTipoButaca
				FROM		NEPAIRLINES.TipoButaca AS TB
				WHERE		M.Butaca_Tipo = TB.Nombre) AS IdTipoButaca, M.Butaca_Piso
		FROM		gd_esquema.Maestra AS M
		WHERE		M.Pasaje_Codigo != 0
		GROUP BY	M.Aeronave_Matricula, M.Butaca_Nro, M.Butaca_Piso, M.Butaca_Tipo;


INSERT INTO NEPAIRLINES.Ruta (Codigo, IdServicio, IdCiudadOrigen, IdCiudadDestino, EstaHabilitada, PrecioBaseKg, PrecioBasePasaje)
		SELECT		M.Ruta_Codigo, (
				SELECT		S.IdServicio
				FROM		NEPAIRLINES.Servicio AS S
				WHERE		M.Tipo_Servicio = S.Nombre) AS IdServicio, (
				SELECT		C1.IdCiudad
				FROM		NEPAIRLINES.Ciudad AS C1
				WHERE		C1.Nombre = M.Ruta_Ciudad_Origen) AS IdCiudadOrigen, (
				SELECT		C2.IdCiudad
				FROM		NEPAIRLINES.Ciudad AS C2
				WHERE		C2.Nombre = M.Ruta_Ciudad_Destino) AS IdCiudadDestino, '1' AS EstaHabilitada, (
				SELECT		M1.Ruta_Precio_BaseKG
				FROM		gd_esquema.Maestra AS M1
				WHERE		M.Ruta_Codigo = M1.Ruta_Codigo
				AND			M.Ruta_Ciudad_Origen = M1.Ruta_Ciudad_Origen
				AND			M.Ruta_Ciudad_Destino = M1.Ruta_Ciudad_Destino
				AND			M1.Ruta_Precio_BaseKG != 0
				GROUP BY	M1.Ruta_Precio_BaseKG) AS PrecioBaseKg, (
				SELECT		M2.Ruta_Precio_BasePasaje
				FROM		gd_esquema.Maestra AS M2
				WHERE		M.Ruta_Codigo = M2.Ruta_Codigo
				AND			M.Ruta_Ciudad_Origen = M2.Ruta_Ciudad_Origen
				AND			M.Ruta_Ciudad_Destino = M2.Ruta_Ciudad_Destino
				AND			M2.Ruta_Precio_BasePasaje != 0
				GROUP BY	M2.Ruta_Precio_BasePasaje) AS PrecioBasePasaje
		FROM		gd_esquema.Maestra AS M
		GROUP BY	M.Ruta_Codigo, M.Tipo_Servicio, M.Ruta_Ciudad_Origen, M.Ruta_Ciudad_Destino;


INSERT INTO NEPAIRLINES.Viaje (IdRuta, IdAeronave, FechaSalida, FechaLlegada, FechaEstimada)
		SELECT		(
				SELECT		R.IdRuta
				FROM		NEPAIRLINES.Ruta AS R
				WHERE		M.Ruta_Ciudad_Origen = (
						SELECT		C1.Nombre
						FROM		NEPAIRLINES.Ciudad AS C1
						WHERE		R.IdCiudadOrigen = C1.IdCiudad)
				AND			M.Ruta_Ciudad_Destino = (
						SELECT		C2.Nombre
						FROM		NEPAIRLINES.Ciudad AS C2
						WHERE		R.IdCiudadDestino = C2.IdCiudad)
				AND			M.Tipo_Servicio = (
						SELECT		S.Nombre
						FROM		NEPAIRLINES.Servicio AS S
						WHERE		M.Tipo_Servicio = S.Nombre)) AS IdRuta,
					(
				SELECT		A.IdAeronave
				FROM		NEPAIRLINES.Aeronave AS A
				WHERE		M.Aeronave_Matricula = A.Matricula) AS IdAeronave, M.FechaSalida, M.FechaLLegada, M.Fecha_LLegada_Estimada
		FROM		gd_esquema.Maestra AS M
		GROUP BY	M.Ruta_Ciudad_Origen, M.Ruta_Ciudad_Destino, M.Tipo_Servicio, M.Aeronave_Matricula, M.FechaSalida, M.FechaLLegada, M.Fecha_LLegada_Estimada;


INSERT INTO NEPAIRLINES.Pasaje (IdCliente, Codigo, Precio, FechaCompra, IdViaje, IdButaca)
		SELECT		(
				SELECT		C.IdCliente
				FROM		NEPAIRLINES.Cliente AS C
				WHERE		M.Cli_Dni = C.Dni
				AND			M.Cli_Nombre = C.Nombre
				AND			M.Cli_Apellido = C.Apellido) AS IdCliente,
					M.Pasaje_Codigo, M.Pasaje_Precio, M.Pasaje_FechaCompra, (
				SELECT		V.IdViaje
				FROM		NEPAIRLINES.Viaje AS V, NEPAIRLINES.Ruta AS R, NEPAIRLINES.Ciudad AS Cd1, NEPAIRLINES.Ciudad AS Cd2, NEPAIRLINES.Aeronave AS Ae
				WHERE		V.IdRuta = R.IdRuta
				AND			V.IdAeronave = Ae.IdAeronave
				AND			M.FechaSalida = V.FechaSalida
				AND			M.Aeronave_Matricula = Ae.Matricula
				AND			M.Tipo_Servicio = (
						SELECT		Srv.Nombre
						FROM		NEPAIRLINES.Servicio AS Srv
						WHERE		Ae.IdServicio = Srv.IdServicio)
				AND			M.Ruta_Codigo = R.Codigo
				AND			M.Ruta_Ciudad_Origen = Cd1.Nombre
				AND			M.Ruta_Ciudad_Destino = Cd2.Nombre
				AND			R.IdCiudadOrigen = Cd1.IdCiudad
				AND			R.IdCiudadDestino = Cd2.IdCiudad) AS IdViaje, (
				SELECT		B.IdButaca
				FROM		NEPAIRLINES.Butaca AS B
				WHERE		B.IdAeronave = (
						SELECT		A.IdAeronave
						FROM		NEPAIRLINES.Aeronave AS A
						WHERE		M.Aeronave_Matricula = A.Matricula)
				AND			M.Butaca_Nro = B.Nro
				AND			M.Butaca_Tipo = (
						SELECT		TB.Nombre
						FROM		NEPAIRLINES.TipoButaca AS TB
						WHERE		TB.IdTipoButaca = B.IdTipoButaca)
				AND			M.Butaca_Piso = B.Piso) AS IdButaca
		FROM		gd_esquema.Maestra AS M
		WHERE		M.Pasaje_Codigo != 0
		GROUP BY	M.Cli_Dni, M.Cli_Nombre, M.Cli_Apellido, M.Pasaje_Codigo, M.Ruta_Codigo, M.Ruta_Ciudad_Origen, M.Ruta_Ciudad_Destino, M.Pasaje_Precio,
					M.Pasaje_FechaCompra, M.FechaSalida, M.Aeronave_Matricula, M.Tipo_Servicio, M.Butaca_Nro, M.Butaca_Tipo, M.Butaca_Piso;


INSERT INTO NEPAIRLINES.Encomienda (IdCliente, Codigo, Precio, Kg, FechaCompra, IdViaje)
		SELECT		(
				SELECT		C.IdCliente
				FROM		NEPAIRLINES.Cliente AS C
				WHERE		M.Cli_Dni = C.Dni
				AND			M.Cli_Nombre = C.Nombre
				AND			M.Cli_Apellido = C.Apellido) AS IdCliente,
					M.Paquete_Codigo, M.Paquete_Precio, M.Paquete_KG, M.Paquete_FechaCompra, (
				SELECT		V.IdViaje
				FROM		NEPAIRLINES.Viaje AS V, NEPAIRLINES.Ruta AS R, NEPAIRLINES.Ciudad AS Cd1, NEPAIRLINES.Ciudad AS Cd2, NEPAIRLINES.Aeronave AS Ae
				WHERE		V.IdRuta = R.IdRuta
				AND			V.IdAeronave = Ae.IdAeronave
				AND			M.FechaSalida = V.FechaSalida
				AND			M.Aeronave_Matricula = Ae.Matricula
				AND			M.Tipo_Servicio = (
						SELECT		Srv.Nombre
						FROM		NEPAIRLINES.Servicio AS Srv
						WHERE		Ae.IdServicio = Srv.IdServicio)
				AND			M.Ruta_Codigo = R.Codigo
				AND			M.Ruta_Ciudad_Origen = Cd1.Nombre
				AND			M.Ruta_Ciudad_Destino = Cd2.Nombre
				AND			R.IdCiudadOrigen = Cd1.IdCiudad
				AND			R.IdCiudadDestino = Cd2.IdCiudad) AS IdViaje
		FROM		gd_esquema.Maestra AS M
		WHERE		M.Paquete_Codigo != 0
		GROUP BY	M.Cli_Dni, M.Cli_Nombre, M.Cli_Apellido, M.Paquete_Codigo, M.Ruta_Codigo, M.Ruta_Ciudad_Origen, M.Ruta_Ciudad_Destino, M.Paquete_Precio,
					M.Paquete_FechaCompra, M.Paquete_KG, M.Aeronave_Matricula, M.FechaSalida, M.Tipo_Servicio;


INSERT INTO NEPAIRLINES.TransaccionMillas (IdCliente, IdViaje, CantMillas, Fecha, Motivo)
(
		(SELECT		P.IdCliente, P.IdViaje, CAST((P.Precio/10) AS INT) AS CantMillas, V1.FechaLlegada, 'Compra de pasaje' AS Motivo
		FROM		NEPAIRLINES.Pasaje AS P, NEPAIRLINES.Viaje AS V1
		WHERE		P.IdViaje = V1.IdViaje)
		UNION ALL
		(SELECT		E.IdCliente, E.IdViaje, CAST((E.Precio/10) AS INT) AS CantMillas, V2.FechaLlegada, 'Compra de encomienda' AS Motivo
		FROM		NEPAIRLINES.Encomienda AS E, NEPAIRLINES.Viaje AS V2
		WHERE		E.IdViaje = V2.IdViaje)
);


GO
COMMIT TRANSACTION
GO