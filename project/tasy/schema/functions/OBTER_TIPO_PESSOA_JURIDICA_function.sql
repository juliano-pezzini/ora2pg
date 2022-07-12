-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function obter_tipo_pessoa_juridica as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION obter_tipo_pessoa_juridica (cd_cgc_p pessoa_juridica.cd_cgc%type) RETURNS bigint AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	bigint;
BEGIN
	v_query := 'SELECT * FROM obter_tipo_pessoa_juridica_atx ( ' || quote_nullable(cd_cgc_p) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret bigint);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION obter_tipo_pessoa_juridica_atx (cd_cgc_p pessoa_juridica.cd_cgc%type) RETURNS bigint AS $body$
DECLARE


cd_tipo_pessoa_w	pessoa_juridica.cd_tipo_pessoa%type;
BEGIN

if (cd_cgc_p IS NOT NULL AND cd_cgc_p::text <> '') then

	select	max(cd_tipo_pessoa)
	into STRICT	cd_tipo_pessoa_w
	from	pessoa_juridica
	where	cd_cgc	= cd_cgc_p;
end if;

return cd_tipo_pessoa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_tipo_pessoa_juridica (cd_cgc_p pessoa_juridica.cd_cgc%type) FROM PUBLIC; -- REVOKE ALL ON FUNCTION obter_tipo_pessoa_juridica_atx (cd_cgc_p pessoa_juridica.cd_cgc%type) FROM PUBLIC;
