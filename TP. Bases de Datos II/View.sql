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

-- ADMINISTRADOR
-- SUSCRIPCIONES ACTIVAS 

CREATE VIEW VW_UsuariosActivos AS 
SELECT 
  U.IdUsuario AS 'IdUsuario',
  U.NombreUsuario,
  U.Apellido,
  U.Nombre,
  U.Email,
  US.FechaVencimiento
FROM Usuarios U 
INNER JOIN SuscripcionDelUsuario US ON US.IdUsuario = U.IdUsuario
WHERE US.Activo = 1;

-- contenido mas visto

CREATE VIEW VW_ContenidosMasVistos AS
SELECT
    C.Titulo,
    COUNT(V.IdContenido) AS CantidadVisualizaciones
FROM Visualizacion V
INNER JOIN Contenido C ON V.IdContenido = C.IdContenido
GROUP BY C.Titulo;

SELECT * FROM VW_ContenidosMasVistos

-- Permite al usuario buscar la suscripcion 
CREATE VIEW VW_MiSuscripcion AS
SELECT
    U.NombreUsuario,
    S.Nombre AS Suscripcion,
    S.Descripcion,
    S.Precio,
    SDU.FechaInicio,
    SDU.FechaVencimiento,
    CASE
        WHEN SDU.Activo = 1 THEN 'Activa'
        ELSE 'Vencida'
    END AS Estado
FROM SuscripcionDelUsuario SDU
INNER JOIN Usuarios U ON SDU.IdUsuario = U.IdUsuario
INNER JOIN Suscripcion S ON SDU.IdSuscripcion = S.IdSuscripcion;

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

-- Playlist del usuario (que contenido contiene su playlist)
  
CREATE VIEW VW_PlaylistsUsuarios
AS
SELECT
    U.NombreUsuario,
    P.Nombre AS Playlist,
    C.Titulo
FROM PlaylistContenido PC
INNER JOIN Playlist P ON PC.IdPlaylist = P.IdPlaylist
INNER JOIN Usuarios U ON P.IdUsuario = U.IdUsuario
INNER JOIN Contenido C ON PC.IdContenido = C.IdContenido


