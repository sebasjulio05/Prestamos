create database dbs_simuladorcredito
go
USE [dbs_simuladorcredito]
GO
/****** Object:  Table [dbo].[tbl_solicitudes]    Script Date: 31/08/2023 7:00:23 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_solicitudes](
	[PKItem] [bigint] IDENTITY(1,1) NOT NULL,
	[Id] [varchar](10) NOT NULL,
	[Nombres] [varchar](100) NOT NULL,
	[Apellidos] [varchar](100) NOT NULL,
	[Contacto] [varchar](10) NOT NULL,
	[Correo] [varchar](50) NOT NULL,
	[Direccion] [varchar](60) NOT NULL,
	[Estado] [varchar](50) NOT NULL,
	[Fecha_registro] [date] NOT NULL,
	[Salario] [float] NOT NULL,
	[Observaciones] [varchar](5000) NOT NULL,
	[Empresa] [varchar](100) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[PKItem] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  StoredProcedure [dbo].[SP_registrar]    Script Date: 31/08/2023 7:00:23 p. m. ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author, sebastián julio>
-- Create date: <Create Date, 24 de Agosto del 2023>
-- Nombre SP: 	<Descripttion, registrar crédito>
-- =============================================
create procedure [dbo].[SP_registrar]
@id varchar(10), @nombres varchar(100), @apellidos varchar(100), @contacto varchar(10), @correo varchar(80), @direccion varchar(60), @salario float, @empresa varchar(100), @plazo int, @monto float
as begin
	declare @cap_descuento float
	declare @cuota float
	declare @intereses float
	declare @totalcredito float
	declare @estado varchar(50)
	declare @observaciones varchar(5000)
	select @cap_descuento = @salario *0.70
	if @plazo = 0--6 meses (0.018)
		begin
			select @intereses = @monto * 0.018
			select @totalcredito = @monto + @intereses
			select @cuota = @totalcredito / 6
		end
	if @plazo = 1--12 meses (0.016)
		begin
			select @intereses = @monto * 0.016
			select @totalcredito = @monto + @intereses
			select @cuota = @totalcredito / 12
		end
	if @plazo = 2--24 meses (0.014)
		begin
			select @intereses = @monto * 0.014
			select @totalcredito = @monto + @intereses
			select @cuota = @totalcredito / 24
		end
	if @plazo = 0--6 meses (0.010)
		begin
			select @intereses = @monto * 0.010
			select @totalcredito = @monto + @intereses
			select @cuota = @totalcredito / 36
		end

	--validar estado crédito
	if @cuota <= @cap_descuento
		begin
			select @estado = 'Aprobado'
			select @observaciones = 'Felicitaciones, tu crédito ha sido aprobado con éxito'
		end
	if @cuota > @cap_descuento
		begin
			select @estado = 'Rechazado'
			select @observaciones = 'Tu crédito no ha sido aprobado, intenta nuevamente'
		end
	insert into tbl_solicitudes
	(Id,Nombres,Apellidos,Contacto,Correo,Direccion,Estado,Fecha_registro,Salario,Observaciones,Empresa)
	values
	(@id,@nombres,@apellidos,@contacto,@correo,@direccion,@estado,GETDATE(),@salario,@observaciones,@empresa)
end
		



GO
