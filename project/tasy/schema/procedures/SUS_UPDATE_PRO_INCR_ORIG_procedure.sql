-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_update_pro_incr_orig (nr_sequencia_p bigint, cd_habilitacao_p bigint, pr_incremento_sa_p bigint, pr_incremento_sh_p bigint, pr_incremento_sp_p bigint, cd_procedimento_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert 	into sus_proced_incremento_origem(nr_sequencia,
	cd_habilitacao,
	pr_incremento_sa,
	pr_incremento_sh,
	pr_incremento_sp,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	cd_procedimento,
	ie_origem_proced)
values (nr_sequencia_p,
	cd_habilitacao_p,
	pr_incremento_sa_p,
	pr_incremento_sh_p,
	pr_incremento_sp_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	cd_procedimento_p,
	7);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_update_pro_incr_orig (nr_sequencia_p bigint, cd_habilitacao_p bigint, pr_incremento_sa_p bigint, pr_incremento_sh_p bigint, pr_incremento_sp_p bigint, cd_procedimento_p bigint, nm_usuario_p text) FROM PUBLIC;

