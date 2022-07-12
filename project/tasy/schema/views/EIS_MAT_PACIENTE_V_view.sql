-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_mat_paciente_v (dt_referencia, cd_estabelecimento, cd_material, cd_grupo_material, cd_centro_custo, dt_atualizacao, nm_usuario, qt_paciente, qt_consumo, vl_paciente, vl_consumo, vl_perda_venda, vl_perda_custo, cd_convenio, qt_atendimento, qt_devolucao, vl_adicional, vl_amenor, vl_glosa, cd_categoria, vl_dif_perda, ds_grupo_material, ds_material, ds_centro_custo, ds_convenio, ds_categoria, vl_custo_medio, vl_ult_compra) AS select	a.DT_REFERENCIA,a.CD_ESTABELECIMENTO,a.CD_MATERIAL,a.CD_GRUPO_MATERIAL,a.CD_CENTRO_CUSTO,a.DT_ATUALIZACAO,a.NM_USUARIO,a.QT_PACIENTE,a.QT_CONSUMO,a.VL_PACIENTE,a.VL_CONSUMO,a.VL_PERDA_VENDA,a.VL_PERDA_CUSTO,a.CD_CONVENIO,a.QT_ATENDIMENTO,a.QT_DEVOLUCAO,a.VL_ADICIONAL,a.VL_AMENOR,a.VL_GLOSA,a.CD_CATEGORIA,
	(a.VL_PERDA_CUSTO - a.VL_PERDA_VENDA) vl_dif_perda,
	substr(obter_desc_estrut_mat(a.cd_grupo_material, null, null, null),1,50) ds_grupo_material,
	substr(obter_desc_estrut_mat(null, null, null, a.cd_material),1,50) ds_material,
	obter_desc_centro_custo(a.cd_centro_custo) ds_centro_custo,
	substr(obter_nome_convenio(a.cd_convenio),1,50) ds_convenio,
	substr(substr(obter_nome_convenio(a.cd_convenio),1,50) || ' - ' || obter_categoria_convenio(a.cd_convenio, a.cd_categoria),1,200) ds_categoria,
	CASE WHEN coalesce(obter_se_mat_consignado(a.cd_material), '0')='1' THEN 	round((obter_custo_medio_consig(cd_estabelecimento, null, a.cd_material, null, dt_referencia))::numeric, 2)  ELSE round((obter_custo_medio_material(cd_estabelecimento, dt_referencia, a.cd_material))::numeric,2) END  vl_custo_medio,
	round((obter_valor_ultima_compra(cd_estabelecimento, null, a.cd_material, null, 'N'))::numeric,2) vl_ult_compra
FROM	eis_mat_paciente a;

