create schema dbs;

create table dbs.person (
svnr integer not null primary key,
anschrift varchar(128),
name varchar(128));

create sequence dbs.patient_id_seq increment 10 start 10;
create table dbs.patient (
id integer not null primary key DEFAULT nextval('dbs.patient_id_seq'),
person integer references dbs.person(svnr) not null,
geheilt boolean not null default false,
seit date not null default CURRENT_DATE);

create table dbs.mitarbeiter (
person integer references dbs.person(svnr) not null primary key,
beschaeftigt_seit date not null default CURRENT_DATE,
abteilung varchar(128),
krankenhaus integer,
gehalt numeric check (gehalt > 0) );


create table dbs.lohnzettel (
mitarbeiter integer references dbs.mitarbeiter(person) not null,
honorar numeric not null,
monat smallint not null,
jahr smallint not null,
primary key(mitarbeiter, monat, jahr));

create table dbs.arzt (
person integer references dbs.person(svnr) not null primary key);


create sequence dbs.krankenhaus_id_seq increment 10 start 10;
create table dbs.krankenhaus (
id integer not null primary key DEFAULT nextval('dbs.krankenhaus_id_seq'),
name varchar(128) not null,
anschrift varchar(128) not null,
geleitet_von integer references dbs.mitarbeiter(person) deferrable initially deferred not null);

create table dbs.abteilung (
name varchar(128) not null,
krankenhaus integer references dbs.krankenhaus(id) deferrable initially deferred not null,
anschrift varchar(128) not null,
koordiniert_von integer references dbs.mitarbeiter(person) deferrable initially deferred not null,
primary key(name, krankenhaus));

alter table dbs.mitarbeiter add foreign key (abteilung, krankenhaus) references dbs.abteilung (name, krankenhaus) deferrable initially deferred;

create table dbs.krankheit (
name varchar(128) not null primary key,
bonus real not null  check (bonus>=1));

create table dbs.spezialisiert (
abteilung varchar(128) not null, 
krankenhaus integer not null,
krankheit varchar(128) not null, 
foreign key (abteilung, krankenhaus) references dbs.abteilung (name, krankenhaus));

create table dbs.klasse (
name varchar(128) not null primary key,
uebergeordnet varchar(128) references dbs.klasse(name));

create table dbs.zugeordnet (
krankheit varchar(128) references dbs.krankheit(name) not null,
klasse varchar(128) references dbs.klasse(name) not null,
primary key(krankheit, klasse));

create sequence dbs.behandelt_id_seq increment 10 start 10;
create table dbs.behandelt (
id integer not null primary key DEFAULT nextval('dbs.behandelt_id_seq'),
arzt integer references dbs.arzt(person) not null,
krankheit varchar(128) references dbs.krankheit(name) not null,
patient integer not null references dbs.patient(id) on delete cascade,
dauer smallint not null,
abgerechnet boolean not null default false);

create table dbs.akteneintrag (
person integer references dbs.person(svnr) not null,
krankenhaus integer references dbs.krankenhaus(id) not null,
krankheit varchar(128) references dbs.krankheit(name) not null,
von timestamp not null,
bis timestamp not null,
constraint chk_date CHECK (von <= bis));