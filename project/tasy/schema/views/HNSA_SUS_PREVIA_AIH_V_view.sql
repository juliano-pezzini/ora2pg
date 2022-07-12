-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW hnsa_sus_previa_aih_v (ds_procedimento, vl_terceiros_hosp, vl_proprio_hosp, vl_terceiros_prof, vl_proprio_prof, cd_proc_editado, vl_terceiro_rat, vl_proprio_rat, cd_procedimento, ie_funcao_equipe, vl_total, nr_interno_conta, cd_medico_executor, dt_procedimento) AS select	substr(obter_descricao_procedimento(p.cd_procedimento,p.ie_origem_proced),1,200) ds_procedimento,
	sum(CASE WHEN coalesce(p.ie_doc_executor,5)=3 THEN coalesce(s.vl_matmed,0)+ coalesce(s.vl_sadt,0) WHEN coalesce(p.ie_doc_executor,5)=6 THEN coalesce(s.vl_matmed,0)+ coalesce(s.vl_sadt,0)  ELSE 0 END ) vl_terceiros_hosp,
	sum(CASE WHEN coalesce(p.ie_doc_executor,5)=5 THEN coalesce(s.vl_matmed,0)+ coalesce(s.vl_sadt,0) WHEN coalesce(p.ie_doc_executor,5)=1 THEN coalesce(s.vl_matmed,0)+ coalesce(s.vl_sadt,0)  ELSE 0 END ) vl_proprio_hosp,
	sum(CASE WHEN sus_obter_procconta_rateio_aih(p.nr_sequencia)='N' THEN 	CASE WHEN coalesce(p.ie_doc_executor,5)=3 THEN coalesce(s.vl_medico,0) WHEN coalesce(p.ie_doc_executor,5)=6 THEN coalesce(s.vl_medico,0)  ELSE 0 END   ELSE 0 END ) vl_terceiros_prof,
	sum(CASE WHEN sus_obter_procconta_rateio_aih(p.nr_sequencia)='N' THEN 	CASE WHEN coalesce(p.ie_doc_executor,5)=5 THEN coalesce(s.vl_medico,0) WHEN coalesce(p.ie_doc_executor,5)=1 THEN coalesce(s.vl_medico,0)  ELSE 0 END   ELSE 0 END ) vl_proprio_prof,
	substr(Sus_Obter_Procedimento_Editado(cd_procedimento),1,30) cd_proc_editado,
	sum(CASE WHEN sus_obter_procconta_rateio_aih(p.nr_sequencia)='S' THEN 	CASE WHEN coalesce(p.ie_doc_executor,5)=3 THEN coalesce(s.vl_ato_medico,0) WHEN coalesce(p.ie_doc_executor,5)=6 THEN coalesce(s.vl_ato_medico,0)  ELSE 0 END   ELSE 0 END ) vl_terceiro_rat,
	sum(CASE WHEN sus_obter_procconta_rateio_aih(p.nr_sequencia)='S' THEN 	CASE WHEN coalesce(p.ie_doc_executor,5)=5 THEN coalesce(s.vl_ato_medico,0) WHEN coalesce(p.ie_doc_executor,5)=1 THEN coalesce(s.vl_ato_medico,0)  ELSE 0 END   ELSE 0 END ) vl_proprio_rat,
	p.cd_procedimento,
	1 ie_funcao_equipe,
	sum(coalesce(s.vl_matmed,0) + coalesce(s.vl_sadt,0) + CASE WHEN sus_obter_procconta_rateio_aih(p.nr_sequencia)='N' THEN 	coalesce(s.vl_medico,0)  ELSE coalesce(s.vl_ato_medico,0) END ) vl_total,
	p.nr_interno_conta,
	coalesce(p.cd_medico_executor,p.cd_pessoa_fisica) cd_medico_executor,
	trunc(p.dt_procedimento) dt_procedimento
FROM	procedimento_paciente p,
	sus_valor_proc_paciente s
where	s.nr_sequencia	= p.nr_sequencia
and	p.ie_origem_proced	= 7
and	p.cd_motivo_exc_conta is null
GROUP BY	p.cd_procedimento,
		p.ie_origem_proced,
		p.nr_interno_conta,
		coalesce(p.cd_medico_executor,p.cd_pessoa_fisica),
		trunc(p.dt_procedimento HAVING(sum(s.vl_medico)<> 0 or sum(s.vl_ato_medico) <> 0 or sum(s.vl_sadt) <> 0 or sum(s.vl_matmed) <> 0)
)

union

select	substr(obter_descricao_procedimento(p.cd_procedimento,p.ie_origem_proced),1,200) ds_procedimento,
	sum(0) vl_terceiros_hosp,
	sum(0) vl_proprio_hosp,
	sum(CASE WHEN sus_obter_procconta_rateio_aih(p.nr_sequencia)='N' THEN 	CASE WHEN coalesce(p.ie_doc_executor,5)=3 THEN coalesce(a.vl_participante,0) WHEN coalesce(p.ie_doc_executor,5)=6 THEN coalesce(a.vl_participante,0)  ELSE 0 END   ELSE 0 END ) vl_terceiros_prof,
	sum(CASE WHEN sus_obter_procconta_rateio_aih(p.nr_sequencia)='N' THEN 	CASE WHEN coalesce(p.ie_doc_executor,5)=5 THEN coalesce(a.vl_participante,0) WHEN coalesce(p.ie_doc_executor,5)=1 THEN coalesce(a.vl_participante,0)  ELSE 0 END   ELSE 0 END ) vl_proprio_prof,
	substr(Sus_Obter_Procedimento_Editado(cd_procedimento),1,30) cd_proc_editado,
	sum(CASE WHEN sus_obter_procconta_rateio_aih(p.nr_sequencia)='S' THEN 	CASE WHEN coalesce(p.ie_doc_executor,5)=3 THEN coalesce(a.vl_participante,0) WHEN coalesce(p.ie_doc_executor,5)=6 THEN coalesce(a.vl_participante,0)  ELSE 0 END   ELSE 0 END ) vl_terceiro_rat,
	sum(CASE WHEN sus_obter_procconta_rateio_aih(p.nr_sequencia)='S' THEN 	CASE WHEN coalesce(p.ie_doc_executor,5)=5 THEN coalesce(a.vl_participante,0) WHEN coalesce(p.ie_doc_executor,5)=1 THEN coalesce(a.vl_participante,0)  ELSE 0 END   ELSE 0 END ) vl_proprio_rat,
	p.cd_procedimento,
	coalesce(Sus_Obter_Indicador_Equipe(a.ie_funcao),0) ie_funcao_equipe,
	sum(a.vl_participante) vl_total,
	p.nr_interno_conta,
	a.cd_pessoa_fisica cd_medico_executor,
	trunc(p.dt_procedimento) dt_procedimento
from	procedimento_paciente p,
	sus_valor_proc_paciente s,
	procedimento_participante a
where	s.nr_sequencia	= p.nr_sequencia
and	a.nr_sequencia	= p.nr_sequencia
and	p.ie_origem_proced	= 7
and	p.cd_motivo_exc_conta is null
GROUP BY	p.cd_procedimento,
		p.ie_origem_proced,
		a.ie_funcao,
		p.nr_interno_conta,
		a.cd_pessoa_fisica,
		trunc(p.dt_procedimento) HAVING sum(a.vl_participante) <>0
;
