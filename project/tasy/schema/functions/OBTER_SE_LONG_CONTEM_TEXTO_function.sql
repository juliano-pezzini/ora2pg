-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function obter_se_long_contem_texto as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION obter_se_long_contem_texto ( nm_tabela_p text, nm_coluna_p text, ds_restricao_where_p text, ds_parametros_sql_p text, ds_texto_busca_p text) RETURNS varchar AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	varchar;
BEGIN
	v_query := 'SELECT * FROM obter_se_long_contem_texto_atx ( ' || quote_nullable(nm_tabela_p) || ',' || quote_nullable(nm_coluna_p) || ',' || quote_nullable(ds_restricao_where_p) || ',' || quote_nullable(ds_parametros_sql_p) || ',' || quote_nullable(ds_texto_busca_p) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret varchar);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION obter_se_long_contem_texto_atx ( nm_tabela_p text, nm_coluna_p text, ds_restricao_where_p text, ds_parametros_sql_p text, ds_texto_busca_p text) RETURNS varchar AS $body$
DECLARE

ie_retorno_w	varchar(1);
BEGIN

ie_retorno_w := obter_se_long_contem(	nm_tabela_p, nm_coluna_p, ds_restricao_where_p, ds_parametros_sql_p, ds_texto_busca_p, ie_retorno_w);
commit;

return	ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_long_contem_texto ( nm_tabela_p text, nm_coluna_p text, ds_restricao_where_p text, ds_parametros_sql_p text, ds_texto_busca_p text) FROM PUBLIC; -- REVOKE ALL ON FUNCTION obter_se_long_contem_texto_atx ( nm_tabela_p text, nm_coluna_p text, ds_restricao_where_p text, ds_parametros_sql_p text, ds_texto_busca_p text) FROM PUBLIC;

