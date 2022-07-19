-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE start_job_dar_remap_tables () AS $body$
DECLARE

l_exst smallint;
cd_estabelecimento_w	estabelecimento.cd_estabelecimento%type;
nm_usuario_w			usuario.nm_usuario%type;


BEGIN

cd_estabelecimento_w := wheb_usuario_pck.get_cd_estabelecimento;
nm_usuario_w := wheb_usuario_pck.get_nm_usuario;

    select case
        when exists (
            select 1
            from user_scheduler_jobs
            where job_name='DAR_REMAP_TABLES_JOB'
        ) then 1
          else 0
        end  into STRICT l_exst
;

    if l_exst = 0 then
        BEGIN
            dbms_scheduler.create_job(
            job_name => 'DAR_REMAP_TABLES_JOB',
            job_type => 'PLSQL_BLOCK',
	    job_action => 'BEGIN DAR_REMAP_TABLES('||cd_estabelecimento_w||','''||nm_usuario_w||'''); END;',
            start_date => clock_timestamp(),
            enabled => true
           );
        END;
    end if;

END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE start_job_dar_remap_tables () FROM PUBLIC;

