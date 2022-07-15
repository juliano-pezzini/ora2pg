-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gravar_consistencia_requisicao ( nr_requisicao_p bigint, cd_material_p bigint, ie_tipo_p text, ds_consistencia_p text, ie_forma_p text, ds_observacao_p text, nm_usuario_p text) AS $body$
BEGIN

insert into requisicao_mat_consist(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_requisicao,
	ie_tipo_consistencia,
	ds_consistencia,
	ie_forma_consistencia,
	ds_observacao,
	cd_material)
values (	nextval('requisicao_mat_consist_seq'),
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_requisicao_p,
	ie_tipo_p,
	substr(ds_consistencia_p,1,255),
	ie_forma_p,
	substr(ds_observacao_p,1,255),
	cd_material_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gravar_consistencia_requisicao ( nr_requisicao_p bigint, cd_material_p bigint, ie_tipo_p text, ds_consistencia_p text, ie_forma_p text, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;

