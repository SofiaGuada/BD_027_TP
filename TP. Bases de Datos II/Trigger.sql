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

