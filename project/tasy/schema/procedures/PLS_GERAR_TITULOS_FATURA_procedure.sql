-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE pls_gerar_titulos_fatura ( nr_seq_lote_p bigint, nr_seq_pls_fatura_p bigint, nr_seq_acao_tit_p bigint, ie_commit_p text, cd_estabelecimento_p bigint, nm_usuario_p text) is /* +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
Finalidade: Gerar os títulos do faturamento
-------------------------------------------------------------------------------------------------------------------

Locais de chamada direta: 
[ X ]  Objetos do dicionário [  ] Tasy (Delphi/Java) [  ] Portal [  ]  Relatórios [ ] Outros:
 ------------------------------------------------------------------------------------------------------------------

Pontos de atenção:
-------------------------------------------------------------------------------------------------------------------

Referências:
++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++ */
 cd_cgc_w varchar(14) RETURNS PLS_REGRA_SERIE_FAT.NR_SERIE_NF%TYPE AS $body$
DECLARE

				
nr_seq_regra_fat_w		pls_regra_serie_fat.nr_seq_regra_fat%type;
ie_tipo_segurado_w		pls_regra_serie_fat.ie_tipo_segurado%type;
nr_seq_contrato_w		pls_regra_serie_fat.nr_seq_contrato%type;
nr_seq_grupo_intercambio_w	pls_regra_serie_fat.nr_seq_grupo_intercambio%type;
nr_seq_intercambio_w		pls_regra_serie_fat.nr_seq_intercambio%type;
nr_serie_nf_w			pls_regra_serie_fat.nr_serie_nf%type;
nr_seq_segurado_w		pls_segurado.nr_sequencia%type;

C01 CURSOR FOR
	SELECT	nr_serie_nf
	from	pls_regra_serie_fat
	where	ie_situacao	= 'A'
	and	((nr_seq_regra_fat	= nr_seq_regra_fat_w) or (coalesce(nr_seq_regra_fat::text, '') = ''))
	and	((ie_tipo_segurado	= ie_tipo_segurado_w) or (coalesce(ie_tipo_segurado::text, '') = ''))
	and	((nr_seq_intercambio	= nr_seq_intercambio_w) or (coalesce(nr_seq_intercambio::text, '') = ''))
	and	((nr_seq_contrato	= nr_seq_contrato_w) or (coalesce(nr_seq_contrato::text, '') = ''))
	and	((nr_seq_grupo_intercambio	= nr_seq_grupo_intercambio_w) or (coalesce(nr_seq_grupo_intercambio::text, '') = ''))
	order by coalesce(nr_seq_regra_fat,0),
		coalesce(ie_tipo_segurado,'A'),
		coalesce(nr_seq_intercambio,0),
		coalesce(nr_seq_contrato,0),
		coalesce(nr_seq_grupo_intercambio,0);
		
BEGIN
select	max(nr_seq_regra_fat)
into STRICT	nr_seq_regra_fat_w
from	pls_lote_faturamento
where	nr_sequencia	= nr_seq_lote_p;

select	max(nr_seq_pagador_intercambio),
	max(nr_seq_contrato)
into STRICT	nr_seq_intercambio_w,
	nr_seq_contrato_w
from	pls_contrato_pagador
where	nr_sequencia	= nr_seq_pagador_p;

select	max(b.nr_seq_segurado),
	max(c.ie_tipo_segurado)
into STRICT	nr_seq_segurado_w,
	ie_tipo_segurado_w
from	pls_conta		c,
	pls_fatura_conta	b,
	pls_fatura_evento	a
where	b.nr_seq_fatura_evento	= a.nr_sequencia
and	c.nr_sequencia		= b.nr_seq_conta
and	a.nr_seq_fatura		= nr_seq_fatura_p;

if (nr_seq_segurado_w IS NOT NULL AND nr_seq_segurado_w::text <> '') then
	if (coalesce(ie_tipo_segurado_w::text, '') = '') then
		select	max(ie_tipo_segurado)
		into STRICT	ie_tipo_segurado_w
		from	pls_segurado
		where	nr_sequencia	= nr_seq_segurado_w;
	end if;
	
	if (coalesce(nr_seq_intercambio_w::text, '') = '') then
		select	max(nr_seq_intercambio)
		into STRICT	nr_seq_intercambio_w
		from	pls_segurado
		where	nr_sequencia	= nr_seq_segurado_w;
	end if;
end if;

if (coalesce(nr_seq_intercambio_w::text, '') = '') then
	select	max(nr_seq_grupo_intercambio)
	into STRICT	nr_seq_grupo_intercambio_w
	from	pls_intercambio
	where	nr_sequencia	= nr_seq_intercambio_w;
end if;

for r_c01_w in C01 loop
	nr_serie_nf_w	:= r_c01_w.nr_serie_nf;
end loop;

return nr_serie_nf_w;

end;

begin
if (nr_seq_lote_p IS NOT NULL AND nr_seq_lote_p::text <> '') then

	nr_seq_acao_w	:= nr_seq_acao_tit_p;
	
	select	max(nr_seq_lote_disc)
	into STRICT	nr_seq_lote_disc_w
	from	pls_lote_faturamento
	where	nr_sequencia	= nr_seq_lote_p;
	
	if (nr_seq_pls_fatura_p IS NOT NULL AND nr_seq_pls_fatura_p::text <> '') then
		select	coalesce(dt_prev_envio, clock_timestamp()),
			coalesce(dt_mesano_referencia, clock_timestamp()),
			dt_emissao
		into STRICT	dt_prev_envio_w,
			dt_mesano_referencia_w,
			dt_emissao_lote_w
		from	pls_lote_faturamento
		where	nr_sequencia	= nr_seq_lote_p;
		
		select	coalesce(max(ie_acao), '1') -- 1 Gerar título	14 Gerar título fatura	15 Gerar título NDC
		into STRICT	ie_acao_w
		from	pls_processo_interc_acao
		where	nr_sequencia	= nr_seq_acao_tit_p;
				
		select	coalesce(a.dt_emissao, coalesce(dt_emissao_lote_w, clock_timestamp())),
			a.nr_seq_congenere,
			a.nr_seq_pagador,
			a.vl_fatura,
			a.ie_impedimento_cobranca,
			a.vl_total_ndc
		into STRICT	dt_emissao_w,
			nr_seq_congenere_w,
			nr_seq_pagador_w,
			vl_fatura_w,
			ie_impedimento_cobranca_w,
			vl_total_ndc_w
		from	pls_fatura a
		where	a.nr_sequencia	= nr_seq_pls_fatura_p;
		
		select	max(nr_fatura),
			max(nr_nota_credito_debito),
			max(tp_documento_1),
			max(tp_documento_2)
		into STRICT	nr_fatura_w,
			nr_nota_credito_debito_w,
			tp_documento_1_w,
			tp_documento_2_w
		from	ptu_fatura
		where	nr_seq_pls_fatura = nr_seq_pls_fatura_p;
		
		if (ie_acao_w = '1') then -- Título GERAL
			vl_fatura_w		:= coalesce(vl_fatura_w,0) + coalesce(vl_total_ndc_w,0);
			ie_tit_fat_ndc_w	:= 'N';
		elsif (ie_acao_w = '14') then -- Título Fatura
			ie_tit_fat_ndc_w	:= 'S';
		elsif (ie_acao_w = '15') then -- Título NDC
			vl_fatura_w		:= coalesce(vl_total_ndc_w,0);
			ie_tit_fat_ndc_w	:= 'S';			
		end if;		
		
		dt_vencimento_w		:= pls_obter_data_venc_pls_fatura(nr_seq_pls_fatura_p, cd_estabelecimento_p, 'N');

		if (coalesce(vl_fatura_w, 0) > 0) and -- Verificar se tem valor/dt venc para geração do título
			(dt_vencimento_w IS NOT NULL AND dt_vencimento_w::text <> '') then			
			nr_seq_conta_banco_w	:= null;
			nr_seq_camara_w		:= null;
			
			if (nr_seq_pagador_w IS NOT NULL AND nr_seq_pagador_w::text <> '') then
				select	a.cd_pessoa_fisica,
					a.cd_cgc
				into STRICT	cd_pessoa_fisica_w,
					cd_cgc_w
				from	pls_contrato_pagador a
				where	a.nr_sequencia = nr_seq_pagador_w;
				
				nr_seq_conta_banco_w	:= pls_obter_dados_pagador_fin(	nr_seq_pagador_w, 'NS');
			elsif (nr_seq_congenere_w IS NOT NULL AND nr_seq_congenere_w::text <> '') then
				select	a.cd_cgc
				into STRICT	cd_cgc_w
				from	pls_congenere a
				where	a.nr_sequencia	= nr_seq_congenere_w;
				
				select	max(a.nr_sequencia)
				into STRICT	nr_seq_pagador_w
				from	pls_contrato_pagador	a
				where	a.nr_seq_congenere	= nr_seq_congenere_w;
				
				if (nr_seq_pagador_w IS NOT NULL AND nr_seq_pagador_w::text <> '') then
					nr_seq_conta_banco_w	:= pls_obter_dados_pagador_fin(	nr_seq_pagador_w, 'NS');
				end if;
			end if;
			
			if (coalesce(nr_seq_camara_w::text, '') = '') and (nr_seq_congenere_w IS NOT NULL AND nr_seq_congenere_w::text <> '') then
				select	max(a.nr_seq_camara)
				into STRICT	nr_seq_camara_w
				from	pls_congenere_camara a
				where	a.nr_seq_congenere = nr_seq_congenere_w
				and	dt_emissao_w between a.dt_inicio_vigencia_ref and a.dt_fim_vigencia_ref;
			end if;
			
			if (cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '') and (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
				cd_cgc_w	:= null;
			end if;
			
			select	max(a.cd_tipo_receb_perda),
				max(a.nr_seq_trans_fin_perda),
				max(a.nr_seq_conta_banco),
				max(a.nr_seq_classe_rec),
				max(a.nr_seq_trans_fin_baixa),
				max(a.nr_seq_carteira_cobr),
				max(a.nr_seq_trans_fin_contab)
			into STRICT	cd_tipo_recebimento_w,
				nr_seq_trans_financ_w,
				nr_seq_conta_banc_acao_w,
				nr_seq_classe_rec_w,
				nr_seq_trans_fin_baixa_w,
				nr_seq_carteira_cobr_w,
				nr_seq_trans_fin_contab_w
			from	pls_processo_interc_acao a
			where	nr_sequencia	= nr_seq_acao_tit_p;
			
			if (coalesce(nr_seq_conta_banco_w::text, '') = '') then
				nr_seq_conta_banco_w	:= nr_seq_conta_banc_acao_w;
			end if;
			
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
			where	a.cd_estabelecimento	= cd_estabelecimento_p;
			exception
			when no_data_found then
				CALL wheb_mensagem_pck.exibir_mensagem_abort(172762);
			end;
			
			if (nr_seq_pagador_w IS NOT NULL AND nr_seq_pagador_w::text <> '') then
				select	max(nr_sequencia)
				into STRICT	nr_seq_regra_w
				from	pls_contrato_pagador_fin
				where	nr_seq_pagador	= nr_seq_pagador_w
				and	trunc(clock_timestamp()) between trunc(dt_inicio_vigencia, 'dd') and fim_dia(coalesce(dt_fim_vigencia, clock_timestamp()));
				
				if (nr_seq_regra_w IS NOT NULL AND nr_seq_regra_w::text <> '') and (coalesce(nr_seq_camara_w::text, '') = '') then
					begin
					select	coalesce(cd_tipo_portador,cd_tipo_portador_w),
						coalesce(cd_portador,cd_portador_w),
						coalesce(nr_seq_conta_banco,nr_seq_conta_banco_w),
						coalesce(nr_seq_carteira_cobr,nr_seq_carteira_cobr_w)
					into STRICT	cd_tipo_portador_w,
						cd_portador_w,
						nr_seq_conta_banco_w,
						nr_seq_carteira_cobr_w
					from	pls_contrato_pagador_fin
					where	nr_sequencia	= nr_seq_regra_w;
					exception
					when others then
						cd_tipo_portador_w	:= cd_tipo_portador_w;
						cd_portador_w		:= cd_portador_w;
						nr_seq_carteira_cobr_w	:= null;
						nr_seq_conta_banco_w	:= nr_seq_conta_banco_w;
					end;
				end if;
			end if;
			
			cd_serie_w := substr(obter_serie_titulo(nr_seq_lote_p,nr_seq_pls_fatura_p,nr_seq_pagador_w),1,5);
			
			begin
			select	CASE WHEN cd_serie_w='' THEN cd_serie_nf  ELSE cd_serie_w END ,
				nr_nota_fiscal
			into STRICT	cd_serie_w,
				nr_nota_fiscal_w
			from	nota_fiscal
			where	nr_seq_fatura	= nr_seq_pls_fatura_p;
			exception
			when others then
				nr_nota_fiscal_w:= null;
			end;
			
			if (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') or (cd_cgc_w IS NOT NULL AND cd_cgc_w::text <> '') then
				if (ie_acao_w = '15') and (nr_nota_credito_debito_w IS NOT NULL AND nr_nota_credito_debito_w::text <> '') and (tp_documento_2_w in ('1','4')) then -- Titulo NDC
					nr_titulo_w := (nr_nota_credito_debito_w)::numeric;
				
				elsif (ie_acao_w in ('1','14')) and (nr_fatura_w IS NOT NULL AND nr_fatura_w::text <> '') and (tp_documento_1_w in ('1','4')) then -- Titulo fatura
					nr_titulo_w := (nr_fatura_w)::numeric;
				else				
					select	nextval('titulo_seq')
					into STRICT	nr_titulo_w
					;
				end if;
				
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
					nr_lote_contabil,
					nr_seq_conta_banco,
					cd_serie,
					nr_seq_carteira_cobr,
					nr_seq_classe,
					nr_seq_trans_fin_baixa,
					nr_seq_trans_fin_contab,
					ie_pls,
					nr_nota_fiscal,
					nr_seq_pagador,
					nr_seq_pls_fatura)
				values (nr_titulo_w,
					nm_usuario_p,
					clock_timestamp(),
					cd_estabelecimento_p,
					cd_tipo_portador_w,
					cd_portador_w,
					dt_emissao_w,
					dt_emissao_w,
					dt_vencimento_w,
					dt_vencimento_w,
					vl_fatura_w,
					vl_fatura_w,
					0,
					0,
					tx_juros_cr_w,
					tx_multa_cr_w,
					cd_tipo_taxa_juro_cr_w,
					cd_tipo_taxa_multa_cr_w,
					0,
					'15', /* Fatura */
					'2',
					'13', /* OPS - Faturamento */
					cd_moeda_cr_w,
					'1',
					cd_pessoa_fisica_w,
					cd_cgc_w,
					'2' /* Emissão bloqueto origem */
,
					0,
					nr_seq_conta_banco_w,
					cd_serie_w,
					nr_seq_carteira_cobr_w,
					nr_seq_classe_rec_w,
					nr_seq_trans_fin_baixa_w,
					nr_seq_trans_fin_contab_w,
					'S',
					nr_nota_fiscal_w,
					nr_seq_pagador_w,
					nr_seq_pls_fatura_p);			
					
				if (nr_seq_lote_disc_w IS NOT NULL AND nr_seq_lote_disc_w::text <> '') then
					update	pls_lote_discussao
					set	nr_titulo_receber	= nr_titulo_w
					where	nr_sequencia		= nr_seq_lote_disc_w;
				end if;
					
				cd_serie_w	:= null;
					
				if (ie_impedimento_cobranca_w = 'BP') then
					if (coalesce(cd_tipo_recebimento_w::text, '') = '') or (coalesce(nr_seq_trans_financ_w::text, '') = '') then
						CALL wheb_mensagem_pck.exibir_mensagem_abort(244066);
					end if;
					
					select	coalesce(max(nr_sequencia), 0) + 1
					into STRICT	nr_seq_baixa_w
					from	titulo_receber_liq
					where	nr_titulo = nr_titulo_w;
					
					insert into titulo_receber_liq(nr_titulo,
						nr_sequencia,
						dt_recebimento,
						vl_recebido,
						vl_descontos,
						vl_juros,
						vl_multa,
						vl_rec_maior,
						vl_glosa,
						cd_moeda,					
						cd_tipo_recebimento,
						ie_acao,
						nr_seq_trans_fin,
						ie_lib_caixa,
						dt_atualizacao,
						nm_usuario,
						nr_lote_contabil,
						nr_lote_contab_antecip,
						nr_lote_contab_pro_rata,
						ds_observacao)
					values (nr_titulo_w,
						nr_seq_baixa_w,
						dt_emissao_w,
						vl_fatura_w,
						0,
						0,
						0,
						0,
						0,
						cd_moeda_cr_w,					
						cd_tipo_recebimento_w,
						'I', 
						nr_seq_trans_financ_w, 
						'S',
						clock_timestamp(),
						nm_usuario_p,
						0,
						0,
						0,
						'Baixa gerada pela função OPS - Faturamento, devido a fatura ter impedimento de cobrança');
						
					CALL atualizar_saldo_tit_rec(nr_titulo_w, nm_usuario_p);	
				end if;
				
				if (ie_acao_w = '15') then -- Título NDC
					update	pls_fatura
					set 	nr_titulo_ndc 		= nr_titulo_w,
						dt_vencimento_ndc	= dt_vencimento_w,
						ie_tit_fat_ndc		= ie_tit_fat_ndc_w,
						dt_vencimento		= dt_vencimento_w,
						nm_usuario		= nm_usuario_p,
						dt_atualizacao		= clock_timestamp(),
						dt_emissao		= dt_emissao_w
					where	nr_sequencia 		= nr_seq_pls_fatura_p;
				else -- Título Geral / Fatura
					update	pls_fatura
					set 	nr_titulo 		= nr_titulo_w,
						dt_vencimento		= dt_vencimento_w,
						ie_tit_fat_ndc		= ie_tit_fat_ndc_w,
						dt_vencimento_ndc	= dt_vencimento_w,
						nm_usuario		= nm_usuario_p,
						dt_atualizacao		= clock_timestamp(),
						dt_emissao		= dt_emissao_w
					where	nr_sequencia 		= nr_seq_pls_fatura_p;
				end if;

				-- Gerar classificação do título a receber

				/*OS 1402862 - Conversei com o bernardino. A classificacao so gera se no pls_fatura tiver o título. Como o update ocorre aqui em cima, retirei a geração da classif que estava abaixo do insert no titulo e coloquei aqui, depois do update.*/

				CALL pls_gerar_tit_rec_class_fat( nr_titulo_w, cd_estabelecimento_p, nm_usuario_p, 'N');
				
				CALL pls_gerar_fatura_log(nr_seq_lote_p, nr_seq_pls_fatura_p, null, 'PLS_GERAR_TITULOS_FATURA', 'GT' ,ie_commit_p , nm_usuario_p);
				
				cd_cgc_w 		:= null;
				cd_pessoa_fisica_w 	:= null;

				select	count(1)
				into STRICT	qt_registros_w
				from	pls_fatura_trib
				where	nr_seq_fatura	= nr_seq_pls_fatura_p  LIMIT 1;
				
				if (qt_registros_w > 0) then
					CALL gerar_imposto_tit_rec(	nr_titulo_w, nm_usuario_p);
				end if;
				
				CALL atualizar_saldo_tit_rec(nr_titulo_w, nm_usuario_p);
				
				--Se há pagador, deve ser verificado se NÃO há informações financeiras (nvl autorizando a geração do bloqueto), ou se há e esteja configurada como Boleto, então dentro destas condições o bloqueto pode ser gerado
				if (nr_seq_pagador_w IS NOT NULL AND nr_seq_pagador_w::text <> '') then
					if (coalesce(pls_obter_dados_pagador_fin(nr_seq_pagador_w, 'F'), '1') = '1') then
						CALL gerar_bloqueto_tit_rec(nr_titulo_w, 'OPSF');
					end if;
				else
					CALL gerar_bloqueto_tit_rec(nr_titulo_w, 'OPSF');
				end if;
				
				select	max(b.cd_tributo)
				into STRICT	cd_tributo_ir_w
				from	tributo b,
					titulo_receber_trib a
				where	a.cd_tributo		= b.cd_tributo
				and	b.ie_situacao		= 'A'
				and	b.ie_tipo_tributo	= 'IR'
				and	a.nr_titulo		= nr_titulo_w;
				
				if (cd_tributo_ir_w IS NOT NULL AND cd_tributo_ir_w::text <> '') then
					select	coalesce(sum(a.vl_tributo), 0)
					into STRICT	vl_ir_w
					from	titulo_receber_trib a
					where	a.nr_titulo	= nr_titulo_w
					and	a.cd_tributo	= cd_tributo_ir_w;
				end if;
				
				if (nr_seq_camara_w IS NOT NULL AND nr_seq_camara_w::text <> '') then				
					if (nr_seq_acao_w IS NOT NULL AND nr_seq_acao_w::text <> '') then
						select	coalesce(qt_dias_antes_a500, 0)
						into STRICT	qt_dias_antes_a500_w
						from	pls_processo_interc_acao
						where	nr_sequencia	= nr_seq_acao_w;
					else
						qt_dias_antes_a500_w	:= 0;
					end if;
					
					CALL pls_inserir_tit_camara(	null, nr_titulo_w, nr_seq_camara_w,trunc(clock_timestamp(), 'dd'),
								qt_dias_antes_a500_w, cd_estabelecimento_p, nm_usuario_p);
				end if;
				
				-- if	(nvl(ie_commit_p, 'N') = 'S') then
					select	max(a.nr_sequencia),
						max(a.cd_serie_nf)
					into STRICT 	nr_seq_nota_w,
						cd_serie_w
					from	nota_fiscal a
					where	a.nr_seq_fatura	= nr_seq_pls_fatura_p;
				
					update	titulo_receber	a
					set	a.nr_seq_nf_saida	= CASE WHEN nr_seq_nf_saida = NULL THEN nr_seq_nota_w  ELSE nr_seq_nf_saida END ,
						a.cd_serie		= CASE WHEN cd_serie='' THEN cd_serie_w  ELSE cd_serie END
					where	exists (SELECT	1
							from	pls_fatura x
							where	x.nr_titulo 	= a.nr_titulo
							and	x.nr_sequencia 	= nr_seq_pls_fatura_p);
				-- end if;

				
				/*AAMFIRMO Inicio alteração OS 925991 - Para titulos originados de OPS Faturamento(13), a data contábil do titulo deve ser a data referencia do lote OPS*/

				begin
					ie_dt_contabil_ops_w := Obter_Param_Usuario(801, 204, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_dt_contabil_ops_w);
					
					if ( coalesce(ie_dt_contabil_ops_w,'N') = 'S' ) then
						
						select	max(a.ie_origem_titulo)
						into STRICT	ie_origem_titulo_w
						from	titulo_receber a
						where	a.nr_titulo = nr_titulo_w;
						
						if (ie_origem_titulo_w = '13') then
							select 	max(x.dt_mes_competencia)
							into STRICT	dt_contabil_ops_w
							from 	pls_fatura  x
							where 	x.nr_titulo = nr_titulo_w;
							
							if (coalesce(dt_contabil_ops_w::text, '') = '') then
								select 	max(x.dt_mes_competencia)
								into STRICT	dt_contabil_ops_w
								from 	pls_fatura  x
								where  	x.nr_titulo_ndc = nr_titulo_w;
							end if;
							
							if (dt_contabil_ops_w IS NOT NULL AND dt_contabil_ops_w::text <> '') then
								update	titulo_receber
								set	dt_contabil = coalesce(dt_contabil_ops_w,dt_contabil)
								where	nr_titulo = nr_titulo_w;
							end if;
						end if;
					end if;	
				exception when others then
					null;
				end;
				/*AAMFIRMO Inicio alteração OS 925991 - Para titulos originados de OPS Faturamento(13), a data contábil do titulo deve ser a data referencia do lote OPS*/

			end if; -- Pessoa física
		end if; -- Título
	end if; -- Não faturar
end if;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE pls_gerar_titulos_fatura ( nr_seq_lote_p bigint, nr_seq_pls_fatura_p bigint, nr_seq_acao_tit_p bigint, ie_commit_p text, cd_estabelecimento_p bigint, nm_usuario_p text) is  cd_cgc_w varchar(14) FROM PUBLIC;

