-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW com_canal_consultor_v (nr_sequencia, nr_seq_canal, dt_atualizacao, nm_usuario, cd_pessoa_fisica, dt_certificacao, dt_desligamento, ie_situacao, cd_cnpj, cd_condicao_pagamento, cd_material, ie_paga_rat, dt_atualizacao_nrec, nm_usuario_nrec, ie_consultor_wheb, dt_contrato, ie_regime_contr, ie_funcao_exec, cd_pessoa_vinculo, cd_coordenador_padrao, ie_tipo_consultor, nm_consultor, ds_distribuidor, cd_empresa) AS select a.NR_SEQUENCIA,a.NR_SEQ_CANAL,a.DT_ATUALIZACAO,a.NM_USUARIO,a.CD_PESSOA_FISICA,a.DT_CERTIFICACAO,a.DT_DESLIGAMENTO,a.IE_SITUACAO,a.CD_CNPJ,a.CD_CONDICAO_PAGAMENTO,a.CD_MATERIAL,a.IE_PAGA_RAT,a.DT_ATUALIZACAO_NREC,a.NM_USUARIO_NREC,a.IE_CONSULTOR_WHEB,a.DT_CONTRATO,a.IE_REGIME_CONTR,a.IE_FUNCAO_EXEC,a.CD_PESSOA_VINCULO,a.CD_COORDENADOR_PADRAO,a.IE_TIPO_CONSULTOR,
	substr(obter_nome_pf(a.cd_pessoa_fisica),1,100) nm_consultor, 
	b.nm_guerra ds_distribuidor, 
	b.cd_empresa 
FROM 	com_canal b, 
	Com_Canal_Consultor a 
where	a.nr_seq_canal	= b.nr_sequencia;

