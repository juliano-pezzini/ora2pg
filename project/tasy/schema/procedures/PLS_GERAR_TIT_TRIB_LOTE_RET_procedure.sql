-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_tit_trib_lote_ret ( nr_seq_lote_ret_p bigint, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) AS $body$
DECLARE

	
ds_irrelevante_w		varchar(4000);
cd_benef_regra_w		varchar(255);
ie_conta_contab_tit_trib_w	varchar(255);
ie_conta_financ_tit_trib_w	varchar(255);
cd_darf_w			varchar(255);
cd_conta_cred_w			varchar(20);
cd_conta_contab_trib_w		varchar(20);
cd_cgc_w			varchar(14);
cd_pessoa_fisica_w		varchar(10);
ie_tipo_contratacao_w		varchar(2);
vl_base_calculo_w		double precision;
vl_imposto_w			double precision;
nr_titulo_w			bigint;
nr_seq_classe_w			bigint;
cd_tipo_baixa_neg_w		bigint;
cd_conta_financ_regra_w		bigint;
cd_conta_financ_w		bigint;
nr_seq_trans_reg_w		bigint;
nr_seq_trans_baixa_w		bigint;
cd_empresa_w			bigint;
nr_seq_regra_w			bigint;
cd_tributo_w			bigint;
cd_moeda_padrao_w		bigint;
nr_seq_ret_valor_w		bigint;
dt_imposto_w			timestamp;
dt_mes_referencia_w		timestamp;
nr_seq_tipo_prestador_w		pls_tipo_prestador.nr_sequencia%type;
nr_seq_classificacao_w		pls_prestador.nr_seq_classificacao%type;
ie_titulo_zerado_w		varchar(1);
vl_saldo_trib_w			pls_lote_ret_trib_valor.vl_saldo_trib%type;
	
C01 CURSOR FOR
	SELECT	c.vl_base_calculo,
		c.vl_imposto,
		c.cd_tributo,
		b.cd_cgc,
		b.cd_pessoa_fisica,
		c.dt_imposto,
		c.nr_sequencia,
		a.dt_mes_referencia,
		c.vl_saldo_trib
	from	pls_lote_ret_trib_valor c,
		pls_lote_ret_trib_prest	b,
		pls_lote_retencao_trib	a
	where	b.nr_sequencia = c.nr_seq_trib_prest
	and	a.nr_sequencia = b.nr_seq_lote
	and	c.ie_pago_prev <> 'R'
	and	a.nr_sequencia = nr_seq_lote_ret_p;
	

BEGIN
if (nr_seq_lote_ret_p IS NOT NULL AND nr_seq_lote_ret_p::text <> '') then	
	open C01;
	loop
	fetch C01 into	
		vl_base_calculo_w,
		vl_imposto_w,
		cd_tributo_w,
		cd_cgc_w,
		cd_pessoa_fisica_w,		
		dt_imposto_w,
		nr_seq_ret_valor_w,
		dt_mes_referencia_w,
		vl_saldo_trib_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		----- faço o select na parametros_conta_pagar para verificar se permite gerar titulo para valores zerados
		select	coalesce(max(ie_titulo_zerado),'S')
		into STRICT	ie_titulo_zerado_w
		from 	parametros_contas_pagar
		where	cd_estabelecimento	= cd_estabelecimento_p;
		
		if	( ie_titulo_zerado_w = 'S' and vl_saldo_trib_w >= 0) or --se parametro = 'S' permite qualquer valor que não seja negativo
			( ie_titulo_zerado_w = 'N' and vl_saldo_trib_w > 0) then -- se parametro = 'N' so valor maior que zero

		
			select	max(a.ie_tipo_contratacao),
				max(e.nr_seq_tipo_prestador),
				max(e.nr_seq_classificacao)
			into STRICT	ie_tipo_contratacao_w,
				nr_seq_tipo_prestador_w,
				nr_seq_classificacao_w
			from	pls_prestador			e,
				pls_lote_pagamento		d,
				pls_pagamento_prestador		c,
				pls_pag_prest_vencimento	b,
				pls_pag_prest_venc_trib		a,
				tributo				z
			where	a.nr_seq_vencimento		= b.nr_sequencia
			and	b.nr_seq_pag_prestador		= c.nr_sequencia
			and	c.nr_seq_lote			= d.nr_sequencia
			and	e.nr_sequencia			= c.nr_seq_prestador

			and	a.cd_tributo			= cd_tributo_w	
			and	z.cd_tributo			= a.cd_tributo
			and (e.cd_pessoa_fisica = cd_pessoa_fisica_w or e.cd_cgc = cd_cgc_w)
			and	(((z.ie_venc_pls_pag_prod IS NOT NULL AND z.ie_venc_pls_pag_prod::text <> '') and (CASE WHEN z.ie_venc_pls_pag_prod='V' THEN b.dt_vencimento  ELSE d.dt_mes_competencia END  between trunc(to_date(dt_mes_referencia_w),'month') and fim_dia(last_day(to_date(dt_mes_referencia_w))))) or
				CASE WHEN z.ie_vencimento='V' THEN b.dt_vencimento WHEN z.ie_vencimento='C' THEN b.dt_vencimento  ELSE d.dt_mes_competencia END  between trunc(to_date(dt_mes_referencia_w),'month') and fim_dia(last_day(to_date(dt_mes_referencia_w))));
			
			SELECT * FROM obter_dados_trib_tit_pagar(	cd_tributo_w, cd_estabelecimento_p, cd_cgc_w, cd_pessoa_fisica_w, cd_benef_regra_w, ds_irrelevante_w, ds_irrelevante_w, cd_conta_financ_regra_w, nr_seq_trans_reg_w, nr_seq_trans_baixa_w, ds_irrelevante_w, ds_irrelevante_w, ds_irrelevante_w, ds_irrelevante_w, ds_irrelevante_w, cd_darf_w, dt_mes_referencia_w, ds_irrelevante_w, ds_irrelevante_w, 'N', null, null, null, ie_tipo_contratacao_w, null, nr_seq_regra_w, null, 0, nr_seq_classe_w, cd_tipo_baixa_neg_w, vl_base_calculo_w, 'S', null, null, nr_seq_tipo_prestador_w, nr_seq_classificacao_w) INTO STRICT cd_benef_regra_w, ds_irrelevante_w, ds_irrelevante_w, cd_conta_financ_regra_w, nr_seq_trans_reg_w, nr_seq_trans_baixa_w, ds_irrelevante_w, ds_irrelevante_w, ds_irrelevante_w, ds_irrelevante_w, ds_irrelevante_w, cd_darf_w, ds_irrelevante_w, ds_irrelevante_w, nr_seq_regra_w, nr_seq_classe_w, cd_tipo_baixa_neg_w;			
							
			if (cd_benef_regra_w IS NOT NULL AND cd_benef_regra_w::text <> '') then	
				select	nextval('titulo_pagar_seq')
				into STRICT	nr_titulo_w
				;

				select	coalesce(max(ie_conta_contab_tit_trib),'T'),
					coalesce(max(ie_conta_financ_tit_trib),'T'),
					max(cd_moeda_padrao)
				into STRICT	ie_conta_contab_tit_trib_w,
					ie_conta_financ_tit_trib_w,
					cd_moeda_padrao_w
				from	parametros_contas_pagar
				where 	cd_estabelecimento 	= cd_estabelecimento_p;	
				
				if (ie_conta_financ_tit_trib_w = 'R') then
					cd_conta_financ_w	:= coalesce(cd_conta_financ_regra_w, cd_conta_financ_w);
				end if;
				
				cd_conta_contab_trib_w	:= null;
				
				if (ie_conta_contab_tit_trib_w = 'R') then
					select	max(cd_empresa)
					into STRICT	cd_empresa_w
					from	estabelecimento	
					where	cd_estabelecimento	= cd_estabelecimento_p;
					
					cd_conta_contab_trib_w		:= substr(obter_conta_contabil_trib(cd_empresa_w, cd_tributo_w, cd_cgc_w, clock_timestamp()),1,20);
				end if;	

				insert into titulo_pagar(
					nr_titulo,
					cd_estabelecimento,
					dt_atualizacao,
					nm_usuario,
					dt_emissao,
					dt_contabil,
					dt_vencimento_original,
					dt_vencimento_atual,
					vl_titulo, 	
					vl_saldo_titulo,
					vl_saldo_juros,
					vl_saldo_multa,
					cd_moeda,
					tx_juros,
					tx_multa,
					cd_tipo_taxa_juro,
					cd_tipo_taxa_multa,
					tx_desc_antecipacao,
					ie_situacao,
					ie_origem_titulo,
					ie_tipo_titulo,
					cd_cgc,
					ie_desconto_dia,
					nr_lote_contabil,
					nr_seq_trans_fin_contab,
					nr_seq_trans_fin_baixa,
					ie_status_tributo,
					nr_lote_transf_trib,
					nr_seq_classe,
					cd_tipo_baixa_neg,
					ie_status,
					cd_tributo,
					ds_observacao_titulo,
					cd_darf)
				values (nr_titulo_w,
					cd_estabelecimento_p,
					clock_timestamp(),
					nm_usuario_p,
					trunc(clock_timestamp(),'dd'),
					trunc(clock_timestamp(),'dd'),
					trunc(dt_imposto_w, 'dd'),
					trunc(dt_imposto_w, 'dd'),
					vl_saldo_trib_w,
					vl_saldo_trib_w,
					0,
					0, 
					cd_moeda_padrao_w,
					0,
					0, 
					1,
					1,
					0,
					'A',		  		/* Situação Aberto */
					4,  	/*4- Imposto, 3- Repasse (quando origem for repasse)*/
					4,                			/* Imposto */
					cd_benef_regra_w,
					'N',
					0,
					nr_seq_trans_reg_w,
					nr_seq_trans_baixa_w,
					'NT',
					0,
					nr_seq_classe_w,
					cd_tipo_baixa_neg_w,
					'D',
					cd_tributo_w,
					substr(obter_nome_pf_pj(cd_pessoa_fisica_w, cd_cgc_w), 1,80),
					cd_darf_w);
					
				CALL atualizar_inclusao_tit_pagar(nr_titulo_w, nm_usuario_p);
				
				insert into titulo_pagar_classif(
					nr_titulo, nr_sequencia, vl_titulo,
					dt_atualizacao, nm_usuario,
					cd_conta_contabil, cd_centro_custo,
					nr_seq_conta_financ)
				values (	nr_titulo_w, 1, vl_saldo_trib_w,
					clock_timestamp(), nm_usuario_p, 
					coalesce(cd_conta_contab_trib_w,cd_conta_cred_w), null, 
					cd_conta_financ_w);
					
				update	pls_lote_ret_trib_valor
				set	nr_titulo 	= nr_titulo_w,
					nm_usuario	= nm_usuario_p,
					dt_atualizacao	= clock_timestamp()
				where	nr_sequencia 	= nr_seq_ret_valor_w;
				
				-- alimenta o campo do titulo a pagar com o nr_titulo gerado OS960165
				update 	pls_pag_prest_venc_trib
				set	nr_titulo_pagar_ret = nr_titulo_w
				where	nr_seq_lote_ret_trib_valor = nr_seq_ret_valor_w;
			end if;
	end if;	
	end;
	end loop;
	close C01;	
end if;

begin
	update	pls_lote_retencao_trib
	set	dt_geracao_titulos	= clock_timestamp()
	where	nr_sequencia		= nr_seq_lote_ret_p;	
exception
when others then
	null;
end;
	
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_tit_trib_lote_ret ( nr_seq_lote_ret_p bigint, cd_estabelecimento_p estabelecimento.cd_estabelecimento%type, nm_usuario_p usuario.nm_usuario%type) FROM PUBLIC;

