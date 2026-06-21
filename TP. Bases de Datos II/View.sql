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

SELECT * FROM VW_UsuariosActivos
ORDER BY FechaVencimiento DESC;

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

