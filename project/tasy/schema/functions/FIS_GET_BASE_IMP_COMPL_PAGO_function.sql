-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fis_get_base_imp_compl_pago ( nr_sequencia_p nota_fiscal.nr_sequencia%type, tx_tributo_p nota_fiscal_item_trib.tx_tributo%type, sum_vl_base_calculo_p nota_fiscal_item_trib.vl_base_calculo%type, vl_recebido_p titulo_receber_liq.vl_recebido%type, vl_total_nota_p nota_fiscal.vl_total_nota%type) RETURNS varchar AS $body$
DECLARE


ds_retorno_w			varchar(20);
vl_base_calculo_nf_credito_w	nota_fiscal_item_trib.vl_base_calculo%type;
nr_seq_nf_credito_w		nota_fiscal.nr_Sequencia%type;


BEGIN

begin
	select 	nr_seq_nf_gerada
	into STRICT 	nr_seq_nf_credito_w
	from 	nf_credito
	where	nr_seq_nf_orig = nr_sequencia_p;
exception when no_data_found or too_many_rows then
nr_seq_nf_credito_w := -1;
end;

if (nr_seq_nf_credito_w  <> -1) then

	select	coalesce(sum(vl_base_calculo), 0)
	into STRICT 	vl_base_calculo_nf_credito_w
	from 	nota_fiscal_item_trib
	where	nr_sequencia = nr_seq_nf_credito_w
	and	tx_tributo = tx_tributo_p;
	
	ds_retorno_w := subst_virgula_ponto_adic_zero(campo_mascara_casas(sum_vl_base_calculo_p - vl_base_calculo_nf_credito_w, 2));
	
elsif (tx_tributo_p = 0) then
	ds_retorno_w := subst_virgula_ponto_adic_zero(campo_mascara_casas(sum_vl_base_calculo_p, 2));
	
else
	ds_retorno_w := subst_virgula_ponto_adic_zero(campo_mascara_casas(Dividir_sem_round(vl_recebido_p, vl_total_nota_p) * sum_vl_base_calculo_p, 2));
end if;

return ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fis_get_base_imp_compl_pago ( nr_sequencia_p nota_fiscal.nr_sequencia%type, tx_tributo_p nota_fiscal_item_trib.tx_tributo%type, sum_vl_base_calculo_p nota_fiscal_item_trib.vl_base_calculo%type, vl_recebido_p titulo_receber_liq.vl_recebido%type, vl_total_nota_p nota_fiscal.vl_total_nota%type) FROM PUBLIC;
