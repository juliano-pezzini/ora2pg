-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_sintese_oc_prod ( nr_seq_ordem_p bigint, cd_produto_p text, cd_produto_marca_p text, cd_marca_p text, ds_marca_p text, qt_embalagem_p bigint, qt_produto_p bigint, tp_frete_p text, vl_preco_produto_p bigint, pc_ipi_produto_p bigint, ds_observacao_produto_p text, nm_usuario_p text, nr_seq_oc_prod_p INOUT text) AS $body$
DECLARE


nr_seq_oc_prod_w	w_sintese_oc_prod.nr_sequencia%type;
			

BEGIN

select	nextval('w_sintese_oc_prod_seq')
into STRICT	nr_seq_oc_prod_w
;

insert into w_sintese_oc_prod(	
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_seq_ordem,
	cd_produto,
	cd_produto_marca,
	cd_marca,
	ds_marca,
	qt_embalagem,
	qt_produto,
	tp_frete,
	vl_preco_produto,
	pc_ipi_produto,
	ds_observacao_produto)
values (	nr_seq_oc_prod_w,
	clock_timestamp(),      
	nm_usuario_p,             
	clock_timestamp(),    
	nm_usuario_p,        
	nr_seq_ordem_p,
	cd_produto_p,
	cd_produto_marca_p,
	cd_marca_p,
	ds_marca_p,
	qt_embalagem_p,
	qt_produto_p,
	tp_frete_p,
	vl_preco_produto_p,
	pc_ipi_produto_p,
	ds_observacao_produto_p);

commit;
	
nr_seq_oc_prod_p := nr_seq_oc_prod_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_sintese_oc_prod ( nr_seq_ordem_p bigint, cd_produto_p text, cd_produto_marca_p text, cd_marca_p text, ds_marca_p text, qt_embalagem_p bigint, qt_produto_p bigint, tp_frete_p text, vl_preco_produto_p bigint, pc_ipi_produto_p bigint, ds_observacao_produto_p text, nm_usuario_p text, nr_seq_oc_prod_p INOUT text) FROM PUBLIC;

