-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW atualizacao_cadastro_mat_v (nm_tabela, cd_material, ds_material, dt_atualizacao_nrec, nm_usuario_nrec, dt_atualizacao, nm_usuario) AS select	'material' nm_tabela,
	cd_material,
	ds_material,
	dt_atualizacao_nrec dt_atualizacao_nrec,
	nm_usuario_nrec nm_usuario_nrec,
	dt_atualizacao dt_atualizacao,
	nm_usuario nm_usuario
FROM	material

union all

select	'material_diluicao' nm_tabela,
	cd_material,
	obter_desc_material(cd_material) ds_material,
	dt_atualizacao_nrec dt_atualizacao_nrec,
	nm_usuario_nrec nm_usuario_nrec,
	dt_atualizacao dt_atualizacao,
	nm_usuario nm_usuario
from	material_diluicao

union all

select	'material_prescr' nm_tabela,
	cd_material,
	obter_desc_material(cd_material) ds_material,
	dt_atualizacao_nrec dt_atualizacao_nrec,
	nm_usuario_nrec nm_usuario_nrec,
	dt_atualizacao dt_atualizacao,
	nm_usuario nm_usuario
from	material_prescr

union all

select	'material_reacao' nm_tabela,
	cd_material,
	obter_desc_material(cd_material) ds_material,
	dt_atualizacao_nrec dt_atualizacao_nrec,
	nm_usuario_nrec nm_usuario_nrec,
	dt_atualizacao dt_atualizacao,
	nm_usuario nm_usuario
from	material_reacao

union all

select	'material_interacao_medic' nm_tabela,
	cd_material,
	obter_desc_material(cd_material) ds_material,
	dt_atualizacao_nrec dt_atualizacao_nrec,
	nm_usuario_nrec nm_usuario_nrec,
	dt_atualizacao dt_atualizacao,
	nm_usuario nm_usuario
from	material_interacao_medic

union all

select	'medic_interacao_alimento' nm_tabela,
	cd_material,
	obter_desc_material(cd_material) ds_material,
	dt_atualizacao_nrec dt_atualizacao_nrec,
	nm_usuario_nrec nm_usuario_nrec,
	dt_atualizacao dt_atualizacao,
	nm_usuario nm_usuario
from	medic_interacao_alimento

union all

select	'material_classe_adic' nm_tabela,
	cd_material,
	obter_desc_material(cd_material) ds_material,
	dt_atualizacao_nrec dt_atualizacao_nrec,
	nm_usuario_nrec nm_usuario_nrec,
	dt_atualizacao dt_atualizacao,
	nm_usuario nm_usuario
from	material_classe_adic

union all

select	'material_conversao_unidade' nm_tabela,
	cd_material,
	obter_desc_material(cd_material) ds_material,
	dt_atualizacao_nrec dt_atualizacao_nrec,
	nm_usuario_nrec nm_usuario_nrec,
	dt_atualizacao dt_atualizacao,
	nm_usuario nm_usuario
from	material_conversao_unidade

union all

select	'material_armazenamento' nm_tabela,
	cd_material,
	obter_desc_material(cd_material) ds_material,
	dt_atualizacao_nrec dt_atualizacao_nrec,
	nm_usuario_nrec nm_usuario_nrec,
	dt_atualizacao dt_atualizacao,
	nm_usuario nm_usuario
from	material_armazenamento

union all

select	'mat_via_aplic' nm_tabela,
	cd_material,
	obter_desc_material(cd_material) ds_material,
	dt_atualizacao_nrec dt_atualizacao_nrec,
	nm_usuario_nrec nm_usuario_nrec,
	dt_atualizacao dt_atualizacao,
	nm_usuario nm_usuario
from	mat_via_aplic

union all

select	'kit_mat_prescricao' nm_tabela,
	cd_material,
	obter_desc_material(cd_material) ds_material,
	dt_atualizacao_nrec dt_atualizacao_nrec,
	nm_usuario_nrec nm_usuario_nrec,
	dt_atualizacao dt_atualizacao,
	nm_usuario nm_usuario
from	kit_mat_prescricao

union all

select	'material_espec_tecnica' nm_tabela,
	cd_material,
	obter_desc_material(cd_material) ds_material,
	dt_atualizacao_nrec dt_atualizacao_nrec,
	nm_usuario_nrec nm_usuario_nrec,
	dt_atualizacao dt_atualizacao,
	nm_usuario nm_usuario
from	material_espec_tecnica

union all

select	'regra_dose_terap' nm_tabela,
	000 cd_material,
	'Geral' ds_material,
	dt_atualizacao_nrec dt_atualizacao_nrec,
	nm_usuario_nrec nm_usuario_nrec,
	dt_atualizacao dt_atualizacao,
	nm_usuario nm_usuario
from	regra_dose_terap

union all

select	'material_setor_exclusivo' nm_tabela,
	cd_material,
	obter_desc_material(cd_material) ds_material,
	dt_atualizacao_nrec dt_atualizacao_nrec,
	nm_usuario_nrec nm_usuario_nrec,
	dt_atualizacao dt_atualizacao,
	nm_usuario nm_usuario
from	material_setor_exclusivo

union all

select	'material_dose_terap' nm_tabela,
	cd_material,
	obter_desc_material(cd_material) ds_material,
	dt_atualizacao_nrec dt_atualizacao_nrec,
	nm_usuario_nrec nm_usuario_nrec,
	dt_atualizacao dt_atualizacao,
	nm_usuario nm_usuario
from	material_dose_terap

union all

select	'material_dcb' nm_tabela,
	cd_material,
	obter_desc_material(cd_material) ds_material,
	dt_atualizacao_nrec dt_atualizacao_nrec,
	nm_usuario_nrec nm_usuario_nrec,
	dt_atualizacao dt_atualizacao,
	nm_usuario nm_usuario
from	material_dcb

union all

select	'material_dci' nm_tabela,
	cd_material,
	obter_desc_material(cd_material) ds_material,
	dt_atualizacao_nrec dt_atualizacao_nrec,
	nm_usuario_nrec nm_usuario_nrec,
	dt_atualizacao dt_atualizacao,
	nm_usuario nm_usuario
from	material_dci

union all

select	'material_atc' nm_tabela,
	cd_material,
	obter_desc_material(cd_material) ds_material,
	dt_atualizacao_nrec dt_atualizacao_nrec,
	nm_usuario_nrec nm_usuario_nrec,
	dt_atualizacao dt_atualizacao,
	nm_usuario nm_usuario
from	material_atc

union all

select	'material_opcao_beneficio' nm_tabela,
	cd_material,
	obter_desc_material(cd_material) ds_material,
	dt_atualizacao_nrec dt_atualizacao_nrec,
	nm_usuario_nrec nm_usuario_nrec,
	dt_atualizacao dt_atualizacao,
	nm_usuario nm_usuario
from	material_opcao_beneficio

union all

select	'prescr_estoque_redu' nm_tabela,
	cd_material,
	obter_desc_material(cd_material) ds_material,
	dt_atualizacao_nrec dt_atualizacao_nrec,
	nm_usuario_nrec nm_usuario_nrec,
	dt_atualizacao dt_atualizacao,
	nm_usuario nm_usuario
from	prescr_estoque_redu

union all

select	'regra_material_proced' nm_tabela,
	cd_material,
	obter_desc_material(cd_material) ds_material,
	dt_atualizacao_nrec dt_atualizacao_nrec,
	nm_usuario_nrec nm_usuario_nrec,
	dt_atualizacao dt_atualizacao,
	nm_usuario nm_usuario
from	regra_material_proced;

