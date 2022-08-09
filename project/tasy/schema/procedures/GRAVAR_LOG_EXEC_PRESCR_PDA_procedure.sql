-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_log_exec_prescr_pda ( nm_usuario_p text, nr_atendimento_p text, cd_material_p text, cd_procedimento_p text, nr_seq_kit_estoque_p text, ds_log_p text) AS $body$
BEGIN

insert into log_exec_prescr_pda(
	nr_sequencia,
	nm_usuario,
	dt_atualizacao,
	nr_atendimento,
	cd_material,
	cd_procedimento,
	nr_seq_kit_estoque,
	ds_log)
values (	nextval('log_exec_prescr_pda_seq'),
	nm_usuario_p,
	clock_timestamp(),
	substr(nr_atendimento_p,1,10),
	substr(cd_material_p,1,6),
	substr(cd_procedimento_p,1,15),
	substr(nr_seq_kit_estoque_p,1,10),
	ds_log_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_log_exec_prescr_pda ( nm_usuario_p text, nr_atendimento_p text, cd_material_p text, cd_procedimento_p text, nr_seq_kit_estoque_p text, ds_log_p text) FROM PUBLIC;
