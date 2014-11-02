alter table dbs.mitarbeiter drop constraint mitarbeiter_abteilung_fkey;
alter table dbs.krankenhaus drop constraint krankenhaus_geleitet_von_fkey;

drop table dbs.akteneintrag;
drop table dbs.behandelt;
drop table dbs.zugeordnet;
drop table dbs.klasse;
drop table dbs.spezialisiert;
drop table dbs.krankheit;
drop table dbs.lohnzettel;
drop table dbs.arzt;
drop table dbs.patient;
drop table dbs.abteilung;
drop table dbs.mitarbeiter;
drop table dbs.krankenhaus;
drop table dbs.person;

drop sequence dbs.patient_id_seq;
drop sequence dbs.krankenhaus_id_seq;
drop sequence dbs.behandelt_id_seq;

drop function t_check_treated();
drop function t_check_hospital_chef();
drop function t_check_department_chef();
drop function p_move_healed();
drop function p_calc_salary();
drop function f_calc_salary(svnr int, month int, year int);

drop schema dbs;