-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_med_solic_exame_v (dt_solicitacao, cd_convenio, ie_sexo, cd_medico, nm_convenio, ds_sexo, ds_exame, ds_grupo, qt_exame, nm_medico) AS select	b.dt_solicitacao,
	a.cd_convenio, 
	e.ie_sexo, 
	a.cd_medico, 
	substr(obter_nome_convenio(a.cd_convenio),1,100) nm_convenio, 
	substr(obter_valor_dominio(4,e.ie_sexo),1,100) ds_sexo, 
	substr(ds_exame,1,100) ds_exame, 
	substr(ds_grupo_exame,1,100) ds_grupo, 
	c.qt_exame, 
	substr(obter_nome_pf(a.cd_medico),1,100) nm_medico 
FROM	pessoa_fisica e, 
	med_grupo_exame g, 
	med_exame_padrao f, 
	med_cliente a, 
	med_pedido_exame b, 
	med_ped_exame_cod c 
where	b.nr_seq_cliente	= a.nr_sequencia 
and	c.nr_seq_pedido 	= b.nr_sequencia 
and	a.cd_pessoa_fisica	= e.cd_pessoa_fisica 
and	c.nr_seq_exame		= f.nr_sequencia 
and	f.nr_seq_grupo		= g.nr_sequencia;
