CREATE TABLE memos (
  id SERIAL PRIMARY KEY,
  title VARCHAR(30) NOT NULL,
  content VARCHAR(1000) NOT NULL
);
