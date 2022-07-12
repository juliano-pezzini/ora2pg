-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_risco_upp_v (nr_atendimento, dt_liberacao, ie_sae, cd_estabelecimento, cd_empresa) AS select a.nr_atendimento,
		a.dt_liberacao, 
		substr(obter_se_reg_sae_braden(a.nr_atendimento,a.dt_liberacao,a.dt_liberacao + 1),1,255) ie_sae, 
		b.cd_estabelecimento, 
		f.cd_empresa 
FROM  atend_escala_braden a, 
		atendimento_paciente b, 
		estabelecimento f 
where  a.nr_atendimento = b.nr_atendimento 
and		b.cd_estabelecimento = f.cd_estabelecimento 
and		dt_liberacao is not null 
and		dt_inativacao is null 
and		qt_ponto < 19;

