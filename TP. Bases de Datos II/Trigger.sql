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

-- PARA USARLO 
-- DELETE FROM Contenido WHERE IdContenido = 1
-- PARA ELIMINAR UN TRIGGERS DROP TRIGGER El nombre de trigger a eliminar


-- FIN DE SUSCRIPCIÓN 

CREATE TRIGGER TR_FinSuscripcion ON SuscripcionDelUsuario
AFTER INSERT, UPDATE 
AS 
BEGIN 
    UPDATE SuscripcionDelUsuario SET Activo = 0 WHERE FechaVencimiento <= GETDATE() AND Activo = 1;

    Print 'SE ACTUALIZO CON EXITO';
END;


--evita duplicados en las calificaciones

CREATE TRIGGER TR_LimitePuntuacion
ON Calificacion
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS(
        SELECT 1
        FROM Calificacion C
        JOIN inserted i ON C.IdUsuario = i.IdUsuario AND C.IdContenido = i.IdContenido
    )
    BEGIN
    PRINT 'Ya existe una calificación para este contenido.'
    RETURN;
    END

    INSERT INTO Calificacion (IdUsuario, IdContenido, Puntaje, Fecha)
    SELECT IdUsuario,IdContenido,Puntaje,Fecha
    FROM inserted;
END;