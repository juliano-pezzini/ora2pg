-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_movto_trans_finac ( dt_saldo_p text, nr_seq_trans_financ_p bigint, vl_transacao_p bigint, nr_seq_caixa_p bigint, cd_conta_contabil_p bigint, ds_historico_p text, nr_seq_lote_p bigint, nr_saldo_aberto_p bigint, nm_usuario_p text) AS $body$
BEGIN
insert into  movto_trans_financ(nr_sequencia,
	dt_transacao,
	nr_seq_trans_financ,
	vl_transacao,
	dt_atualizacao,
	nm_usuario,
	nr_seq_caixa,
	cd_conta_contabil,
        	ds_historico,
        	dt_referencia_saldo,
	nr_seq_lote,
	nr_seq_saldo_caixa,
        	ie_conciliacao,
        	nr_lote_contabil)
values (nextval('movto_trans_financ_seq'),
	dt_saldo_p,
	nr_seq_trans_financ_p,
	vl_transacao_p,
	clock_timestamp(),
        	nm_usuario_p,
	nr_seq_caixa_p,
	cd_conta_contabil_p,
	ds_historico_p,
	dt_saldo_p,
        	nr_seq_lote_p,
        	nr_saldo_aberto_p,
        	'N',
        	0);
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_movto_trans_finac ( dt_saldo_p text, nr_seq_trans_financ_p bigint, vl_transacao_p bigint, nr_seq_caixa_p bigint, cd_conta_contabil_p bigint, ds_historico_p text, nr_seq_lote_p bigint, nr_saldo_aberto_p bigint, nm_usuario_p text) FROM PUBLIC;
