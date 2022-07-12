-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function obter_receita_avaliacao_nom as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION obter_receita_avaliacao_nom (nr_atendimento_hosp_p bigint) RETURNS varchar AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	varchar;
BEGIN
	v_query := 'SELECT * FROM obter_receita_avaliacao_nom_atx ( ' || quote_nullable(nr_atendimento_hosp_p) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret varchar);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION obter_receita_avaliacao_nom_atx (nr_atendimento_hosp_p bigint) RETURNS varchar AS $body$
DECLARE
qt_receita_w	bigint;
ds_receita_w	varchar(4000);	
nr_seq_rtf_srtring_w	bigint;
nr_seq_receita_w	bigint;
					

BEGIN

if (nr_atendimento_hosp_p IS NOT NULL AND nr_atendimento_hosp_p::text <> '') then
	SELECT	nr_sequencia
	into STRICT	nr_seq_receita_w
	FROM	med_receita
	WHERE	nr_atendimento_hosp = nr_atendimento_hosp_p
	AND	(ds_receita IS NOT NULL AND ds_receita::text <> '')
	AND    dt_receita = (SELECT MAX(dt_receita)
			     FROM	med_receita 
			     WHERE	nr_atendimento_hosp = nr_atendimento_hosp_p);	
end if;


if (coalesce(nr_seq_receita_w,0) > 0 ) then
	begin
	select 	substr(convert_long_html_to_str('DS_RECEITA','MED_RECEITA',' NR_SEQUENCIA = ' || nr_seq_receita_w),1,4000)
	into STRICT	ds_receita_w
	;
	end;
end if;

return	ds_receita_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_receita_avaliacao_nom (nr_atendimento_hosp_p bigint) FROM PUBLIC; -- REVOKE ALL ON FUNCTION obter_receita_avaliacao_nom_atx (nr_atendimento_hosp_p bigint) FROM PUBLIC;
