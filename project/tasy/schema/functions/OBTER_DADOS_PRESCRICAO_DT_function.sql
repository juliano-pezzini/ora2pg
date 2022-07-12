-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function obter_dados_prescricao_dt as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION obter_dados_prescricao_dt ( nr_prescricao_p prescr_medica.nr_prescricao%type, ie_opcao_p text ) RETURNS timestamp AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	timestamp;
BEGIN
	v_query := 'SELECT * FROM obter_dados_prescricao_dt_atx ( ' || quote_nullable(nr_prescricao_p) || ',' || quote_nullable(ie_opcao_p) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret timestamp);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION obter_dados_prescricao_dt_atx ( nr_prescricao_p prescr_medica.nr_prescricao%type, ie_opcao_p text ) RETURNS timestamp AS $body$
DECLARE

 
/* 
D  - Data prescrição 
VI  - Validade início 
VF  - Validade final 
DL  - Data Liberação 
DLM - Data Liberação Médico 
DN  - Data de nascimento 
DE  - Data de entrada atendimento 
*/
 
 
dt_retorno_w		timestamp;
BEGIN
if (nr_prescricao_p IS NOT NULL AND nr_prescricao_p::text <> '') then 
 
	if (ie_opcao_p = 'D') then 
		 
		select	max(dt_prescricao) 
		into STRICT	dt_retorno_w 
		from	prescr_medica 
		where	nr_prescricao = nr_prescricao_p;
	 
	elsif (ie_opcao_p = 'VI') then 
 
		select	max(dt_inicio_prescr) 
		into STRICT	dt_retorno_w 
		from	prescr_medica 
		where	nr_prescricao = nr_prescricao_p;
	 
	elsif (ie_opcao_p = 'VF') then	 
 
		select	max(dt_validade_prescr) 
		into STRICT	dt_retorno_w 
		from	prescr_medica 
		where	nr_prescricao = nr_prescricao_p;
	 
	elsif (ie_opcao_p = 'DL') then 
 
		select	max(dt_liberacao) 
		into STRICT	dt_retorno_w 
		from	prescr_medica 
		where	nr_prescricao = nr_prescricao_p;
	 
	elsif (ie_opcao_p = 'DLM') then 
 
		select	max(dt_liberacao_medico) 
		into STRICT	dt_retorno_w 
		from	prescr_medica 
		where	nr_prescricao = nr_prescricao_p;
	 
	elsif (ie_opcao_p = 'DN') then 
 
		select	obter_data_nascto_pf(cd_pessoa_fisica) 
		into STRICT	dt_retorno_w 
		from	prescr_medica 
		where	nr_prescricao = nr_prescricao_p;
	 
	elsif (ie_opcao_p = 'DE') then 
 
		select	obter_dados_atendimento_dt(nr_atendimento,'DE') 
		into STRICT	dt_retorno_w 
		from	prescr_medica 
		where	nr_prescricao = nr_prescricao_p;
 
	end if;
	 
end if;
 
return dt_retorno_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_dados_prescricao_dt ( nr_prescricao_p prescr_medica.nr_prescricao%type, ie_opcao_p text ) FROM PUBLIC; -- REVOKE ALL ON FUNCTION obter_dados_prescricao_dt_atx ( nr_prescricao_p prescr_medica.nr_prescricao%type, ie_opcao_p text ) FROM PUBLIC;

