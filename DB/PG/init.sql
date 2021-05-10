set search_path to toybox, public;

insert into person (last_name) values ('admin');

insert into project (title, created_by) values ('default', (select id from person));

