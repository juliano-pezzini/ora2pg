-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW conta_paciente_mat_proc_rep_v (nr_atendimento, nm_pessoa_fisica, dt_entrada, nm_medico, cd_item, ds_item, ds_status, nr_repasse_terceiro, vl_repasse, vl_liberado, dt_contabil, dt_contabil_titulo, nr_sequencia, ds_terceiro, cd_regra, dt_liberacao, dt_conta, nr_seq_criterio, cd_cgc, cd_pessoa_fisica, cd_medico, nr_interno_conta, ie_emite_conta, nr_seq_proc_pacote, nr_seq_protocolo, vl_mat_proc, qt_mat_proc) AS select c.nr_atendimento,
    substr(obter_nome_pf(c.cd_pessoa_fisica),1,40) nm_pessoa_fisica, 
    c.dt_entrada, 
    substr(obter_nome_medico(a.cd_medico, 'N'),1,100) nm_medico, 
	b.cd_procedimento cd_item, 
    f.ds_procedimento ds_item, 
    substr(obter_valor_dominio(1129, a.ie_status),1,50) ds_status, 
    a.nr_repasse_terceiro, 
    a.vl_repasse, 
    a.vl_liberado,     
    a.dt_contabil, 
    a.dt_contabil_titulo, 
    a.nr_sequencia, 
    substr(obter_nome_terceiro(g.nr_sequencia),1,60) ds_terceiro, 
    a.cd_regra, 
    a.dt_liberacao, 
    b.dt_conta, 
    a.nr_seq_criterio, 
	g.cd_cgc, 
	c.cd_pessoa_fisica, 
	a.cd_medico, 
	b.nr_interno_conta, 
	210 ie_emite_conta, 
	b.nr_seq_proc_pacote, 
	d.nr_seq_protocolo, 
	b.vl_procedimento vl_mat_proc, 
	b.qt_procedimento qt_mat_proc 
FROM  procedimento f, 
    atendimento_paciente c, 
    terceiro g, 
    procedimento_repasse a, 
    procedimento_paciente b, 
	conta_paciente d 
where  a.nr_seq_procedimento  = b.nr_sequencia 
and   c.nr_atendimento    = b.nr_atendimento 
and   f.cd_procedimento    = b.cd_procedimento 
and   f.ie_origem_proced   = b.ie_origem_proced 
and   g.nr_sequencia     = a.nr_seq_terceiro 
and	b.nr_interno_conta	= d.nr_interno_conta 

union all
 
select c.nr_atendimento, 
    e.nm_pessoa_fisica, 
    c.dt_entrada, 
    substr(obter_nome_medico(a.cd_medico, 'N'),1,100) nm_medico, 
    f.cd_material cd_item, 
    f.ds_material ds_item, 
    substr(obter_valor_dominio(1129, a.ie_status),1,50) ds_status, 
    a.nr_repasse_terceiro, 
    a.vl_repasse, 
    a.vl_liberado, 
    a.dt_contabil, 
    a.dt_contabil_titulo, 
    a.nr_sequencia, 
    substr(obter_nome_terceiro(g.nr_sequencia),1,60) ds_terceiro, 
    a.cd_regra, 
    a.dt_liberacao, 
    b.dt_conta, 
    a.nr_seq_criterio, 
	g.cd_cgc, 
	c.cd_pessoa_fisica, 
	a.cd_medico, 
	b.nr_interno_conta, 
	210 ie_emite_conta, 
	b.nr_seq_proc_pacote, 
	d.nr_seq_protocolo, 
	b.vl_material vl_mat_proc, 
	b.qt_material qt_mat_proc 
from  material f, 
    pessoa_fisica e, 
    atendimento_paciente c, 
    terceiro g, 
    material_repasse a, 
    material_atend_paciente b, 
	conta_paciente d 
where  a.nr_seq_material	= b.nr_sequencia 
and   c.nr_atendimento    = b.nr_atendimento 
and   e.cd_pessoa_fisica  	= c.cd_pessoa_fisica 
and   f.cd_material     = b.cd_material 
and   g.nr_sequencia     = a.nr_seq_terceiro 
and	b.nr_interno_conta	= d.nr_interno_conta;

