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