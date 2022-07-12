-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW procedimento_cirurgia_v (nr_cirurgia, cd_pessoa_fisica, dt_inicio_real, cd_medico_cirurgiao, cd_procedimento, ie_origem_proced, nr_seq_proc_interno, qt_procedimento) AS select	c.nr_cirurgia,
	b.cd_pessoa_fisica,
	c.dt_inicio_real,
	coalesce(a.cd_medico_exec,c.cd_medico_cirurgiao) cd_medico_cirurgiao,
	a.cd_procedimento,
	a.ie_origem_proced,
	a.nr_seq_proc_interno,
	a.qt_procedimento
FROM	prescr_procedimento a,
	prescr_medica b,
	cirurgia c
where	a.nr_prescricao = b.nr_prescricao
and	c.nr_prescricao = b.nr_prescricao;
