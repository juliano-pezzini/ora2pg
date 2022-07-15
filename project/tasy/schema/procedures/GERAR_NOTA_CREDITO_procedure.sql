-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_nota_credito ( nr_seq_tit_rec_cobr_p bigint, nr_titulo_p bigint, nr_seq_baixa_p bigint, dt_baixa_p timestamp, nm_usuario_p text, ie_origem_p text) AS $body$
DECLARE

 
/* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ 
Finalidade: Criar nota de crédito quando um titulo já tem baixa e é feito uma nova baixa pois 
o titulo foi pago em duplicidade, 
------------------------------------------------------------------------------------------------------------------- 
Locais de chamada direta: 
[ X ] Objetos do dicionário [ ] Tasy (Delphi/Java) [ ] Portal [ ] Relatórios [ ] Outros: 
 ------------------------------------------------------------------------------------------------------------------ 
Pontos de atenção: 
	Procedure criada a princípio para ser usada na 'Manutenção de Títulos a Receber' 
------------------------------------------------------------------------------------------------------------------- 
Referências: 
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 
 
vl_parametro_w			varchar(255);
cd_cgc_w			varchar(14);
cd_pessoa_fisica_w		varchar(10);
ie_situacao_tit_regra_w		varchar(5);
ie_origem_nota_w			varchar(3)	:= 'CE';
ie_acao_w			varchar(3);
ie_situacao_tit_w			varchar(1);
ie_saldo_titulo_w			varchar(1);
vl_regra_ger_nc_w			double precision;
vl_saldo_titulo_w			double precision;
vl_desp_banc_w			double precision;
vl_rec_maior_w			double precision;
vl_descontos_w			double precision;
vl_recebido_w			double precision;
vl_devolver_w			double precision;
vl_titulo_w			double precision;
vl_multa_w			double precision;
vl_juros_w			double precision;
vl_cobranca_tit_w			double precision	:= 0;
nr_seq_trans_inadimplencia_w	bigint	:= null;
nr_seq_tit_rec_cobr_w		bigint	:= null;
nr_seq_nota_credito_w		bigint	:= null;
nr_seq_trans_baixa_tit_pagar_w	bigint;
nr_seq_trans_contab_nota_w		bigint;
nr_seq_conta_banco_w		bigint;
nr_seq_cobranca_w		bigint;
nr_seq_regra_w			bigint;
nr_titulo_w			bigint;
cd_estabelecimento_w		smallint;
cd_moeda_cp_w			smallint;
dt_pagamento_previsto_w		timestamp;
dt_credito_bancario_w		timestamp;
dt_liquidacao_w			timestamp;
dt_remessa_w			timestamp;
nr_seq_motivo_w			regra_acao_pag_duplic.nr_seq_motivo%type;
	

BEGIN 
if (nr_seq_tit_rec_cobr_p IS NOT NULL AND nr_seq_tit_rec_cobr_p::text <> '') or (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then 
	if (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') then 
		select	a.cd_estabelecimento 
		into STRICT	cd_estabelecimento_w 
		from	titulo_receber a 
		where	a.nr_titulo	= nr_titulo_p;
	else 
		select	b.cd_estabelecimento, 
			b.dt_credito_bancario 
		into STRICT	cd_estabelecimento_w, 
			dt_credito_bancario_w 
		from	cobranca_escritural	b, 
			titulo_receber_cobr	a 
		where	a.nr_seq_cobranca	= b.nr_sequencia 
		and	a.nr_sequencia	= nr_seq_tit_rec_cobr_p;
	end if;
 
	-- parâmetro [145] - Gerar a nota de crédito ao baixar manualmente um título que tenha recebimento a maior 
	vl_parametro_w := Obter_Param_Usuario(801, 145, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, vl_parametro_w);
	 
	SELECT * FROM obter_regra_acao_pag_duplic(dt_baixa_p, cd_estabelecimento_w, nm_usuario_p, nr_seq_regra_w, ie_acao_w) INTO STRICT nr_seq_regra_w, ie_acao_w;
 
	begin 
	select	max(nr_seq_trans_contab_nota), 
		max(nr_seq_trans_baixa_tit_pagar), 
		max(vl_minimo_nc), 
		coalesce(max(ie_saldo_titulo), 'S'), 
		coalesce(max(ie_situacao_tit), 'T'), 
		max(nr_seq_motivo) 
	into STRICT	nr_seq_trans_contab_nota_w, 
		nr_seq_trans_baixa_tit_pagar_w, 
		vl_regra_ger_nc_w, 
		ie_saldo_titulo_w, 
		ie_situacao_tit_regra_w, 
		nr_seq_motivo_w 
	from	regra_acao_pag_duplic 
	where	nr_sequencia	= nr_seq_regra_w;
	exception 
	when others then 
		nr_seq_trans_contab_nota_w	:= null;
		nr_seq_trans_baixa_tit_pagar_w	:= null;
		vl_regra_ger_nc_w		:= null;
		ie_saldo_titulo_w		:= 'S';
		ie_situacao_tit_regra_w		:= 'T';
		nr_seq_motivo_w			:= null;
	end;
	 
	begin 
	select	a.cd_moeda_padrao 
	into STRICT	cd_moeda_cp_w 
	from	parametros_contas_pagar a 
	where	a.cd_estabelecimento	= cd_estabelecimento_w;
	exception 
	when no_data_found then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(181573);
	end;
	 
	select	max(nr_seq_trans_inadimplencia) 
	into STRICT	nr_seq_trans_inadimplencia_w 
	from	pls_parametros_cr 	a 
	where	a.cd_estabelecimento	= cd_estabelecimento_w;
	 
	if (nr_seq_tit_rec_cobr_p IS NOT NULL AND nr_seq_tit_rec_cobr_p::text <> '') then 
		select	b.vl_saldo_titulo, 
			trunc(a.dt_liquidacao, 'dd'), 
			c.nr_seq_conta_banco, 
			b.cd_pessoa_fisica, 
			b.cd_cgc, 
			coalesce(a.vl_juros, 0), 
			coalesce(a.vl_multa, 0), 
			coalesce(a.vl_despesa_bancaria, 0), 
			a.nr_titulo, 
			c.dt_remessa_retorno, 
			c.nr_sequencia, 
			b.vl_titulo, 
			a.vl_cobranca, 
			b.dt_pagamento_previsto, 
			b.ie_situacao 
		into STRICT	vl_saldo_titulo_w, 
			dt_liquidacao_w, 
			nr_seq_conta_banco_w, 
			cd_pessoa_fisica_w, 
			cd_cgc_w, 
			vl_juros_w, 
			vl_multa_w, 
			vl_desp_banc_w, 
			nr_titulo_w, 
			dt_remessa_w, 
			nr_seq_cobranca_w, 
			vl_titulo_w, 
			vl_cobranca_tit_w, 
			dt_pagamento_previsto_w, 
			ie_situacao_tit_w 
		from	cobranca_escritural 	c, 
			titulo_receber 		b, 
			titulo_receber_cobr 	a 
		where	a.nr_titulo		= b.nr_titulo 
		and	a.nr_seq_cobranca	= c.nr_sequencia 
		and	a.nr_sequencia		= nr_seq_tit_rec_cobr_p;
	elsif (nr_titulo_p IS NOT NULL AND nr_titulo_p::text <> '') and (nr_seq_baixa_p IS NOT NULL AND nr_seq_baixa_p::text <> '') then /* Se for estorno pela baixa "manual" */
 
		select	b.vl_saldo_titulo, 
			trunc(a.dt_recebimento, 'dd'), 
			a.nr_seq_conta_banco, 
			b.cd_pessoa_fisica, 
			b.cd_cgc, 
			coalesce(a.vl_juros, 0), 
			coalesce(a.vl_multa, 0), 
			a.nr_titulo, 
			b.vl_titulo, 
			a.nr_seq_cobranca, 
			b.ie_situacao 
		into STRICT	vl_saldo_titulo_w, 
			dt_liquidacao_w, 
			nr_seq_conta_banco_w, 
			cd_pessoa_fisica_w, 
			cd_cgc_w, 
			vl_juros_w, 
			vl_multa_w, 
			nr_titulo_w, 
			vl_titulo_w, 
			nr_seq_cobranca_w, 
			ie_situacao_tit_w 
		from	titulo_receber b, 
			titulo_receber_liq 	a 
		where	a.nr_titulo		= b.nr_titulo 
		and	a.nr_titulo		= nr_titulo_p 
		and	a.nr_sequencia		= nr_seq_baixa_p;
		 
		if (nr_seq_cobranca_w IS NOT NULL AND nr_seq_cobranca_w::text <> '') then 
			select	max(a.nr_sequencia) 
			into STRICT	nr_seq_tit_rec_cobr_w 
			from	titulo_receber_cobr	a 
			where	a.nr_seq_cobranca	= nr_seq_cobranca_w 
			and	a.nr_titulo		= nr_titulo_p;
		end if;
	end if;
	 
	begin 
	select	a.vl_recebido, 
		coalesce(a.vl_descontos, 0), 
		coalesce(vl_rec_maior, 0) 
	into STRICT	vl_recebido_w, 
		vl_descontos_w, 
		vl_rec_maior_w 
	from	titulo_receber_liq	a 
	where	a.nr_titulo		= nr_titulo_w 
	and	a.nr_sequencia		= nr_seq_baixa_p;
	exception 
	when others then 
		null;
	end;
	 
	-- Caso a baixa do título for manual 
	if (coalesce(vl_rec_maior_w, 0) > 0) and (coalesce(vl_parametro_w, 'N') = 'S') then 
		vl_devolver_w := vl_rec_maior_w;
	else 
		vl_devolver_w	:= abs(vl_saldo_titulo_w - (vl_recebido_w + vl_descontos_w));
	end if;
 
	if (ie_acao_w in ('NC', 'NCM')) and 
		((coalesce(vl_regra_ger_nc_w::text, '') = '') or (vl_devolver_w >= vl_regra_ger_nc_w)) and 
		((ie_saldo_titulo_w = 'S') or (vl_saldo_titulo_w = 0)) and 
		((coalesce(ie_situacao_tit_regra_w, 'T') = 'T') or ((coalesce(ie_situacao_tit_regra_w, 'T') = 'LC') and (ie_situacao_tit_w in ('2', '3')))) and (vl_devolver_w > 0) then 
		/* Se foi originado de crédito não identificado */
 
		if (coalesce(nr_seq_tit_rec_cobr_p::text, '') = '') and (coalesce(nr_seq_tit_rec_cobr_w::text, '') = '') then 
			ie_origem_nota_w	:= 'CN';
		end if;
		 
		/* Gerar nota de crédito */
 
		select	nextval('nota_credito_seq') 
		into STRICT	nr_seq_nota_credito_w 
		;		
	 
		insert into nota_credito(nr_sequencia, 
			cd_estabelecimento, 
			dt_atualizacao, 
			nm_usuario, 
			dt_atualizacao_nrec, 
			nm_usuario_nrec, 
			vl_nota_credito, 
			cd_pessoa_fisica, 
			cd_cgc, 
			dt_nota_credito, 
			dt_vencimento, 
			cd_moeda, 
			tx_juros, 
			tx_multa, 
			cd_tipo_taxa_juro, 
			cd_tipo_taxa_multa, 
			ie_origem, 
			vl_saldo, 
			nr_lote_contabil, 
			ds_observacao, 
			ie_situacao, 
			nr_seq_tit_rec_cobr, 
			nr_seq_regra_pag_duplic, 
			nr_seq_trans_fin_contab, 
			nr_seq_trans_baixa_tit_pagar, 
			nr_seq_conta_banco, 
			nr_titulo_receber, 
			nr_seq_baixa_origem, 
			ie_situacao_tit_rec, 
			nr_seq_motivo) 
		values (nr_seq_nota_credito_w, 
			cd_estabelecimento_w, 
			clock_timestamp(), 
			nm_usuario_p, 
			clock_timestamp(), 
			nm_usuario_p, 
			vl_devolver_w, 
			cd_pessoa_fisica_w, 
			cd_cgc_w, 
			coalesce(dt_credito_bancario_w, dt_liquidacao_w), 
			null, 
			cd_moeda_cp_w, 
			null, 
			null, 
			null, 
			null, 
			ie_origem_nota_w, 
			vl_devolver_w, 
			null, 
			wheb_mensagem_pck.get_texto(302153,null), --Nota de crédito gerada devido a pagamento em duplicidade/à maior 
			'A', 
			nr_seq_tit_rec_cobr_p, 
			nr_seq_regra_w, 
			nr_seq_trans_contab_nota_w, 
			nr_seq_trans_baixa_tit_pagar_w, 
			nr_seq_conta_banco_w, 
			coalesce(nr_titulo_w,nr_titulo_p), 
			nr_seq_baixa_p, 
			ie_situacao_tit_w, 
			nr_seq_motivo_w);
 
	update	titulo_receber_liq 
	set	ds_observacao	= wheb_mensagem_pck.get_texto(302154,'NOTA_CREDITO='||nr_seq_nota_credito_w) --'Nota de crédito ' || nr_seq_nota_credito_w || ' gerada devido a pagamento em duplicidade/à maior.' 
	where	nr_titulo		= nr_titulo_p 
	and	nr_sequencia	= nr_seq_baixa_p;
	end if;		
end if;		
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_nota_credito ( nr_seq_tit_rec_cobr_p bigint, nr_titulo_p bigint, nr_seq_baixa_p bigint, dt_baixa_p timestamp, nm_usuario_p text, ie_origem_p text) FROM PUBLIC;

