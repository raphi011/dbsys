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
WITH sum_incomes as (
	select svnr, sum(honorar) as sum_honorar
	from lohnzettel 
	group by svnr, honorar
	), max_min_incomes as (
	select max(sum_honorar) as maxi, min(sum_honorar) as mini
	from sum_incomes
	)
select p.name, si.sum_honorar
from max_min_incomes mm, sum_incomes si
join person p
on si.svnr = p.svnr
where	si.sum_honorar = mm.maxi or 
	si.sum_honorar = mm.mini
