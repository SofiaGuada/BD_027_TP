Use BD_TPI_27

-- Una baja logica para las Peliculas SOLO ELIMINA UNA FILA 

CREATE TRIGGER TR_BajaLogica_Contenido On Contenido
INSTEAD OF DELETE
AS
BEGIN
   BEGIN TRY
        BEGIN TRANSACTION 

         DECLARE @IdContenido BIGINT 
         SELECT @IdContenido = IdContenido From deleted

         UPDATE Contenido SET Activo = 0 WHERE IdContenido = @IdContenido

      COMMIT TRANSACTION
   END TRY
   BEGIN CATCH
      ROLLBACK TRANSACTION
   END CATCH
END 

USE BD_TPI_27
GO

CREATE TRIGGER TR_Favoritos_ValidarContenido
ON Favoritos
AFTER INSERT
AS
BEGIN
    IF EXISTS (
        SELECT 1
        FROM inserted i
        INNER JOIN Contenido C ON C.IdContenido = i.IdContenido
        WHERE C.Activo = 0
    )
    BEGIN
        ROLLBACK TRANSACTION;
    END
END
GO
CREATE TRIGGER TR_ValidarTemporadaContenido ON Temporada
AFTER INSERT, UPDATE
AS
BEGIN
    -- Evita interferencias con el conteo de filas afectadas
    SET NOCOUNT ON;

    -- Verifica si alguna de las filas insertadas o modificadas pertenece a una Película
    IF EXISTS (
        SELECT 1 
        FROM inserted i
        INNER JOIN Contenido c ON i.IdContenido = c.IdContenido
        INNER JOIN TipoContenido tc ON c.IdTipoContenido = tc.IdTipoContenido
        WHERE tc.nombre LIKE '%Películas%'
    )
    BEGIN
        -- Si encuentra una coincidencia, cancela la transacción y muestra el error
        RAISERROR('No está permitido asignar temporadas ni episodios a contenidos catalogados como Película.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
GO

