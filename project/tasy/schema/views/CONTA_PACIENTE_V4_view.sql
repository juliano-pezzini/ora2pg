-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW conta_paciente_v4 (nr_atendimento, ie_proc_mat, cd_setor_atendimento, nr_interno_conta) AS select	a.nr_atendimento,
	1 ie_proc_mat,
	a.cd_setor_atendimento,
	a.nr_interno_conta
FROM	procedimento_paciente a,
	conta_paciente m
where	a.nr_interno_conta	  = m.nr_interno_conta

union

select	x.nr_atendimento,
	2 ie_proc_mat,
	x.cd_setor_atendimento,
	x.nr_interno_conta
from	material_atend_paciente x,
	conta_paciente m
where	x.nr_interno_conta	  = m.nr_interno_conta;
