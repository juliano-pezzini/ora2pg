-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_receita_custo_v (cd_estabelecimento, cd_convenio, cd_conta_contabil, dt_referencia, dt_receita, cd_centro_custo, ie_protocolo, vl_receita, vl_total, cd_estab_atend, cd_setor_atendimento, ie_tipo_atendimento, ds_tipo_atend, ie_clinica_atend, ds_clinica_atend) AS select	a.cd_estabelecimento,
	a.cd_convenio,
	a.cd_conta_contabil,
	trunc(a.dt_referencia,'month') dt_referencia,
	trunc(a.dt_receita,'month') dt_receita,
	coalesce(b.cd_centro_custo_receita, b.cd_centro_custo) cd_centro_custo,
	a.ie_protocolo,
	(a.vl_procedimento + a.vl_material) vl_receita,
	(a.vl_procedimento + a.vl_material + a.vl_terceiro) vl_total,
	obter_estab_atend(a.nr_atendimento) cd_estab_atend,
	b.cd_setor_atendimento cd_setor_atendimento,
	a.ie_tipo_atendimento ie_tipo_atendimento,
	a.ds_tipo_atend ds_tipo_atend,
	a.ie_clinica_atend ie_clinica_atend,
	a.ds_clinica_atend ds_clinica_atend
FROM	Setor_Atendimento b,
	Eis_Resultado a
where	a.cd_setor_atendimento	= b.cd_setor_atendimento
and	a.cd_conta_contabil	is not null
and	coalesce(b.cd_centro_custo_receita, b.cd_centro_custo) is not null;
