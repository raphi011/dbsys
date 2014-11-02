-- test salary constraint
insert into dbs.mitarbeiter (person, abteilung, krankenhaus, gehalt) values (1, 'abteilung 1', 10, 0);  -- check constraint violation

-- test bonus 
insert into dbs.krankheit values ('test krankheit', 0); -- check constraint violation

-- check dates
insert into dbs.akteneintrag (person, krankenhaus, krankheit, von, bis) values (1, '10', 'krankheit 1', current_timestamp, current_timestamp - interval '2 hour'); -- check constraint violation

-- test hospital chef
update dbs.krankenhaus set geleitet_von = 3 where id = 10; -- trigger error 

-- test department chef
update dbs.abteilung set koordiniert_von = 3 where name = 'abteilung 1' and krankenhaus = 10; -- trigger error

-- test check treated
insert into dbs.behandelt (arzt, krankheit, patient, dauer) values (1, 'krankheit 1', 10, 2); -- trigger error

-- test f calc salary
select f_calc_salary(4, 10,2014); -- should be 5010 ( 167 * 30 )
select f_calc_salary(1, 10,2014); -- should be 40 ( 40 * 2 )

-- test move healed
select p_move_healed();
select id from dbs.behandelt where id = 30; -- should not exist
select id from dbs.patient where person = 2; -- shouldn't exist either
select * from dbs.akteneintrag where person = 2; -- should exist

-- test p calc salary
select p_calc_salary(); 
select * from dbs.lohnzettel; -- all pay slips should've been generated