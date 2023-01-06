/*Encontre as 5 contas mais velhas*/
SELECT * FROM usuarios ORDER BY dataCriacao LIMIT 3;


/*Encontre o dia em que a maioria dos usuarios se registraram*/
SELECT DAYNAME(dataCriacao) AS dia, COUNT(*) AS total
    FROM usuarios GROUP BY dia ORDER BY total DESC;
    
    
/*Encontre os usuarios que nunca postaram uma foto*/
SELECT usuario FROM usuarios 
    LEFT JOIN fotos ON usuarios.id = fotos.usuarioId
WHERE fotos.id IS NULL;


/*Encontre o usuario com mais curtidas em uma unica foto*/
SELECT usuario, fotos.id, fotos.imagemURL, COUNT(*) AS totalCurtidas FROM fotos
    INNER JOIN curtidas ON curtidas.fotoId = fotos.id
    INNER JOIN usuarios ON fotos.usuarioId = usuarios.id
GROUP BY fotos.id ORDER BY totalCurtidas DESC LIMIT 1;


/*Encontre quantas postagens em media os usuario fazem*/
SELECT (SELECT COUNT(*) FROM fotos) / (SELECT COUNT(*) FROM usuarios) AS postsMedia;


/*Monte um hanking a partir do numero de posts de cada usuario*/
SELECT usuarios.usuario, COUNT(fotos.imagemURL) AS nPosts FROM usuarios
    JOIN fotos ON usuarios.id = fotos.usuarioId
    GROUP BY usuarios.id ORDER BY 2 DESC;
    

/*Encontre a quantidade de usuarios que postaram algo ao menos uma vez*/
SELECT COUNT(DISTINCT(usuarios.id)) AS usuariosComPosts FROM usuarios
    JOIN fotos ON usuarios.id = fotos.usuarioId;


/*Encontre as 5 hashtags mais utilizadas pelos usuarios*/
SELECT nomeTag, COUNT(nomeTag) AS total FROM tags
    JOIN tagsFotos ON tags.id = tagsFotos.tagId
    GROUP BY tags.id ORDER BY total DESC;
    

/*Encontre os usuarios que curtiram todas as fotos do site*/
SELECT usuarios.id, usuario, COUNT(usuarios.id) As nCurtidas FROM usuarios
    JOIN curtidas ON usuarios.id = curtidas.usuarioId GROUP BY usuarios.id
    HAVING nCurtidas = (SELECT COUNT(*) FROM fotos);
    
    
/*Encontre os usuarios que nunca comentaram em nenhuma postagem*/
SELECT usuario FROM usuarios
    LEFT JOIN comentarios ON usuarios.id = comentarios.usuarioId
    WHERE comentarios.comentario IS NULL;


/*Encontre os usuarios que já comentaram em alguma postagem ao menos uma vez*/
SELECT usuario FROM usuarios
    JOIN comentarios ON usuarios.id = comentarios.usuarioId
    GROUP BY usuario;


/*Encontre a porcentagem de usuarios que já comentaram em alguma postagem e a de
usuarios que nunca comentaram*/
CREATE VIEW NuncaComentaram AS 
    SELECT usuario FROM usuarios
        LEFT JOIN comentarios ON usuarios.id = comentarios.usuarioId
        WHERE comentarios.comentario IS NULL;

CREATE VIEW JaComentaram AS
    SELECT usuario FROM usuarios
        JOIN comentarios ON usuarios.id = comentarios.usuarioId
        GROUP BY usuario;

SELECT 
	CONCAT(ROUND((NuncaComentaram.n/(SELECT COUNT(*) FROM usuarios))*100), '%') AS 'Nunca Comentaram',
	CONCAT(ROUND((Comentaram.n/(SELECT COUNT(*) FROM usuarios))*100), '%') AS 'Comentaram'
FROM(SELECT(SELECT COUNT(*) FROM NuncaComentaram) AS n) AS NuncaComentaram
JOIN(SELECT(SELECT COUNT(*) FROM JaComentaram) AS n) AS Comentaram;
