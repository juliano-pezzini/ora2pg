-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tiss_opm_executado_v (ds_versao, cd_material, ds_procedimento, qt_material, cd_edicao_amb, cd_procedimento_convenio, cd_edicao_relat, vl_unitario, vl_material, cd_autorizacao, nr_interno_conta, ie_tiss_tipo_guia_desp, cd_cgc_prestador) AS select	'2.01.01' ds_versao,
	a.cd_material,
	substr(obter_desc_material(a.cd_material),1,60) ds_procedimento,
	sum(a.qt_material) qt_material,
	substr(TISS_OBTER_ORIGEM_PRECO_MAT(a.ie_origem_preco, a.cd_material, b.cd_estabelecimento, b.cd_convenio_parametro, b.cd_categoria_parametro, a.cd_tab_preco_material, a.dt_conta,a.cd_setor_atendimento,'X',null,a.nr_sequencia, a.cd_material_tuss),1,20) cd_edicao_amb,
	lpad(CASE WHEN a.CD_material_CONVENIO='0' THEN  TO_CHAR(a.CD_material) WHEN a.CD_material_CONVENIO IS NULL THEN  TO_CHAR(a.CD_material)  ELSE a.CD_material_convenio END ,10,'0') cd_procedimento_convenio,
	substr(TISS_OBTER_ORIGEM_PRECO_MAT(a.ie_origem_preco, a.cd_material, b.cd_estabelecimento, b.cd_convenio_parametro, b.cd_categoria_parametro, a.cd_tab_preco_material, a.dt_conta,a.cd_setor_atendimento,'R',null,a.nr_sequencia, a.cd_material_tuss),1,20) cd_edicao_relat,
	a.vl_unitario,
	sum(a.vl_material) vl_material,
	coalesce(a.nr_doc_convenio, obter_desc_expressao(778770)) cd_autorizacao,
	a.nr_interno_conta,
	a.ie_tiss_tipo_guia_desp,
	coalesce(a.cd_cgc_prestador, g.cd_cgc) cd_cgc_prestador
FROM	estabelecimento g,
	classe_material f,
	material e,
	material_atend_paciente a,
	conta_paciente b
where	b.nr_interno_conta				= a.nr_interno_conta
and	a.cd_motivo_exc_conta				is null
and	a.cd_material					= e.cd_material
and	e.cd_classe_material				= f.cd_classe_material
and	f.ie_tipo_classe				in ('O','P','M')
and	b.cd_estabelecimento				= g.cd_estabelecimento
group 	by a.cd_material,
	substr(obter_desc_material(a.cd_material),1,60),
	substr(TISS_OBTER_ORIGEM_PRECO_MAT(a.ie_origem_preco, a.cd_material, b.cd_estabelecimento, b.cd_convenio_parametro, b.cd_categoria_parametro, a.cd_tab_preco_material, a.dt_conta,a.cd_setor_atendimento,'X',null,a.nr_sequencia, a.cd_material_tuss),1,20),
	lpad(CASE WHEN a.CD_material_CONVENIO='0' THEN  TO_CHAR(a.CD_material) WHEN a.CD_material_CONVENIO IS NULL THEN  TO_CHAR(a.CD_material)  ELSE a.CD_material_convenio END ,10,'0'),
	substr(TISS_OBTER_ORIGEM_PRECO_MAT(a.ie_origem_preco, a.cd_material, b.cd_estabelecimento, b.cd_convenio_parametro, b.cd_categoria_parametro, a.cd_tab_preco_material, a.dt_conta,a.cd_setor_atendimento,'R',null,a.nr_sequencia, a.cd_material_tuss),1,20),
	a.vl_unitario,
	coalesce(a.nr_doc_convenio, obter_desc_expressao(778770)),
	a.nr_interno_conta,
	a.ie_tiss_tipo_guia_desp,
	coalesce(a.cd_cgc_prestador, g.cd_cgc);

