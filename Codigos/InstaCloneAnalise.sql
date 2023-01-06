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


/*A brand wants to know which hashtags to use in a post
What are the top 5 most commonly used hashtags?*/
SELECT nomeTag, COUNT(nomeTag) AS total FROM tags
    JOIN tagsFotos ON tags.id = tagsFotos.tagId
    GROUP BY tags.id ORDER BY total DESC;

