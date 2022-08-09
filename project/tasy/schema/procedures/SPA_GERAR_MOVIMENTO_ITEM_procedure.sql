-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE spa_gerar_movimento_item ( nr_seq_movimento_p bigint, nr_seq_item_p bigint, ie_tipo_item_p text, nm_usuario_p text) AS $body$
BEGIN

insert into spa_movimento_item(
	nr_sequencia,
	nr_seq_movimento,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_item,
	ie_tipo_item)
values (
	nextval('spa_movimento_item_seq'),
	nr_seq_movimento_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_item_p,
	ie_tipo_item_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE spa_gerar_movimento_item ( nr_seq_movimento_p bigint, nr_seq_item_p bigint, ie_tipo_item_p text, nm_usuario_p text) FROM PUBLIC;
