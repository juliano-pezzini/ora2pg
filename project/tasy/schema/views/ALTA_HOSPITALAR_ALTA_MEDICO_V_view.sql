-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW alta_hospitalar_alta_medico_v (nr_atendimento, nr_atend_original, dt_alta, cd_motivo_alta, cd_pessoa_fisica, cd_procedencia, ie_tipo_atendimento, cd_medico_resp, dt_entrada, ie_permite_visita, ie_clinica, nr_seq_classificacao, dt_entrada_unidade, dt_saida_unidade, cd_setor_atendimento, cd_unidade_basica, cd_unidade_compl, cd_unidade, cd_tipo_acomod_unid, cd_convenio, cd_categoria, cd_usuario_convenio, cd_empresa, cd_tipo_acomod_conv, nr_doc_convenio, ds_setor_atendimento, ds_convenio, ds_categoria, nm_medico, nm_paciente, nr_prontuario, dt_nascimento, cd_religiao, dt_fim_conta, cd_estabelecimento, ds_motivo_alta, dt_alta_interno, nr_seq_interno, hr_alta, dt_saida_real, ie_carater_inter_sus, nr_seq_indicacao, ds_obs_alta, ie_paciente_isolado, nr_seq_tipo_acidente, dt_entrada_real, nm_usuario_saida, cd_classif_setor, dt_impressao_alta, nr_seq_agrupamento, dt_cancelamento, ds_nivel_urgencia, nr_seq_classif_medico, dt_alta_medico, dt_alta_tesouraria, nr_seq_motivo_perm, nm_usuario_alta_medica, dt_alta_medico_setor, nr_episodio) AS select	a.nr_atendimento,
	a.nr_atend_original,
	a.dt_alta,
	a.cd_motivo_alta,
	a.cd_pessoa_fisica,
	a.cd_procedencia,
	a.ie_tipo_atendimento,
	a.cd_medico_resp,
	a.dt_entrada,
	a.ie_permite_visita,
	a.ie_clinica,
	a.nr_seq_classificacao,
	b.dt_entrada_unidade,
	b.dt_saida_unidade,
	b.cd_setor_atendimento,
	b.cd_unidade_basica,
	b.cd_unidade_compl,
	b.cd_unidade_basica || ' ' ||b.cd_unidade_compl  cd_unidade,
	b.cd_tipo_acomodacao cd_tipo_acomod_unid,
	c.cd_convenio,
	c.cd_categoria,
	c.cd_usuario_convenio,
	c.cd_empresa,
	c.cd_tipo_acomodacao cd_tipo_acomod_conv,
	c.nr_doc_convenio,
	substr(obter_nome_setor(b.cd_setor_atendimento),1,100) ds_setor_atendimento,
	substr(obter_nome_convenio(c.cd_convenio),1,60) ds_convenio,
	t.ds_categoria,
	substr(obter_nome_pf(a.cd_medico_resp),1,100) nm_medico,
	p.nm_pessoa_fisica nm_paciente,
	p.nr_prontuario,
	p.dt_nascimento,
	p.cd_religiao,
	a.dt_fim_conta,
	a.cd_estabelecimento,
	substr(obter_desc_motivo_alta(a.cd_motivo_alta),1,100) ds_motivo_alta,
	a.dt_alta_interno,
	b.nr_seq_interno,
	to_char(dt_alta,'hh24') hr_alta,
	dt_saida_real,
	a.ie_carater_inter_sus,
	a.nr_seq_indicacao,
	a.ds_obs_alta,
	a.ie_paciente_isolado,
	a.nr_seq_tipo_acidente,
	b.dt_entrada_real,
	a.nm_usuario_saida,
	obter_classif_setor(b.cd_setor_atendimento) cd_classif_setor,
	a.dt_impressao_alta,
	obter_agrupamento_setor(b.cd_setor_atendimento) nr_seq_agrupamento,
	a.dt_cancelamento,
	substr(coalesce(obter_nivel_urgencia(a.nr_atendimento),'Não informado'),1,100) ds_nivel_urgencia,
	a.nr_seq_classif_medico,
	a.dt_alta_medico,
	a.dt_alta_tesouraria,
	b.nr_seq_motivo_perm,
	a.nm_usuario_alta_medica,
	 b.dt_alta_medico_setor,
	substr(OBTER_EPISODIO_ATEND_TELA(a.nr_atendimento),1,80) nr_episodio
FROM	pessoa_fisica p,
	categoria_convenio t,
	atend_paciente_unidade b,
	atend_categoria_convenio c,
	atendimento_paciente a
where (a.dt_alta is not null or a.dt_alta_medico is not null or b.dt_alta_medico_setor is not null)
and	a.nr_atendimento	= b.nr_atendimento
and	a.nr_atendimento	= c.nr_atendimento
and	b.nr_Seq_interno = (	select	coalesce(max(x.nr_seq_interno),0)
				from 	atend_paciente_unidade x,
					setor_atendimento y
				where	X.nr_atendimento = a.nr_atendimento
				and	x.cd_setor_atendimento = y.cd_setor_atendimento
				AND 	y.cd_classif_setor IN (3,4,8,12)
				and 	coalesce(x.dt_saida_unidade, x.dt_entrada_unidade + 9999)	=
					(select max(coalesce(v.dt_saida_unidade, v.dt_entrada_unidade + 9999))
					from 	atend_paciente_unidade v,
						setor_atendimento u
					where 	v.nr_atendimento 	= a.nr_atendimento
					and	v.cd_setor_atendimento  = u.cd_setor_Atendimento
					AND 	u.cd_classif_setor IN (3,4,8,12))
			   )
AND	c.nr_seq_interno	= (SELECT	coalesce(MAX(x.nr_seq_interno),0)
							FROM 	atend_categoria_convenio x
							WHERE	x.nr_atendimento 		= a.nr_atendimento
							  AND 	x.dt_inicio_vigencia	=
												(SELECT	MAX(y.dt_inicio_vigencia)
												 FROM 	atend_categoria_convenio y
												 WHERE 	y.nr_atendimento	= a.nr_atendimento  LIMIT 1)
							)
and	a.cd_pessoa_fisica	= p.cd_pessoa_fisica
and	c.cd_convenio		= t.cd_convenio
and	c.cd_categoria		= t.cd_categoria

union all

select	a.nr_atendimento,
	a.nr_atend_original,
	a.dt_alta,
	a.cd_motivo_alta,
	a.cd_pessoa_fisica,
	a.cd_procedencia,
	a.ie_tipo_atendimento,
	a.cd_medico_resp,
	a.dt_entrada,
	a.ie_permite_visita,
	a.ie_clinica,
	a.nr_seq_classificacao,
	b.dt_entrada_unidade,
	b.dt_saida_unidade,
	b.cd_setor_atendimento,
	b.cd_unidade_basica,
	b.cd_unidade_compl,
	b.cd_unidade_basica || ' ' ||b.cd_unidade_compl  cd_unidade,
	b.cd_tipo_acomodacao cd_tipo_acomod_unid,
	0 cd_convenio,
	'' cd_categoria,
	'' cd_usuario_convenio,
	0 cd_empresa,
	0 cd_tipo_acomod_conv,
	'' nr_doc_convenio,
	substr(obter_nome_setor(b.cd_setor_atendimento),1,100) ds_setor_atendimento,
	'' ds_convenio,
	'' ds_categoria,
	substr(obter_nome_pf(a.cd_medico_resp),1,100) nm_medico,
	p.nm_pessoa_fisica nm_paciente,
	p.nr_prontuario,
	p.dt_nascimento,
	p.cd_religiao,
	a.dt_fim_conta,
	a.cd_estabelecimento,
	substr(obter_desc_motivo_alta(a.cd_motivo_alta),1,100) ds_motivo_alta,
	a.dt_alta_interno,
	b.nr_seq_interno,
	to_char(dt_alta,'hh24') hr_alta,
	dt_saida_real,
	a.ie_carater_inter_sus,
	a.nr_seq_indicacao,
	a.ds_obs_alta,
	a.ie_paciente_isolado,
	a.nr_seq_tipo_acidente,
	b.dt_entrada_real,
	a.nm_usuario_saida,
	obter_classif_setor(b.cd_setor_atendimento) cd_classif_setor,
	a.dt_impressao_alta,
	obter_agrupamento_setor(b.cd_setor_atendimento) nr_seq_agrupamento,
	a.dt_cancelamento,
	substr(coalesce(obter_nivel_urgencia(a.nr_atendimento),'Não informado'),1,100) ds_nivel_urgencia,
	a.nr_seq_classif_medico,
	a.dt_alta_medico,
	a.dt_alta_tesouraria,
	b.nr_seq_motivo_perm,
	a.nm_usuario_alta_medica,
	b.dt_alta_medico_setor,
	substr(OBTER_EPISODIO_ATEND_TELA(a.nr_atendimento),1,80) nr_episodio
from	pessoa_fisica p,
	atend_paciente_unidade b,
	atendimento_paciente a
where (a.dt_alta is not null or a.dt_alta_medico is not null or b.dt_alta_medico_setor is not null)
and	a.nr_atendimento	= b.nr_atendimento
and	b.nr_Seq_interno = (	select	coalesce(max(x.nr_seq_interno),0)
				from 	atend_paciente_unidade x,
					setor_atendimento y
				where	X.nr_atendimento = a.nr_atendimento
				and	x.cd_setor_atendimento = y.cd_setor_atendimento
				AND 	y.cd_classif_setor IN (3,4,8,12)
				and 	coalesce(x.dt_saida_unidade, x.dt_entrada_unidade + 9999)	=
					(select max(coalesce(v.dt_saida_unidade, v.dt_entrada_unidade + 9999))
					from 	atend_paciente_unidade v,
						setor_atendimento u
					where 	v.nr_atendimento 	= a.nr_atendimento
					and	v.cd_setor_atendimento  = u.cd_setor_Atendimento
					AND 	u.cd_classif_setor IN (3,4,8,12))
				)
and	a.cd_pessoa_fisica	= p.cd_pessoa_fisica
and	not exists (select	max(1)
			from	atend_categoria_convenio x
			where	x.nr_atendimento = a.nr_atendimento);

