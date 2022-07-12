-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW tws_pls_ocorrencia_benef_v (nr_sequencia, dt_atualizacao, nr_seq_conta, nr_seq_execucao, nr_seq_guia_plano, nr_seq_mat, nr_seq_ocorrencia, nr_seq_proc, ds_observacao, nr_seq_requisicao, nr_seq_conta_pos_estab) AS select 	nr_sequencia,
	dt_atualizacao,
	nr_seq_conta,
	nr_seq_execucao,
	nr_seq_guia_plano,
	nr_seq_mat,
	nr_seq_ocorrencia,
	nr_seq_proc,
	ds_observacao,
	nr_seq_requisicao,
	nr_seq_conta_pos_estab
FROM 	pls_ocorrencia_benef;
