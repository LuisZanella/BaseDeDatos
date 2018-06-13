CREATE DATABASE ProyectoMedico
USE ProyectoMedico
GO
--REGLA RANGO DE Lista de Valores(REGLA CON LISTA DE VALORES)

CREATE RULE dbo.Prioridad_rule
AS @lista IN('1', '2', '3');
--CREACION DE Tipo de Dato PRIORIDAD
	CREATE TYPE dbo.Prioridad_type FROM [INT] NOT NULL
GO
--CREAR DEFAULT Para la Prioridad
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
-- CREACION DEL Tipo de GRAVERDAD DEL PROBLEMA
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
--Tipo DE Dato horario Horario
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
--Tipo CantidadProducto
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
--CREACION DEL TIPO DE DATO GENERO
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
-- CREACION DEL TIPO DE ESTATUS
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
CREATE RULE [dbo].[Nombre_rule]
	AS @Nombre NOT LIKE '%[^a-zA-Z]%';
--CREACION DEL Tipo de Dato Nombre
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
--CREACION DE LA TABLA Especialidad
CREATE TABLE Especialidad(
	CodigoEspecialidad INT PRIMARY KEY IDENTITY,
	Especialidad VARCHAR (100) NOT NULL
)
GO
--CREACION DE LA TABLA EspecialidadMedico
CREATE TABLE EspecialidadMedico(
	CodigoEspecialidadMedico INT PRIMARY KEY IDENTITY,
	CodigoMedico INT NOT NULL FOREIGN KEY REFERENCES Medico(CodigoMedico) ON DELETE CASCADE ON UPDATE CASCADE,
	CodigoEspecialidad INT NOT NULL FOREIGN KEY REFERENCES Especialidad(CodigoEspecialidad) ON DELETE CASCADE ON UPDATE CASCADE
)
GO

--CREACION DE LA TABLA PACIENTE
CREATE TABLE Paciente(
	CodigoPaciente INT PRIMARY KEY IDENTITY,
	CodigoPersona INT NOT NULL FOREIGN KEY REFERENCES Persona(CodigoPersona) ON DELETE CASCADE ON UPDATE CASCADE,
	Sexo Genero_type NOT NULL,
	FechaNacimiento DATE NOT NULL,
	Prioridad Prioridad_type NOT NULL
)
--CREACION DE LA TABLA VISITAS
CREATE TABLE Visita(
	CodigoVisita INT PRIMARY KEY IDENTITY,
	Descripcion VARCHAR(1000) DEFAULT 'Sin Descripción'
)


--CREACION DE LA TABLA CITAS
CREATE TABLE Cita(
	CodigoCita INT PRIMARY KEY IDENTITY,
	CodigoPaciente INT NOT NULL FOREIGN KEY REFERENCES Paciente(CodigoPaciente) ON DELETE CASCADE ON UPDATE CASCADE,
	CodigoMedico INT NOT NULL FOREIGN KEY REFERENCES Medico(CodigoMedico),
	CodigoVisita INT NOT NULL FOREIGN KEY REFERENCES Visita(CodigoVisita) ON DELETE CASCADE ON UPDATE CASCADE,
	FechaInicio DATE NOT NULL,
	FechaFinal DATETIME NULL,
	Costo FLOAT NOT NULL,
	Hora Horario_type NOT NULL,
	Estatus Estatus_type
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
		CodigoLab VARCHAR(200) NOT NULL,
		Nombre NombreLaboratorio_type,
		Estatus Estatus_type,
		CONSTRAINT UC_LaboratiorioVerificacion UNIQUE (CodigoLab,Nombre)
)

--CREACION DE LA TABLA PRODUCTOS
CREATE TABLE Producto(
		CodigoProducto INT PRIMARY KEY IDENTITY,
		CodigoLaboratorio INT NOT NULL FOREIGN KEY REFERENCES Laboratorio(CodigoLaboratorio) ON DELETE CASCADE ON UPDATE CASCADE,
		Nombre Nombre_type NOT NULL,
		Cantidad CantidadProducto_type NOT NULL,
		Descripcion VARCHAR(1000) DEFAULT 'Sin Descripción',
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
		DECLARE @nyears INT = (Select datediff(Year, @bDay, @today) - case When datepart(dayofYear, @today) < datepart(dayofYear, @bDay) Then 1 Else 0 END)
		UPDATE HistorialMedico SET Edad = @nyears
		WHERE CodigoHistorialMedico = (SELECT CodigoHistorialMedico FROM inserted)
		END
GO


-------PROCEDIMIENTOS ALMACENADOS INSERTS
CREATE PROCEDURE sp_InsertMedico
@Persona VARCHAR(20),
@paterno VARCHAR(20),
@materno VARCHAR(20),
@especialidad VARCHAR(100),
@consultorio INT,
@cedula VARCHAR(30),
@salubridad VARCHAR(30)
AS
	INSERT INTO Persona(Nombre, ApellidoP, ApellidoM)
				 VALUES(@Persona, @paterno, @materno)
	DECLARE @id INT = (SELECT MAX(CodigoPersona) FROM Persona)
	DECLARE @tipo INT = (SELECT TOP 1(CodigoEspecialidad) FROM Especialidad WHERE Especialidad =  @especialidad OR Especialidad LIKE '%'+@especialidad+'%' OR Especialidad LIKE @especialidad+'%' OR Especialidad LIKE '%'+@especialidad)   
	INSERT INTO Medico(CodigoPersona, Consultorio, CedulaProfesional, RegistroSalubridad)
				VALUES(@id, @consultorio, @cedula, @salubridad)
	DECLARE @idMedico INT = (SELECT MAX(CodigoMedico) FROM Medico)
	INSERT INTO EspecialidadMedico (CodigoEspecialidad, CodigoMedico) VALUES (@tipo,@idMedico)
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
--------------------------------
--Trae todos los medicos que su especialidad es cirugia o medicina excluyendo los medicos de Medicina Nuclear
--Y tienen menos de dos pacientes el dia actual

CREATE VIEW view_MedicosSinConsultasDia
AS
	SELECT j.NombreCompleto, j.Especialidad, j.[Numero de Citas]
	 FROM((
		SELECT P.NombreCompleto, E.Especialidad, COUNT(C.CodigoCita) 'Numero de Citas'
		FROM Medico M
		LEFT JOIN Persona P
		ON M.CodigoPersona = P.CodigoPersona
		INNER JOIN EspecialidadMedico EM
		ON EM.CodigoMedico = M.CodigoMedico
		INNER JOIN Especialidad E
		ON E.CodigoEspecialidad = EM.CodigoEspecialidad
		INNER JOIN Cita C
		ON C.CodigoMedico = M.CodigoMedico
		WHERE M.Estatus = 1 AND C.FechaInicio = GETDATE() AND E.Especialidad LIKE 'CIRUGÍA%'
		HAVING COUNT(C.CodigoCita)<2
			UNION 
		SELECT P.NombreCompleto, E.Especialidad, COUNT(C.CodigoCita) 'Numero de Citas'
		FROM Medico M
		LEFT JOIN Persona P
		ON M.CodigoPersona = P.CodigoPersona
		INNER JOIN EspecialidadMedico EM
		ON EM.CodigoMedico = M.CodigoMedico
		INNER JOIN Especialidad E
		ON E.CodigoEspecialidad = EM.CodigoEspecialidad
		INNER JOIN Cita C
		ON C.CodigoMedico = M.CodigoMedico
		WHERE M.Estatus = 1 AND C.FechaInicio = GETDATE() AND E.Especialidad LIKE 'MEDICINA%'
		HAVING COUNT(C.CodigoCita)<2
		)
			EXCEPT
		SELECT P.NombreCompleto, E.Especialidad, COUNT(C.CodigoCita) 'Numero de Citas'
		FROM Medico M
		LEFT JOIN Persona P
		ON M.CodigoPersona = P.CodigoPersona
		INNER JOIN EspecialidadMedico EM
		ON EM.CodigoMedico = M.CodigoMedico
		INNER JOIN Especialidad E
		ON E.CodigoEspecialidad = EM.CodigoEspecialidad
		INNER JOIN Cita C
		ON C.CodigoMedico = M.CodigoMedico
		WHERE M.Estatus = 1 AND C.FechaInicio = GETDATE() AND E.Especialidad LIKE 'MEDICINA NUCLEAR'
		)j
GO
--- VISTA QUE MUESTRA TODOS LOS LABORATORIOS QUE HAN VENDIDO 1 sola vez Y MAS DE 5 veces *A LOS MEDICOS CON MAS PACIENTES* QUITANDO LOS QUE SU ESTATUS ES 0
CREATE VIEW view_LaboratoriosMasVENDEN
AS
	SELECT j.Empresa, j.[Productos Vendidos]
	 FROM((
		SELECT L.Nombre Empresa, COUNT(MP.CodigoMedicoProducto) 'Productos Vendidos'
		FROM Medico M
		LEFT JOIN Persona P
		ON M.CodigoPersona = P.CodigoPersona
		INNER JOIN EspecialidadMedico EM
		ON EM.CodigoMedico = M.CodigoMedico
		INNER JOIN Especialidad E
		ON E.CodigoEspecialidad = EM.CodigoEspecialidad
		INNER JOIN Cita C
		ON C.CodigoMedico = M.CodigoMedico
		INNER JOIN MedicoProducto MP
		ON MP.CodigoMedico = M.CodigoMedico
		INNER JOIN Producto Pr
		ON Pr.CodigoProducto = MP.CodigoProducto 
		INNER JOIN Laboratorio L
		ON L.CodigoLaboratorio = Pr.CodigoLaboratorio
		HAVING COUNT(MP.CodigoMedicoProducto)=1
			UNION 
				SELECT L.Nombre Empresa, COUNT(MP.CodigoMedicoProducto) 'Productos Vendidos'
		FROM Medico M
		LEFT JOIN Persona P
		ON M.CodigoPersona = P.CodigoPersona
		INNER JOIN EspecialidadMedico EM
		ON EM.CodigoMedico = M.CodigoMedico
		INNER JOIN Especialidad E
		ON E.CodigoEspecialidad = EM.CodigoEspecialidad
		INNER JOIN Cita C
		ON C.CodigoMedico = M.CodigoMedico
		INNER JOIN MedicoProducto MP
		ON MP.CodigoMedico = M.CodigoMedico
		INNER JOIN Producto Pr
		ON Pr.CodigoProducto = MP.CodigoProducto 
		INNER JOIN Laboratorio L
		ON L.CodigoLaboratorio = Pr.CodigoLaboratorio
		HAVING COUNT(MP.CodigoMedicoProducto)>5
		)
			EXCEPT
		SELECT L.Nombre Empresa, COUNT(MP.CodigoMedicoProducto) 'Productos Vendidos'
		FROM Medico M
		LEFT JOIN Persona P
		ON M.CodigoPersona = P.CodigoPersona
		INNER JOIN EspecialidadMedico EM
		ON EM.CodigoMedico = M.CodigoMedico
		INNER JOIN Especialidad E
		ON E.CodigoEspecialidad = EM.CodigoEspecialidad
		INNER JOIN Cita C
		ON C.CodigoMedico = M.CodigoMedico
		INNER JOIN MedicoProducto MP
		ON MP.CodigoMedico = M.CodigoMedico
		INNER JOIN Producto Pr
		ON Pr.CodigoProducto = MP.CodigoProducto 
		INNER JOIN Laboratorio L
		ON L.CodigoLaboratorio = Pr.CodigoLaboratorio
		WHERE L.Estatus = 0
		)j
GO
--------------------------------
INSERT INTO Especialidad (Especialidad) VALUES
('ALERGIA E INMUNOLOGÍA'),
('ANATOMÍA PATOLÓGICA'),
('ANESTESIOLOGÍA'),
('ANGIOLOGÍA GENERAL y HEMODINAMIA'),
('CARDIOLOGÍA'),
('CARDIÓLOGO INFANTIL'),
('CIRUGÍA GENERAL'),
('CIRUGÍA CARDIOVASCULAR'),
('CIRUGÍA DE CABEZA Y CUELLO'),
('CIRUGÍA DE TÓRAX (CIRUGÍA TORÁCICA)'),
('CIRUGÍA INFANTIL (CIRUGÍA PEDIÁTRICA)'),
('CIRUGÍA PLÁSTICA Y REPARADORA'),
('CIRUGÍA VASCULAR PERIFÉRICA'),
('CLÍNICA MÉDICA'),
('COLOPROCTOLOGÍA'),
('DERMATOLOGÍA'),
('DIAGNOSTICO POR IMÁGENES'),
('ENDOCRINOLOGÍA'),
('ENDOCRINÓLOGO INFANTIL'),
('FARMACOLOGÍA CLÍNICA'),
('FISIATRÍA (MEDICINA FÍSICA Y REHABILITACIÓN)'),
('GASTROENTEROLOGÍA'),
('GASTROENTERÓLOGO INFANTIL'),
('GENÉTICA MEDICA'),
('GERIATRÍA'),
('GINECOLOGÍA'),
('HEMATOLOGÍA'),
('HEMATÓLOGO INFANTIL'),
('HEMOTERAPIA E INMUNOHEMATOLOGÍA'),
('INFECTOLOGÍA'),
('INFECTÓLOGO INFANTIL'),
('MEDICINA DEL DEPORTE'),
('MEDICINA GENERAL y/o MEDICINA DE FAMILIA'),
('MEDICINA LEGAL'),
('MEDICINA NUCLEAR'),
('MEDICINA DEL TRABAJO'),
('NEFROLOGÍA'),
('NEFRÓLOGO INFANTIL'),
('NEONATOLOGÍA'),
('NEUMONOLOGÍA'),
('NEUMONÓLOGO INFANTIL'),
('NEUROCIRUGÍA'),
('NEUROLOGÍA'),
('NEURÓLOGO INFANTIL'),
('NUTRICIÓN'),
('OBSTETRICIA'),
('OFTALMOLOGÍA'),
('ONCOLOGÍA'),
('ONCÓLOGO INFANTIL'),
('ORTOPEDIA Y TRAUMATOLOGÍA'),
('OTORRINOLARINGOLOGÍA'),
('PEDIATRÍA'),
('PSIQUIATRÍA'),
('PSIQUIATRÍA INFANTO JUVENIL'),
('RADIOTERAPIA O TERAPIA RADIANTE'),
('REUMATOLOGÍA'),
('REUMATÓLOGO INFANTIL'),
('TERAPIA INTENSIVA'),
('TERAPISTA INTENSIVO INFANTIL'),
('TOCOGINECOLOGÍA'),
('TOXICOLOGÍA'),
('UROLOGÍA')

SELECT * FROM Persona

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
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Nathan', ' Dooley', 'Quincey');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Obed', 'De Bischof', 'Ohm');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Saul', 'Bewlay', 'Stobo');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Bone', 'McCaig', 'Gunda');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Grantham', 'Ginman', 'Craxford');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ikey', 'Byneth', 'Hundy');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Shaw', 'Mealing', 'Pester');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Vladamir', 'MacFadin','Dee');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Elijah', 'Cowle', 'Youngman');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Robby', 'Dinesen', 'Paradyce');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Neal', 'Lee', 'Mariel');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Alexandro', 'McKaile', 'Edmondson');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Luce', 'Coldbreath', 'Stirley');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Eal', 'Lynch', 'Esslemont');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Wendel', 'Turnbull', 'Stammer');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Anatole', 'Vauls', 'Hibbart');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Lin', 'Ternouth','Currane');
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
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jeremiah', 'Grivori','Dyvoie');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rod', 'Glanton', 'Gockelen');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Filmer', 'Boggs', 'Comerford');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Claus', 'McCumskay', 'Hagger');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Chaim', 'Levermore', 'Belt');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rochester', 'Crim', 'Nanninini');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Willey', 'Penson', 'Vasenkov');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Cornell', 'Ninotti','Day');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Eric', 'Skittles', 'Fayerbrother');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Franzen', 'Challenor', 'Serfati');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Orbadiah', 'Kewley', 'Girauld');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Carly', 'Standing', 'Blenkiron');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Garv', 'Stirton', 'Berth');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Keene', 'Strelitz', 'Novotna');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Wes', 'Swigger','Lagen');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Guntar', 'Shatford', 'Wymer');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Chris','Fogerty', 'Skentelbury');
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
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Torr', 'Brewitt',' Mullane');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gage', 'Minear', 'Jacobssen');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Kipper', 'Ollivierre', 'Sebire');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Stanton', 'Winkworth', 'Pabelik');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hagen', 'Libbey', 'Cashen');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Caesar', 'Donner', 'Rehme');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ozzy', 'Babalola', 'Kielt');
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
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Herschel','Hagan', 'Foulcher');
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
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rodrick', 'Jacquet','Drought');
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
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Costa', 'Shiels', 'Clayfield');
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
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Dael','Dowling', 'Jasper');
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
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Kenyon', 'McIleen','Henecan');
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
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Raul', 'Drysdale', ' Mara');
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
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Conway', 'Glessane', 'Bencher');
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
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Fonz', 'Purdon','Hallagan');
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
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hamish', 'Dine-Hart','Fergus');
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
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Niki', 'Kelso','Loghlen');
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
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Willi', 'Murname','Gleasane');
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
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Douglass','Lagen', 'Thombleson');
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
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Maximo','Glassane', 'Dun');
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
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Abdel', 'Sheils', 'Bloxsum');
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
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jefferson','Grada', 'Lehmann');
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
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Cosme','Shavlan', 'Tellenbrook');
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
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Ricky','Doohaine', 'Ginni');
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
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Douglas', 'Balazot',' Kelleher');
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
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Hew', 'Weddeburn Scrimgeour', 'Wishart');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Tye', 'Slides', 'Newborn');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Jory', 'Blunsum', 'Stepto');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Gerri', 'Ganley', 'Christophers');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Rourke', 'Moodycliffe', 'Greggs');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Wald', 'Attree', 'Cholton');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Feodor', 'Hartfield', 'Knibbs');
insert into Persona (Nombre, ApellidoP, ApellidoM) values ('Wheeler', 'Arkle', 'Grossier');
insert into Laboratorio (CodigoLab, Nombre) values ('3219444946', 'Ammi');
insert into Laboratorio (CodigoLab, Nombre) values ('5305311535', 'Fly Marsh Elder');
insert into Laboratorio (CodigoLab, Nombre) values ('1752312333', 'Sicklepod Holdback');
insert into Laboratorio (CodigoLab, Nombre) values ('9348807129', 'Perennial Sandgrass');
insert into Laboratorio (CodigoLab, Nombre) values ('3099329053', 'Discelium Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('3644733112', 'Medusahead');
insert into Laboratorio (CodigoLab, Nombre) values ('2378011016', 'Thurber''s Sedge');
insert into Laboratorio (CodigoLab, Nombre) values ('6623421114', 'Obtuseleaf Aspen Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('1888780126', 'Xanthoparmelia Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('7445972102', 'Douglas'' Grasswidow');
insert into Laboratorio (CodigoLab, Nombre) values ('6941794283', 'Small Venus'' Looking-glass');
insert into Laboratorio (CodigoLab, Nombre) values ('2168444579', 'Sevier Milkvetch');
insert into Laboratorio (CodigoLab, Nombre) values ('6954121312', 'Compressed Plumegrass');
insert into Laboratorio (CodigoLab, Nombre) values ('6323388383', 'Clubbed Creepingfern');
insert into Laboratorio (CodigoLab, Nombre) values ('3183135221', 'Texas Greeneyes');
insert into Laboratorio (CodigoLab, Nombre) values ('3935108230', 'Bavarian Timmia Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('3560709334', 'Snake River Twinpod');
insert into Laboratorio (CodigoLab, Nombre) values ('8613968856', 'Coco Yam');
insert into Laboratorio (CodigoLab, Nombre) values ('1414660065', 'Bipinnate Princesplume');
insert into Laboratorio (CodigoLab, Nombre) values ('5773293986', 'Texas Brome');
insert into Laboratorio (CodigoLab, Nombre) values ('5208081334', 'Cadaba');
insert into Laboratorio (CodigoLab, Nombre) values ('1600124771', 'Blessed Thistle');
insert into Laboratorio (CodigoLab, Nombre) values ('5643270005', 'Flaxleaf Monardella');
insert into Laboratorio (CodigoLab, Nombre) values ('5584127639', 'Wright''s Rosette Grass');
insert into Laboratorio (CodigoLab, Nombre) values ('0485865386', 'Piper''s Fleabane');
insert into Laboratorio (CodigoLab, Nombre) values ('3399100914', 'Grugru Palm');
insert into Laboratorio (CodigoLab, Nombre) values ('3564529365', 'Lodgepole Pine');
insert into Laboratorio (CodigoLab, Nombre) values ('7039843366', 'Laurent''s Milkvetch');
insert into Laboratorio (CodigoLab, Nombre) values ('7383899431', 'Sanchezia');
insert into Laboratorio (CodigoLab, Nombre) values ('2747085910', 'Mahaleb Cherry');
insert into Laboratorio (CodigoLab, Nombre) values ('8496344622', 'Dwarf Ninebark');
insert into Laboratorio (CodigoLab, Nombre) values ('0662725166', 'Horizontal Woody Rockcress');
insert into Laboratorio (CodigoLab, Nombre) values ('0265218543', 'Rubber Rabbitbrush');
insert into Laboratorio (CodigoLab, Nombre) values ('4278249381', 'Jamaican Weissia Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('7473912305', 'Bonebract');
insert into Laboratorio (CodigoLab, Nombre) values ('3112638867', 'Redosier Dogwood');
insert into Laboratorio (CodigoLab, Nombre) values ('2221048644', 'Narrowleaf Purple Everlasting');
insert into Laboratorio (CodigoLab, Nombre) values ('0118537660', 'Missoula Phlox');
insert into Laboratorio (CodigoLab, Nombre) values ('0272670588', 'Caribbean Curlygrass Fern');
insert into Laboratorio (CodigoLab, Nombre) values ('2840653176', 'Longstalk Greenthread');
insert into Laboratorio (CodigoLab, Nombre) values ('6217367858', 'Wright''s Beaksedge');
insert into Laboratorio (CodigoLab, Nombre) values ('5628293113', 'Koerberia Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('8260155060', 'Rock Panicgrass');
insert into Laboratorio (CodigoLab, Nombre) values ('4986257323', 'Miniature Lupine');
insert into Laboratorio (CodigoLab, Nombre) values ('2535763818', 'Heller''s Draba');
insert into Laboratorio (CodigoLab, Nombre) values ('9846066961', 'Prairie Ironweed');
insert into Laboratorio (CodigoLab, Nombre) values ('6489516640', 'Sanibel Shrubverbena');
insert into Laboratorio (CodigoLab, Nombre) values ('3262691453', 'Partridgefoot');
insert into Laboratorio (CodigoLab, Nombre) values ('2318992657', 'Pitaya');
insert into Laboratorio (CodigoLab, Nombre) values ('0525166122', 'Hawai''i Plantain');
insert into Laboratorio (CodigoLab, Nombre) values ('5365024494', 'Texas Madrone');
insert into Laboratorio (CodigoLab, Nombre) values ('7230666716', 'Alyxia');
insert into Laboratorio (CodigoLab, Nombre) values ('6646217130', 'Didymodon Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('4520874238', 'Islandthicket Thoroughwort');
insert into Laboratorio (CodigoLab, Nombre) values ('5691348140', 'Nevada Jacob''s-ladder');
insert into Laboratorio (CodigoLab, Nombre) values ('1380769868', 'Knotweed');
insert into Laboratorio (CodigoLab, Nombre) values ('8255379681', 'Hybrid Ryegrass');
insert into Laboratorio (CodigoLab, Nombre) values ('9461172990', 'Fivestamen Chickweed');
insert into Laboratorio (CodigoLab, Nombre) values ('2111013978', 'Sicklegrass');
insert into Laboratorio (CodigoLab, Nombre) values ('1851348174', 'Grimmia Dry Rock Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('1386507296', 'Sword Townsend Daisy');
insert into Laboratorio (CodigoLab, Nombre) values ('6807134851', 'Membranous Garlicvine');
insert into Laboratorio (CodigoLab, Nombre) values ('5109309841', 'Arrowweed');
insert into Laboratorio (CodigoLab, Nombre) values ('3063908703', 'Rough Shrubverbena');
insert into Laboratorio (CodigoLab, Nombre) values ('9428149489', 'Point Reyes Bentgrass');
insert into Laboratorio (CodigoLab, Nombre) values ('4192205653', 'Shasta Knotweed');
insert into Laboratorio (CodigoLab, Nombre) values ('6854653460', 'Huckleberry');
insert into Laboratorio (CodigoLab, Nombre) values ('5771472913', 'Watson''s Fleabane');
insert into Laboratorio (CodigoLab, Nombre) values ('7179786179', 'Cleftleaf Wildheliotrope');
insert into Laboratorio (CodigoLab, Nombre) values ('3282016085', 'Koko');
insert into Laboratorio (CodigoLab, Nombre) values ('0605351139', 'Mexican Twist');
insert into Laboratorio (CodigoLab, Nombre) values ('3085577475', 'Montagne''s Roccella Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('6801604910', 'Swamp Lousewort');
insert into Laboratorio (CodigoLab, Nombre) values ('2523954656', 'Menziesia');
insert into Laboratorio (CodigoLab, Nombre) values ('5421173976', 'Fewflower Pea');
insert into Laboratorio (CodigoLab, Nombre) values ('8405522158', 'Beavertail Pricklypear');
insert into Laboratorio (CodigoLab, Nombre) values ('3790312649', 'Licorice Bedstraw');
insert into Laboratorio (CodigoLab, Nombre) values ('4650137071', 'Pennycress');
insert into Laboratorio (CodigoLab, Nombre) values ('8861580785', 'Chaparral Currant');
insert into Laboratorio (CodigoLab, Nombre) values ('8901552558', 'Amygdalaria Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('4187101268', 'Arizona Ragwort');
insert into Laboratorio (CodigoLab, Nombre) values ('8030433344', 'Pineland Wild Indigo');
insert into Laboratorio (CodigoLab, Nombre) values ('2977492054', 'Gulf Coast Spikerush');
insert into Laboratorio (CodigoLab, Nombre) values ('6849952277', 'Touch-me-not');
insert into Laboratorio (CodigoLab, Nombre) values ('4061837311', 'Parrothead Indian Paintbrush');
insert into Laboratorio (CodigoLab, Nombre) values ('2857770359', 'South African Ragwort');
insert into Laboratorio (CodigoLab, Nombre) values ('4150483523', 'Wheat');
insert into Laboratorio (CodigoLab, Nombre) values ('8199560444', 'Jepson''s Monkeyflower');
insert into Laboratorio (CodigoLab, Nombre) values ('9684565186', 'Bog Stitchwort');
insert into Laboratorio (CodigoLab, Nombre) values ('8057315768', 'Sevenleaf Creeper');
insert into Laboratorio (CodigoLab, Nombre) values ('4327458996', 'Royal Penstemon');
insert into Laboratorio (CodigoLab, Nombre) values ('2306121192', 'Attorney');
insert into Laboratorio (CodigoLab, Nombre) values ('4475047684', 'Cooper''s Dogweed');
insert into Laboratorio (CodigoLab, Nombre) values ('6085171560', 'Faurie''s Panicgrass');
insert into Laboratorio (CodigoLab, Nombre) values ('8982658084', 'Jepsonia');
insert into Laboratorio (CodigoLab, Nombre) values ('2266017314', 'Seaside Ragwort');
insert into Laboratorio (CodigoLab, Nombre) values ('4558944217', 'Mandrake');
insert into Laboratorio (CodigoLab, Nombre) values ('9279903810', 'Cultivated Raspberry');
insert into Laboratorio (CodigoLab, Nombre) values ('1318900263', 'Oregon Western Rosinweed');
insert into Laboratorio (CodigoLab, Nombre) values ('9504445624', 'Columbian Windflower');
insert into Laboratorio (CodigoLab, Nombre) values ('4138932828', 'Fringed Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('7003607255', 'Swartz''s Flatsedge');
insert into Laboratorio (CodigoLab, Nombre) values ('0322674921', 'Saxifrage');
insert into Laboratorio (CodigoLab, Nombre) values ('4655044284', 'Barbgrass');
insert into Laboratorio (CodigoLab, Nombre) values ('6900772544', 'Goosegrass');
insert into Laboratorio (CodigoLab, Nombre) values ('6435874077', 'Currant');
insert into Laboratorio (CodigoLab, Nombre) values ('5807296230', 'Mountain Azalea');
insert into Laboratorio (CodigoLab, Nombre) values ('6753506233', 'Coral Phyllopsora Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('6377431147', 'Forest Climbing Bamboo');
insert into Laboratorio (CodigoLab, Nombre) values ('4055846266', 'Melanelia Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('2583794566', 'Dalea');
insert into Laboratorio (CodigoLab, Nombre) values ('6685923636', 'Downy Ryegrass');
insert into Laboratorio (CodigoLab, Nombre) values ('5754075847', 'Sanddune Wallflower');
insert into Laboratorio (CodigoLab, Nombre) values ('7772776454', 'Juniper Berry');
insert into Laboratorio (CodigoLab, Nombre) values ('7844241063', 'Shrubby False Mallow');
insert into Laboratorio (CodigoLab, Nombre) values ('1137970146', 'Maui Remya');
insert into Laboratorio (CodigoLab, Nombre) values ('9440513543', 'Chaffweed');
insert into Laboratorio (CodigoLab, Nombre) values ('0968008011', 'Arthrorhaphis Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('6310603000', 'Stiffbranch Bird''s Beak');
insert into Laboratorio (CodigoLab, Nombre) values ('3741109290', 'Gray Five Eyes');
insert into Laboratorio (CodigoLab, Nombre) values ('3212076437', 'Jagleaf Junglefern');
insert into Laboratorio (CodigoLab, Nombre) values ('7044258387', 'Scabland Sagebrush');
insert into Laboratorio (CodigoLab, Nombre) values ('6391334617', 'Rock Harlequin');
insert into Laboratorio (CodigoLab, Nombre) values ('8783914196', 'Agroelymus');
insert into Laboratorio (CodigoLab, Nombre) values ('1667335472', 'Denseflower Mullein');
insert into Laboratorio (CodigoLab, Nombre) values ('5815734691', 'Toothed Snailfern');
insert into Laboratorio (CodigoLab, Nombre) values ('8463471404', 'Finger Skin Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('7028890708', 'False Bindweed');
insert into Laboratorio (CodigoLab, Nombre) values ('3829433603', 'Needle Goldfields');
insert into Laboratorio (CodigoLab, Nombre) values ('6711063139', 'Heartleaf Springbeauty');
insert into Laboratorio (CodigoLab, Nombre) values ('3838565398', 'Scribble Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('0931102057', 'Spotted Fritillary');
insert into Laboratorio (CodigoLab, Nombre) values ('4275757181', 'Sedge');
insert into Laboratorio (CodigoLab, Nombre) values ('2873899646', 'Pale Bellflower');
insert into Laboratorio (CodigoLab, Nombre) values ('9252160124', 'Appalachian Sedge');
insert into Laboratorio (CodigoLab, Nombre) values ('2469609739', 'Eastern White Pine');
insert into Laboratorio (CodigoLab, Nombre) values ('3417122538', 'White Penstemon');
insert into Laboratorio (CodigoLab, Nombre) values ('0747196451', 'Slenderleaf Lomatium');
insert into Laboratorio (CodigoLab, Nombre) values ('2828075591', 'Grape Hyacinth');
insert into Laboratorio (CodigoLab, Nombre) values ('0908112564', 'Jacob''s-ladder');
insert into Laboratorio (CodigoLab, Nombre) values ('1382974582', 'Star Phacelia');
insert into Laboratorio (CodigoLab, Nombre) values ('0240827759', 'New Mexican Sarcogyne Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('5954379556', 'Cynodontium Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('4401525825', 'False Spleenwort');
insert into Laboratorio (CodigoLab, Nombre) values ('4324018049', 'Saffron-flowered Lupine');
insert into Laboratorio (CodigoLab, Nombre) values ('2430595990', 'Colicroot');
insert into Laboratorio (CodigoLab, Nombre) values ('3247232419', 'Streambank Springbeauty');
insert into Laboratorio (CodigoLab, Nombre) values ('9110482822', 'Bushy Bird''s Beak');
insert into Laboratorio (CodigoLab, Nombre) values ('3074236655', 'Orangefruit Horse-gentian');
insert into Laboratorio (CodigoLab, Nombre) values ('9412096364', 'Sarsaparilla');
insert into Laboratorio (CodigoLab, Nombre) values ('9754166765', 'American Smoketree');
insert into Laboratorio (CodigoLab, Nombre) values ('2220160831', 'Scarlet Globemallow');
insert into Laboratorio (CodigoLab, Nombre) values ('5165093301', 'Tortula Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('5742659180', 'Greater Water Dock');
insert into Laboratorio (CodigoLab, Nombre) values ('4176892765', 'Autumn Coralroot');
insert into Laboratorio (CodigoLab, Nombre) values ('5187530089', 'Dwarf Arctic Ragwort');
insert into Laboratorio (CodigoLab, Nombre) values ('2057503348', 'Florida Yam');
insert into Laboratorio (CodigoLab, Nombre) values ('4814454961', 'Utah Spikemoss');
insert into Laboratorio (CodigoLab, Nombre) values ('9439365811', 'Peirson''s Springbeauty');
insert into Laboratorio (CodigoLab, Nombre) values ('5458877462', 'Woodland Necklace Fern');
insert into Laboratorio (CodigoLab, Nombre) values ('1516969642', 'Curlycup Gumweed');
insert into Laboratorio (CodigoLab, Nombre) values ('4038498476', 'Waxflower Shinleaf');
insert into Laboratorio (CodigoLab, Nombre) values ('9060110153', 'Sand Pygmyweed');
insert into Laboratorio (CodigoLab, Nombre) values ('4458842595', 'Link''s Blackberry');
insert into Laboratorio (CodigoLab, Nombre) values ('4827534144', 'Smallflower Wrightwort');
insert into Laboratorio (CodigoLab, Nombre) values ('8590557960', 'Hairyseed Bahia');
insert into Laboratorio (CodigoLab, Nombre) values ('6159563114', 'Sharpleaf Cancerwort');
insert into Laboratorio (CodigoLab, Nombre) values ('1768723605', 'Cheddar Pink');
insert into Laboratorio (CodigoLab, Nombre) values ('3770600088', 'Cinnamon');
insert into Laboratorio (CodigoLab, Nombre) values ('0430442157', 'Cook''s Spleenwort');
insert into Laboratorio (CodigoLab, Nombre) values ('7156793810', 'Oemleria');
insert into Laboratorio (CodigoLab, Nombre) values ('1232715190', 'Farinose Cartilage Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('6400436154', 'Elliptic Yellowwood');
insert into Laboratorio (CodigoLab, Nombre) values ('1871348811', 'Common Green Bryum Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('3614377741', 'Purple False Oat');
insert into Laboratorio (CodigoLab, Nombre) values ('4120601803', 'Hybrid Alfalfa');
insert into Laboratorio (CodigoLab, Nombre) values ('7861746526', 'Marble Canyon Spurge');
insert into Laboratorio (CodigoLab, Nombre) values ('1075073626', 'Toadflax Penstemon');
insert into Laboratorio (CodigoLab, Nombre) values ('5263809697', 'Rush Broom');
insert into Laboratorio (CodigoLab, Nombre) values ('5002671357', 'Alsike Clover');
insert into Laboratorio (CodigoLab, Nombre) values ('3673649604', 'Daisy Bush');
insert into Laboratorio (CodigoLab, Nombre) values ('4401790057', 'California Laurel');
insert into Laboratorio (CodigoLab, Nombre) values ('0033791805', 'Slender Threeseed Mercury');
insert into Laboratorio (CodigoLab, Nombre) values ('5598042339', 'Comb Forkedfern');
insert into Laboratorio (CodigoLab, Nombre) values ('1075324033', 'Chiricahua Mountain Brookweed');
insert into Laboratorio (CodigoLab, Nombre) values ('1309617201', 'Barberton Daisy');
insert into Laboratorio (CodigoLab, Nombre) values ('1705033865', 'Diamond Maidenhair');
insert into Laboratorio (CodigoLab, Nombre) values ('0695016547', 'Victorin''s Manzanita');
insert into Laboratorio (CodigoLab, Nombre) values ('3395604772', 'Dactylina Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('6974917392', 'Contorted Rimmed Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('5976261442', 'Goosefoot Violet');
insert into Laboratorio (CodigoLab, Nombre) values ('3221749325', 'Sixweeks Fescue');
insert into Laboratorio (CodigoLab, Nombre) values ('9151225565', 'Currant');
insert into Laboratorio (CodigoLab, Nombre) values ('5870086612', 'Sand Brazos-mint');
insert into Laboratorio (CodigoLab, Nombre) values ('7152646740', 'Mojave Sandwort');
insert into Laboratorio (CodigoLab, Nombre) values ('1095958291', 'Cartilage Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('6760633350', 'Rugose Rim Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('4068601348', 'Largeflower Rose Gentian');
insert into Laboratorio (CodigoLab, Nombre) values ('1451858965', 'Catjang');
insert into Laboratorio (CodigoLab, Nombre) values ('6485279946', 'Alpine Bedstraw');
insert into Laboratorio (CodigoLab, Nombre) values ('2867781523', 'Isely''s Stickpea');
insert into Laboratorio (CodigoLab, Nombre) values ('3202972316', 'Jaffueliobryum Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('2830779460', 'Chaparral Clarkia');
insert into Laboratorio (CodigoLab, Nombre) values ('1440697523', 'Pygmyflower Rockjasmine');
insert into Laboratorio (CodigoLab, Nombre) values ('7232002793', 'Bolander''s Pohlia Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('4189224081', 'Arburua Ranch Jewelflower');
insert into Laboratorio (CodigoLab, Nombre) values ('3899794079', 'Maximowicz''s Myuroclada Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('4320767616', 'Sitka Alder');
insert into Laboratorio (CodigoLab, Nombre) values ('7574191522', 'Carolina Nutrush');
insert into Laboratorio (CodigoLab, Nombre) values ('4996485841', 'Warnock''s Water-willow');
insert into Laboratorio (CodigoLab, Nombre) values ('2191850162', 'Wild Balata');
insert into Laboratorio (CodigoLab, Nombre) values ('7397538924', 'Greeneyes');
insert into Laboratorio (CodigoLab, Nombre) values ('8497439279', 'King''s Bird''s-beak');
insert into Laboratorio (CodigoLab, Nombre) values ('1079462503', 'Crocynia Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('5250433413', 'Ballhead Sandwort');
insert into Laboratorio (CodigoLab, Nombre) values ('6581727210', 'Currant Milkvetch');
insert into Laboratorio (CodigoLab, Nombre) values ('9241478772', 'Slender False Brome');
insert into Laboratorio (CodigoLab, Nombre) values ('9589554172', 'Threelobe Oxytheca');
insert into Laboratorio (CodigoLab, Nombre) values ('8199685905', 'Sweetclover Vetch');
insert into Laboratorio (CodigoLab, Nombre) values ('9420918831', 'Chinese Raspwort');
insert into Laboratorio (CodigoLab, Nombre) values ('6408690408', 'Fogfruit');
insert into Laboratorio (CodigoLab, Nombre) values ('9968622796', 'Maxon''s Tonguefern');
insert into Laboratorio (CodigoLab, Nombre) values ('5878207907', 'White Locoweed');
insert into Laboratorio (CodigoLab, Nombre) values ('3312693268', 'Contorted Pogonatum Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('0075644258', 'Indianpipe');
insert into Laboratorio (CodigoLab, Nombre) values ('8426716059', 'Contorted Sphagnum');
insert into Laboratorio (CodigoLab, Nombre) values ('0871052962', 'Sherring''s Dwarf Polypody');
insert into Laboratorio (CodigoLab, Nombre) values ('3204422925', 'Catnip');
insert into Laboratorio (CodigoLab, Nombre) values ('1234584158', 'Limestone Grass');
insert into Laboratorio (CodigoLab, Nombre) values ('2538550793', 'Sweet White Violet');
insert into Laboratorio (CodigoLab, Nombre) values ('7497901745', 'White Hawkweed');
insert into Laboratorio (CodigoLab, Nombre) values ('6396090910', 'Phaeospora');
insert into Laboratorio (CodigoLab, Nombre) values ('3037673109', 'Allegheny Brookfoam');
insert into Laboratorio (CodigoLab, Nombre) values ('2362591123', 'Malabar Plum');
insert into Laboratorio (CodigoLab, Nombre) values ('1477416617', 'Whitewoolly Buckwheat');
insert into Laboratorio (CodigoLab, Nombre) values ('1625953283', 'Sticky Blue Eyed Mary');
insert into Laboratorio (CodigoLab, Nombre) values ('9362468654', 'Forest Danafern');
insert into Laboratorio (CodigoLab, Nombre) values ('5052960182', 'Streambed Nehe');
insert into Laboratorio (CodigoLab, Nombre) values ('6027255501', 'Codiaeum');
insert into Laboratorio (CodigoLab, Nombre) values ('6370587028', 'Roundhead Prairie Clover');
insert into Laboratorio (CodigoLab, Nombre) values ('6744389041', 'Smallflower Oxtongue');
insert into Laboratorio (CodigoLab, Nombre) values ('7686987647', 'Common Viburnum');
insert into Laboratorio (CodigoLab, Nombre) values ('5651697470', 'Cory''s Mistletoe');
insert into Laboratorio (CodigoLab, Nombre) values ('5676295945', 'Fendler''s Bladderpod');
insert into Laboratorio (CodigoLab, Nombre) values ('9778654522', 'Orbignya');
insert into Laboratorio (CodigoLab, Nombre) values ('1089278047', 'Fishlock''s Croton');
insert into Laboratorio (CodigoLab, Nombre) values ('9470236491', 'Mueller''s Isopterygiopsis Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('0837756847', 'Mexican Bonebract');
insert into Laboratorio (CodigoLab, Nombre) values ('6691324447', 'Low Serviceberry');
insert into Laboratorio (CodigoLab, Nombre) values ('7337175345', 'Heartleaf Four O''clock');
insert into Laboratorio (CodigoLab, Nombre) values ('9291463116', 'Mountain Ricegrass');
insert into Laboratorio (CodigoLab, Nombre) values ('1803706295', 'Hopi Milkvetch');
insert into Laboratorio (CodigoLab, Nombre) values ('0871719886', 'Douglas'' Silverpuffs');
insert into Laboratorio (CodigoLab, Nombre) values ('8175543213', 'Rimularia Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('3350513948', 'Texas Pricklyleaf');
insert into Laboratorio (CodigoLab, Nombre) values ('3952306746', 'Sandplain Flax');
insert into Laboratorio (CodigoLab, Nombre) values ('0082136793', 'Fuscidea Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('6901426054', 'Florida Keys Seagrass');
insert into Laboratorio (CodigoLab, Nombre) values ('5057585215', 'Eaton''s Fleabane');
insert into Laboratorio (CodigoLab, Nombre) values ('3276608561', 'Longtube Iris');
insert into Laboratorio (CodigoLab, Nombre) values ('1786950618', 'Seifriz''s Chamaedorea');
insert into Laboratorio (CodigoLab, Nombre) values ('0591009471', 'Palmer''s Catchfly');
insert into Laboratorio (CodigoLab, Nombre) values ('9519197133', 'Hansen''s Cinquefoil');
insert into Laboratorio (CodigoLab, Nombre) values ('9836775870', 'Narrowleaf Bedstraw');
insert into Laboratorio (CodigoLab, Nombre) values ('8071535559', 'Rimrock Milkvetch');
insert into Laboratorio (CodigoLab, Nombre) values ('2226693939', 'White Panicle Aster');
insert into Laboratorio (CodigoLab, Nombre) values ('8242264570', 'Baltzell''s Sedge');
insert into Laboratorio (CodigoLab, Nombre) values ('5502709019', 'Water Wattle');
insert into Laboratorio (CodigoLab, Nombre) values ('4428279108', 'Sharplobe Hepatica');
insert into Laboratorio (CodigoLab, Nombre) values ('4545569625', 'Mountain Decumbent Goldenrod');
insert into Laboratorio (CodigoLab, Nombre) values ('3324170087', 'Hound''s Tongue');
insert into Laboratorio (CodigoLab, Nombre) values ('3104992371', 'Littleleaf Leadtree');
insert into Laboratorio (CodigoLab, Nombre) values ('9057964163', 'Needle Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('9614681918', 'American Umbrellaleaf');
insert into Laboratorio (CodigoLab, Nombre) values ('6904798289', 'Rio Grande Pearlhead');
insert into Laboratorio (CodigoLab, Nombre) values ('6773883245', 'Cima Milkvetch');
insert into Laboratorio (CodigoLab, Nombre) values ('4821974223', 'Thrombium Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('5324658316', 'Mt. Kaala Cyanea');
insert into Laboratorio (CodigoLab, Nombre) values ('5174153540', 'Field Eryngo');
insert into Laboratorio (CodigoLab, Nombre) values ('1992837090', 'Pottia Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('2106347391', 'Hybrid Spruce');
insert into Laboratorio (CodigoLab, Nombre) values ('6158463159', 'Texas Palafox');
insert into Laboratorio (CodigoLab, Nombre) values ('3887977920', 'Yellow Marsh Marigold');
insert into Laboratorio (CodigoLab, Nombre) values ('6776745218', 'Hollyleaved Barberry');
insert into Laboratorio (CodigoLab, Nombre) values ('0754699455', 'Feathered Mosquitofern');
insert into Laboratorio (CodigoLab, Nombre) values ('5351529726', 'Oldfield Blackberry');
insert into Laboratorio (CodigoLab, Nombre) values ('4774472026', 'Beard Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('7097088664', 'Common Crupina');
insert into Laboratorio (CodigoLab, Nombre) values ('5277530258', 'Heermann''s Buckwheat');
insert into Laboratorio (CodigoLab, Nombre) values ('0665907672', 'Sand Fringepod');
insert into Laboratorio (CodigoLab, Nombre) values ('3702697365', 'Graceful Peperomia');
insert into Laboratorio (CodigoLab, Nombre) values ('3089270153', 'Fitzgerald''s Sphagnum');
insert into Laboratorio (CodigoLab, Nombre) values ('2771555867', 'Cenizo');
insert into Laboratorio (CodigoLab, Nombre) values ('1889961612', 'Roundleaf Bladderpod');
insert into Laboratorio (CodigoLab, Nombre) values ('2958370984', 'Sphenostylis');
insert into Laboratorio (CodigoLab, Nombre) values ('7684445235', 'Schaffner''s Wattle');
insert into Laboratorio (CodigoLab, Nombre) values ('2004979356', 'Leciophysma Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('5522698047', 'Rockledge Spleenwort');
insert into Laboratorio (CodigoLab, Nombre) values ('4405435545', 'Salmon River Cryptantha');
insert into Laboratorio (CodigoLab, Nombre) values ('7564280166', 'Downy Phlox');
insert into Laboratorio (CodigoLab, Nombre) values ('5632342026', 'Treculia');
insert into Laboratorio (CodigoLab, Nombre) values ('6056658155', 'Smilograss');
insert into Laboratorio (CodigoLab, Nombre) values ('2458651992', 'California Goldenrod');
insert into Laboratorio (CodigoLab, Nombre) values ('5603708131', 'False Grama');
insert into Laboratorio (CodigoLab, Nombre) values ('7416247985', 'Oldwoman');
insert into Laboratorio (CodigoLab, Nombre) values ('0965730107', 'Fivestamen Chickweed');
insert into Laboratorio (CodigoLab, Nombre) values ('4717538838', 'Richardson''s Phlox');
insert into Laboratorio (CodigoLab, Nombre) values ('1637224346', 'San Clemente Island Triteleia');
insert into Laboratorio (CodigoLab, Nombre) values ('0752810626', 'Bryum Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('2568900814', 'Lizard''s Tail');
insert into Laboratorio (CodigoLab, Nombre) values ('4474672194', 'Shaggy Milkvetch');
insert into Laboratorio (CodigoLab, Nombre) values ('7493421366', 'Tree Anemone');
insert into Laboratorio (CodigoLab, Nombre) values ('6837062573', 'Waterhyssop');
insert into Laboratorio (CodigoLab, Nombre) values ('3539331239', 'Wright''s Bird''s Beak');
insert into Laboratorio (CodigoLab, Nombre) values ('7363782628', 'Laurel Espada');
insert into Laboratorio (CodigoLab, Nombre) values ('4089943043', 'Hartweg''s Sundrops');
insert into Laboratorio (CodigoLab, Nombre) values ('1286798795', 'Earth Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('7826584280', 'Hoptree');
insert into Laboratorio (CodigoLab, Nombre) values ('6908734862', 'Welsh''s Aster');
insert into Laboratorio (CodigoLab, Nombre) values ('6761958644', 'Claspingleaf Doll''s Daisy');
insert into Laboratorio (CodigoLab, Nombre) values ('8700735523', 'Gray''s Flatsedge');
insert into Laboratorio (CodigoLab, Nombre) values ('0882297287', 'Spiked Larkspur');
insert into Laboratorio (CodigoLab, Nombre) values ('1990648746', 'Red Rice');
insert into Laboratorio (CodigoLab, Nombre) values ('4171226635', 'Hummock Honeymyrtle');
insert into Laboratorio (CodigoLab, Nombre) values ('6467043030', 'Looseflower Water-willow');
insert into Laboratorio (CodigoLab, Nombre) values ('8644287273', 'Coast Range Triteleia');
insert into Laboratorio (CodigoLab, Nombre) values ('4849952615', 'Ruggedleaf Schlotheimia Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('9859879621', 'Pearly Everlasting');
insert into Laboratorio (CodigoLab, Nombre) values ('2202592407', 'Spring Forget-me-not');
insert into Laboratorio (CodigoLab, Nombre) values ('6303653413', 'Roughfruit Scaleseed');
insert into Laboratorio (CodigoLab, Nombre) values ('2790491631', 'Eggers'' Milkpea');
insert into Laboratorio (CodigoLab, Nombre) values ('3496896329', 'Perplexed Chiodecton Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('5353882695', 'Gray''s Cloak Fern');
insert into Laboratorio (CodigoLab, Nombre) values ('5670509390', 'Bolander''s Pohlia Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('5892938387', 'Eltrot');
insert into Laboratorio (CodigoLab, Nombre) values ('0594277493', 'New Mexico Maple');
insert into Laboratorio (CodigoLab, Nombre) values ('7799397837', 'Yellow Pincushion');
insert into Laboratorio (CodigoLab, Nombre) values ('7308465462', 'Fontinalis Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('0329227815', 'Olympic Indian Paintbrush');
insert into Laboratorio (CodigoLab, Nombre) values ('3416962036', 'American Bluehearts');
insert into Laboratorio (CodigoLab, Nombre) values ('5265847367', 'Merrill''s Lecidea Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('9352292855', 'Shortleaf Jefea');
insert into Laboratorio (CodigoLab, Nombre) values ('0341363839', 'Rotund Boesenbergia');
insert into Laboratorio (CodigoLab, Nombre) values ('2180580614', 'Thyrea Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('5010214296', 'Antelope Grass');
insert into Laboratorio (CodigoLab, Nombre) values ('8550757179', 'Green Sotol');
insert into Laboratorio (CodigoLab, Nombre) values ('8394487386', 'Serpentine Stitchwort');
insert into Laboratorio (CodigoLab, Nombre) values ('5998528484', 'Bridges'' Pincushionplant');
insert into Laboratorio (CodigoLab, Nombre) values ('0544534107', 'Ho''awa');
insert into Laboratorio (CodigoLab, Nombre) values ('4301086897', 'Desert Blazingstar');
insert into Laboratorio (CodigoLab, Nombre) values ('1513700464', 'Kauai Bottlebrush');
insert into Laboratorio (CodigoLab, Nombre) values ('1228652805', 'Red Passion-flower');
insert into Laboratorio (CodigoLab, Nombre) values ('4843799270', 'Purple Rattlesnakeroot');
insert into Laboratorio (CodigoLab, Nombre) values ('3818515271', 'Low Scleropodium Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('7568764087', 'Swartz''s Pigeonplum');
insert into Laboratorio (CodigoLab, Nombre) values ('7242017440', 'Pumpwood');
insert into Laboratorio (CodigoLab, Nombre) values ('3998265406', 'American Ocellularia Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('5031092084', 'Oil Shale Fescue');
insert into Laboratorio (CodigoLab, Nombre) values ('2378783000', 'Pyxine Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('9909738481', 'Alpine Willow');
insert into Laboratorio (CodigoLab, Nombre) values ('2602196096', 'Polymeridium Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('9131350615', 'Leatherleaf Wild Coffee');
insert into Laboratorio (CodigoLab, Nombre) values ('3983983405', 'Golden Suncup');
insert into Laboratorio (CodigoLab, Nombre) values ('5777673848', 'Thread Rush');
insert into Laboratorio (CodigoLab, Nombre) values ('4621817876', 'Payson''s Groundsel');
insert into Laboratorio (CodigoLab, Nombre) values ('5292737666', 'Warty Panicgrass');
insert into Laboratorio (CodigoLab, Nombre) values ('0963927973', 'Chihuahuan Fishhook Cactus');
insert into Laboratorio (CodigoLab, Nombre) values ('4012495372', 'Nylon Hedgehog Cactus');
insert into Laboratorio (CodigoLab, Nombre) values ('0178624195', 'Barreta');
insert into Laboratorio (CodigoLab, Nombre) values ('7118135046', 'Largeflower Tickseed');
insert into Laboratorio (CodigoLab, Nombre) values ('1276972067', 'Humboldt''s Lily');
insert into Laboratorio (CodigoLab, Nombre) values ('4198761590', 'Hawai''i Roughbush');
insert into Laboratorio (CodigoLab, Nombre) values ('8649723357', 'Silver Mock Orange');
insert into Laboratorio (CodigoLab, Nombre) values ('2386090671', 'Idaho Bentgrass');
insert into Laboratorio (CodigoLab, Nombre) values ('6755941239', 'Kahili Ridge Yellow Loosestrife');
insert into Laboratorio (CodigoLab, Nombre) values ('7991296024', 'Neofuscelia Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('6557872524', 'California Oatgrass');
insert into Laboratorio (CodigoLab, Nombre) values ('9584074377', 'Annual Wallrocket');
insert into Laboratorio (CodigoLab, Nombre) values ('4566222373', 'Southwestern White Pine');
insert into Laboratorio (CodigoLab, Nombre) values ('9803531328', 'Dunebroom');
insert into Laboratorio (CodigoLab, Nombre) values ('7361135358', 'Dwarf Checkerbloom');
insert into Laboratorio (CodigoLab, Nombre) values ('0242047076', 'Roundhead Bulrush');
insert into Laboratorio (CodigoLab, Nombre) values ('1590086244', 'Huachuca Mountain Spurge');
insert into Laboratorio (CodigoLab, Nombre) values ('4493022833', 'Seaweed Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('9047527402', 'Beyrich''s Entodon Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('0640756972', 'Rim Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('4443231455', 'Kettle Falls Lupine');
insert into Laboratorio (CodigoLab, Nombre) values ('1003375561', 'Subterranean Clover');
insert into Laboratorio (CodigoLab, Nombre) values ('4372725981', 'Columbian Mock Orange');
insert into Laboratorio (CodigoLab, Nombre) values ('0278915728', 'Hedge False Bindweed');
insert into Laboratorio (CodigoLab, Nombre) values ('6423701318', 'Diverse Porpidia Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('5096944700', 'Smooth Penstemon');
insert into Laboratorio (CodigoLab, Nombre) values ('0371362709', 'Icelandic Poppy');
insert into Laboratorio (CodigoLab, Nombre) values ('1341689794', 'Mountain Bush Honeysuckle');
insert into Laboratorio (CodigoLab, Nombre) values ('5108874022', 'Philodendron');
insert into Laboratorio (CodigoLab, Nombre) values ('6074585857', 'Tidestrom''s Lupine');
insert into Laboratorio (CodigoLab, Nombre) values ('7033805209', 'Mistmaiden');
insert into Laboratorio (CodigoLab, Nombre) values ('4720612601', 'Heterodraba');
insert into Laboratorio (CodigoLab, Nombre) values ('4303861421', 'Texas Plains Indian Breadroot');
insert into Laboratorio (CodigoLab, Nombre) values ('8231589562', 'Map Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('3985015066', 'Nuttall''s Quillwort');
insert into Laboratorio (CodigoLab, Nombre) values ('7836200051', 'Maidenberry');
insert into Laboratorio (CodigoLab, Nombre) values ('1479386030', 'Maricao Cimun');
insert into Laboratorio (CodigoLab, Nombre) values ('6221936179', 'Distictis');
insert into Laboratorio (CodigoLab, Nombre) values ('6212792755', 'Twobristle Rockdaisy');
insert into Laboratorio (CodigoLab, Nombre) values ('3189267987', 'Thatching Grass');
insert into Laboratorio (CodigoLab, Nombre) values ('7294541469', 'Crinkleawn Fescue');
insert into Laboratorio (CodigoLab, Nombre) values ('5128628280', 'American Alpine Speedwell');
insert into Laboratorio (CodigoLab, Nombre) values ('2445325404', 'Manystem Blazingstar');
insert into Laboratorio (CodigoLab, Nombre) values ('3850712206', 'Islandthicket Threeawn');
insert into Laboratorio (CodigoLab, Nombre) values ('5772330160', 'Nootka Lupine');
insert into Laboratorio (CodigoLab, Nombre) values ('9590103510', 'Michaux''s Snoutbean');
insert into Laboratorio (CodigoLab, Nombre) values ('5154000439', 'Colorado Cinquefoil');
insert into Laboratorio (CodigoLab, Nombre) values ('8452536208', 'Peck''s Sedge');
insert into Laboratorio (CodigoLab, Nombre) values ('9519218408', 'Mountain Wavy Hairgrass');
insert into Laboratorio (CodigoLab, Nombre) values ('6024978669', 'Pholisma');
insert into Laboratorio (CodigoLab, Nombre) values ('5035164535', 'Sargent''s Apple');
insert into Laboratorio (CodigoLab, Nombre) values ('4223711105', 'Strawberry');
insert into Laboratorio (CodigoLab, Nombre) values ('1831153416', 'Sand Goldenrod');
insert into Laboratorio (CodigoLab, Nombre) values ('5441970553', 'Meesia Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('9915120125', 'Climbing False Buckwheat');
insert into Laboratorio (CodigoLab, Nombre) values ('2721896164', 'Spikemoss');
insert into Laboratorio (CodigoLab, Nombre) values ('0870220330', 'Roughpod Bladderpod');
insert into Laboratorio (CodigoLab, Nombre) values ('8648730686', 'Manchineel Berry');
insert into Laboratorio (CodigoLab, Nombre) values ('9593803017', 'Glaucous Bluegrass');
insert into Laboratorio (CodigoLab, Nombre) values ('9842095266', 'Conimitella');
insert into Laboratorio (CodigoLab, Nombre) values ('3941666010', 'Veronicastrum');
insert into Laboratorio (CodigoLab, Nombre) values ('8027573890', 'Nevada Pussypaws');
insert into Laboratorio (CodigoLab, Nombre) values ('7099894900', 'Vine Hill Manzanita');
insert into Laboratorio (CodigoLab, Nombre) values ('6028454648', 'Hybrid Oak');
insert into Laboratorio (CodigoLab, Nombre) values ('1857886240', 'Open Clover');
insert into Laboratorio (CodigoLab, Nombre) values ('0191175617', 'Alpine Feverfew');
insert into Laboratorio (CodigoLab, Nombre) values ('4444913312', 'Diogenes'' Lantern');
insert into Laboratorio (CodigoLab, Nombre) values ('5358211721', 'Balloon Sack Clover');
insert into Laboratorio (CodigoLab, Nombre) values ('6385515567', 'Nightshade');
insert into Laboratorio (CodigoLab, Nombre) values ('1924389088', 'Lemon Lily');
insert into Laboratorio (CodigoLab, Nombre) values ('7448590936', 'Willowleaf Candyleaf');
insert into Laboratorio (CodigoLab, Nombre) values ('8005088078', 'Rapp''s Biatorella Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('3196479005', 'Japanese Chestnut');
insert into Laboratorio (CodigoLab, Nombre) values ('0491340397', 'Jacanillo');
insert into Laboratorio (CodigoLab, Nombre) values ('6374388860', 'Grove Hawthorn');
insert into Laboratorio (CodigoLab, Nombre) values ('1282473964', 'Norwegian Ragged Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('4830211776', 'Autumn Coralroot');
insert into Laboratorio (CodigoLab, Nombre) values ('5184367861', 'Canereed');
insert into Laboratorio (CodigoLab, Nombre) values ('2468576233', 'San Luis Obispo Wallflower');
insert into Laboratorio (CodigoLab, Nombre) values ('6740328617', 'Grape Soda Lupine');
insert into Laboratorio (CodigoLab, Nombre) values ('9571673617', 'Russethair Saxifrage');
insert into Laboratorio (CodigoLab, Nombre) values ('2248133324', 'Santa Cruz Mountains Beardtongue');
insert into Laboratorio (CodigoLab, Nombre) values ('7038584146', 'Lancepod');
insert into Laboratorio (CodigoLab, Nombre) values ('4341510045', 'Honeycombhead');
insert into Laboratorio (CodigoLab, Nombre) values ('9846354371', 'Rainbow Iris');
insert into Laboratorio (CodigoLab, Nombre) values ('2867820340', 'Robust Spineflower');
insert into Laboratorio (CodigoLab, Nombre) values ('8772560258', 'Macawflower');
insert into Laboratorio (CodigoLab, Nombre) values ('9740890717', 'Urnflower Alumroot');
insert into Laboratorio (CodigoLab, Nombre) values ('5524771760', 'Moldy Bread And Cheese');
insert into Laboratorio (CodigoLab, Nombre) values ('4090887879', 'Texas Barberry');
insert into Laboratorio (CodigoLab, Nombre) values ('3171415178', 'Hoary Pincushionplant');
insert into Laboratorio (CodigoLab, Nombre) values ('4295900753', 'Bryum Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('4215000033', 'Nutzotin Milkvetch');
insert into Laboratorio (CodigoLab, Nombre) values ('3415685772', 'Warty Bedstraw');
insert into Laboratorio (CodigoLab, Nombre) values ('3866047088', 'Organ Mountain Figwort');
insert into Laboratorio (CodigoLab, Nombre) values ('8219718307', 'Bocconia');
insert into Laboratorio (CodigoLab, Nombre) values ('8605256435', 'Aguinaldo Blanco');
insert into Laboratorio (CodigoLab, Nombre) values ('7879237194', 'Quebec Sedge');
insert into Laboratorio (CodigoLab, Nombre) values ('2050619839', 'Sugarberry');
insert into Laboratorio (CodigoLab, Nombre) values ('6540694369', 'Sand Muhly');
insert into Laboratorio (CodigoLab, Nombre) values ('6081814513', 'Manyflower Sandmallow');
insert into Laboratorio (CodigoLab, Nombre) values ('0690184360', 'Santa Cruz Island Fringepod');
insert into Laboratorio (CodigoLab, Nombre) values ('8036874431', 'Ma Huang');
insert into Laboratorio (CodigoLab, Nombre) values ('0892880023', 'Long-flower Marlock');
insert into Laboratorio (CodigoLab, Nombre) values ('4386266283', 'Acute Indian Paintbrush');
insert into Laboratorio (CodigoLab, Nombre) values ('1288502397', 'Purple False Horkelia');
insert into Laboratorio (CodigoLab, Nombre) values ('1764647793', 'Pauper Milkvetch');
insert into Laboratorio (CodigoLab, Nombre) values ('1593223900', 'Kilauea Hau Kuahiwi');
insert into Laboratorio (CodigoLab, Nombre) values ('6317041571', 'Xerophytic Limestone Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('7067753090', 'Sierra Madre Larkspur');
insert into Laboratorio (CodigoLab, Nombre) values ('3195272059', 'African Morningvine');
insert into Laboratorio (CodigoLab, Nombre) values ('5971896407', 'Ruby Mountain Buckwheat');
insert into Laboratorio (CodigoLab, Nombre) values ('3860473352', 'Great Fern');
insert into Laboratorio (CodigoLab, Nombre) values ('0791162230', 'Lindheimer''s Globeberry');
insert into Laboratorio (CodigoLab, Nombre) values ('7126140959', 'Rusby''s Rubberweed');
insert into Laboratorio (CodigoLab, Nombre) values ('8610743950', 'Episcia');
insert into Laboratorio (CodigoLab, Nombre) values ('9740442323', 'Dwarf Waterclover');
insert into Laboratorio (CodigoLab, Nombre) values ('4543240502', 'Christmas Fern');
insert into Laboratorio (CodigoLab, Nombre) values ('6959565278', 'Plains Ironweed');
insert into Laboratorio (CodigoLab, Nombre) values ('1160021783', 'Big-sage');
insert into Laboratorio (CodigoLab, Nombre) values ('6970902986', 'Olaga');
insert into Laboratorio (CodigoLab, Nombre) values ('6467146921', 'Howell''s Lewisia');
insert into Laboratorio (CodigoLab, Nombre) values ('1205297367', 'Nimblewill');
insert into Laboratorio (CodigoLab, Nombre) values ('1579732402', 'Sweet Tanglehead');
insert into Laboratorio (CodigoLab, Nombre) values ('6635025499', 'Puerto Rico Alfilerillo');
insert into Laboratorio (CodigoLab, Nombre) values ('4779509327', 'Spreading Sandwort');
insert into Laboratorio (CodigoLab, Nombre) values ('3608288929', 'Coast Indian Paintbrush');
insert into Laboratorio (CodigoLab, Nombre) values ('5820405587', 'False Christmas Cactus');
insert into Laboratorio (CodigoLab, Nombre) values ('7787540680', 'Dermiscellum Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('6210733433', 'Cephalanthera');
insert into Laboratorio (CodigoLab, Nombre) values ('3119331791', 'Carissa');
insert into Laboratorio (CodigoLab, Nombre) values ('6197721066', 'Macadamia');
insert into Laboratorio (CodigoLab, Nombre) values ('9170393451', 'Bolander''s Woodland-star');
insert into Laboratorio (CodigoLab, Nombre) values ('9244874156', 'Emory''s Globemallow');
insert into Laboratorio (CodigoLab, Nombre) values ('0611658682', 'Oreas Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('8774675249', 'Red Brome');
insert into Laboratorio (CodigoLab, Nombre) values ('4891419253', 'Scarlet Fritillary');
insert into Laboratorio (CodigoLab, Nombre) values ('4314252022', 'Dawson''s Angelica');
insert into Laboratorio (CodigoLab, Nombre) values ('9334651237', 'Western White Clematis');
insert into Laboratorio (CodigoLab, Nombre) values ('7165871608', 'Rinodina Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('2041343672', 'Tibig');
insert into Laboratorio (CodigoLab, Nombre) values ('4202597737', 'Brazilian Red-cloak');
insert into Laboratorio (CodigoLab, Nombre) values ('1746313056', 'Cuachilote');
insert into Laboratorio (CodigoLab, Nombre) values ('1643680102', 'Redscale Shoestring Fern');
insert into Laboratorio (CodigoLab, Nombre) values ('4919583281', 'Lamp Rush');
insert into Laboratorio (CodigoLab, Nombre) values ('6642658795', 'Limahuli Valley Pritchardia');
insert into Laboratorio (CodigoLab, Nombre) values ('4124512171', 'Valley Lessingia');
insert into Laboratorio (CodigoLab, Nombre) values ('5089788146', 'Mexican Navelwort');
insert into Laboratorio (CodigoLab, Nombre) values ('7872043688', 'Woodland Climbing Bamboo');
insert into Laboratorio (CodigoLab, Nombre) values ('9219723417', 'Pensacola Hawthorn');
insert into Laboratorio (CodigoLab, Nombre) values ('6403200887', 'Mojave Dwarf');
insert into Laboratorio (CodigoLab, Nombre) values ('9263103100', 'Bahama Sachsia');
insert into Laboratorio (CodigoLab, Nombre) values ('2008190188', 'Aloe');
insert into Laboratorio (CodigoLab, Nombre) values ('8477769648', 'Pancratium');
insert into Laboratorio (CodigoLab, Nombre) values ('2764957866', 'Chaparral Checkerbloom');
insert into Laboratorio (CodigoLab, Nombre) values ('1978984634', 'European Hornbeam');
insert into Laboratorio (CodigoLab, Nombre) values ('8626321740', 'Flymallow');
insert into Laboratorio (CodigoLab, Nombre) values ('6089874868', 'Alexandrian Senna');
insert into Laboratorio (CodigoLab, Nombre) values ('0248735705', 'Green Bulrush');
insert into Laboratorio (CodigoLab, Nombre) values ('1051354803', 'Mendocino Sphagnum');
insert into Laboratorio (CodigoLab, Nombre) values ('5637929890', 'Nebraska Aster');
insert into Laboratorio (CodigoLab, Nombre) values ('0883843307', 'Whitemouth Dayflower');
insert into Laboratorio (CodigoLab, Nombre) values ('1810351642', 'Macoun''s Pore Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('8140432938', 'Obsolete Polyblastia Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('9037965482', 'Saltmeadow Cordgrass');
insert into Laboratorio (CodigoLab, Nombre) values ('3300116317', 'Andrews'' Clover');
insert into Laboratorio (CodigoLab, Nombre) values ('2287806881', 'Texas Pricklypear');
insert into Laboratorio (CodigoLab, Nombre) values ('2580683305', 'Peanut');
insert into Laboratorio (CodigoLab, Nombre) values ('8777206940', 'Santa Lucia Manzanita');
insert into Laboratorio (CodigoLab, Nombre) values ('2810600295', 'Largeseed Bittercress');
insert into Laboratorio (CodigoLab, Nombre) values ('8890370173', 'Forbes''s Hawthorn');
insert into Laboratorio (CodigoLab, Nombre) values ('8884902843', 'Narrowleaf Indian Breadroot');
insert into Laboratorio (CodigoLab, Nombre) values ('6383740512', 'Hemlock Rosette Grass');
insert into Laboratorio (CodigoLab, Nombre) values ('2285699190', 'Shortleaf Yelloweyed Grass');
insert into Laboratorio (CodigoLab, Nombre) values ('7907685656', 'Decumaria');
insert into Laboratorio (CodigoLab, Nombre) values ('4647420884', 'Argus'' Willow');
insert into Laboratorio (CodigoLab, Nombre) values ('3940504793', 'Whisperingbells');
insert into Laboratorio (CodigoLab, Nombre) values ('4132942155', 'Waterweed');
insert into Laboratorio (CodigoLab, Nombre) values ('4974786954', 'Bohemian Knotweed');
insert into Laboratorio (CodigoLab, Nombre) values ('0468439838', 'Water Pygmyweed');
insert into Laboratorio (CodigoLab, Nombre) values ('9016262628', 'Rock Creek Broomrape');
insert into Laboratorio (CodigoLab, Nombre) values ('6198536211', 'Elegant Cinquefoil');
insert into Laboratorio (CodigoLab, Nombre) values ('0700930531', 'Howell''s Marsh Marigold');
insert into Laboratorio (CodigoLab, Nombre) values ('7137145477', 'Plains Blackberry');
insert into Laboratorio (CodigoLab, Nombre) values ('8053693474', 'Green Prairie Coneflower');
insert into Laboratorio (CodigoLab, Nombre) values ('1246580527', 'Chapman''s Milkwort');
insert into Laboratorio (CodigoLab, Nombre) values ('7252945618', 'Heartleaf Speedwell');
insert into Laboratorio (CodigoLab, Nombre) values ('2021061965', 'New Zealand Flax');
insert into Laboratorio (CodigoLab, Nombre) values ('8457700790', 'Wildrye');
insert into Laboratorio (CodigoLab, Nombre) values ('4243962111', 'Higuerillo');
insert into Laboratorio (CodigoLab, Nombre) values ('4991139228', 'Mountain Witchalder');
insert into Laboratorio (CodigoLab, Nombre) values ('5299847386', 'Sporastatia Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('5912225356', 'Common Filbert');
insert into Laboratorio (CodigoLab, Nombre) values ('1698573634', 'Rooted Poppy');
insert into Laboratorio (CodigoLab, Nombre) values ('4533649262', 'Groundcone');
insert into Laboratorio (CodigoLab, Nombre) values ('7172989538', 'Florida Silver Palm');
insert into Laboratorio (CodigoLab, Nombre) values ('4388372854', 'Pineland Scalypink');
insert into Laboratorio (CodigoLab, Nombre) values ('6167138141', 'Hawthorn');
insert into Laboratorio (CodigoLab, Nombre) values ('0249986191', 'Hawai''i Dogweed');
insert into Laboratorio (CodigoLab, Nombre) values ('0564285870', 'Bitter Yam');
insert into Laboratorio (CodigoLab, Nombre) values ('2686083743', 'Stereophyllum Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('3389084134', 'Yellow Avalanche-lily');
insert into Laboratorio (CodigoLab, Nombre) values ('3335239512', 'Fewflower Clover');
insert into Laboratorio (CodigoLab, Nombre) values ('8736231037', 'Tropical Panicgrass');
insert into Laboratorio (CodigoLab, Nombre) values ('1352562944', 'Spring Phacelia');
insert into Laboratorio (CodigoLab, Nombre) values ('9941338493', 'Hammock Sedge');
insert into Laboratorio (CodigoLab, Nombre) values ('1893776492', 'Smallhead Clover');
insert into Laboratorio (CodigoLab, Nombre) values ('6926662800', 'Immersaria Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('3219365892', 'St. Catherine''s Lace');
insert into Laboratorio (CodigoLab, Nombre) values ('8059161105', 'Downy Indian Paintbrush');
insert into Laboratorio (CodigoLab, Nombre) values ('2156935769', 'Hill''s Lupine');
insert into Laboratorio (CodigoLab, Nombre) values ('8469839993', 'Payson''s Bladderpod');
insert into Laboratorio (CodigoLab, Nombre) values ('8624630835', 'Lesser Rushy Milkvetch');
insert into Laboratorio (CodigoLab, Nombre) values ('8668524135', 'Myrin''s Aspicilia');
insert into Laboratorio (CodigoLab, Nombre) values ('2832928900', 'Christiansen''s Hobsonia Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('9296388961', 'Orange Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('3587048606', 'Common Gum Cistus');
insert into Laboratorio (CodigoLab, Nombre) values ('6676312867', 'Texas Stork''s Bill');
insert into Laboratorio (CodigoLab, Nombre) values ('4812134242', 'Case''s Lady''s Tresses');
insert into Laboratorio (CodigoLab, Nombre) values ('5477900202', 'New Mexico Xanthoparmelia Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('3790167924', 'Windmills');
insert into Laboratorio (CodigoLab, Nombre) values ('0902243438', 'Pale Grasspink');
insert into Laboratorio (CodigoLab, Nombre) values ('0627185983', 'Gongolin');
insert into Laboratorio (CodigoLab, Nombre) values ('4466482225', 'Pale Gentian');
insert into Laboratorio (CodigoLab, Nombre) values ('5515917286', 'Haller''s Campylium Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('3082383459', 'Manzanita');
insert into Laboratorio (CodigoLab, Nombre) values ('6342784477', 'Brandegee''s Buttercup');
insert into Laboratorio (CodigoLab, Nombre) values ('3514979243', 'Trapeliopsis Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('5609290414', 'Jamaican Crabgrass');
insert into Laboratorio (CodigoLab, Nombre) values ('4579392795', 'Clokey''s Greasebush');
insert into Laboratorio (CodigoLab, Nombre) values ('6693564070', 'Thicket Panicgrass');
insert into Laboratorio (CodigoLab, Nombre) values ('5975300711', 'Lacy Tansyaster');
insert into Laboratorio (CodigoLab, Nombre) values ('4974329561', 'Nardoo');
insert into Laboratorio (CodigoLab, Nombre) values ('6368599855', 'Desert Date');
insert into Laboratorio (CodigoLab, Nombre) values ('9546432202', 'Bitter Cherry');
insert into Laboratorio (CodigoLab, Nombre) values ('1537936190', 'Southern Quillwort');
insert into Laboratorio (CodigoLab, Nombre) values ('9477625035', 'Rio Grande Gilia');
insert into Laboratorio (CodigoLab, Nombre) values ('2275907092', 'Desertsenna');
insert into Laboratorio (CodigoLab, Nombre) values ('5623694969', 'Cypress Panicgrass');
insert into Laboratorio (CodigoLab, Nombre) values ('5321750815', 'Park Milkvetch');
insert into Laboratorio (CodigoLab, Nombre) values ('7159439228', 'Arrowleaf Mallow');
insert into Laboratorio (CodigoLab, Nombre) values ('7321786110', 'Hoary Blackfoot');
insert into Laboratorio (CodigoLab, Nombre) values ('4521179711', 'Wright''s Beaksedge');
insert into Laboratorio (CodigoLab, Nombre) values ('5771498602', 'Oxytheca');
insert into Laboratorio (CodigoLab, Nombre) values ('5856346572', 'Ash Meadows Gumweed');
insert into Laboratorio (CodigoLab, Nombre) values ('5660213081', 'Sclerophora Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('4839574375', 'Vervain');
insert into Laboratorio (CodigoLab, Nombre) values ('8454412425', 'Florida Toadwood');
insert into Laboratorio (CodigoLab, Nombre) values ('9238252440', 'Zarzabacoa Peluda');
insert into Laboratorio (CodigoLab, Nombre) values ('0086570560', 'Lathrocasis');
insert into Laboratorio (CodigoLab, Nombre) values ('2864129132', 'Lemmon''s Yampah');
insert into Laboratorio (CodigoLab, Nombre) values ('1709483385', 'Skin Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('0906745306', 'Smooth Babybonnets');
insert into Laboratorio (CodigoLab, Nombre) values ('8705749697', 'Spleenwort');
insert into Laboratorio (CodigoLab, Nombre) values ('8637872441', 'Shy Wallflower');
insert into Laboratorio (CodigoLab, Nombre) values ('0804418551', 'Archontophoenix');
insert into Laboratorio (CodigoLab, Nombre) values ('8111950195', 'Simpson''s Grasspink');
insert into Laboratorio (CodigoLab, Nombre) values ('1388433214', 'Island Sagebrush');
insert into Laboratorio (CodigoLab, Nombre) values ('4715373920', 'Butter And Eggs');
insert into Laboratorio (CodigoLab, Nombre) values ('2255648172', 'Wright''s Cudweed');
insert into Laboratorio (CodigoLab, Nombre) values ('1375155059', 'Adirondack Rinodina Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('6120559795', 'Carolina Wild Petunia');
insert into Laboratorio (CodigoLab, Nombre) values ('3261042427', 'Hualapai Blazingstar');
insert into Laboratorio (CodigoLab, Nombre) values ('3054644111', 'Cusick''s Sedge');
insert into Laboratorio (CodigoLab, Nombre) values ('4611646505', 'Small''s Jointweed');
insert into Laboratorio (CodigoLab, Nombre) values ('9831459423', 'Rim Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('3502647798', 'Myrsine-leaved Willow');
insert into Laboratorio (CodigoLab, Nombre) values ('3457792437', 'Tropic Trypelthelium Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('7306288733', 'Foothill Clover');
insert into Laboratorio (CodigoLab, Nombre) values ('7947512892', 'Keil''s Erigeron');
insert into Laboratorio (CodigoLab, Nombre) values ('6899671891', 'Annual Wildrice');
insert into Laboratorio (CodigoLab, Nombre) values ('2799778194', 'Willamette Fleabane');
insert into Laboratorio (CodigoLab, Nombre) values ('4964401588', 'Chinquapin');
insert into Laboratorio (CodigoLab, Nombre) values ('3195905884', 'Mexican Prairie Clover');
insert into Laboratorio (CodigoLab, Nombre) values ('2016392878', 'Timber Milkvetch');
insert into Laboratorio (CodigoLab, Nombre) values ('0911263691', 'Arnold''s Silverskin Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('1502015196', 'Flor De Conchitas');
insert into Laboratorio (CodigoLab, Nombre) values ('5223236181', 'Beard Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('0305885928', 'Nevada Catchfly');
insert into Laboratorio (CodigoLab, Nombre) values ('1453474323', 'Fiveleaf Clover');
insert into Laboratorio (CodigoLab, Nombre) values ('1917122764', 'Snow Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('1526269627', 'Gilia');
insert into Laboratorio (CodigoLab, Nombre) values ('0588552232', 'High Mountain Cinquefoil');
insert into Laboratorio (CodigoLab, Nombre) values ('1354002490', 'Boreal Starwort');
insert into Laboratorio (CodigoLab, Nombre) values ('3560531241', 'Horsehair Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('5741840647', 'Hareleaf');
insert into Laboratorio (CodigoLab, Nombre) values ('5420695820', 'Dactylospora Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('8155091805', 'Holy Dandelion');
insert into Laboratorio (CodigoLab, Nombre) values ('6233628911', 'Wildrye');
insert into Laboratorio (CodigoLab, Nombre) values ('6573582004', 'Seaside Goldenrod');
insert into Laboratorio (CodigoLab, Nombre) values ('8710036326', 'Smallspore Map Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('3081132576', 'Pacific Buttercup');
insert into Laboratorio (CodigoLab, Nombre) values ('4586838884', 'Red Silk Cottontree');
insert into Laboratorio (CodigoLab, Nombre) values ('0463481526', 'Variableleaf Sunflower');
insert into Laboratorio (CodigoLab, Nombre) values ('8497462432', 'Pacific Poison Oak');
insert into Laboratorio (CodigoLab, Nombre) values ('3942274760', 'Bering Chickweed');
insert into Laboratorio (CodigoLab, Nombre) values ('6723968026', 'Angelon');
insert into Laboratorio (CodigoLab, Nombre) values ('6643387507', 'Blumer Buckthorn');
insert into Laboratorio (CodigoLab, Nombre) values ('1427617023', 'Yellowishwhite Bladderwort');
insert into Laboratorio (CodigoLab, Nombre) values ('6972259290', 'Manila Grass');
insert into Laboratorio (CodigoLab, Nombre) values ('3064671715', 'Orthodontium Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('9340702182', 'Standish''s Honeysuckle');
insert into Laboratorio (CodigoLab, Nombre) values ('4955613322', 'Silvergrass');
insert into Laboratorio (CodigoLab, Nombre) values ('6750528406', 'Turban Prickly Pear');
insert into Laboratorio (CodigoLab, Nombre) values ('9169786216', 'Fruitleaf Knotweed');
insert into Laboratorio (CodigoLab, Nombre) values ('0705211878', 'Indigo');
insert into Laboratorio (CodigoLab, Nombre) values ('1880164337', 'Pineland Chaffhead');
insert into Laboratorio (CodigoLab, Nombre) values ('7488506049', 'Lemmon''s Brickellbush');
insert into Laboratorio (CodigoLab, Nombre) values ('2201493162', 'Elegant Silverpuffs');
insert into Laboratorio (CodigoLab, Nombre) values ('3280112702', 'Cupey De Monte');
insert into Laboratorio (CodigoLab, Nombre) values ('5778474822', 'Spotted Felt Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('7996632227', 'Ohio Buckeye');
insert into Laboratorio (CodigoLab, Nombre) values ('7704764632', 'Henderson''s Wavewing');
insert into Laboratorio (CodigoLab, Nombre) values ('6810829490', 'Barbasco');
insert into Laboratorio (CodigoLab, Nombre) values ('5197192097', 'Red Triangles');
insert into Laboratorio (CodigoLab, Nombre) values ('7681454861', 'Lanceleaf Tickseed');
insert into Laboratorio (CodigoLab, Nombre) values ('3728819360', 'Hedlund''s Dot Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('9072386256', 'Robust Suncup');
insert into Laboratorio (CodigoLab, Nombre) values ('8781027885', 'California Thelomma Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('6436263632', 'Kalmiopsis');
insert into Laboratorio (CodigoLab, Nombre) values ('7908872808', 'Purpleflowering Raspberry');
insert into Laboratorio (CodigoLab, Nombre) values ('2233904680', 'Poorman''s Patch');
insert into Laboratorio (CodigoLab, Nombre) values ('6401440309', 'Smallflower Miterwort');
insert into Laboratorio (CodigoLab, Nombre) values ('5084590402', 'Feltleaf Monardella');
insert into Laboratorio (CodigoLab, Nombre) values ('1251750877', 'Great Burnet');
insert into Laboratorio (CodigoLab, Nombre) values ('8980932944', 'Turbina');
insert into Laboratorio (CodigoLab, Nombre) values ('5346207082', 'Needle Stonecrop');
insert into Laboratorio (CodigoLab, Nombre) values ('2946035158', 'Tall Tumblemustard');
insert into Laboratorio (CodigoLab, Nombre) values ('7372823927', 'Yukon Whitlowgrass');
insert into Laboratorio (CodigoLab, Nombre) values ('6060240178', 'Hairy-lemma Barley');
insert into Laboratorio (CodigoLab, Nombre) values ('5187436325', 'Jost Van Dyke''s Indian Mallow');
insert into Laboratorio (CodigoLab, Nombre) values ('6304653751', 'Stiffstem Saxifrage');
insert into Laboratorio (CodigoLab, Nombre) values ('9121312494', 'Pine Needlegrass');
insert into Laboratorio (CodigoLab, Nombre) values ('7449532034', 'Privet Honeysuckle');
insert into Laboratorio (CodigoLab, Nombre) values ('7339875298', 'Licorice Fern');
insert into Laboratorio (CodigoLab, Nombre) values ('6134175412', 'Hasse''s Vetch');
insert into Laboratorio (CodigoLab, Nombre) values ('6079391716', 'Smut Grass');
insert into Laboratorio (CodigoLab, Nombre) values ('2593817437', 'Dot Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('3287778390', 'Piedmont Staggerbush');
insert into Laboratorio (CodigoLab, Nombre) values ('9416131199', 'Kudzu');
insert into Laboratorio (CodigoLab, Nombre) values ('7643986894', 'Deflexed Brachiaria');
insert into Laboratorio (CodigoLab, Nombre) values ('5280171786', 'Scribner''s Rosette Grass');
insert into Laboratorio (CodigoLab, Nombre) values ('6667158958', 'Red Ribbons');
insert into Laboratorio (CodigoLab, Nombre) values ('6348459772', 'Ashen Milkvetch');
insert into Laboratorio (CodigoLab, Nombre) values ('7144464108', 'Silky Mousetail');
insert into Laboratorio (CodigoLab, Nombre) values ('2706682655', 'Swamp Cottonwood');
insert into Laboratorio (CodigoLab, Nombre) values ('0979672090', 'Globe Amaranth');
insert into Laboratorio (CodigoLab, Nombre) values ('2449808396', 'Cyprus-vetch');
insert into Laboratorio (CodigoLab, Nombre) values ('8381590108', 'New Mexico Goosefoot');
insert into Laboratorio (CodigoLab, Nombre) values ('4070836055', 'Whiteleaf Manzanita');
insert into Laboratorio (CodigoLab, Nombre) values ('1807273148', 'Cardinal Catchfly');
insert into Laboratorio (CodigoLab, Nombre) values ('9471431972', 'Nonesuch Daffodil');
insert into Laboratorio (CodigoLab, Nombre) values ('9173497231', 'Deam''s Beardtongue');
insert into Laboratorio (CodigoLab, Nombre) values ('9621510031', 'False Aloe');
insert into Laboratorio (CodigoLab, Nombre) values ('6714653751', 'Stroganowia');
insert into Laboratorio (CodigoLab, Nombre) values ('7514276025', 'Chirriador');
insert into Laboratorio (CodigoLab, Nombre) values ('7591941348', 'Peucedanum');
insert into Laboratorio (CodigoLab, Nombre) values ('3421633231', 'Threenerve Fleabane');
insert into Laboratorio (CodigoLab, Nombre) values ('8069048050', 'Santa Catalina Island Manzanita');
insert into Laboratorio (CodigoLab, Nombre) values ('9644975340', 'Dicranum Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('5094708635', 'Bur-reed Sedge');
insert into Laboratorio (CodigoLab, Nombre) values ('5002128564', 'Fall Tansyaster');
insert into Laboratorio (CodigoLab, Nombre) values ('5511835447', 'Pigeonpea');
insert into Laboratorio (CodigoLab, Nombre) values ('1762991128', 'Seaside Brome');
insert into Laboratorio (CodigoLab, Nombre) values ('4448434427', 'Sargent''s Apple');
insert into Laboratorio (CodigoLab, Nombre) values ('2447507607', 'Western Blue Virginsbower');
insert into Laboratorio (CodigoLab, Nombre) values ('1043561544', 'Lonestar Gumweed');
insert into Laboratorio (CodigoLab, Nombre) values ('2692469437', 'Taiwan Kudzu');
insert into Laboratorio (CodigoLab, Nombre) values ('2373687046', 'Bladderpod');
insert into Laboratorio (CodigoLab, Nombre) values ('6484580359', 'Silvertop Stringybark');
insert into Laboratorio (CodigoLab, Nombre) values ('3306359300', 'French Rose');
insert into Laboratorio (CodigoLab, Nombre) values ('8304329611', 'Oriental Poppy');
insert into Laboratorio (CodigoLab, Nombre) values ('9191084059', 'Acid-loving Sedge');
insert into Laboratorio (CodigoLab, Nombre) values ('4097019325', 'Acuminate Brachythecium Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('1912846764', 'Haussknecht''s Atrichum Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('1496540174', 'Cadillo Anaranjado');
insert into Laboratorio (CodigoLab, Nombre) values ('7204572491', 'Cuban Purslane');
insert into Laboratorio (CodigoLab, Nombre) values ('5979533575', 'Football Fruit');
insert into Laboratorio (CodigoLab, Nombre) values ('0779693922', 'King''s Serpentweed');
insert into Laboratorio (CodigoLab, Nombre) values ('4436985741', 'Beautiful Rockcress');
insert into Laboratorio (CodigoLab, Nombre) values ('2131787138', 'Biscayne Pricklyash');
insert into Laboratorio (CodigoLab, Nombre) values ('0714105198', 'Bluestem');
insert into Laboratorio (CodigoLab, Nombre) values ('2943493279', 'Isopterygium Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('4738004905', 'Drummond''s Dropseed');
insert into Laboratorio (CodigoLab, Nombre) values ('3311664868', 'Rim Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('1976160618', 'Flattened Pipewort');
insert into Laboratorio (CodigoLab, Nombre) values ('0244733090', 'Snow On The Prairie');
insert into Laboratorio (CodigoLab, Nombre) values ('2439152315', 'Kingdevil');
insert into Laboratorio (CodigoLab, Nombre) values ('6020045625', 'Spidergrass');
insert into Laboratorio (CodigoLab, Nombre) values ('1875137688', 'Littleleaf Milkpea');
insert into Laboratorio (CodigoLab, Nombre) values ('2907989685', 'Delicate Bluegrass');
insert into Laboratorio (CodigoLab, Nombre) values ('2310976431', 'False Goat''s Beard');
insert into Laboratorio (CodigoLab, Nombre) values ('1473166217', 'Calymperes Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('8395056664', 'Gaspé Willow');
insert into Laboratorio (CodigoLab, Nombre) values ('9710521217', 'St. Thomas Staggerbush');
insert into Laboratorio (CodigoLab, Nombre) values ('2468930150', 'Leafy Lespedeza');
insert into Laboratorio (CodigoLab, Nombre) values ('5510689277', 'Nicaraguan Fountaingrass');
insert into Laboratorio (CodigoLab, Nombre) values ('1055057625', 'Coastal Bristlegrass');
insert into Laboratorio (CodigoLab, Nombre) values ('9184830441', 'Graphina Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('4406640940', 'Klotzsch''s Brachymenium Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('2863463926', 'Candelilla');
insert into Laboratorio (CodigoLab, Nombre) values ('7737698647', 'Arizona Sunflower');
insert into Laboratorio (CodigoLab, Nombre) values ('3901230645', 'Sand Pink');
insert into Laboratorio (CodigoLab, Nombre) values ('3399929005', 'Saltmarsh Sea Lavender');
insert into Laboratorio (CodigoLab, Nombre) values ('3599802106', 'Roughleaf Coneflower');
insert into Laboratorio (CodigoLab, Nombre) values ('1125366702', 'Laxmann''s Milkvetch');
insert into Laboratorio (CodigoLab, Nombre) values ('0151263655', 'Yellow Nutsedge');
insert into Laboratorio (CodigoLab, Nombre) values ('1453696423', 'Yellow White Larkspur');
insert into Laboratorio (CodigoLab, Nombre) values ('2750348617', 'Cudweed');
insert into Laboratorio (CodigoLab, Nombre) values ('1351886525', 'Flat-top Broomrape');
insert into Laboratorio (CodigoLab, Nombre) values ('7993988926', 'West Humboldt Buckwheat');
insert into Laboratorio (CodigoLab, Nombre) values ('1155024184', 'Turkeypeas');
insert into Laboratorio (CodigoLab, Nombre) values ('9768978511', 'Canby''s Aster');
insert into Laboratorio (CodigoLab, Nombre) values ('2064816879', 'Oldpasture Bluegrass');
insert into Laboratorio (CodigoLab, Nombre) values ('5637290334', 'Lecania Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('9926678041', 'Pineland Valerian');
insert into Laboratorio (CodigoLab, Nombre) values ('4073287850', 'Yellowdot Saxifrage');
insert into Laboratorio (CodigoLab, Nombre) values ('0665403739', 'Greville''s Dicranella Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('5885285047', 'Herbst''s Bloodleaf');
insert into Laboratorio (CodigoLab, Nombre) values ('3085822186', 'Moss Pygmyweed');
insert into Laboratorio (CodigoLab, Nombre) values ('6591348107', 'Lotus Milkvetch');
insert into Laboratorio (CodigoLab, Nombre) values ('6906528394', 'Rim Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('5864464279', 'Pterocarpus');
insert into Laboratorio (CodigoLab, Nombre) values ('2301391337', 'Kidneyshape Buckwheat');
insert into Laboratorio (CodigoLab, Nombre) values ('2774420385', 'Dusty Beardtongue');
insert into Laboratorio (CodigoLab, Nombre) values ('6930081620', 'Snow Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('3310867854', 'Whitehead Mule-ears');
insert into Laboratorio (CodigoLab, Nombre) values ('6251481145', 'Revolute Hypnum Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('9855190831', 'Joor Oak');
insert into Laboratorio (CodigoLab, Nombre) values ('7845722308', 'Gray Everlasting');
insert into Laboratorio (CodigoLab, Nombre) values ('0007966830', 'Porpidia Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('0343237407', 'Spanish Thyme');
insert into Laboratorio (CodigoLab, Nombre) values ('6106744408', 'Tropical Bristlegrass');
insert into Laboratorio (CodigoLab, Nombre) values ('9709415972', 'Cartilage Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('1237436168', 'Spring Club Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('5760151304', 'Tailed Strapfern');
insert into Laboratorio (CodigoLab, Nombre) values ('5102037455', 'New Mexico Spanish Bayonet');
insert into Laboratorio (CodigoLab, Nombre) values ('7872069024', 'Dwarf Crested Iris');
insert into Laboratorio (CodigoLab, Nombre) values ('9431251671', 'Common Beargrass');
insert into Laboratorio (CodigoLab, Nombre) values ('2398128326', 'Mossgrass');
insert into Laboratorio (CodigoLab, Nombre) values ('9879532236', 'Hairy False Goldenaster');
insert into Laboratorio (CodigoLab, Nombre) values ('2186045184', 'Eyebright');
insert into Laboratorio (CodigoLab, Nombre) values ('8115032328', 'Amerorchis');
insert into Laboratorio (CodigoLab, Nombre) values ('7719400046', 'Grape Hyacinth');
insert into Laboratorio (CodigoLab, Nombre) values ('3442928761', 'Phacopsis Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('8618235474', 'Parish''s Popcornflower');
insert into Laboratorio (CodigoLab, Nombre) values ('9293179490', 'New Mexico Fameflower');
insert into Laboratorio (CodigoLab, Nombre) values ('2961441927', 'Tennessee Bladderfern');
insert into Laboratorio (CodigoLab, Nombre) values ('1753153360', 'Common Coleus');
insert into Laboratorio (CodigoLab, Nombre) values ('7373247563', 'Trailing St. Johnswort');
insert into Laboratorio (CodigoLab, Nombre) values ('0649044762', 'Rinodina Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('6471980469', 'Guajillo');
insert into Laboratorio (CodigoLab, Nombre) values ('0900511524', 'Bigfoot Waterclover');
insert into Laboratorio (CodigoLab, Nombre) values ('4400633535', 'Potato Dwarfdandelion');
insert into Laboratorio (CodigoLab, Nombre) values ('1381569749', 'Trematodon Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('4126835989', 'Tasmanian Bluegum');
insert into Laboratorio (CodigoLab, Nombre) values ('3681301549', 'Symblepharis Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('7063876996', 'Hairy Dozedaisy');
insert into Laboratorio (CodigoLab, Nombre) values ('1747147508', 'Blackish Oxytrope');
insert into Laboratorio (CodigoLab, Nombre) values ('7902024910', 'Grand Paspalum');
insert into Laboratorio (CodigoLab, Nombre) values ('7086487376', 'Annual Ragweed');
insert into Laboratorio (CodigoLab, Nombre) values ('0549095462', 'Trianthema');
insert into Laboratorio (CodigoLab, Nombre) values ('9693903765', 'Grants Pass Lupine');
insert into Laboratorio (CodigoLab, Nombre) values ('4903295370', 'Asthmaweed');
insert into Laboratorio (CodigoLab, Nombre) values ('8496114856', 'San Francisco Woodland-star');
insert into Laboratorio (CodigoLab, Nombre) values ('0553630865', 'Texas Varilla');
insert into Laboratorio (CodigoLab, Nombre) values ('9863599972', 'Oval-leaf Spikemoss');
insert into Laboratorio (CodigoLab, Nombre) values ('9105340950', 'Rincon Mountain Indian Paintbrush');
insert into Laboratorio (CodigoLab, Nombre) values ('5821024951', 'King''s Serpentweed');
insert into Laboratorio (CodigoLab, Nombre) values ('9953130221', 'Red Ribbons');
insert into Laboratorio (CodigoLab, Nombre) values ('6539040946', 'Boreal Carnation');
insert into Laboratorio (CodigoLab, Nombre) values ('8787511061', 'Oca');
insert into Laboratorio (CodigoLab, Nombre) values ('3438347733', 'Navajo Bridge Pricklypear');
insert into Laboratorio (CodigoLab, Nombre) values ('6687595059', 'Violet Lespedeza');
insert into Laboratorio (CodigoLab, Nombre) values ('7201116258', 'Oriental Popcornflower');
insert into Laboratorio (CodigoLab, Nombre) values ('3751467181', 'Ouricury Palm');
insert into Laboratorio (CodigoLab, Nombre) values ('8695921328', 'Disc Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('8827778292', 'Lady''s Tresses');
insert into Laboratorio (CodigoLab, Nombre) values ('8886407076', 'Spreading Buckwheat');
insert into Laboratorio (CodigoLab, Nombre) values ('3944051386', 'Velvet Tamarind');
insert into Laboratorio (CodigoLab, Nombre) values ('9994612409', 'Boreal Sagebrush');
insert into Laboratorio (CodigoLab, Nombre) values ('2137290324', 'Fleabane');
insert into Laboratorio (CodigoLab, Nombre) values ('1872050387', 'Dwarf Alpine Indian Paintbrush');
insert into Laboratorio (CodigoLab, Nombre) values ('6790747273', 'Maui Clermontia');
insert into Laboratorio (CodigoLab, Nombre) values ('5246101614', 'Carrot');
insert into Laboratorio (CodigoLab, Nombre) values ('8837490445', 'Cumin');
insert into Laboratorio (CodigoLab, Nombre) values ('4985519545', 'Kleinhovia');
insert into Laboratorio (CodigoLab, Nombre) values ('2978427779', 'Protoparmelia Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('5506416024', 'Coastal Bluff Bentgrass');
insert into Laboratorio (CodigoLab, Nombre) values ('4453018673', 'Rockcress');
insert into Laboratorio (CodigoLab, Nombre) values ('3726580573', 'Austroamerican Skin Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('0800700422', 'Broadleaf Wild Leek');
insert into Laboratorio (CodigoLab, Nombre) values ('2208056256', 'Callingcard Vine');
insert into Laboratorio (CodigoLab, Nombre) values ('6839721426', 'Broom Teatree');
insert into Laboratorio (CodigoLab, Nombre) values ('7933298540', 'Panama Tree');
insert into Laboratorio (CodigoLab, Nombre) values ('5032588598', 'Florida Trypelthelium Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('2654963195', 'Yellowseed False Pimpernel');
insert into Laboratorio (CodigoLab, Nombre) values ('8009538094', 'Pale Evening Primrose');
insert into Laboratorio (CodigoLab, Nombre) values ('5719753125', 'Brothera Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('9280568949', 'Script Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('3649645769', 'Arctodupontia');
insert into Laboratorio (CodigoLab, Nombre) values ('2565508492', 'Menzies'' Goldenbush');
insert into Laboratorio (CodigoLab, Nombre) values ('5957928631', 'Big Saltbush');
insert into Laboratorio (CodigoLab, Nombre) values ('7330465240', 'Blue Mountain Buckwheat');
insert into Laboratorio (CodigoLab, Nombre) values ('0491971311', 'Lecidella Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('1418379360', 'Davidson''s Saltbush');
insert into Laboratorio (CodigoLab, Nombre) values ('6487995347', 'Fendler''s Waterleaf');
insert into Laboratorio (CodigoLab, Nombre) values ('2229480162', 'Plume Albizia');
insert into Laboratorio (CodigoLab, Nombre) values ('9029120681', 'Chamisso Arnica');
insert into Laboratorio (CodigoLab, Nombre) values ('7257086737', 'Berlandier''s Yellow Flax');
insert into Laboratorio (CodigoLab, Nombre) values ('2959877993', 'Cryptantha');
insert into Laboratorio (CodigoLab, Nombre) values ('5734261564', 'White Leadtree');
insert into Laboratorio (CodigoLab, Nombre) values ('9600235805', 'Dwarf Hawthorn');
insert into Laboratorio (CodigoLab, Nombre) values ('0257488391', 'Shrubby Bedstraw');
insert into Laboratorio (CodigoLab, Nombre) values ('0826791069', 'Mogollon Hawkweed');
insert into Laboratorio (CodigoLab, Nombre) values ('6320264209', 'Great Plains Lady''s Tresses');
insert into Laboratorio (CodigoLab, Nombre) values ('5052155018', 'Sky Plant');
insert into Laboratorio (CodigoLab, Nombre) values ('0813243777', 'Birdcage Evening Primrose');
insert into Laboratorio (CodigoLab, Nombre) values ('5640727314', 'Wai''oli Valley Pritchardia');
insert into Laboratorio (CodigoLab, Nombre) values ('7650644049', 'Heller''s Draba');
insert into Laboratorio (CodigoLab, Nombre) values ('6770300354', 'Pitted Stripeseed');
insert into Laboratorio (CodigoLab, Nombre) values ('9369406123', 'Threeparted Miterwort');
insert into Laboratorio (CodigoLab, Nombre) values ('5053819114', 'Sticky Cinquefoil');
insert into Laboratorio (CodigoLab, Nombre) values ('1546520783', 'Appalachian Quillwort');
insert into Laboratorio (CodigoLab, Nombre) values ('2352634792', 'Rim Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('9767843019', 'Sphagnum');
insert into Laboratorio (CodigoLab, Nombre) values ('2804840026', 'Woodfern');
insert into Laboratorio (CodigoLab, Nombre) values ('3257785429', 'Desert Agave');
insert into Laboratorio (CodigoLab, Nombre) values ('9272623731', 'Physciella');
insert into Laboratorio (CodigoLab, Nombre) values ('3764820756', 'American Spikenard');
insert into Laboratorio (CodigoLab, Nombre) values ('6398162889', 'Hybrid Oak');
insert into Laboratorio (CodigoLab, Nombre) values ('8591041739', 'Common Linden');
insert into Laboratorio (CodigoLab, Nombre) values ('4231060266', 'Jand');
insert into Laboratorio (CodigoLab, Nombre) values ('3716498475', 'Spiny Sowthistle');
insert into Laboratorio (CodigoLab, Nombre) values ('5010816326', 'Phylliscum Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('6995510887', 'Bishop''s Milkvetch');
insert into Laboratorio (CodigoLab, Nombre) values ('4232068759', 'Rosary Babybonnets');
insert into Laboratorio (CodigoLab, Nombre) values ('2269172612', 'Japanese Mazus');
insert into Laboratorio (CodigoLab, Nombre) values ('2767262184', 'Hubricht''s Bluestar');
insert into Laboratorio (CodigoLab, Nombre) values ('8277348169', 'Bonneville Shootingstar');
insert into Laboratorio (CodigoLab, Nombre) values ('6399191548', 'Tracy''s Hawthorn');
insert into Laboratorio (CodigoLab, Nombre) values ('1609452895', 'European Smoketree');
insert into Laboratorio (CodigoLab, Nombre) values ('9414404392', 'Badlands Mule-ears');
insert into Laboratorio (CodigoLab, Nombre) values ('8097788411', 'Fivepetal Leaf-flower');
insert into Laboratorio (CodigoLab, Nombre) values ('7603935989', 'Hawthorn');
insert into Laboratorio (CodigoLab, Nombre) values ('5406340344', 'Alpineflames');
insert into Laboratorio (CodigoLab, Nombre) values ('3405977991', 'Narrowleaf Purple Everlasting');
insert into Laboratorio (CodigoLab, Nombre) values ('1159792704', 'Disc Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('5956488654', 'Coastal Plain Blue-eyed Grass');
insert into Laboratorio (CodigoLab, Nombre) values ('8615271925', 'Spidergrass');
insert into Laboratorio (CodigoLab, Nombre) values ('7468065322', 'Whitewhorl Lupine');
insert into Laboratorio (CodigoLab, Nombre) values ('8572296115', 'Broadleaved Pepperweed');
insert into Laboratorio (CodigoLab, Nombre) values ('0355013223', 'Entireleaf Mountain-avens');
insert into Laboratorio (CodigoLab, Nombre) values ('6151152514', 'Tennessee Bladderfern');
insert into Laboratorio (CodigoLab, Nombre) values ('4562164654', 'Hybrid Oak');
insert into Laboratorio (CodigoLab, Nombre) values ('0706572831', 'Green Beebalm');
insert into Laboratorio (CodigoLab, Nombre) values ('6186671321', 'Sclerophyton Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('9205028835', 'Haya Blanca');
insert into Laboratorio (CodigoLab, Nombre) values ('2336380013', 'Yellowbeak Owl''s-clover');
insert into Laboratorio (CodigoLab, Nombre) values ('9228020679', 'Hutchins'' Ulota Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('2085943799', 'Oldfield Dewberry');
insert into Laboratorio (CodigoLab, Nombre) values ('2217218735', 'Steudner''s Clover');
insert into Laboratorio (CodigoLab, Nombre) values ('3557435865', 'King''s Dalea');
insert into Laboratorio (CodigoLab, Nombre) values ('4849755186', 'Spearleaf Brickellbush');
insert into Laboratorio (CodigoLab, Nombre) values ('0620643374', 'Inyo Blazingstar');
insert into Laboratorio (CodigoLab, Nombre) values ('3971586112', 'Cheesewood');
insert into Laboratorio (CodigoLab, Nombre) values ('0307984702', 'Spotted St. Johnswort');
insert into Laboratorio (CodigoLab, Nombre) values ('1747689920', 'Winged Rockcress');
insert into Laboratorio (CodigoLab, Nombre) values ('8871182723', 'Longleaf Primrose-willow');
insert into Laboratorio (CodigoLab, Nombre) values ('5275917023', 'Sierra Sedge');
insert into Laboratorio (CodigoLab, Nombre) values ('7078843401', 'Wart Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('5606349485', 'Japanese Thimbleweed');
insert into Laboratorio (CodigoLab, Nombre) values ('4208055898', 'Siltbush');
insert into Laboratorio (CodigoLab, Nombre) values ('2410869939', 'European Searocket');
insert into Laboratorio (CodigoLab, Nombre) values ('4874170676', 'Lacebark');
insert into Laboratorio (CodigoLab, Nombre) values ('5933426776', 'Hairy Bedstraw');
insert into Laboratorio (CodigoLab, Nombre) values ('9257192997', 'Squirrel''s Tail');
insert into Laboratorio (CodigoLab, Nombre) values ('3682197427', 'Mound Phlox');
insert into Laboratorio (CodigoLab, Nombre) values ('1303086476', 'Glaucous Beardtongue');
insert into Laboratorio (CodigoLab, Nombre) values ('0380511673', 'Farnoldia Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('8933240519', 'Iowa Rinodina Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('6337866886', 'Blue Ridge Shield Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('3192352744', 'Dill');
insert into Laboratorio (CodigoLab, Nombre) values ('3564593578', 'Florida Slash Pine');
insert into Laboratorio (CodigoLab, Nombre) values ('6733511460', 'Bigflower Clover');
insert into Laboratorio (CodigoLab, Nombre) values ('7582322835', 'Meadow Pennycress');
insert into Laboratorio (CodigoLab, Nombre) values ('9759858878', 'Alkali Pepperweed');
insert into Laboratorio (CodigoLab, Nombre) values ('1371825807', 'Bracted Jewelflower');
insert into Laboratorio (CodigoLab, Nombre) values ('4819159984', 'Southern Bush Monkeyflower');
insert into Laboratorio (CodigoLab, Nombre) values ('9633496128', 'Spotflower');
insert into Laboratorio (CodigoLab, Nombre) values ('8115813796', 'Sandpaper Plant');
insert into Laboratorio (CodigoLab, Nombre) values ('9544117202', 'Jamaican Forget-me-not');
insert into Laboratorio (CodigoLab, Nombre) values ('0318316692', 'Arrowhead Rattlebox');
insert into Laboratorio (CodigoLab, Nombre) values ('1826213791', 'Dwarf Rotala');
insert into Laboratorio (CodigoLab, Nombre) values ('2070500616', 'Tavares'' Matted Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('8627246092', 'Hybrid Violet');
insert into Laboratorio (CodigoLab, Nombre) values ('5715983762', 'Caltrop');
insert into Laboratorio (CodigoLab, Nombre) values ('4237170217', 'Crevice Flatsedge');
insert into Laboratorio (CodigoLab, Nombre) values ('1464161852', 'Hernando County Noddingcaps');
insert into Laboratorio (CodigoLab, Nombre) values ('1831826364', 'Oglethorpe Oak');
insert into Laboratorio (CodigoLab, Nombre) values ('4736140097', 'Black River Beardtongue');
insert into Laboratorio (CodigoLab, Nombre) values ('7467945345', 'Stickystem Penstemon');
insert into Laboratorio (CodigoLab, Nombre) values ('6617562232', 'Chinese White Olive');
insert into Laboratorio (CodigoLab, Nombre) values ('6013895414', 'Bahama Manjack');
insert into Laboratorio (CodigoLab, Nombre) values ('4039428137', 'Virginia Whitehair Leather Flower');
insert into Laboratorio (CodigoLab, Nombre) values ('1885790252', 'Scattered Paspalum');
insert into Laboratorio (CodigoLab, Nombre) values ('5452210431', 'Texas Pricklyleaf');
insert into Laboratorio (CodigoLab, Nombre) values ('6144084452', 'Myrinia Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('6981638622', 'Grand Junction Camissonia');
insert into Laboratorio (CodigoLab, Nombre) values ('9007549464', 'Thinleaf Alder');
insert into Laboratorio (CodigoLab, Nombre) values ('2342501692', 'Dian Mu Dan');
insert into Laboratorio (CodigoLab, Nombre) values ('0553815369', 'Crested Goosefoot');
insert into Laboratorio (CodigoLab, Nombre) values ('9453951048', 'Prairie Panicgrass');
insert into Laboratorio (CodigoLab, Nombre) values ('1795051213', 'Red Grama');
insert into Laboratorio (CodigoLab, Nombre) values ('0215889274', 'Twoflower Dwarfdandelion');
insert into Laboratorio (CodigoLab, Nombre) values ('0545306558', 'Shore Quillwort');
insert into Laboratorio (CodigoLab, Nombre) values ('7498087731', 'Goldwire');
insert into Laboratorio (CodigoLab, Nombre) values ('4997879932', 'Utah Violet');
insert into Laboratorio (CodigoLab, Nombre) values ('6131717737', 'Maui Tetramolopium');
insert into Laboratorio (CodigoLab, Nombre) values ('6578064737', 'Acacia');
insert into Laboratorio (CodigoLab, Nombre) values ('3128166536', 'Shagbark Manzanita');
insert into Laboratorio (CodigoLab, Nombre) values ('8094982977', 'Central America Grass');
insert into Laboratorio (CodigoLab, Nombre) values ('8551193511', 'Agrestia Lichen');
insert into Laboratorio (CodigoLab, Nombre) values ('1195368615', 'Sweetjuice');
insert into Laboratorio (CodigoLab, Nombre) values ('9899785490', 'Trematodon Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('8158816460', 'Lesser Hawkbit');
insert into Laboratorio (CodigoLab, Nombre) values ('5841181238', 'Sonoran Indigo');
insert into Laboratorio (CodigoLab, Nombre) values ('2366636881', 'Alpine Polytrichastrum Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('2102912744', 'Gymnostomum Moss');
insert into Laboratorio (CodigoLab, Nombre) values ('7663263065', 'Beach Naupaka');
insert into Laboratorio (CodigoLab, Nombre) values ('5510385022', 'Pinweed');
insert into Laboratorio (CodigoLab, Nombre) values ('0466553412', 'Mexican Croton');
insert into Laboratorio (CodigoLab, Nombre) values ('8773043168', 'Woodland Monolopia');
insert into Laboratorio (CodigoLab, Nombre) values ('7412570137', 'Purple Bushbean');
insert into Laboratorio (CodigoLab, Nombre) values ('9775335116', 'Galactia P. Br.');
insert into Laboratorio (CodigoLab, Nombre) values ('1964433339', 'Quercus ×substellata Trel.');
insert into Laboratorio (CodigoLab, Nombre) values ('7341294760', 'Phacelia pringlei A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('9508365633', 'Amyris P. Br.');
insert into Laboratorio (CodigoLab, Nombre) values ('3230348001', 'Melilotus indicus (L.) All.');
insert into Laboratorio (CodigoLab, Nombre) values ('1279070951', 'Casearia aculeata Jacq.');
insert into Laboratorio (CodigoLab, Nombre) values ('0537734473', 'Rhynchosia minima (L.) DC.');
insert into Laboratorio (CodigoLab, Nombre) values ('1829243314', 'Trapeliopsis wallrothii (Flörke ex Spreng.) Hertel & Gotth. Schneid.');
insert into Laboratorio (CodigoLab, Nombre) values ('2596072017', 'Thelenella weberi H. Mayrh.');
insert into Laboratorio (CodigoLab, Nombre) values ('6625178551', 'Quercus buckleyi Nixon & Dorr');
insert into Laboratorio (CodigoLab, Nombre) values ('9919127108', 'Dryopteris subbipinnata W.H. Wagner & Hobdy');
insert into Laboratorio (CodigoLab, Nombre) values ('8848084974', 'Lythrum thymifolia L.');
insert into Laboratorio (CodigoLab, Nombre) values ('8229241767', 'Pinus parviflora Siebold & Zucc.');
insert into Laboratorio (CodigoLab, Nombre) values ('7906431707', 'Eucalyptus globulus Labill. ssp. maidenii (F. Muell.) J.B. Kirkpat.');
insert into Laboratorio (CodigoLab, Nombre) values ('6291657848', 'Usnea occidentalis Mot.');
insert into Laboratorio (CodigoLab, Nombre) values ('6896946288', 'Asarum wagneri Lu & Mesler');
insert into Laboratorio (CodigoLab, Nombre) values ('8281344113', 'Ludwigia L.');
insert into Laboratorio (CodigoLab, Nombre) values ('1685717918', 'Mimusops elengi L.');
insert into Laboratorio (CodigoLab, Nombre) values ('1777345715', 'Gentiana decora Pollard');
insert into Laboratorio (CodigoLab, Nombre) values ('0185681883', 'Lepidium lasiocarpum Nutt. var. lasiocarpum');
insert into Laboratorio (CodigoLab, Nombre) values ('8776209989', 'Tetraneuris ivesiana Greene');
insert into Laboratorio (CodigoLab, Nombre) values ('5418716093', 'Malaxis spicata Sw.');
insert into Laboratorio (CodigoLab, Nombre) values ('6155592586', 'Lycoris squamigera Maxim.');
insert into Laboratorio (CodigoLab, Nombre) values ('9738752914', 'Nasturtium gambelii (S. Watson) O.E. Schulz');
insert into Laboratorio (CodigoLab, Nombre) values ('6837069659', 'Microsteris Greene');
insert into Laboratorio (CodigoLab, Nombre) values ('5940346588', 'Trientalis borealis Raf.');
insert into Laboratorio (CodigoLab, Nombre) values ('1430745703', 'Eleutheranthera ruderalis (Sw.) Sch. Bip.');
insert into Laboratorio (CodigoLab, Nombre) values ('9353902452', 'Calamagrostis cainii Hitchc.');
insert into Laboratorio (CodigoLab, Nombre) values ('3764071974', 'Crotalaria incana L.');
insert into Laboratorio (CodigoLab, Nombre) values ('1768044937', 'Lesquerella valida Greene');
insert into Laboratorio (CodigoLab, Nombre) values ('3231939178', 'Lespedeza texana Britton');
insert into Laboratorio (CodigoLab, Nombre) values ('0529851091', 'Argyranthemum foeniculum (Willd.) Sch. Bip.');
insert into Laboratorio (CodigoLab, Nombre) values ('3956073681', 'Melaleuca diosmifolia Andrews');
insert into Laboratorio (CodigoLab, Nombre) values ('7067570654', 'Sedum laxum (Britton) A. Berger ssp. heckneri (M. Peck) R.T. Clausen');
insert into Laboratorio (CodigoLab, Nombre) values ('0782699154', 'Lepidium flavum Torr. var. flavum');
insert into Laboratorio (CodigoLab, Nombre) values ('1313377244', 'Anemone virginiana L.');
insert into Laboratorio (CodigoLab, Nombre) values ('6197578301', 'Cyphelium brunneum W.A. Weber');
insert into Laboratorio (CodigoLab, Nombre) values ('0420216650', 'Brickellia brachyphylla (A. Gray) A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('3696014095', 'Lesquerella gordonii (A. Gray) S. Watson var. densifolia Rollins');
insert into Laboratorio (CodigoLab, Nombre) values ('4607698679', 'Dalea jamesii (Torr.) Torr. & A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('7528800775', 'Heterotheca sessiliflora (Nutt.) Shinners');
insert into Laboratorio (CodigoLab, Nombre) values ('7591108875', 'Calochortus longebarbatus S. Watson');
insert into Laboratorio (CodigoLab, Nombre) values ('8692348414', 'Potentilla bimundorum Soják');
insert into Laboratorio (CodigoLab, Nombre) values ('1576671208', 'Rubus laudatus A. Berger');
insert into Laboratorio (CodigoLab, Nombre) values ('0486658309', 'Lespedeza cyrtobotrya Miq.');
insert into Laboratorio (CodigoLab, Nombre) values ('1147041326', 'Penstemon moriahensis N.H. Holmgren');
insert into Laboratorio (CodigoLab, Nombre) values ('3094654630', 'Liatris punctata Hook. var. mexicana Gaiser');
insert into Laboratorio (CodigoLab, Nombre) values ('2795224682', 'Arabis suffrutescens S. Watson var. suffrutescens');
insert into Laboratorio (CodigoLab, Nombre) values ('8830318728', 'Phacelia lyonii (A. Gray) Rydb.');
insert into Laboratorio (CodigoLab, Nombre) values ('3381245988', 'Ochrolechia laevigata (Rasanen) Verseghy ex Brodo');
insert into Laboratorio (CodigoLab, Nombre) values ('7285240893', 'Solanum bulbocastanum Dunal');
insert into Laboratorio (CodigoLab, Nombre) values ('2632489601', 'Arceuthobium blumeri A. Nelson');
insert into Laboratorio (CodigoLab, Nombre) values ('3633094806', 'Xyris ambigua Bey. ex Kunth');
insert into Laboratorio (CodigoLab, Nombre) values ('0723364141', 'Pinus massoniana Lamb.');
insert into Laboratorio (CodigoLab, Nombre) values ('3880177058', 'Artemisia ludoviciana Nutt. ssp. ludoviciana');
insert into Laboratorio (CodigoLab, Nombre) values ('5950477537', 'Ceanothus martinii M.E. Jones');
insert into Laboratorio (CodigoLab, Nombre) values ('5256459295', 'Eriodictyon parryi (A. Gray) Greene');
insert into Laboratorio (CodigoLab, Nombre) values ('9046449882', 'Pickeringia montana Nutt. ex Torr. & A. Gray var. montana');
insert into Laboratorio (CodigoLab, Nombre) values ('5802860332', 'Pimenta racemosa (Mill.) J.W. Moore var. racemosa');
insert into Laboratorio (CodigoLab, Nombre) values ('7531746670', 'Chamaesaracha sordida (Dunal) A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('7390639121', 'Cakile geniculata (B.L. Rob.) Millsp.');
insert into Laboratorio (CodigoLab, Nombre) values ('2638130087', 'Lupinus argenteus Pursh ssp. argenteus var. laxiflorus (Douglas ex Lindl.) Dorn');
insert into Laboratorio (CodigoLab, Nombre) values ('0195967631', 'Hexastylis rhombiformis Gaddy');
insert into Laboratorio (CodigoLab, Nombre) values ('9004564942', 'Cistanthe parryi (A. Gray) Hershkovitz');
insert into Laboratorio (CodigoLab, Nombre) values ('9440258748', 'Datura stramonium L.');
insert into Laboratorio (CodigoLab, Nombre) values ('1861522363', 'Viguiera laciniata A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('2065720107', 'Petalonyx nitidus S. Watson');
insert into Laboratorio (CodigoLab, Nombre) values ('2412067899', 'Lonicera subspicata Hook. & Arn. var. denudata Rehder');
insert into Laboratorio (CodigoLab, Nombre) values ('3157020064', 'Ageratina herbacea (A. Gray) R.M. King & H. Rob.');
insert into Laboratorio (CodigoLab, Nombre) values ('2571983210', 'Schoenoplectiella mucronata (L.) J. Jung & H.K. Choi');
insert into Laboratorio (CodigoLab, Nombre) values ('0524062986', 'Bidens sandvicensis Less.');
insert into Laboratorio (CodigoLab, Nombre) values ('2405782723', 'Lecidea tessellata Flörke');
insert into Laboratorio (CodigoLab, Nombre) values ('3559624568', 'Sempervivum L.');
insert into Laboratorio (CodigoLab, Nombre) values ('4540188003', 'Dichaetophora A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('9807787637', 'Silene perlmanii W.L. Wagner, D.R. Herbst & Sohmer');
insert into Laboratorio (CodigoLab, Nombre) values ('7738939672', 'Securigera cretica (L.) Lassen');
insert into Laboratorio (CodigoLab, Nombre) values ('7194740052', 'Panax pseudoginseng Wall. ssp. japonicus (C.A. Mey.) H. Hara');
insert into Laboratorio (CodigoLab, Nombre) values ('4111041108', 'Sisyrinchium atlanticum E.P. Bicknell');
insert into Laboratorio (CodigoLab, Nombre) values ('1251310338', 'Melica decumbens Thunb.');
insert into Laboratorio (CodigoLab, Nombre) values ('2706438657', 'Balsamorhiza hookeri (Hook.) Nutt. var. hookeri');
insert into Laboratorio (CodigoLab, Nombre) values ('2616513226', 'Thelopsis inordinata Nyl.');
insert into Laboratorio (CodigoLab, Nombre) values ('6424374639', 'Tillandsia bulbosa Hook.');
insert into Laboratorio (CodigoLab, Nombre) values ('6735812123', 'Verrucaria degelii R. Sant.');
insert into Laboratorio (CodigoLab, Nombre) values ('6693796796', 'Coscinodon Spreng.');
insert into Laboratorio (CodigoLab, Nombre) values ('1669918343', 'Clarkia biloba (Durand) A. Nelson & J.F. Macbr. ssp. biloba');
insert into Laboratorio (CodigoLab, Nombre) values ('8447796531', 'Cordia rickseckeri Millsp.');
insert into Laboratorio (CodigoLab, Nombre) values ('2788944705', 'Stenandrium tuberosum (L.) Urb.');
insert into Laboratorio (CodigoLab, Nombre) values ('8001245772', 'Cymophora B.L. Rob.');
insert into Laboratorio (CodigoLab, Nombre) values ('4926298880', 'Quercus cedrosensis C.H. Mull.');
insert into Laboratorio (CodigoLab, Nombre) values ('7352044205', 'Astragalus robbinsii (Oakes) A. Gray var. occidentalis S. Watson');
insert into Laboratorio (CodigoLab, Nombre) values ('9780934928', 'Astragalus humistratus A. Gray var. hosackiae (Greene) M.E. Jones');
insert into Laboratorio (CodigoLab, Nombre) values ('4492631909', 'Penstemon papillatus J.T. Howell');
insert into Laboratorio (CodigoLab, Nombre) values ('5469225283', 'Ichnanthus tenuis (J. Presl) Hitchc. & Chase');
insert into Laboratorio (CodigoLab, Nombre) values ('5244221779', 'Eugenia earhartii Acev.-Rodr.');
insert into Laboratorio (CodigoLab, Nombre) values ('6787993374', 'Parmelia fraudans (Nyl.) Nyl.');
insert into Laboratorio (CodigoLab, Nombre) values ('5809963714', 'Stylisma patens (Desr.) Myint');
insert into Laboratorio (CodigoLab, Nombre) values ('9495091160', 'Urtica dioica L.');
insert into Laboratorio (CodigoLab, Nombre) values ('4078261256', 'Desmanthus acuminatus Benth.');
insert into Laboratorio (CodigoLab, Nombre) values ('8469112414', 'Physostegia purpurea (Walter) S.F. Blake');
insert into Laboratorio (CodigoLab, Nombre) values ('9590671292', 'Hopea Roxb.');
insert into Laboratorio (CodigoLab, Nombre) values ('6001492123', 'Banisteriopsis lucida (Rich.) Small');
insert into Laboratorio (CodigoLab, Nombre) values ('5652166630', 'Tectaria Cav.');
insert into Laboratorio (CodigoLab, Nombre) values ('1844517292', 'Streptanthella longirostris (S. Watson) Rydb.');
insert into Laboratorio (CodigoLab, Nombre) values ('2178675603', 'Agave sisalana Perrine');
insert into Laboratorio (CodigoLab, Nombre) values ('3610712104', 'Purshia stansburiana (Torr.) Henrickson');
insert into Laboratorio (CodigoLab, Nombre) values ('7113907806', 'Mycelis Cass.');
insert into Laboratorio (CodigoLab, Nombre) values ('8333963692', 'Corispermum hookeri Mosyakin var. hookeri');
insert into Laboratorio (CodigoLab, Nombre) values ('6482823777', 'Letrouitia domingensis (Pers.) Hafeller & Bellem.');
insert into Laboratorio (CodigoLab, Nombre) values ('4487165458', 'Porotrichum vancouveriense (Kindb.) H.A. Crum');
insert into Laboratorio (CodigoLab, Nombre) values ('2172064637', 'Viburnum prunifolium L.');
insert into Laboratorio (CodigoLab, Nombre) values ('8422722305', 'Machaeranthera pinnatifida (Hook.) Shinners');
insert into Laboratorio (CodigoLab, Nombre) values ('2426136790', 'Veratrum californicum Durand var. californicum');
insert into Laboratorio (CodigoLab, Nombre) values ('2429370883', 'Cestrum L.');
insert into Laboratorio (CodigoLab, Nombre) values ('7231755887', 'Hyssopus officinalis L.');
insert into Laboratorio (CodigoLab, Nombre) values ('8125918272', 'Ficus L.');
insert into Laboratorio (CodigoLab, Nombre) values ('2957995107', 'Menodora spinescens A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('7266914981', 'Heliotropium polyphyllum Lehm.');
insert into Laboratorio (CodigoLab, Nombre) values ('0999854917', 'Hesperocyparis lusitanica (Mill.) Bartel');
insert into Laboratorio (CodigoLab, Nombre) values ('5329979927', 'Cyanea comata Hillebr.');
insert into Laboratorio (CodigoLab, Nombre) values ('7747183909', 'Tragopogon mirus Ownbey');
insert into Laboratorio (CodigoLab, Nombre) values ('2860231234', 'Flaveria brownii A. Powell');
insert into Laboratorio (CodigoLab, Nombre) values ('9832669561', 'Pterygoneurum kozlovii Laz.');
insert into Laboratorio (CodigoLab, Nombre) values ('5158415439', 'Penstemon cyananthus Hook. var. cyananthus');
insert into Laboratorio (CodigoLab, Nombre) values ('4835161920', 'Asplenium platyneuron (L.) Britton, Sterns & Poggenb. var. bacculum-rubrum (Featherm.) Fernald');
insert into Laboratorio (CodigoLab, Nombre) values ('9060187555', 'Sida tragiifolia A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('2724642996', 'Rosa spinosissima L.');
insert into Laboratorio (CodigoLab, Nombre) values ('8176278963', 'Polymeridium catapastum (Nyl.) R.C. Harris');
insert into Laboratorio (CodigoLab, Nombre) values ('0046594434', 'Sacciolepis indica (L.) Chase');
insert into Laboratorio (CodigoLab, Nombre) values ('6404288974', 'Rubus hawaiensis A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('4270177993', 'Draba brachystylis Rydb.');
insert into Laboratorio (CodigoLab, Nombre) values ('0903601044', 'Araujia Brot.');
insert into Laboratorio (CodigoLab, Nombre) values ('9359849065', 'Retama monosperma (L.) Boiss.');
insert into Laboratorio (CodigoLab, Nombre) values ('7267725856', 'Liatris gholsonii L.C. Anderson');
insert into Laboratorio (CodigoLab, Nombre) values ('3846273694', 'Trifolium variegatum Nutt.');
insert into Laboratorio (CodigoLab, Nombre) values ('3560365414', 'Solanum lycopersicum L.');
insert into Laboratorio (CodigoLab, Nombre) values ('3158097494', 'Ptelea trifoliata L. ssp. trifoliata');
insert into Laboratorio (CodigoLab, Nombre) values ('5171728895', 'Abies procera Rehder');
insert into Laboratorio (CodigoLab, Nombre) values ('0957617445', 'Aspicilia sublapponica (Zahlbr.) Oksner');
insert into Laboratorio (CodigoLab, Nombre) values ('4957248419', 'Dendriscocaulon Nyl.');
insert into Laboratorio (CodigoLab, Nombre) values ('6515486537', 'Najas wrightiana A. Braun');
insert into Laboratorio (CodigoLab, Nombre) values ('9178607590', 'Calystegia macrostegia (Greene) Brummitt');
insert into Laboratorio (CodigoLab, Nombre) values ('5393215908', 'Malus ioensis (Alph. Wood) Britton var. ioensis');
insert into Laboratorio (CodigoLab, Nombre) values ('9891401952', 'Grimmia donniana Sm.');
insert into Laboratorio (CodigoLab, Nombre) values ('4806217204', 'Phlox hoodii Richardson ssp. hoodii');
insert into Laboratorio (CodigoLab, Nombre) values ('2418638057', 'Polygala hookeri Torr. & A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('5546721650', 'Centaurea montana L.');
insert into Laboratorio (CodigoLab, Nombre) values ('8936028456', 'Gilia leptantha Parish ssp. pinetorum A.D. Grant & V.E. Grant');
insert into Laboratorio (CodigoLab, Nombre) values ('1510997105', 'Lobelia appendiculata A. DC. var. gattingeri (A. Gray) McVaugh');
insert into Laboratorio (CodigoLab, Nombre) values ('9457771982', 'Ribes indecorum Eastw.');
insert into Laboratorio (CodigoLab, Nombre) values ('3939083801', 'Lupinus benthamii A. Heller');
insert into Laboratorio (CodigoLab, Nombre) values ('7351305765', 'Adiantum tricholepis Fée');
insert into Laboratorio (CodigoLab, Nombre) values ('2337639983', 'Ranunculus occidentalis Nutt. var. brevistylis Greene');
insert into Laboratorio (CodigoLab, Nombre) values ('6608637497', 'Cyathea australis (R. Br.) Domin');
insert into Laboratorio (CodigoLab, Nombre) values ('2366796285', 'Salsola tragus L.');
insert into Laboratorio (CodigoLab, Nombre) values ('9802248568', 'Neoregelia L.B. Sm.');
insert into Laboratorio (CodigoLab, Nombre) values ('3813063682', 'Muilla S. Watson ex Benth.');
insert into Laboratorio (CodigoLab, Nombre) values ('6712686237', 'Cyanea truncata (Rock) Rock');
insert into Laboratorio (CodigoLab, Nombre) values ('5593233977', 'Phyllostegia hirsuta Benth.');
insert into Laboratorio (CodigoLab, Nombre) values ('9536010097', 'Helianthus maximiliani Schrad.');
insert into Laboratorio (CodigoLab, Nombre) values ('8901218380', 'Penstemon neomexicanus Wooton & Standl.');
insert into Laboratorio (CodigoLab, Nombre) values ('0227906527', 'Cerastium arvense L. ssp. velutinum (Raf.) Ugborogho var. velutinum (Raf.) Britton');
insert into Laboratorio (CodigoLab, Nombre) values ('2855470285', 'Stevia ovata Willd.');
insert into Laboratorio (CodigoLab, Nombre) values ('5718374813', 'Setaria macrostachya Kunth');
insert into Laboratorio (CodigoLab, Nombre) values ('9366086705', 'Polygonum glaucum Nutt.');
insert into Laboratorio (CodigoLab, Nombre) values ('6240068365', 'Malus prattii (Hemsl.) C.K. Schneid.');
insert into Laboratorio (CodigoLab, Nombre) values ('0152000496', 'Physciella Essl.');
insert into Laboratorio (CodigoLab, Nombre) values ('0023697024', 'Amblystegium varium (Hedw.) Lindb.');
insert into Laboratorio (CodigoLab, Nombre) values ('2657100147', 'Cardamine purpurea Cham. & Schltdl.');
insert into Laboratorio (CodigoLab, Nombre) values ('6229717557', 'Aristida purpurea Nutt. var. fendleriana (Steud.) Vasey');
insert into Laboratorio (CodigoLab, Nombre) values ('1030190283', 'Polygala L.');
insert into Laboratorio (CodigoLab, Nombre) values ('0151192855', 'Ipomoea violacea L.');
insert into Laboratorio (CodigoLab, Nombre) values ('8096639218', 'Edrudia constipans (Nyl.) W.P. Jordan');
insert into Laboratorio (CodigoLab, Nombre) values ('5042462775', 'Claytonia lanceolata Pall. ex Pursh var. lanceolata');
insert into Laboratorio (CodigoLab, Nombre) values ('9319960941', 'Perilla frutescens (L.) Britton var. crispa (Benth.) Deane');
insert into Laboratorio (CodigoLab, Nombre) values ('0430572611', 'Collomia tinctoria Kellogg');
insert into Laboratorio (CodigoLab, Nombre) values ('4553887738', 'Streptanthus hesperidis Jeps.');
insert into Laboratorio (CodigoLab, Nombre) values ('6933436810', 'Tortula bartramii Steere');
insert into Laboratorio (CodigoLab, Nombre) values ('2574821548', 'Viola flettii Piper');
insert into Laboratorio (CodigoLab, Nombre) values ('0125832729', 'Heuchera longiflora Rydb.');
insert into Laboratorio (CodigoLab, Nombre) values ('7873069958', 'Chaerophyllum tainturieri Hook. var. dasycarpum Hook. ex S. Watson');
insert into Laboratorio (CodigoLab, Nombre) values ('0125030274', 'Sphagnum andersonianum R.E. Andrus');
insert into Laboratorio (CodigoLab, Nombre) values ('9554990618', 'Acleisanthes wrightii (A. Gray) Benth. & Hook. f. ex Hemsl.');
insert into Laboratorio (CodigoLab, Nombre) values ('1623011949', 'Jacquinia keyensis Mez');
insert into Laboratorio (CodigoLab, Nombre) values ('1269258427', 'Polygonum chinense L.');
insert into Laboratorio (CodigoLab, Nombre) values ('4562006633', 'Adenostoma fasciculatum Hook. & Arn. var. obtusifolium S. Watson');
insert into Laboratorio (CodigoLab, Nombre) values ('9613190988', 'Eucalyptus morrisii R.T. Baker');
insert into Laboratorio (CodigoLab, Nombre) values ('8650620272', 'Stylisma patens (Desr.) Myint ssp. patens');
insert into Laboratorio (CodigoLab, Nombre) values ('0102194882', 'Astragalus pleianthus (Shinners) Isely');
insert into Laboratorio (CodigoLab, Nombre) values ('9395201096', 'Parthenium confertum A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('5392856500', 'Stigmidium psorae (Anzi) Hafellner');
insert into Laboratorio (CodigoLab, Nombre) values ('2418986721', 'Isachne carolinensis Ohwi');
insert into Laboratorio (CodigoLab, Nombre) values ('6335607921', 'Onosmodium bejariense DC. ex A. DC. var. bejariense');
insert into Laboratorio (CodigoLab, Nombre) values ('7584063241', 'Selaginella arenicola Underw. ssp. arenicola');
insert into Laboratorio (CodigoLab, Nombre) values ('4785763876', 'Dirinaria confusa D.D. Awasthi');
insert into Laboratorio (CodigoLab, Nombre) values ('3213579564', 'Polygala heterorhyncha (Barneby) T. Wendt');
insert into Laboratorio (CodigoLab, Nombre) values ('3927199761', 'Oenothera fruticosa L. ssp. fruticosa');
insert into Laboratorio (CodigoLab, Nombre) values ('9791714320', 'Usnea cornuta Körb.');
insert into Laboratorio (CodigoLab, Nombre) values ('4311982216', 'Agropyron cristatum (L.) Gaertn. ssp. cristatum');
insert into Laboratorio (CodigoLab, Nombre) values ('0711042136', 'Eritrichium nanum (Vill.) Schrad. ex Gaudin var. aretioides (Cham.) Herder');
insert into Laboratorio (CodigoLab, Nombre) values ('1355736919', 'Muhlenbergia fragilis Swallen');
insert into Laboratorio (CodigoLab, Nombre) values ('6264040134', 'Bergia L.');
insert into Laboratorio (CodigoLab, Nombre) values ('1427205973', 'Erigeron hyssopifolius Michx. var. hyssopifolius');
insert into Laboratorio (CodigoLab, Nombre) values ('3077618087', 'Myrcianthes Berg');
insert into Laboratorio (CodigoLab, Nombre) values ('4699403964', 'Synalissa symphorea (Ach.) Nyl.');
insert into Laboratorio (CodigoLab, Nombre) values ('8991146961', 'Cyanea arborea Hillebr.');
insert into Laboratorio (CodigoLab, Nombre) values ('2505445494', 'Quercus phellos L.');
insert into Laboratorio (CodigoLab, Nombre) values ('4648622189', 'Eriogonum hieraciifolium Benth.');
insert into Laboratorio (CodigoLab, Nombre) values ('4695736330', 'Arabis lignifera A. Nelson');
insert into Laboratorio (CodigoLab, Nombre) values ('5880126811', 'Tolumnia G.J. Braem');
insert into Laboratorio (CodigoLab, Nombre) values ('6868010303', 'Calamintha sylvatica Bromf.');
insert into Laboratorio (CodigoLab, Nombre) values ('6421925103', 'Physaria iveyana O''Kane, K.N. Sm. & K.A. Arp');
insert into Laboratorio (CodigoLab, Nombre) values ('1157737749', 'Ochrosia haleakalae H. St. John');
insert into Laboratorio (CodigoLab, Nombre) values ('1010279351', 'Isocoma Nutt.');
insert into Laboratorio (CodigoLab, Nombre) values ('2225728283', 'Prunus subcordata Benth. var. kelloggii Lemmon');
insert into Laboratorio (CodigoLab, Nombre) values ('3221595085', 'Carex communis L.H. Bailey var. communis');
insert into Laboratorio (CodigoLab, Nombre) values ('9064557314', 'Lomatium serpentinum (M.E. Jones) Mathias');
insert into Laboratorio (CodigoLab, Nombre) values ('8482188887', 'Polyblastia septentrionalis Lynge');
insert into Laboratorio (CodigoLab, Nombre) values ('2873918365', 'Smelowskia ovalis M.E. Jones');
insert into Laboratorio (CodigoLab, Nombre) values ('5734464961', 'Nasturtium R. Br.');
insert into Laboratorio (CodigoLab, Nombre) values ('9500093537', 'Mesadenus lucayanus (Britton) Schltr.');
insert into Laboratorio (CodigoLab, Nombre) values ('3649290499', 'Crataegus exilis Beadle');
insert into Laboratorio (CodigoLab, Nombre) values ('6094679156', 'Geranium pratense L.');
insert into Laboratorio (CodigoLab, Nombre) values ('0153967927', 'Lecanora subcarnea (Lilj.) Ach.');
insert into Laboratorio (CodigoLab, Nombre) values ('7779959430', 'Lobaria linita (Ach.) Rabenh.');
insert into Laboratorio (CodigoLab, Nombre) values ('5075554032', 'Briza L.');
insert into Laboratorio (CodigoLab, Nombre) values ('1421024705', 'Tolumnia prionochila (Kraenzlin) G.J. Braem');
insert into Laboratorio (CodigoLab, Nombre) values ('0008776296', 'Asclepias viridula Chapm.');
insert into Laboratorio (CodigoLab, Nombre) values ('4919377959', 'Eustachys petraea (Sw.) Desv.');
insert into Laboratorio (CodigoLab, Nombre) values ('7332290359', 'Cornus ×arnoldiana Rehder');
insert into Laboratorio (CodigoLab, Nombre) values ('1323921648', 'Stachytarpheta strigosa Vahl');
insert into Laboratorio (CodigoLab, Nombre) values ('5816230344', 'Orthocarpus cuspidatus Greene ssp. copelandii (Eastw.) T.I. Chuang & Heckard');
insert into Laboratorio (CodigoLab, Nombre) values ('0693063386', 'Thaspium Nutt.');
insert into Laboratorio (CodigoLab, Nombre) values ('0937350141', 'Pyrrhopappus DC.');
insert into Laboratorio (CodigoLab, Nombre) values ('5249003427', 'Galium serpenticum Dempster ssp. wenatchicum Dempster & Ehrend.');
insert into Laboratorio (CodigoLab, Nombre) values ('9462248400', 'Bromus berteroanus Colla');
insert into Laboratorio (CodigoLab, Nombre) values ('3142462368', 'Thelopsis melathelia Nyl.');
insert into Laboratorio (CodigoLab, Nombre) values ('1797316591', 'Vaccinium ×nubigenum Fernald (pro sp.)');
insert into Laboratorio (CodigoLab, Nombre) values ('6957877256', 'Eriogonum atrorubens Engelm.');
insert into Laboratorio (CodigoLab, Nombre) values ('6230401517', 'Brunfelsia portoricensis Krug & Urb.');
insert into Laboratorio (CodigoLab, Nombre) values ('1915075335', 'Phacelia vallis-mortae J. Voss var. heliophila (J.F. Macbr.) J. Voss');
insert into Laboratorio (CodigoLab, Nombre) values ('2822645507', 'Cynara scolymus L.');
insert into Laboratorio (CodigoLab, Nombre) values ('7416638844', 'Agyrium rufum (Pers.) Fr.');
insert into Laboratorio (CodigoLab, Nombre) values ('6060959237', 'Galium argense Dempster & Ehrend.');
insert into Laboratorio (CodigoLab, Nombre) values ('2176840240', 'Amsonia tharpii Woodson');
insert into Laboratorio (CodigoLab, Nombre) values ('8698223435', 'Spermacoce floridana Urb.');
insert into Laboratorio (CodigoLab, Nombre) values ('0073662526', 'Dirina paradoxa (Fée) Tehler');
insert into Laboratorio (CodigoLab, Nombre) values ('8101970444', 'Lythrum lineare L.');
insert into Laboratorio (CodigoLab, Nombre) values ('3469006563', 'Minuartia caroliniana (Walter) Mattf.');
insert into Laboratorio (CodigoLab, Nombre) values ('8412919432', 'Juncus ×lemieuxii B. Boivin');
insert into Laboratorio (CodigoLab, Nombre) values ('4276677181', 'Helenium arizonicum S.F. Blake');
insert into Laboratorio (CodigoLab, Nombre) values ('0012480924', 'Leymus racemosus (Lam.) Tzvelev');
insert into Laboratorio (CodigoLab, Nombre) values ('1368211453', 'Carex rossii Boott');
insert into Laboratorio (CodigoLab, Nombre) values ('0318359294', 'Agalinis nuttallii Shinners');
insert into Laboratorio (CodigoLab, Nombre) values ('8154080338', 'Hieracium alpinum L.');
insert into Laboratorio (CodigoLab, Nombre) values ('7034376212', 'Loeseliastrum depressum (M.E. Jones ex A. Gray) J.M. Porter');
insert into Laboratorio (CodigoLab, Nombre) values ('8067007187', 'Eriogonum divaricatum Hook.');
insert into Laboratorio (CodigoLab, Nombre) values ('7465866693', 'Trifolium andinum Nutt. var. podocephalum Barneby');
insert into Laboratorio (CodigoLab, Nombre) values ('4911797150', 'Crepis setosa Haller f.');
insert into Laboratorio (CodigoLab, Nombre) values ('2798815010', 'Convolvulus equitans Benth.');
insert into Laboratorio (CodigoLab, Nombre) values ('5069043854', 'Rumex patientia L.');
insert into Laboratorio (CodigoLab, Nombre) values ('7422634308', 'Stachys germanica L.');
insert into Laboratorio (CodigoLab, Nombre) values ('1654303763', 'Erigeron neomexicanus A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('2459776357', 'Rumex acetosa L. ssp. thyrsiflorus (Fingerh.) Hayek');
insert into Laboratorio (CodigoLab, Nombre) values ('7021617267', 'Nicolletia occidentalis A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('9230257613', 'Cuscuta epithymum (L.) L.');
insert into Laboratorio (CodigoLab, Nombre) values ('0634172999', 'Usnea dimorpha (Müll. Arg.) Mot.');
insert into Laboratorio (CodigoLab, Nombre) values ('6734646599', 'Atriplex glabriuscula Edmondston var. acadiensis (Taschereau) S.L. Welsh');
insert into Laboratorio (CodigoLab, Nombre) values ('9680796191', 'Pellaea wrightiana Hook.');
insert into Laboratorio (CodigoLab, Nombre) values ('8147998511', 'Hecistopteris pumila (Spreng.) J. Sm.');
insert into Laboratorio (CodigoLab, Nombre) values ('1340128756', 'Chamaesyce florida (Engelm.) Millsp.');
insert into Laboratorio (CodigoLab, Nombre) values ('7086227803', 'Platanthera ×shriveri P.M. Br., (pro. sp.)');
insert into Laboratorio (CodigoLab, Nombre) values ('3832707107', 'Verbascum virgatum Stokes');
insert into Laboratorio (CodigoLab, Nombre) values ('5357274665', 'Racomitrium macounii Kindb.');
insert into Laboratorio (CodigoLab, Nombre) values ('4716476588', 'Rhizocarpon expallescens Th. Fr.');
insert into Laboratorio (CodigoLab, Nombre) values ('3556947978', 'Lobelia rotundifolia Juss. ex A. DC.');
insert into Laboratorio (CodigoLab, Nombre) values ('7978010945', 'Physaria geyeri (Hook.) A. Gray var. purpurea Rollins');
insert into Laboratorio (CodigoLab, Nombre) values ('7689333729', 'Penstemon crandallii A. Nelson ssp. procumbens (Greene) D.D. Keck');
insert into Laboratorio (CodigoLab, Nombre) values ('2865527581', 'Lagophylla glandulosa A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('1251092128', 'Lepidium virginicum L. var. virginicum');
insert into Laboratorio (CodigoLab, Nombre) values ('7316093226', 'Asclepias lemmonii A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('0222122285', 'Celosia L.');
insert into Laboratorio (CodigoLab, Nombre) values ('6927808213', 'Allium acuminatum Hook.');
insert into Laboratorio (CodigoLab, Nombre) values ('6560139352', '×Elyhordeum stebbinsianum (Bowden) Bowden');
insert into Laboratorio (CodigoLab, Nombre) values ('3492102786', 'Tanacetum corymbosum (L.) Sch. Bip.');
insert into Laboratorio (CodigoLab, Nombre) values ('1130766225', 'Elymus alaskanus (Scribn. & Merr.) Á. Löve ssp. alaskanus');
insert into Laboratorio (CodigoLab, Nombre) values ('4523879044', 'Calliscirpus brachythrix C.N. Gilmour, J.R. Starr & Naczi');
insert into Laboratorio (CodigoLab, Nombre) values ('5079865075', 'Delphinium variegatum Torr. & A. Gray ssp. kinkiense (Munz) Warnock');
insert into Laboratorio (CodigoLab, Nombre) values ('1729909213', 'Letharia (Th. Fr.) Zahlbr.');
insert into Laboratorio (CodigoLab, Nombre) values ('5320225458', 'Chamaecrista pilosa (L.) Greene');
insert into Laboratorio (CodigoLab, Nombre) values ('9770773093', 'Mimulus nudatus Curran ex Greene');
insert into Laboratorio (CodigoLab, Nombre) values ('1637632762', 'Tofieldia coccinea Richardson');
insert into Laboratorio (CodigoLab, Nombre) values ('5455701908', 'Dodonaea viscosa (L.) Jacq. ssp. angustissima (DC.) J.G. West');
insert into Laboratorio (CodigoLab, Nombre) values ('4948985635', 'Valerianella texana Dyal');
insert into Laboratorio (CodigoLab, Nombre) values ('1838910018', 'Dieffenbachia seguine (Jacq.) Schott');
insert into Laboratorio (CodigoLab, Nombre) values ('6508420232', 'Castilleja applegatei Fernald ssp. applegatei');
insert into Laboratorio (CodigoLab, Nombre) values ('6892747922', 'Malacothrix saxatilis (Nutt.) Torr. & A. Gray var. commutata (Torr. & A. Gray) Ferris');
insert into Laboratorio (CodigoLab, Nombre) values ('9958653508', 'Aspicilia verrucigera Hue');
insert into Laboratorio (CodigoLab, Nombre) values ('4885141729', 'Usnea mirabilis Mot.');
insert into Laboratorio (CodigoLab, Nombre) values ('6358262785', 'Andreaea nivalis Hook.');
insert into Laboratorio (CodigoLab, Nombre) values ('6484825505', 'Thymophylla concinna (A. Gray) Strother');
insert into Laboratorio (CodigoLab, Nombre) values ('2920202944', 'Psychotria garberiana Christoph.');
insert into Laboratorio (CodigoLab, Nombre) values ('8031660883', 'Orogenia linearifolia S. Watson');
insert into Laboratorio (CodigoLab, Nombre) values ('3036814272', 'Odontonema Nees');
insert into Laboratorio (CodigoLab, Nombre) values ('4889283722', 'Cyperus lentiginosus Millsp. & Chase');
insert into Laboratorio (CodigoLab, Nombre) values ('6767832197', 'Perityle coronopifolia A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('3079591232', 'Liatris scariosa (L.) Willd.');
insert into Laboratorio (CodigoLab, Nombre) values ('1240398344', 'Solidago wrightii A. Gray var. wrightii');
insert into Laboratorio (CodigoLab, Nombre) values ('2053629959', 'Astragalus alpinus L. var. alpinus');
insert into Laboratorio (CodigoLab, Nombre) values ('0356462781', 'Carex ×haematolepis Drejer (pro sp.)');
insert into Laboratorio (CodigoLab, Nombre) values ('8191375001', 'Ipomopsis aggregata (Pursh) V.E. Grant ssp. weberi V.E. Grant & Wilken');
insert into Laboratorio (CodigoLab, Nombre) values ('2646418582', 'Hibiscadelphus hualalaiensis Rock');
insert into Laboratorio (CodigoLab, Nombre) values ('3272571345', 'Carex sartwellii Dewey');
insert into Laboratorio (CodigoLab, Nombre) values ('2397318881', 'Dicranum acutifolium (Lindb. & Arnell) C.E.O. Jensen ex Weinm.');
insert into Laboratorio (CodigoLab, Nombre) values ('1246419084', 'Scutellaria havanensis Jacq.');
insert into Laboratorio (CodigoLab, Nombre) values ('3028780062', 'Delphinium variegatum Torr. & A. Gray ssp. variegatum');
insert into Laboratorio (CodigoLab, Nombre) values ('1543248373', 'Crataegus pinnatifida Bunge');
insert into Laboratorio (CodigoLab, Nombre) values ('3854813880', 'Mentha pulegium L.');
insert into Laboratorio (CodigoLab, Nombre) values ('3603567528', 'Cladonia anitae W.L. Culb. & C.F. Culb.');
insert into Laboratorio (CodigoLab, Nombre) values ('3725328900', 'Leptarrhena pyrolifolia (D. Don) R. Br. ex Ser.');
insert into Laboratorio (CodigoLab, Nombre) values ('0607539127', 'Malachra radiata L.');
insert into Laboratorio (CodigoLab, Nombre) values ('0441623468', 'Solanum carolinense L. var. carolinense');
insert into Laboratorio (CodigoLab, Nombre) values ('9249661487', 'Alopecurus L.');
insert into Laboratorio (CodigoLab, Nombre) values ('0515209171', 'Nymphaea capensis Thunb. var. capensis Thunb. [excluded]');
insert into Laboratorio (CodigoLab, Nombre) values ('0613598288', 'Galactia parvifolia A. Rich.');
insert into Laboratorio (CodigoLab, Nombre) values ('3499761157', 'Erigeron supplex A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('2820319424', 'Sclerocactus whipplei (Engelm. & J.M. Bigelow) Britton & Rose');
insert into Laboratorio (CodigoLab, Nombre) values ('9145358605', 'Fraxinus caroliniana Mill.');
insert into Laboratorio (CodigoLab, Nombre) values ('9775215226', 'Galium triflorum Michx.');
insert into Laboratorio (CodigoLab, Nombre) values ('8764524663', 'Youngia Cass.');
insert into Laboratorio (CodigoLab, Nombre) values ('6322273051', 'Claytonia lanceolata Pall. ex Pursh var. lanceolata');
insert into Laboratorio (CodigoLab, Nombre) values ('5811479875', 'Silene verecunda S. Watson ssp. andersonii (Clokey) C.L. Hitchc. & Maguire');
insert into Laboratorio (CodigoLab, Nombre) values ('5633175751', 'Ipomopsis sancti-spiritus Wilken & Fletcher');
insert into Laboratorio (CodigoLab, Nombre) values ('8957710639', 'Vitis tiliifolia Humb. & Bonpl. ex Schult.');
insert into Laboratorio (CodigoLab, Nombre) values ('3441868358', 'Hybanthus concolor (T.F. Forst.) Spreng.');
insert into Laboratorio (CodigoLab, Nombre) values ('4307724097', 'Asplenium L.');
insert into Laboratorio (CodigoLab, Nombre) values ('7347376424', 'Lobelia grayana E. Wimm.');
insert into Laboratorio (CodigoLab, Nombre) values ('3286459445', 'Caloplaca holocarpa (Hoffm. ex Ach.) M. Wade');
insert into Laboratorio (CodigoLab, Nombre) values ('1481139436', 'Castilleja densiflora (Benth.) T.I. Chuang & Heckard ssp. gracilis (Benth.) T.I. Chuang & Heckard');
insert into Laboratorio (CodigoLab, Nombre) values ('5662761949', 'Oplonia microphylla (Lam.) Stearn');
insert into Laboratorio (CodigoLab, Nombre) values ('6578170871', 'Bruchia carolinae Austin');
insert into Laboratorio (CodigoLab, Nombre) values ('9722292862', 'Eriogonum incanum Torr. & A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('1747780596', 'Viola lobata Benth.');
insert into Laboratorio (CodigoLab, Nombre) values ('9123211326', 'Vitex agnus-castus L. var. agnus-castus');
insert into Laboratorio (CodigoLab, Nombre) values ('6910730178', 'Mitracarpus maxwelliae Britton & P. Wilson');
insert into Laboratorio (CodigoLab, Nombre) values ('7251488604', 'Melanelia subaurifera (Nyl.) Essl.');
insert into Laboratorio (CodigoLab, Nombre) values ('9751232198', 'Polygonatum Mill.');
insert into Laboratorio (CodigoLab, Nombre) values ('3792509954', 'Phlox stolonifera Sims');
insert into Laboratorio (CodigoLab, Nombre) values ('0701818085', 'Eriogonum grande Greene var. grande');
insert into Laboratorio (CodigoLab, Nombre) values ('7997065253', 'Zigadenus glaberrimus Michx.');
insert into Laboratorio (CodigoLab, Nombre) values ('8622542610', 'Astrolepis integerrima (Hook.) Benham & Windham');
insert into Laboratorio (CodigoLab, Nombre) values ('4598221372', 'Artemisia longifolia Nutt.');
insert into Laboratorio (CodigoLab, Nombre) values ('8976341627', 'Lecanora subintricata (Nyl.) Th. Fr.');
insert into Laboratorio (CodigoLab, Nombre) values ('4544672082', 'Polystichum lemmonii Underw.');
insert into Laboratorio (CodigoLab, Nombre) values ('5581200505', 'Orthocarpus purpureoalbus A. Gray ex S. Watson');
insert into Laboratorio (CodigoLab, Nombre) values ('0313654611', 'Malacothrix saxatilis (Nutt.) Torr. & A. Gray var. arachnoidea (McGregor) E.W. Williams');
insert into Laboratorio (CodigoLab, Nombre) values ('0004573242', 'Pinguicula macroceras Link');
insert into Laboratorio (CodigoLab, Nombre) values ('1648819109', 'Bouteloua aristidoides (Kunth) Griseb. var. arizonica M.E. Jones');
insert into Laboratorio (CodigoLab, Nombre) values ('2194308032', 'Hordeum intercedens Nevski');
insert into Laboratorio (CodigoLab, Nombre) values ('2368636137', 'Bidens vulgata Greene');
insert into Laboratorio (CodigoLab, Nombre) values ('2639536494', 'Solanum phureja Juz. & Buk.');
insert into Laboratorio (CodigoLab, Nombre) values ('7053646386', 'Nuttallanthus canadensis (L.) D.A. Sutton');
insert into Laboratorio (CodigoLab, Nombre) values ('9665510762', 'Heterodermia squamulosa (Degel.) W.L. Culb.');
insert into Laboratorio (CodigoLab, Nombre) values ('5214921268', 'Comarostaphylis diversifolia (Parry) Greene');
insert into Laboratorio (CodigoLab, Nombre) values ('5977326130', 'Euphrasia oakesii Wettst.');
insert into Laboratorio (CodigoLab, Nombre) values ('0370367448', 'Betula pubescens Ehrh. ssp. tortuosa (Ledeb.) Nyman');
insert into Laboratorio (CodigoLab, Nombre) values ('8825535015', 'Galactia dubia DC.');
insert into Laboratorio (CodigoLab, Nombre) values ('6684866752', 'Dodonaea viscosa (L.) Jacq. ssp. angustissima (DC.) J.G. West');
insert into Laboratorio (CodigoLab, Nombre) values ('0243874057', 'Pinus resinosa Aiton');
insert into Laboratorio (CodigoLab, Nombre) values ('7682677856', 'Kalinia H.L. Bell & Columbus');
insert into Laboratorio (CodigoLab, Nombre) values ('7087283766', 'Hyophila Brid.');
insert into Laboratorio (CodigoLab, Nombre) values ('9400639406', 'Erigeron lassenianus Greene var. lassenianus');
insert into Laboratorio (CodigoLab, Nombre) values ('3920856708', 'Stenogonum flexum (M.E. Jones) Reveal & J.T. Howell');
insert into Laboratorio (CodigoLab, Nombre) values ('1694412431', 'Kalimeris (Cass.) Cass.');
insert into Laboratorio (CodigoLab, Nombre) values ('1716878764', 'Evolvulus squamosus Britton');
insert into Laboratorio (CodigoLab, Nombre) values ('7078673085', 'Polygonella parksii Cory');
insert into Laboratorio (CodigoLab, Nombre) values ('3030714780', 'Arthonia tetramera (Stizenb.) Hasse');
insert into Laboratorio (CodigoLab, Nombre) values ('0275251403', 'Arctostaphylos stanfordiana Parry ssp. stanfordiana');
insert into Laboratorio (CodigoLab, Nombre) values ('5485189784', 'Warnstorfia fluitans (Hedw.) Loeske var. fluitans');
insert into Laboratorio (CodigoLab, Nombre) values ('4532135443', 'Honckenya peploides (L.) Ehrh. ssp. peploides (L.) Ehrh. [excluded]');
insert into Laboratorio (CodigoLab, Nombre) values ('2396250450', 'Faramea occidentalis (L.) A. Rich.');
insert into Laboratorio (CodigoLab, Nombre) values ('2019276992', 'Cleome lutea Hook.');
insert into Laboratorio (CodigoLab, Nombre) values ('1457378639', 'Viola rotundifolia Michx.');
insert into Laboratorio (CodigoLab, Nombre) values ('1715344979', 'Garrya wrightii Torr.');
insert into Laboratorio (CodigoLab, Nombre) values ('1222449609', 'Desmodium affine Schltdl.');
insert into Laboratorio (CodigoLab, Nombre) values ('3794974808', 'Salix ×bebbii Gandog.');
insert into Laboratorio (CodigoLab, Nombre) values ('6244026810', 'Hymenocallis henryae Traub');
insert into Laboratorio (CodigoLab, Nombre) values ('9693855140', 'Astripomoea A. Meeuse');
insert into Laboratorio (CodigoLab, Nombre) values ('5294777746', 'Astragalus convallarius Greene var. convallarius');
insert into Laboratorio (CodigoLab, Nombre) values ('1948389576', 'Stylisma pickeringii (Torr. ex M.A. Curtis) A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('2996168011', 'Juncus digitatus C.W. Witham & Zika');
insert into Laboratorio (CodigoLab, Nombre) values ('5919780371', 'Rinodina corticola Arnold');
insert into Laboratorio (CodigoLab, Nombre) values ('6054174215', 'Bidens sandvicensis Less. ssp. sandvicensis');
insert into Laboratorio (CodigoLab, Nombre) values ('0883796740', 'Trichomanes scandens L.');
insert into Laboratorio (CodigoLab, Nombre) values ('3767092042', 'Trichostomum sinaloense (E.B. Bartram) R.H. Zander');
insert into Laboratorio (CodigoLab, Nombre) values ('7719954084', 'Machaonia portoricensis Baill.');
insert into Laboratorio (CodigoLab, Nombre) values ('9180059007', 'Pyrrocoma racemosa (Nutt.) Torr. & A. Gray var. congesta (Greene) Mayes ex G. Brown & Keil');
insert into Laboratorio (CodigoLab, Nombre) values ('2786517311', 'Malacothrix squalida Greene');
insert into Laboratorio (CodigoLab, Nombre) values ('4390654438', 'Tortula stanfordensis Steere');
insert into Laboratorio (CodigoLab, Nombre) values ('6805929768', 'Castilleja rubida Piper');
insert into Laboratorio (CodigoLab, Nombre) values ('0636831132', 'Musa velutina H. Wendl. & Drude');
insert into Laboratorio (CodigoLab, Nombre) values ('7970551378', 'Sidalcea malviflora (DC.) A. Gray ex Benth. ssp. patula C.L. Hitchc.');
insert into Laboratorio (CodigoLab, Nombre) values ('6891760887', 'Digitalis ferruginea L.');
insert into Laboratorio (CodigoLab, Nombre) values ('5523545066', 'Neurolaena lobata (L.) Cass.');
insert into Laboratorio (CodigoLab, Nombre) values ('9699324090', 'Woodsia obtusa (Spreng.) Torr.');
insert into Laboratorio (CodigoLab, Nombre) values ('8479928581', 'Viburnum prunifolium L.');
insert into Laboratorio (CodigoLab, Nombre) values ('8414858716', 'Bouteloua aristidoides (Kunth) Griseb.');
insert into Laboratorio (CodigoLab, Nombre) values ('1768035229', 'Sporobolus indicus (L.) R. Br. var. pyramidalis (P. Beauv.) Veldkamp');
insert into Laboratorio (CodigoLab, Nombre) values ('7853991878', 'Carex paysonis Clokey');
insert into Laboratorio (CodigoLab, Nombre) values ('5115604329', 'Phaeographis exaltata (Mont. & v.d. Bosch) Müll. Arg.');
insert into Laboratorio (CodigoLab, Nombre) values ('7376673679', 'Hypericum fasciculatum Lam.');
insert into Laboratorio (CodigoLab, Nombre) values ('4319653653', 'Arabis falcifructa Rollins');
insert into Laboratorio (CodigoLab, Nombre) values ('5329456592', 'Draba sierrae Sharsm.');
insert into Laboratorio (CodigoLab, Nombre) values ('3404733061', 'Angelica grayi (J.M. Coult. & Rose) J.M. Coult. & Rose');
insert into Laboratorio (CodigoLab, Nombre) values ('0796965641', 'Ramalina polymorpha (Lilj.) Ach.');
insert into Laboratorio (CodigoLab, Nombre) values ('8214692105', 'Stenanthium occidentale A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('0644363363', 'Ceanothus maritimus Hoover');
insert into Laboratorio (CodigoLab, Nombre) values ('7907047056', 'Viburnum recognitum Fernald');
insert into Laboratorio (CodigoLab, Nombre) values ('2316496180', 'Psora himalayana (Bab.) Timdal');
insert into Laboratorio (CodigoLab, Nombre) values ('0218138644', 'Panicum venezuelae Hack.');
insert into Laboratorio (CodigoLab, Nombre) values ('3276254921', 'Pilea herniarioides (Sw.) Lindl.');
insert into Laboratorio (CodigoLab, Nombre) values ('8365153068', 'Carlina vulgaris L. ssp. longifolia Nyman');
insert into Laboratorio (CodigoLab, Nombre) values ('5771638552', 'Tetramolopium consanguineum (A. Gray) Hillebr. ssp. leptophyllum (Sherff) Lowrey var. kauense Lowrey');
insert into Laboratorio (CodigoLab, Nombre) values ('0345890833', 'Batis P. Br.');
insert into Laboratorio (CodigoLab, Nombre) values ('9364378881', 'Astragalus lentiginosus Douglas ex Hook. var. fremontii (A. Gray ex Torr.) S. Watson');
insert into Laboratorio (CodigoLab, Nombre) values ('9279422774', 'Trollius laxus Salisb.');
insert into Laboratorio (CodigoLab, Nombre) values ('1262859344', 'Anisomeridium carinthiacum (J. Steiner) R.C. Harris');
insert into Laboratorio (CodigoLab, Nombre) values ('9926511821', 'Equisetum variegatum Schleich. ex F. Weber & D. Mohr var. variegatum');
insert into Laboratorio (CodigoLab, Nombre) values ('4724530014', 'Elymus elymoides (Raf.) Swezey ssp. californicus (J.G. Sm.) Barkworth');
insert into Laboratorio (CodigoLab, Nombre) values ('6771519287', 'Sedum havardii Rose');
insert into Laboratorio (CodigoLab, Nombre) values ('5334560742', 'Cestrum L.');
insert into Laboratorio (CodigoLab, Nombre) values ('4641348715', 'Lupinus excubitus M.E. Jones var. excubitus');
insert into Laboratorio (CodigoLab, Nombre) values ('2672721602', 'Hedeoma costata A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('9962355974', 'Potentilla hookeriana Lehm. ssp. hookeriana');
insert into Laboratorio (CodigoLab, Nombre) values ('0512876290', 'Ivesia muirii A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('2933628422', 'Lupinus lapidicola A. Heller');
insert into Laboratorio (CodigoLab, Nombre) values ('2396117947', 'Calylophus Spach');
insert into Laboratorio (CodigoLab, Nombre) values ('9664939064', 'Arachis L.');
insert into Laboratorio (CodigoLab, Nombre) values ('4430834660', 'Gigantochloa apus (Schult. f.) Kurz ex Munro');
insert into Laboratorio (CodigoLab, Nombre) values ('7077940535', 'Dillenia L.');
insert into Laboratorio (CodigoLab, Nombre) values ('1719990611', 'Sphaeralcea coccinea (Nutt.) Rydb.');
insert into Laboratorio (CodigoLab, Nombre) values ('7239151328', 'Vicia villosa Roth ssp. villosa');
insert into Laboratorio (CodigoLab, Nombre) values ('6210945252', 'Cryptantha salmonensis (A. Nelson & J.F. Macbr.) Payson');
insert into Laboratorio (CodigoLab, Nombre) values ('2898888192', 'Packera schweinitziana (Nutt.) W.A. Weber & Á. Löve');
insert into Laboratorio (CodigoLab, Nombre) values ('3221242840', 'Monardella glauca Greene');
insert into Laboratorio (CodigoLab, Nombre) values ('7376918434', 'Ulota crispa (Hedw.) Brid.');
insert into Laboratorio (CodigoLab, Nombre) values ('9737853016', 'Draba asprella Greene');
insert into Laboratorio (CodigoLab, Nombre) values ('8502722069', 'Ludwigia alternifolia L.');
insert into Laboratorio (CodigoLab, Nombre) values ('1172086451', 'Ligusticum filicinum S. Watson');
insert into Laboratorio (CodigoLab, Nombre) values ('3722591317', 'Epilobium clavatum Trel.');
insert into Laboratorio (CodigoLab, Nombre) values ('6494455255', 'Heterotheca sessiliflora (Nutt.) Shinners ssp. bolanderi (A. Gray) Semple');
insert into Laboratorio (CodigoLab, Nombre) values ('9451448349', 'Eriochloa acuminata (J. Presl) Kunth var. acuminata');
insert into Laboratorio (CodigoLab, Nombre) values ('8053950787', 'Pyrenula cocoes Müll. Arg.');
insert into Laboratorio (CodigoLab, Nombre) values ('9952092636', 'Nama densum Lemmon var. parviflorum (Greenm.) C.L. Hitchc.');
insert into Laboratorio (CodigoLab, Nombre) values ('4383671934', 'Danthonia californica Bol.');
insert into Laboratorio (CodigoLab, Nombre) values ('5440468676', 'Collema flaccidum (Ach.) Ach.');
insert into Laboratorio (CodigoLab, Nombre) values ('9994781944', 'Ptelea trifoliata L. ssp. pallida (Greene) V. Bailey var. confinis (Greene) V. Bailey');
insert into Laboratorio (CodigoLab, Nombre) values ('4138129375', 'Plantago maritima L. var. californica (Fernald) Pilg.');
insert into Laboratorio (CodigoLab, Nombre) values ('4844606859', 'Ligusticum canadense (L.) Britton');
insert into Laboratorio (CodigoLab, Nombre) values ('6014608788', 'Ceanothus megacarpus Nutt. var. insularis (Eastw.) Munz');
insert into Laboratorio (CodigoLab, Nombre) values ('2527291899', 'Pinus quadrifolia Parl. ex Sudw.');
insert into Laboratorio (CodigoLab, Nombre) values ('9074946240', 'Brunnera macrophylla (J.F. Adams) I.M. Johnst.');
insert into Laboratorio (CodigoLab, Nombre) values ('3999697210', 'Crataegus ×puberis Sarg. (pro sp.)');
insert into Laboratorio (CodigoLab, Nombre) values ('6803317234', 'Vitis riparia Michx.');
insert into Laboratorio (CodigoLab, Nombre) values ('7620415157', 'Crocus tommasinianus Herb.');
insert into Laboratorio (CodigoLab, Nombre) values ('0812830261', 'Euonymus occidentalis Nutt. ex Torr. var. occidentalis');
insert into Laboratorio (CodigoLab, Nombre) values ('2668326702', 'Solanum jasminoides Paxton');
insert into Laboratorio (CodigoLab, Nombre) values ('5400972195', 'Bruchia carolinae Austin');
insert into Laboratorio (CodigoLab, Nombre) values ('3386300367', 'Echinochloa phyllopogon (Stapf) Koso-Pol.');
insert into Laboratorio (CodigoLab, Nombre) values ('4581055784', 'Cymopterus longipes S. Watson');
insert into Laboratorio (CodigoLab, Nombre) values ('2886889504', 'Pennisetum pedicellatum Trin.');
insert into Laboratorio (CodigoLab, Nombre) values ('0911140875', 'Cryptocoryne walkeri Schott');
insert into Laboratorio (CodigoLab, Nombre) values ('0238732657', 'Halimolobos perplexa (L.F. Hend.) Rollins var. lemhiensis C.L. Hitchc.');
insert into Laboratorio (CodigoLab, Nombre) values ('3269526067', 'Platanthera stricta Lindl.');
insert into Laboratorio (CodigoLab, Nombre) values ('9616976230', 'Senna lindheimeriana (Scheele) Irwin & Barneby');
insert into Laboratorio (CodigoLab, Nombre) values ('3822861421', 'Pisonia wagneriana Fosberg');
insert into Laboratorio (CodigoLab, Nombre) values ('2131503083', 'Pluchea Cass.');
insert into Laboratorio (CodigoLab, Nombre) values ('4636112792', 'Cyanea procera Hillebr.');
insert into Laboratorio (CodigoLab, Nombre) values ('6473239758', 'Cassia sturtii R. Br.');
insert into Laboratorio (CodigoLab, Nombre) values ('0516607952', 'Curcuma longa L.');
insert into Laboratorio (CodigoLab, Nombre) values ('2805942957', 'Lindsaea walkerae Hook.');
insert into Laboratorio (CodigoLab, Nombre) values ('4958484507', 'Cyperus hypochlorus Hillebr. var. brevior Kük.');
insert into Laboratorio (CodigoLab, Nombre) values ('5953028725', 'Vitis vulpina L.');
insert into Laboratorio (CodigoLab, Nombre) values ('1131939603', 'Penstemon neotericus D.D. Keck');
insert into Laboratorio (CodigoLab, Nombre) values ('4827961379', 'Rhynchospora rugosa (Vahl) Gale ssp. rugosa');
insert into Laboratorio (CodigoLab, Nombre) values ('1299147208', 'Morella faya (Aiton) Wilbur');
insert into Laboratorio (CodigoLab, Nombre) values ('2098646089', 'Mitracarpus Zucc.');
insert into Laboratorio (CodigoLab, Nombre) values ('1357214553', 'Orthotrichum affine Brid.');
insert into Laboratorio (CodigoLab, Nombre) values ('9160247266', 'Hulsea vestita A. Gray ssp. inyoensis (D.D. Keck) Wilken');
insert into Laboratorio (CodigoLab, Nombre) values ('4769763646', 'Hymenoxys ambigens (S.F. Blake) Bierner');
insert into Laboratorio (CodigoLab, Nombre) values ('1642412643', 'Lycopodium sabinifolium Willd.');
insert into Laboratorio (CodigoLab, Nombre) values ('6579809531', 'Orobanche aegyptiaca Pers.');
insert into Laboratorio (CodigoLab, Nombre) values ('1480712701', 'Bambusa arundinacea (Retz.) Willd.');
insert into Laboratorio (CodigoLab, Nombre) values ('2572755602', 'Eriogonum lachnogynum Torr. ex Benth. var. colobum Reveal & A. Clifford');
insert into Laboratorio (CodigoLab, Nombre) values ('5791955839', 'Salvia subincisa Benth.');
insert into Laboratorio (CodigoLab, Nombre) values ('6715536961', 'Carex norvegica Retz. ssp. inferalpina (Wahlenb.) Hultén');
insert into Laboratorio (CodigoLab, Nombre) values ('8730818400', 'Peperomia amplexicaulis (Sw.) A. Dietr.');
insert into Laboratorio (CodigoLab, Nombre) values ('3708972287', 'Rhizocarpon athalloides (Nyl.) Hasse');
insert into Laboratorio (CodigoLab, Nombre) values ('9836840931', 'Mentzelia pumila Nutt. ex Torr. & A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('0980677866', 'Draba stenoloba Ledeb. var. stenoloba');
insert into Laboratorio (CodigoLab, Nombre) values ('6452582321', 'Murraya exotica L.');
insert into Laboratorio (CodigoLab, Nombre) values ('1091193061', 'Psora cerebriformis W.A. Weber');
insert into Laboratorio (CodigoLab, Nombre) values ('0824242785', 'Gundlachia A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('2091804207', 'Fragaria ×ananassa (Weston) Duchesne ex Rozier ssp. ananassa');
insert into Laboratorio (CodigoLab, Nombre) values ('4815439710', 'Saritaea Dugand');
insert into Laboratorio (CodigoLab, Nombre) values ('9706778144', 'Arthonia vernans Willey');
insert into Laboratorio (CodigoLab, Nombre) values ('7053220826', 'Ericameria parryi (A. Gray) G.L. Nesom & Baird var. vulcanica (Greene) G.L. Nesom & Baird');
insert into Laboratorio (CodigoLab, Nombre) values ('5276593183', 'Fimbristylis cymosa R. Br. ssp. cymosa');
insert into Laboratorio (CodigoLab, Nombre) values ('8820254980', 'Vitis californica Benth.');
insert into Laboratorio (CodigoLab, Nombre) values ('0832445835', 'Opuntia littoralis (Engelm.) Cockerell var. littoralis');
insert into Laboratorio (CodigoLab, Nombre) values ('5183375682', 'Clappia A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('6711533259', 'Distichium capillaceum (Hedw.) Bruch & Schimp. var. capillaceum');
insert into Laboratorio (CodigoLab, Nombre) values ('4314169028', 'Rumex pallidus Bigelow');
insert into Laboratorio (CodigoLab, Nombre) values ('4303084794', 'Neomarica Sprague');
insert into Laboratorio (CodigoLab, Nombre) values ('8449149355', 'Leptochloa nealleyi Vasey');
insert into Laboratorio (CodigoLab, Nombre) values ('6265816489', 'Atriplex canescens (Pursh) Nutt.');
insert into Laboratorio (CodigoLab, Nombre) values ('5715621518', 'Ceanothus gloriosus J.T. Howell');
insert into Laboratorio (CodigoLab, Nombre) values ('7411564419', 'Robinia hispida L. var. fertilis (Ashe) R.T. Clausen');
insert into Laboratorio (CodigoLab, Nombre) values ('5090182612', 'Dicranum elongatum Schleich. ex Schwägr.');
insert into Laboratorio (CodigoLab, Nombre) values ('8411461432', 'Beta lomatogona Fisch. & C.A. Mey.');
insert into Laboratorio (CodigoLab, Nombre) values ('9538641175', 'Symphyotrichum novi-belgii (L.) G.L. Nesom');
insert into Laboratorio (CodigoLab, Nombre) values ('4709044325', 'Cynometra ramiflora L.');
insert into Laboratorio (CodigoLab, Nombre) values ('9711514419', 'Senecio integerrimus Nutt. var. scribneri (Rydb.) T.M. Barkley');
insert into Laboratorio (CodigoLab, Nombre) values ('8526777270', 'Eragrostis minor Host');
insert into Laboratorio (CodigoLab, Nombre) values ('7777259989', 'Gymnocarpium jessoense (Koidzumi) Koidzumi ssp. parvulum Sarvela');
insert into Laboratorio (CodigoLab, Nombre) values ('1542619289', 'Buelliella minimula (Tuck.) Fink');
insert into Laboratorio (CodigoLab, Nombre) values ('1378274709', 'Stipa ichu (Ruiz & Pav.) Kunth');
insert into Laboratorio (CodigoLab, Nombre) values ('3512052371', 'Lycium andersonii A. Gray var. wrightii A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('2621154298', 'Mertensia longiflora Greene');
insert into Laboratorio (CodigoLab, Nombre) values ('5097001001', 'Galium sparsiflorum W. Wight ssp. glabrius Dempster & Stebbins');
insert into Laboratorio (CodigoLab, Nombre) values ('3300834511', 'Blysmus rufus (Huds.) Link');
insert into Laboratorio (CodigoLab, Nombre) values ('3236740051', 'Lathyrus vestitus Nutt. ssp. bolanderi (S. Watson) C.L. Hitchc.');
insert into Laboratorio (CodigoLab, Nombre) values ('0491257945', 'Tridens muticus (Torr.) Nash var. muticus');
insert into Laboratorio (CodigoLab, Nombre) values ('8721733104', 'Oxalis hirta L.');
insert into Laboratorio (CodigoLab, Nombre) values ('7581309029', 'Astragalus accidens S. Watson');
insert into Laboratorio (CodigoLab, Nombre) values ('5054863605', 'Viburnum australe Morton');
insert into Laboratorio (CodigoLab, Nombre) values ('1715870859', 'Penstemon speciosus Douglas ex Lindl.');
insert into Laboratorio (CodigoLab, Nombre) values ('2665453622', 'Carex albolutescens Schwein.');
insert into Laboratorio (CodigoLab, Nombre) values ('7214304864', 'Munroidendron Sherff');
insert into Laboratorio (CodigoLab, Nombre) values ('7262537911', 'Trillium erectum L.');
insert into Laboratorio (CodigoLab, Nombre) values ('7712678723', 'Melampyrum L.');
insert into Laboratorio (CodigoLab, Nombre) values ('1505059410', 'Leptogium adpressum Nyl.');
insert into Laboratorio (CodigoLab, Nombre) values ('9744323345', 'Erigeron divergens Torr. & A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('8647099184', 'Lycopodium lagopus (Laest. ex Hartm.) Zinserl. ex Kuzen');
insert into Laboratorio (CodigoLab, Nombre) values ('4982304386', 'Polytrichum formosum Hedw.');
insert into Laboratorio (CodigoLab, Nombre) values ('5582975861', 'Ochrolechia laevigata (Rasanen) Verseghy ex Brodo');
insert into Laboratorio (CodigoLab, Nombre) values ('7996566089', 'Noccaea fendleri (A. Gray) Holub ssp. glauca (A. Nelson) Al-Shehbaz & M. Koch');
insert into Laboratorio (CodigoLab, Nombre) values ('5905407908', 'Streptanthus farnsworthianus J.T. Howell');
insert into Laboratorio (CodigoLab, Nombre) values ('4609952122', 'Pteroglossaspis ecristata (Fernald) Rolfe');
insert into Laboratorio (CodigoLab, Nombre) values ('9261061710', 'Tauschia arguta (Torr. & A. Gray) J.F. Macbr.');
insert into Laboratorio (CodigoLab, Nombre) values ('0356796078', 'Jacaranda Juss.');
insert into Laboratorio (CodigoLab, Nombre) values ('0340312327', 'Arctomia Th. Fr.');
insert into Laboratorio (CodigoLab, Nombre) values ('3404883306', 'Spiranthes brevilabris Lindl.');
insert into Laboratorio (CodigoLab, Nombre) values ('0631863273', 'Navarretia heterodoxa (Greene) Greene');
insert into Laboratorio (CodigoLab, Nombre) values ('4567613252', 'Viola purpurea Kellogg ssp. geophyta M.S. Baker & J.C. Clausen');
insert into Laboratorio (CodigoLab, Nombre) values ('5011183084', 'Roellia roellii (Broth.) Andrews ex H.A. Crum');
insert into Laboratorio (CodigoLab, Nombre) values ('2153038901', 'Hibiscus syriacus L.');
insert into Laboratorio (CodigoLab, Nombre) values ('9990155976', 'Illicium floridanum Ellis');
insert into Laboratorio (CodigoLab, Nombre) values ('7134412334', 'Platanthera obtusata (Banks ex Pursh) Lindl. ssp. obtusata');
insert into Laboratorio (CodigoLab, Nombre) values ('3339180946', 'Hedyotis st.-johnii B.C. Stone & M.A. Lane');
insert into Laboratorio (CodigoLab, Nombre) values ('8149264361', 'Pyrrocoma apargioides (A. Gray) Greene');
insert into Laboratorio (CodigoLab, Nombre) values ('6704042709', 'Aletes anisatus (A. Gray) W.L. Theobald & C.C. Tseng');
insert into Laboratorio (CodigoLab, Nombre) values ('6264346144', 'Balanites aegyptiacus (L.) Delile');
insert into Laboratorio (CodigoLab, Nombre) values ('4976727246', 'Cecropia obtusifolia Bertol.');
insert into Laboratorio (CodigoLab, Nombre) values ('9216007222', 'Carex baltzellii Chapm. ex Dewey');
insert into Laboratorio (CodigoLab, Nombre) values ('4464463061', 'Goodyera R. Br.');
insert into Laboratorio (CodigoLab, Nombre) values ('0773496645', 'Trifolium monanthum A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('4270879564', 'Polygala nitida Brandegee');
insert into Laboratorio (CodigoLab, Nombre) values ('7794721598', 'Jatropha hernandiifolia Vent.');
insert into Laboratorio (CodigoLab, Nombre) values ('2076154396', 'Lecidea santae-monicae H. Magn.');
insert into Laboratorio (CodigoLab, Nombre) values ('7139777675', 'Polycarpon tetraphyllum (L.) L.');
insert into Laboratorio (CodigoLab, Nombre) values ('8907193258', 'Arctoa Bruch & Schimp.');
insert into Laboratorio (CodigoLab, Nombre) values ('9400231326', 'Calystegia spithamaea (L.) Pursh ssp. spithamaea');
insert into Laboratorio (CodigoLab, Nombre) values ('5401843259', 'Lobelia spicata Lam. var. leptostachys (A. DC.) Mack. & Bush');
insert into Laboratorio (CodigoLab, Nombre) values ('1188622412', 'Lesquerella pruinosa Greene');
insert into Laboratorio (CodigoLab, Nombre) values ('8826232237', 'Spirodela intermedia W.D.J. Koch');
insert into Laboratorio (CodigoLab, Nombre) values ('2917662778', 'Sisyrinchium halophilum Greene');
insert into Laboratorio (CodigoLab, Nombre) values ('4357290228', 'Eriogonum grande Greene');
insert into Laboratorio (CodigoLab, Nombre) values ('1662875886', 'Stephanomeria cichoriacea A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('5697371799', 'Paronychia baldwinii (Torr. & A. Gray) Fenzl ex Walp. ssp. riparia (Chapm.) Chaudhri');
insert into Laboratorio (CodigoLab, Nombre) values ('1827951583', 'Xanthoparmelia neoconspersa (Gyel.) Hale');
insert into Laboratorio (CodigoLab, Nombre) values ('1059098423', 'Carex ozarkana P. Rothr. & Reznicek');
insert into Laboratorio (CodigoLab, Nombre) values ('1490392467', 'Chorizanthe breweri S. Watson');
insert into Laboratorio (CodigoLab, Nombre) values ('8202547741', 'Delosperma N.E. Br.');
insert into Laboratorio (CodigoLab, Nombre) values ('9461234864', 'Rosa blanda Aiton');
insert into Laboratorio (CodigoLab, Nombre) values ('1133243169', 'Eriogonum jamesii Benth. var. undulatum (Benth.) S. Stokes ex M.E. Jones');
insert into Laboratorio (CodigoLab, Nombre) values ('9376203380', 'Carex helleri Mack.');
insert into Laboratorio (CodigoLab, Nombre) values ('3087950823', 'Androsace filiformis Retz.');
insert into Laboratorio (CodigoLab, Nombre) values ('1299400574', 'Astragalus tephrodes A. Gray var. brachylobus (A. Gray) Barneby');
insert into Laboratorio (CodigoLab, Nombre) values ('7691037163', 'Astragalus curvicarpus (A. Heller) J.F. Macbr.');
insert into Laboratorio (CodigoLab, Nombre) values ('8210088750', 'Beaucarnea recurvata Lem.');
insert into Laboratorio (CodigoLab, Nombre) values ('9470873157', 'Rudbeckia texana (Perdue) P. Cox & Urbatsch');
insert into Laboratorio (CodigoLab, Nombre) values ('9052394059', 'Trifolium campestre Schreb.');
insert into Laboratorio (CodigoLab, Nombre) values ('8030587848', 'Vanilla poitaei Rchb. f.');
insert into Laboratorio (CodigoLab, Nombre) values ('6103825377', 'Cerastium beeringianum Cham. & Schltdl. ssp. beeringianum var. beeringianum');
insert into Laboratorio (CodigoLab, Nombre) values ('1563224305', 'Forsteronia G. Mey.');
insert into Laboratorio (CodigoLab, Nombre) values ('2863120778', 'Penstemon kralii D. Estes');
insert into Laboratorio (CodigoLab, Nombre) values ('3741186414', 'Callirhoe leiocarpa R.F. Martin');
insert into Laboratorio (CodigoLab, Nombre) values ('4547575835', 'Eucalyptus rigens Brooker & Hopper');
insert into Laboratorio (CodigoLab, Nombre) values ('3412718831', 'Lecidella granulata (H. Magn.) R.C. Harris');
insert into Laboratorio (CodigoLab, Nombre) values ('2716038082', 'Plagiomnium medium (Bruch & Schimp.) T. Kop. var. curvatulum (Lindb.) H.A. Crum & L.E. Anderson');
insert into Laboratorio (CodigoLab, Nombre) values ('3278200861', 'Juncus interior Wiegand var. neomexicanus (Wiegand) F.J. Herm.');
insert into Laboratorio (CodigoLab, Nombre) values ('7089349055', 'Descurainia pinnata (Walter) Britton ssp. paysonii Detling');
insert into Laboratorio (CodigoLab, Nombre) values ('4661245563', 'Lewisia columbiana (Howell ex A. Gray) B.L. Rob. var. columbiana');
insert into Laboratorio (CodigoLab, Nombre) values ('8361814981', 'Potentilla atrosanguinea Lodd. ex D. Don');
insert into Laboratorio (CodigoLab, Nombre) values ('0935216286', 'Eriogonum mortonianum Reveal');
insert into Laboratorio (CodigoLab, Nombre) values ('6307948701', 'Argythamnia mercurialina (Nutt.) Müll. Arg. var. pilosissima (Benth.) Shinners');
insert into Laboratorio (CodigoLab, Nombre) values ('7106965448', 'Tetracarpidium Pax');
insert into Laboratorio (CodigoLab, Nombre) values ('7461055860', 'Scaevola mollis Hook. & Arn.');
insert into Laboratorio (CodigoLab, Nombre) values ('4657695029', 'Calochortus tiburonensis A.J. Hill');
insert into Laboratorio (CodigoLab, Nombre) values ('6823853123', 'Salix fuscescens Andersson');
insert into Laboratorio (CodigoLab, Nombre) values ('4516845091', 'Aletris L.');
insert into Laboratorio (CodigoLab, Nombre) values ('7547079989', 'Cissampelos pareira L.');
insert into Laboratorio (CodigoLab, Nombre) values ('2603670670', 'Viola ×robinsoniana House');
insert into Laboratorio (CodigoLab, Nombre) values ('7789917633', 'Olsynium Raf.');
insert into Laboratorio (CodigoLab, Nombre) values ('7086236624', 'Setaria pumila (Poir.) Roem. & Schult.');
insert into Laboratorio (CodigoLab, Nombre) values ('1825177317', 'Carex arctata Boott ex Hook.');
insert into Laboratorio (CodigoLab, Nombre) values ('9081620401', 'Bryoria spiralifera Brodo & D. Hawksw.');
insert into Laboratorio (CodigoLab, Nombre) values ('8526055542', 'Lepidium nitidum Nutt. var. nitidum');
insert into Laboratorio (CodigoLab, Nombre) values ('3824988593', 'Mirabilis laevis (Benth.) Curran var. retrorsa (A. Heller) Jeps.');
insert into Laboratorio (CodigoLab, Nombre) values ('3333891867', 'Pseudocyphellaria anthraspis (Ach.) H. Magn.');
insert into Laboratorio (CodigoLab, Nombre) values ('8293413743', 'Renealmia jamaicensis (Gaertn.) Horan.');
insert into Laboratorio (CodigoLab, Nombre) values ('7261180440', 'Choisya dumosa (Torr.) A. Gray var. dumosa');
insert into Laboratorio (CodigoLab, Nombre) values ('0162115156', 'Passiflora suberosa L.');
insert into Laboratorio (CodigoLab, Nombre) values ('0041181573', 'Castilleja raupii Pennell');
insert into Laboratorio (CodigoLab, Nombre) values ('4650040272', 'Carex hyalina Boott');
insert into Laboratorio (CodigoLab, Nombre) values ('3303358931', 'Primula parryi A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('3614286177', 'Woodsia scopulina D.C. Eaton');
insert into Laboratorio (CodigoLab, Nombre) values ('1546603158', 'Rhizocarpon rittokense (Hellbom) Th. Fr.');
insert into Laboratorio (CodigoLab, Nombre) values ('8036523701', 'Syringa pekinensis Rupr.');
insert into Laboratorio (CodigoLab, Nombre) values ('7290779487', 'Gilia brecciarum M.E. Jones ssp. neglecta A.D. Grant & V.E. Grant');
insert into Laboratorio (CodigoLab, Nombre) values ('9229684767', 'Astragalus canadensis L. var. mortonii (Nutt.) S. Watson');
insert into Laboratorio (CodigoLab, Nombre) values ('9180173152', 'Aspicilia perradiata (Nyl.) Hue');
insert into Laboratorio (CodigoLab, Nombre) values ('2836321695', 'Ischaemum timorense Kunth');
insert into Laboratorio (CodigoLab, Nombre) values ('0749284196', 'Malus florentina (Zuccagni) C.K. Schneid.');
insert into Laboratorio (CodigoLab, Nombre) values ('4959493143', 'Anthoceros punctatus L.');
insert into Laboratorio (CodigoLab, Nombre) values ('3469873313', 'Buxbaumia piperi Best');
insert into Laboratorio (CodigoLab, Nombre) values ('8679725714', '×Amelasorbus Rehder');
insert into Laboratorio (CodigoLab, Nombre) values ('4402526116', 'Desmodium psilocarpum A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('6655836042', 'Zea luxurians (Durieu & Asch.) Bird');
insert into Laboratorio (CodigoLab, Nombre) values ('8184430744', 'Juglans nigra L.');
insert into Laboratorio (CodigoLab, Nombre) values ('8394032478', 'Selaginella uncinata (Desv. ex Poir.) Spring');
insert into Laboratorio (CodigoLab, Nombre) values ('1981105735', 'Cladonia ecmocyna Leight. ssp. intermedia (Robbins) Ahti');
insert into Laboratorio (CodigoLab, Nombre) values ('5952266975', 'Crataegus ×laneyi Sarg. (pro sp.)');
insert into Laboratorio (CodigoLab, Nombre) values ('5252401748', 'Trifolium dalmaticum Vis.');
insert into Laboratorio (CodigoLab, Nombre) values ('2629476227', 'Justicia candicans (Nees) L.D. Benson');
insert into Laboratorio (CodigoLab, Nombre) values ('1324258039', 'Quercus ×macdonaldii Greene & Kellogg (pro sp.)');
insert into Laboratorio (CodigoLab, Nombre) values ('6513705428', 'Potamogeton illinoensis Morong');
insert into Laboratorio (CodigoLab, Nombre) values ('4121588363', 'Mentzelia multicaulis (Osterh.) A. Nelson ex J. Darl. var. uintahensis N.H. Holmgren & P.K. Holmgren');
insert into Laboratorio (CodigoLab, Nombre) values ('7747726058', 'Pinus longaeva D.K. Bailey');
insert into Laboratorio (CodigoLab, Nombre) values ('1479583561', 'Dulichium arundinaceum (L.) Britton var. arundinaceum');
insert into Laboratorio (CodigoLab, Nombre) values ('5161283505', 'Castilleja hispida Benth. ssp. acuta Pennell');
insert into Laboratorio (CodigoLab, Nombre) values ('0866725741', 'Penstemon virens Pennell ex Rydb.');
insert into Laboratorio (CodigoLab, Nombre) values ('7825679490', 'Burmannia flava Mart.');
insert into Laboratorio (CodigoLab, Nombre) values ('4937492411', 'Oligoneuron album (Nutt.) G.L. Nesom');
insert into Laboratorio (CodigoLab, Nombre) values ('0003922588', 'Arthonia subminutula Nyl.');
insert into Laboratorio (CodigoLab, Nombre) values ('2278952676', 'Mycomicrothelia capitosa (Krempelh.) D. Hawksw.');
insert into Laboratorio (CodigoLab, Nombre) values ('3915718114', 'Abronia maritima Nutt. ex S. Watson');
insert into Laboratorio (CodigoLab, Nombre) values ('8395146353', 'Polygonum buxiforme Small');
insert into Laboratorio (CodigoLab, Nombre) values ('8732685165', 'Anthurium dominicense Schott');
insert into Laboratorio (CodigoLab, Nombre) values ('3875407490', 'Urochloa arrecta (Hack. ex T. Dur. & Schinz) O. Morrone & F. Zuloaga');
insert into Laboratorio (CodigoLab, Nombre) values ('6028553204', 'Buchanania latifolia Roxb.');
insert into Laboratorio (CodigoLab, Nombre) values ('6909731883', 'Mertensia platyphylla A. Heller var. subcordata (Greene) L.O. Williams');
insert into Laboratorio (CodigoLab, Nombre) values ('9813872306', 'Sisyrinchium capillare E.P. Bicknell');
insert into Laboratorio (CodigoLab, Nombre) values ('4382389607', 'Acarospora glaucocarpa (Ach.) Körb.');
insert into Laboratorio (CodigoLab, Nombre) values ('6404173166', 'Plectritis macrocera Torr. & A. Gray ssp. macrocera');
insert into Laboratorio (CodigoLab, Nombre) values ('7766754924', 'Rytidosperma biannulare (Zotov) Connor & Edgar');
insert into Laboratorio (CodigoLab, Nombre) values ('5064461615', 'Cirsium araneans Rydb.');
insert into Laboratorio (CodigoLab, Nombre) values ('7518086417', 'Bletia patula Graham var. alba A.D. Hawkes');
insert into Laboratorio (CodigoLab, Nombre) values ('6569935070', 'Verbascum pulverulentum Vill.');
insert into Laboratorio (CodigoLab, Nombre) values ('5409513045', 'Cotoneaster acutifolius Turcz.');
insert into Laboratorio (CodigoLab, Nombre) values ('8634399222', 'Arabis pulchra M.E. Jones ex S. Watson var. gracilis M.E. Jones');
insert into Laboratorio (CodigoLab, Nombre) values ('6344845325', 'Catapyrenium heppioides (Zahlbr.) J.W. Thomson');
insert into Laboratorio (CodigoLab, Nombre) values ('2250803951', 'Silybum Adans.');
insert into Laboratorio (CodigoLab, Nombre) values ('4538172766', 'Puccinellia phryganodes (Trin.) Scribn. & Merr.');
insert into Laboratorio (CodigoLab, Nombre) values ('2854149130', 'Crotalaria purshii DC.');
insert into Laboratorio (CodigoLab, Nombre) values ('8322726082', 'Trifolium andersonii A. Gray ssp. andersonii');
insert into Laboratorio (CodigoLab, Nombre) values ('3763190260', 'Horkelia fusca Lindl. ssp. capitata (Lindl.) D.D. Keck');
insert into Laboratorio (CodigoLab, Nombre) values ('7492164386', 'Arctostaphylos parryana Lemmon ssp. parryana');
insert into Laboratorio (CodigoLab, Nombre) values ('0778526461', 'Leptogium floridanum Sierk');
insert into Laboratorio (CodigoLab, Nombre) values ('4078179657', 'Eucrypta chrysanthemifolia (Benth.) Greene var. bipinnatifida (Torr.) Constance');
insert into Laboratorio (CodigoLab, Nombre) values ('7784865228', 'Clarkia xantiana A. Gray ssp. parviflora (Eastw.) H.F. Lewis & P.H. Raven');
insert into Laboratorio (CodigoLab, Nombre) values ('3932694074', 'Leskea Hedw.');
insert into Laboratorio (CodigoLab, Nombre) values ('1412647754', 'Agrimonia microcarpa Wallr.');
insert into Laboratorio (CodigoLab, Nombre) values ('4137566089', 'Astragalus oocarpus A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('9949436427', 'Bryum aeneum Blytt ex Bruch & Schimp.');
insert into Laboratorio (CodigoLab, Nombre) values ('5279887986', 'Parkinsonia texana (A. Gray) S. Watson var. texana');
insert into Laboratorio (CodigoLab, Nombre) values ('3212698055', 'Costus scaber Ruiz & Pav.');
insert into Laboratorio (CodigoLab, Nombre) values ('3838234278', 'Agoseris glauca (Pursh) Raf. var. agrestis (Osterh.) Q. Jones ex Cronquist');
insert into Laboratorio (CodigoLab, Nombre) values ('7673552019', 'Oxalis trilliifolia Hook.');
insert into Laboratorio (CodigoLab, Nombre) values ('0383940117', 'Arabis pulchra M.E. Jones ex S. Watson');
insert into Laboratorio (CodigoLab, Nombre) values ('2496278039', 'Cyperus flavidus Retz.');
insert into Laboratorio (CodigoLab, Nombre) values ('5759019953', 'Pinguicula ionantha Godfrey');
insert into Laboratorio (CodigoLab, Nombre) values ('4059755192', 'Solidago hispida Muhl. ex Willd. var. lanata (Hook.) Fernald');
insert into Laboratorio (CodigoLab, Nombre) values ('4468482869', 'Bebbia juncea (Benth.) Greene');
insert into Laboratorio (CodigoLab, Nombre) values ('7515921412', 'Placynthium petersii (Nyl.) Burnham');
insert into Laboratorio (CodigoLab, Nombre) values ('0966865294', 'Platanthera macrophylla (Goldie) P.M. Brown');
insert into Laboratorio (CodigoLab, Nombre) values ('7064025728', 'Eriophorum callitrix Cham. ex C.A. Mey.');
insert into Laboratorio (CodigoLab, Nombre) values ('5291979054', 'Neomacounia nitida (Lindb.) Irel.');
insert into Laboratorio (CodigoLab, Nombre) values ('2265459712', 'Lepidium strictum (S. Watson) Rattan');
insert into Laboratorio (CodigoLab, Nombre) values ('0049223224', 'Enterolobium Mart.');
insert into Laboratorio (CodigoLab, Nombre) values ('4650757398', 'Dasyochloa pulchella (Kunth) Willd. ex Rydb.');
insert into Laboratorio (CodigoLab, Nombre) values ('6606415217', 'Crambe abyssinica Hochst. ex R.E. Fries');
insert into Laboratorio (CodigoLab, Nombre) values ('1320093027', 'Tonestus eximius (H.M. Hall) A. Nelson & J.F. Macbr.');
insert into Laboratorio (CodigoLab, Nombre) values ('8032656081', 'Pellaea andromedifolia (Kaulf.) Fée');
insert into Laboratorio (CodigoLab, Nombre) values ('4311263090', 'Xolantha guttata (L.) Raf.');
insert into Laboratorio (CodigoLab, Nombre) values ('6124565897', 'Glandularia canadensis (L.) Nutt.');
insert into Laboratorio (CodigoLab, Nombre) values ('2803521571', 'Pistacia atlantica Desf.');
insert into Laboratorio (CodigoLab, Nombre) values ('3807771301', 'Polygala incarnata L.');
insert into Laboratorio (CodigoLab, Nombre) values ('9874108991', 'Cyperus flavescens L.');
insert into Laboratorio (CodigoLab, Nombre) values ('9586474682', 'Brachythecium populeum (Hedw.) Schimp.');
insert into Laboratorio (CodigoLab, Nombre) values ('0982332319', 'Cercocarpus traskiae Eastw.');
insert into Laboratorio (CodigoLab, Nombre) values ('3954493535', 'Grusonia kunzei (Rose) Pinkava');
insert into Laboratorio (CodigoLab, Nombre) values ('1793634998', 'Arenaria aculeata S. Watson');
insert into Laboratorio (CodigoLab, Nombre) values ('3977220829', 'Aongstroemia Bruch & Schimp.');
insert into Laboratorio (CodigoLab, Nombre) values ('4491630976', 'Asclepias stenophylla A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('7994487068', 'Poa laxa Haenke');
insert into Laboratorio (CodigoLab, Nombre) values ('4207346503', 'Plantago princeps Cham. & Schltdl. var. longibracteata H. Mann');
insert into Laboratorio (CodigoLab, Nombre) values ('8628895779', 'Phoradendron pauciflorum Torr.');
insert into Laboratorio (CodigoLab, Nombre) values ('2503345433', 'Commelina diffusa Burm. f. var. gigas (Small) Faden');
insert into Laboratorio (CodigoLab, Nombre) values ('5276256934', 'Trifolium steudneri Schweinf.');
insert into Laboratorio (CodigoLab, Nombre) values ('7735447744', 'Trachycarpus fortunei (Hook.) H. Wendl.');
insert into Laboratorio (CodigoLab, Nombre) values ('0373696256', 'Tradescantia subaspera Ker Gawl.');
insert into Laboratorio (CodigoLab, Nombre) values ('5649227446', 'Cinclidium arcticum Bruch & Schimp.');
insert into Laboratorio (CodigoLab, Nombre) values ('7603807514', 'Malacothrix sonchoides (Nutt.) Torr. & A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('5686274851', 'Angelica archangelica L. ssp. norvegica (Rupr.) Nordh.');
insert into Laboratorio (CodigoLab, Nombre) values ('9234417429', 'Condylidium iresinoides (Kunth) R.M. King & H. Rob.');
insert into Laboratorio (CodigoLab, Nombre) values ('3101443474', 'Usnea catenulata Mot.');
insert into Laboratorio (CodigoLab, Nombre) values ('0584713428', 'Calochortus monanthus Ownbey');
insert into Laboratorio (CodigoLab, Nombre) values ('0613598180', 'Castilleja victoriae Fairbarns & J.M. Egger');
insert into Laboratorio (CodigoLab, Nombre) values ('9848665161', 'Asplenium lobulatum Mett.');
insert into Laboratorio (CodigoLab, Nombre) values ('4139725400', 'Thelypteris hispidula (Decne.) C.F. Reed var. inconstans (C. Chr.) Proctor');
insert into Laboratorio (CodigoLab, Nombre) values ('5063892760', 'Lupinus croceus Eastw. var. pilosellus (Eastw.) Munz');
insert into Laboratorio (CodigoLab, Nombre) values ('9078948418', 'Styrax portoricensis Krug & Urb.');
insert into Laboratorio (CodigoLab, Nombre) values ('4791978854', 'Ocimum basilicum L.');
insert into Laboratorio (CodigoLab, Nombre) values ('3204709787', 'Peltigera canina (L.) Willd.');
insert into Laboratorio (CodigoLab, Nombre) values ('2110089911', 'Vaccaria von Wolf');
insert into Laboratorio (CodigoLab, Nombre) values ('2888739887', 'Erigeron ovinus Cronquist');
insert into Laboratorio (CodigoLab, Nombre) values ('3487928590', 'Althaea officinalis L.');
insert into Laboratorio (CodigoLab, Nombre) values ('8758844732', 'Cardamine breweri S. Watson var. breweri');
insert into Laboratorio (CodigoLab, Nombre) values ('5922633554', 'Cyrtomnium hymenophyllum (Bruch & Schimp.) Holmen');
insert into Laboratorio (CodigoLab, Nombre) values ('6976165428', 'Cardamine pachystigma (S. Watson) Rollins var. dissectifolia (Detling) Rollins');
insert into Laboratorio (CodigoLab, Nombre) values ('8544202322', 'Pylaisiella Kindb.');
insert into Laboratorio (CodigoLab, Nombre) values ('8985701630', 'Mappia racemosa Jacq.');
insert into Laboratorio (CodigoLab, Nombre) values ('5931241817', 'Symphyotrichum ericoides (L.) G.L. Nesom var. pansum (S.F. Blake) G.L. Nesom');
insert into Laboratorio (CodigoLab, Nombre) values ('6698487570', 'Passiflora ciliata Aiton var. riparia C. Wright');
insert into Laboratorio (CodigoLab, Nombre) values ('8580004500', 'Euonymus americanus L.');
insert into Laboratorio (CodigoLab, Nombre) values ('1686522479', 'Acarospora heufleriana Körb.');
insert into Laboratorio (CodigoLab, Nombre) values ('2112358456', 'Polanisia dodecandra (L.) DC. ssp. dodecandra');
insert into Laboratorio (CodigoLab, Nombre) values ('4515969900', 'Camissonia claviformis (Torr. & Frém.) P.H. Raven ssp. peirsonii (Munz) P.H. Raven');
insert into Laboratorio (CodigoLab, Nombre) values ('6011837719', 'Calamagrostis epigeios (L.) Roth ssp. meinshausenii Tzvelev [excluded]');
insert into Laboratorio (CodigoLab, Nombre) values ('7514644989', 'Botrychium rugulosum W.H. Wagner');
insert into Laboratorio (CodigoLab, Nombre) values ('7170270269', 'Allamanda blanchetii A. DC.');
insert into Laboratorio (CodigoLab, Nombre) values ('3895000019', 'Ericameria nauseosa (Pall. ex Pursh) G.L. Nesom & Baird ssp. nauseosa var. glabrata (A. Gray) G.L. Nesom & Baird');
insert into Laboratorio (CodigoLab, Nombre) values ('6642850610', 'Seymeria cassioides (J.F. Gmel.) S.F. Blake');
insert into Laboratorio (CodigoLab, Nombre) values ('4714874683', 'Pyrenopsis lecidella Fink');
insert into Laboratorio (CodigoLab, Nombre) values ('7282288461', 'Buellia erubescens Arnold');
insert into Laboratorio (CodigoLab, Nombre) values ('6411397112', 'Sorghastrum elliottii (C. Mohr) Nash');
insert into Laboratorio (CodigoLab, Nombre) values ('3358122239', 'Gossypium hirsutum L.');
insert into Laboratorio (CodigoLab, Nombre) values ('0760173370', 'Lysimachia lamiatilis H. St. John');
insert into Laboratorio (CodigoLab, Nombre) values ('0361991193', 'Vaccinium simulatum Small');
insert into Laboratorio (CodigoLab, Nombre) values ('5740808111', 'Saxifraga hirculus L.');
insert into Laboratorio (CodigoLab, Nombre) values ('0025238361', 'Ceratophyllum L.');
insert into Laboratorio (CodigoLab, Nombre) values ('2287953000', 'Strophanthus thollonii Franchet');
insert into Laboratorio (CodigoLab, Nombre) values ('4508954480', 'Leptodactylon Hook. & Arn.');
insert into Laboratorio (CodigoLab, Nombre) values ('4147726011', 'Scutellaria elliptica Muhl. ex Spreng. var. elliptica');
insert into Laboratorio (CodigoLab, Nombre) values ('0810546868', 'Xanthoparmelia hypomelaena (Hale) Hale');
insert into Laboratorio (CodigoLab, Nombre) values ('8964459652', 'Rhynchosia caribaea (Jacq.) DC.');
insert into Laboratorio (CodigoLab, Nombre) values ('5569831312', 'Ribes bracteosum Douglas ex Hook.');
insert into Laboratorio (CodigoLab, Nombre) values ('0335111246', 'Quercus vacciniifolia Kellogg');
insert into Laboratorio (CodigoLab, Nombre) values ('3480698123', 'Usnea diplotypus Vain.');
insert into Laboratorio (CodigoLab, Nombre) values ('7776749265', 'Caloplaca lactea (A. Massal.) Zahlbr.');
insert into Laboratorio (CodigoLab, Nombre) values ('5053317038', 'Chamaesyce laredana (Millsp.) Small');
insert into Laboratorio (CodigoLab, Nombre) values ('4750987433', 'Cnemidaria C. Presl');
insert into Laboratorio (CodigoLab, Nombre) values ('1118602269', 'Arthonia glaucomaria (Nyl.) Nyl.');
insert into Laboratorio (CodigoLab, Nombre) values ('6740353212', 'Penstemon dissectus Elliott');
insert into Laboratorio (CodigoLab, Nombre) values ('7104195769', 'Ternstroemia Mutis ex L. f.');
insert into Laboratorio (CodigoLab, Nombre) values ('9665676776', 'Astragalus iodanthus S. Watson');
insert into Laboratorio (CodigoLab, Nombre) values ('7860364344', 'Acacia penninervis Sieber ex DC.');
insert into Laboratorio (CodigoLab, Nombre) values ('9600433046', 'Placidiopsis pseudocinerea Breuss');
insert into Laboratorio (CodigoLab, Nombre) values ('1464844461', 'Anthoceros macounii M. Howe');
insert into Laboratorio (CodigoLab, Nombre) values ('2964961956', 'Eriogonum heermannii Durand & Hilg. var. sulcatum (S. Watson) Munz & Reveal');
insert into Laboratorio (CodigoLab, Nombre) values ('4571108850', 'Umbilicaria lyngei Schol.');
insert into Laboratorio (CodigoLab, Nombre) values ('9906910143', 'Isoetes ×hickeyi W.C. Taylor & N. Luebke');
insert into Laboratorio (CodigoLab, Nombre) values ('6317697833', 'Silene virginica L. var. robusta Strausbaugh & Core');
insert into Laboratorio (CodigoLab, Nombre) values ('4108673069', 'Heuchera parvifolia Nutt. ex Torr. & A. Gray var. nivalis (Rosend., Butters & Lakela) Á. Löve & D. Löve & Kapoor');
insert into Laboratorio (CodigoLab, Nombre) values ('8183448852', 'Aristida L.');
insert into Laboratorio (CodigoLab, Nombre) values ('4212801280', 'Rhapidophyllum hystrix (Pursh) H. Wendl. & Drude ex Drude');
insert into Laboratorio (CodigoLab, Nombre) values ('0862099722', 'Vigna unguiculata (L.) Walp.');
insert into Laboratorio (CodigoLab, Nombre) values ('8300323546', 'Senna sulfurea (DC. ex Collad.) Irwin & Barneby');
insert into Laboratorio (CodigoLab, Nombre) values ('0513261400', 'Lathyrus nevadensis S. Watson ssp. lanceolatus (Howell) C.L. Hitchc. var. parkeri (H. St. John) C.L. Hitchc.');
insert into Laboratorio (CodigoLab, Nombre) values ('2011849373', 'Arceuthobium gillii Hawksw. & Wiens');
insert into Laboratorio (CodigoLab, Nombre) values ('1509880402', 'Rondeletia L.');
insert into Laboratorio (CodigoLab, Nombre) values ('1898954003', 'Sporobolus vaginiflorus (Torr. ex A. Gray) Alph. Wood');
insert into Laboratorio (CodigoLab, Nombre) values ('0355515342', 'Mimosa malacophylla A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('6589638608', 'Calochortus weedii Alph. Wood var. intermedius Ownbey');
insert into Laboratorio (CodigoLab, Nombre) values ('2020779951', 'Saxifraga oppositifolia L. ssp. smalliana (Engl. & Irmsch.) Hultén');
insert into Laboratorio (CodigoLab, Nombre) values ('3228330818', 'Catha Forssk. ex Scop.');
insert into Laboratorio (CodigoLab, Nombre) values ('4519625157', 'Eucalyptus dives Schauer');
insert into Laboratorio (CodigoLab, Nombre) values ('4304775278', 'Lasthenia glabrata Lindl.');
insert into Laboratorio (CodigoLab, Nombre) values ('2824838205', 'Bartonia verna (Michx.) Raf. ex Barton');
insert into Laboratorio (CodigoLab, Nombre) values ('2433127610', 'Jatropha dioica Cerv. var. graminea McVaugh');
insert into Laboratorio (CodigoLab, Nombre) values ('2871809577', 'Polemonium L.');
insert into Laboratorio (CodigoLab, Nombre) values ('5069208519', 'Doryopteris takeuchii (W.H. Wagner) W.H. Wagner');
insert into Laboratorio (CodigoLab, Nombre) values ('6444790301', 'Asplenium aethiopicum (N.L. Burm.) Bech.');
insert into Laboratorio (CodigoLab, Nombre) values ('2285524269', 'Arctomia Th. Fr.');
insert into Laboratorio (CodigoLab, Nombre) values ('2494499313', 'Elionurus tripsacoides Humb. & Bonpl. ex Willd.');
insert into Laboratorio (CodigoLab, Nombre) values ('1826391118', 'Hypocenomyce scalaris (Ach. ex Lilj.) M. Choisy');
insert into Laboratorio (CodigoLab, Nombre) values ('4859702743', 'Scleropodium cespitans (Müll. Hal.) L.F. Koch');
insert into Laboratorio (CodigoLab, Nombre) values ('1732566046', 'Sorghastrum nutans (L.) Nash');
insert into Laboratorio (CodigoLab, Nombre) values ('9534128864', 'Myrosma L. f.');
insert into Laboratorio (CodigoLab, Nombre) values ('0969349688', 'Geranium cuneatum Hook. var. tridens (Hillebr.) Fosberg');
insert into Laboratorio (CodigoLab, Nombre) values ('5595885645', 'Alstroemeria pulchella L. f.');
insert into Laboratorio (CodigoLab, Nombre) values ('2594892912', 'Cystopteris Bernh.');
insert into Laboratorio (CodigoLab, Nombre) values ('0468960120', 'Tephrosia angustissima Shuttlw. ex Chapm. var. curtissii (Small ex Rydb.) Isely');
insert into Laboratorio (CodigoLab, Nombre) values ('7114810229', 'Pohlia pacifica Shaw');
insert into Laboratorio (CodigoLab, Nombre) values ('6857907277', 'Solidago nana Nutt.');
insert into Laboratorio (CodigoLab, Nombre) values ('3476788350', 'Tumamoca Rose');
insert into Laboratorio (CodigoLab, Nombre) values ('8568426913', 'Casearia arborea (Rich.) Urb.');
insert into Laboratorio (CodigoLab, Nombre) values ('0510627234', 'Eriogonum corymbosum Benth.');
insert into Laboratorio (CodigoLab, Nombre) values ('0031559867', 'Ceanothus ophiochilus Boyd, Ross & Arnseth');
insert into Laboratorio (CodigoLab, Nombre) values ('2988060150', 'Penstemon fremontii Torr. & A. Gray ex A. Gray var. fremontii');
insert into Laboratorio (CodigoLab, Nombre) values ('6215748048', 'Atrichum cylindricum (Willd.) G.L. Sm.');
insert into Laboratorio (CodigoLab, Nombre) values ('2962245773', 'Trichloris crinita (Lag.) Parodi');
insert into Laboratorio (CodigoLab, Nombre) values ('6009276438', 'Rosa ×dulcissima Lunell (pro sp.)');
insert into Laboratorio (CodigoLab, Nombre) values ('7310815882', 'Hydnocarpus anthelminticus Pierre ex Lanessan');
insert into Laboratorio (CodigoLab, Nombre) values ('0970630735', 'Hypericum maculatum Crantz');
insert into Laboratorio (CodigoLab, Nombre) values ('5234379329', 'Thelypteris pilosa (M. Martens & Galeotti) Crawford');
insert into Laboratorio (CodigoLab, Nombre) values ('1054515972', 'Amygdalaria subdissentiens (Nyl.) Mas. Inoue & Brodo');
insert into Laboratorio (CodigoLab, Nombre) values ('7894162930', 'Cirsium wheeleri (A. Gray) Petr.');
insert into Laboratorio (CodigoLab, Nombre) values ('4356671600', 'Packera glabella (Poir.) C. Jeffrey');
insert into Laboratorio (CodigoLab, Nombre) values ('9983929325', 'Rumex frutescens Thouars');
insert into Laboratorio (CodigoLab, Nombre) values ('5165309533', 'Chorizanthe parryi S. Watson');
insert into Laboratorio (CodigoLab, Nombre) values ('3424658782', 'Chenopodium littoreum Benet-Pierce & M.G. Simpson');
insert into Laboratorio (CodigoLab, Nombre) values ('5042013229', 'Draba sibirica (Pall.) Thell.');
insert into Laboratorio (CodigoLab, Nombre) values ('1475653360', 'Punctelia perreticulata (Rasanen) G. Wilh. & Ladd');
insert into Laboratorio (CodigoLab, Nombre) values ('7391221619', 'Fontinalis macmillanii Cardot');
insert into Laboratorio (CodigoLab, Nombre) values ('1865014621', 'Aristolochia anguicida Jacq.');
insert into Laboratorio (CodigoLab, Nombre) values ('4049510774', 'Pseudorchis straminea (Fernald) Soó');
insert into Laboratorio (CodigoLab, Nombre) values ('2582847003', 'Miconia lanata (DC.) Triana, nom. inq.');
insert into Laboratorio (CodigoLab, Nombre) values ('3416769716', 'Pilophorus vegae Krog');
insert into Laboratorio (CodigoLab, Nombre) values ('4716416739', 'Ctenitis submarginalis (Langsd. & Fisch.) Ching');
insert into Laboratorio (CodigoLab, Nombre) values ('0409048526', 'Roccellina franciscana (Zahlbr. ex Herre) Follmann');
insert into Laboratorio (CodigoLab, Nombre) values ('7118548790', 'Diplacus Nutt.');
insert into Laboratorio (CodigoLab, Nombre) values ('8162948449', 'Eriogonum ovalifolium (Gand.) Reveal & Mansfield var. rubidum ');
insert into Laboratorio (CodigoLab, Nombre) values ('4217105061', 'Antennaria rosea Greene');
insert into Laboratorio (CodigoLab, Nombre) values ('1664488146', 'Bryoria lanestris (Ach.) Brodo & D. Hawksw.');
insert into Laboratorio (CodigoLab, Nombre) values ('6251499443', 'Calathea lutea (Aubl.) Schult.');
insert into Laboratorio (CodigoLab, Nombre) values ('1885018037', 'Artocarpus elasticus Reinw. ex Blume');
insert into Laboratorio (CodigoLab, Nombre) values ('4852667144', 'Phacelia lemmonii A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('0905389956', 'Alocasia cucullata (Lour.) G. Don');
insert into Laboratorio (CodigoLab, Nombre) values ('0142106763', 'Guapira obtusata (Jacq.) Little');
insert into Laboratorio (CodigoLab, Nombre) values ('7238876647', 'Draba argyrea Rydb.');
insert into Laboratorio (CodigoLab, Nombre) values ('0935881026', 'Mimulus nanus Hook. & Arn. var. mephiticus (A.L. Grant) D. M. Thomps.');
insert into Laboratorio (CodigoLab, Nombre) values ('9489742333', 'Oxalis suksdorfii Trel.');
insert into Laboratorio (CodigoLab, Nombre) values ('1798126478', 'Phanerophlebia C. Presl');
insert into Laboratorio (CodigoLab, Nombre) values ('9049867421', 'Plantago heterophylla Nutt.');
insert into Laboratorio (CodigoLab, Nombre) values ('9726730287', 'Polygonatum biflorum (Walter) Elliott var. hebetifolium R.R. Gates');
insert into Laboratorio (CodigoLab, Nombre) values ('2156505306', 'Datisca glomerata (C. Presl) Baill.');
insert into Laboratorio (CodigoLab, Nombre) values ('3391090685', 'Dichodontium olympicum Renauld & Cardot');
insert into Laboratorio (CodigoLab, Nombre) values ('4201414876', 'Symphyotrichum potosinum (A. Gray) G.L. Nesom');
insert into Laboratorio (CodigoLab, Nombre) values ('1801268908', 'Eleocharis tricostata Torr.');
insert into Laboratorio (CodigoLab, Nombre) values ('5370301603', 'Streblus pendulinus (Endl.) F. Muell.');
insert into Laboratorio (CodigoLab, Nombre) values ('5612111746', 'Ferocactus cylindraceus (Engelm.) Orcutt var. lecontei (Engelm.) H. Bravo');
insert into Laboratorio (CodigoLab, Nombre) values ('3668792259', 'Buellia retrovertens Tuck.');
insert into Laboratorio (CodigoLab, Nombre) values ('2504626517', 'Thrinax radiata Lodd. ex Schult. & Schult. f.');
insert into Laboratorio (CodigoLab, Nombre) values ('1521867909', 'Salix lucida Muhl.');
insert into Laboratorio (CodigoLab, Nombre) values ('0101218311', 'Racomitrium ericoides (F. Weber ex Brid.) Brid.');
insert into Laboratorio (CodigoLab, Nombre) values ('7975167401', 'Casearia decandra Jacq.');
insert into Laboratorio (CodigoLab, Nombre) values ('2015269282', 'Canarium schweinfurthii Engl.');
insert into Laboratorio (CodigoLab, Nombre) values ('5657465466', 'Camissonia cheiranthifolia (Hornem. ex Spreng.) Raimann ssp. suffruticosa (S. Watson) P.H. Raven');
insert into Laboratorio (CodigoLab, Nombre) values ('0290028914', 'Lichenosticta alcicornaria (Lindsay) D. Hawksw.');
insert into Laboratorio (CodigoLab, Nombre) values ('4297019159', 'Cyperus retroflexus Buckley');
insert into Laboratorio (CodigoLab, Nombre) values ('0347865437', 'Lysimachia radicans Hook.');
insert into Laboratorio (CodigoLab, Nombre) values ('0833394371', 'Veronica verna L.');
insert into Laboratorio (CodigoLab, Nombre) values ('8314423149', 'Geranium solanderi Carolin');
insert into Laboratorio (CodigoLab, Nombre) values ('5970883034', 'Thymophylla pentachaeta (DC.) Small');
insert into Laboratorio (CodigoLab, Nombre) values ('0370213904', 'Ipomopsis spicata (Nutt.) V.E. Grant ssp. orchidacea (Brand) Wilken & R.L. Hartm. var. cephaloidea (Rydb.) Wilken & R.L. Hartm.');
insert into Laboratorio (CodigoLab, Nombre) values ('3653745829', 'Mimulus glabratus Kunth var. oklahomensis Fassett');
insert into Laboratorio (CodigoLab, Nombre) values ('2820743609', 'Eurybia compacta G.L. Nesom');
insert into Laboratorio (CodigoLab, Nombre) values ('9908126873', 'Sphaeralcea lindheimeri A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('9573261685', 'Festuca earlei Rydb.');
insert into Laboratorio (CodigoLab, Nombre) values ('7153147829', 'Chaptalia nutans (L.) Polak.');
insert into Laboratorio (CodigoLab, Nombre) values ('8884184665', 'Cnemidaria horrida (L.) C. Presl');
insert into Laboratorio (CodigoLab, Nombre) values ('2066636452', 'Baptisia ×sulphurea Engelm. (pro sp.)');
insert into Laboratorio (CodigoLab, Nombre) values ('0789947137', 'Chenopodium murale L.');
insert into Laboratorio (CodigoLab, Nombre) values ('6138207475', 'Houstonia micrantha (Shinners) Terrell');
insert into Laboratorio (CodigoLab, Nombre) values ('8450065208', 'Eryngium armatum (S. Watson) J.M. Coult. & Rose');
insert into Laboratorio (CodigoLab, Nombre) values ('0968026192', 'Scrophularia canina L. ssp. hoppii (Koch) Fourn.');
insert into Laboratorio (CodigoLab, Nombre) values ('4186295492', 'Pentaclethra macrophylla Benth.');
insert into Laboratorio (CodigoLab, Nombre) values ('6006934884', 'Schaefferia frutescens Jacq.');
insert into Laboratorio (CodigoLab, Nombre) values ('7428290422', 'Rumex kerneri Borbás');
insert into Laboratorio (CodigoLab, Nombre) values ('2269239466', 'Quercus arizonica Sarg.');
insert into Laboratorio (CodigoLab, Nombre) values ('6092789205', 'Paraleucobryum enerve (Thed.) Loeske');
insert into Laboratorio (CodigoLab, Nombre) values ('9540033233', 'Crinum macowanii Baker');
insert into Laboratorio (CodigoLab, Nombre) values ('8799485575', 'Paronychia lindheimeri Engelm. ex A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('3762549745', 'Boerhavia pterocarpa S. Watson');
insert into Laboratorio (CodigoLab, Nombre) values ('0565451235', 'Crataegus chrysocarpa Ashe var. chrysocarpa');
insert into Laboratorio (CodigoLab, Nombre) values ('0594607574', 'Hypericum dissimulatum E.P. Bicknell');
insert into Laboratorio (CodigoLab, Nombre) values ('3163889581', 'Tillandsia ionantha Planch.');
insert into Laboratorio (CodigoLab, Nombre) values ('3760621503', 'Astragalus nuttallianus DC. var. cedrosensis M.E. Jones');
insert into Laboratorio (CodigoLab, Nombre) values ('3306902551', 'Pseudoleskeella tectorum (Funck ex Brid.) Kindb.');
insert into Laboratorio (CodigoLab, Nombre) values ('1676137289', 'Deparia cataracticola M. Kato');
insert into Laboratorio (CodigoLab, Nombre) values ('7933051936', 'Morisonia L.');
insert into Laboratorio (CodigoLab, Nombre) values ('2306551340', 'Mirabilis rotundifolia (Greene) Standl.');
insert into Laboratorio (CodigoLab, Nombre) values ('1253129436', 'Amianthium A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('4148957882', 'Ludwigia hyssopifolia (G. Don) Exell apud A.R. Fernandes');
insert into Laboratorio (CodigoLab, Nombre) values ('4982466696', 'Brachymenium erectum (Hook.) Margad.');
insert into Laboratorio (CodigoLab, Nombre) values ('8127075159', 'Dichrostachys (DC.) Wight & Arn.');
insert into Laboratorio (CodigoLab, Nombre) values ('2057560791', 'Metrosideros polymorpha Gaudich. var. pseudorugosa Skottsb.');
insert into Laboratorio (CodigoLab, Nombre) values ('4605742069', 'Hyptis pectinata (L.) Poit.');
insert into Laboratorio (CodigoLab, Nombre) values ('4695529653', 'Andreaea rothii F. Weber & D. Mohr var. papillosa Müll. Hal.');
insert into Laboratorio (CodigoLab, Nombre) values ('9734455621', 'Caulophyllum giganteum (Farw.) Loconte & Blackwell');
insert into Laboratorio (CodigoLab, Nombre) values ('5756968385', 'Flavoparmelia Hale');
insert into Laboratorio (CodigoLab, Nombre) values ('3366656492', 'Neobeckia Greene');
insert into Laboratorio (CodigoLab, Nombre) values ('1096491834', 'Malacothrix saxatilis (Nutt.) Torr. & A. Gray var. saxatilis');
insert into Laboratorio (CodigoLab, Nombre) values ('1025589165', 'Physcia stellaris (L.) Nyl.');
insert into Laboratorio (CodigoLab, Nombre) values ('0451229126', 'Toninia squalida (Ach.) A. Massal.');
insert into Laboratorio (CodigoLab, Nombre) values ('6067523280', 'Peltigera scabrosa Th. Fr.');
insert into Laboratorio (CodigoLab, Nombre) values ('3613391627', 'Vicia fulgens Battand.');
insert into Laboratorio (CodigoLab, Nombre) values ('0872199789', 'Cucurbita pepo L. var. medullosa Alef.');
insert into Laboratorio (CodigoLab, Nombre) values ('8575879642', 'Lilaeopsis chinensis (L.) Kuntze');
insert into Laboratorio (CodigoLab, Nombre) values ('5827355194', 'Navarretia leucocephala Benth. ssp. bakeri (H. Mason) Day');
insert into Laboratorio (CodigoLab, Nombre) values ('7105967773', 'Dyschoriste linearis (Torr. & A. Gray) Kuntze');
insert into Laboratorio (CodigoLab, Nombre) values ('9280208861', 'Velezia L.');
insert into Laboratorio (CodigoLab, Nombre) values ('0863060668', 'Astrolepis sinuata (Lag. ex Sw.) Benham & Windham');
insert into Laboratorio (CodigoLab, Nombre) values ('9029948833', 'Eremopyrum bonaepartis (Spreng.) Nevski');
insert into Laboratorio (CodigoLab, Nombre) values ('9774647572', 'Selaginella leucobryoides Maxon');
insert into Laboratorio (CodigoLab, Nombre) values ('8938746275', 'Lotus argophyllus (A. Gray) Greene var. adsurgens Dunkle');
insert into Laboratorio (CodigoLab, Nombre) values ('0881471984', 'Allotropa virgata Torr. & A. Gray ex A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('6482696449', 'Cymodocea filiformis (Kütz.) Correll');
insert into Laboratorio (CodigoLab, Nombre) values ('0978604598', 'Senna atomaria (L.) Irwin & Barneby');
insert into Laboratorio (CodigoLab, Nombre) values ('0803949804', 'Eucalyptus robusta Sm.');
insert into Laboratorio (CodigoLab, Nombre) values ('5856782887', 'Salix tweedyi (Bebb ex Rose) C.R. Ball');
insert into Laboratorio (CodigoLab, Nombre) values ('2803500183', 'Poa macrocalyx Trautv. & C.A. Mey.');
insert into Laboratorio (CodigoLab, Nombre) values ('4919356099', 'Parmotrema praesorediosum (Nyl.) Hale');
insert into Laboratorio (CodigoLab, Nombre) values ('4800386276', 'Erythroxylum novogranatense (Morris) Hieron. var. novogranatense');
insert into Laboratorio (CodigoLab, Nombre) values ('3054637689', 'Eriogonum pusillum Torr. & A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('3475215608', 'Tamonea Aubl.');
insert into Laboratorio (CodigoLab, Nombre) values ('7567673657', 'Erigeron parishii A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('3515877428', 'Isoetes tenella Léman');
insert into Laboratorio (CodigoLab, Nombre) values ('1913902668', 'Myrsine sandwicensis A. DC.');
insert into Laboratorio (CodigoLab, Nombre) values ('8333372031', 'Fothergilla major (Sims) Lodd.');
insert into Laboratorio (CodigoLab, Nombre) values ('3082288928', 'Peperomia portoricensis Urb.');
insert into Laboratorio (CodigoLab, Nombre) values ('4513970316', 'Arnica chamissonis Less.');
insert into Laboratorio (CodigoLab, Nombre) values ('0137560273', 'Passiflora foetida L. var. isthmia Killip');
insert into Laboratorio (CodigoLab, Nombre) values ('8788517527', 'Leucophyllum minus A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('3062719796', 'Croton megalobotrys Müll. Arg.');
insert into Laboratorio (CodigoLab, Nombre) values ('2801353817', 'Vriesea Lindl.');
insert into Laboratorio (CodigoLab, Nombre) values ('0016056345', 'Keckiella rothrockii (A. Gray) Straw ssp. rothrockii');
insert into Laboratorio (CodigoLab, Nombre) values ('8885907628', 'Xanthoparmelia tasmanica (Hook. f. & Taylor) Hale');
insert into Laboratorio (CodigoLab, Nombre) values ('4107185893', 'Isoetes lacustris L.');
insert into Laboratorio (CodigoLab, Nombre) values ('9721900702', 'Asplenium polyodon G. Forst.');
insert into Laboratorio (CodigoLab, Nombre) values ('3042074323', 'Brodiaea coronaria (Salisb.) Engl. ssp. coronaria');
insert into Laboratorio (CodigoLab, Nombre) values ('8174598138', 'Euphorbia ×gayeri Boros & Soó ex Soó');
insert into Laboratorio (CodigoLab, Nombre) values ('8828447931', 'Angelica dawsonii S. Watson');
insert into Laboratorio (CodigoLab, Nombre) values ('7521878485', 'Encelia resinifera C. Clark ssp. tenuifolia C. Clark');
insert into Laboratorio (CodigoLab, Nombre) values ('4177090905', 'Engelmannia peristenia (Raf.) Goodman & C.A. Lawson');
insert into Laboratorio (CodigoLab, Nombre) values ('6021914511', 'Lupinus caudatus Kellogg ssp. cutleri (Eastw.) Hess & D. Dunn');
insert into Laboratorio (CodigoLab, Nombre) values ('6455426029', 'Castilleja cusickii Greenm.');
insert into Laboratorio (CodigoLab, Nombre) values ('5626664785', 'Nymphaea L.');
insert into Laboratorio (CodigoLab, Nombre) values ('0308424581', 'Pellaea wrightiana Hook.');
insert into Laboratorio (CodigoLab, Nombre) values ('3567395602', 'Aristida purpurea Nutt. var. fendleriana (Steud.) Vasey');
insert into Laboratorio (CodigoLab, Nombre) values ('0412216582', 'Corylus ferox Wall. var. ferox');
insert into Laboratorio (CodigoLab, Nombre) values ('6388977669', 'Sphagnum subobesum Warnst.');
insert into Laboratorio (CodigoLab, Nombre) values ('7872355221', 'Crataegus nuda Sarg.');
insert into Laboratorio (CodigoLab, Nombre) values ('3375686609', 'Caesalpinia portoricensis (Britton & P. Wilson) Alain');
insert into Laboratorio (CodigoLab, Nombre) values ('1046141635', 'Claytonia gypsophiloides Fisch. & C.A. Mey.');
insert into Laboratorio (CodigoLab, Nombre) values ('2051110336', 'Ehretia anacua (Terán & Berl.) I.M. Johnst.');
insert into Laboratorio (CodigoLab, Nombre) values ('6636564806', 'Poa arctica R. Br. ssp. grayana (Vasey) Á. Löve & D. Löve & Kapoor');
insert into Laboratorio (CodigoLab, Nombre) values ('4515829874', 'Agarista D. Don ex G. Don');
insert into Laboratorio (CodigoLab, Nombre) values ('4747045031', 'Ivesia lycopodioides A. Gray ssp. scandularis (Rydb.) D.D. Keck');
insert into Laboratorio (CodigoLab, Nombre) values ('7357961486', 'Polygonatum pubescens (Willd.) Pursh');
insert into Laboratorio (CodigoLab, Nombre) values ('7464964608', 'Arenaria congesta Nutt. var. subcongesta (S. Watson) S. Watson');
insert into Laboratorio (CodigoLab, Nombre) values ('8515286912', 'Hyphaene thebaica (L.) Mart.');
insert into Laboratorio (CodigoLab, Nombre) values ('3487989379', 'Ferocactus cylindraceus (Engelm.) Orcutt var. cylindraceus');
insert into Laboratorio (CodigoLab, Nombre) values ('2333892374', 'Brodiaea terrestris Kellogg ssp. terrestris');
insert into Laboratorio (CodigoLab, Nombre) values ('7422994045', 'Cladonia rei Schaerer');
insert into Laboratorio (CodigoLab, Nombre) values ('1530269970', 'Isoetes howellii Engelm.');
insert into Laboratorio (CodigoLab, Nombre) values ('0903028638', 'Pinus mugo Turra');
insert into Laboratorio (CodigoLab, Nombre) values ('2863240781', 'Delphinium alpestre Rydb.');
insert into Laboratorio (CodigoLab, Nombre) values ('3252116618', 'Browallia americana L.');
insert into Laboratorio (CodigoLab, Nombre) values ('8002609603', 'Eriogonum visheri A. Nelson');
insert into Laboratorio (CodigoLab, Nombre) values ('0036751545', 'Bryum longisetum Bland. ex Schwägr. var. longisetum');
insert into Laboratorio (CodigoLab, Nombre) values ('1917560184', 'Coryphantha robustispina (Schott ex Engelm.) Britton & Rose ssp. uncinata (L.D. Benson) N.P. Taylor');
insert into Laboratorio (CodigoLab, Nombre) values ('8266384479', 'Weinmannia affinis A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('1962436837', 'Elatine chilensis A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('7103766347', 'Physostegia digitalis Small');
insert into Laboratorio (CodigoLab, Nombre) values ('1252809417', 'Passiflora multiflora L.');
insert into Laboratorio (CodigoLab, Nombre) values ('7818898786', 'Aliciella latifolia (S. Watson) J.M. Porter ssp. imperialis (S.L. Welsh) J.M. Porter');
insert into Laboratorio (CodigoLab, Nombre) values ('9212639860', 'Scleria pauciflora Muhl. ex Willd.');
insert into Laboratorio (CodigoLab, Nombre) values ('6293937880', 'Hymenocallis duvalensis Traub');
insert into Laboratorio (CodigoLab, Nombre) values ('9694251605', 'Brighamia insignis A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('8330728153', 'Aristolochia erecta L.');
insert into Laboratorio (CodigoLab, Nombre) values ('5628343935', 'Boerhavia megaptera Standl.');
insert into Laboratorio (CodigoLab, Nombre) values ('0998637246', 'Astragalus parryi A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('4657726749', 'Mentzelia albicaulis (Hook.) Torr. & A. Gray');
insert into Laboratorio (CodigoLab, Nombre) values ('0452380758', 'Nemacladus rubescens Greene var. rubescens');
insert into Laboratorio (CodigoLab, Nombre) values ('1545900590', 'Epiphyllum oxypetalum (DC.) Haw.');
insert into Laboratorio (CodigoLab, Nombre) values ('7883908634', 'Atriplex lentiformis (Torr.) S. Watson');
insert into Laboratorio (CodigoLab, Nombre) values ('0419998071', 'Anulocaulis eriosolenus (A. Gray) Standl.');

