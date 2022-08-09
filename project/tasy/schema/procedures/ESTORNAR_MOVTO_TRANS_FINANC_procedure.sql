-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE estornar_movto_trans_financ (nr_seq_movto_trans_p bigint, nm_usuario_p text, nr_seq_movto_estorno_p INOUT bigint) AS $body$
DECLARE


/* NÃO DAR COMMIT NESTA PROCEDURE */

nr_seq_movto_estorno_w	bigint;


BEGIN

select	nextval('movto_trans_financ_seq')
into STRICT	nr_seq_movto_estorno_w
;

insert	into movto_trans_financ(cd_centro_custo,
	cd_cgc,
	cd_conta_contabil,
	cd_conta_financ,
	cd_historico,
	cd_pessoa_fisica,
	cd_portador,
	cd_tipo_baixa_cpa,
	cd_tipo_portador,
	cd_tipo_recebimento,
	ds_historico,
	dt_atualizacao,
	dt_autenticacao,
	dt_conferencia,
	dt_fechamento_lote,
	dt_referencia_saldo,
	dt_transacao,
	ie_conciliacao,
	ie_estorno,
	ie_rejeitado,
	nm_usuario,
	nr_adiantamento,
	nr_adiant_pago,
	nr_bordero,
	nr_bordero_rec,
	nr_documento,
	nr_interno_conta,
	nr_lote_contabil,
	nr_seq_banco,
	nr_seq_banco_escrit,
	nr_seq_bordero_cheque,
	nr_seq_caixa,
	nr_seq_caixa_rec,
	nr_seq_cheque,
	nr_seq_cheque_cp,
	nr_seq_classif,
	nr_seq_cobr_escrit,
	nr_seq_concil,
	nr_seq_conv_receb,
	nr_seq_deposito,
	nr_seq_etapa_gpi,
	nr_seq_lote,
	nr_seq_lote_cartao,
	nr_seq_lote_origem,
	nr_seq_motivo_dev,
	nr_seq_movto_cartao,
	nr_seq_movto_orig,
	nr_seq_movto_transf,
	nr_seq_nota_fiscal,
	nr_seq_proj_gpi,
	nr_seq_proj_rec,
	nr_seq_relat_desp,
	nr_seq_saldo_banco,
	nr_seq_saldo_caixa,
	nr_seq_titulo_pagar,
	nr_seq_titulo_receber,
	nr_seq_trans_financ,
	nr_sequencia,
	vl_recebido,
	vl_transacao,
	vl_transacao_estrang,
	vl_complemento,
	vl_cotacao,
	cd_moeda)
SELECT	a.cd_centro_custo,
	a.cd_cgc,
	a.cd_conta_contabil,
	a.cd_conta_financ,
	a.cd_historico,
	a.cd_pessoa_fisica,
	a.cd_portador,
	a.cd_tipo_baixa_cpa,
	a.cd_tipo_portador,
	a.cd_tipo_recebimento,
	wheb_mensagem_pck.get_texto(302771,null) || ' ' || nr_seq_movto_trans_p, --Estorno do movimento
	clock_timestamp(),
	a.dt_autenticacao,
	a.dt_conferencia,
	a.dt_fechamento_lote,
	a.dt_referencia_saldo,
	a.dt_transacao,
	'N',
	'E',
	a.ie_rejeitado,
	nm_usuario_p,
	a.nr_adiantamento,
	a.nr_adiant_pago,
	a.nr_bordero,
	a.nr_bordero_rec,
	a.nr_documento,
	a.nr_interno_conta,
	a.nr_lote_contabil,
	a.nr_seq_banco,
	a.nr_seq_banco_escrit,
	a.nr_seq_bordero_cheque,
	a.nr_seq_caixa,
	a.nr_seq_caixa_rec,
	a.nr_seq_cheque,
	a.nr_seq_cheque_cp,
	a.nr_seq_classif,
	a.nr_seq_cobr_escrit,
	null,
	a.nr_seq_conv_receb,
	a.nr_seq_deposito,
	a.nr_seq_etapa_gpi,
	a.nr_seq_lote,
	a.nr_seq_lote_cartao,
	a.nr_seq_lote_origem,
	a.nr_seq_motivo_dev,
	a.nr_seq_movto_cartao,
	nr_seq_movto_trans_p,
	a.nr_seq_movto_transf,
	a.nr_seq_nota_fiscal,
	a.nr_seq_proj_gpi,
	a.nr_seq_proj_rec,
	a.nr_seq_relat_desp,
	a.nr_seq_saldo_banco,
	a.nr_seq_saldo_caixa,
	a.nr_seq_titulo_pagar,
	a.nr_seq_titulo_receber,
	a.nr_seq_trans_financ,
	nr_seq_movto_estorno_w,
	coalesce(a.vl_recebido,0) * -1,
	coalesce(a.vl_transacao,0) * -1,
	CASE WHEN coalesce(a.vl_transacao_estrang,0)=0 THEN null  ELSE a.vl_transacao_estrang * -1 END , --Projeto Multimoeda - Grava os valores quando moeda estrangeira
	CASE WHEN coalesce(a.vl_transacao_estrang,0)=0 THEN null  ELSE a.vl_complemento * -1 END ,
	CASE WHEN coalesce(a.vl_transacao_estrang,0)=0 THEN null  ELSE a.vl_cotacao END ,
	CASE WHEN coalesce(a.vl_transacao_estrang,0)=0 THEN null  ELSE a.cd_moeda END
from	movto_trans_financ a
where	a.nr_sequencia	= nr_seq_movto_trans_p;

update	movto_trans_financ
set	ie_estorno	= 'O'
where	nr_sequencia	= nr_seq_movto_trans_p;

nr_seq_movto_estorno_p	:= nr_seq_movto_estorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE estornar_movto_trans_financ (nr_seq_movto_trans_p bigint, nm_usuario_p text, nr_seq_movto_estorno_p INOUT bigint) FROM PUBLIC;
