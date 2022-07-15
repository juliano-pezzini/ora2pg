-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_sintese_cot_proposta ( nr_seq_cot_prod_p bigint, cd_fornecedor_oferta_p text, cd_produto_marca_p text, ds_marca_p text, qt_embalagem_p bigint, vl_preco_produto_p bigint, pr_ipi_produto_p bigint, ds_observacao_p text, ie_selecao_oferta_p text, ds_justificativa_compra_p text, qt_entrega_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_cot_proposta_w	bigint;


BEGIN

select	nextval('w_sintese_cot_proposta_seq')
into STRICT	nr_seq_cot_proposta_w
;

insert into w_sintese_cot_proposta(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_cot_prod,
	cd_fornecedor_oferta,
	cd_produto_marca,
	ds_marca,
	qt_embalagem,
	vl_preco_produto,
	pr_ipi_produto,
	ds_observacao,
	ie_selecao_oferta,
	ds_justificativa_compra,
	qt_entrega)
values (	nr_seq_cot_proposta_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_seq_cot_prod_p,
	cd_fornecedor_oferta_p,
	cd_produto_marca_p,
	ds_marca_p,
	qt_embalagem_p,
	vl_preco_produto_p,
	pr_ipi_produto_p,
	ds_observacao_p,
	CASE WHEN upper(ie_selecao_oferta_p)='TRUE' THEN  substr(wheb_mensagem_pck.get_texto(309708),1,255)  ELSE substr(wheb_mensagem_pck.get_texto(309709),1,255) END ,
	ds_justificativa_compra_p,
	qt_entrega_p);


commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_sintese_cot_proposta ( nr_seq_cot_prod_p bigint, cd_fornecedor_oferta_p text, cd_produto_marca_p text, ds_marca_p text, qt_embalagem_p bigint, vl_preco_produto_p bigint, pr_ipi_produto_p bigint, ds_observacao_p text, ie_selecao_oferta_p text, ds_justificativa_compra_p text, qt_entrega_p bigint, nm_usuario_p text) FROM PUBLIC;

