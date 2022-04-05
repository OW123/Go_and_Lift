create database bd_goandlift 

use bd_goandlift

create table Tamanos(
    IdTamanos int not null primary key identity(1,1),
    Descripcion varchar(150) not null
)
create table Proveedores(
    IdProveedor int not null primary key,
    IdProducto int not null,
    Cantidad int not null,
    Costo_Compra numeric(10,2) not null,
    foreign key (IdProducto) references Productos(IdProducto)
)

create table Categorias(
    IdCategoria int not null primary key,
    Descripcion varchar(150) not null,
)
create table Productos(
    IdProducto int not null primary key identity(1,1),
    IdCategoria int not null,
    Precio numeric(10,2) not null, 
    foreign key (IdCategoria) references Categorias(IdCategoria)
)

create table Relaciones(
    IdProducto int not null ,
    IdTamanos int not null,
    foreign key (IdProducto) references Productos(IdProducto),
    foreign key (IdTamanos) references Tamanos(IdTamanos)
)

create table Ticket(
    IdTicket int not null primary key identity(1,1),
    IdCliente int not null,
    IdProducto int not null,
    MetodoPago varchar(100) not null,
    Cantidad int not null,
    FechaVenta smalldatetime,
    FechaReparto smalldatetime,
    foreign key (IdCliente) references Cliente(IdCliente),
    foreign key (IdProducto) references Productos(IdProducto)
)

create table Cliente(
    IdCliente int not null primary key identity(1,1),
    Correo varchar(200) not null,
    Nombre varchar(60) not null,
    Direccion varchar(250) not null,
    CodigoPostal int not null,
    foreign key (CodigoPostal) references Ciudades(CodigoPostal)
)

create table Ciudades(
    CodigoPostal int not null primary key,
    Nombre varchar(150)
)




/*********************************
        PROCEDIMIENTOS ALMACENADOS
*********************************/
create proc AgregaCliente
    @Correo varchar(200),
    @Nombre varchar(60),
    @Direccion varchar(250),
    @CodigoPostal int 
AS
    if exists (select * from Ciudades where CodigoPostal = @CodigoPostal) and
    not exists(select * from Cliente where Correo = @Correo)
    BEGIN
        insert into Cliente(Correo, Nombre, Direccion, CodigoPostal)
        values(@Correo,@Nombre,@Direccion,@CodigoPostal);
        select ('Registro existoso') as Msg
    END
    ELSE
    BEGIN
        IF not exists(select * from Ciudades where CodigoPostal = @CodigoPostal)
            select ('Codigo Postal no existente') as Msg
        if exists(select * from Cliente where Correo = @Correo)
            select ('Correo Electrónico ya registrado') as Msg
    END

        
/*Proc para agregar Productos*/
ALTER proc AgregaProducto
@IdCategoria int,
@Precio numeric(10,2)
as

if exists(select * from Categorias where IdCategoria = @IdCategoria)
begin
	insert into Productos(IdCategoria,Precio)
	values(@IdCategoria,@Precio)
	select 'Agregado exitosamente' as mensaje
end
else
	select 'Esta categoria no existe'

/*Actualizar datos de cliente*/
create proc Act_Cliente
    @Id int,
    @Correo varchar(200),
    @Nombre varchar(60),
    @Direccion varchar(250),
    @CodigoPostal int 
AS

    if exists (select * from Cliente where IdCliente = @Id) and 
    exists(select * from Ciudades where CodigoPostal = @CodigoPostal)
    BEGIN
        update Cliente set Correo = @Correo, Nombre = @Nombre,Direccion = @Direccion, CodigoPostal = @CodigoPostal
        where IdCliente = @Id;
        select('Registro actualizado exitosamente') as Msg
    END
    else
    BEGIN
        if not exists(select * from Cliente where IdCliente = @Id)
            select('Cliente no existente') as Msg
        if not exists(select * from Ciudades where CodigoPostal = @CodigoPostal)
            select ('Codigo postal no existente') as Msg
    END
        

create proc AgregaCiudad
    @CodigoPostal int,
    @Nombre varchar(150)
AS
    if not exists(select * from Ciudades where CodigoPostal = @CodigoPostal)
        insert into Ciudades(CodigoPostal,Nombre)
        values(@CodigoPostal,@Nombre)
    ELSE    
        select('La ciudad ya está registrada') as Msg    

create proc AgregaTamano
    @Desc varchar(150)
AS  
    insert into Tamanos(Descripcion) values(@Desc)

create proc AgregaProveedores
    @IdProveedor int,
    @IdProducto int,
    @Cantidad int,
    @Costo numeric(10,2)

As
    if not exists(select * from Proveedores where IdProveedor = @IdProveedor)
    and exists(select * from Productos where IdProducto = @IdProducto)
        
    BEGIN
        insert into Proveedores(IdProveedor, IdProducto, Cantidad,Costo_Compra)
        values (@IdProveedor,@IdProducto,@Cantidad,@Costo);
        select ('Proveedor registrado exitosamente') as Msg
    END
        
    ELSE
    BEGIN
    if not exists(select * from Productos where IdProducto = @IdProducto)
            select('Producto no existente') as Msg
        if exists(select * from Proveedores where IdProveedor = @IdProveedor)
            select('Proveedor ya registrado') as Msg
    END

        

create proc AgregaCategoria
    @IdCategoria int,
    @Desc varchar(150)
AS
    if not exists(select * from Categorias where IdCategoria = @IdCategoria)
    BEGIN
        insert intO Categorias(IdCategoria, Descripcion)
        values (@IdCategoria,@Desc);
        select ('Categoria agregada exitosamente') as Msg
    END
    ELSE
        select ('Categoria ya registrada') as Msg

create proc AgregaTicket
    @IdCliente int,
    @IdProducto int,
    @MetodoPago varchar(100),
    @Cantidad int,
    @FechaReparto smalldatetime
AS
    if exists(select * from Cliente where IdCliente = @IdCliente)
    and exists(select * from Productos where IdProducto = @IdProducto)
    BEGIN
        insert into Ticket(IdCliente, IdProducto,MetodoPago,Cantidad,FechaVenta,FechaReparto)
        values(@IdCliente,@IdProducto,@MetodoPago,@Cantidad,getdate(),@FechaReparto);
        select('Ticket registrado exitosamente') as Msg
    END
        
    else
    BEGIN
        if not exists(select * from Cliente where IdCliente = @IdCliente)
            select ('Cliente no existente') as Msg
        if not exists(select * from Productos where IdProducto = @IdProducto)
            select ('Producto no existente') as Msg
    END
        

/*******************************
    TRIGGERS
***************************************/

/*Crear tabla de logs de Productos_H*/
create table log_Productos_H(
	IdProducto int,
    IdCategoria int,
    Precio numeric(10,2), 
    Descripción varchar(100),
    Accion varchar(50),
    Fecha_Mod smalldatetime
)

/*Trigger para la tabla de un producto eleiminado de Productos_H*/
create trigger tg_EliminaProducto_H
on Productos_H after DELETE
AS
    insert into log_Productos_H(IdProducto,IdCategoria,Precio,Descripcion,Accion ,Fecha_Mod)
    select IdProducto,IdCategoria,Precio,Descripcion,'Eliminado',getdate() from deleted
    
    
 /*Crear tabla de logs de Productos_M*/
 create table log_Productos_M(
	IdProducto int,
    IdCategoria int,
    Precio numeric(10,2), 
    Descripción varchar(100),
    Accion varchar(50),
    Fecha_Mod smalldatetime
)

/*Trigger para la tabla de un producto eleiminado de Productos_M*/
create trigger tg_EliminaProducto_M
on Productos_M after DELETE
AS
    insert into log_Productos_H(IdProducto,IdCategoria,Precio,Descripcion,Accion ,Fecha_Mod)
    select IdProducto,IdCategoria,Precio,Descripcion,'Eliminado',getdate() from deleted
    


/*Trigger producto actualizado*/
create trigger tg_ActualizaProducto_H
on Productos_H after UPDATE
As
    insert into log_Productos_H(IdProducto,IdCategoria,Precio,Descripcion,Accion ,Fecha_Mod)
    select IdProducto,IdCategoria,Precio,Descripcion,'Actualizado',getdate() from inserted
    
    
create trigger tg_ActualizaProducto_M
on Productos_M after UPDATE
As
    insert into log_Productos_M(IdProducto,IdCategoria,Precio,Descripcion,Accion ,Fecha_Mod)
    select IdProducto,IdCategoria,Precio,Descripcion,'Actualizado',getdate() from inserted
    
    
    
    
 /*Log de Clientes*/
create table log_Clientes(
    IdCliente int ,
    Correo varchar(200),
    Nombre varchar(60),
    Direccion varchar(250),
    CodigoPostal int,
    contraseña varchar(100),
    Accion varchar(50),
    FechaMod smalldatetime 
)

/*Trigger de actualizacion de clientes*/
create trigger tg_ActualizaCliente
on Cliente after UPDATE
AS
    insert into log_Clientes (IdCliente,Correo,Nombre,Direccion,CodigoPostal,contraseña,Accion,FechaMod)
    select IdCliente, Correo,Nombre,Direccion, CodigoPostal,contraseña,'Actualizado',getdate() from inserted

/*Trigger de Cliente Eliminado*/
create trigger tg_EliminaCliente
on Cliente after DELETE
AS
    insert into log_Clientes(IdCliente,Correo,Nombre,Direccion,CodigoPostal,contraseña,Accion,FechaMod)
    select IdCliente, Correo,Nombre,Direccion, CodigoPostal,contraseña,'Eliminado',getdate() from deleted
    
 

/*Trigger para tabla de Tickets*/
create table log_ticket(
    IdTicket int ,
    IdCliente int ,
    MetodoPago varchar(100),
    FechaVenta smalldatetime,
    FechaReparto smalldatetime,
    Accion varchar(50),
    Fecha_Mod smalldatetime
)

/*Ticket eliminado*/
create trigger tg_EliminaTicket
on Ticket after DELETE
as 
    insert into log_ticket(IdTicket,IdCliente,MetodoPago,FechaVenta,FechaReparto,Accion,Fecha_Mod)
    select IdTicket,IdCliente,MetodoPago,FechaVenta,FechaReparto,'Eliminado',getdate() from deleted

/*Ticket actualizado*/
create trigger tg_ActualizaTicket
on Ticket after UPDATE
As
    insert into log_ticket(IdTicket,IdCliente,MetodoPago,FechaVenta,FechaReparto,Accion,Fecha_Mod)
    select IdTicket,IdCliente,MetodoPago,FechaVenta,FechaReparto,'Actualizado',getdate() from inserted
