USE publications;
SHOW TABLES;

#drop table Royalty_basic;
CREATE TEMPORARY TABLE Royalty_basic
SELECT sales.title_id AS Title_Id, titleauthor.au_id AS AuthorId, titles.title AS Title, ((titles.price*sales.qty*titles.royalty)/(100*(titleauthor.royaltyper/100))) AS Royalty_Book
FROM publications.sales sales
INNER JOIN publications.titles AS titles ON titles.title_id = sales.title_id
INNER JOIN publications.titleauthor AS titleauthor ON titles.title_id = titleauthor.title_id
;

CREATE TEMPORARY TABLE Royalty_2
SELECT Title_id, AuthorId, SUM(Royalty1) AS Royalty2
FROM(
SELECT title_Id, AuthorId, SUM(Royalty_Book) AS Royalty1
FROM Royalty_basic
GROUP BY AuthorId
) subq1
GROUP BY Title_id
;

SELECT AuthorId, Royalty2 + titles.advance AS Profit
FROM Royalty_2
INNER JOIN publications.titles ON Royalty_2.Title_id = titles.title_id
ORDER BY Profit DESC
LIMIT 3
;



