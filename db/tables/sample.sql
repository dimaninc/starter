CREATE TABLE IF NOT EXISTS sample(
  id bigint unsigned not null auto_increment,
  user_id bigint DEFAULT '0',
  name varchar(100) default '',
  email varchar(60) default '',
  phone varchar(20) default '',
  company varchar(100) default '',
  web varchar(100) default '',
  content text,
  ip bigint,
  date timestamp default CURRENT_TIMESTAMP,
  primary key(id),
  index idx(name, email, company)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;