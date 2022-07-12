-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION pls_fiscal_dados_dmed_pck.obter_valor_nota_credito () RETURNS bigint AS $body$
DECLARE


vl_nota_credito_w	titulo_receber_liq.vl_nota_credito%type;
pr_item_nota_credito_w	double precision;


BEGIN

vl_nota_credito_w	:= 0;

if (current_setting('pls_fiscal_dados_dmed_pck.vl_recebido_nota_credito_w')::titulo_receber_liq.vl_nota_credito%type <> 0) then
	PERFORM set_config('pls_fiscal_dados_dmed_pck.vl_item_rateio_w', (current_setting('pls_fiscal_dados_dmed_pck.vl_item_rateio_w')::pls_mensalidade_seg_item.vl_item%type + current_setting('pls_fiscal_dados_dmed_pck.vl_juros_negociacao_item_w')::double + current_setting('pls_fiscal_dados_dmed_pck.vl_multa_negociacao_item_w')::double + current_setting('pls_fiscal_dados_dmed_pck.vl_taxa_negociacao_item_w')::double) - current_setting('pls_fiscal_dados_dmed_pck.vl_desconto_negociacao_item_w')::double, false);
	pr_item_nota_credito_w	:= (100/current_setting('pls_fiscal_dados_dmed_pck.vl_recebido_w')::titulo_receber_liq.vl_recebido%type) * current_setting('pls_fiscal_dados_dmed_pck.vl_item_rateio_w')::pls_mensalidade_seg_item.vl_item%type;
	
	if (coalesce(current_setting('pls_fiscal_dados_dmed_pck.vl_item_rateio_w')::pls_mensalidade_seg_item.vl_item%type, 0) <> 0) then
		vl_nota_credito_w	:= (pr_item_nota_credito_w/100) * current_setting('pls_fiscal_dados_dmed_pck.vl_recebido_nota_credito_w')::titulo_receber_liq.vl_nota_credito%type;
		
		if	((vl_nota_credito_w = 0) and (current_setting('pls_fiscal_dados_dmed_pck.vl_item_rateio_w')::pls_mensalidade_seg_item.vl_item%type > 0)) then
			vl_nota_credito_w := current_setting('pls_fiscal_dados_dmed_pck.vl_item_rateio_w')::pls_mensalidade_seg_item.vl_item%type;
		end if;

		if (current_setting('pls_fiscal_dados_dmed_pck.qt_total_itens_w')::bigint = current_setting('pls_fiscal_dados_dmed_pck.qt_item_w')::bigint) then
			if (current_setting('pls_fiscal_dados_dmed_pck.qt_outros_titulos_w')::bigint = 0) then
				if	((current_setting('pls_fiscal_dados_dmed_pck.vl_total_nota_credito_w')::titulo_receber_liq.vl_nota_credito%type + vl_nota_credito_w) <> current_setting('pls_fiscal_dados_dmed_pck.vl_recebido_nota_credito_w')::titulo_receber_liq.vl_nota_credito%type) then
					vl_nota_credito_w := vl_nota_credito_w + (current_setting('pls_fiscal_dados_dmed_pck.vl_recebido_nota_credito_w')::titulo_receber_liq.vl_nota_credito%type - (current_setting('pls_fiscal_dados_dmed_pck.vl_total_nota_credito_w')::titulo_receber_liq.vl_nota_credito%type + vl_nota_credito_w));
				end if;
			else
				if	((current_setting('pls_fiscal_dados_dmed_pck.vl_total_nota_credito_w')::titulo_receber_liq.vl_nota_credito%type + current_setting('pls_fiscal_dados_dmed_pck.vl_dif_desconto_baixa_tit_w')::double + vl_nota_credito_w) <> current_setting('pls_fiscal_dados_dmed_pck.vl_recebido_nota_credito_w')::titulo_receber_liq.vl_nota_credito%type) then
					vl_nota_credito_w := vl_nota_credito_w + (current_setting('pls_fiscal_dados_dmed_pck.vl_recebido_nota_credito_w')::titulo_receber_liq.vl_nota_credito%type - (current_setting('pls_fiscal_dados_dmed_pck.vl_total_nota_credito_w')::titulo_receber_liq.vl_nota_credito%type + current_setting('pls_fiscal_dados_dmed_pck.vl_dif_desconto_baixa_tit_w')::double + vl_nota_credito_w));
				end if;
			end if;
		elsif	(((current_setting('pls_fiscal_dados_dmed_pck.vl_total_nota_credito_w')::titulo_receber_liq.vl_nota_credito%type + vl_nota_credito_w) > current_setting('pls_fiscal_dados_dmed_pck.vl_recebido_nota_credito_w')::titulo_receber_liq.vl_nota_credito%type) and (current_setting('pls_fiscal_dados_dmed_pck.vl_item_rateio_w')::pls_mensalidade_seg_item.vl_item%type > 0)) then
			vl_nota_credito_w := 0;
		end if;
	end if;
end if;

PERFORM set_config('pls_fiscal_dados_dmed_pck.vl_total_nota_credito_w', current_setting('pls_fiscal_dados_dmed_pck.vl_total_nota_credito_w')::titulo_receber_liq.vl_nota_credito%type + vl_nota_credito_w, false);

return vl_nota_credito_w;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION pls_fiscal_dados_dmed_pck.obter_valor_nota_credito () FROM PUBLIC;