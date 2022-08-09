-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE reg_exclude_items_test_plan ( ie_tipo_mudanca_p text, nr_seq_product_req_p bigint, nr_seq_caso_teste_p bigint, cd_funcao_p bigint, ie_matriz_risco_p text, ie_tipo_operacao_p text, nm_usuario_p text, nr_seq_pendency_p bigint, ds_version_p text) AS $body$
BEGIN

CALL reg_test_plan_pck.exclude_items_from_plan(
	ie_tipo_mudanca_p,
	nr_seq_product_req_p,
	nr_seq_caso_teste_p,
	cd_funcao_p,
	ie_matriz_risco_p,
	ie_tipo_operacao_p,
	nm_usuario_p,
	nr_seq_pendency_p,
	ds_version_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE reg_exclude_items_test_plan ( ie_tipo_mudanca_p text, nr_seq_product_req_p bigint, nr_seq_caso_teste_p bigint, cd_funcao_p bigint, ie_matriz_risco_p text, ie_tipo_operacao_p text, nm_usuario_p text, nr_seq_pendency_p bigint, ds_version_p text) FROM PUBLIC;
