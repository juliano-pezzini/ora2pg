-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW sus_previa_aih_for_org_v (ds_procedimento, cd_proc_editado, nr_interno_conta, vl_terceiros_hosp, vl_proprio_hosp, vl_terceiros_prof, vl_proprio_prof, vl_proprio_rat, vl_terceiro_rat, vl_total) AS select	upper(a.ds_procedimento) ds_procedimento,
	a.cd_proc_editado,
	a.nr_interno_conta,
	sum(a.vl_terceiros_hosp) vl_terceiros_hosp,
	sum(a.vl_proprio_hosp) vl_proprio_hosp,
	sum(a.vl_terceiros_prof) vl_terceiros_prof,
	sum(a.vl_proprio_prof) vl_proprio_prof,
	sum(a.vl_proprio_rat) vl_proprio_rat,
	sum(a.vl_terceiro_rat) vl_terceiro_rat,
	sum(a.vl_total) vl_total
FROM (	select	substr(sus_obter_estrut_proc(p.cd_procedimento,p.ie_origem_proced,'D','F'),1,200) ds_procedimento,
		substr(sus_obter_estr_porc_edit(p.cd_procedimento,'F'),1,30) cd_proc_editado,
		p.nr_interno_conta,
		(coalesce(s.vl_matmed,0)+ coalesce(s.vl_sadt,0)) vl_terceiros_hosp,
		0 vl_proprio_hosp,
		coalesce(s.vl_medico,0) vl_terceiros_prof,
		0 vl_proprio_prof,
		0 vl_proprio_rat,
		0 vl_terceiro_rat,
		(coalesce(s.vl_matmed,0) + coalesce(s.vl_sadt,0) + coalesce(s.vl_medico,0)) vl_total
	from	procedimento_paciente p,
		sus_valor_proc_paciente s
	where	s.nr_sequencia	= p.nr_sequencia
	and	p.ie_origem_proced	= 7
	and	p.cd_motivo_exc_conta is null
	and	sus_obter_procconta_rateio_aih(p.nr_sequencia) = 'N'
	and	coalesce(p.ie_doc_executor,5) in (3,6)
	
union all

	select	substr(sus_obter_estrut_proc(p.cd_procedimento,p.ie_origem_proced,'D','F'),1,200) ds_procedimento,
		substr(sus_obter_estr_porc_edit(p.cd_procedimento,'F'),1,30) cd_proc_editado,
		p.nr_interno_conta,
		0 vl_terceiros_hosp,
		(coalesce(s.vl_matmed,0)+ coalesce(s.vl_sadt,0)) vl_proprio_hosp,
		0 vl_terceiros_prof,
		coalesce(s.vl_medico,0) vl_proprio_prof,
		0 vl_proprio_rat,
		0 vl_terceiro_rat,
		(coalesce(s.vl_matmed,0) + coalesce(s.vl_sadt,0) + coalesce(s.vl_medico,0)) vl_total
	from	procedimento_paciente p,
		sus_valor_proc_paciente s
	where	s.nr_sequencia	= p.nr_sequencia
	and	p.ie_origem_proced	= 7
	and	p.cd_motivo_exc_conta is null
	and	sus_obter_procconta_rateio_aih(p.nr_sequencia) = 'N'
	and	coalesce(p.ie_doc_executor,5) in (1,5)
	
union all

	select	substr(sus_obter_estrut_proc(p.cd_procedimento,p.ie_origem_proced,'D','F'),1,200) ds_procedimento,
		substr(sus_obter_estr_porc_edit(p.cd_procedimento,'F'),1,30) cd_proc_editado,
		p.nr_interno_conta,
		(coalesce(s.vl_matmed,0) + coalesce(s.vl_sadt,0)) vl_terceiros_hosp,
		0 vl_proprio_hosp,
		0 vl_terceiros_prof,
		0 vl_proprio_prof,
		0 vl_proprio_rat,
		coalesce(s.vl_ato_medico,0) vl_terceiro_rat,
		(coalesce(s.vl_matmed,0) + coalesce(s.vl_sadt,0) + coalesce(s.vl_ato_medico,0)) vl_total
	from	procedimento_paciente p,
		sus_valor_proc_paciente s
	where	s.nr_sequencia	= p.nr_sequencia
	and	p.ie_origem_proced	= 7
	and	p.cd_motivo_exc_conta is null
	and	sus_obter_procconta_rateio_aih(p.nr_sequencia) = 'S'
	and	coalesce(p.ie_doc_executor,5) in (3,6)
	
union all

	select	substr(sus_obter_estrut_proc(p.cd_procedimento,p.ie_origem_proced,'D','F'),1,200) ds_procedimento,
		substr(sus_obter_estr_porc_edit(p.cd_procedimento,'F'),1,30) cd_proc_editado,
		p.nr_interno_conta,
		0 vl_terceiros_hosp,
		(coalesce(s.vl_matmed,0)+ coalesce(s.vl_sadt,0)) vl_proprio_hosp,
		0 vl_terceiros_prof,
		0 vl_proprio_prof,
		coalesce(s.vl_ato_medico,0) vl_proprio_rat,
		0 vl_terceiro_rat,
		(coalesce(s.vl_matmed,0) + coalesce(s.vl_sadt,0) + coalesce(s.vl_ato_medico,0)) vl_total
	from	procedimento_paciente p,
		sus_valor_proc_paciente s
	where	s.nr_sequencia	= p.nr_sequencia
	and	p.ie_origem_proced	= 7
	and	p.cd_motivo_exc_conta is null
	and	sus_obter_procconta_rateio_aih(p.nr_sequencia) = 'S'
	and	coalesce(s.cd_registro_proc,3) = 3
	and	coalesce(p.ie_doc_executor,5) in (1,5)
	
union all

	select	substr(sus_obter_estrut_proc(p.cd_procedimento,p.ie_origem_proced,'D','F'),1,200) ds_procedimento,
		substr(sus_obter_estr_porc_edit(p.cd_procedimento,'F'),1,30) cd_proc_editado,
		p.nr_interno_conta,
		0 vl_terceiros_hosp,
		(coalesce(s.vl_matmed,0)+ coalesce(s.vl_sadt,0)) vl_proprio_hosp,
		0 vl_terceiros_prof,
		coalesce(s.vl_medico,0) vl_proprio_prof,
		coalesce(s.vl_ato_medico,0) vl_proprio_rat,
		0 vl_terceiro_rat,
		(coalesce(s.vl_matmed,0) + coalesce(s.vl_sadt,0) + coalesce(s.vl_ato_medico,0) + coalesce(s.vl_medico,0)) vl_total
	from	procedimento_paciente p,
		sus_valor_proc_paciente s
	where	s.nr_sequencia	= p.nr_sequencia
	and	p.ie_origem_proced	= 7
	and	p.cd_motivo_exc_conta is null
	and	sus_obter_procconta_rateio_aih(p.nr_sequencia) = 'S'
	and	coalesce(s.cd_registro_proc,3) = 4
	and	coalesce(p.ie_doc_executor,5) in (1,5)
	and	p.cd_procedimento <> 802010199
	
union all

	select	substr(sus_obter_estrut_proc(p.cd_procedimento,p.ie_origem_proced,'D','F'),1,200) ds_procedimento,
		substr(sus_obter_estr_porc_edit(p.cd_procedimento,'F'),1,30) cd_proc_editado,
		p.nr_interno_conta,
		0 vl_terceiros_hosp,
		0 vl_proprio_hosp,
		0 vl_terceiros_prof,
		0 vl_proprio_prof,
		coalesce(s.vl_ato_medico,0) vl_proprio_rat,
		0 vl_terceiro_rat,
		(coalesce(s.vl_ato_medico,0)) vl_total
	from	procedimento_paciente p,
		sus_valor_proc_paciente s
	where	s.nr_sequencia	= p.nr_sequencia
	and	p.ie_origem_proced	= 7
	and	p.cd_motivo_exc_conta is null
	and	sus_obter_procconta_rateio_aih(p.nr_sequencia) = 'S'
	and	coalesce(s.cd_registro_proc,3) = 5
	and	coalesce(p.ie_doc_executor,5) in (1,5)
	
union all

	select	substr(sus_obter_estrut_proc(p.cd_procedimento,p.ie_origem_proced,'D','F'),1,200) ds_procedimento,
		substr(sus_obter_estr_porc_edit(p.cd_procedimento,'F'),1,30) cd_proc_editado,
		p.nr_interno_conta,
		0 vl_terceiros_hosp,
		0 vl_proprio_hosp,
		coalesce(a.vl_participante,0) vl_terceiros_prof,
		0 vl_proprio_prof,
		0 vl_proprio_rat,
		0 vl_terceiro_rat,
		coalesce(a.vl_participante,0) vl_total
	from	procedimento_paciente p,
		sus_valor_proc_paciente s,
		procedimento_participante a
	where	s.nr_sequencia	= p.nr_sequencia
	and	p.nr_sequencia = a.nr_sequencia
	and	p.ie_origem_proced	= 7
	and	p.cd_motivo_exc_conta is null
	and	((sus_obter_procconta_rateio_aih(p.nr_sequencia) = 'N') or (coalesce(sus_obter_indicador_equipe(a.ie_funcao),0) = 6))
	and	coalesce(a.ie_doc_executor,5) in (3,6)
	
union all

	select	substr(sus_obter_estrut_proc(p.cd_procedimento,p.ie_origem_proced,'D','F'),1,200) ds_procedimento,
		substr(sus_obter_estr_porc_edit(p.cd_procedimento,'F'),1,30) cd_proc_editado,
		p.nr_interno_conta,
		0 vl_terceiros_hosp,
		0 vl_proprio_hosp,
		0 vl_terceiros_prof,
		coalesce(a.vl_participante,0) vl_proprio_prof,
		0 vl_proprio_rat,
		0 vl_terceiro_rat,
		coalesce(a.vl_participante,0) vl_total
	from	procedimento_paciente p,
		sus_valor_proc_paciente s,
		procedimento_participante a
	where	s.nr_sequencia	= p.nr_sequencia
	and	p.nr_sequencia = a.nr_sequencia
	and	p.ie_origem_proced	= 7
	and	p.cd_motivo_exc_conta is null
	and	((sus_obter_procconta_rateio_aih(p.nr_sequencia) = 'N') or (coalesce(sus_obter_indicador_equipe(a.ie_funcao),0) = 6))
	and	coalesce(a.ie_doc_executor,5) in (1,5)
	
union all

	select	substr(sus_obter_estrut_proc(p.cd_procedimento,p.ie_origem_proced,'D','F'),1,200) ds_procedimento,
		substr(sus_obter_estr_porc_edit(p.cd_procedimento,'F'),1,30) cd_proc_editado,
		p.nr_interno_conta,
		0 vl_terceiros_hosp,
		0 vl_proprio_hosp,
		0 vl_terceiros_prof,
		0 vl_proprio_prof,
		0 vl_proprio_rat,
		coalesce(a.vl_participante,0) vl_terceiro_rat,
		coalesce(a.vl_participante,0) vl_total
	from	procedimento_paciente p,
		sus_valor_proc_paciente s,
		procedimento_participante a
	where	s.nr_sequencia	= p.nr_sequencia
	and	p.nr_sequencia = a.nr_sequencia
	and	p.ie_origem_proced	= 7
	and	p.cd_motivo_exc_conta is null
	and	((sus_obter_procconta_rateio_aih(p.nr_sequencia) = 'S') and (coalesce(sus_obter_indicador_equipe(a.ie_funcao),0) <> 6))
	and	coalesce(a.ie_doc_executor,5) in (3,6)
	
union all

	select	substr(sus_obter_estrut_proc(p.cd_procedimento,p.ie_origem_proced,'D','F'),1,200) ds_procedimento,
		substr(sus_obter_estr_porc_edit(p.cd_procedimento,'F'),1,30) cd_proc_editado,
		p.nr_interno_conta,
		0 vl_terceiros_hosp,
		0 vl_proprio_hosp,
		0 vl_terceiros_prof,
		0 vl_proprio_prof,
		coalesce(a.vl_participante,0) vl_proprio_rat,
		0 vl_terceiro_rat,
		coalesce(a.vl_participante,0) vl_total
	from	procedimento_paciente p,
		sus_valor_proc_paciente s,
		procedimento_participante a
	where	s.nr_sequencia	= p.nr_sequencia
	and	p.nr_sequencia = a.nr_sequencia
	and	p.ie_origem_proced	= 7
	and	p.cd_motivo_exc_conta is null
	and	((sus_obter_procconta_rateio_aih(p.nr_sequencia) = 'S') and (coalesce(sus_obter_indicador_equipe(a.ie_funcao),0) <> 6))
	and	coalesce(a.ie_doc_executor,5) in (1,5)
	
union all

	select	substr(sus_obter_estrut_proc(p.cd_procedimento,p.ie_origem_proced,'D','F'),1,200) ds_procedimento,
		substr(sus_obter_estr_porc_edit(p.cd_procedimento,'F'),1,30) cd_proc_editado,
		p.nr_interno_conta,
		0 vl_terceiros_hosp,
		(coalesce(s.vl_matmed,0)+ coalesce(s.vl_sadt,0)) vl_proprio_hosp,
		0 vl_terceiros_prof,
		0 vl_proprio_prof,
		coalesce(s.vl_ato_medico,0) vl_proprio_rat,
		0 vl_terceiro_rat,
		(coalesce(s.vl_matmed,0) + coalesce(s.vl_sadt,0) + coalesce(s.vl_ato_medico,0)) vl_total
	from	procedimento_paciente p,
		sus_valor_proc_paciente s
	where	s.nr_sequencia	= p.nr_sequencia
	and	p.ie_origem_proced	= 7
	and	p.cd_motivo_exc_conta is null
	and	p.cd_procedimento = 802010199) a
group by	upper(a.ds_procedimento),
	a.cd_proc_editado,
	a.nr_interno_conta;

