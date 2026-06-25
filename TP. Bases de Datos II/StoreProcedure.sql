USE BD_TPI_27
GO

/* =========================================================
   STORED PROCEDURE 1
   REPORTE PARAMETRIZADO
   Muestra contenido filtrado por país de la productora
   ========================================================= */

CREATE PROCEDURE SP_ContenidoPorPaisProductora
    @Pais VARCHAR(100)
AS
BEGIN
    SELECT 
        C.Titulo,
        C.Descripcion,
        P.Nombre AS Productora,
        P.Pais,
        G.Nombre AS Genero,
        T.Nombre AS TipoContenido
    FROM Contenido C
    INNER JOIN Productora P ON C.IdProductora = P.IdProductora
    INNER JOIN Genero G ON C.IdGenero = G.IdGenero
    INNER JOIN TipoContenido T ON C.IdTipoContenido = T.IdTipoContenido
    WHERE P.Pais = @Pais
      AND C.Activo = 1
END
GO


/* =========================================================
   STORED PROCEDURE 2
   ACCIÓN EN BASE DE DATOS
   Agrega un contenido a favoritos de un usuario
   Evita duplicados
   ========================================================= */

CREATE PROCEDURE SP_AgregarFavorito
    @IdUsuario BIGINT,
    @IdContenido BIGINT
AS
BEGIN
    -- Validamos que no exista ya en favoritos
    IF NOT EXISTS (
        SELECT 1 
        FROM Favoritos 
        WHERE IdUsuario = @IdUsuario 
          AND IdContenido = @IdContenido
    )
    BEGIN
        INSERT INTO Favoritos (IdUsuario, IdContenido)
        VALUES (@IdUsuario, @IdContenido)
    END
END
GO

-- registrar suscripcion
   
CREATE PROCEDURE SP_ContratarSuscripcion
    @IdUsuario BIGINT,
    @IdSuscripcion BIGINT
AS
BEGIN
    DECLARE @Plazo INT;
    SELECT @Plazo = Plazo
    FROM Suscripcion
    WHERE IdSuscripcion = @IdSuscripcion;
    INSERT INTO SuscripcionDelUsuario
    (
        IdUsuario,
        IdSuscripcion,
        FechaInicio,
        FechaVencimiento
    )
    VALUES
    (
        @IdUsuario,
        @IdSuscripcion,
        GETDATE(),
        DATEADD(DAY, @Plazo, GETDATE())
    );
END;

--- Registrar visualizacion
GO
Create Procedure SP_RegistrarVisualizacion
    @IdUsuario bigint,
    @IdContenido bigint
As
Begin
    Insert Into Visualizacion(IdUsuario, IdContenido)
    Values(@IdUsuario, @IdContenido)
End;

-- Registrar usuario
GO
CREATE PROCEDURE SP_RegistrarNuevoUsuario
    @NombreUsuario VARCHAR(100),
    @Nombre VARCHAR(50),
    @Apellido VARCHAR(100), 
    @DNI VARCHAR(20),
    @Email VARCHAR(100),
    @Pais VARCHAR(50),
    @Contraseña VARCHAR(100)
AS
BEGIN
    BEGIN TRANSACTION;
     -- Verificar si el usuario ya existe por DNI o Email
    IF EXISTS (SELECT 1 FROM Usuarios WHERE dni = @DNI OR email = @Email)
    BEGIN
         -- Si existe
        RAISERROR('Error: Ya existe un usuario registrado con ese DNI o Email.', 16, 1);
    END  
    --  Inserción en la tabla de Usuarios
     INSERT INTO Usuarios (NombreUsuario, nombre, Apellido, dni, email, pais, Contraseña)
    VALUES (@NombreUsuario, @Nombre, @Apellido, @DNI, @Email, @Pais, @Contraseña);
    -- Si todo salió bien
     COMMIT TRANSACTION;
     PRINT 'Usuario registrado con éxito en el sistema.';  
END;




/* =========================================================
   EJEMPLOS DE EJECUCIÓN (PARA PRUEBA)
   ========================================================= */

-- Contenido por país
EXEC SP_ContenidoPorPaisProductora 'Estados Unidos';

-- Agregar favorito
EXEC SP_AgregarFavorito 1, 5;

-- Agregar Suscripcion del usuario 10
EXEC SP_ContratarSuscripcion 10,2
   
-- Agregar la visualizacion del usuario 10
Exec SP_RegistrarVisualizacion 10, 9


