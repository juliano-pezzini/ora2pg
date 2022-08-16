
-- FUNCTION: oracle.decode(bigint, integer, text, text)
-- DROP FUNCTION IF EXISTS oracle.decode(bigint, integer, text, text);

CREATE OR REPLACE FUNCTION oracle.decode(
	bigint,
	integer,
	text,
	text)
    RETURNS integer
    LANGUAGE 'c'
    COST 1
    IMMUTABLE PARALLEL UNSAFE
AS '$libdir/orafce', 'ora_decode'
;

ALTER FUNCTION oracle.decode(bigint, integer, text, text)
    OWNER TO postgres;

