-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_itens_cfdi_global (nr_sequencia_p bigint, nr_titulo_p bigint, nr_seq_baixa_p bigint, cd_serie_nf_p text, nm_usuario_p text, cd_operacao_nf_p bigint, cd_natureza_operacao_p bigint, cd_estabelecimento_p bigint, cd_centro_custo_p bigint, cd_conta_contabil_p bigint, cd_local_estoque_p bigint, cd_procedimento_p bigint, vl_baixa_p bigint) AS $body$
DECLARE


nr_item_nf_w     	nota_fiscal_item.nr_item_nf%type;
nr_sequencia_nf_w       nota_fiscal.nr_sequencia_nf%TYPE;
nr_nota_fiscal_w	nota_fiscal.nr_nota_fiscal%TYPE;


BEGIN

select  nr_nota_fiscal,
        nr_sequencia_nf
into STRICT    nr_nota_fiscal_w,
	nr_sequencia_nf_w
from    nota_fiscal
where   nr_sequencia = nr_sequencia_p;

select (coalesce(max(nr_item_nf),0)+1)
into STRICT	nr_item_nf_w
from	nota_fiscal_item
where	nr_sequencia	 = nr_sequencia_p;


	INSERT	INTO nota_fiscal_item(
		cd_estabelecimento,
		cd_procedimento,
		cd_natureza_operacao,
		cd_serie_nf,
		dt_atualizacao,
		nm_usuario,
		nr_atendimento,
		nr_item_nf,
		nr_nota_fiscal,
		nr_sequencia,
		nr_sequencia_nf,
		qt_item_nf,
		qt_peso_bruto,
		qt_peso_liquido,
		vl_desconto,
		vl_desconto_rateio,
		vl_despesa_acessoria,
		vl_frete,
		vl_liquido,
		vl_seguro,
		vl_total_item_nf,
		vl_unitario_item_nf,
		cd_centro_custo,
		cd_conta_contabil,
		cd_local_estoque,
		nr_titulo,
		nr_seq_tit_rec)
	VALUES (	cd_estabelecimento_p,
		cd_procedimento_p,
		cd_natureza_operacao_p,
		cd_serie_nf_p,
		clock_timestamp(),
		nm_usuario_p,
		null,
		nr_item_nf_w,
		nr_nota_fiscal_w,
		nr_sequencia_p,
		nr_sequencia_nf_w,
		1,
		0,
		0,
		0,
		0,
		0,
		0,
		coalesce(vl_baixa_p,0),
		0,
		coalesce(vl_baixa_p,0),
		coalesce(vl_baixa_p,0),
		cd_centro_custo_p,
		cd_conta_contabil_p,
		cd_local_estoque_p,
		nr_titulo_p,
		nr_seq_baixa_p);


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_itens_cfdi_global (nr_sequencia_p bigint, nr_titulo_p bigint, nr_seq_baixa_p bigint, cd_serie_nf_p text, nm_usuario_p text, cd_operacao_nf_p bigint, cd_natureza_operacao_p bigint, cd_estabelecimento_p bigint, cd_centro_custo_p bigint, cd_conta_contabil_p bigint, cd_local_estoque_p bigint, cd_procedimento_p bigint, vl_baixa_p bigint) FROM PUBLIC;
