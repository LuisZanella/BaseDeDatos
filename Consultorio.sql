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

--CREACION DE LA TABLA MEDICO
CREATE TABLE Medico(
	CodigoMedico INT PRIMARY KEY IDENTITY,
	CodigoPersona INT NOT NULL FOREIGN KEY REFERENCES Persona(CodigoPersona) ON DELETE CASCADE ON UPDATE CASCADE,
	Vocacion VARCHAR (40) NOT NULL,
	Consultorio INT NOT NULL,
	CedulaProfesional VARCHAR (30) NOT NULL,
	RegistroSalubridad VARCHAR(30) NOT NULL,
	Estatus Estatus_type,
	CONSTRAINT UC_Vocacion UNIQUE (Vocacion),
	CONSTRAINT UC_Cedula UNIQUE (CedulaProfesional)
)

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
		CodigoPaciente INT NOT NULL FOREIGN KEY REFERENCES Paciente(CodigoPaciente) ON DELETE CASCADE ON UPDATE CASCADE,
		Edad VARCHAR (100) NOT NULL,
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