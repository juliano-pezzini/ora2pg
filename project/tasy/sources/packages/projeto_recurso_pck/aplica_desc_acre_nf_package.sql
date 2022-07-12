-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
	--VT>>>>>>>>>>>>>>>>>>>> Obter valor total liquido de um item aplicando os descontos e acrescimos da Nota Fiscal <<<<<<<<<<<<<<<<<<<<<<<<<<<<<--

	/*
	Objetivo: Retornar o valor total liquido do item aplicando os descontos e acrescimos da nota fiscal, quando os mesmos ja nao sao aplicados ao calcular a nota
	Parametros: 
	nr_seq_nota_fiscal_p = Numero de sequencia da nota fiscal
	vl_liq_item_p = Lavor liquido do item da nota fiscal
	*/



CREATE OR REPLACE FUNCTION projeto_recurso_pck.aplica_desc_acre_nf ( nr_seq_nota_fiscal_p bigint, vl_liq_item_p bigint) RETURNS bigint AS $body$
DECLARE

					
	vl_icms_w		double precision;
	vl_icms_st_w		double precision;
	vl_despesa_doc_w	nota_fiscal.vl_despesa_doc%type;
	vl_frete_w		nota_fiscal.vl_frete%type;
	vl_seguro_w		nota_fiscal.vl_seguro%type;
	vl_descontos_w		nota_fiscal.vl_descontos%type;
	vl_despesa_acessoria_w	nota_fiscal.vl_despesa_acessoria%type;
	vl_ipi_w		nota_fiscal.vl_ipi%type;
	vl_retorno_w		double precision;
	vl_soma_itens_w		double precision;
	
	
BEGIN
	
	vl_retorno_w		:= vl_liq_item_p;

	select 	coalesce(max(obter_valor_icms_nf(nr_sequencia)),0),	
		coalesce(max(obter_valor_icmsst_nf(nr_sequencia)),0),		
		coalesce(max(vl_despesa_doc),0),
		coalesce(max(vl_frete),0),	
		coalesce(max(vl_seguro),0),
		coalesce(max(vl_descontos),0),
		coalesce(max(vl_despesa_acessoria),0),
		coalesce(max(vl_ipi),0)
	into STRICT	vl_icms_w,		
	        vl_icms_st_w,	
	        vl_despesa_doc_w,
	        vl_frete_w,	
	        vl_seguro_w,		
	        vl_descontos_w,		
	        vl_despesa_acessoria_w,	
	        vl_ipi_w		
	from	nota_fiscal
	where 	nr_sequencia = nr_seq_nota_fiscal_p;
	
	select 	coalesce(sum(vl_liquido),0)
	into STRICT	vl_soma_itens_w
	from 	nota_fiscal_item
	where	nr_sequencia = nr_seq_nota_fiscal_p;
	
	
	if (vl_icms_w <> 0) then
		vl_retorno_w := vl_retorno_w + dividir_sem_round(vl_icms_w, vl_soma_itens_w) * vl_liq_item_p;
	end if;
	
	if (vl_icms_st_w <> 0) then
		vl_retorno_w := vl_retorno_w + dividir_sem_round(vl_icms_st_w, vl_soma_itens_w) * vl_liq_item_p;
	end if;
	
	if (vl_despesa_doc_w <> 0) then
		vl_retorno_w := vl_retorno_w + dividir_sem_round(vl_despesa_doc_w, vl_soma_itens_w) * vl_liq_item_p;
	end if;
	
	if (vl_frete_w <> 0) then
		vl_retorno_w := vl_retorno_w + dividir_sem_round(vl_frete_w, vl_soma_itens_w) * vl_liq_item_p;
	end if;
	
	if (vl_seguro_w <> 0) then
		vl_retorno_w := vl_retorno_w + dividir_sem_round(vl_seguro_w, vl_soma_itens_w) * vl_liq_item_p;
	end if;
	
	if (vl_descontos_w <> 0) then
		vl_retorno_w := vl_retorno_w - dividir_sem_round(vl_descontos_w, vl_soma_itens_w) * vl_liq_item_p;
	end if;
	
	if (vl_despesa_acessoria_w <> 0) then
		vl_retorno_w := vl_retorno_w + dividir_sem_round(vl_despesa_acessoria_w, vl_soma_itens_w) * vl_liq_item_p;
	end if;
	
	if (vl_ipi_w <> 0) then
		vl_retorno_w := vl_retorno_w + dividir_sem_round(vl_ipi_w, vl_soma_itens_w) * vl_liq_item_p;
	end if;
	
	
	return vl_retorno_w;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION projeto_recurso_pck.aplica_desc_acre_nf ( nr_seq_nota_fiscal_p bigint, vl_liq_item_p bigint) FROM PUBLIC;
