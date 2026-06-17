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


/* =========================================================
   EJEMPLOS DE EJECUCIÓN (PARA PRUEBA)
   ========================================================= */

-- Contenido por país
EXEC SP_ContenidoPorPaisProductora 'Estados Unidos';

-- Agregar favorito
EXEC SP_AgregarFavorito 1, 5;