-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';

	
-->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>++++++ VALORES REALIZADOS ++++++<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--


	--VR>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>> Nota Fiscal <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<--

	/*
	Objetivo: Retornar o valor realizado da nota fiscal passada por parametro no projeto recurso passado por parametro.
	Parametros: 
	nr_seq_proj_rec_p = Numero de sequencia do projeto recurso.
	nr_seq_nota_fiscal_p = Numero de sequencia da nota fiscal.
	*/



CREATE OR REPLACE FUNCTION projeto_recurso_pck.obter_vl_realizado_nf ( nr_seq_proj_rec_p bigint, nr_seq_nota_fiscal_p bigint) RETURNS bigint AS $body$
DECLARE

	
	vl_total_nf_w			nota_fiscal_item.vl_liquido%type;
	ie_considerar_trib_saldo_w 	projeto_recurso.ie_considerar_trib_saldo%type;
	vl_total_devolucao_w    	nota_fiscal.vl_total_nota%type;
	
	
BEGIN
	
	vl_total_nf_w := 0;
		
	select 	ie_considerar_trib_saldo
	into STRICT	ie_considerar_trib_saldo_w
	from	projeto_recurso
	where	nr_sequencia = nr_seq_proj_rec_p;
	
	begin
		select  sum(coalesce(n.vl_total_nota, 0))
		into STRICT    vl_total_devolucao_w
		from    nota_fiscal n,
			operacao_nota o
		where   n.nr_sequencia_ref = nr_seq_nota_fiscal_p
		and     (n.dt_atualizacao_estoque IS NOT NULL AND n.dt_atualizacao_estoque::text <> '')
		and     n.ie_situacao = 1
		and     n.cd_operacao_nf = o.cd_operacao_nf
		and	o.ie_operacao_fiscal = 'S'
		and 	o.ie_devolucao = 'S';
	exception
		when no_data_found then
		    vl_total_devolucao_w := 0;
	end;
	
	if (ie_considerar_trib_saldo_w = 'S') then
		select  round((coalesce(sum(b.vl_liquido),0))::numeric,2)
		into STRICT	vl_total_nf_w
		from    nota_fiscal a,
			nota_fiscal_item b
		where   a.nr_sequencia = b.nr_sequencia
		and	a.nr_sequencia = nr_seq_nota_fiscal_p
		and	b.nr_seq_proj_rec = nr_seq_proj_rec_p
		and     a.ie_situacao = 1
		and     (a.dt_atualizacao_estoque IS NOT NULL AND a.dt_atualizacao_estoque::text <> '');
	else
		select  round((coalesce(sum(b.vl_liquido),0))::numeric,2) - coalesce(sum(projeto_recurso_pck.obter_vl_total_trib_nf(nr_seq_nota_fiscal_p,b.nr_item_nf)),0)
		into STRICT	vl_total_nf_w
		from    nota_fiscal a,
			nota_fiscal_item b
		where   a.nr_sequencia = b.nr_sequencia
		and	a.nr_sequencia = nr_seq_nota_fiscal_p
		and	b.nr_seq_proj_rec = nr_seq_proj_rec_p
		and     a.ie_situacao = 1
		and     (a.dt_atualizacao_estoque IS NOT NULL AND a.dt_atualizacao_estoque::text <> '');
	end if;
	
	if (vl_total_devolucao_w > 0) then
		vl_total_nf_w := vl_total_nf_w - vl_total_devolucao_w;
	end if;
	
	return	vl_total_nf_w;
	
	END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON FUNCTION projeto_recurso_pck.obter_vl_realizado_nf ( nr_seq_proj_rec_p bigint, nr_seq_nota_fiscal_p bigint) FROM PUBLIC;
