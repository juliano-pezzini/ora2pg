-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_adiant_movto_bco_pend ( nr_seq_movto_baixa_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_acao_p text, nr_adiantamento_p INOUT bigint) AS $body$
DECLARE


/* ie_acao_p
'G'	Gerar adiantamento
'D'	Devolver adiantamento
*/
cd_cgc_w			varchar(14);
cd_moeda_w			integer;
cd_pessoa_fisica_w		varchar(10);
cd_tipo_recebimento_w		integer;
vl_adiantamento_w		double precision;
nr_adiantamento_w		bigint;
nr_seq_movto_pend_w		bigint;
nr_seq_devolucao_w		integer;
nr_seq_tipo_baixa_w		bigint;
/* Projeto Multimoeda - Variáveis */

vl_adto_estrang_w		double precision;
vl_complemento_w		double precision;
vl_cotacao_w			cotacao_moeda.vl_cotacao%type;
cd_moeda_estrang_w		integer;


BEGIN
if (coalesce(ie_acao_p,'G') = 'G') then
	select	max(substr(obter_pessoa_movto_trans(c.nr_sequencia,'CF','GE'),1,255)),
		max(substr(obter_pessoa_movto_trans(c.nr_sequencia,'CJ','GE'),1,255)),
		max(a.vl_baixa),
		max(a.vl_baixa_estrang),
		max(a.vl_cotacao),
		max(a.cd_moeda)
	into STRICT	cd_pessoa_fisica_w,
		cd_cgc_w,
		vl_adiantamento_w,
		vl_adto_estrang_w,
		vl_cotacao_w,
		cd_moeda_estrang_w
	FROM movto_banco_pend_baixa a, movto_banco_pend b
LEFT OUTER JOIN movto_trans_financ c ON (b.nr_seq_movto_trans_fin = c.nr_sequencia)
WHERE a.nr_sequencia			= nr_seq_movto_baixa_p and a.nr_seq_movto_pend		= b.nr_sequencia;

	select	max(a.cd_tipo_recebimento)
	into STRICT	cd_tipo_recebimento_w
	from	tipo_recebimento a
	where	a.ie_tipo_consistencia	= 13
	and     ((a.cd_estabelecimento = cd_estabelecimento_p) or (coalesce(a.cd_estabelecimento::text, '') = ''));

	select	max(a.cd_moeda_padrao)
	into STRICT	cd_moeda_w
	from	parametro_contas_receber a
	where	a.cd_estabelecimento	= cd_estabelecimento_p;

	/* Projeto Multimoeda - Verifica se o crédito é em moeda estrangeira, caso positivo calcula o complemento, caso negativo limpa as variáveis*/

	if (coalesce(vl_adto_estrang_w,0) <> 0 and coalesce(vl_cotacao_w,0) <> 0) then
		vl_complemento_w := vl_adiantamento_w - vl_adto_estrang_w;
	else
		vl_adto_estrang_w := null;
		vl_complemento_w := null;
		vl_cotacao_w := null;
		cd_moeda_estrang_w := null;
	end if;

	select	nextval('adiantamento_seq')
	into STRICT	nr_adiantamento_w
	;

	insert	into adiantamento(cd_cgc,
		cd_estabelecimento,
		cd_moeda,
		cd_pessoa_fisica,
		cd_tipo_recebimento,
		dt_adiantamento,
		dt_atualizacao,
		dt_contabil,
		ie_situacao,
		nm_usuario,
		nr_adiantamento,
		vl_adiantamento,
		vl_saldo,
		vl_adto_estrang,
		vl_saldo_estrang,
		vl_complemento,
		vl_cotacao)
	values (cd_cgc_w,
		cd_estabelecimento_p,
		coalesce(cd_moeda_estrang_w,cd_moeda_w),  -- Projeto Multimoeda - Grava a moeda estrangeira caso exista, caso contrário grava a moeda padrão
		cd_pessoa_fisica_w,
		cd_tipo_recebimento_w,
		clock_timestamp(),
		clock_timestamp(),
		clock_timestamp(),
		'A',
		nm_usuario_p,
		nr_adiantamento_w,
		vl_adiantamento_w,
		vl_adiantamento_w,
		vl_adto_estrang_w,
		vl_adto_estrang_w,
		vl_complemento_w,
		vl_cotacao_w);

	select	max(a.nr_sequencia)
	into STRICT	nr_seq_tipo_baixa_w
	from	tipo_baixa_cni a
	where	a.cd_estabelecimento	= cd_estabelecimento_p
	and	a.ie_situacao		= 'A'
	and	a.ie_tipo_baixa		= 4;

	update	movto_banco_pend_baixa
	set	nr_adiantamento		= nr_adiantamento_w,
		nr_seq_tipo_baixa	= nr_seq_tipo_baixa_w
	where	nr_sequencia		= nr_seq_movto_baixa_p;
elsif (ie_acao_p = 'D') then
	select	max(a.nr_adiantamento),
		max(a.nr_seq_movto_pend)
	into STRICT	nr_adiantamento_w,
		nr_seq_movto_pend_w
	from	movto_banco_pend_baixa a
	where	a.nr_sequencia	= nr_seq_movto_baixa_p;

	select	coalesce(max(a.nr_sequencia),0) + 1
	into STRICT	nr_seq_devolucao_w
	from	adiantamento_dev a
	where	a.nr_adiantamento	= nr_adiantamento_w;

	insert	into adiantamento_dev(cd_moeda,
		ds_motivo_dev,
		dt_atualizacao,
		dt_devolucao,
		nm_usuario,
		nr_adiantamento,
		nr_sequencia,
		vl_devolucao,
		vl_devolucao_estrang,
		vl_complemento,
		vl_cotacao)
	SELECT	a.cd_moeda,
		substr(wheb_mensagem_pck.get_texto(302764,	'NR_SEQ_MOVTO_BAIXA=' || nr_seq_movto_baixa_p || ';' ||
							'NR_SEQ_MOVTO_PEND=' || nr_seq_movto_pend_w),1,255),
		clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		a.nr_adiantamento,
		nr_seq_devolucao_w,
		a.vl_saldo,
		CASE WHEN coalesce(a.vl_adto_estrang::text, '') = '' THEN null  ELSE a.vl_saldo_estrang END ,
		CASE WHEN coalesce(a.vl_adto_estrang::text, '') = '' THEN null  ELSE (a.vl_saldo - a.vl_saldo_estrang) END ,
		CASE WHEN coalesce(a.vl_adto_estrang::text, '') = '' THEN null  ELSE a.vl_cotacao END
	from	adiantamento a
	where	a.nr_adiantamento	= nr_adiantamento_w;

	CALL atualizar_saldo_adiantamento(	nr_adiantamento_w,
					nm_usuario_p,
					null);
end if;

nr_adiantamento_p	:= nr_adiantamento_w;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_adiant_movto_bco_pend ( nr_seq_movto_baixa_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, ie_acao_p text, nr_adiantamento_p INOUT bigint) FROM PUBLIC;
