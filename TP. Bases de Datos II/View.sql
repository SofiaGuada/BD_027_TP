Use BD_TPI_27
-- lo que el Usuario necesita ver

-- CONTENIDO

CREATE VIEW VW_Contenido As
SELECT
  C.Titulo,
  C.Descripcion,
  C.Duracion,
  T.Nombre AS 'Tipo Contenido',
  G.Nombre AS 'Genero',
  P.Nombre AS 'Productora'
FROM Contenido C
INNER JOIN TipoContenido T ON T.IdTipoContenido = C.IdTipoContenido
INNER JOIN Genero G ON C.IdGenero = G.IdGenero
INNER JOIN Productora P ON C.IdProductora = P.IdProductora
WHERE C.Activo = 1;

SELECT *FROM VW_Contenido

-- comentario de contenido de los usuarios de forma desc para que aparescan los mas nuevos

CREATE VIEW VW_ComentariosContenido AS
SELECT
    C.Titulo,
    U.NombreUsuario,
    CO.Texto,
    CO.Fecha
FROM Comentario CO
INNER JOIN Usuarios U ON CO.IdUsuario = U.IdUsuario
INNER JOIN Contenido C ON CO.IdContenido = C.IdContenido

SELECT * FROM VW_ComentariosContenido
ORDER BY Fecha DESC;


-- Actores y contenido

CREATE VIEW VW_ActoresContenido
AS
SELECT
    A.Nombre + ' ' + A.Apellido AS 'Actor',
    C.Titulo
FROM ContenidoActor CA
INNER JOIN Actores A ON CA.IdActor = A.IdActor
INNER JOIN Contenido C ON CA.IdContenido = C.IdContenido

SELECT *FROM VW_ActoresContenido

--HISTORIAL DE VISUALIZACION
  
CREATE VIEW VW_HistorialVisualizacion
AS
SELECT
    U.NombreUsuario,
    C.Titulo,
    V.Fecha
FROM Visualizacion V
INNER JOIN Usuarios U ON V.IdUsuario = U.IdUsuario
INNER JOIN Contenido C ON V.IdContenido = C.IdContenido

SELECT *FROM VW_HistorialVisualizacion order by Fecha DESC

Create View VW_ContenidoProductora As
Select 
    C.IdContenido,
    C.Titulo,
    C.FechaLanzamiento,
    P.Nombre As Productora
From Contenido C
Inner Join Productora P On C.IdProductora = P.IdProductora

SELECT * FROM VistaContenidoProductora
