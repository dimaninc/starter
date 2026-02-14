CREATE TABLE IF NOT EXISTS sample(
  id int unsigned not null auto_increment,
  user_id int DEFAULT '0',
  name varchar(100) default '',
  email varchar(60) default '',
  phone varchar(20) default '',
  company varchar(100) default '',
  web varchar(100) default '',
  content text,
  properties json,
  ip bigint,
  order_num int,
  visible tinyint default '1',
  top tinyint default '0',
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  primary key(id),
  index idx(name, email, company, visible, top, order_num)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
