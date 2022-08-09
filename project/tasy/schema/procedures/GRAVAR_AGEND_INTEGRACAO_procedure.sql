-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';



--
-- dblink wrapper to call function gravar_agend_integracao as an autonomous transaction
--
CREATE EXTENSION IF NOT EXISTS dblink;

CREATE OR REPLACE PROCEDURE gravar_agend_integracao ( nr_seq_evento_p bigint, ds_parametros_p text, cd_setor_atendimento_p bigint default null) AS $body$
DECLARE
	-- Change this to reflect the dblink connection string
	v_conn_str  text := format('port=%s dbname=%s user=%s', current_setting('port'), current_database(), current_user);
	v_query     text;

BEGIN
	v_query := 'CALL gravar_agend_integracao_atx ( ' || quote_nullable(nr_seq_evento_p) || ',' || quote_nullable(ds_parametros_p) || ',' || quote_nullable(cd_setor_atendimento_p) || ' )';
	PERFORM * FROM dblink(v_conn_str, v_query) AS p (ret boolean);

END;
$body$ LANGUAGE plpgsql SECURITY DEFINER;




CREATE OR REPLACE PROCEDURE gravar_agend_integracao_atx ( nr_seq_evento_p bigint, ds_parametros_p text, cd_setor_atendimento_p bigint default null) AS $body$
DECLARE

jobno bigint;
cd_estabelecimento_w smallint;
ds_parametros_w varchar(4000);
cd_setor_atendimento_w varchar(60);


-- If on 19c, dbms_job implicitly schedule the job using dbms_scheduler

-- Dbms_scheduler has an implicit commit, which cannot be executed under a trigger

-- So on 19c, an autonomous transaction is required
$if dbms_db_version.version >= 19 $then$end

;
BEGIN

  if (wheb_usuario_pck.is_evento_ativo(nr_seq_evento_p) = 'S') then
  begin
    select 'pck_cd_estabelecimento=' || wheb_usuario_pck.get_cd_estabelecimento || obter_separador_bv  || 
           'pck_nm_usuario=' || wheb_usuario_pck.get_nm_usuario || obter_separador_bv  
           into STRICT ds_parametros_w
;
    cd_estabelecimento_w := coalesce(wheb_usuario_pck.get_cd_estabelecimento,1);

	cd_setor_atendimento_w := '';
	if (cd_setor_atendimento_p IS NOT NULL AND cd_setor_atendimento_p::text <> '') then
		cd_setor_atendimento_w := ', ' ||cd_setor_atendimento_p;
	end if;
	
    $if dbms_db_version.version >= 19 $then
        -- If 19c or higher, schedule the job using the dbms_scheduler (which will commit).

        -- So the autonomous transaction is commited but the main transaction still have to be commited

        -- To give some time to the main trasaction, the job schedule to run a few minutes in the future
        dbms_scheduler.create_job(
            job_name  => 'job_gravar_agend_int' || round(dbms_random.value(1000000, 9999999)),
            job_type => 'PLSQL_BLOCK', 
            job_action => 'begin job_gravar_agend_integracao('|| to_char(nr_seq_evento_p) || ', ''' || ds_parametros_p || ds_parametros_w || ''', ' || cd_estabelecimento_w || cd_setor_atendimento_w || '); end;',
            start_date  => CURRENT_TIMESTAMP + interval '30' second, 
            enabled   => TRUE, 
            auto_drop=>TRUE);
    $else
        -- If not 19c, schedule the job using dbms_job and the job will only run once the main transaction commits
        dbms_job.submit(jobno, 'job_gravar_agend_integracao('|| to_char(nr_seq_evento_p) || ', ''' || ds_parametros_p || ds_parametros_w || ''', ' || cd_estabelecimento_w || cd_setor_atendimento_w || ');');
    $end	
  end;
  end if;
  
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_agend_integracao ( nr_seq_evento_p bigint, ds_parametros_p text, cd_setor_atendimento_p bigint default null) FROM PUBLIC; -- REVOKE ALL ON PROCEDURE gravar_agend_integracao_atx ( nr_seq_evento_p bigint, ds_parametros_p text, cd_setor_atendimento_p bigint default null) FROM PUBLIC;
