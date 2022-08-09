-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_insert_proced_serv_classif (cd_procedimento_p bigint, nr_seq_serv_classif_p bigint, cd_servico_classif_p bigint, cd_servico_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert 	into sus_proced_serv_classif(cd_procedimento,
	ie_origem_proced,
	nr_seq_serv_classif,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_sequencia,
	cd_servico_classif,
	cd_servico)
values (cd_procedimento_p,
	7,
	nr_seq_serv_classif_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nextval('sus_proced_serv_classif_seq'),
	cd_servico_classif_p,
	cd_servico_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_insert_proced_serv_classif (cd_procedimento_p bigint, nr_seq_serv_classif_p bigint, cd_servico_classif_p bigint, cd_servico_p bigint, nm_usuario_p text) FROM PUBLIC;
