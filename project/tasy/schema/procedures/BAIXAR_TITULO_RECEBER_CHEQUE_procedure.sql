-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixar_titulo_receber_cheque (nr_titulo_p bigint, nr_seq_cheque_p bigint, nm_usuario_p text) AS $body$
DECLARE


vl_cheque_w			double precision 	:= 0;
vl_saldo_titulo_w		double precision	:= 0;
nr_adiantamento_w		bigint	:= 0;
nr_sequencia_w			integer	:= 0;
cd_moeda_w			integer	:= 0;
cd_estabelecimento_w		smallint;
/* Projeto Multimoeda - Variáveis */

vl_cheque_estrang_w		double precision;
vl_complemento_w		double precision;
vl_cotacao_w			cotacao_moeda.vl_cotacao%type;
cd_moeda_estrang_w		integer;
vl_cotacao_tit_w		cotacao_moeda.vl_cotacao%type;
cd_moeda_tit_w			integer;
vl_var_cambial_w		double precision;
vl_cambial_ativo_w		double precision := 0;
vl_cambial_passivo_w		double precision := 0;
dt_real_recebimento_w		titulo_receber_liq.dt_real_recebimento%type;


BEGIN

select	vl_cheque,
	obter_saldo_titulo_receber(nr_titulo_p, clock_timestamp()),
	coalesce(nr_adiantamento,0),
	cd_estabelecimento,
	vl_cheque_estrang,
	vl_cotacao,
	cd_moeda,
	dt_compensacao
into STRICT	vl_cheque_w,
	vl_saldo_titulo_w,
	nr_adiantamento_w,
	cd_estabelecimento_w,
	vl_cheque_estrang_w,
	vl_cotacao_w,
	cd_moeda_estrang_w,
	dt_real_recebimento_w
from 	cheque_cr
where	nr_seq_cheque	= nr_seq_cheque_p;


select	coalesce(max(cd_moeda_padrao),1)
into STRICT		cd_moeda_w
from		parametro_contas_receber;


if (vl_cheque_w > 0) and (vl_cheque_w <= vl_saldo_titulo_w) then
	begin
	select	coalesce(max(nr_sequencia),0) + 1
	into STRICT	nr_sequencia_w
	from	titulo_receber_liq
	where	nr_titulo	= nr_titulo_p;

	/* Projeto Multimoeda - Verifica se o cheque é em moeda estrangeira, caso positivo calcula o complemento para gravar na baixa,
			caso negativo limpa as variáveis antes de gravar a baixa. */
	if (coalesce(vl_cheque_estrang_w,0) <> 0 and coalesce(vl_cotacao_w,0) <> 0) then
		vl_complemento_w := vl_cheque_w - vl_cheque_estrang_w;
	else
		vl_cheque_estrang_w	:= null;
		vl_complemento_w	:= null;
		vl_cotacao_w		:= null;
		cd_moeda_estrang_w	:= null;
	end if;

	/* Projeto Multimoeda - Busca os dados do título para verificar a existência de variação cambial para títulos em moeda estrangeira quando a baixa for realizada na mesma moeda do título.
		Caso seja a mesma moeda e exista cotação no título e na baixa, calcula a variação entre a emissão do título e a baixa a ser realizada para gravar a variação passiva caso o
		valor seja negativo ou a variação passiva caso seja positivo. */
	select	max(cd_moeda),
		max(vl_cotacao)
	into STRICT	cd_moeda_tit_w,
		vl_cotacao_tit_w
	from 	titulo_receber
	where	nr_titulo = nr_titulo_p;
	if (coalesce(cd_moeda_tit_w,0) <> 0 and coalesce(vl_cotacao_tit_w,0) <> 0
		and coalesce(cd_moeda_estrang_w,0) <> 0 and coalesce(vl_cotacao_w,0) <> 0) then
		if (cd_moeda_tit_w = cd_moeda_estrang_w) then
			vl_var_cambial_w := (coalesce(vl_cheque_estrang_w,0) * vl_cotacao_tit_w) - (coalesce(vl_cheque_estrang_w,0) * vl_cotacao_w);
			if (vl_var_cambial_w < 0) then
				vl_cambial_passivo_w := vl_var_cambial_w * -1;
				vl_cambial_ativo_w := 0;
			else
				vl_cambial_passivo_w := 0;
				vl_cambial_ativo_w := vl_var_cambial_w;
			end if;
		end if;
	end if;

	insert into titulo_receber_liq(nr_titulo,
		nr_sequencia,
		dt_recebimento,
		vl_recebido,
		vl_descontos,
		vl_juros,
		vl_multa,
		cd_moeda,
		dt_atualizacao,
		nm_usuario,
		cd_tipo_recebimento,
		ie_acao,
		cd_serie_nf_devol,
		nr_nota_fiscal_devol,
		cd_banco,
		cd_agencia_bancaria,
		nr_documento,
		nr_lote_banco,
		cd_cgc_emp_cred,
		nr_cartao_cred,
		nr_adiantamento,
		nr_lote_contabil,
		nr_seq_trans_fin,
		vl_rec_maior,
		vl_glosa,
		ie_lib_caixa,
		nr_lote_contab_antecip,
		nr_lote_contab_pro_rata,
		vl_recebido_estrang,
		vl_complemento,
		vl_cotacao,
		vl_cambial_passivo,
		vl_cambial_ativo,
		dt_real_recebimento)
	values (nr_titulo_p,
		nr_sequencia_w,
		clock_timestamp(),
		vl_cheque_w,
		0,
		0,
		0,
		coalesce(cd_moeda_estrang_w,cd_moeda_w), -- Projeto Multimoeda - grava moeda estrangeira quando o cheque for em moeda estrangeira
		clock_timestamp(),
		nm_usuario_p,
		3,
		'I',
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		null,
		0,
		null,
		0,
		0,
		'S',
		0,
		0,
		vl_cheque_estrang_w,
		vl_complemento_w,
		vl_cotacao_w,
		vl_cambial_passivo_w,
		vl_cambial_ativo_w,
		dt_real_recebimento_w);

	/* Francisco - OS 194892 - 10/02/2010 */

	CALL pls_gerar_amortizacao_regra(nr_titulo_p,nr_sequencia_w,nm_usuario_p,'N');

	/* Francisco - 28/09/2010 */

	CALL pls_apropriar_juros_multa_mens(nr_titulo_p,nr_sequencia_w,nm_usuario_p,cd_estabelecimento_w,'N','I');

	if (nr_adiantamento_w > 0) then
		update	adiantamento
		set	dt_baixa 	= clock_timestamp(),
			nm_usuario	= nm_usuario_p
		where 	nr_adiantamento	= nr_adiantamento_w;
	end if;

	/* update	cheque_cr
	set	dt_deposito 	= sysdate,
		nm_usuario		= nm_usuario_p,
		nr_titulo		= nr_titulo_p
	where 	nr_seq_cheque	= nr_seq_cheque_p;    Francisco - OS 41205 - Comentei o update*/
	CALL atualizar_saldo_tit_rec(nr_titulo_p, nm_usuario_p);

	end;
else
     CALL wheb_mensagem_pck.exibir_mensagem_abort(247000);
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixar_titulo_receber_cheque (nr_titulo_p bigint, nr_seq_cheque_p bigint, nm_usuario_p text) FROM PUBLIC;

