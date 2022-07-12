-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function obter_se_internado_ou_obito as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION obter_se_internado_ou_obito (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	varchar;
BEGIN
	v_query := 'SELECT * FROM obter_se_internado_ou_obito_atx ( ' || quote_nullable(cd_pessoa_fisica_p) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret varchar);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION obter_se_internado_ou_obito_atx (cd_pessoa_fisica_p text) RETURNS varchar AS $body$
DECLARE

 
qt_obito_motivo_w		smallint;
ds_retorno_w		varchar(1) := 'N';
qt_obito_cadastro_w	smallint;
BEGIN
 
select	count(*) 
into STRICT	qt_obito_motivo_w 
from	motivo_alta b, 
		atendimento_paciente a 
where	a.cd_pessoa_fisica = cd_pessoa_fisica_p 
and		(a.dt_alta IS NOT NULL AND a.dt_alta::text <> '') 
and		a.cd_motivo_alta = b.cd_motivo_alta 
and		b.ie_obito = 'S';
 
select	count(*) 
into STRICT	qt_obito_cadastro_w 
from	pessoa_fisica 
where	cd_pessoa_fisica = cd_pessoa_fisica_p 
and		(dt_obito IS NOT NULL AND dt_obito::text <> '');
 
if (qt_obito_motivo_w > 0 or qt_obito_cadastro_w > 0)	then 
	ds_retorno_w	:= 'O';
else 
	select		coalesce(max('I'),'N') 
	into STRICT		ds_retorno_w 
	from		unidade_atendimento a, 
				atendimento_paciente b 
	where		a.nr_atendimento = b.nr_atendimento 
	and			b.cd_pessoa_fisica = cd_pessoa_fisica_p;	
end if;
 
return ds_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_internado_ou_obito (cd_pessoa_fisica_p text) FROM PUBLIC; -- REVOKE ALL ON FUNCTION obter_se_internado_ou_obito_atx (cd_pessoa_fisica_p text) FROM PUBLIC;

