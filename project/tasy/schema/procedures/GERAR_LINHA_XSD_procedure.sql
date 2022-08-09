-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_linha_xsd (nr_seq_item_xsd_p xsd_item.nr_sequencia%type, ds_linha_p xsd_item_linha.ds_linha%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
BEGIN

insert	into xsd_item_linha(nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_item_xsd,
		ds_linha)
values (nextval('xsd_item_linha_seq'),
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_item_xsd_p,
		ds_linha_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_linha_xsd (nr_seq_item_xsd_p xsd_item.nr_sequencia%type, ds_linha_p xsd_item_linha.ds_linha%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;
