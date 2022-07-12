-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tiss_dados_solicitacao_v (ds_versao, ie_origem, nr_atendimento, nr_seq_agenda, dt_autorizacao, ie_carater_inter_sus, ds_indicacao, nr_sequencia, cd_cgc, ds_razao_social, cd_cnes, qt_dia_autorizado, cd_tipo_acomod_autor, nr_sequencia_autor, ie_tipo_autorizacao, cd_ans, cd_autorizacao, ie_tipo_internacao, ie_regime_internacao, ds_observacao, nr_interno_conta, cd_senha, dt_fim_vigencia, qt_dia_solicitado, nm_responsavel, dt_entrada_prevista, ie_interno, cd_convenio, cd_interno, cd_autorizacao_princ, ie_tiss_tipo_guia, ie_previsao_uso_quimio, ie_previsao_uso_opme, ie_tiss_tipo_acidente, cd_autorizacao_prest, nr_seq_pedido_exame_ext, cd_validacao_tiss, cd_ausencia_cod_valid, ie_tiss_tipo_etapa_autor, ie_tiss_cobertura_especial) AS select	'2.01.01' ds_versao,
	'AC' ie_origem,
	a.nr_atendimento,
	a.nr_seq_agenda,
	TISS_OBTER_DATA_AUTOR(a.nr_sequencia) dt_autorizacao,
	a.ie_carater_int_tiss ie_carater_inter_sus,
	a.ds_indicacao,
	a.nr_sequencia,
	c.cd_cgc,
	d.ds_razao_social,
	d.cd_cnes,
	a.qt_dia_autorizado,
	substr(tiss_obter_tipo_acomod(a.cd_tipo_acomodacao),1,40) cd_tipo_acomod_autor,
	a.nr_sequencia nr_sequencia_autor,
	a.ie_tipo_autorizacao,
	coalesce(g.cd_ans, d.cd_ans)cd_ans,
	TISS_OBTER_GUIA_PRIC_AUTOR(x.cd_estabelecimento,a.cd_convenio,a.nr_sequencia,'GO') cd_autorizacao,
	coalesce(a.ie_tipo_internacao_tiss,substr(TISS_OBTER_CLINICA(b.ie_clinica, b.nr_seq_classificacao),1,3)) ie_tipo_internacao,
	coalesce(a.ie_regime_internacao,substr(tiss_obter_regime_atend(b.nr_atendimento, c.cd_convenio),1,5)) ie_regime_internacao,
	substr(coalesce(tiss_obter_regra_campo(4, 'DS_OBSERVACAO', a.cd_convenio, a.ds_observacao, b.ie_tipo_atendimento, null,'N',0, b.cd_estabelecimento, null, null, null, null), tiss_obter_obs_solic_spsadt(a.cd_convenio, b.cd_estabelecimento, a.nm_usuario) || ' ' || substr(a.ds_observacao,1,255)),1,254) ds_observacao,
	(null)::numeric  nr_interno_conta,
	a.CD_SENHA,
	a.DT_FIM_VIGENCIA,
	a.qt_dia_solicitado,
	a.NM_RESPONSAVEL,
	a.DT_ENTRADA_PREVISTA,
	e.ie_interno,
	a.cd_convenio,
	substr(TISS_OBTER_CODIGO_PRESTADOR(c.cd_convenio, b.cd_estabelecimento, null, coalesce(a.cd_cgc_prestador, x.cd_cgc), (null)::numeric , 'CI',NULL,b.ie_tipo_atendimento,null),1,20) cd_interno,
	TISS_OBTER_GUIA_PRIC_AUTOR(x.cd_estabelecimento,a.cd_convenio,a.nr_sequencia,'GP') cd_autorizacao_princ,
	tiss_obter_tipo_guia_autor(a.nr_sequencia) ie_tiss_tipo_guia,
	a.ie_previsao_uso_quimio,
	a.ie_previsao_uso_opme,
	a.ie_tiss_tipo_acidente,
	a.cd_autorizacao_prest,
	0 nr_seq_pedido_exame_ext,
	a.cd_validacao_tiss,
	a.cd_ausencia_cod_valid,
	a.ie_tiss_tipo_etapa_autor,
    	a.ie_tiss_cobertura_especial
FROM	estagio_autorizacao e,
	pessoa_juridica d,
	estabelecimento x,
	convenio c,
	atendimento_paciente b,
	autorizacao_convenio a,
	convenio_estabelecimento g
where	a.nr_atendimento	= b.nr_atendimento
and 	c.cd_convenio = g.cd_convenio
and 	g.cd_estabelecimento = a.cd_estabelecimento
and	a.cd_convenio		= c.cd_convenio
and	c.cd_cgc		= d.cd_cgc
and	x.cd_estabelecimento	= b.cd_estabelecimento
and	a.nr_seq_estagio	= e.nr_sequencia
and	a.nr_seq_agenda	is null
and	a.nr_seq_agenda_consulta is null
and	a.nr_seq_rxt_tratamento		is null

union

select	'2.01.01' ds_versao,
	'AC' ie_origem,
	(null)::numeric  nr_atendimento,
	a.nr_seq_agenda,
	TISS_OBTER_DATA_AUTOR(a.nr_sequencia) dt_autorizacao,
	a.ie_carater_int_tiss ie_carater_inter_sus,
	a.ds_indicacao,
	a.nr_sequencia,
	c.cd_cgc,
	d.ds_razao_social,
	d.cd_cnes,
	a.qt_dia_autorizado,
	substr(tiss_obter_tipo_acomod(a.cd_tipo_acomodacao),1,40) cd_tipo_acomod_autor,
	a.nr_sequencia nr_sequencia_autor,
	a.ie_tipo_autorizacao,
	coalesce(p.cd_ans, d.cd_ans) cd_ans,
	TISS_OBTER_GUIA_PRIC_AUTOR(f.cd_estabelecimento,a.cd_convenio,a.nr_sequencia,'GO') cd_autorizacao,
	coalesce(a.ie_tipo_internacao_tiss,substr(TISS_OBTER_CLINICA(coalesce(g.ie_clinica, g.ie_clinica), g.nr_seq_classificacao),1,3)) ie_tipo_internacao,
	coalesce(a.ie_regime_internacao,substr(tiss_obter_regime_atend(a.nr_atendimento, a.cd_convenio),1,5)) ie_regime_internacao,
	substr(coalesce(tiss_obter_regra_campo(4, 'DS_OBSERVACAO', a.cd_convenio, a.ds_observacao, b.ie_tipo_atendimento, null,'N',0, f.cd_estabelecimento, null, null, null, null), tiss_obter_obs_solic_spsadt(a.cd_convenio, f.cd_estabelecimento, a.nm_usuario) || ' ' || substr(a.ds_observacao,1,255)),1,254) ds_observacao,
	(null)::numeric  nr_interno_conta,
	a.CD_SENHA,
	a.DT_FIM_VIGENCIA,
	a.qt_dia_solicitado,
	a.NM_RESPONSAVEL,
	a.DT_ENTRADA_PREVISTA,
	e.ie_interno,
	a.cd_convenio,
	substr(Obter_Valor_Conv_Estab(c.cd_convenio, f.cd_estabelecimento, 'CD_INTERNO'),1,15) cd_interno,
	TISS_OBTER_GUIA_PRIC_AUTOR(f.cd_estabelecimento,a.cd_convenio,a.nr_sequencia,'GP') cd_autorizacao_princ,
	tiss_obter_tipo_guia_autor(a.nr_sequencia) ie_tiss_tipo_guia,
	a.ie_previsao_uso_quimio,
	a.ie_previsao_uso_opme,
	a.ie_tiss_tipo_acidente,
	a.cd_autorizacao_prest,
	0 nr_seq_pedido_exame_ext,
	a.cd_validacao_tiss,
	a.cd_ausencia_cod_valid,
	a.ie_tiss_tipo_etapa_autor,
    	a.ie_tiss_cobertura_especial
FROM convenio_estabelecimento p, agenda f, estagio_autorizacao e, pessoa_juridica d, convenio c, agenda_paciente b, autorizacao_convenio a
LEFT OUTER JOIN atendimento_paciente g ON (a.nr_atendimento = g.nr_atendimento)
WHERE a.nr_seq_agenda		= b.nr_sequencia and c.cd_convenio = p.cd_convenio and p.cd_estabelecimento = a.cd_estabelecimento and b.cd_agenda		= f.cd_agenda and a.cd_convenio		= c.cd_convenio and c.cd_cgc		= d.cd_cgc and a.nr_seq_estagio	= e.nr_sequencia
union

select	'2.01.01' ds_versao,
	'AC' ie_origem,
	(null)::numeric  nr_atendimento,
	a.nr_seq_agenda,
	TISS_OBTER_DATA_AUTOR(a.nr_sequencia) dt_autorizacao,
	a.ie_carater_int_tiss ie_carater_inter_sus,
	a.ds_indicacao,
	a.nr_sequencia,
	c.cd_cgc,
	d.ds_razao_social,
	d.cd_cnes,
	a.qt_dia_autorizado,
	substr(tiss_obter_tipo_acomod(a.cd_tipo_acomodacao),1,40) cd_tipo_acomod_autor,
	a.nr_sequencia nr_sequencia_autor,
	a.ie_tipo_autorizacao,
	coalesce(p.cd_ans, d.cd_ans) cd_ans,
	TISS_OBTER_GUIA_PRIC_AUTOR(f.cd_estabelecimento,a.cd_convenio,a.nr_sequencia,'GO') cd_autorizacao,
	coalesce(a.ie_tipo_internacao_tiss,substr(TISS_OBTER_CLINICA(g.ie_clinica, g.nr_seq_classificacao),1,3)) ie_tipo_internacao,
	coalesce(a.ie_regime_internacao,substr(tiss_obter_regime_atend(a.nr_atendimento, a.cd_convenio),1,5)) ie_regime_internacao,
	substr(coalesce(tiss_obter_regra_campo(4, 'DS_OBSERVACAO', a.cd_convenio, a.ds_observacao, null, null,'N',0, f.cd_estabelecimento, null, null, null, null), tiss_obter_obs_solic_spsadt(a.cd_convenio, f.cd_estabelecimento, a.nm_usuario) || ' ' || substr(a.ds_observacao,1,255)),1,254) ds_observacao,
	(null)::numeric  nr_interno_conta,
	a.CD_SENHA,
	a.DT_FIM_VIGENCIA,
	a.qt_dia_solicitado,
	a.NM_RESPONSAVEL,
	a.DT_ENTRADA_PREVISTA,
	e.ie_interno,
	a.cd_convenio,
	substr(Obter_Valor_Conv_Estab(c.cd_convenio, f.cd_estabelecimento, 'CD_INTERNO'),1,15) cd_interno,
	TISS_OBTER_GUIA_PRIC_AUTOR(f.cd_estabelecimento,a.cd_convenio,a.nr_sequencia,'GP') cd_autorizacao_princ,
	tiss_obter_tipo_guia_autor(a.nr_sequencia) ie_tiss_tipo_guia,
	a.ie_previsao_uso_quimio,
	a.ie_previsao_uso_opme,
	a.ie_tiss_tipo_acidente,
	a.cd_autorizacao_prest,
	0 nr_seq_pedido_exame_ext,
	a.cd_validacao_tiss,
	a.cd_ausencia_cod_valid,
	a.ie_tiss_tipo_etapa_autor,
    	a.ie_tiss_cobertura_especial
FROM convenio_estabelecimento p, agenda f, estagio_autorizacao e, pessoa_juridica d, convenio c, agenda_consulta b, autorizacao_convenio a
LEFT OUTER JOIN atendimento_paciente g ON (a.nr_atendimento = g.nr_atendimento)
WHERE a.nr_seq_agenda_consulta 	= b.nr_sequencia and c.cd_convenio = p.cd_convenio and p.cd_estabelecimento = a.cd_estabelecimento and b.cd_agenda		= f.cd_agenda and a.cd_convenio		= c.cd_convenio and c.cd_cgc			= d.cd_cgc and a.nr_seq_estagio		= e.nr_sequencia  
union

select	'2.01.01' ds_versao,
	'AC' ie_origem,
	(null)::numeric  nr_atendimento,
	(null)::numeric  nr_seq_agenda,
	TISS_OBTER_DATA_AUTOR(a.nr_sequencia) dt_autorizacao,
	a.ie_carater_int_tiss ie_carater_inter_sus,
	a.ds_indicacao,
	a.nr_sequencia,
	c.cd_cgc,
	d.ds_razao_social,
	d.cd_cnes,
	a.qt_dia_autorizado,
	substr(tiss_obter_tipo_acomod(a.cd_tipo_acomodacao),1,40) cd_tipo_acomod_autor,
	a.nr_sequencia nr_sequencia_autor,
	a.ie_tipo_autorizacao,
	coalesce(g.cd_ans, d.cd_ans)cd_ans,
	TISS_OBTER_GUIA_PRIC_AUTOR(b.cd_estabelecimento,a.cd_convenio,a.nr_sequencia,'GO') cd_autorizacao,
	a.ie_tipo_internacao_tiss ie_tipo_internacao,
	a.ie_regime_internacao ie_regime_internacao,
	substr(coalesce(tiss_obter_regra_campo(4, 'DS_OBSERVACAO', a.cd_convenio, a.ds_observacao, null, null,'N',0, b.cd_estabelecimento, null, null, null, null), tiss_obter_obs_solic_spsadt(a.cd_convenio, b.cd_estabelecimento, a.nm_usuario) || ' ' || substr(a.ds_observacao,1,255)),1,254) ds_observacao,
	(null)::numeric  nr_interno_conta,
	a.CD_SENHA,
	a.DT_FIM_VIGENCIA,
	a.qt_dia_solicitado,
	a.NM_RESPONSAVEL,
	a.DT_ENTRADA_PREVISTA,
	e.ie_interno,
	a.cd_convenio,
	substr(Obter_Valor_Conv_Estab(c.cd_convenio, b.cd_estabelecimento, 'CD_INTERNO'),1,15) cd_interno,
	TISS_OBTER_GUIA_PRIC_AUTOR(b.cd_estabelecimento,a.cd_convenio,a.nr_sequencia,'GP') cd_autorizacao_princ,
	tiss_obter_tipo_guia_autor(a.nr_sequencia) ie_tiss_tipo_guia,
	a.ie_previsao_uso_quimio,
	a.ie_previsao_uso_opme,
	a.ie_tiss_tipo_acidente,
	a.cd_autorizacao_prest,
	0 nr_seq_pedido_exame_ext,
	a.cd_validacao_tiss,
	a.cd_ausencia_cod_valid,
	a.ie_tiss_tipo_etapa_autor,
    	a.ie_tiss_cobertura_especial
from	estagio_autorizacao e,
	pessoa_juridica d,
	convenio c,
	autorizacao_convenio_tiss b,
	autorizacao_convenio a,
	convenio_estabelecimento g
where	a.nr_sequencia		= b.nr_sequencia_autor
and c.cd_convenio = g.cd_convenio
and g.cd_estabelecimento = a.cd_estabelecimento
and	a.cd_convenio		= c.cd_convenio
and	c.cd_cgc			= d.cd_cgc
and	a.nr_seq_estagio		= e.nr_sequencia
and	a.nr_atendimento		is null
and	a.nr_seq_agenda			is null
and	a.nr_seq_agenda_consulta	is null
and	a.nr_seq_gestao			is null
and	a.nr_seq_paciente_setor		is null
and	a.nr_seq_rxt_tratamento		is null
and	a.cd_pessoa_fisica 		is not null

union

select	'2.01.01' ds_versao,
	'AC' ie_origem,
	(null)::numeric  nr_atendimento,
	(null)::numeric  nr_seq_agenda,
	TISS_OBTER_DATA_AUTOR(a.nr_sequencia) dt_autorizacao,
	a.ie_carater_int_tiss ie_carater_inter_sus,
	a.ds_indicacao,
	a.nr_sequencia,
	c.cd_cgc,
	d.ds_razao_social,
	d.cd_cnes,
	a.qt_dia_autorizado,
	substr(tiss_obter_tipo_acomod(a.cd_tipo_acomodacao),1,40) cd_tipo_acomod_autor,
	a.nr_sequencia nr_sequencia_autor,
	a.ie_tipo_autorizacao,
	coalesce(g.cd_ans, d.cd_ans)cd_ans,
	TISS_OBTER_GUIA_PRIC_AUTOR(a.cd_estabelecimento,a.cd_convenio,a.nr_sequencia,'GO') cd_autorizacao,
	a.ie_tipo_internacao_tiss ie_tipo_internacao,
	a.ie_regime_internacao ie_regime_internacao,
	substr(coalesce(tiss_obter_regra_campo(4, 'DS_OBSERVACAO', a.cd_convenio, a.ds_observacao, null, null,'N',0, a.cd_estabelecimento, null, null, null, null), tiss_obter_obs_solic_spsadt(a.cd_convenio, a.cd_estabelecimento, a.nm_usuario) || ' ' || substr(a.ds_observacao,1,255)),1,254) ds_observacao,
	(null)::numeric  nr_interno_conta,
	a.CD_SENHA,
	a.DT_FIM_VIGENCIA,
	a.qt_dia_solicitado,
	a.NM_RESPONSAVEL,
	a.DT_ENTRADA_PREVISTA,
	e.ie_interno,
	a.cd_convenio,
	substr(Obter_Valor_Conv_Estab(c.cd_convenio, a.cd_estabelecimento, 'CD_INTERNO'),1,15) cd_interno,
	TISS_OBTER_GUIA_PRIC_AUTOR(a.cd_estabelecimento,a.cd_convenio,a.nr_sequencia,'GP') cd_autorizacao_princ,
	tiss_obter_tipo_guia_autor(a.nr_sequencia) ie_tiss_tipo_guia,
	a.ie_previsao_uso_quimio,
	a.ie_previsao_uso_opme,
	a.ie_tiss_tipo_acidente,
	a.cd_autorizacao_prest,
	0 nr_seq_pedido_exame_ext,
	a.cd_validacao_tiss,
	a.cd_ausencia_cod_valid,
	a.ie_tiss_tipo_etapa_autor,
    	a.ie_tiss_cobertura_especial
from	estagio_autorizacao e,
	pessoa_juridica d,
	convenio c,	
	autorizacao_convenio a,
	convenio_estabelecimento g
where	a.cd_convenio		= c.cd_convenio
and c.cd_convenio = g.cd_convenio
and g.cd_estabelecimento = a.cd_estabelecimento
and	c.cd_cgc			= d.cd_cgc
and	a.nr_seq_estagio		= e.nr_sequencia
and	a.nr_atendimento		is null
and	a.nr_seq_agenda			is null
and	a.nr_seq_agenda_consulta	is null
and	a.nr_seq_gestao			is null
and	a.nr_seq_rxt_tratamento		is null
and	a.cd_estabelecimento		is not null
and	a.nr_seq_paciente_setor		is not null
and	a.cd_pessoa_fisica 		is not null

union

select	'2.01.01' ds_versao,
	'AC' ie_origem,
	a.nr_atendimento nr_atendimento,
	(null)::numeric  nr_seq_agenda,
	TISS_OBTER_DATA_AUTOR(a.nr_sequencia) dt_autorizacao,
	a.ie_carater_int_tiss ie_carater_inter_sus,
	a.ds_indicacao,
	a.nr_sequencia,
	c.cd_cgc,
	d.ds_razao_social,
	d.cd_cnes,
	a.qt_dia_autorizado,
	substr(tiss_obter_tipo_acomod(a.cd_tipo_acomodacao),1,40) cd_tipo_acomod_autor,
	a.nr_sequencia nr_sequencia_autor,
	a.ie_tipo_autorizacao,
	coalesce(g.cd_ans, d.cd_ans)cd_ans,
	TISS_OBTER_GUIA_PRIC_AUTOR(a.cd_estabelecimento,a.cd_convenio,a.nr_sequencia,'GO') cd_autorizacao,
	a.ie_tipo_internacao_tiss ie_tipo_internacao,
	a.ie_regime_internacao ie_regime_internacao,
	substr(coalesce(tiss_obter_regra_campo(4, 'DS_OBSERVACAO', a.cd_convenio, a.ds_observacao, null, null,'N',0, a.cd_estabelecimento, null, null, null, null), tiss_obter_obs_solic_spsadt(a.cd_convenio, a.cd_estabelecimento, a.nm_usuario) || ' ' || substr(a.ds_observacao,1,255)),1,254) ds_observacao,
	(null)::numeric  nr_interno_conta,
	a.CD_SENHA,
	a.DT_FIM_VIGENCIA,
	a.qt_dia_solicitado,
	a.NM_RESPONSAVEL,
	a.DT_ENTRADA_PREVISTA,
	e.ie_interno,
	a.cd_convenio,
	substr(Obter_Valor_Conv_Estab(c.cd_convenio, a.cd_estabelecimento, 'CD_INTERNO'),1,15) cd_interno,
	TISS_OBTER_GUIA_PRIC_AUTOR(a.cd_estabelecimento,a.cd_convenio,a.nr_sequencia,'GP') cd_autorizacao_princ,
	tiss_obter_tipo_guia_autor(a.nr_sequencia) ie_tiss_tipo_guia,
	a.ie_previsao_uso_quimio,
	a.ie_previsao_uso_opme,
	a.ie_tiss_tipo_acidente,
	a.cd_autorizacao_prest,
	0 nr_seq_pedido_exame_ext,
	a.cd_validacao_tiss,
	a.cd_ausencia_cod_valid,
	a.ie_tiss_tipo_etapa_autor,
    	a.ie_tiss_cobertura_especial
from	estagio_autorizacao e,
	pessoa_juridica d,
	convenio c,	
	autorizacao_convenio a,
	convenio_estabelecimento g
where	a.cd_convenio			= c.cd_convenio
and c.cd_convenio = g.cd_convenio
and g.cd_estabelecimento = a.cd_estabelecimento
and	c.cd_cgc			= d.cd_cgc
and	a.nr_seq_estagio		= e.nr_sequencia
--and	a.nr_atendimento		is null

and	a.nr_seq_agenda			is null
and	a.nr_seq_agenda_consulta	is null
and	a.nr_seq_gestao			is null
and	a.cd_estabelecimento		is not null
and	a.nr_seq_rxt_tratamento		is not null
and	a.cd_pessoa_fisica 		is not null

union

select	'2.01.01' ds_versao,
	'EX' ie_origem,
	a.nr_atendimento,
	null,
	a.dt_solicitacao dt_autorizacao,
	SUBSTR(TISS_OBTER_CARATER_INTERN(b.IE_CARATER_INTER_SUS),1,1) ie_carater_inter_sus,
	a.ds_dados_clinicos ds_indicacao,
	0 nr_sequencia,
	d.cd_cgc cd_cgc,
	e.ds_razao_social ds_razao_social,
	e.cd_cnes,
	0 qt_dia_autorizado,
	null cd_tipo_acomod_autor,
	0 nr_sequencia_autor,
	'3' ie_tipo_autorizacao,
	coalesce(g.cd_ans, e.cd_ans)cd_ans,
	c.nr_doc_convenio cd_autorizacao,
	null  ie_tipo_internacao,
	null ie_regime_internacao,
	substr(coalesce(tiss_obter_regra_campo(4, 'DS_OBSERVACAO', c.cd_convenio, a.ds_justificativa, b.ie_tipo_atendimento, c.cd_categoria,'N',0, b.cd_estabelecimento, null, null, null, null), tiss_obter_obs_solic_spsadt(c.cd_convenio, b.cd_estabelecimento, a.nm_usuario)),1,254) ds_observacao,
	(null)::numeric  nr_interno_conta,
	c.CD_SENHA,
	c.DT_INICIO_VIGENCIA,
	0 qt_dia_solicitado,
	null NM_RESPONSAVEL,
	null DT_ENTRADA_PREVISTA,
	'1' ie_interno,
	c.cd_convenio,
	substr(TISS_OBTER_CODIGO_PRESTADOR(c.cd_convenio, b.cd_estabelecimento, null, e.cd_cgc, (null)::numeric , 'CI',NULL,b.ie_tipo_atendimento,null),1,20) cd_interno,
	null cd_autorizacao_princ,
	'4' ie_tiss_tipo_guia,
	null ie_previsao_uso_quimio,
	null ie_previsao_uso_opme,
	null ie_tiss_tipo_acidente,
	null cd_autorizacao_prest,
	a.nr_sequencia nr_seq_pedido_exame_ext,
	'' cd_validacao_tiss,
	'' cd_ausencia_cod_valid,
	null ie_tiss_tipo_etapa_autor,
    	null ie_tiss_cobertura_especial
from	PEDIDO_EXAME_EXTERNO A,
	ATENDIMENTO_PACIENTE B,
	ATEND_CATEGORIA_CONVENIO C,
	CONVENIO D,
	PESSOA_JURIDICA E,
	ESTABELECIMENTO F,
	AUTORIZACAO_CONVENIO P,
    CONVENIO_ESTABELECIMENTO G
where	b.nr_atendimento	= c.nr_atendimento
and d.cd_convenio = g.cd_convenio
and g.cd_estabelecimento = p.cd_estabelecimento
and	obter_atecaco_atendimento(b.nr_atendimento) 	= c.nr_seq_interno
and	a.nr_atendimento	= b.nr_atendimento
and	d.cd_convenio		= c.cd_convenio
and	d.cd_cgc		= e.cd_cgc
and	f.cd_estabelecimento	= b.cd_estabelecimento;

