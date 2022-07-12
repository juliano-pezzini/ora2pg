-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_proc_participante_ocor_v (nr_sequencia, nr_seq_grau_partic, cd_grau_partic_imp, ie_status, nr_seq_conta_proc, cd_procedimento, cd_procedimento_imp, ie_origem_proced, dt_procedimento, dt_procedimento_imp, ds_grau_partic, ds_grau_partic_imp, nr_seq_grau_partic_imp, nr_seq_prestador, cd_prestador, nr_seq_tipo_prestador, cd_medico, nr_seq_lote_conta) AS select	a.nr_sequencia,
	a.nr_seq_grau_partic,
	a.cd_grau_partic_imp,
	a.ie_status,
	a.nr_seq_conta_proc,
	a.cd_procedimento,
	a.cd_procedimento_imp,
	a.ie_origem_proced,
	a.dt_procedimento,
	a.dt_procedimento_imp,
	a.ds_grau_partic,
	a.ds_grau_partic_imp,
	a.nr_seq_grau_partic_imp,
	a.nr_seq_prestador,
	a.cd_prestador,
	a.nr_seq_tipo_prestador,
	a.cd_medico,
	a.nr_seq_lote_conta
FROM	pls_proc_participante_v a
where	a.ie_status <> 'C'

union all

select	a.nr_sequencia,
	a.nr_seq_grau_partic,
	a.cd_grau_partic_imp,
	a.ie_status,
	a.nr_seq_conta_proc,
	a.cd_procedimento,
	a.cd_procedimento_imp,
	a.ie_origem_proced,
	a.dt_procedimento,
	a.dt_procedimento_imp,
	a.ds_grau_partic,
	a.ds_grau_partic_imp,
	a.nr_seq_grau_partic_imp,
	a.nr_seq_prestador,
	a.cd_prestador,
	a.nr_seq_tipo_prestador,
	a.cd_medico,
	a.nr_seq_lote_conta
from	pls_proc_participante_v a
where	a.ie_status is null;

