-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW eis_solic_entrega_pront_v (dt_referencia, nr_prontuario, nm_paciente, nm_pessoa_solic, dt_solicitacao, dt_prevista, nr_seq_motivo, ds_motivo, dt_entrega, nm_pessoa_entrega, cd_estabelecimento, ie_status, ds_status, ie_tipo_solicitacao, ds_tipo_solicitacao) AS select	a.dt_solicitacao dt_referencia,
		substr(OBTER_PRONTUARIO_PACIENTE(a.cd_pessoa_fisica),1,254) nr_prontuario, 
		substr(obter_nome_pf(a.cd_pessoa_fisica),1,254) nm_paciente, 
		substr(obter_nome_pf_pj(a.cd_pessoa_solicitante, null),1,254) nm_pessoa_solic, 
		a.dt_solicitacao, 
		a.dt_prevista, 
		a.nr_seq_motivo, 
		substr(obter_descricao_padrao('SAME_SOLIC_MOTIVO','DS_MOTIVO',a.NR_SEQ_MOTIVO),1,80) ds_motivo, 
		a.dt_entrega,	 
		SUBSTR(obter_nome_pf(b.cd_pessoa_fisica),1,120) nm_pessoa_entrega, 
		a.cd_estabelecimento, 
		a.ie_status, 
		substr(obter_valor_dominio(1313,a.ie_status),1,100) ds_status, 
		a.ie_tipo_solicitacao, 
		substr(obter_valor_dominio(1322,a.ie_tipo_solicitacao),1,100) ds_tipo_solicitacao 
FROM	same_solic_pront a, 
		same_copia_prontuario b 
where	a.nr_sequencia = b.nr_seq_solic;
