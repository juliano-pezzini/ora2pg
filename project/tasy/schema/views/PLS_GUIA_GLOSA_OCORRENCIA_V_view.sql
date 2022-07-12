-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_guia_glosa_ocorrencia_v (ie_tipo, nr_sequencia, nr_codigo, ds_descricao_glosa_ocor, ds_grupo, ds_observacao, ds_msg_externa, ds_origem_glosa, nr_regra_ocor, nr_seq_guia, nr_seq_proc, nr_seq_mat, nr_ocorrencia, ie_vinculo, ds_msg_glosa_ocor, nr_nivel_liberacao, ie_status, nr_seq_motivo_glosa) AS select	'G' ie_tipo,
	a.nr_sequencia,
	substr(tiss_obter_motivo_glosa(nr_seq_motivo_glosa,'C'),1,10) nr_codigo,
	substr(tiss_obter_motivo_glosa(nr_seq_motivo_glosa,'D'),1,255) ds_descricao_glosa_ocor,
	substr(tiss_obter_motivo_glosa(nr_seq_motivo_glosa,'DG'),1,255) ds_grupo,
	substr(ds_observacao,1,255) ds_observacao,
	substr(pls_obter_dados_msg_glosa(nr_seq_motivo_glosa,'ME'),1,255) ds_msg_externa,
	substr(CASE WHEN ie_origem='P' THEN 'Produto' WHEN ie_origem='C' THEN 'Contrato' WHEN ie_origem='B' THEN expressao_pck.obter_desc_expressao(623685) WHEN ie_origem='A' THEN 'SCA'  ELSE '' END ,1,50) ds_origem_glosa,
	0 nr_regra_ocor,
	a.nr_seq_guia nr_seq_guia,
	a.nr_seq_guia_proc nr_seq_proc,
	a.nr_seq_guia_mat nr_seq_mat,
	a.nr_seq_ocorrencia nr_ocorrencia,
	CASE WHEN a.nr_seq_ocorrencia IS NULL THEN 'G'  ELSE 'O' END  ie_vinculo,
	substr(coalesce(coalesce(pls_obter_dados_ocorrencia(a.nr_seq_ocorrencia,'DE'), pls_obter_dados_msg_glosa(nr_seq_motivo_glosa,'ME')),
	tiss_obter_motivo_glosa(nr_seq_motivo_glosa,'D')),1,255) ds_msg_glosa_ocor,
  	(select b.nr_nivel_liberacao
	FROM	pls_analise_ocor_glosa_aut b
	where 	a.nr_sequencia = b.nr_seq_glosa  LIMIT 1) nr_nivel_liberacao,
  	(select b.ie_status
	from	pls_analise_ocor_glosa_aut b
	where 	a.nr_sequencia = b.nr_seq_glosa  LIMIT 1) ie_status,
	nr_seq_motivo_glosa
from	pls_guia_glosa	a

union

select	'O' ie_tipo,
	a.nr_sequencia,	
	substr(pls_obter_dados_ocorrencia(nr_seq_ocorrencia,'C'),1,255) nr_codigo,
	substr(pls_obter_dados_ocorrencia(nr_seq_ocorrencia,'D'),1,255) ds_descricao_glosa_ocor,
	'' ds_grupo,
	coalesce(substr(ds_observacao,1,255),substr(pls_obter_dados_ocorrencia(nr_seq_ocorrencia,'DO'),1,255)) ds_observacao,
	substr(pls_obter_dados_ocorrencia(nr_seq_ocorrencia,'ME'),1,255) ds_msg_externa,
	'' ds_origem_glosa,
	a.nr_seq_regra nr_regra_ocor,
	a.nr_seq_guia_plano nr_seq_guia,
	a.nr_seq_proc nr_seq_proc,
	a.nr_seq_mat nr_seq_mat,
	a.nr_seq_ocorrencia nr_ocorrencia,
	CASE WHEN a.nr_seq_glosa_guia IS NULL THEN 'O'  ELSE 'G' END  ie_vinculo,
	substr(coalesce(pls_obter_dados_ocorrencia(nr_seq_ocorrencia,'ME'), pls_obter_dados_ocorrencia(nr_seq_ocorrencia,'D')),1,255) ds_msg_glosa_ocor,
  	(select b.nr_nivel_liberacao
	from	pls_analise_ocor_glosa_aut b
	where 	a.nr_sequencia = b.nr_seq_glosa  LIMIT 1) nr_nivel_liberacao,
  	(select b.ie_status
	from	pls_analise_ocor_glosa_aut b
	where 	a.nr_sequencia = b.nr_seq_glosa  LIMIT 1) ie_status,
	null nr_seq_motivo_glosa
from	pls_ocorrencia_benef	a
where	nr_seq_conta is null
and	nr_seq_requisicao is null
and	nr_seq_execucao is null
and	nr_seq_conta_pos_estab is null;

