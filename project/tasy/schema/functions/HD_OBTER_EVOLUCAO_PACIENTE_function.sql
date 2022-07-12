-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function hd_obter_evolucao_paciente as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION hd_obter_evolucao_paciente ( cd_pessoa_fisica_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	varchar;
BEGIN
	v_query := 'SELECT * FROM hd_obter_evolucao_paciente_atx ( ' || quote_nullable(cd_pessoa_fisica_p) || ',' || quote_nullable(cd_estabelecimento_p) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret varchar);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION hd_obter_evolucao_paciente_atx ( cd_pessoa_fisica_p text, cd_estabelecimento_p bigint) RETURNS varchar AS $body$
DECLARE


cd_tipo_evolucao_w		varchar(3);
cd_evolucao_w			bigint;
ds_evolucao_w			varchar(255);
ds_sql_w			varchar(2000);
nr_seq_resultado_w		bigint;
BEGIN

select	cd_tipo_evolucao
into STRICT	cd_tipo_evolucao_w
from	hd_parametro
where	cd_estabelecimento	= cd_estabelecimento_p;

select	max(cd_evolucao)
into STRICT	cd_evolucao_w
from	evolucao_paciente
where	cd_pessoa_fisica	= cd_pessoa_fisica_p
and	ie_evolucao_clinica	= cd_tipo_evolucao_w
and	(dt_liberacao IS NOT NULL AND dt_liberacao::text <> '');

ds_sql_w	:= 'select ds_evolucao from evolucao_paciente where cd_evolucao	= :cd_evolucao';

nr_seq_resultado_w := converte_rtf_string(ds_sql_w, cd_evolucao_w, 'Tasy', nr_seq_resultado_w);

select	substr(ds_texto_clob,255,1)
into STRICT	ds_evolucao_w
from	tasy_conversao_rtf
where	nr_sequencia		= nr_seq_resultado_w;

return	ds_evolucao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION hd_obter_evolucao_paciente ( cd_pessoa_fisica_p text, cd_estabelecimento_p bigint) FROM PUBLIC; -- REVOKE ALL ON FUNCTION hd_obter_evolucao_paciente_atx ( cd_pessoa_fisica_p text, cd_estabelecimento_p bigint) FROM PUBLIC;
