--Ingreso/Migración de datos
BEGIN TRANSACTION	

/*Cargo tabla ROL*/
INSERT INTO	LOS_LEONES.Rol (rol_id,rol_nombre, rol_habilitado) VALUES
		(1,'Administrador',1),
		(2,'Empresa', 1),
		(3,'Cliente',1);
/*Cargo tabla Funcion*/		
INSERT INTO LOS_LEONES.Funcion(fun_id,fun_descripcion) VALUES
		(1,'Vender'),
		(2,'Calificar'),
		(3,'Comprar'),
		(4,'Vender'),
		(5,'ABM Rol'),
		(6,'Listado Estadistico'),
		(7,'ABM Usuarios');
/*Cargo tabla ROL_funcion (tabla intermedia)*/
INSERT INTO LOS_LEONES.Rol_Funcion(rolf_id,rolf_funcion) VALUES
		(1,7),
		(2,4),
		(3,1),
		(3,2),
		(3,4),
		(3,6);

/*Cargo tabla Publi_Visibilidad desde la tabla maestra*/
INSERT INTO LOS_LEONES.Publ_Visibilidad(publivisi_codigo,publivisi_descripcion,publivisi_precio,publivisi_porcentaje,publivisi_envio) 
		SELECT DISTINCT Publicacion_Visibilidad_Cod,Publicacion_Visibilidad_Desc,Publicacion_Visibilidad_Precio,Publicacion_Visibilidad_Porcentaje, 0
		FROM gd_esquema.Maestra 
		ORDER BY Publicacion_Visibilidad_Cod

GO

/*Cargo tabla de Calificaciones */
INSERT INTO LOS_LEONES.Calificacion
select distinct Calificacion_Codigo,Calificacion_Cant_Estrellas,Calificacion_Descripcion
from gd_esquema.Maestra
where Calificacion_Codigo is not null
order by Calificacion_Codigo,Calificacion_Cant_Estrellas,Calificacion_Descripcion
GO

/*Cargo tabla Factura */
INSERT INTO LOS_LEONES.Factura
select distinct Factura_Nro,Factura_Fecha,Factura_Total
from gd_esquema.Maestra
where Factura_Nro is not null
order by Factura_Nro,Factura_Fecha,Factura_Total
go

/*Cargo tabla forma de pago */
INSERT INTO LOS_LEONES.Forma_Pago
select distinct Forma_Pago_Desc 
from gd_esquema.Maestra
where Forma_Pago_Desc is not null
go


/*Cargo la tabla de Usuarios con datos de Clientes */
INSERT INTO LOS_LEONES.Usuario(usu_nombre,usu_contrasenia,usu_rol,usu_nuevo,usu_habilitado)
select distinct cast(Publ_Cli_Dni as nvarchar(255)), SUBSTRING(Publ_Cli_Apeliido,1,3) + SUBSTRING(Publ_Cli_Nombre,1,3),3,1,1
from gd_esquema.Maestra
where Publ_Cli_Dni is not null
go

/*Cargo la tabla de Usuarios con datos de Empresas */
INSERT INTO LOS_LEONES.Usuario(usu_nombre,usu_contrasenia,usu_rol,usu_nuevo,usu_habilitado)
select distinct cast(Publ_Empresa_Cuit as nvarchar(255)), SUBSTRING(Publ_Empresa_Razon_Social,1,6),2,1,1
from gd_esquema.Maestra
where Publ_Empresa_Cuit is not null
go

/*Cargo tabla Direccion Empresa */
INSERT INTO LOS_LEONES.Direccion_Empresa
select distinct Publ_Empresa_Dom_Calle,Publ_Empresa_Nro_Calle,Publ_Empresa_Piso,Publ_Empresa_Depto,Publ_Empresa_Cod_Postal,Publ_Empresa_Cuit
from gd_esquema.Maestra 
where Publ_Empresa_Dom_Calle is not NULL
order by Publ_Empresa_Dom_Calle,Publ_Empresa_Nro_Calle,Publ_Empresa_Piso,Publ_Empresa_Depto,Publ_Empresa_Cod_Postal
GO

/*Cargo tabla Direccion Cliente */
INSERT INTO LOS_LEONES.Direccion_Cliente
select distinct Publ_Cli_Dom_Calle,Publ_Cli_Nro_Calle,Publ_Cli_Piso,Publ_Cli_Depto,Publ_Cli_Cod_Postal,Publ_Cli_Dni
from gd_esquema.Maestra 
where Publ_Cli_Dom_Calle is not NULL
order by Publ_Cli_Dom_Calle,Publ_Cli_Nro_Calle,Publ_Cli_Piso,Publ_Cli_Depto,Publ_Cli_Cod_Postal
GO

/*Cargo tabla de Clientes */
INSERT INTO LOS_LEONES.Persona_Cliente(pers_nombre,pers_apellido,pers_dni,pers_fecha_nacimiento,pers_mail,pers_tipo_dni,pers_telefono,pers_fecha_creacion,pers_direccion,pers_id_usuario)
select distinct Publ_Cli_Nombre,Publ_Cli_Apeliido,Publ_Cli_Dni,Publ_Cli_Fecha_Nac,Publ_Cli_Mail,'DNI','0',GETDATE(),(
				select D.dir_id
				from LOS_LEONES.Direccion_Cliente AS D
				where Publ_Cli_Dni = D.dir_dni) AS pers_direccion,(
				select U.usu_id
				from LOS_LEONES.Usuario AS U
				where Publ_Cli_Dni = U.usu_nombre) AS pers_id_usuario
							
from gd_esquema.Maestra 
where Publ_Cli_Dni is not NULL
GO

/*Cargo tabla de Empresas */
INSERT INTO LOS_LEONES.Empresa(emp_razon_social,emp_cuit,emp_fecha_creacion,emp_mail,emp_id_usuario,emp_rubro,emp_telefono,emp_ciudad,emp_nombre_de_contacto,emp_direccion)
select distinct Publ_Empresa_Razon_Social,Publ_Empresa_Cuit,Publ_Empresa_Fecha_Creacion,Publ_Empresa_Mail,(
				select U.usu_id
				from LOS_LEONES.Usuario AS U
				where Publ_Empresa_Cuit = U.usu_nombre) AS emp_id_usuario,'1','0','CABA','Prueba',(
				select D.dir_id
				from LOS_LEONES.Direccion_Empresa as D
				where Publ_Empresa_Cuit = D.dir_cuit) AS emp_direccion
from gd_esquema.Maestra 
where Publ_Empresa_Cuit is not null
go
/*Cargo la tabla de Publicacion */
INSERT INTO LOS_LEONES.Publicacion(publi_id,publi_descripcion,publi_stock,publi_fecha_inicio,publi_fecha_vencimiento,publi_precio,publi_tipo,publi_usuario_responsable,publi_visibilidad,publi_id_rubro,publi_enviable,publi_calificaciones,publi_preguntable)
select distinct Publicacion_Cod,Publicacion_Descripcion,Publicacion_Stock,Publicacion_Fecha,Publicacion_Fecha_Venc,Publicacion_Precio,Publicacion_Tipo,(
				select U.usu_id
				from LOS_LEONES.Usuario AS U
				where 
				
				),Publicacion_Visibilidad_Cod,(),(),(),()

from gd_esquema.Maestra
GO

/*Cargo la tabla de Ofertas */
INSERT INTO LOS_LEONES.Ofertar(ofer_fecha,ofer_monto,ofer_publicacion,ofer_esGanadora)
select distinct Oferta_Fecha,Oferta_Monto,(),()
from gd_esquema.Maestra
GO

/*Cargo la tabla de compras */
INSERT INTO LOS_LEONES.Comprar(comp_fecha,comp_cantidad,comp_factura_nro,comp_usuario,comp_id_publicacion,comp_forma_pago,comp_calificacion)
select distinct Compra_Fecha,Compra_Fecha
from gd_esquema.Maestra
GO

/*Cargo la tabla de Item_Factura */
INSERT INTO LOS_LEONES.Item_Factura(itemf_id,itemf_id_visibilidad,itemf_item,itemf_monto_total,itemf_cantidad)
select distinct (),(),(),Item_Factura_Monto,Item_Factura_Cantidad
from gd_esquema.Maestra
GO

/*Cargo la tabla de Rubros */
INSERT INTO LOS_LEONES.Rubro(rub_descripcion_corta,rub_descripcion_larga)
select distinct Publicacion_Rubro_Descripcion,Publicacion_Rubro_Descripcion
from gd_esquema.Maestra
where Publicacion_Rubro_Descripcion is not null
GO

COMMIT TRANSACTION
GO

select Cli_Dni
from gd_esquema.Maestra

select distinct Publicacion_Cod
from gd_esquema.Maestra


select * from LOS_LEONES.Funcion
select * from LOS_LEONES.Rol
select * from LOS_LEONES.Rol_Funcion
select * from LOS_LEONES.Publ_Visibilidad
select * from LOS_LEONES.Direccion_Cliente
select * from LOS_LEONES.Direccion_Empresa
select * from LOS_LEONES.Calificacion
select * from LOS_LEONES.Factura
select * from LOS_LEONES.Forma_Pago
select * from LOS_LEONES.Usuario
select * from LOS_LEONES.Empresa

select * from LOS_LEONES.Rubro
/* CAMPO POR CAMPO */
select Publ_Cli_Dni from gd_esquema.Maestra
select Publ_Cli_Apeliido from gd_esquema.Maestra
select Publ_Cli_Nombre from gd_esquema.Maestra
select Publ_Cli_Fecha_Nac from gd_esquema.Maestra
select Publ_Cli_Mail from gd_esquema.Maestra
select Publ_Cli_Dom_Calle from gd_esquema.Maestra
select Publ_Cli_Nro_Calle from gd_esquema.Maestra
select Publ_Cli_Piso from gd_esquema.Maestra
select Publ_Cli_Depto from gd_esquema.Maestra
select Publ_Cli_Cod_Postal from gd_esquema.Maestra

/* TODAS LOS CAMPOS DE LAS PUBLICACIONES DE CLIENTES QUE NO SON NULL */
select distinct Publ_Cli_Dni,Publ_Cli_Apeliido,Publ_Cli_Nombre ,Publ_Cli_Fecha_Nac,Publ_Cli_Mail,Publ_Cli_Dom_Calle,Publ_Cli_Nro_Calle,Publ_Cli_Piso,Publ_Cli_Depto,Publ_Cli_Cod_Postal
from gd_esquema.Maestra where Publ_Cli_Apeliido is not NULL


/* CAMPO POR CAMPO */
select Publ_Empresa_Razon_Social from gd_esquema.Maestra
select Publ_Empresa_Cuit from gd_esquema.Maestra
select Publ_Empresa_Fecha_Creacion from gd_esquema.Maestra
select Publ_Empresa_Mail from gd_esquema.Maestra
select Publ_Empresa_Dom_Calle from gd_esquema.Maestra
select Publ_Empresa_Nro_Calle from gd_esquema.Maestra
select Publ_Empresa_Piso from gd_esquema.Maestra
select Publ_Empresa_Depto from gd_esquema.Maestra
select Publ_Empresa_Cod_Postal from gd_esquema.Maestra

/* TODOS LOS CAMPOS DE LAS PUBLICACIONES DE LAS EMPRESAS QUE NO SON NULL */
select distinct Publ_Empresa_Razon_Social,Publ_Empresa_Cuit, Publ_Empresa_Fecha_Creacion, Publ_Empresa_Mail,Publ_Empresa_Dom_Calle,Publ_Empresa_Nro_Calle,Publ_Empresa_Piso, Publ_Empresa_Depto,Publ_Empresa_Cod_Postal
from gd_esquema.Maestra where Publ_Empresa_Cuit is not NULL

/* CAMPO POR CAMPO */
select Publicacion_Cod from gd_esquema.Maestra
select Publicacion_Descripcion from gd_esquema.Maestra
select Publicacion_Stock from gd_esquema.Maestra
select Publicacion_Fecha from gd_esquema.Maestra
select Publicacion_Fecha_Venc from gd_esquema.Maestra
select Publicacion_Precio from gd_esquema.Maestra
select Publicacion_Tipo from gd_esquema.Maestra
select Publicacion_Visibilidad_Cod from gd_esquema.Maestra
select Publicacion_Visibilidad_Desc from gd_esquema.Maestra
select Publicacion_Visibilidad_Precio from gd_esquema.Maestra
select Publicacion_Visibilidad_Porcentaje from gd_esquema.Maestra
select Publicacion_Estado from gd_esquema.Maestra
select Publicacion_Rubro_Descripcion from gd_esquema.Maestra

/*TODOS LOS CAMPOS DE LAS PUBLICACIONES QUE NO SON NULL*/
select distinct Publicacion_Cod,Publicacion_Descripcion,Publicacion_Stock,Publicacion_Fecha,Publicacion_Fecha_Venc,Publicacion_Precio,Publicacion_Tipo,Publicacion_Visibilidad_Cod,Publicacion_Visibilidad_Desc,Publicacion_Visibilidad_Precio,Publicacion_Visibilidad_Porcentaje,Publicacion_Estado,Publicacion_Rubro_Descripcion
from gd_esquema.Maestra where Publicacion_Cod is not NULL
select distinct Publicacion_Visibilidad_Cod,Publicacion_Visibilidad_Desc,Publicacion_Visibilidad_Precio,Publicacion_Visibilidad_Porcentaje
from gd_esquema.Maestra 
ORDER BY Publicacion_Visibilidad_Cod
/* CAMPO POR CAMPO */
select Cli_Dni from gd_esquema.Maestra
select Cli_Apeliido from gd_esquema.Maestra
select Cli_Nombre from gd_esquema.Maestra
select Cli_Fecha_Nac from gd_esquema.Maestra
select Cli_Mail from gd_esquema.Maestra
select Cli_Dom_Calle from gd_esquema.Maestra
select Cli_Nro_Calle from gd_esquema.Maestra
select Cli_Piso from gd_esquema.Maestra
select Cli_Depto from gd_esquema.Maestra
select Cli_Cod_Postal from gd_esquema.Maestra

/*TODOS LOS CAMPOS DE LOS CLIENTES QUE NO SON NULL */
select distinct Cli_Dni,Cli_Apeliido,Cli_Nombre,Cli_Fecha_Nac,Cli_Mail,Cli_Dom_Calle,Cli_Nro_Calle,Cli_Piso,Cli_Depto,Cli_Cod_Postal
from gd_esquema.Maestra where Cli_Dni is not NULL

/*CAMPO POR CAMPO */
select Compra_Fecha from gd_esquema.Maestra
select Compra_Cantidad from gd_esquema.Maestra

/* TODOS LOS CAMPOS DE LAS COMPRAS QUE NO SON NULL */
select distinct Compra_Fecha,Compra_Cantidad
from gd_esquema.Maestra where Compra_Fecha is not NULL

/*CAMPO POR CAMPO */
select Oferta_Fecha from gd_esquema.Maestra
select Oferta_Monto from gd_esquema.Maestra

/*TODOS LOS CAMPOS DE LAS OFERTAS QUE NO SON NULL*/
select distinct Oferta_Fecha,Oferta_Monto
from gd_esquema.Maestra where Oferta_Fecha is not NULL

/* CAMPO POR CAMPO */
select Calificacion_Codigo from gd_esquema.Maestra
select Calificacion_Cant_Estrellas from gd_esquema.Maestra
select Calificacion_Descripcion from gd_esquema.Maestra

/*TODOS LOS CAMPOS DE CALIFICACION QUE NO SON NULL */
select Calificacion_Codigo, Calificacion_Cant_Estrellas,Calificacion_Descripcion
from gd_esquema.Maestra where Calificacion_Codigo is not NULL

/*CAMPO POR CAMPO */
select Item_Factura_Monto from gd_esquema.Maestra
select Item_Factura_Cantidad from gd_esquema.Maestra

/*TODOS LOS CAMPOS DE ITEM_FACTURA QUE NO SON NULL */
select distinct Item_Factura_Monto, Item_Factura_Cantidad
from gd_esquema.Maestra where Item_Factura_Monto is not NULL

/* CAMPO POR CAMPO */
select Factura_Nro from gd_esquema.Maestra
select Factura_Fecha from gd_esquema.Maestra
select Factura_Total from gd_esquema.Maestra

/* TODOS LOS CAMPOS DE LAS FACTURAS QUE NO SON NULL */
select distinct Factura_Nro,Factura_Fecha,Factura_Total
from gd_esquema.Maestra where Factura_Nro is not NULL

/*CAMPO POR CAMPO */
select Forma_Pago_Desc from gd_esquema.Maestra

/* TODOS LOS CAMPOS DE FORMA_PAGO QUE NO SON NULL */
select distinct Forma_Pago_Desc from gd_esquema.Maestra where Forma_Pago_Desc is not null