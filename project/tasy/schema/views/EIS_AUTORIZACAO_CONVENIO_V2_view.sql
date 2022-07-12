-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_autorizacao_convenio_v2 (qt_autorizacao, qt_dias_autor, ds_convenio, cd_convenio, ds_medico_solicitante, ds_procedimento, ds_tipo_autorizacao, ie_tipo_autorizacao, cd_estabelecimento, ds_tipo_atendimento, ie_tipo_atendimento, nr_seq_estagio, ds_estagio, nr_atendimento, nr_seq_agenda, dt_autorizacao, dt_inicio_vigencia, ds_pre_pos_internacao, ie_pre_pos_internacao, nm_usuario_autor, nm_usuario_resp) AS select	count(*) qt_autorizacao,
	obter_dias_entre_datas(a.dt_autorizacao,obter_data_autor_finalizada(a.nr_sequencia)) qt_dias_autor,	 
	substr(obter_desc_convenio(a.cd_convenio),1,255) ds_convenio, 
	a.cd_convenio, 
	substr(obter_nome_pf_pj(a.cd_medico_solicitante, null),1,255) ds_medico_solicitante, 
	substr(obter_descricao_procedimento(a.cd_procedimento_principal, a.ie_origem_proced),1,255) ds_procedimento, 
	substr(obter_valor_dominio(1377,a.ie_tipo_autorizacao),1,150) ds_tipo_autorizacao, 
	a.ie_tipo_autorizacao, 
	(obter_dados_autor_convenio(a.nr_sequencia,'E'))::numeric  cd_estabelecimento,	 
	substr(coalesce(obter_valor_dominio(12,obter_dados_autor_convenio(a.nr_sequencia,'TA')),'Não informado'),1,255) ds_tipo_atendimento, 
	coalesce((obter_dados_autor_convenio(a.nr_sequencia,'TA'))::numeric ,9999) ie_tipo_atendimento, 
	a.nr_seq_estagio, 
	b.ds_estagio, 
	a.nr_atendimento, 
	a.nr_seq_agenda, 
	trunc(a.dt_retorno) dt_autorizacao, 
	a.dt_inicio_vigencia, 
	'Pré - Internação' ds_pre_pos_internacao, 
	0 ie_pre_pos_internacao, 
	substr(Obter_dados_usuario_opcao(obter_usuario_autorizador(a.nr_sequencia),'NP'),1,255) nm_usuario_autor,	 
	substr(Obter_dados_usuario_opcao(a.nm_usuario_resp,'NP'),1,255) nm_usuario_resp 
FROM	autorizacao_convenio a, 
	estagio_autorizacao b 
where	a.nr_seq_estagio	= b.nr_sequencia 
and	b.ie_interno		in ('10','70') --Somente autorizados e cancelados 
and (a.dt_autorizacao 	> obter_data_entrada(a.nr_atendimento) or 
	a.nr_atendimento	is null) 
group by obter_dias_entre_datas(a.dt_autorizacao,obter_data_autor_finalizada(a.nr_sequencia)), 
	substr(obter_desc_convenio(a.cd_convenio),1,255), 
	a.cd_convenio, 
	substr(obter_nome_pf_pj(a.cd_medico_solicitante, null),1,255), 
	substr(obter_descricao_procedimento(a.cd_procedimento_principal, a.ie_origem_proced),1,255), 
	substr(obter_valor_dominio(1377,a.ie_tipo_autorizacao),1,150), 
	a.ie_tipo_autorizacao, 
	(obter_dados_autor_convenio(a.nr_sequencia,'E'))::numeric , 
	substr(coalesce(obter_valor_dominio(12,obter_dados_autor_convenio(a.nr_sequencia,'TA')),'Não informado'),1,255), 
	coalesce((obter_dados_autor_convenio(a.nr_sequencia,'TA'))::numeric ,9999), 
	a.nr_atendimento, 
	a.nr_seq_agenda, 
	trunc(a.dt_retorno), 
	a.dt_inicio_vigencia, 
	a.nr_seq_estagio, 
	b.ds_estagio, 
	substr(Obter_dados_usuario_opcao(obter_usuario_autorizador(a.nr_sequencia),'NP'),1,255), 
	substr(Obter_dados_usuario_opcao(a.nm_usuario_resp,'NP'),1,255) 

union
 
select	count(*) qt_autorizacao, 
	obter_dias_entre_datas(a.dt_autorizacao,obter_data_autor_finalizada(a.nr_sequencia)) qt_dias_autor,	 
	substr(obter_desc_convenio(a.cd_convenio),1,255) ds_convenio, 
	a.cd_convenio, 
	substr(obter_nome_pf_pj(a.cd_medico_solicitante, null),1,255) ds_medico_solicitante, 
	substr(obter_descricao_procedimento(a.cd_procedimento_principal, a.ie_origem_proced),1,255) ds_procedimento, 
	substr(obter_valor_dominio(1377,a.ie_tipo_autorizacao),1,150) ds_tipo_autorizacao, 
	a.ie_tipo_autorizacao, 
	(obter_dados_autor_convenio(a.nr_sequencia,'E'))::numeric  cd_estabelecimento,	 
	substr(coalesce(obter_valor_dominio(12,obter_dados_autor_convenio(a.nr_sequencia,'TA')),'Não informado'),1,255) ds_tipo_atendimento, 
	coalesce((obter_dados_autor_convenio(a.nr_sequencia,'TA'))::numeric ,9999) ie_tipo_atendimento, 
	a.nr_seq_estagio, 
	b.ds_estagio, 
	a.nr_atendimento, 
	a.nr_seq_agenda, 
	trunc(a.dt_retorno) dt_autorizacao, 
	a.dt_inicio_vigencia, 
	'Pós - Internação' DS_PRE_POS_INTERNACAO, 
	1 ie_pre_pos_internacao, 
	substr(Obter_dados_usuario_opcao(obter_usuario_autorizador(a.nr_sequencia),'NP'),1,255) nm_usuario_autor, 
	substr(Obter_dados_usuario_opcao(a.nm_usuario_resp,'NP'),1,255) nm_usuario_resp 
from	autorizacao_convenio a, 
	estagio_autorizacao b 
where	a.nr_seq_estagio	= b.nr_sequencia 
and	b.ie_interno		in ('10','70') --Somente autorizados e cancelados 
and	a.nr_atendimento	is not null 
and	a.dt_autorizacao 	<= obter_data_entrada(a.nr_atendimento) 
group by obter_dias_entre_datas(a.dt_autorizacao,obter_data_autor_finalizada(a.nr_sequencia)), 
	substr(obter_desc_convenio(a.cd_convenio),1,255), 
	a.cd_convenio, 
	substr(obter_nome_pf_pj(a.cd_medico_solicitante, null),1,255), 
	substr(obter_descricao_procedimento(a.cd_procedimento_principal, a.ie_origem_proced),1,255), 
	substr(obter_valor_dominio(1377,a.ie_tipo_autorizacao),1,150), 
	a.ie_tipo_autorizacao, 
	(obter_dados_autor_convenio(a.nr_sequencia,'E'))::numeric , 
	substr(coalesce(obter_valor_dominio(12,obter_dados_autor_convenio(a.nr_sequencia,'TA')),'Não informado'),1,255), 
	coalesce((obter_dados_autor_convenio(a.nr_sequencia,'TA'))::numeric ,9999), 
	a.nr_atendimento, 
	a.nr_seq_agenda, 
	trunc(a.dt_retorno), 
	a.dt_inicio_vigencia, 
	a.nr_seq_estagio, 
	b.ds_estagio, 
	substr(Obter_dados_usuario_opcao(obter_usuario_autorizador(a.nr_sequencia),'NP'),1,255), 
	substr(Obter_dados_usuario_opcao(a.nm_usuario_resp,'NP'),1,255);

