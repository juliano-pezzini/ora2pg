-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE sus_insert_servico_classif (cd_servico_classif_p bigint, ds_servic_classif_p text, cd_servico_p bigint, nr_seq_servico_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert	into sus_servico_classif(cd_servico_classif,
	ds_servic_classif,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_sequencia,
	cd_servico,
	nr_seq_servico)
values (cd_servico_classif_p,
	ds_servic_classif_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nextval('sus_servico_classif_seq'),
	cd_servico_p,
	nr_seq_servico_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE sus_insert_servico_classif (cd_servico_classif_p bigint, ds_servic_classif_p text, cd_servico_p bigint, nr_seq_servico_p bigint, nm_usuario_p text) FROM PUBLIC;

