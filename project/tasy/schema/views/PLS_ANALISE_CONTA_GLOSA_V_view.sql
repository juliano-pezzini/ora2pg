-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_analise_conta_glosa_v (ds_tipo, cd_ocorrencia, ds_ocorrencia, cd_glosa, ds_glosa, grupo_glosa, geracao_glosa, ds_observacao, ie_situacao, ie_fechar_conta, nr_seq_conta, nr_seq_proc, nr_seq_mat, nr_sequencia) AS select	'Ocorrência' ds_tipo,
	substr(pls_obter_dados_ocorrencia(nr_seq_ocorrencia,'C'),1,255) cd_ocorrencia,
	substr(pls_obter_dados_ocorrencia(nr_seq_ocorrencia,'D'),1,255) ds_ocorrencia,
	'' cd_glosa,
	'' ds_glosa,
	'' grupo_glosa,
	'' geracao_glosa,
	'' ds_observacao,
	'' ie_situacao,
	'' ie_fechar_conta,
	nr_seq_conta,
	nr_seq_proc,
	nr_seq_mat,
	nr_sequencia
FROM	pls_ocorrencia_benef

union

select	'Ocorrência e Glosa' ds_tipo,
	substr(pls_obter_dados_ocorrencia(b.nr_seq_ocorrencia,'C'),1,255) cd_ocorrencia,
	substr(pls_obter_dados_ocorrencia(b.nr_seq_ocorrencia,'D'),1,255) ds_ocorrencia,
	substr(tiss_obter_motivo_glosa(a.nr_seq_motivo_glosa,'C'),1,255) cd_glosa,
	substr(tiss_obter_motivo_glosa(a.nr_seq_motivo_glosa,'D'),1,255) ds_glosa,
	substr(tiss_obter_motivo_glosa(a.nr_seq_motivo_glosa,'DG'),1,255) grupo_glosa,
	substr(CASE WHEN a.ie_lib_manual='S' THEN 'Usuário'  ELSE 'Sistema' END ,1,50) geracao_glosa,
	substr(a.ds_observacao,1,255) ds_observacao,
	a.ie_situacao,
	a.ie_fechar_conta,
	b.nr_seq_conta,
	b.nr_seq_proc,
	b.nr_seq_mat,
	a.nr_sequencia
from	pls_ocorrencia_benef	b,
	pls_conta_glosa		a
where	a.nr_seq_ocorrencia_benef = b.nr_sequencia

union

select	'Glosa' ds_tipo,
	'' cd_ocorrencia,
	'' ds_ocorrencia,
	substr(tiss_obter_motivo_glosa(nr_seq_motivo_glosa,'C'),1,255) cd_glosa,
	substr(tiss_obter_motivo_glosa(nr_seq_motivo_glosa,'D'),1,255) ds_glosa,
	substr(tiss_obter_motivo_glosa(nr_seq_motivo_glosa,'DG'),1,255) grupo_glosa,
	substr(CASE WHEN ie_lib_manual='S' THEN 'Usuário'  ELSE 'Sistema' END ,1,50) geracao_glosa,
	substr(ds_observacao,1,255) ds_observacao,
	ie_situacao,
	ie_fechar_conta,
	nr_seq_conta,
	nr_seq_conta_proc nr_seq_proc,
	nr_seq_conta_mat nr_seq_mat,
	nr_sequencia
from	pls_conta_glosa;

