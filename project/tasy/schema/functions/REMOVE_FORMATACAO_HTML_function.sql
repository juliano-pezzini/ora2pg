-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function remove_formatacao_html as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION remove_formatacao_html (cd_pessoa_fisica_p bigint) RETURNS varchar AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	varchar;
BEGIN
	v_query := 'SELECT * FROM remove_formatacao_html_atx ( ' || quote_nullable(cd_pessoa_fisica_p) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret varchar);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION remove_formatacao_html_atx (cd_pessoa_fisica_p bigint) RETURNS varchar AS $body$
DECLARE


nr_seq_tasy_conversao_rtf_w	tasy_conversao_rtf.nr_sequencia%type;

cd_pessoa_fisica_w			evolucao_paciente.cd_pessoa_fisica%type;

ds_retorno_w			varchar(2000);
BEGIN
cd_pessoa_fisica_w := cd_pessoa_fisica_p;

nr_seq_tasy_conversao_rtf_w := converte_rtf_string('select ds_evolucao from evolucao_paciente where cd_pessoa_fisica = :cd_pessoa_fisica_p order by DT_EVOLUCAO desc fetch first row only ', to_char(cd_pessoa_fisica_w), 'Tasy', nr_seq_tasy_conversao_rtf_w);



select	substr( ds_texto_clob, 2000, 1 )

into STRICT	ds_retorno_w

from	tasy_conversao_rtf

where	nr_sequencia = nr_seq_tasy_conversao_rtf_w;



return	ds_retorno_w;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION remove_formatacao_html (cd_pessoa_fisica_p bigint) FROM PUBLIC; -- REVOKE ALL ON FUNCTION remove_formatacao_html_atx (cd_pessoa_fisica_p bigint) FROM PUBLIC;

