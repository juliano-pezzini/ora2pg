-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_titulo_trib_receb (nr_seq_nfs_p bigint, nm_usuario_p text) AS $body$
DECLARE

			
cd_tributo_w            	nota_fiscal_trib.cd_tributo%type;
vl_tributo_w            	nota_fiscal_trib.vl_tributo%type;
tx_tributo_w            	nota_fiscal_trib.tx_tributo%type;
vl_base_calculo_w      	 	nota_fiscal_trib.vl_base_calculo%type;
vl_trib_nao_retido_w    	nota_fiscal_trib.vl_trib_nao_retido%type;
vl_base_nao_retido_w   	 	nota_fiscal_trib.vl_base_nao_retido%type;
vl_trib_adic_w          	nota_fiscal_trib.vl_trib_adic%type;
vl_base_adic_w         		nota_fiscal_trib.vl_base_adic%type;
ie_origem_trib_w       		nota_fiscal_trib.ie_origem_trib%type;
nr_seq_regra_trib_w		nota_fiscal_trib.nr_seq_regra_trib%type;
ie_nf_tit_rec_w  		tributo.ie_nf_tit_rec%type;
nr_seq_trans_prov_trib_rec_w	tributo.nr_seq_trans_prov_trib_rec%type;
nr_seq_tit_rec_trib_w   	titulo_receber_trib.nr_sequencia%type;
ie_titulo_pagar_w  		regra_calculo_imposto.ie_titulo_pagar%type;
cd_cgc_beneficiario_w 		regra_calculo_imposto.cd_cgc_beneficiario%type;
nr_seq_trans_fin_baixa_cp_w 	regra_calculo_imposto.nr_seq_tf_baixa_cp%type;
cd_condicao_pagamento_trib_w 	regra_calculo_imposto.cd_condicao_pagamento%type;
dt_emissao_w                    nota_fiscal.dt_emissao%type;
cd_estabelecimento_w            nota_fiscal.cd_estabelecimento%type;
vl_total_nota_w 		nota_fiscal.vl_total_nota%type;
cd_cgc_w                	nota_fiscal.cd_cgc%type;
cd_pessoa_fisica_w      	nota_fiscal.cd_pessoa_fisica%type;
nr_interno_conta_w       	nota_fiscal.nr_interno_conta%type;
nr_seq_protocolo_w       	nota_fiscal.nr_seq_protocolo%type;
cd_condicao_pagamento_w    	nota_fiscal.cd_condicao_pagamento%type;
nr_nota_fiscal_w         	nota_fiscal.nr_nota_fiscal%type;
nr_seq_mensalidade_w      	nota_fiscal.nr_seq_mensalidade%type;
cd_conv_integracao_w      	nota_fiscal.cd_conv_integracao%type;
cd_operacao_nf_w          	nota_fiscal.cd_operacao_nf%type;
pr_juro_padrao_w   		parametros_contas_pagar.pr_juro_padrao%type;
pr_multa_padrao_w  		parametros_contas_pagar.pr_multa_padrao%type;
cd_tipo_taxa_juro_w   		parametro_contas_receber.cd_tipo_taxa_juro%type;
cd_tipo_taxa_multa_w  		parametro_contas_receber.cd_tipo_taxa_multa%type;
cd_moeda_padrao_w    		parametro_contas_receber.cd_moeda_padrao%type;
nr_seq_trans_fin_baixa_w 	parametro_contas_receber.nr_seq_trans_fin_baixa%type;
ie_conta_financ_tit_rec_w 	parametro_contas_receber.ie_conta_financ_tit_rec%type;
cd_convenio_w                   convenio.cd_convenio%type;
nr_titulo_w                     titulo_receber.nr_titulo%type;
nr_seq_regra_w			regra_calculo_imposto.nr_sequencia%type;
cd_pessoa_fisica_trib_w         titulo_pagar.cd_pessoa_fisica%type;
nr_titulo_pagar_w               titulo_pagar.nr_titulo%type;
cd_estab_financeiro_w           estabelecimento.cd_estab_financeiro%type;
dt_vencimento_trib_w		timestamp;
qt_venc_w			bigint;
ds_venc_w			varchar(4000);
pr_aliquota_w			double precision;
vl_minimo_base_w		double precision;
vl_minimo_tributo_w		double precision;
ie_acumulativo_w		varchar(10);
vl_teto_base_w			double precision;
vl_desc_dependente_w		double precision;
ie_tipo_contrato_w		varchar(2);
cont_w 				integer;

cd_darf_w			regra_calculo_imposto.cd_darf%type;

C03 CURSOR FOR
	SELECT	a.cd_tributo,
		a.vl_tributo,
		a.tx_tributo,
		a.vl_base_calculo,
		a.vl_trib_nao_retido,
		a.vl_base_nao_retido,
		a.vl_trib_adic,
		a.vl_base_adic,
		a.ie_origem_trib,
		a.nr_seq_regra_trib
	from	nota_fiscal_trib a
	where	a.nr_sequencia	= nr_seq_nfs_p

union

	SELECT  cd_tributo,
		sum(vl_tributo),
		tx_tributo,
		sum(vl_base_calculo),
		sum(vl_trib_nao_retido),
		sum(vl_base_nao_retido),
		sum(vl_trib_adic),
		sum(vl_base_adic),
		ie_origem_trib,
		nr_seq_regra_trib
	from ( select	a.cd_tributo,
		a.vl_tributo,
		a.tx_tributo,
		a.vl_base_calculo,
		a.vl_trib_nao_retido,
		a.vl_base_nao_retido,
		a.vl_trib_adic,
		a.vl_base_adic,
		null ie_origem_trib,
		a.nr_seq_regra_trib
		from	nota_fiscal_item_trib a
		where	a.nr_sequencia	= nr_seq_nfs_p ) alias6
		group by    cd_tributo,
			    tx_tributo, 
			    ie_origem_trib,
			    nr_seq_regra_trib;
			
			    

BEGIN

select  max(nr_titulo)
into STRICT    nr_titulo_w
from    titulo_receber
where   nr_seq_nf_saida = nr_seq_nfs_p;	


select	dt_emissao,
	cd_estabelecimento,
	vl_total_nota,
	cd_cgc,
	cd_pessoa_fisica,
	nr_interno_conta,
	nr_seq_protocolo,
	cd_condicao_pagamento,
	vl_total_nota,
	nr_nota_fiscal,
	nr_seq_mensalidade,
	cd_conv_integracao,
	cd_operacao_nf
into STRICT	dt_emissao_w,
	cd_estabelecimento_w,
	vl_total_nota_w,
	cd_cgc_w,
	cd_pessoa_fisica_w,
	nr_interno_conta_w,
	nr_seq_protocolo_w,
	cd_condicao_pagamento_w,
	vl_total_nota_w,
	nr_nota_fiscal_w,
	nr_seq_mensalidade_w,
	cd_conv_integracao_w,
	cd_operacao_nf_w
from	nota_fiscal
where	nr_sequencia = nr_seq_nfs_p;	


if (coalesce(nr_seq_protocolo_w,0) > 0) then

	select	max(cd_convenio)
		into STRICT	cd_convenio_w
		from	protocolo_convenio
		where	nr_seq_protocolo	= nr_seq_protocolo_w;
	else
		select	max(c.cd_convenio)
		into STRICT	cd_convenio_w
		from	lote_protocolo c,
			nota_fiscal d
		where	d.nr_sequencia		= nr_seq_nfs_p
		and	d.nr_seq_lote_prot	= c.nr_sequencia;
end if;	
		
	
	select	max(a.pr_multa_padrao),
		max(a.pr_juro_padrao)
	into STRICT	pr_multa_padrao_w,
		pr_juro_padrao_w
	from	parametros_contas_pagar a
	where	a.cd_estabelecimento	= cd_estabelecimento_w;
	
	select	cd_tipo_taxa_juro,
		cd_tipo_taxa_multa,
		cd_moeda_padrao
	into STRICT	cd_tipo_taxa_juro_w,
		cd_tipo_taxa_multa_w,
		cd_moeda_padrao_w
	from	parametro_contas_receber
	where	cd_estabelecimento = cd_estabelecimento_w;
	
	select	coalesce(cd_estab_financeiro, cd_estabelecimento)
	into STRICT	cd_estab_financeiro_w
	from	estabelecimento
	where	cd_estabelecimento = cd_estabelecimento_w;
	
if (nr_titulo_w > 0 ) then	
	
			 
open C03;
loop
fetch C03 into
	cd_tributo_w,
	vl_tributo_w,
	tx_tributo_w,
	vl_base_calculo_w,
	vl_trib_nao_retido_w,
	vl_base_nao_retido_w,
	vl_trib_adic_w,
	vl_base_adic_w,
	ie_origem_trib_w,
	nr_seq_regra_trib_w;
EXIT WHEN NOT FOUND; /* apply on C03 */

	select	coalesce(max(ie_nf_tit_rec),'N'),
		max(nr_seq_trans_prov_trib_rec)
	into STRICT	ie_nf_tit_rec_w,
		nr_seq_trans_prov_trib_rec_w
	from	tributo
	where	cd_tributo = cd_tributo_w;

	select	count(*)
	into STRICT	cont_w
	from	titulo_receber_trib
	where	nr_titulo	= nr_titulo_w
	and	cd_tributo	= cd_tributo_w;

	if	(ie_nf_tit_rec_w = 'S' AND cont_w = 0) or (ie_nf_tit_rec_w = 'U') then
		
		if (cont_w > 0) then
			delete  from titulo_receber_trib
			where   nr_titulo	= nr_titulo_w
			and 	cd_tributo	= cd_tributo_w;
		end if;
		
		select	nextval('titulo_receber_trib_seq')
		into STRICT	nr_seq_tit_rec_trib_w
		;
		
		insert into titulo_receber_trib(nr_sequencia,
			dt_atualizacao,
			nm_usuario,
			nr_titulo,
			cd_tributo,
			vl_tributo,
			tx_tributo,
			vl_base_calculo,
			vl_trib_nao_retido,
			vl_base_nao_retido,
			vl_trib_adic,
			vl_base_adic,
			nr_seq_nota_fiscal,
			ie_origem_tributo,
			nr_seq_trans_financ,
			nr_lote_contabil)
		SELECT	nr_seq_tit_rec_trib_w,
			clock_timestamp(),
			nm_usuario_p,
			nr_titulo_w,
			cd_tributo_w,
			vl_tributo_w,
			coalesce(tx_tributo_w,0),
			coalesce(vl_base_calculo_w,0),
			vl_trib_nao_retido_w,
			vl_base_nao_retido_w,
			vl_trib_adic_w,
			vl_base_adic_w,
			nr_seq_nfs_p,
			CASE WHEN coalesce(ie_origem_trib_w::text, '') = '' THEN  'C'  ELSE ie_origem_trib_w END ,
			nr_seq_trans_prov_trib_rec_w,
			0
		;
		
		
		if (ie_origem_trib_w = 'CD') then
			CALL Atualizar_Saldo_Tit_Rec(nr_titulo_w, nm_usuario_p);
		end if;
		
		
		SELECT * FROM obter_dados_trib_tit_rec(cd_tributo_w, cd_estabelecimento_w, coalesce(cd_convenio_w,cd_conv_integracao_w), dt_emissao_w, 'N', pr_aliquota_w, vl_minimo_base_w, vl_minimo_tributo_w, ie_acumulativo_w, vl_teto_base_w, vl_desc_dependente_w, cd_pessoa_fisica_w, cd_cgc_w, ie_tipo_contrato_w, 1, 0, nr_seq_regra_w, cd_darf_w) INTO STRICT pr_aliquota_w, vl_minimo_base_w, vl_minimo_tributo_w, ie_acumulativo_w, vl_teto_base_w, vl_desc_dependente_w, nr_seq_regra_w, cd_darf_w;
		
		select	max(a.ie_titulo_pagar),
			max(a.cd_cgc_beneficiario),
			max(a.nr_seq_tf_baixa_cp),
			max(a.cd_condicao_pagamento)
		into STRICT	ie_titulo_pagar_w,
			cd_cgc_beneficiario_w,
			nr_seq_trans_fin_baixa_cp_w,
			cd_condicao_pagamento_trib_w
		from	regra_calculo_imposto a
		where	a.nr_sequencia	= nr_seq_regra_w;
		
		
		if (nr_seq_regra_trib_w IS NOT NULL AND nr_seq_regra_trib_w::text <> '') and (coalesce(ie_titulo_pagar_w::text, '') = '') then
		
			select	max(a.ie_titulo_pagar),
				max(a.cd_cgc_beneficiario),
				max(a.nr_seq_tf_baixa_cp),
				max(a.cd_condicao_pagamento)
		into STRICT		ie_titulo_pagar_w,
				cd_cgc_beneficiario_w,
				nr_seq_trans_fin_baixa_cp_w,
				cd_condicao_pagamento_trib_w
			from	regra_calculo_imposto a
			where	a.nr_sequencia	= nr_seq_regra_trib_w;
		
		end if;
		
		if (ie_titulo_pagar_w	= 'S') and (vl_tributo_w <> 0) then
			if (coalesce(cd_cgc_beneficiario_w::text, '') = '') then
				cd_pessoa_fisica_trib_w	:= cd_pessoa_fisica_w;
			else
				cd_pessoa_fisica_trib_w	:= null;
			end if;
			
			if (cd_condicao_pagamento_trib_w IS NOT NULL AND cd_condicao_pagamento_trib_w::text <> '') then
					dt_vencimento_trib_w := dt_emissao_w;
					
					if (PKG_DATE_UTILS.get_WeekDay(dt_vencimento_trib_w) = 7) then
						
						if (PKG_DATE_UTILS.start_of(dt_vencimento_trib_w,'DD',0) = PKG_DATE_UTILS.start_of(dt_vencimento_trib_w + 2, 'MONTH',0)) then
							dt_vencimento_trib_w := dt_vencimento_trib_w + 2;
						end if;
					elsif (PKG_DATE_UTILS.get_WeekDay(dt_vencimento_trib_w) = 1) then
						
						if (PKG_DATE_UTILS.start_of(dt_vencimento_trib_w,'DD',0) = PKG_DATE_UTILS.start_of(dt_vencimento_trib_w + 1, 'MONTH',0)) then
							dt_vencimento_trib_w := dt_vencimento_trib_w + 1;
						end if;
					end if;
					
					SELECT * FROM calcular_vencimento(	cd_estabelecimento_w, cd_condicao_pagamento_trib_w, dt_vencimento_trib_w, qt_venc_w, ds_venc_w) INTO STRICT qt_venc_w, ds_venc_w;

					if (qt_venc_w = 1) then	
						dt_vencimento_trib_w	:= to_date(substr(ds_venc_w,1,10),'DD/MM/YYYY');
					end if;

			end if;
			
			select	nextval('titulo_pagar_seq')
			into STRICT	nr_titulo_pagar_w
			;

			insert	into titulo_pagar(cd_cgc,
				cd_estabelecimento,
				cd_estab_financeiro,
				cd_moeda,
				cd_pessoa_fisica,
				cd_tipo_taxa_juro,
				cd_tipo_taxa_multa,
				dt_atualizacao,
				dt_emissao,
				dt_vencimento_atual,
				dt_vencimento_original,
				ie_origem_titulo,
				ie_situacao,
				ie_tipo_titulo,
				nm_usuario,
				nr_seq_tit_rec_trib,
				nr_titulo,
				tx_juros,
				tx_multa,
				vl_saldo_juros,
				vl_saldo_multa,
				vl_saldo_titulo,
				vl_titulo,
				cd_tributo,
				nr_seq_trans_fin_baixa)
			values (coalesce(cd_cgc_beneficiario_w,cd_cgc_w),
				cd_estabelecimento_w,
				cd_estab_financeiro_w,
				cd_moeda_padrao_w,
				cd_pessoa_fisica_trib_w,
				cd_tipo_taxa_juro_w,
				cd_tipo_taxa_multa_w,
				clock_timestamp(),
				dt_emissao_w,
				coalesce(dt_vencimento_trib_w,dt_emissao_w),
				coalesce(dt_vencimento_trib_w,dt_emissao_w),
				'4',
				'A',
				'4',
				nm_usuario_p,
				nr_seq_tit_rec_trib_w,
				nr_titulo_pagar_w,
				pr_juro_padrao_w,
				pr_multa_padrao_w,
				0,
				0,
				vl_tributo_w,
				vl_tributo_w,
				cd_tributo_w,
				nr_seq_trans_fin_baixa_cp_w);
			CALL atualizar_inclusao_tit_pagar(nr_titulo_pagar_w, nm_usuario_p);
		end if;
	end if;
end loop;
close c03;
end if;
		
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_titulo_trib_receb (nr_seq_nfs_p bigint, nm_usuario_p text) FROM PUBLIC;
