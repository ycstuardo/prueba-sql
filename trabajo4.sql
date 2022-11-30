-- crear la tabla
CREATE DATABASE desafio_yonathan_cordero549;
\c desafio_yonathan_cordero549;
SELECT * FROM pelicula;
SELECT * FROM tag;
SELECT * FROM pelicula_tag;

-- crear la tabla
-- 1. Crea el modelo (revisa bien cuál es el tipo de relación antes de crearlo), respeta las
-- claves primarias, foráneas y tipos de datos. (1 punto)
CREATE TABLE pelicula(
  id SERIAL PRIMARY key,
  nombre VARCHAR(255) NOT NULL,
  anno INTEGER NOT NULL
);

CREATE TABLE tag(
  id SERIAL primary key,
  tag VARCHAR(32) NOT NULL
);


CREATE TABLE pelicula_tag (
  pelicula_id INT,
  tag_id INT,
  PRIMARY KEY (pelicula_id, tag_id),
  CONSTRAINT fk_pelicula FOREIGN KEY(pelicula_id) REFERENCES pelicula(id),
  CONSTRAINT fk_tag FOREIGN KEY(tag_id) REFERENCES tag(id)
);

-- 2. Inserta 5 películas y 5 tags, la primera película tiene que tener 3 tags asociados, la
-- segunda película debe tener dos tags asociados. (1 punto)
INSERT INTO pelicula(nombre, anno) VALUES 
('club de la pelea', 1999),
('rescatando al soldado ryan', 1998),
('supercool', 1993),
('origen',2022),
('rec', 2006);


INSERT INTO tag(tag) VALUES 
('accion'),
('drama'),
('comedia'),
('suspenso'),
('terror');


INSERT INTO pelicula_tag(pelicula_id, tag_id) VALUES 
(1, 1),
(1, 3),
(1, 5),
(2, 4),
(2, 5);


-- 3. Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe
-- mostrar 0. (1 punto)
SELECT
    T.ID,
    T.TAG,
    COUNT(PT.pelicula_id)
FROM TAG T
    LEFT JOIN PELICULA_TAG PT
    ON T.ID = NULLIF(PT.TAG_ID, 0)
GROUP BY T.ID
ORDER BY T.ID;


-- 4. Crea las tablas respetando los nombres, tipos, claves primarias y foráneas y tipos de
-- datos. (1 punto)

CREATE TABLE preguntas(
  id SERIAL PRIMARY key,
  pregunta VARCHAR(255) NOT NULL,
  respuesta_correcta varchar
);


CREATE TABLE usuarios(
  id SERIAL PRIMARY key,
  nombre VARCHAR(255) NOT NULL,
  edad integer
);

CREATE TABLE respuestas(
  id SERIAL PRIMARY key,
  respuesta VARCHAR(255),
  pregunta_id integer,
  usuario_id integer,
  CONSTRAINT fk_pregunta FOREIGN KEY(pregunta_id) REFERENCES preguntas(id),
  CONSTRAINT fk_usuario FOREIGN KEY(usuario_id) REFERENCES usuarios(id)
);
SELECT * FROM usuarios;
SELECT * FROM preguntas;
SELECT * FROM respuestas;

-- 5. Agrega datos, 5 usuarios y 5 preguntas, la primera pregunta debe estar contestada
-- dos veces correctamente por distintos usuarios, la pregunta 2 debe estar contestada
-- correctamente sólo por un usuario, y las otras 2 respuestas deben estar incorrectas.
-- (1 punto)
INSERT INTO usuarios(nombre, edad) VALUES 
('Elena', 38),
('Javier', 26),
('Anais', 21),
('Fernanda', 23),
('Yonathan', 39);

INSERT INTO preguntas(pregunta, respuesta_correcta) VALUES 
('¿Quien es openhaimer?', 'padre de la bomba atomica'),
('¿Quien es cocinero de luffy?', 'sanji'),
('¿cuantos pares son tres moscas?', 'uno'),
('¿padre de la mecanica cuantica?', 'plank'),
('¿causus bellis de la primera guerra mundial?', 'muerte de franz ferdinand');


INSERT INTO respuestas(respuesta, usuario_id, pregunta_id) VALUES 
('padre de la bomba atomica', 1, 1),
('padre de la bomba atomica', 3, 1),
('sanji', 2, 2),
('fritz haber', 5, 2),
('gavrilo princip', 4, 2);


-- 6. Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la
-- pregunta). (1 punto)
SELECT
    u.nombre,
    COUNT(p.respuesta_correcta) as cantidad_respuesta
FROM respuestas R
LEFT JOIN usuarios U 
    ON R.usuario_id = U.id
LEFT JOIN preguntas P 
    ON P.respuesta_correcta = R.respuesta
GROUP BY 
    R.usuario_id,
    U.nombre;

-- 7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios tuvieron la
-- respuesta correcta. (1 punto)

SELECT
    p.pregunta as Pregunta,
    COUNT(P.pregunta) as CANTIDAD_USUARIO_RESPUESTA_CORRECTA
FROM respuestas R
JOIN preguntas P 
    ON P.respuesta_correcta = R.respuesta
GROUP BY 
    P.pregunta;

-- 8. Implementa borrado en cascada de las respuestas al borrar un usuario y borrar el
-- primer usuario para probar la implementación. (1 punto)



ALTER TABLE respuestas 
 ADD FOREIGN KEY (usuario_id) 
 REFERENCES usuarios(id) 
ON DELETE CASCADE;
DELETE FROM usuarios WHERE id= 1; 

-- 9. Crea una restricción que impida insertar usuarios menores de 18 años en la base de
-- datos. (1 punto)
ALTER TABLE usuarios ADD CHECK (edad > 18); 

-- 10. Altera la tabla existente de usuarios agregando el campo email con la restricción de
-- único. (1 punto)
ALTER TABLE usuarios ADD email VARCHAR(50) UNIQUE;


-- Requerimientos
-- Dado el siguiente modelo:
-- 1. Crea el modelo (revisa bien cuál es el tipo de relación antes de crearlo), respeta las
-- claves primarias, foráneas y tipos de datos. (1 punto)
-- _ 1
-- www.desafiolatam.com
-- 2. Inserta 5 películas y 5 tags, la primera película tiene que tener 3 tags asociados, la
-- segunda película debe tener dos tags asociados. (1 punto)
-- 3. Cuenta la cantidad de tags que tiene cada película. Si una película no tiene tags debe
-- mostrar 0. (1 punto)
-- Dado el siguiente modelo:
-- 4. Crea las tablas respetando los nombres, tipos, claves primarias y foráneas y tipos de
-- datos. (1 punto)
-- 5. Agrega datos, 5 usuarios y 5 preguntas, la primera pregunta debe estar contestada
-- dos veces correctamente por distintos usuarios, la pregunta 2 debe estar contestada
-- correctamente sólo por un usuario, y las otras 2 respuestas deben estar incorrectas.
-- (1 punto)
-- a. Contestada correctamente significa que la respuesta indicada en la tabla
-- respuestas es exactamente igual al texto indicado en la tabla de preguntas.
-- 6. Cuenta la cantidad de respuestas correctas totales por usuario (independiente de la
-- pregunta). (1 punto)
-- 7. Por cada pregunta, en la tabla preguntas, cuenta cuántos usuarios tuvieron la
-- respuesta correcta. (1 punto)
-- 8. Implementa borrado en cascada de las respuestas al borrar un usuario y borrar el
-- primer usuario para probar la implementación. (1 punto)
-- 9. Crea una restricción que impida insertar usuarios menores de 18 años en la base de
-- datos. (1 punto)
-- 10. Altera la tabla existente de usuarios agregando el campo email con la restricción de
-- único. (1 punto)