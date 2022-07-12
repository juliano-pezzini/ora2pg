-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_gestor_mmed_v (dt_verificacao, ds_nome, dt_baixa, dt_primeira_aprov, dt_laudado, dt_entrada_unidade, dt_seg_aprovacao, cd_pessoa_verificacao) AS select		b.dt_baixa dt_verificacao, --executado 
			substr(obter_nome_pf(a.cd_medico_executor),1,255) ds_nome,
			b.dt_baixa dt_baixa, 
			null dt_primeira_aprov, 
			null dt_laudado, 
			null dt_entrada_unidade, 
			null dt_seg_aprovacao, 
			a.cd_medico_executor cd_pessoa_verificacao 
FROM prescr_procedimento b
LEFT OUTER JOIN procedimento_paciente a ON (b.nr_sequencia = a.nr_sequencia_prescricao AND b.nr_prescricao = a.nr_prescricao)
LEFT OUTER JOIN prescr_proc_ditado e ON (b.nr_seq_interno = e.nr_seq_prescr_proc)
LEFT OUTER JOIN laudo_paciente d ON (a.nr_laudo = d.nr_sequencia) 
union all
 
select			d.dt_aprovacao dt_verificacao,	 --1 aprovacao 
				substr(obter_nome_pf(obter_pf_usuario(d.nm_usuario_aprovacao,'C')),1,255) ds_nome, 
				null dt_baixa, 
				d.dt_aprovacao dt_primeira_aprov, 
				null dt_laudado, 
				null dt_entrada_unidade, 
				null dt_seg_aprovacao, 
			obter_pf_usuario(d.nm_usuario_aprovacao,'C') cd_pessoa_verificacao 
FROM prescr_procedimento b
LEFT OUTER JOIN procedimento_paciente a ON (b.nr_sequencia = a.nr_sequencia_prescricao AND b.nr_prescricao = a.nr_prescricao)
LEFT OUTER JOIN prescr_proc_ditado e ON (b.nr_seq_interno = e.nr_seq_prescr_proc)
LEFT OUTER JOIN laudo_paciente d ON (a.nr_laudo = d.nr_sequencia)
WHERE d.dt_aprovacao is not null  
union all
 
select			coalesce(e.dt_atualizacao_nrec,d.dt_entrada_unidade) dt_verificacao,	 --laudado/ditado 
				substr(obter_nome_pf(coalesce(obter_pf_usuario(e.nm_usuario,'C'),d.cd_medico_resp)),1,255) ds_nome, 
				null dt_baixa, 
				null dt_primeira_aprov, 
				coalesce(e.dt_atualizacao_nrec,d.dt_entrada_unidade) dt_laudado, 
				null dt_entrada_unidade, 
				null dt_seg_aprovacao, 
			coalesce(obter_pf_usuario(e.nm_usuario,'C'),d.cd_medico_resp) cd_pessoa_verificacao 
FROM prescr_procedimento b
LEFT OUTER JOIN procedimento_paciente a ON (b.nr_sequencia = a.nr_sequencia_prescricao AND b.nr_prescricao = a.nr_prescricao)
LEFT OUTER JOIN prescr_proc_ditado e ON (b.nr_seq_interno = e.nr_seq_prescr_proc)
LEFT OUTER JOIN laudo_paciente d ON (a.nr_laudo = d.nr_sequencia)
WHERE coalesce(e.dt_atualizacao_nrec,d.dt_entrada_unidade) is not null  
union all
 
select			d.dt_entrada_unidade dt_verificacao,	-- digitado 
				substr(obter_nome_pf(d.cd_medico_resp),1,255) ds_nome, 
				null dt_baixa, 
				null dt_primeira_aprov, 
				null dt_laudado, 
				d.dt_entrada_unidade, 
				null dt_seg_aprovacao, 
				d.cd_medico_resp cd_pessoa_verificacao 
FROM prescr_procedimento b
LEFT OUTER JOIN procedimento_paciente a ON (b.nr_sequencia = a.nr_sequencia_prescricao AND b.nr_prescricao = a.nr_prescricao)
LEFT OUTER JOIN prescr_proc_ditado e ON (b.nr_seq_interno = e.nr_seq_prescr_proc)
LEFT OUTER JOIN laudo_paciente d ON (a.nr_laudo = d.nr_sequencia)
WHERE d.dt_entrada_unidade is not null  
union all
 
select			d.dt_seg_aprovacao dt_verificacao,	-- 2 aprovacao 
				substr(obter_nome_pf(obter_pf_usuario(d.nm_usuario_seg_aprov,'C')),1,255) ds_nome, 
				null dt_baixa, 
				null dt_primeira_aprov, 
				null dt_laudado, 
				null dt_entrada_unidade, 
				d.dt_seg_aprovacao	, 
			obter_pf_usuario(d.nm_usuario_seg_aprov,'C') cd_pessoa_verificacao 
FROM prescr_procedimento b
LEFT OUTER JOIN procedimento_paciente a ON (b.nr_sequencia = a.nr_sequencia_prescricao AND b.nr_prescricao = a.nr_prescricao)
LEFT OUTER JOIN prescr_proc_ditado e ON (b.nr_seq_interno = e.nr_seq_prescr_proc)
LEFT OUTER JOIN laudo_paciente d ON (a.nr_laudo = d.nr_sequencia)
WHERE d.dt_seg_aprovacao is not null;
