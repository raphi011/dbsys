create schema dbs;

create table dbs.person (
svnr integer not null primary key,
anschrift varchar(128),
name varchar(128));

create table dbs.patient (
person integer references dbs.person(svnr) not null primary key,
geheilt boolean not null default false,
seit date not null default CURRENT_DATE);

create table dbs.mitarbeiter (
person integer references dbs.person(svnr) not null primary key,
beschaeftigt_seit date not null default CURRENT_DATE,
gehalt real);

create table dbs.lohnzettel (
id integer not null,
mitarbeiter integer references dbs.mitarbeiter(person) not null,
honorar double precision not null,
monat smallint not null,
jahr smallint not null,
primary key(id, mitarbeiter));

create table dbs.arzt (
person integer references dbs.person(svnr) not null primary key);

create table dbs.krankenhaus (
name varchar(128) not null primary key,
anschrift varchar(128) not null,
geleitet_von integer references dbs.mitarbeiter(person) not null);

create table dbs.abteilung (
name varchar(128) not null,
krankenhaus varchar(128) references dbs.krankenhaus(name) not null,
anschrift varchar(128) not null,
koordiniert_von integer references dbs.mitarbeiter(person) not null,
primary key(name, krankenhaus));

create table dbs.krankheit (
name varchar(128) not null primary key,
bonus real not null);

create table dbs.klasse (
name varchar(128) not null primary key,
uebergeordnet varchar(128) references dbs.klasse(name));

create table dbs.zugeordnet (
krankheit varchar(128) references dbs.krankheit(name) not null,
klasse varchar(128) references dbs.klasse(name) not null,
primary key(krankheit, klasse));

create table dbs.behandelt (
arzt integer references dbs.arzt(person) not null,
krankheit varchar(128) references dbs.krankheit(name) not null,
patient integer references dbs.patient(person) not null,
dauer timestamp not null,
abgerechnet boolean not null default false,
primary key(krankheit, patient));

create table dbs.akteneintrag (
person varchar(128) references dbs.person(name) not null,
krankenhaus varchar(128) references dbs.krankenhaus(name) not null,
krankheit varchar(128) references dbs.krankheit(name) not null,
von date not null,
bis date not null);



