-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cot_compra_pend_lib ( nm_usuario_p text) AS $body$
DECLARE

 
 
nr_cot_compra_w			cot_compra.nr_cot_compra%type;
nr_item_cot_compra_w		cot_compra_item.nr_item_cot_compra%type;
cd_material_w			material.cd_material%type;
qt_material_w			cot_compra_item.qt_material%type;
cd_unidade_medida_compra_w	unidade_medida.cd_unidade_medida%type;
vl_unitario_material_w		cot_compra_forn_item.vl_unitario_material%type;
vl_preco_liquido_w		cot_compra_forn_item.vl_preco_liquido%type;
nr_seq_cot_item_forn_w		cot_compra_forn_item.nr_sequencia%type;
cd_cgc_fornecedor_w		pessoa_juridica.cd_cgc%type;
cd_estabelecimento_w		estabelecimento.cd_estabelecimento%type;

c01 CURSOR FOR 
SELECT	a.nr_cot_compra, 
	a.nr_item_cot_compra, 
	a.cd_material, 
	a.qt_material, 
	a.cd_unidade_medida_compra, 
	a.vl_unitario_material, 
	a.vl_preco_liquido, 
	a.nr_seq_cot_item_forn, 
	a.cd_cgc_fornecedor, 
	a.cd_estabelecimento 
from	cot_compra_pend_lib_v a 
where	substr(obter_se_mat_lib_fornec(a.cd_cgc_fornecedor,a.cd_material, a.cd_estabelecimento, 'C'),1,15) in ('L', 'V') 
and	coalesce(a.dt_liberacao::text, '') = '' 
and	coalesce(a.dt_geracao_ordem_compra::text, '') = '';


BEGIN 
 
delete from cot_compra_pend_lib;
 
open C01;
loop 
fetch C01 into	 
	nr_cot_compra_w, 
	nr_item_cot_compra_w, 
	cd_material_w, 
	qt_material_w, 
	cd_unidade_medida_compra_w, 
	vl_unitario_material_w, 
	vl_preco_liquido_w, 
	nr_seq_cot_item_forn_w, 
	cd_cgc_fornecedor_w, 
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	insert into cot_compra_pend_lib( 
		nr_sequencia, 
		dt_atualizacao, 
		nm_usuario,		 
		nr_cot_compra, 
		nr_item_cot_compra, 
		cd_material, 
		qt_material, 
		cd_unidade_medida_compra, 
		vl_unitario_material, 
		vl_preco_liquido, 
		nr_seq_cot_item_forn,	 
		cd_cgc_fornecedor, 
		cd_estabelecimento) 
	values (	nextval('cot_compra_pend_lib_seq'), 
		clock_timestamp(), 
		nm_usuario_p,		 
		nr_cot_compra_w, 
		nr_item_cot_compra_w, 
		cd_material_w, 
		qt_material_w, 
		cd_unidade_medida_compra_w, 
		vl_unitario_material_w, 
		vl_preco_liquido_w, 
		nr_seq_cot_item_forn_w, 
		cd_cgc_fornecedor_w, 
		cd_estabelecimento_w);
	end;
end loop;
close C01;
 
 
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cot_compra_pend_lib ( nm_usuario_p text) FROM PUBLIC;

