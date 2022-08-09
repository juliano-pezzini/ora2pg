-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE vincular_entidade_pf ( cd_pessoa_fisica_p text, nr_seq_entidade_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert into pessoa_fisica_ent_assoc(
	nr_sequencia,
	cd_pessoa_fisica,
	nr_seq_entidade,
	dt_atualizacao,
	nm_usuario,
	ds_observacao,
	ie_situacao,
	dt_atualizacao_nrec,
	nm_usuario_nrec)
values (	nextval('pessoa_fisica_ent_assoc_seq'),
	cd_pessoa_fisica_p,
	nr_seq_entidade_p,
	clock_timestamp(),
	nm_usuario_p,
	null,
	'A',
	clock_timestamp(),
	nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE vincular_entidade_pf ( cd_pessoa_fisica_p text, nr_seq_entidade_p bigint, nm_usuario_p text) FROM PUBLIC;
