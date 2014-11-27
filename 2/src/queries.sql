/* Query 1 */
WITH RECURSIVE classes(name, uebergeordnet, level) as (
	SELECT k.name, (select name from klasse where kl_id = k.uebergeordnet), 0 from klasse k where name = 'Herz'
	UNION ALL
	SELECT k.name, (select name from klasse where kl_id = k.uebergeordnet), c.level + 1
	FROM classes c, klasse k 
	WHERE k.name = c.uebergeordnet
	)
 SELECT * from classes;


/* Query 2 */
# TODO Write Query 2 here 



