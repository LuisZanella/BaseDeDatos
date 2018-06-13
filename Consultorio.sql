CREATE DATABASE ProyectoMedico
USE ProyectoMedico

--REGLA RANGO DE Lista de Valores(REGLA CON LISTA DE VALORES)
CREATE RULE dbo.Prioridad_rule
AS @lista IN('1', '2', '3');
	CREATE TYPE dbo.Prioridad_type FROM [INT] NOT NULL
GO
CREATE DEFAULT dbo.DF_Prioridad
	AS '1'
GO
EXEC sys.sp_bindefault @defname = N'[dbo].[DF_Prioridad]',
	@objname = N'[dbo].[Prioridad_type]',@futureonly='futureonly'
GO

EXEC sys.sp_bindrule @rulename = N'[dbo].[Prioridad_rule]',
	@objname = N'[dbo].[Prioridad_type]' , @futureonly = 'futureonly'
GO
--REGLA RANGO DE Lista de Valores(REGLA CON LISTA DE VALORES)
CREATE RULE dbo.GravedadProblema_rule
AS @lista IN('0', '1', '2', '3','4','5');
	CREATE TYPE dbo.GravedadProblema_type FROM [INT] NOT NULL
GO
CREATE DEFAULT dbo.DF_GravedadProblema
	AS '0'
GO
EXEC sys.sp_bindefault @defname = N'[dbo].[DF_GravedadProblema]',
	@objname = N'[dbo].[GravedadProblema_type]',@futureonly='futureonly'
GO

EXEC sys.sp_bindrule @rulename = N'[dbo].[GravedadProblema_rule]',
	@objname = N'[dbo].[GravedadProblema_type]' , @futureonly = 'futureonly'
GO
--REGLA RANGO DE VALORES Horario
CREATE RULE dbo.Hora_rule
AS @Hora >= 6 AND @Hora <= 21;
	CREATE TYPE dbo.Horario_type FROM [INT] NOT NULL
GO
CREATE DEFAULT dbo.DF_Hora
	AS '21'
GO
EXEC sys.sp_bindefault @defname = N'[dbo].[DF_Hora]',
	@objname = N'[dbo].[Horario_type]',@futureonly='futureonly'
GO

EXEC sys.sp_bindrule @rulename = N'[dbo].[Hora_rule]',
	@objname = N'[dbo].[Horario_type]' , @futureonly = 'futureonly'
GO
--REGLA RANGO DE VALORES CantidadProducto
CREATE RULE dbo.CantidadProducto_rule
AS @Cantidad >=0;
	CREATE TYPE dbo.CantidadProducto_type FROM [INT] NOT NULL
GO
CREATE DEFAULT dbo.DF_CantidadProducto
	AS '0'
GO
EXEC sys.sp_bindefault @defname = N'[dbo].[DF_CantidadProducto]',
	@objname = N'[dbo].[CantidadProducto_type]',@futureonly='futureonly'
GO

EXEC sys.sp_bindrule @rulename = N'[dbo].[CantidadProducto_rule]',
	@objname = N'[dbo].[CantidadProducto_type]' , @futureonly = 'futureonly'
GO
--REGLA CON OPCION GENERO
CREATE RULE dbo.Genero_rule
AS @Genero IN('F', 'M', 'SG');
	CREATE TYPE dbo.Genero_type FROM [NVARCHAR](2) NOT NULL
GO
CREATE DEFAULT dbo.DF_Genero
	AS 'SG'
GO
EXEC sys.sp_bindefault @defname = N'[dbo].[DF_Genero]',
	@objname = N'[dbo].[Genero_type]',@futureonly='futureonly'
GO

EXEC sys.sp_bindrule @rulename = N'[dbo].[Genero_rule]',
	@objname = N'[dbo].[Genero_type]' , @futureonly = 'futureonly'
GO
--REGLA CON OPCION ESTATUS
CREATE RULE dbo.Estatus_rule
AS @estatus IN(1,0);
	CREATE TYPE dbo.Estatus_type FROM [bit] NOT NULL
GO
CREATE DEFAULT dbo.DF_Estatus
	AS '1'
GO
EXEC sys.sp_bindefault @defname = N'[dbo].[DF_Estatus]',
	@objname = N'[dbo].[Estatus_type]',@futureonly='futureonly'
GO

EXEC sys.sp_bindrule @rulename = N'[dbo].[Estatus_rule]',
	@objname = N'[dbo].[Estatus_type]' , @futureonly = 'futureonly'
GO
--REGLA CON PATRÓN NOMBRE
USE TestDB1
CREATE RULE [dbo].[Nombre_rule]
	AS @Nombre NOT LIKE '%[^a-zA-Z]%';
CREATE TYPE dbo.Nombre_type FROM [NVARCHAR](30) NOT NULL
GO
CREATE DEFAULT dbo.DF_Nombre
	AS 'Anónimo'
GO
EXEC sys.sp_bindefault @defname = N'[dbo].[DF_Nombre]',
	@objname = N'[dbo].[Nombre_type]',@futureonly='futureonly'
GO

EXEC sys.sp_bindrule @rulename = N'[dbo].[Nombre_rule]',
	@objname = N'[dbo].[Nombre_type]' , @futureonly = 'futureonly'
GO
--REGLA CON PATRÓN EMPRESA
CREATE RULE dbo.NombreLaboratorio_rule
AS @NameEmpresa NOT LIKE '%[^a-zA-Z0-9]%';
	CREATE TYPE dbo.NombreLaboratorio_type FROM [NVARCHAR](200) NOT NULL
GO
CREATE DEFAULT dbo.DF_NombreLaboratorio
	AS 'Sin Registro de Nombre'
GO
EXEC sys.sp_bindefault @defname = N'[dbo].[DF_NombreLaboratorio]',
	@objname = N'[dbo].[NombreLaboratorio_type]',@futureonly='futureonly'
GO

EXEC sys.sp_bindrule @rulename = N'[dbo].[NombreLaboratorio_rule]',
	@objname = N'[dbo].[NombreLaboratorio_type]' , @futureonly = 'futureonly'
GO



--CREACION DE LA TABLA PERSONA
CREATE TABLE Persona(
	CodigoPersona INT PRIMARY KEY IDENTITY, 	
	Nombre Nombre_type NOT NULL,
	ApellidoP Nombre_type NOT NULL,
	ApellidoM Nombre_type NOT NULL,
	NombreCompleto AS(Nombre + ' ' + ApellidoP+ ' ' + ApellidoM),
	CONSTRAINT UC_Persona UNIQUE (NombreCompleto)
)
GO

--CREACION DE LA TABLA MEDICO
CREATE TABLE Medico(
	CodigoMedico INT PRIMARY KEY IDENTITY,
	CodigoPersona INT NOT NULL FOREIGN KEY REFERENCES Persona(CodigoPersona) ON DELETE CASCADE ON UPDATE CASCADE,
	Consultorio INT NOT NULL,
	CedulaProfesional VARCHAR (30) NOT NULL,
	RegistroSalubridad VARCHAR(30) NOT NULL,
	Estatus Estatus_type,
	CONSTRAINT UC_Cedula UNIQUE (CedulaProfesional)
)
GO
--CREACION DE LA TABLA Vocacion
CREATE TABLE Especialidad(
	CodigoEspecialidad INT PRIMARY KEY IDENTITY,
	Especialidad VARCHAR (100) NOT NULL
)
GO
--CREACION DE LA TABLA VocacionMedico
CREATE TABLE EspecialidadMedico(
	CodigoVocacionMedico INT PRIMARY KEY IDENTITY,
	CodigoMedico INT NOT NULL FOREIGN KEY REFERENCES Medico(CodigoMedico) ON DELETE CASCADE ON UPDATE CASCADE,
	CodigoEspecialidad INT NOT NULL FOREIGN KEY REFERENCES Especialidad(CodigoEspecialidad) ON DELETE CASCADE ON UPDATE CASCADE
)
GO

--CREACION DE LA TABLA PACIENTE
CREATE TABLE Paciente(
	CodigoPaciente INT PRIMARY KEY IDENTITY,
	CodigoPersona INT NOT NULL FOREIGN KEY REFERENCES Persona(CodigoPersona) ON DELETE CASCADE ON UPDATE CASCADE,
	Sexo Genero_type NOT NULL,
	Prioridad Prioridad_type NOT NULL
)
--CREACION DE LA TABLA VISITAS
CREATE TABLE Visita(
	CodigoVisita INT PRIMARY KEY IDENTITY,
	NoVisita VARCHAR(1000)
)
--CREACION DE LA TABLA CITAS
CREATE TABLE Cita(
	CodigoCita INT PRIMARY KEY IDENTITY,
	CodigoPaciente INT NOT NULL FOREIGN KEY REFERENCES Paciente(CodigoPaciente) ON DELETE CASCADE ON UPDATE CASCADE,
	CodigoMedico INT NOT NULL FOREIGN KEY REFERENCES Medico(CodigoMedico) ON DELETE CASCADE ON UPDATE CASCADE,
	CodigoVisita INT NOT NULL FOREIGN KEY REFERENCES Visita(CodigoVisita) ON DELETE CASCADE ON UPDATE CASCADE,
	Fecha DATE NOT NULL,
	Hora Horario_type NOT NULL,
	Costo FLOAT NOT NULL
)
--CREACION DE LA TABLA REGISTROS
CREATE TABLE Registro(
		CodigoRegistro INT PRIMARY KEY IDENTITY,
		CodigoPaciente INT NOT NULL FOREIGN KEY REFERENCES Paciente(CodigoPaciente) ON DELETE CASCADE ON UPDATE CASCADE,
		PeriodoIngesta VARCHAR(30),
		Problema VARCHAR(1000),
		GravedadProblema GravedadProblema_type
)
--CREACION DE LA TABLA LABORATORIOS
CREATE TABLE Laboratorio(
		CodigoLaboratorio INT PRIMARY KEY IDENTITY,
		CodigoLab VARCHAR(200),
		Nombre NombreLaboratorio_type UNIQUE,
		Estatus Estatus_type
)
--CREACION DE LA TABLA PRODUCTOS
CREATE TABLE Producto(
		CodigoProducto INT PRIMARY KEY IDENTITY,
		CodigoLaboratorio INT NOT NULL FOREIGN KEY REFERENCES Laboratorio(CodigoLaboratorio) ON DELETE CASCADE ON UPDATE CASCADE,
		Nombre Nombre_type NOT NULL,
		Cantidad CantidadProducto_type NOT NULL,
		Descripcion VARCHAR(1000)  NOT NULL,
		Categoria Varchar(100)
)
--CREACION DE LA TABLA RELACION PRODUCTO MEDICO
CREATE TABLE MedicoProducto(
		CodigoMedicoProducto INT PRIMARY KEY IDENTITY,
		CodigoMedico INT NOT NULL FOREIGN KEY REFERENCES Medico(CodigoMedico) ON DELETE CASCADE ON UPDATE CASCADE,
		CodigoProducto INT NOT NULL FOREIGN KEY REFERENCES Producto(CodigoProducto) ON DELETE CASCADE ON UPDATE CASCADE,
		FechaIngreso DATE NOT NULL
)
--CREACION DE LA TABLA RELACION REGISTRO PRODUCTO
CREATE TABLE RegistroProducto(
		CodigoRegistroProducto INT PRIMARY KEY IDENTITY,
		CodigoRegistro INT NOT NULL FOREIGN KEY REFERENCES Registro(CodigoRegistro) ON DELETE CASCADE ON UPDATE CASCADE,
		CodigoProducto INT NOT NULL FOREIGN KEY REFERENCES Producto(CodigoProducto) ON DELETE CASCADE ON UPDATE CASCADE,
		CantidadIngresada VARCHAR(1000) NOT NULL
)
--CREACION DE LA TABLA HistorialMedico por Paciente
CREATE TABLE HistorialMedico(
		CodigoHistorialMedico INT PRIMARY KEY IDENTITY,
		CodigoPaciente INT NOT NULL FOREIGN KEY REFERENCES Paciente(CodigoPaciente),
		Edad VARCHAR (100) NULL,
		Estatura VARCHAR (6) NOT NULL,
		Sexo VARCHAR (15) NOT NULL,
		Ocupacion VARCHAR (60) NOT NULL,
		PadecimientoActual VARCHAR (1000) NOT NULL,
		IngestaMedicamento VARCHAR (1000) NOT NULL,
		AntecedenteFamiliar VARCHAR (1000) NOT NULL,
		AntecedentePersonal VARCHAR (1000) NOT NULL
)
GO
-----------------------------------------

INSERT INTO Persona(Nombre,ApellidoM, ApellidoP)
VALUES 	('Laura', 'Contreras','López'),
		('Juan','Barrera', 'Hidalgo'),
		('Rodolfo','Perez','Castro'),
		('Cuellar', 'Atilano', 'Perez'),
		('Regina','Pineda','Gonzales'),
		('Enrique','Viloria','Carpio')

GO

INSERT INTO Medico(CodigoPersona,Vocacion, Consultorio, CedulaProfesional,RegistroSalubridad)
VALUES 		(1,'Medico Bariatra',1,'86278261','9272867' ),
			(2,'Oftalmólogo',2, '32232377','6982977'),
			(3,'Psicólogo',3,  '98181087','2172940'),
			(4,'Dentista',4,'87862102','8743287')
GO
UPDATE Medico
SET CedulaProfesional=''
WHERE CodigoPersona=1
GO
UPDATE Medico
SET RegistroSalubridad=''
WHERE CodigoPersona=1
GO
UPDATE Medico
SET Vocacion=''
WHERE CodigoPersona=1
GO
UPDATE Medico
SET Consultorio=0
WHERE CodigoPersona=1
GO
DELETE 	Medico
FROM Medico
Where CodigoPersona=6
GO

------------------------------------------------------

Select D.CodigoMedico,F.Nombre,F.Cantidad,F.Descripcion,F.Categoria, D.FechaIngreso
FROM MedicoProducto D INNER JOIN Producto F
ON F.CodigoProducto= D.CodigoProducto
GO


------------------------------------------------------
UPDATE Producto
SET Nombre=''
WHERE CodigoProducto=1
GO
UPDATE Producto
SET Descripcion=''
WHERE CodigoProducto=1
GO
UPDATE Producto
SET Cantidad=''
WHERE CodigoProducto=1
GO
------------------------------------------------------
INSERT INTO Paciente(CodigoPersona,Sexo)
VALUES (5,'Femenino'),
		(6,'Masculino')
GO

INSERT INTO Cita (CodigoMedico,CodigoPaciente,CodigoVisita,Fecha,Hora,Costo)
VALUES (1,1,1,'2012-11-11',12.20,300),
		(2,2,2,'2012-11-11',1.20,200),
		(1,2,3,'2012-10-30',5.30,100)
GO
------------------------------------------------------
INSERT INTO Laboratorio(CodigoLab,Nombre)
VALUES ('6482CD','Naturales ARTROM'),
		('7283AR','Escame RITMO'),
		('19s8KF1','Herba Life')
GO
UPDATE Laboratorio
SET Nombre =''
WHERE CodigoLaboratorio=1
GO
UPDATE Laboratorio
SET CodigoLab =''
WHERE CodigoLaboratorio=1
GO
DELETE Laboratorio
FROM Laboratorio
WHERE CodigoLaboratorio=1
GO
------------------------------------------------------
INSERT INTO Persona(Nombre,ApellidoM, ApellidoP)
VALUES 	('Laura', 'Contreras','López'),
		('Juan','Barrera', 'Hidalgo'),
		('Rodolfo','Perez','Castro'),
		('Cuellar', 'Atilano', 'Perez'),
		('Regina','Pineda','Gonzales'),
		('Enrique','Viloria','Carpio')

GO
INSERT INTO Paciente(CodigoPersona,Sexo)
VALUES (5,'Femenino'),
		(6,'Masculino')
GO
-------------------------------------------------------
INSERT INTO HistorialMedico(CodigoPaciente,Edad,Estatura,Sexo,Ocupacion,PadecimientoActual,IngestaMedicamento,AntecedenteFamiliar,AntecedentePersonal)
VALUES (1,'30','1.60','Femenino', 'Abogada','Problemas cardiovasculares y diabetes', '','Problemas cardiovasculares','Ninguno'),
		(2,'24','1.84','Masculino','Albañil','Estrabismo','Ninguno','Ninguno','Ninguno')
GO
-------------------------------------------------------
INSERT INTO Producto(CodigoLaboratorio,Nombre,Cantidad,Descripcion,Categoria)
VALUES	(1,'Alterox','30 tabletas','Sodio,Grasa Monoinsaturada, Grasa Saturada, Acidos Grasos Trans, Goma Acacia Organica','Reductor'),
		(2,'Epefrano','15 tabletas', 'Eritiol,Sal,Goma Xantana, Estevia Organica','Vision'),
		(3,'Sitrasinico','40 tabletas','Cisteina, minerales y creatina','Suplemento Alimenticio'),
		(1,'Penamox','30 tabletas','Ampicilina','Antibiotico')
GO
INSERT INTO Registro(CodigoPaciente,PeriodoIngesta,Problema)
VALUES (1,'15 días', 'Problemas cardiovasculares y diabetes'),
		(2,'7 días', 'Problema de Estrabismo')
GO
INSERT INTO RegistroProducto(CodigoProducto, CodigoRegistro, CantidadIngresada)
VALUES (1,1,'1 tableta cada 12 horas'),
		(2,2,'1 tableta cada 6 horas'),
		(3,2,'1 tableta cada 12 horas')
GO
----------------------------------------------------------
INSERT INTO Persona(Nombre,ApellidoM, ApellidoP)
VALUES 	('Laura', 'Contreras','López'),
		('Juan','Barrera', 'Hidalgo'),
		('Rodolfo','Perez','Castro'),
		('Cuellar', 'Atilano', 'Perez'),
		('Regina','Pineda','Gonzales'),
		('Enrique','Viloria','Carpio')

GO
INSERT INTO Paciente(CodigoPersona,Sexo)
VALUES (5,'Femenino'),
		(6,'Masculino')
GO
INSERT INTO Medico(CodigoPersona,Vocacion, Consultorio, CedulaProfesional,RegistroSalubridad)
VALUES 		(1,'Medico Bariatra',1,'86278261','9272867' ),
			(2,'Oftalmólogo',2, '32232377','6982977'),
			(3,'Psicólogo',3,  '98181087','2172940'),
			(4,'Dentista',4,'87862102','8743287')
GO
INSERT INTO Visita (NoVisita)
VALUES	('1'),
		('2'),
		('3')
GO
INSERT INTO Cita (CodigoMedico,CodigoPaciente,CodigoVisita,Fecha,Hora,Costo)
VALUES (1,1,1,'2012-11-11',12.20,300),
		(2,2,2,'2012-11-11',1.20,200),
		(1,2,3,'2012-10-30',5.30,100)
GO

SELECT J.Nombre AS Paciente, R.Nombre AS Medico, K.NoVisita, Fecha, Hora
FROM Cita D INNER JOIN Medico F
ON D.CodigoMedico = F.CodigoMedico
INNER JOIN Paciente H
ON D.CodigoPaciente = H.CodigoPaciente
INNER JOIN Visita K
ON D.CodigoVisita =  K.CodigoVisita
INNER JOIN Persona R
ON R.CodigoPersona = F.CodigoPersona 
INNER JOIN Persona J
ON J.CodigoPersona = H.CodigoPersona
---------------------------------------------------------------
SELECT SUM (CodigoPaciente) AS 'Numero de visitas'
FROM Cita
WHERE CodigoPaciente=1
---------------------------------------------------------------
DELETE Cita
FROM Cita
WHERE CodigoCita= 1
--------------------------------------------------------------
SELECT Edad,Estatura,D.Sexo,Ocupacion,PadecimientoActual,IngestaMedicamento,AntecedenteFamiliar,AntecedentePersonal, P.Nombre
FROM HistorialMedico D INNER JOIN Paciente H
ON D.CodigoPaciente = H.CodigoPaciente
INNER JOIN Persona P
ON H.CodigoPersona = P.CodigoPersona
--------------------------------------------------------------
SELECT Edad,Estatura,D.Sexo,Ocupacion,PadecimientoActual,IngestaMedicamento,AntecedenteFamiliar,AntecedentePersonal, P.Nombre,R.PeriodoIngesta, I.Nombre
FROM HistorialMedico D INNER JOIN Paciente H
ON D.CodigoPaciente = H.CodigoPaciente
INNER JOIN Persona P
ON H.CodigoPersona = P.CodigoPersona
INNER JOIN Registro R
ON R.CodigoPaciente = P.CodigoPersona
INNER JOIN RegistroProducto C
ON C.CodigoRegistro=R.CodigoRegistro
INNER JOIN Producto I
ON C.CodigoProducto = I.CodigoProducto
-------------------------------------------------------------
SELECT J.Nombre AS Paciente,J.ApellidoM,J.ApellidoP, F.Consultorio AS Consultorio, K.NoVisita, Fecha, Hora
FROM Cita D INNER JOIN Medico F
ON D.CodigoMedico = F.CodigoMedico
INNER JOIN Paciente H
ON D.CodigoPaciente = H.CodigoPaciente
INNER JOIN Visita K
ON D.CodigoVisita =  K.CodigoVisita
INNER JOIN Persona R
ON R.CodigoPersona = F.CodigoPersona 
INNER JOIN Persona J
ON J.CodigoPersona = H.CodigoPersona
-------------------------------------------------------------
INSERT INTO MedicoProducto (CodigoMedico,CodigoProducto,FechaIngreso)

VALUES	(1,2,'2017-10-10'),
		(2,1,'2007-10-15'),
		(3,1,'2010-10-10')
GO
SELECT L.Nombre AS Empresa,P.Nombre AS Producto, MP.FechaIngreso, P.Cantidad, N.Nombre AS Medico
FROM MedicoProducto MP INNER JOIN Producto P
ON MP.CodigoProducto=P.CodigoProducto
INNER JOIN Laboratorio L
ON L.CodigoLaboratorio = P.CodigoLaboratorio
INNER JOIN Medico M
ON M.CodigoMedico = MP.CodigoMedico
INNER JOIN Persona N
ON N.CodigoPersona = M.CodigoPersona
----------------------------------------------------------
SELECT SUM (CodigoCita) AS 'Cantidad de citas'
FROM Cita
WHERE Fecha ='2012-11-11'
----------------------------------------------------------
SELECT SUM(Costo) AS 'Dinero Total Ganado', CONCAT (P.Nombre,'  ' ,P.ApellidoM,'  ', P.ApellidoP) AS 'Nombre del medico'
FROM Cita C INNER JOIN Medico M
ON C.CodigoMedico = M.CodigoMedico
INNER JOIN Persona P
ON M.CodigoPersona = P.CodigoPersona
WHERE Fecha = '2012-11-11'
GROUP BY P.Nombre, P.ApellidoM,P.ApellidoP
GO

-----TRIGGERS TIPO 1
CREATE TRIGGER tgr_TimeCita
ON Cita
AFTER UPDATE
AS 
	BEGIN
		--SET NOCOUNT ON impide que se generen mensajes de texto
		--con cada instrucción
		SET NOCOUNT ON;
		UPDATE Cita SET FechaFinal = GETDATE()
		WHERE CodigoCita = (SELECT CodigoCita FROM inserted)
	END
GO

CREATE TRIGGER tgr_EdadPaciente
ON HistorialMedico
AFTER INSERT
AS 
	BEGIN
		--SET NOCOUNT ON impide que se generen mensajes de texto
		--con cada instrucción
		SET NOCOUNT ON;
		DECLARE @today DATE = CAST(GETDATE() AS DATE)
		DECLARE @idPaciente INT = (SELECT CodigoPaciente FROM inserted)
		DECLARE @bDay DATE = (SELECT FechaNacimiento FROM Paciente WHERE CodigoPaciente = @idPaciente)
		DECLARE @nyears INT = (Select datediff(Year, @bDay, @today) - case When datepart(dayofYear, @today) < datepart(dayofYear, @bDay) Then 1 Else 0)
		UPDATE HistorialMedico SET Edad = @nyears
		WHERE CodigoHistorialMedico = (SELECT CodigoHistorialMedico FROM inserted)
		END
GO


-------PROCEDIMIENTOS ALMACENADOS INSERTS
CREATE PROCEDURE sp_InsertMedico
@Persona VARCHAR(20),
@paterno VARCHAR(20),
@materno VARCHAR(20),
@vocacion VARCHAR(40),
@consultorio INT,
@cedula VARCHAR(30),
@salubridad VARCHAR(30)
AS
	INSERT INTO Persona(Nombre, ApellidoP, ApellidoM)
				 VALUES(@Persona, @paterno, @materno)
	DECLARE @id INT = (SELECT MAX(CodigoPersona) FROM Persona)  
	INSERT INTO Medico(CodigoPersona, Vocacion, Consultorio, CedulaProfesional, RegistroSalubridad)
				VALUES(@id, @vocacion, @consultorio, @cedula, @salubridad)
GO

CREATE PROCEDURE sp_InsertPersona
@Persona VARCHAR(20),
@paterno VARCHAR(20),
@materno VARCHAR(20),
@sexo VARCHAR (15),
@fechaNacimiento DATE
AS
	INSERT INTO Persona(Nombre, ApellidoP, ApellidoM)
				 VALUES(@Persona, @paterno, @materno)
	DECLARE @id INT = (SELECT MAX(CodigoPersona) FROM Persona) 
	INSERT INTO Paciente(CodigoPersona, Sexo, FechaNacimiento)
				  VALUES(@id, @sexo, @fechaNacimiento)
GO

CREATE TYPE ProductoType AS TABLE(
	IdProducto INT,
	Nombre VARCHAR (50) NOT NULL,
	Cantidad VARCHAR(1000) NOT NULL,
	Descripcion VARCHAR(1000) NOT NULL,
	Categoria Varchar(100));
GO

CREATE PROCEDURE sp_InsertLabProducts
@codLab VARCHAR(200),
@nlab VARCHAR(200),
@product ProductoType READONLY
AS
	INSERT INTO Laboratorio(CodigoLab, Nombre)
					 VALUES(@codLab, @nlab)
	DECLARE @IdLab INT
	SET @IdLab=(SELECT MAX(CodigoLaboratorio) FROM Laboratorio)
	INSERT INTO Producto(CodigoLaboratorio, CodigoProducto, Cantidad, Descripcion, Categoria)
	SELECT @IdLab, * FROM @product
GO

-------PROCEDIMIENTOS ALMACENADOS CONSULTA
CREATE PROCEDURE sp_PacientesAtendidosPorMedico
@nombreMedico VARCHAR(20)
AS
	SELECT J.Nombre AS Paciente, HM.Edad AS EDAD, FechaInicio, FechaFinal, Hora
	FROM Cita D INNER JOIN Medico F
	ON D.CodigoMedico = F.CodigoMedico
	INNER JOIN Paciente H
	ON D.CodigoPaciente = H.CodigoPaciente
	INNER JOIN Persona R
	ON R.CodigoPersona = F.CodigoPersona 
	INNER JOIN Persona J
	ON J.CodigoPersona = H.CodigoPersona
	INNER JOIN HistorialMedico HM
	ON H.CodigoPaciente = HM.CodigoPaciente 
	WHERE R.Nombre = @nombreMedico
GO

CREATE PROCEDURE sp_CitasFecha
@fecha DATE
AS
	SELECT SUM (CodigoCita) AS 'Cantidad de citas'
	FROM Cita
	WHERE FechaInicio = @fecha
GO


-------PROCEDIMIENTOS ALMACENADOS CON TRY CATCH
CREATE PROCEDURE sp_InsertMedicoProducto
@idMedico INT,
@idProducto INT,
@fechaingreso DATE
AS
	BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO MedicoProducto(CodigoMedico, CodigoProducto, FechaIngreso)
							VALUES(@idMedico, @idProducto, @fechaingreso)
	COMMIT Transaction
	END TRY
	BEGIN CATCH
		PRINT 'ERROR 415'
		ROLLBACK TRANSACTION
	END CATCH
GO

CREATE PROCEDURE sp_InsertRegistroProducto
@idRegistro INT,
@idProducto INT,
@cantidadIngresada VARCHAR(1000)
AS
	BEGIN TRY
	BEGIN TRANSACTION
		INSERT INTO RegistroProducto(CodigoRegistro, CodigoProducto, CantidadIngresada)
							  VALUES(@idRegistro, @idProducto, @cantidadIngresada)
	COMMIT Transaction
	END TRY
	BEGIN CATCH
		PRINT 'ERROR 69'
		ROLLBACK TRANSACTION
	END CATCH
GO


----------------------------------INSERTS DE PERSONA SIN PROCEDIMIENTO ALMACENADO
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Marco', 'Gerram', 'Grinham');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Cesar', 'Querree', 'Badsworth');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Mason', 'Vittore', 'Melbert');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Westbrooke', 'Buttner', 'Curedell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Barnie', 'Dayne', 'Mattessen');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Micheal', 'Farrier', 'Curmi');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Kelley', 'Jelphs', 'Kliche');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Howey', 'Maldin', 'Longmore');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Blair', 'Cheales', 'Chelnam');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ruy', 'Lambdin', 'Tribe');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Son', 'Gillbanks', 'Sanderson');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Erskine', 'Drohane', 'Bedinn');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Nathan', 'O'' Dooley', 'Quincey');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Obed', 'De Bischof', 'Ohm');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Saul', 'Bewlay', 'Stobo');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Bone', 'McCaig', 'Gunda');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Grantham', 'Ginman', 'Craxford');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ikey', 'Byneth', 'Hundy');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Shaw', 'Mealing', 'Pester');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Vladamir', 'MacFadin', 'O''Dee');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Elijah', 'Cowle', 'Youngman');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Robby', 'Dinesen', 'Paradyce');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Neal', 'Lee', 'Mariel');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Alexandro', 'McKaile', 'Edmondson');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Luce', 'Coldbreath', 'Stirley');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Eal', 'Lynch', 'Esslemont');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Wendel', 'Turnbull', 'Stammer');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Anatole', 'Vauls', 'Hibbart');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Lin', 'Ternouth', 'O''Currane');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Lodovico', 'Bragger', 'Dayborne');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gerald', 'Destouche', 'Hold');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Skipton', 'Stoneley', 'Gutman');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Donavon', 'Rearden', 'Smails');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rouvin', 'Andrivot', 'Alforde');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hardy', 'Stalley', 'Breen');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Billy', 'Carden', 'McGerr');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Patrice', 'Van Hove', 'Tapscott');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Burk', 'Gladtbach', 'Kenefick');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Karlens', 'Ridehalgh', 'Lequeux');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Guido', 'Scarce', 'Boydell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Tannie', 'Matthai', 'Swate');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Fabiano', 'Fielding', 'Duggleby');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Alfonse', 'Hallaways', 'Kirke');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Corbet', 'Spruce', 'Cookney');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Henry', 'Conklin', 'Scourfield');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jesus', 'Dugue', 'Sutheran');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Roi', 'Lehmann', 'Moverley');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Felic', 'Vint', 'Dudek');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Fairleigh', 'Tutt', 'Cornilli');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Woody', 'Redmond', 'de Nore');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Barty', 'Bultitude', 'Gullam');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Menard', 'Ludmann', 'Studdal');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Davin', 'Buglass', 'Jenk');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Alick', 'Stredwick', 'Gunthorp');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Freedman', 'Silveston', 'Goddman');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Monro', 'Porson', 'Pietrusiak');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ingra', 'Langmuir', 'Richmont');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Robert', 'Monck', 'Calf');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Amble', 'Yokelman', 'Gaucher');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Renato', 'Gutcher', 'Arrington');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Allyn', 'Arnopp', 'Godber');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Vern', 'Zellick', 'Knoller');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Stuart', 'Bains', 'Poytres');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Wade', 'Palk', 'Lovewell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Svend', 'Matchett', 'Urwin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Duffy', 'Lakenden', 'Tott');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rustie', 'Fisbburne', 'Tilling');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gabby', 'Summerside', 'Denning');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Marc', 'Bartolomivis', 'Rustedge');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rutger', 'Blowing', 'Hullin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Guthrie', 'Henlon', 'Hobgen');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ev', 'Kassidy', 'Treadwell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Douglas', 'Shelbourne', 'MacLaig');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jone', 'Nielson', 'Pursehouse');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Aharon', 'Woolvett', 'Nicely');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Svend', 'Totterdill', 'Behling');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Anatole', 'Megson', 'Faithfull');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Oby', 'Asipenko', 'Doddrell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Myrvyn', 'Birbeck', 'Jarrelt');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Efren', 'Sherrum', 'Scud');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Henrik', 'Ysson', 'Brydson');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ewell', 'McKenzie', 'Allitt');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Dietrich', 'McTurk', 'Hayton');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Marsh', 'Poli', 'Tremblot');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Kippie', 'Elles', 'Letessier');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Trey', 'Gaylord', 'Dack');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Igor', 'Oldall', 'Kenchington');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Bondie', 'Sharma', 'Fitzpayn');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Loydie', 'Walls', 'Livick');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Saunderson', 'Beardall', 'Hamshere');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Vergil', 'Yaakov', 'Gouldstone');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Keith', 'Alywen', 'Farncombe');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Parnell', 'Hannen', 'Crewes');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Timmie', 'Bearblock', 'Girdler');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Thaine', 'Keogh', 'Gunnell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Michal', 'Nuzzti', 'Cummungs');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Darrel', 'Turner', 'Cessford');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Desmund', 'Ivetts', 'Wadsworth');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Olivier', 'Wandrey', 'Pagon');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rand', 'Birkett', 'Sherwell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Cleve', 'Scougall', 'Passo');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Julius', 'Tams', 'Krammer');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Dex', 'Cussons', 'Woolhouse');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Manolo', 'Tobias', 'Lepoidevin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Marcos', 'Skillanders', 'Dutteridge');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Karlik', 'Miranda', 'Trime');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Sansone', 'Thorold', 'Dobrowski');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Beauregard', 'Cobby', 'Pymer');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Tobiah', 'Hundal', 'Crellim');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Sherman', 'Canto', 'Warwick');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Andonis', 'Boffey', 'Screech');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Aaron', 'Scutt', 'Tummons');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ben', 'Kuhlmey', 'Basnett');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Mario', 'Rosoman', 'MacDonough');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Isidoro', 'Begent', 'Padden');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Saxe', 'Telezhkin', 'Feige');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Tristan', 'Hakes', 'Derrick');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Lionello', 'Laneham', 'Catterick');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Berty', 'McGrale', 'Dongles');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Zacharia', 'Duffin', 'Drewes');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Wood', 'Banaszewski', 'Erni');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Moses', 'Stanyard', 'Dashkovich');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Falito', 'Kopecka', 'Caiger');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Leonid', 'Pipworth', 'Mintoff');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Desi', 'Mutter', 'Andrichak');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Donny', 'Roadnight', 'Iacovo');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Meir', 'Barti', 'Signorelli');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Royce', 'Krahl', 'Terbrugge');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gardner', 'Wyld', 'Cavee');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Berkly', 'McMonnies', 'Grigaut');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Pietrek', 'Daud', 'Mutch');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hadleigh', 'McConachie', 'Tunnick');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Brennen', 'Ioselevich', 'Faull');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Bat', 'Duligall', 'Gristock');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Emmett', 'Teacy', 'Feria');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Noby', 'Wheeler', 'Bartlam');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jarrad', 'Kilday', 'Brunone');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jeremiah', 'Grivori', 'O''Dyvoie');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rod', 'Glanton', 'Gockelen');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Filmer', 'Boggs', 'Comerford');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Claus', 'McCumskay', 'Hagger');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Chaim', 'Levermore', 'Belt');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rochester', 'Crim', 'Nanninini');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Willey', 'Penson', 'Vasenkov');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Cornell', 'Ninotti', 'O''Day');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Eric', 'Skittles', 'Fayerbrother');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Franzen', 'Challenor', 'Serfati');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Orbadiah', 'Kewley', 'Girauld');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Carly', 'Standing', 'Blenkiron');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Garv', 'Stirton', 'Berth');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Keene', 'Strelitz', 'Novotna');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Wes', 'Swigger', 'O''Lagen');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Guntar', 'Shatford', 'Wymer');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Chris', 'O''Fogerty', 'Skentelbury');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Boot', 'Jenoure', 'Rimes');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Coop', 'Hasley', 'Barrim');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Robbie', 'Scholfield', 'Widdocks');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Mayne', 'Ide', 'Crowhurst');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Roland', 'Randalston', 'McGillicuddy');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Malachi', 'Layfield', 'Blaker');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Urson', 'Weyland', 'Rutherforth');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hoyt', 'Beade', 'Chifney');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Chev', 'Rechert', 'Whitton');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Waylen', 'Valiant', 'Glewe');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Clemmie', 'Wolstencroft', 'Dadd');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Cole', 'Meaking', 'Lanham');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Koenraad', 'Tarburn', 'Davers');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Roderic', 'Varey', 'Sutter');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Adrien', 'Cogan', 'Borell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ozzy', 'Faas', 'Woodcroft');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Aldus', 'Keedwell', 'Niemiec');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Archambault', 'Grishukov', 'Cattemull');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Pall', 'Riglesford', 'Hewson');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Bradley', 'MacEvilly', 'Quigley');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Willis', 'Dandison', 'Eldin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Simmonds', 'Wareham', 'Gumme');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Dex', 'Broadhead', 'Puddicombe');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Sammie', 'Byass', 'Mertel');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Luther', 'Silmon', 'Brann');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Olav', 'Beardon', 'Abbess');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hermie', 'Prier', 'Kunzel');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Smith', 'Keets', 'Griniov');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Harper', 'Szymon', 'Campo');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Antoine', 'Forty', 'Fearnley');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Clemmie', 'Moorman', 'Gumbrell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Evelyn', 'Robun', 'Kenwin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Alwin', 'Roden', 'Purle');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Avery', 'MacDiarmid', 'Yakushkev');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Alessandro', 'Nockolds', 'Merkel');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Georg', 'cornhill', 'Gorusso');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gawen', 'Braddon', 'Andrieux');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Fulton', 'Craddy', 'Brotheridge');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Mitchel', 'Taggart', 'Tomaszek');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Torr', 'Brewitt', 'O'' Mullane');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gage', 'Minear', 'Jacobssen');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Kipper', 'Ollivierre', 'Sebire');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Stanton', 'Winkworth', 'Pabelik');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hagen', 'Libbey', 'Cashen');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Caesar', 'Donner', 'Rehme');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ozzy', 'Babalola', 'O''Kielt');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Zach', 'Cratere', 'Halsho');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Napoleon', 'McLean', 'Sarten');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Asa', 'Normanvill', 'Dundredge');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ulick', 'Rotte', 'Bartelli');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Clyve', 'Ongin', 'Guwer');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Darby', 'Escot', 'Sansom');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Benji', 'Romao', 'Witherbed');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gottfried', 'Giordano', 'Ledley');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Husain', 'Althorp', 'Menere');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Urbain', 'Browell', 'Brummell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Lowell', 'Godby', 'Yokelman');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Shurlock', 'Brockett', 'Beckley');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Fredek', 'Narup', 'Gillet');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Verney', 'Ivan', 'Broose');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Claudian', 'Gozzett', 'Perse');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rawley', 'Gabites', 'Izakovitz');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Tades', 'Guinan', 'Georghiou');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Sigismund', 'Finnemore', 'Lanmeid');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Bronson', 'Morrid', 'Britee');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Clark', 'Markie', 'Becker');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Herschel', 'O''Hagan', 'Foulcher');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Drake', 'Dwyr', 'Mincher');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Alley', 'Dring', 'Shoosmith');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Bondy', 'Erwin', 'Stuther');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Engelbert', 'Povey', 'Davidescu');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jamill', 'Deaton', 'Curle');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Noah', 'McClintock', 'Empleton');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hamilton', 'Stanlack', 'Malkin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Curtice', 'Britee', 'Stroton');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rudolph', 'Bolzen', 'Shearme');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Chrotoem', 'Bourgeois', 'Lasseter');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Abram', 'Trimbey', 'Peddel');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gregor', 'Santhouse', 'Trenholm');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Tobie', 'Vila', 'Kubyszek');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rodrick', 'Jacquet', 'O''Drought');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Burk', 'Aloshikin', 'Oneill');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Eamon', 'Priel', 'Stott');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Melvin', 'Grafom', 'Olenov');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Evelin', 'Fetherby', 'Ranyell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Xerxes', 'Pund', 'Vauter');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Eadmund', 'Chamberlain', 'Edgell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Dalis', 'Rayment', 'Grovier');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Daven', 'Conti', 'Pembry');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jeremy', 'Binne', 'Girdwood');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ferguson', 'Franciotti', 'Ledington');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Evyn', 'Burgher', 'Totton');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Aurthur', 'Troup', 'Enderby');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Linus', 'Quayle', 'Crottagh');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Mano', 'Hare', 'Loveday');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Anderson', 'Giacopello', 'Blackey');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Skipton', 'McCaughan', 'Naper');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Nickolaus', 'Gunthorpe', 'Applebee');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Iain', 'Faithfull', 'Wakeman');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gaile', 'Wildey', 'Scrigmour');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Norrie', 'Vlasov', 'Brideau');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Tab', 'Larham', 'Huckel');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Karel', 'Le Clercq', 'Storrock');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Elvin', 'Margrem', 'Kleinlerer');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Val', 'Paynter', 'Sawfoot');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Lombard', 'Lynskey', 'Doag');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gav', 'Fairpool', 'Poytress');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Obadiah', 'Domeney', 'Garrat');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Iago', 'Dewdeny', 'Bishopp');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Orion', 'Ellissen', 'Currum');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Mathias', 'Karchewski', 'Delahunt');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Archie', 'Hutchason', 'Horbart');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Leroi', 'Stratford', 'Philbrick');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jacques', 'Eaves', 'Clitsome');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Averil', 'Wyd', 'Crammy');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Phillipp', 'Thorwarth', 'Bagnold');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Fernando', 'Phair', 'D''Almeida');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Craggy', 'Doggett', 'Bimrose');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ricki', 'Millea', 'Bullingham');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Shep', 'Ragbourn', 'Beecham');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Elihu', 'Coudray', 'Spary');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Devlen', 'Krysztowczyk', 'Atkin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Christopher', 'Priditt', 'De la croix');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Chrotoem', 'Hiseman', 'Clace');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Frazier', 'Son', 'Swalteridge');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Moritz', 'Tunder', 'Gideon');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Bendix', 'Temporal', 'Davsley');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ludvig', 'Tredger', 'Bichard');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Harv', 'Jarrelt', 'Daubney');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Powell', 'Ughetti', 'Tiller');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Harold', 'Biaggelli', 'Franklen');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Sergio', 'Merrywether', 'Purches');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Mateo', 'Ploughwright', 'Iles');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Forbes', 'Dane', 'Theunissen');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Edwin', 'Ibell', 'Franzini');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Derry', 'Strainge', 'Deam');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hubey', 'Denton', 'Nann');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Erhart', 'Ancliffe', 'Reddle');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Edan', 'Leetham', 'Claxson');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Frants', 'Lebarree', 'Aizikov');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Avigdor', 'Germain', 'Navaro');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Sebastien', 'Fawke', 'Bolderson');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Franklin', 'Doggart', 'Blowing');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Curt', 'Tomalin', 'Cornall');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Kristoffer', 'Gorring', 'Streat');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Scot', 'Keywood', 'Champken');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Massimo', 'Lawey', 'Leinthall');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Keir', 'Macieja', 'Okell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gearalt', 'Danford', 'Roby');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Elliott', 'Batsford', 'Bolsteridge');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Peterus', 'Handaside', 'Winsom');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Agustin', 'Scohier', 'Spurdle');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Eddy', 'Dickin', 'Wellard');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hiram', 'Carah', 'Breton');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Keane', 'Duny', 'Vahl');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rickey', 'Oxenden', 'Maulkin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Yancy', 'Longhorne', 'McGhie');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jarid', 'Kelf', 'Spiers');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Davidde', 'Crunkhurn', 'Sapshed');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Winslow', 'Mulderrig', 'Waldrum');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Culley', 'Jeakins', 'Marian');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Etienne', 'Lasselle', 'Stoker');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Costa', 'O''Shiels', 'Clayfield');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Obediah', 'Death', 'Washbrook');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Prentiss', 'Kelf', 'Winscum');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Antin', 'Merigeau', 'Snassell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Dagny', 'Kemell', 'Stammers');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rutherford', 'Wintour', 'Gwyther');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Courtnay', 'Dungate', 'Jonin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Johnathan', 'Nickolls', 'Andrich');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Skell', 'Drioli', 'Lasty');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ryon', 'McGeown', 'Domotor');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Antony', 'McKee', 'Licciardiello');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Port', 'Bleacher', 'MacNelly');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Alexandr', 'Hamments', 'Dooman');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Justinian', 'Rabley', 'Pettipher');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gay', 'Swarbrick', 'Gelardi');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Willdon', 'Placide', 'Yakovlev');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Mal', 'Barstowk', 'Teesdale');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Fabio', 'Heersma', 'Brauns');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Arte', 'Hryncewicz', 'De''Ath');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Lowell', 'Beadles', 'Menure');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Patsy', 'Watson-Brown', 'Yea');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Clementius', 'Pachmann', 'Ickovici');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Benn', 'Bradwell', 'Monckton');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Kendrick', 'Bendon', 'McMichael');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Wat', 'Bambury', 'Cressingham');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Eugenio', 'Furphy', 'Lauxmann');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Abner', 'Jakubczyk', 'Donnachie');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Orlando', 'Methley', 'Maryin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Otis', 'Giroldi', 'Baike');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Silvano', 'Coulsen', 'McNirlan');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Davon', 'Verlander', 'Stovell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ancell', 'Burnet', 'Feehan');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Bordy', 'Ellse', 'Josephson');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ignatius', 'Morot', 'Melarkey');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jacques', 'Lord', 'Jonsson');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Sonny', 'Kettridge', 'Stanman');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Joe', 'Stanmer', 'Peart');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Reinaldos', 'Janikowski', 'Syne');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Flem', 'Antal', 'Royan');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Peadar', 'Henrys', 'Melendez');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Bronnie', 'Son', 'Tipple');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Osborne', 'Bernot', 'Garr');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Augustin', 'Delamere', 'Greenly');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Alistair', 'Maudling', 'Lawrenson');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Grant', 'McGoogan', 'Gianolo');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Nolan', 'Linbohm', 'Andres');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Morgen', 'Woolston', 'Ilbert');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Darrin', 'Canland', 'Wallbank');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Otis', 'Padden', 'Dunstan');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Holden', 'Gason', 'Mussolini');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Johannes', 'Stolz', 'Lampard');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Antoine', 'Housin', 'Gabbitus');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Armin', 'Valasek', 'Carrigan');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Pebrook', 'D''Hooge', 'Ferber');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Horton', 'Saxby', 'Kas');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Caldwell', 'Northall', 'Feechan');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Boris', 'Commander', 'Passey');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Inger', 'Glaister', 'Goldsberry');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Chariot', 'Whymark', 'Melburg');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Berky', 'Redgate', 'Arnaut');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Nehemiah', 'Nelissen', 'Bedell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Albert', 'Halley', 'Grisdale');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Arron', 'Stanyon', 'Holme');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Fabian', 'Babalola', 'Barringer');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Alfons', 'Gerard', 'Chaff');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hunfredo', 'Ventura', 'Ecclestone');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Pincus', 'Barradell', 'Shoobridge');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Malvin', 'Duffer', 'Bourdice');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Armando', 'Ridpath', 'Gingold');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Corby', 'Starsmore', 'Ebbles');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Osmond', 'Rait', 'Starkey');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Shepard', 'Eyckelbeck', 'Gartin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Dorie', 'Seedhouse', 'Grayshan');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Fransisco', 'Jaques', 'Veillard');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Eamon', 'Silk', 'Matches');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Granthem', 'Fullard', 'Johansen');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Fairleigh', 'Ferreira', 'Swinburn');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Curr', 'Wiles', 'Normanton');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Stefan', 'Geertsen', 'Haggart');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Massimiliano', 'Quinlan', 'Kynson');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Maxie', 'Loudwell', 'Briskey');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Borg', 'Lumsdall', 'Rintoul');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Eduardo', 'Omar', 'Killik');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gasparo', 'Millam', 'Worvill');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Liam', 'Billanie', 'Jenne');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Tobias', 'Segrott', 'Abbotts');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Inigo', 'Cops', 'Alderwick');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Aristotle', 'Swine', 'Hamerton');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Bank', 'Moscon', 'Celle');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Wood', 'Derham', 'Wasson');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Burch', 'Minghi', 'Bollini');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Chrissie', 'Caghan', 'Cockerham');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Myron', 'Willox', 'Dikes');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Desi', 'Bogeys', 'Lodo');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Cross', 'Langstone', 'Davage');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Homerus', 'Eary', 'Demageard');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Garrard', 'Alesin', 'Gallimore');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Armando', 'Dregan', 'Ranvoise');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Abbey', 'Stinchcombe', 'Notman');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Solomon', 'Bru', 'Josefovic');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ethelred', 'Phythian', 'de Quesne');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Xever', 'Comiam', 'Stubbert');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Sherlocke', 'Chatenet', 'Najera');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gunter', 'Checchetelli', 'Ingles');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rowland', 'Swinglehurst', 'Burkinshaw');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Toddie', 'Besnard', 'Hembling');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Dael', 'O''Dowling', 'Jasper');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Bay', 'Poppy', 'Shipsey');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Maurits', 'Dominicacci', 'Everil');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Tymon', 'Wilbraham', 'Renowden');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Elvis', 'Gartell', 'Willeman');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Josias', 'Chittenden', 'Maciocia');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hanan', 'Engeham', 'Blackadder');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Trip', 'Benallack', 'Pither');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Murdock', 'Torricella', 'Ashard');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Kerr', 'Heinecke', 'Serot');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Eustace', 'Vivers', 'Obispo');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Stearn', 'Fuentez', 'Hebditch');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ambrosio', 'Joule', 'Blancowe');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jonathan', 'Bellas', 'Raddenbury');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Delbert', 'Kingzet', 'Muzzall');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Kearney', 'Ferencowicz', 'Inman');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Shaun', 'Fielden', 'Gulston');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Geri', 'Sambals', 'Tayler');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Tyrone', 'Wegener', 'McAnalley');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Arie', 'Eby', 'de Marco');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jone', 'Fosdike', 'Aldin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Eldredge', 'Blount', 'Thornebarrow');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Chas', 'Yokelman', 'Clethro');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Roth', 'Boucher', 'Alben');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Herbert', 'Silkstone', 'Michiel');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Wilbert', 'Feldhammer', 'Simeonov');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Feodor', 'Threadkell', 'Fasham');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Merrel', 'Patman', 'Guildford');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Felic', 'Woodnutt', 'Posthill');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Elmo', 'Ferrelli', 'Luten');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Erwin', 'Lortzing', 'Garcia');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Conrade', 'Lawley', 'Masdin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Mario', 'Pesek', 'Frankling');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Nataniel', 'Gegay', 'Matchell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Harper', 'Ashness', 'Tax');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rhett', 'Looby', 'Lambourn');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Demetrius', 'Purvess', 'Coast');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Killian', 'Norkett', 'Kiggel');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Lockwood', 'Hagergham', 'Rignold');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Christoffer', 'Murrow', 'McTrustey');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Johann', 'Dusting', 'Barkes');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Wilmar', 'Cajkler', 'Blayney');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Derwin', 'Buffin', 'Hawkswood');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ossie', 'Fitzjohn', 'Wimp');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Cirilo', 'Iley', 'Ambrozik');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Danya', 'Eunson', 'Bispham');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ron', 'Chiverstone', 'MacDearmaid');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ahmed', 'Trimble', 'Dmitrichenko');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Farley', 'Lackner', 'Barrar');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rainer', 'Tomczak', 'Blagden');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Vasily', 'Garrattley', 'Niaves');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Harlen', 'Aleso', 'Dulanty');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Joseph', 'Edgeon', 'Gipps');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Nowell', 'Wolfenden', 'Ellams');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Duffie', 'Emig', 'Corstan');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Balduin', 'Lambertini', 'Gannan');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Auberon', 'Soltan', 'Juhruke');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Walton', 'Keppy', 'Honniebal');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Kenyon', 'McIleen', 'O''Henecan');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Seumas', 'Themann', 'Cutmere');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Peyton', 'Arnauduc', 'Roselli');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jae', 'Exall', 'Esterbrook');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ruben', 'Chaters', 'Oyley');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Alley', 'Durnill', 'Harnor');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Alley', 'Fraine', 'Ofer');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Paolo', 'Ladley', 'Sigart');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Markus', 'Pentycross', 'Samworth');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Joaquin', 'Badsworth', 'Winsborrow');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Lorne', 'Janek', 'Parcells');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hayden', 'Littledike', 'Duce');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Aland', 'Suddell', 'Surphliss');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Sloan', 'Dibbert', 'Ollet');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Barry', 'Kinnach', 'Bonson');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Foss', 'Pottage', 'Moorman');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ewart', 'Haselden', 'Lenthall');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Montague', 'Switzer', 'Criple');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Raul', 'Drysdale', 'O'' Mara');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ganny', 'Arbor', 'Sangwin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Skelly', 'Leet', 'Gordon-Giles');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Barret', 'Dumigan', 'Darkott');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Waylan', 'De Gregorio', 'Nolot');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jehu', 'Domingues', 'Feifer');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Waite', 'Edden', 'Lamasna');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hilarius', 'Stacy', 'Grinsted');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Marmaduke', 'Abramowitch', 'Delete');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Allard', 'Townend', 'Finley');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Arman', 'Breadmore', 'Tippell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Zachary', 'Blandamere', 'Grigoli');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Colman', 'Overton', 'Iohananof');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Broderick', 'Hutchence', 'Woodlands');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hughie', 'Gottelier', 'Pughe');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Araldo', 'Coggen', 'Ancketill');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Nicolas', 'Clementel', 'Matuszewski');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Puff', 'Backwell', 'Grisenthwaite');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Teodoor', 'Housley', 'Trattles');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Abrahan', 'Nieass', 'Pundy');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Riobard', 'Olenchenko', 'Bazek');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Fonsie', 'Honnan', 'Corish');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Chauncey', 'Rosel', 'Stiffkins');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Niven', 'Muglestone', 'Stuart');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Lorrie', 'Gallagher', 'McGiffie');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ev', 'Heritege', 'Kleinmann');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ambrosio', 'Marquiss', 'Tadman');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Galvin', 'MacGhee', 'Durram');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Sigismundo', 'Bilverstone', 'Peasegood');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Burlie', 'Dyet', 'Faiers');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Bartram', 'Asman', 'Guiett');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Tadeas', 'McColm', 'Bermingham');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gawen', 'Gentsch', 'Lodewick');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Windham', 'Hynes', 'Pennetta');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Conway', 'O''Glessane', 'Bencher');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Justis', 'McVeigh', 'Carthy');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Addison', 'Welham', 'Glowacki');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Garold', 'Jewess', 'Dwelling');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Malachi', 'Cready', 'McCudden');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Serge', 'Gofton', 'Edsall');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Sim', 'Stampfer', 'Fulford');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Lyon', 'Goodwell', 'Tullett');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Vergil', 'Castagna', 'Arnaudot');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gaby', 'Hatwell', 'Francescozzi');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Bjorn', 'Pinn', 'Biddy');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Benedict', 'Swayte', 'Greim');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Osbert', 'Baker', 'Brigstock');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Fonz', 'Purdon', 'O''Hallagan');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Edgard', 'Strelitzki', 'Hammand');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Kelvin', 'Ness', 'Twell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gannie', 'Byrd', 'Seggie');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Raymond', 'Mellsop', 'McRitchie');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rubin', 'Georgiev', 'Atger');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Sauncho', 'Haggett', 'Lavall');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Brennen', 'Henricsson', 'Bayman');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Port', 'Spooner', 'MacGinlay');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Connie', 'Scarse', 'Pervew');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Abdul', 'Willment', 'Cicchinelli');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Godwin', 'Ottey', 'Petrichat');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Issiah', 'Mellmoth', 'Costa');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Mikel', 'Scaysbrook', 'Relph');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Morrie', 'Orleton', 'Felgat');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Callean', 'Whorlow', 'Beaty');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Pall', 'Lyne', 'Ross');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Konstantine', 'Quinby', 'Canceller');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Andrew', 'Neissen', 'Laverenz');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Man', 'Stannett', 'Cadlock');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Dietrich', 'Galpen', 'Jackett');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Bent', 'Ireson', 'Lockhart');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Kasper', 'Prandin', 'Gillani');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Antonio', 'Corradetti', 'Widger');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gene', 'Simonyi', 'Chattaway');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Quincey', 'Gobbett', 'McEvilly');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Georgy', 'Fairfoul', 'McKernon');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Yvon', 'Antonin', 'Kenrick');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Kerwinn', 'Hancell', 'Crennan');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jammal', 'Braddick', 'Daud');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Josias', 'Rominov', 'Groven');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Birch', 'Ledger', 'Kleanthous');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Broderick', 'Blockey', 'Kropach');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Emmery', 'Woodyer', 'Deboo');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hamish', 'Dine-Hart', 'O''Fergus');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Nye', 'Legrave', 'Margaritelli');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Saleem', 'Liggins', 'Goracci');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Saunders', 'Gwinnel', 'Woodworth');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Cord', 'Kiebes', 'Pude');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Armstrong', 'Noton', 'Boughey');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Antin', 'Vitler', 'Rowdell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Siegfried', 'Feveryear', 'Hutley');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Alexander', 'Bickers', 'Beadon');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ryley', 'Sterman', 'Cowoppe');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Tedmund', 'Wordsworth', 'Tanner');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ikey', 'Watt', 'Martin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Christian', 'Jebb', 'Tebbit');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Spenser', 'Cage', 'Jakobsson');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Godard', 'Antonio', 'Cran');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Mendel', 'Athey', 'Rickford');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Crawford', 'Dubock', 'Slyne');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jamie', 'Lilywhite', 'Bogeys');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Barton', 'Vesty', 'Pyper');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Lamond', 'Bockmann', 'Aspinwall');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hillard', 'Trimble', 'Bale');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Lazare', 'Kell', 'Davoren');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Huntley', 'Callister', 'Primmer');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Randall', 'Ferreiro', 'Shuttell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Mohandas', 'Bettenson', 'Marie');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Erik', 'Lyddy', 'Vanne');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Billie', 'Gaylard', 'Iseton');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Niki', 'Kelso', 'O''Loghlen');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Roderick', 'Wroughton', 'Woodwind');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gonzales', 'Parlett', 'Creggan');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Matty', 'Sindall', 'Klaiser');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ivar', 'Smalecombe', 'Chessill');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Johannes', 'Reader', 'Drew');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Morrie', 'Coyle', 'Slowly');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Brander', 'Allsep', 'Halligan');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Isidore', 'Vivers', 'Kynge');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Chicky', 'Wilman', 'Guerin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Friedrich', 'Clapham', 'Duffet');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Marven', 'Crallan', 'Ashpole');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Aldwin', 'Wyse', 'Daulton');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Brien', 'Kirby', 'Dene');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Anatole', 'Prestie', 'Riping');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Addison', 'Lanning', 'Honywill');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Byrann', 'Simonian', 'Leipoldt');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Otho', 'Prover', 'Shevill');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Kaspar', 'Elster', 'Moodycliffe');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Roddy', 'Dmytryk', 'Hadlee');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Willi', 'Murname', 'O''Gleasane');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Graham', 'Crollman', 'Kilmary');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Roman', 'Ounsworth', 'Code');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Papageno', 'Blenkinsopp', 'Hug');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Marlowe', 'Darracott', 'Revan');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gabbie', 'Breeze', 'Tieman');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Mace', 'Hurton', 'Tanton');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Abraham', 'Handrik', 'Kefford');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Chandler', 'Khidr', 'Harling');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ogdon', 'Simoncini', 'Gath');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Tudor', 'Kittley', 'Nutton');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Agustin', 'Tejero', 'Millichip');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Dick', 'Peachey', 'Krink');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Shepherd', 'Hayth', 'Guiu');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rossie', 'Dodworth', 'Indge');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Roderick', 'Pierri', 'Clabburn');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Finn', 'Tremblot', 'Hynd');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Noland', 'McLaren', 'Klimus');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Eugenio', 'Greensmith', 'Jewiss');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Francesco', 'Wingrove', 'Diggell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Talbert', 'Macconachy', 'Andrin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gram', 'Mesnard', 'Ciccottio');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Mandel', 'Rothert', 'Kunath');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Lazare', 'Reppaport', 'Ledrane');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Demott', 'Christoffels', 'Glenton');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Floyd', 'Stait', 'Filippo');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Wernher', 'Conichie', 'Edlyn');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Allard', 'Maharry', 'Redmire');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Myrvyn', 'Castana', 'Crosser');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Chase', 'Paddington', 'Madelin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Page', 'Paute', 'Gurr');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Cletus', 'Tutchener', 'Bernat');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Bradly', 'Shepperd', 'Dows');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Duke', 'Paty', 'Rosewarne');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Boniface', 'Clarkson', 'Ashbe');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hilario', 'Winters', 'Janew');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Bernarr', 'Voak', 'Iannini');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Godart', 'Gillitt', 'Ortega');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Tabb', 'Mullany', 'Minerdo');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Johann', 'Shilito', 'Scarsbrook');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Mikkel', 'Bratton', 'Ferenc');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Olivero', 'Gostling', 'Calloway');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Austin', 'Benbrick', 'Firpi');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Cosimo', 'Kohtler', 'Johanning');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Wright', 'Morford', 'Jakoviljevic');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Lauren', 'Lissandrini', 'Camacho');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Vail', 'Warbey', 'Paley');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jeramey', 'Itscowicz', 'Trattles');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Chrisy', 'Pendlebury', 'Mardlin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Frazier', 'Rudall', 'Andreasson');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Bendick', 'Lorenzetti', 'Bickford');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hurlee', 'Smallsman', 'Marques');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Thane', 'Danton', 'Mizzi');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Archy', 'Woolforde', 'Gwatkin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Portie', 'Tudhope', 'Brimham');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Roddy', 'Menure', 'Jedryka');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Grenville', 'Cockayne', 'Fevier');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Keven', 'Teague', 'MacRedmond');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Donnell', 'Loughton', 'Smullin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Frazer', 'Shepton', 'Shay');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Siegfried', 'Dudill', 'Kyllford');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Dalt', 'Alderson', 'Topping');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Sigfried', 'Raynard', 'Izchaki');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Paige', 'Girodin', 'Lippiett');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Durand', 'Dict', 'Gillebride');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Izak', 'Ellington', 'Brunini');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gilbert', 'Abotson', 'Rotchell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Fidole', 'Mourton', 'Philipet');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Nicky', 'Hargraves', 'Lill');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Geoffrey', 'Mannin', 'Woolvin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Randi', 'Ballentime', 'Dunderdale');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ave', 'Whalebelly', 'Springall');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Walker', 'McLean', 'Sailer');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Douglass', 'O''Lagen', 'Thombleson');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Fletch', 'Bernaldez', 'Crippen');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Reade', 'Coney', 'Clausius');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jesse', 'Lubeck', 'Joire');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Joey', 'Chattey', 'Shellshear');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Joey', 'Domel', 'Halsted');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Redd', 'Bullock', 'Tanguy');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Darryl', 'Bursnall', 'Kollaschek');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Svend', 'Hasard', 'Fillery');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Efren', 'Sandaver', 'Sussex');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Wilbur', 'Theze', 'Sturr');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ransell', 'Cholwell', 'Calderon');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Seth', 'Heffron', 'McGowran');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Udall', 'Akett', 'Whitesel');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Adolf', 'Forker', 'Wedderburn');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Archibold', 'Ford', 'Sellwood');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gil', 'Creeber', 'Huitson');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Abbie', 'Sinden', 'Smale');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gaston', 'Allbut', 'Lovejoy');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Olag', 'Ziems', 'Ghirardi');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Moss', 'Skeene', 'Olive');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Randie', 'Cureton', 'Decreuze');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Forester', 'Ferenc', 'McTear');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Kevan', 'Iacoviello', 'Jendrach');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Toddy', 'Grigoletti', 'Gavan');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Vassili', 'Molineux', 'Roll');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Fletcher', 'Mussett', 'Curness');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Yorgo', 'Sterricker', 'Baumler');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Abramo', 'Queripel', 'Empson');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Maximo', 'O''Glassane', 'Dun');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Erny', 'Johnigan', 'Dolohunty');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ari', 'Hearst', 'Badrock');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Cordy', 'Advani', 'Frosdick');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Cesar', 'Kupka', 'Digby');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Kristos', 'Clemens', 'Fearne');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Elbert', 'Studdert', 'Sanpere');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Bret', 'Standingford', 'Massel');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Alex', 'Dulson', 'Cushworth');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jesse', 'Dunlea', 'Fairhall');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Taite', 'Allott', 'Meece');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Timothee', 'Storres', 'Balding');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Bruno', 'Callacher', 'Dall');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Claudianus', 'Dancey', 'Blyth');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ferrel', 'Ingerman', 'Trulocke');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Leslie', 'Cranny', 'Musico');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Francklin', 'Bigby', 'Laudham');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Darb', 'Lippiello', 'Paunsford');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Matty', 'Nelthorp', 'Kliner');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Lannie', 'Andrey', 'Caird');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Leonard', 'Littledyke', 'Wilkes');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Linc', 'De Hooch', 'Leaton');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gardy', 'Brendel', 'Tirkin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Justus', 'Watling', 'Landeaux');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Abdel', 'O''Sheils', 'Bloxsum');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gardy', 'Epple', 'Garnham');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Izzy', 'Linebarger', 'Abbis');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Garrick', 'Poyner', 'Bridewell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hollis', 'Dytham', 'Boynton');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Robbie', 'Biddle', 'Duly');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Reinwald', 'Atheis', 'Windle');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Shellysheldon', 'Kovelmann', 'Struthers');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Roarke', 'Firle', 'Rodell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hadley', 'Howler', 'Spacey');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Abner', 'Ketchell', 'Dilke');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Marcel', 'Maskrey', 'Whipple');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Dael', 'Fairpool', 'Bradie');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Arvie', 'M''Quhan', 'Lebrun');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Abramo', 'Titlow', 'Avrahm');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Fred', 'Antrack', 'Doodson');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Llewellyn', 'Costa', 'Suart');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Alf', 'Spira', 'Clausewitz');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ferdie', 'Cubbon', 'Dundendale');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Nat', 'Baudinet', 'Sutherland');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Bartel', 'Gisburne', 'Fessier');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Eben', 'Wallwork', 'Teers');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Enoch', 'Herety', 'Joscelin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gerek', 'Colmore', 'Troy');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Shamus', 'Pellissier', 'Thunderchief');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hadley', 'Gaspero', 'Coneau');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Dani', 'Russ', 'Demongeot');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Griswold', 'Prescot', 'Belderson');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Tades', 'Forge', 'Kilkenny');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Thatch', 'Crosston', 'Glyne');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jefferson', 'O''Grada', 'Lehmann');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Normy', 'Topliss', 'Jarrad');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gaspar', 'Lampard', 'Joncic');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Booth', 'Bateman', 'Vasilyevski');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rudie', 'Petrak', 'Coger');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Benoit', 'Pinkard', 'Klisch');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Taddeo', 'Wretham', 'Tinson');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Olly', 'Orrock', 'Whitlock');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hale', 'McDaid', 'Crathorne');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Pryce', 'Bentick', 'Olyfat');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Haven', 'Garman', 'Van Arsdall');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Langston', 'Baden', 'Wackley');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ignacius', 'Pahler', 'd''Escoffier');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Zerk', 'Leadley', 'Bartosek');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Avrom', 'Symmers', 'Tarney');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rog', 'Baud', 'Nijssen');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Elvis', 'Woodyeare', 'Dohmann');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Garey', 'Gough', 'Yurkov');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Udell', 'Lord', 'Jerke');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Randall', 'Le febre', 'Gringley');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Sam', 'Orhrt', 'Eixenberger');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ruddie', 'Gledstane', 'Catlow');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Wright', 'Sturgeon', 'Lawlance');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Cecil', 'Swan', 'Comerford');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Maxy', 'Reddish', 'Vitall');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Judd', 'Nairy', 'Perassi');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Andreas', 'Amdohr', 'Fateley');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rowan', 'McGuirk', 'Gaunter');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rad', 'Copas', 'Bockin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Duke', 'Cuskery', 'Bore');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jayme', 'Toffts', 'Ledgeway');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Amory', 'Endersby', 'Mourton');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Napoleon', 'Dykes', 'Spurgin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Skell', 'Courtonne', 'Malek');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Keelby', 'Cobb', 'Bagge');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Pierce', 'Errichi', 'Tubritt');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Quent', 'Pedrol', 'Dutt');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Torrence', 'Linfitt', 'Lias');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Berke', 'Lorenc', 'Hugonnet');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Cosme', 'O''Shavlan', 'Tellenbrook');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Kalle', 'Chadd', 'Clandillon');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Lionello', 'Blazejewski', 'Wafer');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hillery', 'Goor', 'Gabby');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Leonerd', 'Gromley', 'Tapin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rickert', 'Plaid', 'Wisdish');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gerik', 'Folkerts', 'Temlett');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Isador', 'Garfirth', 'Crepin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Brad', 'Morrilly', 'Simioni');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Myles', 'Korejs', 'Zeal');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Bancroft', 'Malkin', 'Inett');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Penny', 'Taplow', 'Nowakowski');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Cornie', 'Pomphrett', 'Wingeatt');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Leigh', 'Netti', 'Stickles');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Tamas', 'Trenam', 'Dohmer');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jamesy', 'Rowes', 'Jandel');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Denis', 'Twinborne', 'Winson');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Reinhard', 'Giberd', 'Jeratt');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Corby', 'Kybbye', 'Lumbly');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Renard', 'Bayle', 'Madner');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Russell', 'Milbourn', 'Ladyman');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hashim', 'Mynett', 'Rosedale');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Cameron', 'Durrett', 'Lenthall');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Alvie', 'Shimmans', 'Braferton');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Lorrie', 'Worsnap', 'Wight');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Millard', 'Scotney', 'Dahlgren');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ferguson', 'Winsper', 'Hammand');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jarad', 'Lente', 'Croshaw');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Bradly', 'Rowlings', 'Mundell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Delmer', 'Heighton', 'Waite');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Levy', 'Pettiford', 'Gerardeaux');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Creigh', 'Cullimore', 'Merfin');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Colin', 'Shakspeare', 'Campey');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Sherlocke', 'Geraud', 'Paeckmeyer');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Benjie', 'Manneville', 'Wallicker');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jethro', 'Simonnet', 'Betteridge');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Arne', 'Surman', 'Lippard');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Kenn', 'Goggan', 'Belone');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Milton', 'Fivey', 'Alastair');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Alfredo', 'Lamball', 'McGinny');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Bronny', 'Drewitt', 'Kitlee');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Nico', 'Dallinder', 'Langtry');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Vasilis', 'Apedaile', 'Camell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Abel', 'Jeggo', 'Gonneau');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ricky', 'O''Doohaine', 'Ginni');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Inglis', 'Pryce', 'Blitzer');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Yanaton', 'Mannix', 'Vasenkov');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Cort', 'Syce', 'Trundell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Tad', 'Edworthye', 'Etheridge');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Xavier', 'Rodear', 'Hatherleigh');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Lyon', 'Rawstorne', 'Deschelle');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Lewiss', 'Bygate', 'Turfus');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Elnar', 'Quinnette', 'Treweke');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Giovanni', 'Hooke', 'Romi');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Marwin', 'Evenett', 'Cowpland');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Stanley', 'Secretan', 'Fardy');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Teodoro', 'Winn', 'Kiddy');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Alastair', 'Sheara', 'Gush');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Mart', 'Kunz', 'Warde');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Charley', 'Colliber', 'Aven');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ragnar', 'Tinniswood', 'Brownjohn');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Finn', 'Morgen', 'Barrasse');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Mordecai', 'Wellan', 'Smallridge');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Joshua', 'Gorke', 'Slogrove');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Christophe', 'Martygin', 'Palfrey');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rouvin', 'Reaveley', 'Lunney');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hewie', 'Parman', 'Peddie');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gordie', 'Kingerby', 'Kevis');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Izak', 'Eassom', 'Kleinmann');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Giustino', 'St. Ledger', 'Edie');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Tracy', 'Vasser', 'Baroux');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Vaclav', 'Conyers', 'Eadmeades');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Barclay', 'Harms', 'Brookz');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Pace', 'Plumer', 'Beadnell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Frasco', 'Falvey', 'Ellerman');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Trev', 'Driffield', 'Gillyatt');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Mycah', 'Robertis', 'Bevington');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Tracy', 'Guinane', 'Heales');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gearalt', 'MacAdam', 'Stallion');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Alano', 'McGeneay', 'Palatini');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Norbert', 'Lorenc', 'Greep');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Penrod', 'Sawdon', 'Weall');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Quinlan', 'Mockes', 'Moulson');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rafferty', 'Brabyn', 'Dumbellow');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hermon', 'Andrei', 'Brann');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Thaddeus', 'Harral', 'Baraclough');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hercule', 'Leatt', 'Cicco');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Norbert', 'Trudgian', 'Dosdill');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Georgy', 'Wethered', 'Morena');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Angie', 'Rosling', 'Gyurkovics');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Garwood', 'Douthwaite', 'Bushill');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ara', 'Bracknell', 'Lambourn');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ewell', 'Gillan', 'Linfield');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Glyn', 'Josey', 'Axelbey');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Marshall', 'Etty', 'Butteris');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Darn', 'Dransfield', 'Zink');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Torrey', 'Grinter', 'Gonthard');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Wilmer', 'Payle', 'Cayle');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Filberto', 'Rappport', 'Leak');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Zedekiah', 'Totton', 'Earl');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Artie', 'Fantini', 'Bodley');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Stanwood', 'Rugg', 'Vowell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Keenan', 'Stapels', 'Pavett');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Burton', 'Tribble', 'Parfrey');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Joaquin', 'Lilburne', 'Stitcher');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Chickie', 'Buttle', 'Raynham');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Freeman', 'Brookz', 'Tilliard');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Godfree', 'Wolfe', 'Rhys');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Douglas', 'Balazot', 'O'' Kelleher');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Chandler', 'Carstairs', 'Cavee');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Sigfried', 'Wybrow', 'Frontczak');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Dolph', 'Hogben', 'Edmondson');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Fabien', 'Dixcey', 'Ludee');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Sergei', 'Cheney', 'Hagley');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Evin', 'Havik', 'Reyner');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Budd', 'Suart', 'McGuire');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Maxim', 'Pregal', 'Renoden');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hewet', 'Gartshore', 'Sockell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Noland', 'Sissons', 'Gerretsen');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Kenn', 'Aireton', 'Terlinden');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jefferey', 'Iiannone', 'Stowte');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ancell', 'Norley', 'Rochell');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Tore', 'Blasoni', 'Ashbolt');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Willard', 'Bech', 'Hurlston');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Judah', 'Markovich', 'Edinboro');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Kinny', 'Makey', 'Konert');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Andras', 'Caswell', 'Loveless');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Eugenio', 'Haldenby', 'Dutnall');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Erasmus', 'Kibble', 'Caseborne');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Winston', 'Lippitt', 'Denholm');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Tim', 'Josh', 'Grewcock');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jeffy', 'Sybry', 'Tilsley');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gideon', 'McClelland', 'Bruckman');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Tanner', 'Pochon', 'Bagnold');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Leonardo', 'Karlowicz', 'Asp');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Armin', 'Tookill', 'Vogele');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Keary', 'Lampard', 'Vern');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Harlan', 'Sussems', 'Laite');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Marchall', 'Alsopp', 'Gentry');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Roger', 'Barnet', 'Frankes');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Laurens', 'Clohisey', 'Lenglet');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Thorn', 'Giovanazzi', 'Benning');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Alistair', 'Garvie', 'Ibel');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Clem', 'Skones', 'Markie');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Nat', 'Acey', 'Gloucester');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Carson', 'Caldicot', 'Bowton');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Nevins', 'Queree', 'McIntosh');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Charlie', 'Nangle', 'Brauns');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Udell', 'Novic', 'Couronne');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Natty', 'Physick', 'Tryhorn');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Berky', 'Flag', 'MacIlory');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ray', 'D''Hooge', 'Ameer-Beg');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Marietta', 'Pyatt', 'Sainsbury-Brown');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Malachi', 'Blaine', 'Cottee');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Terrance', 'Oldfield', 'Scramage');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hagen', 'Minter', 'Tilford');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Nils', 'Radki', 'Trencher');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Abdul', 'Nice', 'Tames');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jarrad', 'Grzelczyk', 'De Francesco');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Dimitri', 'Buntine', 'Aspden');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Eb', 'Demke', 'Pulley');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Eugen', 'Mockett', 'Coller');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Sutton', 'Lerway', 'Megany');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Armand', 'Splevin', 'Moodycliffe');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Zed', 'Guyon', 'Seywood');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Nat', 'Clowney', 'Petschelt');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Kalle', 'Knee', 'Fettiplace');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ruy', 'Balmer', 'Diaper');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Reade', 'Skipper', 'Skells');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Obadias', 'Erwin', 'Antonsson');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Damien', 'Josskoviz', 'Tresise');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hew', 'Weddeburn - Scrimgeour', 'Wishart');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Tye', 'Slides', 'Newborn');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jory', 'Blunsum', 'Stepto');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gerri', 'Ganley', 'Christophers');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rourke', 'Moodycliffe', 'Greggs');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Wald', 'Attree', 'Cholton');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Feodor', 'Hartfield', 'Knibbs');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Wheeler', 'Arkle', 'Grossier');

