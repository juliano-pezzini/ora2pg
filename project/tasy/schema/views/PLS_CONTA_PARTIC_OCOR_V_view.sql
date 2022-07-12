-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_conta_partic_ocor_v (nr_seq_conta_proc, nr_seq_proc_partic, cd_procedimento, ie_origem_proced, dt_procedimento, dt_procedimento_trunc, cd_guia_referencia, cd_medico, nr_crm, nr_cpf, cd_grau_partic_imp, nr_seq_grau_partic, nr_seq_prestador, nr_seq_segurado) AS select	a.nr_seq_conta_proc nr_seq_conta_proc,
	a.nr_sequencia nr_seq_proc_partic,
	b.cd_procedimento,
	b.ie_origem_proced,
	b.dt_procedimento,
	b.dt_procedimento_trunc,
	b.cd_guia_referencia cd_guia_referencia,
	a.cd_medico cd_medico,
	a.nr_crm_imp nr_crm,
	a.nr_cpf_imp nr_cpf,
	a.cd_grau_partic_imp,
	a.nr_seq_grau_partic,
	a.nr_seq_prestador nr_seq_prestador,
	b.nr_seq_segurado
FROM	pls_conta_proc_v b,
	pls_proc_participante a
where	a.nr_seq_conta_proc = b.nr_sequencia
and	b.ie_status 		<> 'D'
and (a.ie_status 		<> 'C' or a.ie_status is null)
and (a.ie_gerada_cta_honorario = 'N' or a.ie_gerada_cta_honorario is null)

union all

/* Procedimentos referentes a contas de honorário geradas pelo sistema - Participante e grau na conta */

select	b.nr_sequencia nr_seq_conta_proc,
	null nr_seq_proc_partic,
	b.cd_procedimento,
	b.ie_origem_proced,
	b.dt_procedimento,
	b.dt_procedimento_trunc,
	b.cd_guia_referencia cd_guia_referencia,
	b.cd_medico_executor cd_medico,
	b.nr_crm_exec nr_crm,
	null nr_cpf,
	null cd_grau_partic_imp,
	b.nr_seq_grau_partic,
	b.nr_seq_prestador_exec nr_seq_prestador,
	b.nr_seq_segurado
from	pls_conta_proc_v b
where	b.ie_status 		<> 'D'
and	not exists (select	1
			from	pls_proc_participante x
			where	x.nr_seq_conta_proc = b.nr_sequencia);

