begin transaction;	

set search_path to toybox, public;

create table toybox.person (
	"id" integer not null generated always as identity,
	first_name text null,
	middle_name text null,
	last_name text not null,
	constraint person_pk primary key ("id")
);

create table toybox.project (
	"id" integer not null generated always as identity,
	title text not null,
	created timestamp not null default now(),
	created_by integer not null references person,	
	constraint project_pk primary key ("id")
);


create table toybox.lane (
	"id" integer not null generated always as identity,
	project_id integer not null references project,
	serial_no int2 not null,
	title text not null,
	created timestamp not null default now(),
	created_by integer not null references person,	
	constraint lane_pk primary key ("id")
);


create table toybox.task (
	"id" integer not null generated always as identity,
	title text null,
	"text" text null,
	created timestamp not null default now(),
	created_by integer not null references person,
	assigned_to integer null references person,
	status int2 not null default 0,
	constraint task_pk primary key ("id")
);

commit transaction;
