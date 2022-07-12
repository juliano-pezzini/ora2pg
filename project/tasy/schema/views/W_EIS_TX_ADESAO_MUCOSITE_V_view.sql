-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW w_eis_tx_adesao_mucosite_v (nr_seq_superior, ds_setor_atendimento, qt_prescrito, nr_seq_classificacao, ds_classificacao, nr_atendimento, dt_atualizacao_nrec, ie_escala, nr_seq_escala) AS SELECT	DISTINCT
	a.nr_seq_superior, 
	SUBSTR(obter_nome_setor(Obter_Setor_Atendimento(b.nr_Atendimento)),1,255) ds_Setor_Atendimento,	 
	SUBSTR(obter_dados_mucosite(a.nr_seq_superior,null,'PA'),1,255) qt_prescrito, 
	d.nr_seq_classificacao, 
	obter_desc_classif_atend(d.nr_seq_classificacao) ds_classificacao,	 
	b.nr_atendimento, 
	b.dt_atualizacao_nrec, 
	b.ie_escala, 
	b.nr_seq_escala 
FROM	gqa_pend_pac_acao a, 
	gqa_pendencia_pac b, 
	gqa_pendencia_regra c, 
	atendimento_paciente d 
where	a.nr_seq_proc is not null 
and	a.nr_seq_pend_pac = b.nr_sequencia 
and	d.nr_atendimento = b.nr_atendimento 
and	b.nr_seq_pend_regra = c.nr_sequencia 
and (c.nr_seq_escala = 118) 
and	a.nr_seq_superior is not null 
and	((upper(obter_desc_classif_atend(d.nr_seq_classificacao)) like '%ONCOLOGIA%') or (upper(obter_desc_classif_atend(d.nr_seq_classificacao)) like '%HEMATOLOGIA%') or (upper(obter_desc_classif_atend(d.nr_seq_classificacao)) like '%TMO%') or (upper(obter_desc_classif_atend(d.nr_seq_classificacao)) like '%MEDULA%'));
