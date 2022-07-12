-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW procedimento_paciente_v2 (nr_sequencia, nr_interno_conta, ds_procedimento, nr_atendimento) AS select nr_sequencia,
	nr_interno_conta, 
    substr(obter_desc_prescr_proc_exam(a.cd_procedimento, a.ie_origem_proced, a.nr_seq_proc_interno, a.nr_seq_exame),1,255) ds_procedimento, 
	nr_atendimento 
FROM 	procedimento b, 
	procedimento_paciente a 
where 	a.cd_procedimento	= b.cd_procedimento 
and	a.ie_origem_proced	= b.ie_origem_proced 
and 	a.cd_motivo_exc_conta is null;

