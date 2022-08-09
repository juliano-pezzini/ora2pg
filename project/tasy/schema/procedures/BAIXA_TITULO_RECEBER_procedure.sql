-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixa_titulo_receber (cd_estabelecimento_p bigint, cd_tipo_recebimento_p bigint, nr_titulo_p bigint, nr_seq_trans_financ_p bigint, vl_baixa_p bigint, dt_recebimento_p timestamp, nm_usuario_p text, vl_glosa_p bigint, nr_bordero_p bigint, nr_seq_conta_banco_p bigint, vl_rec_maior_p bigint, vl_perdas_p bigint, nr_seq_movto_trans_fin_p bigint default null, vl_baixa_pend_estrang_p bigint default null, vl_cotacao_pend_p bigint default null, cd_moeda_pend_p bigint default null, nr_seq_lote_enc_p bigint default null, nr_seq_movto_bco_pend_p bigint default null, ie_gerar_baixa_trib_p text default 'S', nr_seq_lote_hist_guia_p bigint default null) AS $body$
DECLARE


/* Projeto Multimoeda - parâmetro nr_seq_movto_trans_fin_p se refere a nr_sequencia da tabela movto_trans_financ
	utilizado para buscar os dados de moeda estrangeira do movimento transação. Possui default null para
	que não seja necessário adicionar a todas as chamadas da procedure.
	Parâmetros vl_baixa_pend_estrang_p, vl_cotacao_pend_p e cd_moeda_pend_p vem do controle de crédito
	não identificado, utilizados para realizar a baixa do título em moeda estrangeira quando o crédito pendente
	estiver em moeda estrangeira. Parâmetros foram criados pois existe a possibilidade de realizar a baixa do 
	título antes de salvar o registro na baixa do crédito, através do parâmetro 9 da função CorFin_CC.
*/
cd_moeda_padrao_w		integer	:= 0;
nr_seq_baixa_w			integer	:= 0;
nr_seq_conta_banco_w		bigint;
vl_juros_w			double precision	:= 0;
vl_desconto_w			double precision	:= 0;
vl_multa_w			double precision	:= 0;
cd_centro_custo_desc_w		bigint;
nr_seq_motivo_desc_w		bigint;
vl_rec_maior_w			double precision	:= 0;
vl_perdas_w			double precision	:= 0;
nr_seq_solic_desc_w		bigint 	:= null;
ds_observacao_bordero_w		varchar(80);
vl_nota_credito_w		double precision;
nr_seq_regra_w			bigint;
ie_acao_w			varchar(5);
ie_acao_baixa_w			varchar(5);
ie_apropriar_w			varchar(1);
nr_seq_cob_previa_w		bigint;
vl_saldo_titulo_w		double precision;
nr_titulo_contab_w		bigint;
count_w				bigint;
/* Projeto Multimoeda - variáveis */

vl_baixa_estrang_w		double precision;
cd_moeda_w			integer;
vl_cotacao_w			cotacao_moeda.vl_cotacao%type;
vl_complemento_w		double precision;
vl_cotacao_tit_w		cotacao_moeda.vl_cotacao%type;
cd_moeda_tit_w			integer;
vl_var_cambial_w		double precision;
vl_cambial_ativo_w		double precision := 0;
vl_cambial_passivo_w		double precision := 0;
dt_real_recebimento_w		titulo_receber_liq.dt_real_recebimento%type;
dt_credito_banco_w		titulo_receber_liq.dt_credito_banco%type;

vl_baixa_w					titulo_receber_liq.vl_recebido%type;	
ie_acresc_bordero_w			parametro_contas_receber.ie_acresc_bordero%type;	
vl_abaixar_w				bordero_tit_rec.vl_abaixar%type;
ie_atualiza_valor_w			varchar(1);

C02 CURSOR FOR
	SELECT	nr_sequencia	
	from	titulo_receber_liq_desc
	where	nr_bordero	= nr_bordero_p
	and	nr_titulo	= nr_titulo_p;


BEGIN
begin
select	cd_moeda_padrao
into STRICT	cd_moeda_padrao_w
from	parametro_contas_receber
where	cd_estabelecimento	= cd_estabelecimento_p;
exception when no_data_found then
	CALL wheb_mensagem_pck.exibir_mensagem_abort(238485);
end;

select	coalesce(max(nr_sequencia),0) + 1
into STRICT	nr_seq_baixa_w
from	titulo_receber_liq
where	nr_titulo	= nr_titulo_p;

/* Projeto Multimoeda - Busca os dados da transação quando parâmetro não for nulo. */

if (nr_seq_movto_trans_fin_p IS NOT NULL AND nr_seq_movto_trans_fin_p::text <> '') then
	select max(vl_transacao_estrang),
		max(vl_cotacao),
		max(cd_moeda)
	into STRICT vl_baixa_estrang_w,
		vl_cotacao_w,
		cd_moeda_w
	from movto_trans_financ
	where nr_sequencia = nr_seq_movto_trans_fin_p
	  and coalesce(vl_transacao_estrang,0) <> 0;
end if;

/* Projeto Multimoeda - Verifica os parâmetros do crédito não identificado, se forem diferentes de 0 o crédito é em moeda estrangeira. 
		Passa os valores do parâmetro para a variável que será gravada na baixa do título. */
if (coalesce(vl_baixa_pend_estrang_p,0) <> 0 and coalesce(vl_cotacao_pend_p,0) <> 0 and coalesce(cd_moeda_pend_p,0) <> 0) then
	vl_baixa_estrang_w	:= vl_baixa_pend_estrang_p;
	vl_cotacao_w		:= vl_cotacao_pend_p;
	cd_moeda_w		:= cd_moeda_pend_p;
end if;

if (coalesce(nr_bordero_p,0) <> 0) then
	/* ahoffelder - 18/08/2009 - OS 160728 */

	select	max(ds_bordero),
			max(dt_recebimento)
	into STRICT	ds_observacao_bordero_w,
			dt_real_recebimento_w
	from	bordero_recebimento
	where	nr_bordero	= nr_bordero_p;

	
	select	coalesce(vl_juros,0),
		coalesce(vl_desconto,0),
		coalesce(vl_multa,0),
		coalesce(vl_rec_maior,0),
		coalesce(vl_perdas,0),
		cd_centro_custo_desc,
		nr_seq_motivo_desc,
		coalesce(vl_nota_credito,0),
		vl_abaixar_estrang,  -- Dados em moeda estrangeira do borderô
		vl_cotacao,
		cd_moeda,
		vl_abaixar
	into STRICT	vl_juros_w,
		vl_desconto_w,
		vl_multa_w,
		vl_rec_maior_w,
		vl_perdas_w,
		cd_centro_custo_desc_w,
		nr_seq_motivo_desc_w,
		vl_nota_credito_w,
		vl_baixa_estrang_w,
		vl_cotacao_w,
		cd_moeda_w,
		vl_abaixar_w
	from	bordero_tit_rec
	where	nr_titulo	= nr_titulo_p
	and	nr_bordero	= nr_bordero_p;
	
	select	max(a.nr_seq_cob_previa),
		max(a.vl_saldo_titulo)
	into STRICT	nr_seq_cob_previa_w,
		vl_saldo_titulo_w
	from	titulo_receber	a
	where	a.nr_titulo	= nr_titulo_p;

	select	max(nr_sequencia)
	into STRICT	nr_seq_solic_desc_w
	from	titulo_receber_liq_desc
	where	nr_bordero	= nr_bordero_p
	and	nr_titulo	= nr_titulo_p;

	begin
	select	nr_seq_conta_banco
	into STRICT	nr_seq_conta_banco_w
	from	bordero_recebimento
	where	nr_bordero = nr_bordero_p;
	exception
	when others then
		nr_seq_conta_banco_w	:= null;
	end;
	
	select	coalesce(max(a.ie_acresc_bordero),'S')
	into STRICT	ie_acresc_bordero_w
	from	parametro_contas_receber a
	where	cd_estabelecimento	= cd_estabelecimento_p;
	
	if (ie_acresc_bordero_w = 'S') and
	   ((coalesce(vl_abaixar_w,0) + coalesce(vl_juros_w,0) + coalesce(vl_multa_w,0) + coalesce(vl_rec_maior_w,0)) = coalesce(vl_baixa_p,0)) then
			vl_baixa_w 			:= coalesce(vl_baixa_p,0) - coalesce(vl_juros_w,0) - coalesce(vl_multa_w,0) - coalesce(vl_rec_maior_w,0);
			ie_atualiza_valor_w := 'S';	
	else
			ie_atualiza_valor_w := 'N';
	end if;
	
else
	vl_rec_maior_w	:= coalesce(vl_rec_maior_p, 0);
	vl_perdas_w	:= coalesce(vl_perdas_p, 0);
end if;

-- Quando a baixa ocorrer por crédito não identificado, gravar a data real de recebimento e a data de crédito no banco com a data do crédito não identificado
if (coalesce(nr_seq_movto_bco_pend_p,0) <> 0) then
	select 	max(dt_credito)
	into STRICT	dt_credito_banco_w
	from	movto_banco_pend
	where 	nr_sequencia = nr_seq_movto_bco_pend_p;
	
	dt_real_recebimento_w := dt_credito_banco_w;
end if;

/* Francisco - OS 87707 - 02/04/2008 */

if (coalesce(nr_seq_conta_banco_w::text, '') = '') then
	nr_seq_conta_banco_w	:= nr_seq_conta_banco_p;
end if;

/* Projeto Multimoeda - verifica a existência de valor em moeda estrangeira, caso não exista limpa os campos correspondentes */

if (coalesce(vl_baixa_estrang_w,0) <> 0 and coalesce(vl_cotacao_w,0) <> 0) then
	if (ie_atualiza_valor_w = 'S') then
		vl_complemento_w := vl_baixa_w - vl_baixa_estrang_w;
	else
		vl_complemento_w := vl_baixa_p - vl_baixa_estrang_w;
	end if;
else
	vl_baixa_estrang_w	:= null;
	vl_cotacao_w		:= null;
	vl_complemento_w	:= null;
	cd_moeda_w		:= null;
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
	and coalesce(cd_moeda_w,0) <> 0 and coalesce(vl_cotacao_w,0) <> 0) then
	if (cd_moeda_tit_w = cd_moeda_w) then
		vl_var_cambial_w := (coalesce(vl_baixa_estrang_w,0) * vl_cotacao_tit_w) - (coalesce(vl_baixa_estrang_w,0) * vl_cotacao_w);
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
	vl_rec_maior,
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
	vl_glosa,
	ie_lib_caixa,
	nr_bordero,
	nr_seq_conta_banco,
	cd_centro_custo_desc,
	nr_seq_motivo_desc,
	vl_perdas,
	ds_observacao,
	vl_nota_credito,
	nr_lote_contab_antecip,
	nr_lote_contab_pro_rata,
	vl_recebido_estrang,
	vl_cotacao,
	vl_complemento,
	nr_seq_lote_enc_contas,
	vl_cambial_passivo,
	vl_cambial_ativo,
	dt_real_recebimento,
	dt_credito_banco,
	ie_gerar_baixa_trib,
	nr_seq_lote_hist_guia)
values (nr_titulo_p,
	nr_seq_baixa_w,
	coalesce(dt_recebimento_p, trunc(clock_timestamp(),'dd')),
	CASE WHEN ie_atualiza_valor_w='S' THEN vl_baixa_w  ELSE vl_baixa_p END ,
	vl_desconto_w,
	vl_juros_w,
	vl_multa_w,
	vl_rec_maior_w,
	coalesce(cd_moeda_w,cd_moeda_padrao_w), -- Projeto Multimoeda - grava a moeda da transação, se não existir grava a moeda padrão
	clock_timestamp(),
	nm_usuario_p,
	cd_tipo_recebimento_p,
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
	nr_seq_trans_financ_p, 
	coalesce(vl_glosa_p,0),
	'S',
	nr_bordero_p,
	nr_seq_conta_banco_w,
	cd_centro_custo_desc_w,
	nr_seq_motivo_desc_w,
	vl_perdas_w,
	ds_observacao_bordero_w,
	vl_nota_credito_w,
	0,
	0,
	vl_baixa_estrang_w,
	vl_cotacao_w,
	vl_complemento_w,
	nr_seq_lote_enc_p,
	vl_cambial_passivo_w,
	vl_cambial_ativo_w,
	dt_real_recebimento_w,
	dt_credito_banco_w,
	coalesce(ie_gerar_baixa_trib_p,'S'),
	nr_seq_lote_hist_guia_p);
		
	if (nr_titulo_contab_w IS NOT NULL AND nr_titulo_contab_w::text <> '') then
		CALL wheb_mensagem_pck.exibir_mensagem_abort(236517, 'NR_TITULO=' || nr_titulo_contab_w);
	end if;		

/* Francisco - OS194892 - 10/02/2010 */

if (vl_baixa_p > 0) then
	CALL pls_gerar_amortizacao_regra(nr_titulo_p,nr_seq_baixa_w,nm_usuario_p,'N');
end if;

SELECT * FROM obter_regra_acao_pag_duplic(dt_recebimento_p, cd_estabelecimento_p, nm_usuario_p, nr_seq_regra_w, ie_acao_w) INTO STRICT nr_seq_regra_w, ie_acao_w;

--Deixar este IF fora do IF(ie_acao_w in ('NC','NCM')), pois a variável ie_acao_baixa_w é utilizada na procedure PLS_APROPRIAR_JUROS_MULTA_MENS
if (vl_baixa_p > 0) then
	ie_acao_baixa_w	:= 'I';
else
	ie_acao_baixa_w	:= 'E';
end if;

if (ie_acao_w in ('NC', 'NCM')) then
	ie_apropriar_w := tratar_baixa_duplicidade_tit(null, nr_titulo_p, nr_seq_baixa_w, ie_acao_baixa_w, dt_recebimento_p, nm_usuario_p, ie_apropriar_w);
end if;

if (nr_seq_cob_previa_w IS NOT NULL AND nr_seq_cob_previa_w::text <> '') and (vl_baixa_p = vl_saldo_titulo_w) then
	CALL pls_atualiza_situacao_cobranca(	nr_seq_cob_previa_w,
					nm_usuario_p,
					'N');
end if;

select	count(*) --AAMFIRMO OS 700834
into STRICT	count_w
from	titulo_rec_negociado
where	nr_titulo = nr_titulo_p;

if (coalesce(count_w,0) > 0) then
	ie_apropriar_w := 'N';
end if;

/* Francisco - 28/09/2010 */

if (coalesce(ie_apropriar_w,'S') = 'S') then
	CALL pls_apropriar_juros_multa_mens(nr_titulo_p,nr_seq_baixa_w,nm_usuario_p,cd_estabelecimento_p,'N',ie_acao_baixa_w); -- OS 412785 - tem de ser por último pois trata suspensão do beneficiário
end if;

/* ahoffelder - 19/05/2010 - OS 208411 */

if (coalesce(nr_bordero_p::text, '') = '') then
	CALL gerar_tit_rec_liq_desc(nr_titulo_p,nr_seq_baixa_w,nm_usuario_p);
end if;

if (nr_bordero_p IS NOT NULL AND nr_bordero_p::text <> '') then
	Open C02;
	loop
	fetch C02 into
		nr_seq_solic_desc_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		insert into titulo_receber_liq_desc(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			dt_atualizacao_nrec,
			nm_usuario_nrec,
			cd_pessoa_fisica,
			cd_cgc,
			nr_titulo,
			nr_seq_liq,
			cd_centro_custo,
			nr_seq_motivo_desc)
		SELECT	nextval('titulo_receber_liq_desc_seq'),
			clock_timestamp(),
			nm_usuario_p,
			clock_timestamp(),
			nm_usuario_p,
			cd_pessoa_fisica,
			cd_cgc,
			nr_titulo_p,
			nr_seq_baixa_w,
			cd_centro_custo,
			nr_seq_motivo_desc
		from	titulo_receber_liq_desc
		where	nr_sequencia	= nr_seq_solic_desc_w;
	end loop;
	close C02;
end if;

/*OS 1985692 - Movi essa parte aqui para baixo, pois dentro da tratar_baixa_duplicidade_tit pode alterar o valor da baixa, valor a maior, e precisa gerar a classif da baixa apos essas alterações nos valores.*/


/* Edgar 19/03/2008, OS 86492, alterei para chamar esta procedure sempre que lançada a baixa */

CALL gerar_titulo_rec_liq_cc(cd_estabelecimento_p,
		null,
		nm_usuario_p,
		nr_titulo_p,
		nr_seq_baixa_w);
nr_titulo_contab_w := pls_gerar_tit_rec_liq_mens(nr_titulo_p, nr_seq_baixa_w, nm_usuario_p, nr_titulo_contab_w);

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixa_titulo_receber (cd_estabelecimento_p bigint, cd_tipo_recebimento_p bigint, nr_titulo_p bigint, nr_seq_trans_financ_p bigint, vl_baixa_p bigint, dt_recebimento_p timestamp, nm_usuario_p text, vl_glosa_p bigint, nr_bordero_p bigint, nr_seq_conta_banco_p bigint, vl_rec_maior_p bigint, vl_perdas_p bigint, nr_seq_movto_trans_fin_p bigint default null, vl_baixa_pend_estrang_p bigint default null, vl_cotacao_pend_p bigint default null, cd_moeda_pend_p bigint default null, nr_seq_lote_enc_p bigint default null, nr_seq_movto_bco_pend_p bigint default null, ie_gerar_baixa_trib_p text default 'S', nr_seq_lote_hist_guia_p bigint default null) FROM PUBLIC;
