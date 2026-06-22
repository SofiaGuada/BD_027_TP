Use BD_TPI_27


-- promedio de cada contenido
GO
CREATE FUNCTION FN_PromedioCalificacion
(
    @IdContenido BIGINT
)
RETURNS DECIMAL(5,2)
AS
BEGIN

    DECLARE @Promedio DECIMAL(5,2);

    SELECT @Promedio = AVG(CAST(Puntaje AS DECIMAL(5,2)))
    FROM Calificacion
    WHERE IdContenido = @IdContenido;

    RETURN ISNULL(@Promedio, 0);

END;
GO

SELECT dbo.FN_PromedioCalificacion(5) AS Promedio;

SELECT
    Titulo,
    dbo.FN_PromedioCalificacion(IdContenido) AS Promedio
FROM Contenido;