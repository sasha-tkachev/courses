mkdir build
type reset_tables.sql > build/query.sql

type qa.sql >> build/query.sql
type qb.sql >> build/query.sql
type qc.sql >> build/query.sql
type "qd\qd1.sql" >> "build\query.sql"
type "qd\qd2.sql" >> "build\query.sql"
type "qd\qd3.sql" >> "build\query.sql"
type "qd\qd4.sql" >> "build\query.sql"
type "qd\qd5.sql" >> "build\query.sql"
type "qd\qd6.sql" >> "build\query.sql"
type "qd\qd7.sql" >> "build\query.sql"