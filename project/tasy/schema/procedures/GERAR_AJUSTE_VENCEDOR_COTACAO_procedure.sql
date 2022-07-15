-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_ajuste_vencedor_cotacao ( nr_sequencia_p bigint, qt_alterar_p bigint, nr_seq_item_fornec_p bigint, nm_usuario_p text) AS $body$
DECLARE



nr_sequencia_w		bigint;
nr_cot_compra_w		bigint;
nr_item_cot_compra_w	bigint;
nr_seq_cot_forn_w		bigint;
qt_diferenca_w		double precision;
vl_preco_liquido_w		double precision;
vl_presente_w		double precision;
vl_unitario_material_w	double precision;
vl_unitario_liquido_w	double precision;
vl_frete_rateio_w		double precision;
vl_preco_w		double precision;



BEGIN

select (qt_material - qt_alterar_p)
into STRICT	qt_diferenca_w
from	cot_compra_resumo
where	nr_sequencia		= nr_sequencia_p;


/*Faz o ajuste da quantidade*/

update	cot_compra_resumo
set	vl_preco_liquido	= dividir(vl_preco_liquido, qt_material) * qt_alterar_p,
	vl_presente	= dividir(vl_presente, qt_material) * qt_alterar_p,
	qt_material	= qt_alterar_p,
	ds_mensagem	= wheb_mensagem_pck.get_texto(300884, 'QT_MATERIAL='||qt_material || ';QT_ALTERAR=' || qt_alterar_p || ';NM_USUARIO=' || nm_usuario_p)
where	nr_sequencia	= nr_sequencia_p;



/*gera a diferença no novo fornecedor*/

select	nr_cot_compra,
	nr_item_cot_compra,
	nr_seq_cot_forn,
	vl_unitario_material,
	vl_unitario_liquido,
	dividir(vl_preco_liquido, qt_material) * qt_diferenca_w,
	dividir(vl_frete_rateio, qt_material) * qt_diferenca_w,
	dividir(vl_presente, qt_material) * qt_diferenca_w,
	vl_preco
into STRICT	nr_cot_compra_w,
	nr_item_cot_compra_w,
	nr_seq_cot_forn_w,
	vl_unitario_material_w,
	vl_unitario_liquido_w,
	vl_preco_liquido_w,
	vl_frete_rateio_w,
	vl_presente_w,
	vl_preco_w
from	cot_compra_forn_item
where	nr_sequencia = nr_seq_item_fornec_p;

select	nextval('cot_compra_resumo_seq')
into STRICT	nr_sequencia_w
;


insert into cot_compra_resumo(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	nr_cot_compra,
	nr_item_cot_compra,
	nr_seq_cot_forn,
	nr_seq_cot_item_forn,
	qt_material,
	vl_unitario_material,
	vl_unitario_liquido,
	vl_preco_liquido,
	vl_frete_rateio,
	vl_presente,
	vl_preco,
	ds_mensagem)
values (	nr_sequencia_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	nr_cot_compra_w,
	nr_item_cot_compra_w,
	nr_seq_cot_forn_w,
	nr_seq_item_fornec_p,
	qt_diferenca_w,
	vl_unitario_material_w,
	vl_unitario_liquido_w,
	vl_preco_liquido_w,
	vl_frete_rateio_w,
	vl_presente_w,
	vl_preco_w,
	wheb_mensagem_pck.get_texto(300881, 'NM_USUARIO=' || nm_usuario_p));

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_ajuste_vencedor_cotacao ( nr_sequencia_p bigint, qt_alterar_p bigint, nr_seq_item_fornec_p bigint, nm_usuario_p text) FROM PUBLIC;

