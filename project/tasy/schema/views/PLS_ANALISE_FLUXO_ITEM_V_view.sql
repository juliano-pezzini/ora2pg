-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_analise_fluxo_item_v (nr_sequencia, nm_auditor, dt_atualizacao, dt_atualizacao_nrec, nr_seq_analise, nr_seq_grupo, ds_grupo, nr_seq_conta, nr_seq_conta_proc, nr_seq_conta_mat, nr_seq_proc_partic, nr_seq_ordem, vl_glosa, qt_liberada, ie_acao_item, ds_acao, ie_finalizacao, ie_glosa_conta, ds_tipo_glosa, ds_origem_acao, ds_parecer, nr_seq_motivo_glosa) AS select	a.nr_sequencia,
	SUBSTR(obter_nome_usuario(a.nm_usuario_nrec),1,255) nm_auditor,
	SUBSTR(to_char(a.dt_atualizacao_nrec, 'dd/mm/yyyy hh24:mi:ss'),1,255) dt_atualizacao,
	a.dt_atualizacao_nrec,
	a.nr_seq_analise,
	a.nr_seq_grupo,
	SUBSTR(pls_obter_nome_grupo_auditor(a.nr_seq_grupo),1,255) ds_grupo,
	a.nr_seq_conta,
	a.nr_seq_conta_proc,
	a.nr_seq_conta_mat,
	a.nr_seq_proc_partic,
	a.nr_seq_ordem,
	a.vl_glosa,
	a.qt_liberada,
	a.ie_acao_item,
	CASE WHEN a.ie_acao_item='G' THEN 'Glosado' WHEN a.ie_acao_item='L' THEN 'Liberado' WHEN a.ie_acao_item='M' THEN 'Mantido' END  ds_acao,
	a.ie_finalizacao,
	a.ie_glosa_conta,
	CASE WHEN a.ie_tipo_glosa='A' THEN 'Ambos' WHEN a.ie_tipo_glosa='P' THEN 'Pagamento' WHEN a.ie_tipo_glosa='F' THEN 'Faturamento'  ELSE 'Pagamento' END  ds_tipo_glosa,
	CASE WHEN a.nr_seq_acao_analise IS NULL THEN  substr(Obter_Valor_Dominio(5527,a.ie_origem_acao),1,255)  ELSE (	select	x.ds_acao_analise													FROM	pls_acao_analise	x													where	x.nr_sequencia = a.nr_seq_acao_analise) END  ds_origem_acao,
	a.ds_parecer,
	a.nr_seq_motivo_glosa
from	pls_analise_fluxo_item a;

