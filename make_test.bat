mkdir build
type reset_state.sql > build/test_query.sql

type qa.sql >> build/test_query.sql
type qb.sql >> build/test_query.sql
type qc.sql >> build/test_query.sql
type "qd\qd%1.sql" >> "build\test_query.sql"
