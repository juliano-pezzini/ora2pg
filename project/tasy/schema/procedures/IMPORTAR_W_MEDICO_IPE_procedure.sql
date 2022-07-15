-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE importar_w_medico_ipe ( nr_crm_p text, nm_medico_p text, cd_cep_p bigint, dt_atualizacao_nrec_p timestamp, nm_usuario_nrec_p text) AS $body$
BEGIN

insert into w_medico_ipe(
	nr_crm,
	nm_medico,
	cd_cep,
	dt_atualizacao_nrec,
	nm_usuario_nrec
) values (
	substr(nr_crm_p,1,8),
	nm_medico_p,
	cd_cep_p,
	dt_atualizacao_nrec_p,
	nm_usuario_nrec_p
);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE importar_w_medico_ipe ( nr_crm_p text, nm_medico_p text, cd_cep_p bigint, dt_atualizacao_nrec_p timestamp, nm_usuario_nrec_p text) FROM PUBLIC;

