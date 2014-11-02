create or replace function t_check_hospital_chef() returns trigger as 
$$
begin
	if ((select person  from dbs.mitarbeiter where person = new.geleitet_von and krankenhaus = new.id) is null) then
		raise exception 'krankenhaus leiter muss auch in einer der Abteilungen des Krankenhauses arbeiten';	
	end if;

	return new;
end;
$$ language plpgsql;

create trigger t_check_hospital_chef before insert or update on dbs.krankenhaus for each row execute procedure t_check_hospital_chef();

create or replace function t_check_department_chef() returns trigger as 
$$
begin
	if ((select person from dbs.mitarbeiter where person = new.koordiniert_von and krankenhaus = new.krankenhaus and abteilung = new.name) is null) then
		raise exception 'der abteilungs leiter muss auch in dieser abteilung arbeiten';	
	end if;

	return new;
end;
$$ language plpgsql;

create trigger t_check_department_chef before insert or update on dbs.abteilung for each row execute procedure t_check_department_chef();

create or replace function t_check_treated() returns trigger as 
$$
begin
	if ((select id from dbs.behandelt where patient = new.patient and krankheit = new.krankheit) is not null) then
		raise exception 'ein Patient kann nicht öfters für die selbe Krankheit behandelt werden';	
	end if;

	if ((select person from dbs.mitarbeiter m natural join dbs.spezialisiert s where m.person = new.arzt and s.krankheit = new.krankheit) is null) then
		raise exception 'dem Arzt seine Abteilung muss auf die zu behandelnde Krankheit spezialisiert sein';
	end if;

	return new;
end;
$$ language plpgsql;

create trigger t_check_treated before insert or update on dbs.behandelt for each row execute procedure t_check_treated();


--f_calc_salary
create or replace function f_calc_salary(svnr int, month int, year int) returns numeric as
$$
declare
	h numeric = 0;
begin
	if ((select person from dbs.arzt where person = svnr) is null) then
		if ((select honorar from dbs.lohnzettel where mitarbeiter = svnr and monat = month and jahr = year and honorar != 0) is null) then
			select gehalt * 167 into h from dbs.mitarbeiter where person = svnr;
		end if;
	else -- es gibt einen arzt
		SELECT COALESCE(sum(dauer * gehalt * bonus), 0) into h 
		from  dbs.behandelt as b 
		inner join dbs.krankheit as k on b.krankheit = k.name 
		inner join dbs.mitarbeiter as m on b.arzt = m.person 
		where b.arzt = svnr and b.abgerechnet = false;
	end if;

	return h;
end;
$$
language plpgsql;

-- p_move_healed 
create or replace function p_move_healed() returns void as 
$$
declare
	curs refcursor;
	row record;
begin 
	open curs for 	select p.person, m.krankenhaus, b.krankheit, b.dauer, b.id 
					from dbs.behandelt b 
					inner join dbs.mitarbeiter m on b.arzt = m.person 
					inner join dbs.patient p on b.patient = p.id
					where p.geheilt = true and (select count(*) from dbs.behandelt where patient = b.patient and abgerechnet = false) = 0;

	fetch curs into row;

	while found loop
		insert into dbs.akteneintrag (person, krankenhaus, krankheit, von, bis) values (row.person, row.krankenhaus, row.krankheit, current_timestamp - row.dauer * interval '1 hour', current_timestamp);
		delete from dbs.behandelt where id = row.id;
		fetch curs into row;
	end loop;

	delete from dbs.patient where id not in (select distinct patient from dbs.behandelt);
	close curs;
end;
$$ 
language plpgsql;

-- p_calc_salary
create or replace function p_calc_salary() returns void as
$$trigger
declare 
	mitarbeiter record;
	monat int = extract(month from current_date);
	jahr int = extract(year from current_date);
begin
	for mitarbeiter in select person from dbs.mitarbeiter loop
		begin 
			insert into dbs.lohnzettel values (mitarbeiter.person, f_calc_salary(mitarbeiter.person, monat, jahr), monat, jahr);
		exception when unique_violation then
			raise notice 'lohnzettel fuer mitarbeiter % wurde schon ausgestellt', mitarbeiter.person;
		end;	
	end loop;
	update dbs.behandelt set abgerechnet = true;
end;
$$
language plpgsql;