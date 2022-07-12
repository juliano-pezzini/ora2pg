-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function obter_unidade_paciente as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION obter_unidade_paciente ( nr_cirurgia_p bigint, cd_pessoa_fisica_p text, nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	varchar;
BEGIN
	v_query := 'SELECT * FROM obter_unidade_paciente_atx ( ' || quote_nullable(nr_cirurgia_p) || ',' || quote_nullable(cd_pessoa_fisica_p) || ',' || quote_nullable(nr_atendimento_p) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret varchar);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION obter_unidade_paciente_atx ( nr_cirurgia_p bigint, cd_pessoa_fisica_p text, nr_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE



ds_resultado_w		varchar(50);
nr_atendimento_w		bigint := null;
BEGIN


if (nr_atendimento_p IS NOT NULL AND nr_atendimento_p::text <> '') then
 	nr_atendimento_w := nr_atendimento_p;
elsif (nr_cirurgia_p IS NOT NULL AND nr_cirurgia_p::text <> '') then
	select nr_atendimento
	into STRICT nr_atendimento_w
	from cirurgia
	where nr_cirurgia = nr_cirurgia_p
	  and (nr_atendimento IS NOT NULL AND nr_atendimento::text <> '');
end if;

if (cd_pessoa_fisica_p IS NOT NULL AND cd_pessoa_fisica_p::text <> '') and (coalesce(nr_atendimento_w::text, '') = '') then
	select	max(nr_atendimento)
	into STRICT		nr_atendimento_w
	from		atendimento_paciente
	where		coalesce(dt_alta::text, '') = ''
	  and		cd_pessoa_fisica = cd_pessoa_fisica_p;
end if;

if (nr_atendimento_w IS NOT NULL AND nr_atendimento_w::text <> '') then
	select max(cd_unidade)
	into STRICT ds_resultado_w
	from atendimento_paciente_v
	where nr_atendimento = nr_atendimento_w;
end if;

return ds_resultado_w;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_unidade_paciente ( nr_cirurgia_p bigint, cd_pessoa_fisica_p text, nr_atendimento_p bigint) FROM PUBLIC; -- REVOKE ALL ON FUNCTION obter_unidade_paciente_atx ( nr_cirurgia_p bigint, cd_pessoa_fisica_p text, nr_atendimento_p bigint) FROM PUBLIC;

