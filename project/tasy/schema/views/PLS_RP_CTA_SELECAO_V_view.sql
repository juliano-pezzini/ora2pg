-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW pls_rp_cta_selecao_v (ie_tipo_registro, nr_sequencia, dt_atualizacao, nm_usuario, dt_atualizacao_nrec, nm_usuario_nrec, nr_id_transacao, nr_seq_conta, nr_seq_conta_proc, nr_seq_conta_mat, ie_valido, ie_valido_temp, nr_seq_rp_cta_filtro) AS select	CASE WHEN nr_seq_conta_proc IS NULL THEN  CASE WHEN nr_seq_conta_mat IS NULL THEN  'C'  ELSE 'M' END   ELSE 'P' END  ie_tipo_registro,
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_id_transacao,
	nr_seq_conta,
	nr_seq_conta_proc,
	nr_seq_conta_mat,
	ie_valido,
	ie_valido_temp,
	nr_seq_rp_cta_filtro
FROM	pls_rp_cta_selecao;
