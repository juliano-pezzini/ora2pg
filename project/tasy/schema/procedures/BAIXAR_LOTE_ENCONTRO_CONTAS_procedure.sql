-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baixar_lote_encontro_contas ( nr_seq_lote_p bigint, ie_acao_p text, dt_baixa_p timestamp, cd_pessoa_fisica_p text, cd_cgc_p text, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

					 
vl_saldo_pessoa_w			double precision	:= 0;
vl_receber_w				double precision	:= 0;
vl_pagar_w				double precision	:= 0;
vl_saldo_titulo_w			double precision;
nr_seq_trans_fin_rec_w			bigint	:= null;
nr_seq_trans_fin_cpa_w			bigint	:= null;
nr_titulo_receber_w			bigint;
nr_titulo_pagar_w			bigint;
nr_novo_titulo_w			bigint;
cd_tipo_recebimento_w			integer	:= null;
cd_tipo_baixa_w				integer	:= null;
cd_estabelecimento_w			smallint;
cd_cgc_w				varchar(14);
cd_cgc_tit_w				varchar(14);
cd_pessoa_fisica_w			varchar(10);
cd_pessoa_fisica_tit_w			varchar(10);
nr_seq_trans_tit_rec_w			bigint	:= null;
nr_seq_trans_tit_pagar_w		bigint	:= null;
cd_tipo_taxa_juro_cp_w			bigint;
cd_tipo_taxa_multa_cp_w			bigint;
cd_tipo_taxa_juro_cr_w			bigint;
cd_tipo_taxa_multa_cr_w			bigint;
cd_tipo_portador_w			bigint;
cd_portador_w				bigint;
cd_conta_financ_cp_w			bigint;
cd_conta_financ_cr_w			bigint;
nr_seq_classif_w			bigint;
nr_sequencia_w				bigint;
nr_seq_pessoa_w				bigint;
nr_seq_congenere_w			bigint;
nr_seq_resp_financ_w			bigint;
nr_seq_trans_fin_baixa_w		bigint;
tx_juros_cp_w				double precision;
tx_multa_cp_w				double precision;
tx_juros_cr_w				double precision;
tx_multa_cr_w				double precision;
cd_moeda_cp_w				integer;
cd_moeda_cr_w				integer;
nr_seq_baixa_w				integer;
dt_vencimento_w				timestamp;

ie_tipo_pessoa_w			varchar(255)	:= null;
cd_cgc_congenere_w			varchar(255)	:= null;
nr_seq_trans_fin_rec_regra_w		bigint	:= null;
nr_seq_trans_fin_cpa_regra_w		bigint	:= null;
nr_seq_trans_tit_rec_regra_w		bigint	:= null;
nr_seq_trans_tit_pag_regra_w		bigint	:= null;
qt_regra_w				bigint	:= 0;
qt_pessoas_w				bigint	:= 0;
qt_baixas_w				bigint	:= 0;
cd_tipo_receb_regra_w			integer	:= null;
cd_tipo_baixa_cpa_regra_w		integer	:= null;

ie_juros_w				varchar(1);
ie_multa_w				varchar(1);
vl_juros_receb_w			double precision := 0;
vl_multa_receb_w			double precision := 0;
vl_juros_pag_w				double precision := 0;
vl_multa_pag_w				double precision := 0;
vl_saldo_juros_w			double precision;
vl_saldo_multa_w			double precision;
vl_saldo_lote_w				double precision;

nr_seq_trans_fin_rec_par_w		bigint;
nr_seq_trans_fin_cpa_par_w		bigint;
nr_seq_trans_tit_rec_par_w		bigint;
nr_seq_trans_tit_pagar_par_w		bigint;
cd_tipo_recebimento_par_w		integer;
cd_tipo_baixa_par_w			integer;
nr_seq_trans_bx_novo_tit_pag_w		bigint;
nr_seq_trans_bx_novo_tit_rec_w		bigint;
nr_seq_trans_bxn_tit_pag_reg_w		bigint;
nr_seq_trans_bxn_tit_rec_reg_w		bigint;
nr_seq_trans_bxn_tit_pag_par_w		bigint;
nr_seq_trans_bxn_tit_rec_par_w		bigint;
ds_observacao_baixa_w			varchar(255);
ie_trans_fin_baixa_w			varchar(1);

ie_despesa_desconto_w			varchar(1);
vl_descontos_w				double precision;
vl_despesa_w				double precision;
dt_liquidacao_w				timestamp;

vl_outros_acrescimos_w			double precision;
nr_seq_classe_pag_w			lote_encontro_contas.nr_seq_classe_pag%type;
nr_seq_classe_rec_w			lote_encontro_contas.nr_seq_classe_rec%type;
vl_informado_w				double precision;
ie_outras_desp_no_saldo_w	varchar(1);

 
C01 CURSOR FOR 
	SELECT	a.nr_sequencia, 
		a.cd_pessoa_fisica, 
		a.cd_cgc 
	from	pessoa_encontro_contas	a 
	where	a.nr_seq_lote		= nr_seq_lote_p 
	and	coalesce(a.dt_baixa::text, '') = '' 
	and	((a.cd_pessoa_fisica	= cd_pessoa_fisica_p) or (coalesce(cd_pessoa_fisica_p::text, '') = '')) 
	and	((a.cd_cgc = cd_cgc_p) or (coalesce(cd_cgc_p::text, '') = ''));

C02 CURSOR FOR 
	SELECT	a.nr_sequencia, 
		a.nr_titulo_receber nr_titulo_receber, 
		null nr_titulo_pagar, 
		b.vl_saldo_titulo, 
		CASE WHEN coalesce(ie_trans_fin_baixa_w,'N')='S' THEN coalesce(nr_seq_trans_tit_rec_w,b.nr_seq_trans_fin_baixa)  ELSE b.nr_seq_trans_fin_baixa END , 
		(obter_juros_multa_titulo(b.nr_titulo, clock_timestamp(),'R','J'))::numeric  vl_saldo_juros, 
		(obter_juros_multa_titulo(b.nr_titulo, clock_timestamp(),'R','M'))::numeric  vl_saldo_multa, 
		coalesce(obter_valores_encontro_contas(b.nr_titulo, a.nr_seq_pessoa, clock_timestamp(),'R','DC'),0) vl_desconto, 
		0 vl_despesa, 
		CASE WHEN a.vl_informado=0 THEN  null  ELSE a.vl_informado END , 
		b.cd_estabelecimento 
	from	titulo_receber		b, 
		encontro_contas_item	a 
	where	a.nr_titulo_receber	= b.nr_titulo 
	and	a.nr_seq_pessoa		= nr_seq_pessoa_w 
	and (b.cd_estabelecimento	= coalesce(cd_estabelecimento_p,b.cd_estabelecimento) or	 
		 b.cd_estab_financeiro = coalesce(cd_estabelecimento_p,b.cd_estabelecimento) or 
		 obter_estab_financeiro(b.cd_estabelecimento) = coalesce(cd_estabelecimento_p,b.cd_estabelecimento)) 
	
union all
 
	SELECT	a.nr_sequencia, 
		null nr_titulo_receber, 
		a.nr_titulo_pagar nr_titulo_pagar, 
		b.vl_saldo_titulo, 
		CASE WHEN coalesce(ie_trans_fin_baixa_w,'N')='S' THEN coalesce(nr_seq_trans_tit_pagar_w,b.nr_seq_trans_fin_baixa)  ELSE b.nr_seq_trans_fin_baixa END , 
		(obter_juros_multa_titulo(b.nr_titulo, clock_timestamp(),'P','J'))::numeric  vl_saldo_juros, 
		(obter_juros_multa_titulo(b.nr_titulo, clock_timestamp(),'P','M'))::numeric  vl_saldo_multa, 
		coalesce(obter_valores_tit_pagar(b.nr_titulo,clock_timestamp(),'D'), coalesce(b.vl_dia_antecipacao,0)) vl_desconto, 
		coalesce(b.vl_outras_despesas,0) vl_despesa, 
		CASE WHEN a.vl_informado=0 THEN  null  ELSE a.vl_informado END , 
		b.cd_estabelecimento 
	from	titulo_pagar		b, 
		encontro_contas_item	a 
	where	a.nr_titulo_pagar	= b.nr_titulo 
	and	a.nr_seq_pessoa		= nr_seq_pessoa_w 
	and (b.cd_estabelecimento	= coalesce(cd_estabelecimento_p,b.cd_estabelecimento) or	 
		 b.cd_estab_financeiro = coalesce(cd_estabelecimento_p,b.cd_estabelecimento) or 
		 obter_estab_financeiro(b.cd_estabelecimento) = coalesce(cd_estabelecimento_p,b.cd_estabelecimento)) 
	order by 2,3;

C03 CURSOR FOR 
	SELECT	a.cd_tipo_recebimento, 
		a.cd_tipo_baixa_cpa, 
		a.nr_seq_trans_baixa_cre, 
		a.nr_seq_trans_baixa_cpa, 
		a.nr_seq_trans_tit_rec, 
		a.nr_seq_trans_tit_pagar, 
		a.nr_seq_trans_bx_novo_tit_pag, 
		a.nr_seq_trans_bx_novo_tit_rec,		 
		coalesce(a.ie_juros,'N'), 
		coalesce(a.ie_multa,'N'), 
		coalesce(a.ie_despesa_desconto,'N') 
	from	regra_receb_enc_contas	a 
	where	a.ie_tipo_pessoa	= ie_tipo_pessoa_w 
	order by 
		a.nr_sequencia desc;	
		 
C04 CURSOR FOR 
	SELECT	a.nr_titulo_receber nr_titulo_receber, 
		null nr_titulo_pagar 
	from	titulo_receber		b, 
		encontro_contas_item	a 
	where	a.nr_titulo_receber	= b.nr_titulo 
	and	a.nr_seq_pessoa		= nr_seq_pessoa_w 
	and (b.cd_estabelecimento	= coalesce(cd_estabelecimento_p,b.cd_estabelecimento) or	 
		 b.cd_estab_financeiro = coalesce(cd_estabelecimento_p,b.cd_estabelecimento) or 
		 obter_estab_financeiro(b.cd_estabelecimento) = coalesce(cd_estabelecimento_p,b.cd_estabelecimento)) 
	
union all
 
	SELECT	null nr_titulo_receber, 
		a.nr_titulo_pagar nr_titulo_pagar 
	from	titulo_pagar		b, 
		encontro_contas_item	a 
	where	a.nr_titulo_pagar	= b.nr_titulo 
	and	a.nr_seq_pessoa		= nr_seq_pessoa_w 
	and (b.cd_estabelecimento	= coalesce(cd_estabelecimento_p,b.cd_estabelecimento) or	 
		 b.cd_estab_financeiro = coalesce(cd_estabelecimento_p,b.cd_estabelecimento) or 
		 obter_estab_financeiro(b.cd_estabelecimento) = coalesce(cd_estabelecimento_p,b.cd_estabelecimento)) 
	order by 1,2;


BEGIN 
 
ie_outras_desp_no_saldo_w := obter_param_usuario(851, 256, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_outras_desp_no_saldo_w);
 
if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then 
 
	select	max(a.nr_seq_classe_pag), 
		max(a.nr_seq_classe_rec) 
	into STRICT	nr_seq_classe_pag_w, 
		nr_seq_classe_rec_w 
	from	lote_encontro_contas a 
	where	a.nr_sequencia	= nr_seq_lote_p;
 
	 
	begin 
	select	a.cd_tipo_recebimento, 
		a.cd_tipo_baixa, 
		a.nr_seq_trans_baixa_cre, 
		a.nr_seq_trans_baixa_cpa, 
		a.nr_seq_trans_tit_rec, 
		a.nr_seq_trans_tit_pagar, 
		a.nr_seq_trans_bx_novo_tit_pag, 
		a.nr_seq_trans_bx_novo_tit_rec, 
		a.ie_trans_fin_baixa 
	into STRICT	cd_tipo_recebimento_par_w, 
		cd_tipo_baixa_par_w, 
		nr_seq_trans_fin_rec_par_w, 
		nr_seq_trans_fin_cpa_par_w, 
		nr_seq_trans_tit_rec_par_w, 
		nr_seq_trans_tit_pagar_par_w, 
		nr_seq_trans_bxn_tit_pag_par_w, 
		nr_seq_trans_bxn_tit_rec_par_w, 
		ie_trans_fin_baixa_w 
	from	parametro_encontro_contas a 
	where	a.cd_estabelecimento	= coalesce(cd_estabelecimento_p,obter_estabelecimento_ativo);
	exception 
		when no_data_found then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(185376);
	end;
	 
	begin 
	select	a.cd_moeda_padrao, 
		a.cd_tipo_taxa_juro, 
		a.cd_tipo_taxa_multa, 
		a.pr_juro_padrao, 
		a.pr_multa_padrao 
	into STRICT	cd_moeda_cp_w, 
		cd_tipo_taxa_juro_cp_w, 
		cd_tipo_taxa_multa_cp_w, 
		tx_juros_cp_w, 
		tx_multa_cp_w 
	from	parametros_contas_pagar a 
	where	a.cd_estabelecimento	= coalesce(cd_estabelecimento_p,obter_estabelecimento_ativo);
	exception 
		when no_data_found then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(185377);
	end;
	 
	begin 
	select	a.cd_moeda_padrao, 
		a.cd_tipo_taxa_juro, 
		a.cd_tipo_taxa_multa, 
		a.pr_juro_padrao, 
		a.pr_multa_padrao, 
		a.cd_tipo_portador, 
		a.cd_portador 
	into STRICT	cd_moeda_cr_w, 
		cd_tipo_taxa_juro_cr_w, 
		cd_tipo_taxa_multa_cr_w, 
		tx_juros_cr_w, 
		tx_multa_cr_w, 
		cd_tipo_portador_w, 
		cd_portador_w 
	from	parametro_contas_receber a 
	where	a.cd_estabelecimento	= coalesce(cd_estabelecimento_p,obter_estabelecimento_ativo);
	exception 
		when no_data_found then 
		CALL wheb_mensagem_pck.exibir_mensagem_abort(185378);
	end;
 
	if (ie_acao_p = 'B') then /* Baixar */
 
		open C01;
		loop 
		fetch C01 into	 
			nr_seq_pessoa_w, 
			cd_pessoa_fisica_w, 
			cd_cgc_w;
		EXIT WHEN NOT FOUND; /* apply on C01 */
			vl_receber_w		:= 0;
			vl_pagar_w		:= 0;
			vl_saldo_pessoa_w	:= 0;
			 
			cd_pessoa_fisica_tit_w	:= cd_pessoa_fisica_w;
			cd_cgc_tit_w		:= cd_cgc_w;
			 
			begin 
			if (cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '') then /* Obter o tipo da pessoa*/
 
				select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'CO' END  
				into STRICT	ie_tipo_pessoa_w 
				from	pls_congenere 
				where	cd_cgc	= cd_cgc_w 
				and	coalesce(dt_exclusao::text, '') = ''  LIMIT 1;
				 
				if (ie_tipo_pessoa_w = 'N') then 
					select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'C' END  
					into STRICT	ie_tipo_pessoa_w 
					from	pls_cooperado 
					where	cd_cgc	= cd_cgc_w 
					and	coalesce(dt_exclusao::text, '') = ''  LIMIT 1;
					 
					if (ie_tipo_pessoa_w = 'N') then 
						ie_tipo_pessoa_w	:= 'CL';
					end if;
				end if;
			else 
				select	CASE WHEN count(1)=0 THEN 'N'  ELSE 'C' END  
				into STRICT	ie_tipo_pessoa_w 
				from	pls_cooperado 
				where	cd_pessoa_fisica	= cd_pessoa_fisica_w 
				and	coalesce(dt_exclusao::text, '') = ''  LIMIT 1;
				 
				if (ie_tipo_pessoa_w = 'N') then 
					ie_tipo_pessoa_w	:= 'CL';
				end if;
			end if;
 
		if (coalesce(nr_seq_classe_pag_w::text, '') = '' )then 
			select	max(nr_seq_classe_cp) 
			into STRICT	nr_seq_classe_pag_w 
			from	regra_receb_enc_contas a 
			where	a.ie_tipo_pessoa	= ie_tipo_pessoa_w;
		end if;
 
	 
		if (coalesce(nr_seq_classe_rec_w::text, '') = '' )then 
			select	max(nr_seq_classe_cr) 
			into STRICT	nr_seq_classe_rec_w 
			from	regra_receb_enc_contas a 
			where	a.ie_tipo_pessoa	= ie_tipo_pessoa_w;
		end if;
		 
 
			select	count(1) /* Obter se existe regra*/
 
			into STRICT	qt_regra_w 
			from	regra_receb_enc_contas 
			where	ie_tipo_pessoa	= ie_tipo_pessoa_w  LIMIT 1;
			 
			if (qt_regra_w <> 0) then				 
				open C03;
				loop 
				fetch C03 into 
					cd_tipo_receb_regra_w, 
					cd_tipo_baixa_cpa_regra_w, 
					nr_seq_trans_fin_rec_regra_w, 
					nr_seq_trans_fin_cpa_regra_w, 
					nr_seq_trans_tit_rec_regra_w, 
					nr_seq_trans_tit_pag_regra_w, 
					nr_seq_trans_bxn_tit_pag_reg_w, 
					nr_seq_trans_bxn_tit_rec_reg_w, 
					ie_juros_w, 
					ie_multa_w, 
					ie_despesa_desconto_w;
				EXIT WHEN NOT FOUND; /* apply on C03 */
				end loop;
				close C03;
			end if;
			 
			if (coalesce(ie_juros_w::text, '') = '') then 
				ie_juros_w := 'N';
			end if;
			 
			if (coalesce(ie_multa_w::text, '') = '') then 
				ie_multa_w := 'N';
			end if;
			 
			if (coalesce(ie_despesa_desconto_w::text, '') = '') then 
				ie_despesa_desconto_w := 'N';
			end if;
			 
			cd_tipo_recebimento_w		:= coalesce(cd_tipo_receb_regra_w,cd_tipo_recebimento_par_w);
			cd_tipo_baixa_w			:= coalesce(cd_tipo_baixa_cpa_regra_w,cd_tipo_baixa_par_w);
			nr_seq_trans_fin_rec_w		:= coalesce(nr_seq_trans_fin_rec_regra_w,nr_seq_trans_fin_rec_par_w);
			nr_seq_trans_fin_cpa_w		:= coalesce(nr_seq_trans_fin_cpa_regra_w,nr_seq_trans_fin_cpa_par_w);
			nr_seq_trans_tit_rec_w		:= coalesce(nr_seq_trans_tit_rec_regra_w,nr_seq_trans_tit_rec_par_w);
			nr_seq_trans_tit_pagar_w	:= coalesce(nr_seq_trans_tit_pag_regra_w,nr_seq_trans_tit_pagar_par_w);
			nr_seq_trans_bx_novo_tit_pag_w	:= coalesce(nr_seq_trans_bxn_tit_pag_reg_w,nr_seq_trans_bxn_tit_pag_par_w);
			nr_seq_trans_bx_novo_tit_rec_w	:= coalesce(nr_seq_trans_bxn_tit_rec_reg_w,nr_seq_trans_bxn_tit_rec_par_w);
			 
			open C02; /* Baixar títulos do lote */
			loop 
			fetch C02 into 
				nr_sequencia_w, 
				nr_titulo_receber_w, 
				nr_titulo_pagar_w, 
				vl_saldo_titulo_w, 
				nr_seq_trans_fin_baixa_w, 
				vl_saldo_juros_w, 
				vl_saldo_multa_w, 
				vl_descontos_w, 
				vl_despesa_w, 
				vl_informado_w, 
				cd_estabelecimento_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin 
				dt_liquidacao_w := null;				
				if (nr_titulo_receber_w IS NOT NULL AND nr_titulo_receber_w::text <> '') then 
					select	max(dt_liquidacao) 
					into STRICT	dt_liquidacao_w 
					from	titulo_receber 
					where	nr_titulo = nr_titulo_receber_w;
					 
				elsif (nr_titulo_pagar_w IS NOT NULL AND nr_titulo_pagar_w::text <> '') then 
					select	max(dt_liquidacao) 
					into STRICT	dt_liquidacao_w 
					from	titulo_pagar 
					where	nr_titulo = nr_titulo_pagar_w;
				end if;
				 
				if (dt_liquidacao_w IS NOT NULL AND dt_liquidacao_w::text <> '') then 
					CALL wheb_mensagem_pck.exibir_mensagem_abort(237365,'NR_TITULO=' || coalesce(nr_titulo_receber_w,nr_titulo_pagar_w));
				end if;
				 
				if (nr_seq_trans_fin_baixa_w IS NOT NULL AND nr_seq_trans_fin_baixa_w::text <> '') and ( ie_trans_fin_baixa_w = 'N' ) then /* Obter a transação de baixa do título, só trocar se tiver informado */
 
					nr_seq_trans_fin_rec_w	:= nr_seq_trans_fin_baixa_w;
				end if;		
 
				update	encontro_contas_item 
				set	vl_juros 	= vl_saldo_juros_w, 
					vl_multa 	= vl_saldo_multa_w 
				where	nr_sequencia 	= nr_sequencia_w;
				 
				if (nr_titulo_receber_w IS NOT NULL AND nr_titulo_receber_w::text <> '') then 
					if (coalesce(cd_tipo_recebimento_w::text, '') = '') then 
						CALL wheb_mensagem_pck.exibir_mensagem_abort(185379);
					end if;
					 
					begin 
					dbms_application_info.SET_ACTION('BAIXAR_LOTE_ENCONTRO_CONTAS'); 					
 
					CALL baixa_titulo_receber(coalesce(cd_estabelecimento_p,cd_estabelecimento_w), 
							cd_tipo_recebimento_w, 
							nr_titulo_receber_w, 
							nr_seq_trans_fin_rec_w , 
							coalesce(vl_informado_w, vl_saldo_titulo_w) , 
							trunc(dt_baixa_p,'dd'), 
							nm_usuario_p, 
							null, 
							null, 
							null, 
							0, 
							0, 
							null, 
							null, 
							null, 
							null, 
							nr_seq_lote_p);
					exception 
					when others then 
						dbms_application_info.SET_ACTION('');
						CALL wheb_mensagem_pck.exibir_mensagem_abort(185560,'SQLERRM='||sqlerrm);						
					end;
							 
 
					select	max(a.nr_sequencia) 
					into STRICT	nr_seq_baixa_w 
					from	titulo_receber_liq a 
					where	a.nr_titulo	= nr_titulo_receber_w;
					 
					if (ie_juros_w = 'N') or (ie_juros_w = 'P') then /*Se a regra para gerar título com juros e multa, estiver inativa. Não é inserido juros e multa no título gerado.*/
 
						vl_saldo_juros_w	:= 0;
					end if;	
					 
					if (ie_multa_w = 'N') or (ie_multa_w = 'P') then /*Se a regra para gerar título com juros e multa, estiver inativa. Não é inserido juros e multa no título gerado.*/
 
						vl_saldo_multa_w	:= 0;
					end if;	
 
					if (ie_despesa_desconto_w = 'N') or (ie_despesa_desconto_w = 'P') then /*Se a regra para gerar título com despesa e descontos, estiver inativa. Não é inserido juros e multa no título gerado.*/
 
						vl_despesa_w	:= 0;
						vl_descontos_w	:= 0;
					end if;
					 
					update	titulo_receber_liq 
					set	nr_seq_lote_enc_contas	= nr_seq_lote_p, 
						vl_juros		= vl_saldo_juros_w, 
						vl_multa		= vl_saldo_multa_w, 
						vl_descontos		= vl_descontos_w, 
						vl_recebido		= coalesce(vl_informado_w, vl_saldo_titulo_w) - coalesce(vl_descontos_w,0) 
					where	nr_titulo		= nr_titulo_receber_w 
					and	nr_sequencia		= nr_seq_baixa_w;
					 
					if (ie_juros_w = 'S') or (ie_juros_w = 'R') then 
						delete	from pls_segurado_mensalidade 
						where	nr_titulo	= nr_titulo_receber_w 
						and	nr_seq_baixa	= nr_seq_baixa_w 
						and	ie_tipo_item in (23);
					end if;
					 
					if (ie_multa_w = 'S') or (ie_multa_w = 'R') then 
						delete	from pls_segurado_mensalidade 
						where	nr_titulo	= nr_titulo_receber_w 
						and	nr_seq_baixa	= nr_seq_baixa_w 
						and	ie_tipo_item in (24);
					end if;
							 
					CALL atualizar_saldo_tit_rec(nr_titulo_receber_w,nm_usuario_p);
					 
					vl_receber_w := vl_receber_w + coalesce(vl_informado_w, vl_saldo_titulo_w) + vl_saldo_juros_w + vl_saldo_multa_w + vl_despesa_w - vl_descontos_w;
				elsif (nr_titulo_pagar_w IS NOT NULL AND nr_titulo_pagar_w::text <> '') then					 
					if (nr_seq_trans_fin_baixa_w IS NOT NULL AND nr_seq_trans_fin_baixa_w::text <> '') and ( ie_trans_fin_baixa_w = 'N' ) then /* Obter a transação de baixa do título. Só trocar se tiver informado */
 
						nr_seq_trans_fin_cpa_w	:= nr_seq_trans_fin_baixa_w;
					end if;	
				 
					CALL baixa_titulo_pagar(coalesce(cd_estabelecimento_p,cd_estabelecimento_w), 
							cd_tipo_baixa_w, 
							nr_titulo_pagar_w, 
							coalesce(vl_informado_w, vl_saldo_titulo_w), 
							nm_usuario_p, 
							nr_seq_trans_fin_cpa_w, 
							null, 
							null, 
							trunc(dt_baixa_p,'dd'), 
							null, 
							null, 
							null, 
							null, 
							nr_seq_lote_p);
							 
					select	max(a.nr_sequencia) 
					into STRICT	nr_seq_baixa_w 
					from	titulo_pagar_baixa a 
					where	a.nr_titulo	= nr_titulo_pagar_w;
					 
					if (ie_juros_w = 'N') or (ie_juros_w = 'R') then /*Se a regra para gerar título com juros e multa, estiver inativa. Não é inserido juros e multa no título gerado.*/
 
						vl_saldo_juros_w	:= 0;
					end if;
					 
					if (ie_multa_w = 'N') or (ie_multa_w = 'R') then /*Se a regra para gerar título com juros e multa, estiver inativa. Não é inserido juros e multa no título gerado.*/
 
						vl_saldo_multa_w	:= 0;
					end if;
					 
					if (ie_despesa_desconto_w = 'N') or (ie_despesa_desconto_w = 'R') or (coalesce(ie_outras_desp_no_saldo_w,'N') = 'S') then /*Se a regra para gerar título com despesa e descontos, estiver inativa. Não é inserido juros e multa no título gerado.*/
 
						vl_despesa_w	:= 0;
						vl_descontos_w	:= 0;
					end if;
					 
					update	titulo_pagar_baixa 
					set	nr_seq_lote_enc_contas	= nr_seq_lote_p, 
						vl_juros		= vl_saldo_juros_w, 
						vl_multa		= vl_saldo_multa_w 
						--vl_descontos		= vl_descontos_w 
					where	nr_titulo		= nr_titulo_pagar_w 
					and	nr_sequencia		= nr_seq_baixa_w;
							 
					CALL atualizar_saldo_tit_pagar(nr_titulo_pagar_w,nm_usuario_p);
					 
					CALL gerar_w_tit_pag_imposto(nr_titulo_pagar_w, nm_usuario_p);
					 
					select	coalesce(sum(vl_outros_acrescimos),0) 
					into STRICT	vl_outros_acrescimos_w 
					from	titulo_pagar 
					where	nr_titulo	= nr_titulo_pagar_w;
					 
					vl_pagar_w	:= vl_pagar_w + coalesce(vl_informado_w, vl_saldo_titulo_w) + vl_saldo_juros_w + vl_saldo_multa_w + vl_despesa_w + vl_outros_acrescimos_w; -- vl_descontos_w;	 
				end if;
				end;
			end loop;
			close C02;			
 
			select	max(a.nr_sequencia) /* Verificar se a pessoa é uma cooperativa, se for, precisa gerar o título para o responsável financeiro */
 
			into STRICT	nr_seq_congenere_w 
			from	pls_congenere a 
			where	a.cd_cgc	= cd_cgc_w;
			 
			if (nr_seq_congenere_w IS NOT NULL AND nr_seq_congenere_w::text <> '') then 
				select	pls_obter_coop_pag_resp_fin(nr_seq_congenere_w,dt_baixa_p) 
				into STRICT	cd_cgc_congenere_w 
				;
				cd_cgc_tit_w	:= coalesce(cd_cgc_congenere_w, cd_cgc_tit_w);
			end if;
			 
			vl_saldo_pessoa_w	:= vl_receber_w - vl_pagar_w; /* Gerar novo título a pagar ou receber */
 
			if (vl_saldo_pessoa_w < 0) then 
				select	nextval('titulo_pagar_seq') /* Gerar título a pagar */
 
				into STRICT	nr_novo_titulo_w 
				;
				 
				dt_vencimento_w	:= trunc(dt_baixa_p,'dd');
 
				insert into titulo_pagar(nr_titulo, 
					nm_usuario, 
					dt_atualizacao, 
					cd_estabelecimento, 
					vl_titulo, 
					vl_saldo_titulo, 
					dt_emissao, 
					dt_contabil, 
					dt_vencimento_original, 
					dt_vencimento_atual, 
					vl_saldo_juros, 
					vl_saldo_multa, 
					cd_moeda, 
					cd_tipo_taxa_juro, 
					cd_tipo_taxa_multa, 
					tx_juros, 
					tx_multa, 
					ie_origem_titulo, 
					ie_tipo_titulo, 
					ie_situacao, 
					cd_pessoa_fisica, 
					cd_cgc, 
					ie_pls, 
					nr_lote_contabil, 
					nr_seq_lote_enc_contas, 
					ds_observacao_titulo, 
					nr_seq_trans_fin_contab, 
					nr_seq_trans_fin_baixa, 
					cd_estab_financeiro, 
					nr_seq_classe) 
				values (nr_novo_titulo_w, 
					nm_usuario_p, 
					clock_timestamp(), 
					coalesce(cd_estabelecimento_p,cd_estabelecimento_w), 
					abs(vl_saldo_pessoa_w), 
					abs(vl_saldo_pessoa_w), 
					trunc(dt_baixa_p,'dd'), 
					trunc(dt_baixa_p,'dd'), 
					dt_vencimento_w, 
					dt_vencimento_w, 
					0, 
					0, 
					cd_moeda_cp_w, 
					cd_tipo_taxa_juro_cp_w, 
					cd_tipo_taxa_multa_cp_w, 
					tx_juros_cp_w, 
					tx_multa_cp_w, 
					'17', /* Encontro de contas*/
 
					'23', /* Fatura */
 
					'A', 
					cd_pessoa_fisica_tit_w, 
					cd_cgc_tit_w, 
					'S', 
					0, 
					nr_seq_lote_p, 
					substr(wheb_mensagem_pck.get_texto(304400,'NR_SEQ_LOTE=' || nr_seq_lote_p),1,255), 
					nr_seq_trans_tit_pagar_w, 
					nr_seq_trans_bx_novo_tit_pag_w, 
					obter_estab_financeiro(coalesce(cd_estabelecimento_p,cd_estabelecimento_w)), 
					nr_seq_classe_pag_w);
					 
				CALL atualizar_inclusao_tit_pagar(nr_novo_titulo_w, nm_usuario_p);
					 
				/* Verificar como obter conta financeira */
 
				cd_conta_financ_cp_w := obter_conta_financeira(	'S', coalesce(cd_estabelecimento_p,cd_estabelecimento_w), null, null, null, null, null, cd_cgc_w, null, cd_conta_financ_cp_w, null, null, null, null, null, null, null, cd_pessoa_fisica_w, null, '17', null, null, null, null, null, null, null, null, null);
							 
				if (coalesce(cd_conta_financ_cp_w,0) > 0) then 
					select	coalesce(max(nr_sequencia),0) + 1 
					into STRICT	nr_seq_classif_w 
					from	titulo_pagar_classif 
					where	nr_titulo	= nr_novo_titulo_w;
				 
					insert into titulo_pagar_classif(nr_titulo, 
						nr_sequencia, 
						nm_usuario, 
						dt_atualizacao, 
						nr_seq_conta_financ, 
						vl_original, 
						vl_titulo, 
						vl_desconto, 
						vl_acrescimo) 
					values (nr_novo_titulo_w, 
						nr_seq_classif_w, 
						nm_usuario_p, 
						clock_timestamp(), 
						cd_conta_financ_cp_w, 
						vl_saldo_pessoa_w, 
						vl_saldo_pessoa_w, 
						0, 
						0);
				end if;
				 
				update	pessoa_encontro_contas 
				set	nr_titulo_pagar		= nr_novo_titulo_w, 
					vl_saldo_devedor	= abs(vl_saldo_pessoa_w) 
				where	nr_sequencia		= nr_seq_pessoa_w;
			elsif (vl_saldo_pessoa_w > 0) then 
				select	nextval('titulo_seq') /* Gerar título a receber */
 
				into STRICT	nr_novo_titulo_w 
				;
				 
				dt_vencimento_w	:= trunc(dt_baixa_p,'dd');
				 
				insert into titulo_receber(nr_titulo, 
					nm_usuario, 
					dt_atualizacao, 
					cd_estabelecimento, 
					cd_tipo_portador, 
					cd_portador, 
					dt_emissao, 
					dt_contabil, 
					dt_vencimento, 
					dt_pagamento_previsto, 
					vl_titulo, 
					vl_saldo_titulo, 
					vl_saldo_juros, 
					vl_saldo_multa, 
					tx_juros, 
					tx_multa, 
					cd_tipo_taxa_juro, 
					cd_tipo_taxa_multa, 
					tx_desc_antecipacao, 
					ie_tipo_titulo, 
					ie_tipo_inclusao, 
					ie_origem_titulo, 
					cd_moeda, 
					ie_situacao, 
					cd_pessoa_fisica, 
					cd_cgc, 
					ie_tipo_emissao_titulo, 
					nr_seq_lote_enc_contas, 
					nr_lote_contabil, 
					ds_observacao_titulo, 
					nr_seq_trans_fin_contab, 
					nr_seq_trans_fin_baixa, 
					cd_estab_financeiro, 
					ie_pls, 
					nr_seq_classe) 
				values (nr_novo_titulo_w, 
					nm_usuario_p, 
					clock_timestamp(), 
					coalesce(cd_estabelecimento_p,cd_estabelecimento_w), 
					cd_tipo_portador_w, 
					cd_portador_w, 
					trunc(dt_baixa_p,'dd'), 
					trunc(dt_baixa_p,'dd'), 
					dt_vencimento_w, 
					dt_vencimento_w, 
					vl_saldo_pessoa_w, 
					vl_saldo_pessoa_w, 
					0, 
					0, 
					tx_juros_cr_w, 
					tx_multa_cr_w, 
					cd_tipo_taxa_juro_cr_w, 
					cd_tipo_taxa_multa_cr_w, 
					0, 
					'1', /* Bloqueto */
 
					'2', 
					'0', /* Encontro de Contas */
 
					cd_moeda_cr_w, 
					'1', 
					cd_pessoa_fisica_tit_w, 
					cd_cgc_tit_w, 
					'2' /* Emissão bloqueto origem */
, 
					nr_seq_lote_p, 
					0, 
					substr(wheb_mensagem_pck.get_texto(304400,'NR_SEQ_LOTE=' || nr_seq_lote_p),1,255), 
					nr_seq_trans_tit_rec_w, 
					nr_seq_trans_bx_novo_tit_rec_w, 
					obter_estab_financeiro(coalesce(cd_estabelecimento_p,cd_estabelecimento_w)), 
					'S', 
					nr_seq_classe_rec_w);
 
					 
				/* Verificar conta financeira */
 
				cd_conta_financ_cr_w := obter_conta_financeira(	'E', coalesce(cd_estabelecimento_p,cd_estabelecimento_w), null, null, null, null, null, cd_cgc_w, null, cd_conta_financ_cr_w, null, null, null, null, null, null, null, cd_pessoa_fisica_w, '0', null, null, null, null, null, null, null, null, null, null);
							 
				if (coalesce(cd_conta_financ_cr_w,0) > 0) then 
					select	coalesce(max(nr_sequencia),0) + 1 
					into STRICT	nr_seq_classif_w 
					from	titulo_receber_classif 
					where	nr_titulo	= nr_novo_titulo_w;
				 
					insert into titulo_receber_classif(nr_titulo, 
						nr_sequencia, 
						nm_usuario, 
						dt_atualizacao, 
						cd_conta_financ, 
						vl_original, 
						vl_classificacao, 
						vl_desconto) 
					values (nr_novo_titulo_w, 
						nr_seq_classif_w, 
						nm_usuario_p, 
						clock_timestamp(), 
						cd_conta_financ_cr_w, 
						vl_saldo_pessoa_w, 
						vl_saldo_pessoa_w, 
						0);
				end if;
					 
				update	pessoa_encontro_contas 
				set	nr_titulo_receber	= nr_novo_titulo_w, 
					vl_saldo_credor		= vl_saldo_pessoa_w 
				where	nr_sequencia		= nr_seq_pessoa_w;
			end if;
			 
			update	pessoa_encontro_contas 
			set	dt_baixa	= dt_baixa_p 
			where	nr_sequencia	= nr_seq_pessoa_w;
			end;
		end loop;
		close C01;
	end if;
	 
	open C04;	-- Cursor para atualizar o ds_observacao dos titulos receber/pagar (títulos baixados) 
	loop
	fetch C04 into	 
		nr_titulo_receber_w, 
		nr_titulo_pagar_w;
	EXIT WHEN NOT FOUND; /* apply on C04 */
		begin 
		if (vl_saldo_pessoa_w < 0) then 
			ds_observacao_baixa_w := substr(wheb_mensagem_pck.get_texto(304403,'NR_NOVO_TITULO=' || nr_novo_titulo_w),1,255);
		elsif (vl_saldo_pessoa_w > 0) then 
			ds_observacao_baixa_w := substr(wheb_mensagem_pck.get_texto(304404,'NR_NOVO_TITULO=' || nr_novo_titulo_w),1,255);
		else 
			ds_observacao_baixa_w := '';
		end if;
		 
		if (nr_titulo_receber_w IS NOT NULL AND nr_titulo_receber_w::text <> '') then 
			select	max(a.nr_sequencia) 
			into STRICT	nr_seq_baixa_w 
			from	titulo_receber_liq a 
			where	a.nr_titulo	= nr_titulo_receber_w;
			 
			update	titulo_receber_liq 
			set	ds_observacao		= substr(wheb_mensagem_pck.get_texto(304405,'NR_SEQ_LOTE=' || nr_seq_lote_p) || ds_observacao_baixa_w ,1,255) 
			where	nr_titulo		= nr_titulo_receber_w 
			and	nr_sequencia		= nr_seq_baixa_w;
		elsif (nr_titulo_pagar_w IS NOT NULL AND nr_titulo_pagar_w::text <> '') then 
			select	max(a.nr_sequencia) 
			into STRICT	nr_seq_baixa_w 
			from	titulo_pagar_baixa a 
			where	a.nr_titulo	= nr_titulo_pagar_w;
			 
			update	titulo_pagar_baixa 
			set	ds_observacao		= substr(wheb_mensagem_pck.get_texto(304405,'NR_SEQ_LOTE=' || nr_seq_lote_p) || ds_observacao_baixa_w ,1,255) 
			where	nr_titulo		= nr_titulo_pagar_w 
			and	nr_sequencia		= nr_seq_baixa_w;
		end if;
		end;
	end loop;
	close C04;
	 
	select	count(1) 
	into STRICT	qt_pessoas_w 
	from	pessoa_encontro_contas a 
	where	a.nr_seq_lote	= nr_seq_lote_p;
	 
	select	count(1) 
	into STRICT	qt_baixas_w 
	from	pessoa_encontro_contas a 
	where	a.nr_seq_lote	 = nr_seq_lote_p 
	and	(a.dt_baixa IS NOT NULL AND a.dt_baixa::text <> '');
	 
	select	coalesce(sum(a.vl_saldo_credor),0) - coalesce(sum(a.vl_saldo_devedor),0) 
	into STRICT	vl_saldo_lote_w 
	from	pessoa_encontro_contas a 
	where	a.nr_seq_lote	= nr_seq_lote_p;
	 
	if (qt_baixas_w = qt_pessoas_w) then 
		update	lote_encontro_contas 
		set	dt_baixa	= dt_baixa_p, 
			nm_usuario	= nm_usuario_p, 
			dt_atualizacao	= clock_timestamp(), 
			vl_saldo	= vl_saldo_lote_w 
		where	nr_sequencia	= nr_seq_lote_p;
	end if;
end if;
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baixar_lote_encontro_contas ( nr_seq_lote_p bigint, ie_acao_p text, dt_baixa_p timestamp, cd_pessoa_fisica_p text, cd_cgc_p text, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
