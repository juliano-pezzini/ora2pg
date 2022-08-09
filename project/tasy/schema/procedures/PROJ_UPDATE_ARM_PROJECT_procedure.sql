-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE proj_update_arm_project (nr_seq_proj_project_p bigint, nm_usuario_p text ) AS $body$
DECLARE

ds_versao_w			varchar(500);
dt_inicio_prev_w	timestamp;
dt_fim_prev_w		timestamp;
ie_status_w		proj_projeto.ie_status%type;
nr_seq_ordem_serv_w	bigint;
cd_metodologia_w	bigint;
ds_escopo_w			varchar(4000);


BEGIN
	select	ds_versao,
			dt_inicio_prev,
			dt_fim_prev,
			ie_status,
			nr_seq_ordem_serv,
			cd_metodologia,
			ds_escopo
	into STRICT	ds_versao_w,
			dt_inicio_prev_w,
			dt_fim_prev_w,
			ie_status_w,
			nr_seq_ordem_serv_w,
			cd_metodologia_w,
			ds_escopo_w
	from	proj_projeto
	where	nr_sequencia 		= nr_seq_proj_project_p;

	update	arm_project
	set		nr_release			= ds_versao_w,
			dt_initial			= dt_inicio_prev_w,
			dt_final			= dt_fim_prev_w,
			nr_seq_scope_stage	= obter_project_estagio_status(ie_status_w,'S'),
			nr_seq_ordem		= nr_seq_ordem_serv_w,
			cd_framework		= to_char(cd_metodologia_w),
			ds_description		= ds_escopo_w,
			nm_usuario			= nm_usuario_p,
			dt_atualizacao		= clock_timestamp()
	where	nr_project_id		= nr_seq_proj_project_p;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE proj_update_arm_project (nr_seq_proj_project_p bigint, nm_usuario_p text ) FROM PUBLIC;
