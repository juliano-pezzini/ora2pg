-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_med_atestado_v (cd_medico, cd_cid_atestado, cd_especialidade, cd_profissao, cd_setor, dt_atestado, qt_dia, ds_cid_doenca, ds_setor_atendimento, ds_especialidade, ds_profissao, nm_medico) AS select	c.cd_medico,
	a.cd_cid_atestado, 
	a.cd_especialidade, 
	a.cd_profissao, 
	a.cd_setor, 
	dt_atestado, 
	qt_dia, 
	substr(obter_desc_cid(a.cd_cid_atestado),1,100) ds_cid_doenca, 
	substr(obter_nome_setor(a.cd_setor),1,100) ds_setor_atendimento, 
	substr(obter_desc_espec_medica(a.cd_especialidade),1,100) ds_especialidade, 
	substr(obter_desc_profissao(a.cd_profissao),1,100) ds_profissao, 
	substr(obter_nome_pf(c.cd_medico),1,100) nm_medico 
FROM	med_cliente c, 
	med_atestado a   
where	c.nr_sequencia   = a.nr_seq_cliente;
