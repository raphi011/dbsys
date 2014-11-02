insert into dbs.person (svnr, anschrift, name) values (1, 'anschrift 1', 'person 1');
insert into dbs.person (svnr, anschrift, name) values (2, 'anschrift 2', 'person 2');
insert into dbs.person (svnr, anschrift, name) values (3, 'anschrift 3', 'person 3');
insert into dbs.person (svnr, anschrift, name) values (4, 'anschrift 4', 'person 4');

insert into dbs.patient (person, geheilt) values (1, true);
insert into dbs.patient (person) values (1);
insert into dbs.patient (person, geheilt) values (2, true);	

begin transaction;

insert into dbs.krankenhaus (name, anschrift, geleitet_von) values ('krankenhaus 1', 'anschrift 1', 1);
insert into dbs.krankenhaus (name, anschrift, geleitet_von) values ('krankenhaus 2', 'anschrift 2', 2);
insert into dbs.krankenhaus (name, anschrift, geleitet_von) values ('krankenhaus 3', 'anschrift 3', 3);

insert into dbs.abteilung (name, krankenhaus, anschrift, koordiniert_von) values ('abteilung 1', 10, 'anschrift 1', 1);
insert into dbs.abteilung (name, krankenhaus, anschrift, koordiniert_von) values ('abteilung 2', 10, 'anschrift 2', 2);
insert into dbs.abteilung (name, krankenhaus, anschrift, koordiniert_von) values ('abteilung 1', 30, 'anschrift 3', 4);
insert into dbs.abteilung (name, krankenhaus, anschrift, koordiniert_von) values ('abteilung 1', 20, 'anschrift 4', 3);

insert into dbs.mitarbeiter (person, abteilung, krankenhaus, gehalt) values (1, 'abteilung 1', 10, 20 );
insert into dbs.mitarbeiter (person, abteilung, krankenhaus, gehalt) values (2, 'abteilung 2', 10, 15 );
insert into dbs.mitarbeiter (person, abteilung, krankenhaus, gehalt) values (3, 'abteilung 1', 20, 30 );
insert into dbs.mitarbeiter (person, abteilung, krankenhaus, gehalt) values (4, 'abteilung 1', 30, 30 );

commit transaction;

insert into dbs.lohnzettel (mitarbeiter, honorar, monat, jahr) values (1, 2000, 11, 2014);
insert into dbs.lohnzettel (mitarbeiter, honorar, monat, jahr) values (1, 2000, 12, 2014);
insert into dbs.lohnzettel (mitarbeiter, honorar, monat, jahr) values (1, 2000, 1, 2015);	
insert into dbs.lohnzettel (mitarbeiter, honorar, monat, jahr) values (4, 2000, 1, 2015);	

insert into dbs.arzt (person) values (1);
insert into dbs.arzt (person) values (2);
insert into dbs.arzt (person) values (3);

insert into dbs.krankheit (name, bonus) values ('krankheit 1', 1);
insert into dbs.krankheit (name, bonus) values ('krankheit 2', 1.2);
insert into dbs.krankheit (name, bonus) values ('krankheit 3', 1.3);

insert into dbs.spezialisiert (abteilung, krankenhaus, krankheit) values ('abteilung 1', 10, 'krankheit 1');
insert into dbs.spezialisiert (abteilung, krankenhaus, krankheit) values ('abteilung 2', 10, 'krankheit 2');
insert into dbs.spezialisiert (abteilung, krankenhaus, krankheit) values ('abteilung 1', 30, 'krankheit 3');

insert into dbs.klasse (name) values ('klasse 1');
insert into dbs.klasse (name, uebergeor167dnet) values ('klasse 1.1', 'klasse 1');
insert into dbs.klasse (name, uebergeordnet) values ('klasse 1.1.1', 'klasse 1.1');

insert into dbs.zugeordnet (krankheit, klasse) values ( 'krankheit 1', 'klasse 1');
insert into dbs.zugeordnet (krankheit, klasse) values ( 'krankheit 2', 'klasse 1.1');
insert into dbs.zugeordnet (krankheit, klasse) values ( 'krankheit 3', 'klasse 1.1.1');	

insert into dbs.behandelt (arzt, krankheit, patient, dauer) values (1, 'krankheit 1', 10, 2);
insert into dbs.behandelt (arzt, krankheit, patient, dauer) values (2, 'krankheit 1', 20, 2);
insert into dbs.behandelt (arzt, krankheit, patient, dauer, abgerechnet) values (3, 'krankheit 1', 30, 2, true);

insert into dbs.akteneintrag (person, krankenhaus, krankheit, von, bis) values (1, 10, 'krankheit 1', '2012-01-01 11:00:00', '2012-01-05 15:00:00');
insert into dbs.akteneintrag (person, krankenhaus, krankheit, von, bis) values (1, 20, 'krankheit 1', '2012-01-01 11:00:00', '2012-01-05 11:00:00');
insert into dbs.akteneintrag (person, krankenhaus, krankheit, von, bis) values (4, 10, 'krankheit 2', '2005-05-06 11:00:00', '2005-08-03 11:00:00');
