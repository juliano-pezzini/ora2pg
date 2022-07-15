-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE man_copiar_suite_testes ( nr_suite_p bigint, nr_story_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_suite_w	bigint;


BEGIN

select	nextval('desenv_suite_teste_seq')
into STRICT	nr_suite_w
;

insert into desenv_suite_teste(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nm_suite,
	nr_story,
	ds_objetivo,
	ds_premissa,
	nr_plano)
SELECT	nr_suite_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nm_suite,
	nr_story_p,
	ds_objetivo,
	ds_premissa,
	nr_plano
from	desenv_suite_teste
where	nr_sequencia = nr_suite_p;

insert into desenv_caso_teste(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	ds_acao,
	ds_resultado,
	nr_ordem,
	nr_suite,
	ds_observacao)
SELECT	nextval('desenv_caso_teste_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	ds_acao,
	ds_resultado,
	nr_ordem,
	nr_suite_w,
	ds_observacao
from	desenv_caso_teste
where	nr_suite = nr_suite_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE man_copiar_suite_testes ( nr_suite_p bigint, nr_story_p bigint, nm_usuario_p text) FROM PUBLIC;

