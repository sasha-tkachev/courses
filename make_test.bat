mkdir build
type reset_state.sql > build/test_query.sql

type "mmn11\qa.sql" >> "build\test_query.sql"
type "mmn11\qb.sql" >> "build\test_query.sql"
type "mmn11\qc.sql" >> "build\test_query.sql"
type "mmn11\qd\qd%1.sql" >> "build\test_query.sql"
start notepad.exe "build\test_query.sql"
