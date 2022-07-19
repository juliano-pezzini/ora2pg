-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE w_gerar_rel_planilha_cotacao ( nr_cot_compra_p bigint) AS $body$
DECLARE

 
nr_seq_cot_item_w			bigint;
nr_seq_cot_col_w			bigint;
nr_item_cot_compra_w		integer;
cd_material_w			integer;
cd_fornecedor_w			varchar(14);
qt_material_w			double precision;
vl_unitario_material_w		double precision;
nr_seq_coluna_w			integer;
ds_marca_w			varchar(30);
vl_ipi_w				double precision;
cd_condicao_pagamento_w		bigint;
vl_frete_w			double precision;
qt_dias_entrega_w			integer;
vl_unitario_inicial_w			double precision;
vl_liquido_w			double precision;
ie_vencedor_w			varchar(1);
nr_seq_cot_item_forn_w		bigint;
ds_observacao_w			varchar(255);
ds_observacao_item_w		varchar(255);
ds_material_direto_w_w		varchar(255);
c01 CURSOR FOR
	SELECT	nr_item_cot_compra, 
		cd_material 
	from	cot_compra_item 
	where	nr_cot_compra = nr_cot_compra_p;

c02 CURSOR FOR 
	SELECT	distinct 
		a.nr_sequencia, 
		f.cd_cgc_fornecedor, 
		f.cd_condicao_pagamento, 
		f.vl_previsto_frete, 
		f.qt_dias_entrega, 
		a.qt_material, 
		a.vl_unitario_material, 
		a.vl_preco_liquido, 
		a.vl_unitario_inicial, 
		a.ds_marca, 
		substr(coalesce(obter_se_fornec_venc_cotacao(nr_cot_compra_p,a.nr_item_cot_compra,f.nr_sequencia),'N'),1,1) ie_vencedor, 
		substr(f.ds_observacao,1,255), 
		a.ds_observacao, 
		b.DS_MATERIAL_DIRETO_W 
	from	cot_compra_forn_item a, 
		cot_compra_forn f, 
		cot_compra_item b 
	where	f.nr_sequencia		= a.nr_seq_cot_forn 
	and	a.nr_cot_compra 		= nr_cot_compra_p 
	and	a.nr_cot_compra = b.nr_cot_compra 
	and	b.nr_item_cot_compra = a.nr_item_cot_compra 
	and	a.nr_item_cot_compra 	= nr_item_cot_compra_w 
	order by substr(obter_dados_pf_pj(null, f.cd_cgc_fornecedor,'N'),1,200);


BEGIN 
 
delete from w_cotacao_item_coluna;
delete from w_cotacao_item;
 
open c01;
loop 
	fetch c01 into 
		nr_item_cot_compra_w, 
		cd_material_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
 
	select	nextval('w_cotacao_item_seq') 
	into STRICT	nr_seq_cot_item_w 
	;
 
	insert into w_cotacao_item( 
		nr_sequencia, 
		dt_atualizacao, 
		nm_usuario, 
		cd_material) 
	values (	nr_seq_cot_item_w, 
		clock_timestamp(), 
		'Tasy', 
		cd_material_w);
	commit;
 
	open c02;
	loop 
		fetch c02 into 
			nr_seq_cot_item_forn_w, 
			cd_fornecedor_w, 
			cd_condicao_pagamento_w, 
			vl_frete_w, 
			qt_dias_entrega_w, 
			qt_material_w, 
			vl_unitario_material_w, 
			vl_liquido_w, 
			vl_unitario_inicial_w, 
			ds_marca_w, 
			ie_vencedor_w, 
			ds_observacao_w, 
			ds_observacao_item_w, 
			ds_material_direto_w_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
 
			select	nextval('w_cotacao_item_coluna_seq') 
			into STRICT	nr_seq_cot_col_w 
			;
 
			select	coalesce(max(nr_seq_coluna),0) 
			into STRICT	nr_seq_coluna_w 
			from	w_cotacao_item_coluna 
			where	cd_fornecedor = cd_fornecedor_w;
 
			if (nr_seq_coluna_w = 0) then 
				select	coalesce(max(nr_seq_coluna),0) + 1 
				into STRICT	nr_seq_coluna_w 
				from	w_cotacao_item_coluna;
			end if;
			 
			select	coalesce(sum(b.vl_tributo),0) 
			into STRICT	vl_ipi_w 
			from	cot_compra_forn_item_tr b, 
				tributo c 
			where	b.cd_tributo = c.cd_tributo 
			and	c.ie_tipo_tributo = 'IPI' 
			and	b.nr_seq_cot_item_forn = nr_seq_cot_item_forn_w;
 
			insert into w_cotacao_item_coluna( 
				nr_sequencia, 
				nr_seq_coluna, 
				dt_atualizacao, 
				nm_usuario, 
				nr_seq_cotacao_item, 
				cd_fornecedor, 
				qt_fornecedor, 
				vl_fornecedor, 
				vl_liquido, 
				vl_unitario_inicial, 
				ds_marca, 
				vl_ipi, 
				cd_condicao_pagamento, 
				vl_frete, 
				qt_dias_entrega, 
				ie_vencedor, 
				ds_observacao, 
				ds_observacao_item, 
				nr_item_cot_compra, 
				ds_material_direto) 
			values (	nr_seq_cot_col_w, 
				nr_seq_coluna_w, 
				clock_timestamp(), 
				'Tasy', 
				nr_seq_cot_item_w, 
				cd_fornecedor_w, 
				qt_material_w, 
				vl_unitario_material_w, 
				vl_liquido_w, 
				vl_unitario_inicial_w, 
				ds_marca_w, 
				vl_ipi_w, 
				cd_condicao_pagamento_w, 
				vl_frete_w, 
				qt_dias_entrega_w, 
				ie_vencedor_w, 
				ds_observacao_w, 
				ds_observacao_item_w, 
				nr_item_cot_compra_w, 
				ds_material_direto_w_w);
			commit;
	end loop;
	close c02;
end loop;
close c01;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE w_gerar_rel_planilha_cotacao ( nr_cot_compra_p bigint) FROM PUBLIC;

