-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function mirth_adt_a08_atualizaao_pac as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE mirth_adt_a08_atualizaao_pac ( cd_pessoa_fisica_p text) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'CALL mirth_adt_a08_atualizaao_pac_atx ( ' || quote_nullable(cd_pessoa_fisica_p) || ' )';
	PERFORM * FROM dblink(v_conn_str, v_query) AS p (ret boolean);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE mirth_adt_a08_atualizaao_pac_atx ( cd_pessoa_fisica_p text) AS $body$
DECLARE

 
ie_existe_atend_w 	bigint;
ds_sep_bv_w		varchar(100);
ds_param_integ_hl7_w	varchar(4000);
BEGIN
 
begin 
	select 	count(*) 
	into STRICT 	ie_existe_atend_w 
	from	atendimento_paciente 
	where 	cd_pessoa_fisica = cd_pessoa_fisica_p;
 
	if (ie_existe_atend_w > 0) then 
		ds_sep_bv_w := obter_separador_bv;
		ds_param_integ_hl7_w :=	'cd_pessoa_fisica=' || cd_pessoa_fisica_p || ds_sep_bv_w;
 
		CALL gravar_agend_integracao(426, ds_param_integ_hl7_w);
	end if;
exception 
	when	others then 
		null;
end;
	 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE mirth_adt_a08_atualizaao_pac ( cd_pessoa_fisica_p text) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE mirth_adt_a08_atualizaao_pac_atx ( cd_pessoa_fisica_p text) FROM PUBLIC;
