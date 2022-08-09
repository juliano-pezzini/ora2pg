-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE estornar_movto_banco (cd_estabelecimento_p bigint, nr_seq_movto_p bigint, dt_estorno_p timestamp, nm_usuario_p text, ie_commit_p text) AS $body$
DECLARE


nr_sequencia_w			bigint;
dt_transacao_w			timestamp;
nr_seq_trans_financ_w		bigint;
vl_transacao_w			double precision;
vl_recebido_w			double precision;
nr_seq_banco_w			bigint;
nr_seq_caixa_w			bigint;
cd_pessoa_fisica_w		varchar(10);
cd_cgc_w			varchar(14);
nr_seq_titulo_pagar_w		bigint;
nr_seq_titulo_receber_w		bigint;
nr_bordero_w			bigint;
nr_adiantamento_w		bigint;
nr_seq_banco_od_w		bigint;
nr_seq_caixa_od_w		bigint;
nr_seq_movto_estorno_w		bigint;
cd_conta_contabil_w		varchar(20);
cd_centro_custo_w		integer;
nr_seq_nota_fiscal_w		bigint;
nr_interno_conta_w		bigint;
nr_documento_w			varchar(22);
ds_historico_w			varchar(255);
dt_referencia_saldo_w		timestamp;
nr_seq_lote_w			bigint;
dt_fechamento_lote_w		timestamp;
cd_tipo_recebimento_w		integer;
cd_tipo_baixa_cpa_w		integer;
nr_seq_cheque_w			bigint;
nr_seq_conv_receb_w		bigint;
nr_seq_deposito_w		bigint;
nr_seq_saldo_caixa_w		bigint;
nr_seq_saldo_banco_w		bigint;
nr_seq_banco_escrit_w		bigint;
dt_autenticacao_w		timestamp;
nr_lote_contabil_w		bigint;
nr_seq_concil_w			bigint;
nr_adiant_pago_w		bigint;
ie_conciliacao_w		varchar(1);
nr_seq_cheque_cp_w		bigint;
ie_origem_lancamento_w		varchar(1);
cd_historico_w			bigint;
nr_bordero_rec_w		bigint;
nr_seq_movto_cartao_w		bigint;
nr_seq_motivo_dev_w		bigint;
nr_seq_caixa_rec_w		bigint;
nr_seq_movto_transf_w		bigint;
dt_conferencia_w		timestamp;
ie_estornar_bordero_receb_w	varchar(1);
ie_estornar_trans_saldo_banc_w	varchar(255);
ie_saldo_caixa_w		varchar(255);
nr_seq_movto_orig_w		bigint;
nr_seq_movto_pend_w		bigint;
vl_movto_pend_baixa_w		double precision;
cd_conta_financ_w		bigint;
nr_Seq_perda_w			bigint;
qt_movto_w			bigint;
nr_seq_aplicacao_w		bigint;
/* Projeto Multimoeda - Variaveis*/

vl_transacao_estrang_w		double precision;
vl_complemento_w		double precision;
vl_cotacao_w			cotacao_moeda.vl_cotacao%type;
cd_moeda_w			integer;
ie_estornar_concil_w	varchar(1);
nr_seq_proj_rec_w		movto_trans_financ.nr_seq_proj_rec%type;
nr_seq_baixa_origem_w			titulo_pagar_baixa.nr_seq_baixa_origem%type;
nr_titulo_w				titulo_pagar_baixa.nr_titulo%type;
nr_seq_movto_transf_bco_w		movto_trans_financ.nr_seq_movto_transf_bco%type;
ie_origem_lanc_transf_bco_w		movto_trans_financ.ie_origem_lancamento%type;


BEGIN

select	count(*)
into STRICT	qt_movto_w
from	movto_trans_financ a
where	a.nr_sequencia	= nr_seq_movto_p;

if (qt_movto_w	= 0) then
	/* O movimento nr_seq_movto_p nao foi encontrado no sistema! */

	CALL wheb_mensagem_pck.exibir_mensagem_abort(238692,'NR_SEQ_MOVTO_P='||nr_seq_movto_p);
end if;

select	coalesce(max(nr_sequencia),0)
into STRICT	nr_seq_movto_estorno_w
from	movto_trans_financ
where	nr_seq_movto_orig	= nr_seq_movto_p;

if (nr_seq_movto_estorno_w > 0) then
	/* Esta movimentacao ja foi estornada!
	Seq movimento: nr_seq_movto_estorno_w */
	CALL wheb_mensagem_pck.exibir_mensagem_abort(238688,'NR_SEQ_MOVTO_ESTORNO_W='||nr_seq_movto_estorno_w);
end if;

select	a.nr_seq_trans_financ,
	a.vl_transacao,
	a.vl_recebido,
	a.nr_seq_banco,
	a.cd_pessoa_fisica,
	a.cd_cgc,
	a.nr_seq_titulo_pagar,
	a.nr_seq_titulo_receber,
	a.nr_bordero,
	a.nr_adiantamento,
	a.nr_seq_banco_od,
	a.nr_seq_caixa_od,
	a.cd_conta_contabil,
	a.cd_centro_custo,
	a.nr_seq_nota_fiscal,
	a.nr_interno_conta,
	a.nr_documento,
	a.ds_historico,
	a.dt_referencia_saldo,
	a.dt_fechamento_lote,
	a.cd_tipo_recebimento,
	a.cd_tipo_baixa_cpa,
	a.nr_seq_cheque,
	a.nr_seq_conv_receb,
	a.nr_seq_deposito,
	a.nr_seq_saldo_banco,
	a.nr_seq_banco_escrit,
	a.dt_autenticacao,
	a.nr_lote_contabil,
	a.nr_seq_concil,
	a.nr_adiant_pago,
	a.ie_conciliacao,
	a.nr_seq_cheque_cp,
	a.ie_origem_lancamento,
	a.cd_historico,
	a.nr_bordero_rec,
	a.nr_seq_movto_cartao,
	a.nr_seq_motivo_dev,
	a.nr_seq_movto_orig,
	a.cd_conta_financ,
	a.nr_Seq_perda,
	b.ie_saldo_caixa,
	vl_transacao_estrang,  -- Projeto Multimoeda - Busca os dados referentes a transacao em moeda estrangeira
	vl_complemento,
	vl_cotacao,
	cd_moeda,
	a.nr_seq_aplicacao,
	a.nr_seq_proj_rec,
	a.nr_seq_movto_transf_bco
into STRICT	nr_seq_trans_financ_w,
	vl_transacao_w,
	vl_recebido_w,
	nr_seq_banco_w,
	cd_pessoa_fisica_w,
	cd_cgc_w,
	nr_seq_titulo_pagar_w,
	nr_seq_titulo_receber_w,
	nr_bordero_w,
	nr_adiantamento_w,
	nr_seq_banco_od_w,
	nr_seq_caixa_od_w,
	cd_conta_contabil_w,
	cd_centro_custo_w,
	nr_seq_nota_fiscal_w,
	nr_interno_conta_w,
	nr_documento_w,
	ds_historico_w,
	dt_referencia_saldo_w,
	dt_fechamento_lote_w,
	cd_tipo_recebimento_w,
	cd_tipo_baixa_cpa_w,
	nr_seq_cheque_w,
	nr_seq_conv_receb_w,
	nr_seq_deposito_w,
	nr_seq_saldo_banco_w,
	nr_seq_banco_escrit_w,
	dt_autenticacao_w,
	nr_lote_contabil_w,
	nr_seq_concil_w,
	nr_adiant_pago_w,
	ie_conciliacao_w,
	nr_seq_cheque_cp_w,
	ie_origem_lancamento_w,
	cd_historico_w,
	nr_bordero_rec_w,
	nr_seq_movto_cartao_w,
	nr_seq_motivo_dev_w,
	nr_seq_movto_orig_w,
	cd_conta_financ_w,
	nr_Seq_perda_w,
	ie_saldo_caixa_w,
	vl_transacao_estrang_w,
	vl_complemento_w,
	vl_cotacao_w,
	cd_moeda_w,
	nr_seq_aplicacao_w,
	nr_seq_proj_rec_w,
	nr_seq_movto_transf_bco_w
from	transacao_financeira b,
	movto_trans_financ a
where	a.nr_seq_trans_financ	= b.nr_sequencia
and	a.nr_sequencia		= nr_seq_movto_p;

if (nr_seq_movto_orig_w IS NOT NULL AND nr_seq_movto_orig_w::text <> '') then
	/* Este movimento foi gerado a partir de um estorno, nao pode ser estornado! */

	CALL wheb_mensagem_pck.exibir_mensagem_abort(238695);
end if;


if (nr_seq_movto_transf_bco_w IS NOT NULL AND nr_seq_movto_transf_bco_w::text <> '') then

	select max(a.ie_origem_lancamento)
	into STRICT ie_origem_lanc_transf_bco_w
	from	movto_trans_financ a
	where	a.nr_sequencia	= nr_seq_movto_transf_bco_w;

	if nr_seq_movto_p != nr_seq_movto_transf_bco_w and ie_origem_lanc_transf_bco_w = 'C' then
		/*Nao foi possivel estornar a transacao, pois foi gerada automaticamente. E necessario estornar a transacao de origem: #@NR_SEQ_MOVTO_TRANSF_BCO#@*/

		CALL wheb_mensagem_pck.exibir_mensagem_abort(1126801,'NR_SEQ_MOVTO_TRANSF_BCO='||nr_seq_movto_transf_bco_w);
	end if;

end if;

ie_estornar_concil_w := Obter_Param_Usuario(814, 100, obter_perfil_ativo, wheb_usuario_pck.get_nm_usuario, obter_estabelecimento_ativo, ie_estornar_concil_w);

if	((ie_conciliacao_w	= 'S') or (nr_seq_concil_w IS NOT NULL AND nr_seq_concil_w::text <> '')) and (coalesce(ie_estornar_concil_w,'S') = 'N') then
	/* O lancamento a ser estornado ja foi conciliado! Nao e possivel estorna-lo. */

	CALL wheb_mensagem_pck.exibir_mensagem_abort(238696);
end if;

ie_estornar_bordero_receb_w := obter_param_usuario(814, 25, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_estornar_bordero_receb_w);
ie_estornar_trans_saldo_banc_w := obter_param_usuario(814, 33, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_estornar_trans_saldo_banc_w);

if (coalesce(ie_estornar_bordero_receb_w,'S') = 'N') and (nr_bordero_rec_w IS NOT NULL AND nr_bordero_rec_w::text <> '') then
	/* A baixa de bordero recebimento deve ser estornada pela funcao. Parametro [25] */

	CALL wheb_mensagem_pck.exibir_mensagem_abort(238715);
end if;

if (coalesce(ie_estornar_trans_saldo_banc_w,'S') = 'N') and (ie_saldo_caixa_w in ('E','S')) then
	/* Sem permissao para estornar transacoes que integram saldo de caixa. Parametro [33] */

	CALL wheb_mensagem_pck.exibir_mensagem_abort(238717);
end if;

/* Projeto multimoeda - Verifica se a transacao se refere a uma transacao em moeda estrangeira, caso positivo inverte os valores da transacao, caso negativo limpa as variaveis antes de gravar o estorno. */

if (coalesce(vl_transacao_estrang_w,0) <> 0 and (cd_moeda_w IS NOT NULL AND cd_moeda_w::text <> '')) then
	vl_transacao_estrang_w	:= vl_transacao_estrang_w * -1;
	vl_complemento_w	:= vl_complemento_w * -1;
else
	vl_transacao_estrang_w	:= null;
	vl_complemento_w	:= null;
	vl_cotacao_w		:= null;
	cd_moeda_w		:= null;
end if;

select	nextval('movto_trans_financ_seq')
into STRICT	nr_sequencia_w
;

dt_transacao_w	:= dt_estorno_p;

insert into movto_trans_financ(nr_sequencia,
	dt_transacao,
	nr_seq_trans_financ,
	vl_transacao,
	dt_atualizacao,
	nm_usuario,
	vl_recebido,
	nr_seq_banco,
	cd_pessoa_fisica,
	cd_cgc,
	nr_seq_titulo_pagar,
	nr_seq_titulo_receber,
	nr_bordero,
	nr_adiantamento,
	nr_seq_banco_od,
	nr_seq_caixa_od,
	cd_conta_contabil,
	cd_centro_custo,
	nr_seq_nota_fiscal,
	nr_interno_conta,
	nr_documento,
	ds_historico,
	dt_referencia_saldo,
	dt_fechamento_lote,
	cd_tipo_recebimento,
	cd_tipo_baixa_cpa,
	nr_seq_cheque,
	nr_seq_conv_receb,
	nr_seq_deposito,
	nr_seq_saldo_banco,
	nr_seq_banco_escrit,
	dt_autenticacao,
	nr_lote_contabil,
	nr_seq_concil,
	nr_adiant_pago,
	ie_conciliacao,
	nr_seq_cheque_cp,
	ie_origem_lancamento,
	cd_historico,
	nr_bordero_rec,
	nr_seq_movto_cartao,
	nr_seq_motivo_dev,
	ie_estorno,
	nr_seq_movto_orig,
	cd_conta_financ,
	nr_Seq_perda,
	vl_transacao_estrang,
	vl_complemento,
	vl_cotacao,
	cd_moeda,
	nr_seq_aplicacao,
	nr_seq_proj_rec)
values (nr_sequencia_w,
	dt_transacao_w,
	nr_seq_trans_financ_w,
	vl_transacao_w * -1,
	clock_timestamp(),
	nm_usuario_p,
	vl_recebido_w,
	nr_seq_banco_w,
	cd_pessoa_fisica_w,
	cd_cgc_w,
	nr_seq_titulo_pagar_w,
	nr_seq_titulo_receber_w,
	nr_bordero_w,
	nr_adiantamento_w,
	nr_seq_banco_od_w,
	nr_seq_caixa_od_w,
	cd_conta_contabil_w,
	cd_centro_custo_w,
	nr_seq_nota_fiscal_w,
	nr_interno_conta_w,
	nr_documento_w,
	ds_historico_w,
	dt_referencia_saldo_w,
	dt_fechamento_lote_w,
	cd_tipo_recebimento_w,
	cd_tipo_baixa_cpa_w,
	nr_seq_cheque_w,
	nr_seq_conv_receb_w,
	nr_seq_deposito_w,
	nr_seq_saldo_banco_w,
	nr_seq_banco_escrit_w,
	dt_autenticacao_w,
	0,
	nr_seq_concil_w,
	nr_adiant_pago_w,
	'N',
	nr_seq_cheque_cp_w,
	ie_origem_lancamento_w,
	cd_historico_w,
	nr_bordero_rec_w,
	nr_seq_movto_cartao_w,
	nr_seq_motivo_dev_w,
	'E',
	nr_seq_movto_p,
	cd_conta_financ_w,
	nr_Seq_perda_w,
	vl_transacao_estrang_w,
	vl_complemento_w,
	vl_cotacao_w,
	cd_moeda_w,
	nr_seq_aplicacao_w,
	nr_seq_proj_rec_w);

select	max(a.nr_seq_movto_pend),
	max(a.vl_baixa)
into STRICT	nr_seq_movto_pend_w,
	vl_movto_pend_baixa_w
from	movto_banco_pend_baixa a
where	a.nr_seq_movto_trans_fin	= nr_seq_movto_p;

if (nr_seq_movto_pend_w IS NOT NULL AND nr_seq_movto_pend_w::text <> '') then	/* ahoffelder - OS 312671 - 25/04/2011 */
	CALL baixar_movto_banco_pend(	nr_seq_movto_pend_w,
					coalesce(dt_transacao_w, clock_timestamp()),
					vl_movto_pend_baixa_w * -1,
					null,
					null,
					nm_usuario_p,
					'N',
					null,
					null,
					null,
					null,
					nr_sequencia_w,
					null,
					null,
					null);

end if;

select max(nr_sequencia),
  max(nr_titulo)
into STRICT nr_seq_baixa_origem_w,
  nr_titulo_w
from titulo_pagar_baixa
where nr_seq_movto_trans_fin = nr_seq_movto_p;

CALL Atualizar_Transacao_Financeira(cd_estabelecimento_p,
				nr_sequencia_w,
				nm_usuario_p,
				'E');

if (nr_seq_baixa_origem_w IS NOT NULL AND nr_seq_baixa_origem_w::text <> '') then
  update titulo_pagar_baixa
  set nr_seq_baixa_origem = nr_seq_baixa_origem_w 
  where nr_titulo = nr_titulo_w 
  and nr_sequencia = (SELECT max(nr_sequencia) from titulo_pagar_baixa where nr_titulo = nr_titulo_w);
end if;

if (ie_commit_p = 'S') then
	commit;
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE estornar_movto_banco (cd_estabelecimento_p bigint, nr_seq_movto_p bigint, dt_estorno_p timestamp, nm_usuario_p text, ie_commit_p text) FROM PUBLIC;
