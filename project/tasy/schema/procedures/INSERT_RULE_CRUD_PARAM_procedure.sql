-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE insert_rule_crud_param ( nr_seq_lote_p bigint, cd_funcao_p bigint, nr_seq_parametro_p bigint, vl_param_origem_p text, cd_estab_param_p bigint, cd_perfil_param_p bigint, nm_usuario_param_p text, nr_seq_obj_schem_p bigint, nm_tabela_p text, nr_seq_visao_p bigint, ie_insert_p text, ie_update_p text, ie_delete_p text, ds_observacao_p text, nm_usuario_p text) AS $body$
DECLARE


nr_sequencia_w				tabela_crud_param.nr_sequencia%type;


BEGIN

select	nextval('tabela_crud_param_seq')
into STRICT	nr_sequencia_w
;

insert into TABELA_CRUD_PARAM(
	nr_sequencia,
	cd_estabelecimento,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nm_tabela,
	nr_seq_visao,
	nr_seq_obj_schematic,
	ie_insert,
	ie_update,
	ie_delete,
	ds_observacao,
	cd_perfil,
	nm_usuario_param,
	ie_aplicar_filhos)
values (
	nr_sequencia_w,
	cd_estab_param_p,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nm_tabela_p,
	nr_seq_visao_p,
	nr_seq_obj_schem_p,
	ie_insert_p,
	ie_update_p,
	ie_delete_p,
	ds_observacao_p,
	cd_perfil_param_p,
	nm_usuario_param_p,
	'N');

CALL html_param_converter_log('TABELA_CRUD_PARAM',
						nr_sequencia_w,
						cd_estab_param_p,
						cd_perfil_param_p,
						nm_usuario_param_p,
						cd_funcao_p,
						nr_seq_parametro_p,
						vl_param_origem_p,
						nr_seq_lote_p,
						nm_usuario_p);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE insert_rule_crud_param ( nr_seq_lote_p bigint, cd_funcao_p bigint, nr_seq_parametro_p bigint, vl_param_origem_p text, cd_estab_param_p bigint, cd_perfil_param_p bigint, nm_usuario_param_p text, nr_seq_obj_schem_p bigint, nm_tabela_p text, nr_seq_visao_p bigint, ie_insert_p text, ie_update_p text, ie_delete_p text, ds_observacao_p text, nm_usuario_p text) FROM PUBLIC;
