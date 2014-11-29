create or replace view PatAbt as 
	select arbeitet_abt_id as abt_id, arbeitet_kh_id as kh_id, count(*) as patients
	from (	select distinct m.arbeitet_abt_id, m.arbeitet_kh_id, b.patient
			from behandlung b 
			inner join patient p on p.svnr = b.patient 
			inner join mitarbeiter m on m.svnr = b.arzt 
			where 	p.geheilt = false
		) as results
		group by arbeitet_abt_id,arbeitet_kh_id;