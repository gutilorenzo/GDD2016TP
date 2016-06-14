use GD1C2016
GO
Create schema LOS_LEONES
GO

GO
create table LOS_LEONES.Direccion_Empresa(
	dir_id numeric(6,0) identity(1,1) not null,
	dir_nom_calle nvarchar(100) not null,
	dir_num_calle numeric(18,0) not null,
	dir_piso numeric(18,0) not null,
	dir_departamento nvarchar(50) not null,
	dir_cod_postal nvarchar(50) not null,
	dir_cuit nvarchar(50) not null,
	primary key(dir_id)

)
GO 
create table LOS_LEONES.Direccion_Cliente(
	dir_id numeric(6,0) IDENTITY(1,1) not null,
	dir_nom_calle nvarchar(255) not null,
	dir_num_calle numeric(18,0) not null,
	dir_piso numeric(18,0) not null,
	dir_departamento nvarchar(50) not null,
	dir_cod_postal nvarchar(50) not null,
	dir_dni numeric(18,0) not null,
	primary key(dir_id)
)

GO
create table LOS_LEONES.Rol(
	rol_id numeric(6,0) not null,
	rol_nombre nvarchar(255) not null,
	rol_habilitado bit,
	primary key(rol_id)	
	
)
GO
create table LOS_LEONES.Funcion(
	fun_id numeric(6,0) not null,
	fun_descripcion nvarchar(255) not null,
	primary key(fun_id)	
	
)
GO
create table LOS_LEONES.Rol_Funcion(
	rolf_id numeric(6,0) not null,
	rolf_funcion numeric(6,0) not null,
	constraint FK_Rol_Funcion_Rol foreign key (rolf_id) references LOS_LEONES.Rol (rol_id),
	constraint FK_Rol_Funcion_Funcion foreign key (rolf_funcion) references LOS_LEONES.Funcion(fun_id),
	primary key (rolf_id, rolf_funcion)
	)



GO
create table LOS_LEONES.Rubro(
	rub_id numeric(6,0) identity(1,1) not null,
	rub_descripcion_corta nvarchar(100) not null,
	rub_descripcion_larga nvarchar(255) not null,
	primary key(rub_id)
)
GO
create table LOS_LEONES.Publ_Visibilidad(
	publivisi_codigo numeric(18,0) not null,
	publivisi_descripcion nvarchar(255) not null,
	publivisi_precio numeric(18,2) not null,
	publivisi_porcentaje numeric(18,2) not null,
	publivisi_envio numeric(18,2)
	primary key(publivisi_codigo)
)

GO
create table LOS_LEONES.Calificacion(
	cali_id numeric(18,0) not null,
	cali_cant_estrellas numeric(18,0) not null,
	cali_descripcion nvarchar(255),
	primary key(cali_id)
)

GO
create table LOS_LEONES.Factura(
	fact_nro numeric(18,0) not null,
	fact_fecha datetime not null,
	fact_total numeric(18,2) not null,
	primary key(fact_nro),
	
)
GO
create table LOS_LEONES.Forma_Pago(
	fpago_id numeric(6,0) identity(1,1) not null,
	fpago_descripcion nvarchar(255) not null,
	primary key(fpago_id),
)

GO
create table LOS_LEONES.Usuario(
	usu_id numeric(6,0) identity(1,1) not null,
	usu_nombre nvarchar(255) unique not null,
	usu_contrasenia nvarchar(255) not null,
	usu_error_login numeric(1,0) not null DEFAULT 0,
	usu_rol numeric(6,0),
	usu_nuevo bit,
	usu_habilitado bit,	
	primary key(usu_id),
	constraint FK_Usuario_Rol foreign key(usu_rol) references LOS_LEONES.Rol(rol_id)
)

GO 
create table LOS_LEONES.Persona_Cliente(
	pers_id numeric(6,0) identity(1,1) not null,
	pers_nombre nvarchar(255) not null,
	pers_apellido nvarchar(255) not null,
	pers_dni numeric(18,0) not null ,
	pers_fecha_nacimiento datetime not null,
	pers_mail nvarchar(255) not null,
	pers_tipo_dni nvarchar(50) not null,
	pers_telefono nvarchar(50) not null,
	pers_fecha_creacion datetime not null,	
	pers_direccion numeric(6,0) not null,
	pers_id_usuario numeric(6,0) not null,
	primary key(pers_dni),
	constraint FK_Persona_Cliente_Usuario foreign key (pers_id_usuario) references LOS_LEONES.Usuario(usu_id),
	constraint FK_Persona_Cliente_Direccion_Cliente foreign key (pers_direccion) references LOS_LEONES.Direccion_Cliente(dir_id)
	
)
GO
create table LOS_LEONES.Empresa(
	emp_id numeric(6,0) identity(1,1) not null,
	emp_razon_social nvarchar(255) not null unique,
	emp_cuit nvarchar(50) not null unique,
	emp_fecha_creacion datetime not null,
	emp_mail nvarchar(50) not null,
	emp_id_usuario numeric(6,0) not null,
	emp_rubro nvarchar(50) not null,
	emp_telefono nvarchar(50) not null,
	emp_ciudad nvarchar(100) not null,
	emp_nombre_de_contacto nvarchar(255) not null,
	emp_direccion numeric(6,0) not null,
	primary key(emp_id),
	constraint FK_Empresa_Usuario foreign key (emp_id_usuario) references LOS_LEONES.Usuario(usu_id),
	constraint FK_Empresa_Direccion_Empresa foreign key (emp_direccion) references LOS_LEONES.Direccion_Empresa(dir_id),

)

GO
create table LOS_LEONES.Item_Factura(
	itemf_id numeric(18,0) not null,
	itemf_id_visibilidad numeric(18,0) not null,
	itemf_item nvarchar(255) not null,
	itemf_monto_total numeric(18,2) not null,
	itemf_cantidad numeric(18,0) not null,
	primary key(itemf_id),
	constraint FK_Item_Factura_Factura foreign key(itemf_id) references LOS_LEONES.Factura(fact_nro),
	constraint FK_Item_Facutra_Visibilidad foreign key(itemf_id_visibilidad) references LOS_LEONES.Publ_Visibilidad(publivisi_codigo)
	
)

GO
create table LOS_LEONES.Publicacion(
	publi_id numeric(18,0) not null,
	publi_descripcion nvarchar(255) not null,
	publi_stock numeric(18,0) not null,
	publi_fecha_inicio datetime not null,
	publi_fecha_vencimiento datetime not null,
	publi_precio numeric(18,2) not null,
	publi_tipo nvarchar(255) not null,
	publi_estado nvarchar(255) not null,
	publi_usuario_responsable numeric(6) not null,
	publi_visibilidad numeric(18,0) not null,
	publi_id_rubro numeric(6,0) not null,
	publi_enviable bit not null,
	publi_calificaciones numeric(18,0),
	publi_preguntable bit,	
	primary key(publi_id),
	constraint FK_Publicacion_Usuario foreign key(publi_usuario_responsable) references LOS_LEONES.Usuario(usu_id),
	constraint FK_Publicacion_Visibilidad foreign key(publi_visibilidad) references LOS_LEONES.Publ_Visibilidad(publivisi_codigo),
	constraint FK_Publicacion_Rubro foreign key(publi_id_rubro) references LOS_LEONES.Rubro(rub_id),
	constraint FK_Publicacion_Calificacion foreign key(publi_calificaciones) references LOS_LEONES.Calificacion(cali_id)
	
)

GO
create table LOS_LEONES.Comprar(
	comp_id numeric(6,0) identity(1,1) not null,
	comp_fecha datetime not null,
	comp_cantidad numeric(18,0) not null,
	comp_factura_nro numeric(18,0) not null,
	comp_usuario numeric(6,0) not null,
	comp_id_publicacion numeric(18,0),
	comp_forma_pago numeric(6,0),
	comp_calificacion numeric(18,0),
	primary key(comp_id),
	constraint FK_Comprar_Factura foreign key(comp_factura_nro) references LOS_LEONES.Factura(fact_nro),
	constraint FK_Comprar_Usuario foreign key(comp_usuario) references LOS_LEONES.Usuario(usu_id),
	constraint FK_Comprar_Publicacion foreign key(comp_id_publicacion) references LOS_LEONES.Publicacion(publi_id),
	constraint FK_Comprar_FormaPago foreign key(comp_forma_pago) references LOS_LEONES.Forma_Pago(fpago_id),
	constraint FK_Comprar_Calificacion foreign key(comp_calificacion) references LOS_LEONES.Calificacion(cali_id)
)
GO
create table LOS_LEONES.Ofertar(
	ofer_id numeric(6,0) identity(1,1) not null,
	ofer_fecha datetime not null,
	ofer_monto numeric(18,2) not null,
	ofer_publicacion numeric(18,0) not null,
	ofer_esGanadora bit not null,
	primary key(ofer_id),
	constraint FK_Ofertar_Publicacion foreign key(ofer_publicacion) references LOS_LEONES.Publicacion(publi_id)
	
)
GO