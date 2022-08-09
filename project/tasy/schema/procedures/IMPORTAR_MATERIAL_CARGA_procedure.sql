-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE importar_material_carga ( cd_estabelecimento_p bigint, cd_tabela_material_p bigint, cd_material_p bigint, dt_inicio_vigencia_p timestamp, vl_preco_venda_p bigint, cd_moeda_p bigint, nm_usuario_p text) AS $body$
BEGIN

insert into preco_material(cd_estabelecimento,
                          	CD_TAB_PRECO_MAT,
                          	CD_MATERIAL,
                          	dt_inicio_vigencia,
                          	VL_PRECO_VENDA,
		IE_BRASINDICE,
		IE_SITUACAO,
                          	cd_moeda,
                          	dt_atualizacao,
                          	nm_usuario,
                          	dt_atualizacao_nrec,
                          	nm_usuario_nrec)
                          	values (cd_estabelecimento_p,
	                cd_tabela_material_p,
                          	cd_material_p,
                          	dt_inicio_vigencia_p,
                          	vl_preco_venda_p,
		  'N',
		  'A',
		cd_moeda_p,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p);
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE importar_material_carga ( cd_estabelecimento_p bigint, cd_tabela_material_p bigint, cd_material_p bigint, dt_inicio_vigencia_p timestamp, vl_preco_venda_p bigint, cd_moeda_p bigint, nm_usuario_p text) FROM PUBLIC;
