-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE analisar_migr_proj_tabsheet ( cd_funcao_p bigint, nm_objeto_p text, ds_objeto_p text, nr_page_index_p bigint, nm_objeto_pai_p text, nm_objeto_avo_p text, nr_dbpanel_p bigint, nr_wcpanel_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w	bigint;


BEGIN
select	nextval('w_analise_migr_proj_seq')
into STRICT	nr_sequencia_w
;

insert into w_analise_migr_proj(
	nr_sequencia,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	dt_atualizacao,
	nm_usuario,
	cd_funcao,
	ie_objeto,
	nm_objeto,
	ds_objeto,
	nr_seq_apresent,
	nm_objeto_pai,
	nm_objeto_avo,
	nr_dbpanel,
	nr_wcpanel,
	qt_tempo_desenv)
values (
	nr_sequencia_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	cd_funcao_p,
	'TTabSheet',
	nm_objeto_p,
	ds_objeto_p,
	nr_page_index_p,
	nm_objeto_pai_p,
	nm_objeto_avo_p,
	nr_dbpanel_p,
	nr_wcpanel_p,
	10);
commit;
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE analisar_migr_proj_tabsheet ( cd_funcao_p bigint, nm_objeto_p text, ds_objeto_p text, nr_page_index_p bigint, nm_objeto_pai_p text, nm_objeto_avo_p text, nr_dbpanel_p bigint, nr_wcpanel_p bigint, nm_usuario_p text) FROM PUBLIC;

