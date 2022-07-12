-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function obter_nome_pf_reserva as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE FUNCTION obter_nome_pf_reserva ( cd_unidade_basica_p text, cd_unidade_compl_p text, cd_setor_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

	v_ret	varchar;
BEGIN
	v_query := 'SELECT * FROM obter_nome_pf_reserva_atx ( ' || quote_nullable(cd_unidade_basica_p) || ',' || quote_nullable(cd_unidade_compl_p) || ',' || quote_nullable(cd_setor_atendimento_p) || ' )';
	SELECT * INTO v_ret FROM dblink(v_conn_str, v_query) AS p (ret varchar);
	RETURN v_ret;

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE FUNCTION obter_nome_pf_reserva_atx ( cd_unidade_basica_p text, cd_unidade_compl_p text, cd_setor_atendimento_p bigint) RETURNS varchar AS $body$
DECLARE

 
 
nr_seq_vaga_w  		bigint;
cd_pessoa_reserva_w 	varchar(20);
BEGIN
 
 
select 	coalesce(min(nr_sequencia),0) 
into STRICT	nr_seq_vaga_w 
from	gestao_vaga 
where	ie_status = 'R' 
and	cd_unidade_basica = cd_unidade_basica_p 
and	cd_unidade_compl = cd_unidade_compl_p 
and	cd_setor_desejado = cd_setor_atendimento_p;
 
select 	max(cd_pessoa_fisica) 
into STRICT	cd_pessoa_reserva_w 
from	gestao_vaga 
where	nr_sequencia = nr_seq_vaga_w;
 
 
return cd_pessoa_reserva_w;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_nome_pf_reserva ( cd_unidade_basica_p text, cd_unidade_compl_p text, cd_setor_atendimento_p bigint) FROM PUBLIC; -- REVOKE ALL ON FUNCTION obter_nome_pf_reserva_atx ( cd_unidade_basica_p text, cd_unidade_compl_p text, cd_setor_atendimento_p bigint) FROM PUBLIC;
