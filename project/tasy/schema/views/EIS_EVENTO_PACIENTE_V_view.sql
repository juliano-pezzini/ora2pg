-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_evento_paciente_v (nr_sequencia, cd_estabelecimento, dt_atualizacao, nm_usuario, dt_referencia, qt_evento, cd_setor_atendimento, ie_classificacao, nr_seq_tipo, nr_seq_evento, ie_sexo, ie_faixa_etaria, dt_atualizacao_nrec, nm_usuario_nrec, nm_usuario_origem, nr_seq_classif_evento, cd_empresa, nr_seq_gravidade, ie_status, ie_possui_hist, ie_situacao, nr_seq_turno, cd_estab_evento, ie_liberado, ds_setor_atendimento, ds_evento, ds_classificacao, ds_cargo, ds_sexo, ds_tipo_evento, ie_classif, ds_detalhamento, ds_gravidade, ds_status, ds_possui_hist, ds_situacao, ie_sit_evento, ds_sit_evento, ie_sit_tipo_evento, ds_sit_tipo_evento, ds_turno, ds_liberado) AS select	a.NR_SEQUENCIA,a.CD_ESTABELECIMENTO,a.DT_ATUALIZACAO,a.NM_USUARIO,a.DT_REFERENCIA,a.QT_EVENTO,a.CD_SETOR_ATENDIMENTO,a.IE_CLASSIFICACAO,a.NR_SEQ_TIPO,a.NR_SEQ_EVENTO,a.IE_SEXO,a.IE_FAIXA_ETARIA,a.DT_ATUALIZACAO_NREC,a.NM_USUARIO_NREC,a.NM_USUARIO_ORIGEM,a.NR_SEQ_CLASSIF_EVENTO,a.CD_EMPRESA,a.NR_SEQ_GRAVIDADE,a.IE_STATUS,a.IE_POSSUI_HIST,a.IE_SITUACAO,a.NR_SEQ_TURNO,a.CD_ESTAB_EVENTO,a.IE_LIBERADO,
	b.ds_setor_atendimento,
	c.ds_evento,
	(select	coalesce(max(x.ds_classificacao),obter_desc_expressao(327119))
	FROM	qua_classif_evento x
	where	x.ie_classificacao 	= a.ie_classificacao
	and	x.cd_empresa 	= obter_empresa_estab(a.cd_estabelecimento)) ds_classificacao,
	substr(obter_cargo_usuario(a.nm_usuario_origem), 1, 255) ds_cargo,
	substr(obter_valor_dominio(4, a.ie_sexo),1,100) ds_sexo,
	d.ds_tipo_evento,
	coalesce(a.ie_classificacao,obter_desc_expressao(327119)) ie_classif,
	coalesce(substr(obter_descricao_padrao('QUA_EVENTO_CLASSIF','DS_CLASSIFICACAO',a.nr_seq_classif_evento),1,255),obter_desc_expressao(327119)) ds_detalhamento,
	substr(coalesce(obter_descricao_padrao('QUA_GRAVIDADE_EVENTO','DS_GRAVIDADE',a.nr_seq_gravidade),obter_desc_expressao(327119)),1,255) ds_gravidade,
	substr(obter_valor_dominio(3502,a.ie_status),1,100) ds_status,
	CASE WHEN a.ie_possui_hist='S' THEN obter_desc_expressao(347758)  ELSE obter_desc_expressao(599787) END  ds_possui_hist,
	CASE WHEN a.ie_situacao='A' THEN obter_desc_expressao(787005) WHEN a.ie_situacao='I' THEN obter_desc_expressao(319239) END  ds_situacao,
	c.ie_situacao ie_sit_evento,
	substr(obter_valor_dominio(2,c.ie_situacao),1,255) ds_sit_evento,
	d.ie_situacao ie_sit_tipo_evento,
	substr(obter_valor_dominio(2,d.ie_situacao),1,255) ds_sit_tipo_evento,
	substr(coalesce(obter_ds_turno_evento(a.nr_seq_turno,'D'),obter_desc_expressao(327119)),1,255) ds_turno,
	CASE WHEN a.ie_liberado='S' THEN  obter_desc_expressao(928855)  ELSE obter_desc_expressao(928857) END  ds_liberado
from	qua_tipo_evento d,
	qua_evento c,
	setor_atendimento b,
	eis_evento_paciente a
where	a.cd_setor_atendimento = b.cd_setor_atendimento
and	a.nr_seq_evento = c.nr_sequencia
and	c.nr_seq_tipo = d.nr_sequencia;
