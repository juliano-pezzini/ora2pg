-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

CREATE OR REPLACE VIEW san_bmts_pr_v (cd_regional_saude, cd_banco_sangue, cd_agencia_transf, dt_mesano_transfusao, nr_bolsa, dt_transfusao, cd_hemocomponente, cd_destino_hemocomp, cd_reacao_transf, dt_dia_transfusao, dt_nascimento, nm_receptor, cd_motivo_inutil, cd_bs_destino, cd_agencia_destino) AS select	11 cd_regional_saude,
	22 cd_banco_sangue,
	33 cd_agencia_transf,
	dt_transfusao dt_mesano_transfusao,
	nr_sec_saude nr_bolsa,
	dt_transfusao,
	00 cd_hemocomponente,
	01 cd_destino_hemocomp,
	00 cd_reacao_transf,
	dt_transfusao dt_dia_transfusao,
	LOCALTIMESTAMP dt_nascimento,
	'Teste' nm_receptor,
	00 cd_motivo_inutil,
	00 cd_bs_destino,
	00 cd_agencia_destino
FROM	san_producao b,
	san_transfusao a
where	a.nr_sequencia = b.nr_seq_transfusao
  and	a.ie_status = 'F';

