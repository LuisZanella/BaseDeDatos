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
AS @NameEmpresa NOT LIKE '[^A-Za-z./]%';
	CREATE TYPE dbo.NombreLaboratorio_type FROM [NVARCHAR](200) NOT NULL
GO

CREATE DEFAULT dbo.DF_NombreLaboratorio
	AS 'Sin Registro de Nombre'
GO
EXEC sys.sp_unbindrule @objname=N'[dbo].[NombreLaboratorio_type]'
GO
EXEC sys.sp_unbindefault @objname=N'[dbo].[NombreLaboratorio_type]'
GO
DROP RULE dbo.NombreLaboratorio_rule
EXEC sys.sp_bindefault @defname = N'[dbo].[DF_NombreLaboratorio]',
	@objname = N'[dbo].[NombreLaboratorio_type]',@futureonly='futureonly'
GO

EXEC sys.sp_bindrule @rulename = N'[dbo].[NombreLaboratorio_rule]',
	@objname = N'[dbo].[NombreLaboratorio_type]' , @futureonly = 'futureonly'
GO
--EXEC sys.sp_unbindrule @objname=N'[dbo].[NombreLaboratorio_type]'
--GO
--EXEC sys.sp_unbindefault @objname=N'[dbo].[NombreLaboratorio_type]'
--GO
--DROP RULE dbo.NombreLaboratorio_rule


--CREACION DE LA TABLA PERSONA
CREATE TABLE Persona(
	CodigoPersona BIGINT PRIMARY KEY IDENTITY, 	
	Nombre Nombre_type NOT NULL,
	ApellidoP Nombre_type NOT NULL,
	ApellidoM Nombre_type NOT NULL,
	NombreCompleto AS(Nombre + ' ' + ApellidoP+ ' ' + ApellidoM),
	CONSTRAINT UC_Persona UNIQUE (NombreCompleto)
)
GO

--CREACION DE LA TABLA MEDICO
CREATE TABLE Medico(
	CodigoMedico BIGINT PRIMARY KEY IDENTITY,
	CodigoPersona BIGINT NOT NULL FOREIGN KEY REFERENCES Persona(CodigoPersona) ON DELETE CASCADE ON UPDATE CASCADE,
	Consultorio BIGINT NOT NULL,
	CedulaProfesional VARCHAR (30) NOT NULL,
	RegistroSalubridad VARCHAR(30) NOT NULL,
	Estatus Estatus_type,
	CONSTRAINT UC_Cedula UNIQUE (CedulaProfesional)
)
GO
--CREACION DE LA TABLA Especialidad
CREATE TABLE Especialidad(
	CodigoEspecialidad BIGINT PRIMARY KEY IDENTITY,
	Especialidad VARCHAR (100) NOT NULL
)
GO
--CREACION DE LA TABLA EspecialidadMedico
CREATE TABLE EspecialidadMedico(
	CodigoEspecialidadMedico BIGINT PRIMARY KEY IDENTITY,
	CodigoMedico BIGINT NOT NULL FOREIGN KEY REFERENCES Medico(CodigoMedico) ON DELETE CASCADE ON UPDATE CASCADE,
	CodigoEspecialidad BIGINT NOT NULL FOREIGN KEY REFERENCES Especialidad(CodigoEspecialidad) ON DELETE CASCADE ON UPDATE CASCADE
)
GO

--CREACION DE LA TABLA PACIENTE
CREATE TABLE Paciente(
	CodigoPaciente BIGINT PRIMARY KEY IDENTITY,
	CodigoPersona BIGINT NOT NULL FOREIGN KEY REFERENCES Persona(CodigoPersona) ON DELETE CASCADE ON UPDATE CASCADE,
	Sexo Genero_type NOT NULL,
	FechaNacimiento DATE NOT NULL,
	Prioridad Prioridad_type NOT NULL
)
--CREACION DE LA TABLA VISITAS
CREATE TABLE Visita(
	CodigoVisita BIGINT PRIMARY KEY IDENTITY,
	Descripcion VARCHAR(1000) DEFAULT 'Sin Descripción'
)


--CREACION DE LA TABLA CITAS
CREATE TABLE Cita(
	CodigoCita BIGINT PRIMARY KEY IDENTITY,
	CodigoPaciente BIGINT NOT NULL FOREIGN KEY REFERENCES Paciente(CodigoPaciente) ON DELETE CASCADE ON UPDATE CASCADE,
	CodigoMedico BIGINT NOT NULL FOREIGN KEY REFERENCES Medico(CodigoMedico),
	CodigoVisita BIGINT NOT NULL FOREIGN KEY REFERENCES Visita(CodigoVisita) ON DELETE CASCADE ON UPDATE CASCADE,
	FechaInicio DATE NOT NULL,
	FechaFinal DATETIME NULL,
	Costo FLOAT NOT NULL,
	Hora Horario_type NOT NULL,
	Estatus Estatus_type
)
--CREACION DE LA TABLA REGISTROS
CREATE TABLE Registro(
		CodigoRegistro BIGINT PRIMARY KEY IDENTITY,
		CodigoPaciente BIGINT NOT NULL FOREIGN KEY REFERENCES Paciente(CodigoPaciente) ON DELETE CASCADE ON UPDATE CASCADE,
		PeriodoIngesta VARCHAR(30),
		Problema VARCHAR(1000),
		GravedadProblema GravedadProblema_type
)
--CREACION DE LA TABLA LABORATORIOS
CREATE TABLE Laboratorio(
		CodigoLaboratorio BIGINT PRIMARY KEY IDENTITY,
		CodigoLab VARCHAR(200) NOT NULL,
		Nombre NombreLaboratorio_type,
		Estatus Estatus_type,
		CONSTRAINT UC_LaboratiorioVerificacion UNIQUE (CodigoLab,Nombre)
)

--CREACION DE LA TABLA PRODUCTOS
CREATE TABLE Producto(
		CodigoProducto BIGINT PRIMARY KEY IDENTITY,
		CodigoLaboratorio BIGINT NOT NULL FOREIGN KEY REFERENCES Laboratorio(CodigoLaboratorio) ON DELETE CASCADE ON UPDATE CASCADE,
		Nombre VARCHAR(1000) NOT NULL,
		Cantidad CantidadProducto_type NOT NULL,
		Descripcion VARCHAR(1000) DEFAULT 'Sin Descripción',
		Categoria Varchar(100)
)

--CREACION DE LA TABLA RELACION PRODUCTO MEDICO
CREATE TABLE MedicoProducto(
		CodigoMedicoProducto BIGINT PRIMARY KEY IDENTITY,
		CodigoMedico BIGINT NOT NULL FOREIGN KEY REFERENCES Medico(CodigoMedico) ON DELETE CASCADE ON UPDATE CASCADE,
		CodigoProducto BIGINT NOT NULL FOREIGN KEY REFERENCES Producto(CodigoProducto) ON DELETE CASCADE ON UPDATE CASCADE,
		FechaIngreso DATE NOT NULL
)
--CREACION DE LA TABLA RELACION REGISTRO PRODUCTO
CREATE TABLE RegistroProducto(
		CodigoRegistroProducto BIGINT PRIMARY KEY IDENTITY,
		CodigoRegistro BIGINT NOT NULL FOREIGN KEY REFERENCES Registro(CodigoRegistro) ON DELETE CASCADE ON UPDATE CASCADE,
		CodigoProducto BIGINT NOT NULL FOREIGN KEY REFERENCES Producto(CodigoProducto) ON DELETE CASCADE ON UPDATE CASCADE,
		CantidadIngresada VARCHAR(1000) NOT NULL
)
--CREACION DE LA TABLA HistorialMedico por Paciente
CREATE TABLE HistorialMedico(
		CodigoHistorialMedico BIGINT PRIMARY KEY IDENTITY,
		CodigoPaciente BIGINT NOT NULL FOREIGN KEY REFERENCES Paciente(CodigoPaciente) ON DELETE CASCADE ON UPDATE CASCADE,
		Edad INT NULL,
		Estatura FLOAT NOT NULL,
		Ocupacion VARCHAR (120) NOT NULL,
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
SELECT * FROM Cita
UPDATE Cita SET Estatus = 0 WHERE CodigoCita = 1;

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
insert into HistorialMedico (Estatura, Ocupacion, PadecimientoActual, IngestaMedicamento, AntecedenteFamiliar, AntecedentePersonal, CodigoPaciente) values ( 1.75, 'Quality Control Specialist', 'Toxic effect of venom of caterpillars, accidental, init', 'Toxic effect of venom of caterpillars, accidental (unintentional), initial encounter', 'Phlebitis and thrombophlebitis of femoral vein (deep) (superficial)', 'Femoral vein phlebitis', 1);
SELECT * FROM HistorialMedico WHERE CodigoPaciente = 1;
SELECT * FROM Paciente WHERE CodigoPaciente= 1;

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
	DECLARE @tipo INT = (SELECT TOP 1(CodigoEspecialidad) FROM Especialidad WHERE Especialidad =  @especialidad OR 
	Especialidad LIKE '%'+@especialidad+'%' OR Especialidad LIKE @especialidad+'%' OR Especialidad LIKE '%'+@especialidad)   
	INSERT INTO Medico(CodigoPersona, Consultorio, CedulaProfesional, RegistroSalubridad)
				VALUES(@id, @consultorio, @cedula, @salubridad)
	DECLARE @idMedico INT = (SELECT MAX(CodigoMedico) FROM Medico)
	INSERT INTO EspecialidadMedico (CodigoEspecialidad, CodigoMedico) VALUES (@tipo,@idMedico)
GO
SELECT * FROM Medico
EXEC sp_InsertMedico 'Juan','Zanella', 'Enriquez', 'CIRU', 3, 'AJDSHAS123', 'ASJIWHIHW13123'
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
SELECT * FROM Persona
SELECT * FROM Paciente
EXEC sp_InsertPersona 'Pedro','Corona', 'Ramirez','M', '2015-04-02'

/*COMO EJECUTAR ESTE*/ 
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
EXEC sp_PacientesAtendidosPorMedico 'Marco'

CREATE PROCEDURE sp_CitasFecha
@fecha DATE
AS
	SELECT SUM (CodigoCita) AS 'Cantidad de citas'
	FROM Cita
	WHERE FechaInicio = @fecha
GO

EXEC sp_CitasFecha '2010-10-26'
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
SELECT * FROM MedicoProducto
EXEC sp_InsertMedicoProducto 2,5,'2013-02-12'
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
SELECT * FROM RegistroProducto
EXEC sp_InsertRegistroProducto 2,5,'ingerir 4 pastillas'
--------------------------------
--Trae todos los medicos que su especialidad es cirugia o medicina excluyendo los medicos de cuyo consultorio es mayor a 60 y han tenido más de dos pasientes

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
		WHERE M.Estatus = 1 AND E.Especialidad LIKE 'CIRUGÍA%'
		GROUP BY P.NombreCompleto, E.Especialidad
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
		WHERE M.Estatus = 1 AND E.Especialidad LIKE 'MEDICINA%'
		GROUP BY P.NombreCompleto, E.Especialidad
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
		WHERE M.Estatus = 1 AND M.Consultorio >60
		GROUP BY P.NombreCompleto, E.Especialidad
		)j
GO

SELECT * FROM view_MedicosSinConsultasDia
--- VISTA QUE MUESTRA TODOS LOS LABORATORIOS QUE HAN VENDIDO 1 sola vez Y MAS DE 5 veces QUITANDO LOS QUE SU ESTATUS ES 0

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
		GROUP BY L.Nombre
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
		GROUP BY L.Nombre
		HAVING COUNT(MP.CodigoMedicoProducto)>150
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
		GROUP BY L.Nombre
		)j
GO

SELECT * FROM view_LaboratoriosMasVENDEN

CREATE VIEW EspecialidadesPorMedico AS
(
SELECT CONCAT(P.Nombre, P.ApellidoP, P.ApellidoM) AS MEDICO, COUNT(EP.Especialidad) Especialidades
FROM EspecialidadMedico E INNER JOIN Medico M
ON E.CodigoMedico = M.CodigoMedico INNER JOIN Persona P
ON M.CodigoPersona = P.CodigoPersona INNER JOIN Especialidad EP
ON E.CodigoEspecialidad = EP.CodigoEspecialidad
GROUP BY CONCAT(P.Nombre, P.ApellidoP, P.ApellidoM), EP.Especialidad    
HAVING COUNT(EP.Especialidad) > 2
)
GO
SELECT * FROM EspecialidadesPorMedico
CREATE VIEW GananciaPorMedicoAlDia AS
(
	SELECT SUM(Costo) AS 'Dinero Total Ganado', CONCAT (P.Nombre,'  ' ,P.ApellidoM,'  ', P.ApellidoP) AS 'Nombre del medico'
	FROM Cita C INNER JOIN Medico M
	ON C.CodigoMedico = M.CodigoMedico
	INNER JOIN Persona P
	ON M.CodigoPersona = P.CodigoPersona
	WHERE FechaInicio = GETDATE()
	GROUP BY P.Nombre, P.ApellidoM,P.ApellidoP
)
GO
SELECT * FROM GananciaPorMedicoAlDia
CREATE VIEW ProductosPorLaboratorio AS
(
    SELECT L.CodigoLab AS CODIGO_LABORATORIO, L.Nombre AS NOMBRE_LABORATORIO, P.Nombre AS NOMBRE_MEDICAMENTO, P.Cantidad AS CANTIDAD_MEDICAMENTO, COUNT (P.CodigoLaboratorio) Productos
    FROM Laboratorio L INNER JOIN Producto P
    ON L.CodigoLaboratorio = P.CodigoLaboratorio
    GROUP BY L.CodigoLab ,L.Nombre, P.Nombre, P.Cantidad
    HAVING COUNT(L.CodigoLaboratorio) > 0
)
GO
SELECT * FROM ProductosPorLaboratorio
CREATE VIEW PadecimientodePaciente AS
(
    SELECT Pe.NombreCompleto AS NOMBRE_PACIENTE, P.Sexo AS SEXO, H.Edad AS EDAD, H.PadecimientoActual AS PADECIMIENTO
    FROM HistorialMedico H INNER JOIN Paciente P
    ON H.CodigoPaciente = P.CodigoPaciente INNER JOIN Persona Pe
    ON P.CodigoPersona = Pe.CodigoPersona
)
GO
SELECT * FROM PadecimientodePaciente
CREATE VIEW MedicamentoRecetadoPorPaciente AS
(
    SELECT PE.NombreCompleto, PR.Nombre AS NOMBRE_PRODUCTO
    FROM RegistroProducto RP INNER JOIN Registro R
    ON RP.CodigoRegistro = R.CodigoRegistro INNER JOIN Paciente PA
    ON R.CodigoPaciente = PA.CodigoPaciente INNER JOIN Persona PE
    ON PA.CodigoPersona = PE.CodigoPersona INNER JOIN Producto PR
    ON RP.CodigoProducto = PR.CodigoProducto
    GROUP BY PA.CodigoPaciente, PE.NombreCompleto, PR.Nombre
)
GO
SELECT * FROM MedicamentoRecetadoPorPaciente