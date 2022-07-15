-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_dev_cheque_deposito (nr_seq_movto_p bigint, nr_cheque_p text, cd_banco_p bigint, cd_agencia_bancaria_p text, nr_conta_p text, vl_cheque_p bigint, cd_pessoa_fisica_p text, cd_cgc_p text, nr_seq_trans_fin_dev_p bigint, nr_seq_motivo_dev_p bigint, dt_devolucao_p timestamp, nm_usuario_p text, ie_origem_cheque_p text, cd_tipo_portador_p bigint, cd_portador_p bigint) AS $body$
DECLARE


cd_estabelecimento_w		smallint;
nr_seq_cheque_w			bigint;
nr_seq_banco_w			bigint;
cd_moeda_w			bigint;
dt_transacao_w			timestamp;
nr_seq_movto_w			bigint;
pr_taxa_juro_padrao_w		double precision;
pr_taxa_multa_padrao_w		double precision;
cd_tipo_taxa_juro_w		bigint;
cd_tipo_taxa_multa_w		bigint;
nr_seq_grupo_prod_w		bigint;
nr_seq_produto_w		bigint;


BEGIN

if (coalesce(nr_seq_motivo_dev_p,0)	= 0) then
	/* Motivo de devolução não informado! */

	CALL wheb_mensagem_pck.exibir_mensagem_abort(218427);
end if;

if (coalesce(nr_seq_trans_fin_dev_p,0)	= 0) then
	/* Transação financeira de devolução não informada! */

	CALL wheb_mensagem_pck.exibir_mensagem_abort(218428);
end if;

if (coalesce(vl_cheque_p,0)	= 0) then
	/* Não é possível gerar um cheque com valor 0! */

	CALL wheb_mensagem_pck.exibir_mensagem_abort(218429);
end if;

select	max(c.cd_estabelecimento),
	max(b.nr_seq_conta),
	max(a.dt_transacao)
into STRICT	cd_estabelecimento_w,
	nr_seq_banco_w,
	dt_transacao_w
from	banco_estabelecimento c,
	banco_saldo b,
	movto_trans_financ a
where	a.nr_sequencia		= nr_seq_movto_p
and	a.nr_seq_saldo_banco	= b.nr_sequencia
and	b.nr_seq_conta		= c.nr_sequencia;

begin
select	pr_juro_padrao,
		pr_multa_padrao,
		cd_tipo_taxa_juro,
		cd_tipo_taxa_multa,
		cd_moeda_padrao
into STRICT	pr_taxa_juro_padrao_w,
		pr_taxa_multa_padrao_w,
		cd_tipo_taxa_juro_w,
		cd_tipo_taxa_multa_w,
		cd_moeda_w
from	parametro_contas_receber
where	cd_estabelecimento	= cd_estabelecimento_w;
exception when no_data_found then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(186551);
end;

SELECT * FROM obter_produto_financeiro(cd_estabelecimento_w, null, cd_cgc_p, nr_seq_produto_w, null, null, nr_seq_grupo_prod_w) INTO STRICT nr_seq_produto_w, nr_seq_grupo_prod_w;

select	nextval('cheque_cr_seq')
into STRICT	nr_seq_cheque_w
;

insert	into cheque_cr(nr_seq_cheque,
	dt_atualizacao,
	nm_usuario,
	cd_banco,
	cd_agencia_bancaria,
	nr_conta,
	nr_cheque,
	vl_cheque,
	cd_moeda,
	cd_pessoa_fisica,
	cd_cgc,
	nm_usuario_devolucao,
	dt_devolucao_banco,
	dt_registro,
	cd_estabelecimento,
	nr_seq_motivo_dev,
	ie_lib_caixa,
	vl_terceiro,
	dt_contabil,
	ie_deposito_paciente,
	dt_deposito,
	ie_origem_cheque,
	cd_tipo_portador,
	cd_portador,
	tx_juros_cobranca,
	tx_multa_cobranca,
	cd_tipo_taxa_juros,
	cd_tipo_taxa_multa,
	nr_seq_grupo_prod,
	nr_seq_produto)
values (nr_seq_cheque_w,
	clock_timestamp(),
	nm_usuario_p,
	cd_banco_p,
	cd_agencia_bancaria_p,
	nr_conta_p,
	nr_cheque_p,
	vl_cheque_p,
	cd_moeda_w,
	cd_pessoa_fisica_p,
	cd_cgc_p,
	nm_usuario_p,
	null,
	clock_timestamp(),
	cd_estabelecimento_w,
	nr_seq_motivo_dev_p,
	'S',
	0,
	clock_timestamp(),
	'S',
	dt_transacao_w,
	ie_origem_cheque_p,
	cd_tipo_portador_p,
	cd_portador_p,
	pr_taxa_juro_padrao_w,
	pr_taxa_multa_padrao_w,
	cd_tipo_taxa_juro_w,
	cd_tipo_taxa_multa_w,
	nr_seq_grupo_prod_w,
	nr_seq_produto_w);

select	nextval('movto_trans_financ_seq')
into STRICT	nr_seq_movto_w
;

insert	into movto_trans_financ(nr_sequencia,
	dt_transacao,
	nr_seq_trans_financ,
	vl_transacao,
	dt_atualizacao,
	nm_usuario,
	nr_seq_banco,
	cd_pessoa_fisica,
	cd_cgc,
	nr_seq_cheque,
	nr_lote_contabil,
	ie_conciliacao,
	ie_origem_lancamento,
	nr_seq_motivo_dev,
	nr_seq_movto_transf)
SELECT	nr_seq_movto_w,
	dt_devolucao_p,
	nr_seq_trans_fin_dev_p,
	vl_cheque_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_banco_w,
	cd_pessoa_fisica_p,
	cd_cgc_p,
	nr_seq_cheque_w,
	0,
	'N',
	'C',
	nr_seq_motivo_dev_p,
	nr_seq_movto_p
;

CALL Atualizar_transacao_financeira(cd_estabelecimento_w,nr_seq_movto_w,nm_usuario_p,'I');

CALL gerar_cheque_cr_hist(nr_seq_cheque_w,wheb_mensagem_pck.get_texto(304578),'N',nm_usuario_p);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_dev_cheque_deposito (nr_seq_movto_p bigint, nr_cheque_p text, cd_banco_p bigint, cd_agencia_bancaria_p text, nr_conta_p text, vl_cheque_p bigint, cd_pessoa_fisica_p text, cd_cgc_p text, nr_seq_trans_fin_dev_p bigint, nr_seq_motivo_dev_p bigint, dt_devolucao_p timestamp, nm_usuario_p text, ie_origem_cheque_p text, cd_tipo_portador_p bigint, cd_portador_p bigint) FROM PUBLIC;

