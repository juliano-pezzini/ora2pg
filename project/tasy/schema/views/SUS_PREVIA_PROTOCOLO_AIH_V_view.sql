-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW sus_previa_protocolo_aih_v (vl_terceiros_hosp, vl_proprio_hosp, vl_terceiros_prof, vl_proprio_prof, vl_terceiro_rat, vl_proprio_rat, ds_forma_organizacao, ds_subgrupo, ds_grupo, vl_total, nr_seq_protocolo, nr_interno_conta) AS select	sum(CASE WHEN coalesce(p.ie_doc_executor,5)=3 THEN coalesce(s.vl_matmed,0)+ coalesce(s.vl_sadt,0) WHEN coalesce(p.ie_doc_executor,5)=6 THEN coalesce(s.vl_matmed,0)+ coalesce(s.vl_sadt,0)  ELSE 0 END ) vl_terceiros_hosp,
	sum(CASE WHEN coalesce(p.ie_doc_executor,5)=5 THEN coalesce(s.vl_matmed,0)+ coalesce(s.vl_sadt,0) WHEN coalesce(p.ie_doc_executor,5)=1 THEN coalesce(s.vl_matmed,0)+ coalesce(s.vl_sadt,0)  ELSE 0 END ) vl_proprio_hosp,
	sum(CASE WHEN sus_obter_procconta_rateio_aih(p.nr_sequencia)='N' THEN 	CASE WHEN coalesce(p.ie_doc_executor,5)=3 THEN coalesce(s.vl_medico,0) + coalesce(s.vl_ato_anestesista,0) WHEN coalesce(p.ie_doc_executor,5)=6 THEN coalesce(s.vl_medico,0) + coalesce(s.vl_ato_anestesista,0)  ELSE 0 END   ELSE 0 END ) vl_terceiros_prof,
	sum(CASE WHEN sus_obter_procconta_rateio_aih(p.nr_sequencia)='N' THEN 	CASE WHEN coalesce(p.ie_doc_executor,5)=5 THEN coalesce(s.vl_medico,0) + coalesce(s.vl_ato_anestesista,0) WHEN coalesce(p.ie_doc_executor,5)=1 THEN coalesce(s.vl_medico,0) + coalesce(s.vl_ato_anestesista,0)  ELSE 0 END   ELSE 0 END ) vl_proprio_prof,
	sum(CASE WHEN sus_obter_procconta_rateio_aih(p.nr_sequencia)='S' THEN 	CASE WHEN coalesce(p.ie_doc_executor,5)=3 THEN coalesce(s.vl_medico,0) + coalesce(s.vl_ato_anestesista,0) WHEN coalesce(p.ie_doc_executor,5)=6 THEN coalesce(s.vl_medico,0) + coalesce(s.vl_ato_anestesista,0)  ELSE 0 END   ELSE 0 END ) vl_terceiro_rat,
	sum(CASE WHEN sus_obter_procconta_rateio_aih(p.nr_sequencia)='S' THEN 	CASE WHEN coalesce(p.ie_doc_executor,5)=5 THEN coalesce(s.vl_medico,0) + coalesce(s.vl_ato_anestesista,0) WHEN coalesce(p.ie_doc_executor,5)=1 THEN coalesce(s.vl_medico,0) + coalesce(s.vl_ato_anestesista,0)  ELSE 0 END   ELSE 0 END ) vl_proprio_rat,
	substr(Sus_Obter_Estrut_Proc(p.cd_procedimento,p.ie_origem_proced,'CD','F'),1,200) ds_forma_organizacao,
	substr(Sus_Obter_Estrut_Proc(p.cd_procedimento,p.ie_origem_proced,'CD','S'),1,200) ds_subgrupo,
	substr(Sus_Obter_Estrut_Proc(p.cd_procedimento,p.ie_origem_proced,'CD','G'),1,200) ds_grupo,
	sum(coalesce(s.vl_medico,0)+ coalesce(s.vl_matmed,0) + coalesce(s.vl_sadt,0) + coalesce(s.vl_ato_anestesista,0)) vl_total,
	c.nr_seq_protocolo,
	c.nr_interno_conta
FROM	procedimento_paciente p,
	sus_valor_proc_paciente s,
	conta_paciente c
where	p.nr_interno_conta	= c.nr_interno_conta
and	s.nr_sequencia	= p.nr_sequencia
and	p.ie_origem_proced	= 7
and	p.cd_motivo_exc_conta is null
group by Sus_Obter_Estrut_Proc(p.cd_procedimento,p.ie_origem_proced,'CD','F'),
	Sus_Obter_Estrut_Proc(p.cd_procedimento,p.ie_origem_proced,'CD','S'),
	Sus_Obter_Estrut_Proc(p.cd_procedimento,p.ie_origem_proced,'CD','G'),
	c.nr_seq_protocolo,
	c.nr_interno_conta;
