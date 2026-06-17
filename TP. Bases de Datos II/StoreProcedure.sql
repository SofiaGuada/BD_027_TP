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
GO
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

-- Creacion de Playlist

CREATE PROCEDURE SP_CrearPlaylist
    @IdUsuario BIGINT,
    @Nombre VARCHAR(100)
AS
BEGIN
    IF EXISTS(
        SELECT 1
        FROM Playlist
        WHERE IdUsuario = @IdUsuario
          AND Nombre = @Nombre
    )
    BEGIN
        RAISERROR('La playlist ya existe para este usuario.',16,1);
        RETURN;
    END
    INSERT INTO Playlist(IdUsuario, Nombre)
    VALUES(@IdUsuario, @Nombre);
    PRINT 'Playlist creada correctamente';
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
   
-- Playlist del usuario 10
EXEC SP_CrearPlaylist 10, 'Mis Favoritas';

