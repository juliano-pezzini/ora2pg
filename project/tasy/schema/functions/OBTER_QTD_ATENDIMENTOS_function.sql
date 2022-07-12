-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function obter_qtd_atendimentos as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION obter_qtd_atendimentos ( cd_pessoa_fisica_p text) RETURNS bigint AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	bigint;
BEGIN
	v_query := 'SELECT * FROM obter_qtd_atendimentos_atx ( ' || quote_nullable(cd_pessoa_fisica_p) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret bigint);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION obter_qtd_atendimentos_atx ( cd_pessoa_fisica_p text) RETURNS bigint AS $body$
DECLARE


qt_atendimento_w	bigint;
BEGIN

select  count(1)
into STRICT    qt_atendimento_w
from    atendimento_paciente a
where   a.cd_pessoa_fisica = cd_pessoa_fisica_p;

return qt_atendimento_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_qtd_atendimentos ( cd_pessoa_fisica_p text) FROM PUBLIC; -- REVOKE ALL ON FUNCTION obter_qtd_atendimentos_atx ( cd_pessoa_fisica_p text) FROM PUBLIC;

