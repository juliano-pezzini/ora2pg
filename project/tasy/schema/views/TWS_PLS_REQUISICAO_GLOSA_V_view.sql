-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tws_pls_requisicao_glosa_v (nr_sequencia, dt_atualizacao, nr_seq_execucao, nr_seq_motivo_glosa, nr_seq_ocorrencia, nr_seq_req_mat, nr_seq_req_proc, nr_seq_requisicao, ds_observacao) AS select	nr_sequencia,
	dt_atualizacao,
	nr_seq_execucao,
	nr_seq_motivo_glosa,
	nr_seq_ocorrencia,
	nr_seq_req_mat,
	nr_seq_req_proc,
	nr_seq_requisicao,
	ds_observacao
FROM 	pls_requisicao_glosa;
