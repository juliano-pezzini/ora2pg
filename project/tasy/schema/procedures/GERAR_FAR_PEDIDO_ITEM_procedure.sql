-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_far_pedido_item (nr_seq_pedido_p bigint, cd_estabelecimento_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, cd_material_p bigint, qt_material_p bigint, nr_seq_contrato_conv_p bigint, nr_seq_item_p INOUT bigint, nr_pedido_retorno_p INOUT bigint) AS $body$
DECLARE

 
vl_total_item_w 		double precision;
vl_unitario_item_w 		double precision;
nr_sequencia_w		bigint;
nr_seq_pedido_w		bigint;
vl_total_pedido_w		double precision;
cd_unidade_venda_w 	varchar(30);
ie_entregar_w		varchar(1);
nr_seq_vendedor_w	bigint;
nr_seq_contrato_conv_w	bigint;
nr_seq_promocao_w	bigint;
qt_existe_w			bigint:=0;
vl_desconto_w			double precision;
pr_desconto_w			double precision;
qt_material_atual_w			double precision;
vl_liquido_item_w			double precision;
vl_liquido_original_w		double precision;


BEGIN 
 
nr_seq_pedido_w	:= coalesce(nr_seq_pedido_p,0);
	 
if (coalesce(nr_seq_pedido_w,0) = 0) then 
	ie_entregar_w := obter_param_usuario(1601, 1, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_entregar_w);
	nr_seq_vendedor_w 	:= far_obter_vendedor_usuario(nm_usuario_p);
	 
	 
	select	nextval('far_pedido_seq') 
	into STRICT 	nr_seq_pedido_w 
	;
	 
	nr_pedido_retorno_p := nr_seq_pedido_w;
	 
	insert into far_pedido( 
			nr_sequencia, 
			dt_atualizacao_nrec, 
			dt_atualizacao, 
			nm_usuario, 
			nm_usuario_nrec, 
			cd_estabelecimento, 
			dt_pedido, 
			nr_atendimento, 
			cd_pessoa_fisica, 
			vl_total, 
			vl_mercadoria, 
			ie_entregar, 
			nr_seq_vendedor, 
			nr_seq_contrato_conv, 
			ie_cpf_nota, 
			ie_classificacao, 
			ie_troco_entrega) 
		values (nr_seq_pedido_w, 
			clock_timestamp(), 
			clock_timestamp(), 
			nm_usuario_p, 
			nm_usuario_p, 
			cd_estabelecimento_p, 
			clock_timestamp(), 
			null, 
			cd_pessoa_fisica_p, 
			0, 
			0, 
			ie_entregar_w, 
			nr_seq_vendedor_w, 
			nr_seq_contrato_conv_p, 
			'N','P','N');
end if;
 
--far_obter_preco_mat(cd_material_p,cd_estabelecimento_p,nr_seq_pedido_w,vl_unitario_item_w,nr_seq_promocao_w); 
vl_unitario_item_w:= far_obter_preco_mat2(cd_material_p,cd_estabelecimento_p,0);
vl_desconto_w	 := far_obter_preco_mat2(cd_material_p,cd_estabelecimento_p,1);
pr_desconto_w   := round(dividir((100 * coalesce(vl_desconto_w,0)),(vl_desconto_w+vl_unitario_item_w)),1);
 
if (vl_desconto_w = vl_unitario_item_w) then 
	vl_desconto_w:= 0;
	pr_desconto_w:= 0;
end if;
 
 
select	count(*) 
into STRICT	qt_existe_w 
from	far_pedido_item 
where	nr_seq_pedido = nr_seq_pedido_p 
and	cd_material = cd_material_p;
 
if (qt_existe_w > 0) then 
 
	select	max(nr_seq_item) 
	into STRICT	nr_sequencia_w 
	from	far_pedido_item 
	where	nr_seq_pedido = nr_seq_pedido_p 
	and	cd_material = cd_material_p;
	 
	select	coalesce(max(qt_material),0), 
		coalesce(max(vl_desconto),0), 
		coalesce(max(vl_unitario_item),0) 
	into STRICT	qt_material_atual_w, 
		vl_desconto_w, 
		vl_liquido_original_w 
	from	far_pedido_item 
	where	nr_seq_pedido = nr_seq_pedido_p 
	and	nr_seq_item = nr_sequencia_w;	
	 
	qt_material_atual_w	:= (coalesce(qt_material_atual_w,0) + coalesce(qt_material_p,0));
	vl_desconto_w:= (vl_desconto_w+dividir(vl_desconto_w,qt_material_atual_w-1));	
	vl_total_item_w	:= (qt_material_atual_w * vl_unitario_item_w);
	vl_liquido_item_w	:= ((vl_liquido_original_w * qt_material_atual_w) - vl_desconto_w);
	 
	update	far_pedido_item 
	set	qt_material = qt_material_atual_w, 
		vl_total_item = vl_total_item_w, 
		vl_liquido_item = vl_liquido_item_w, 
		vl_desconto = vl_desconto_w 
	where	nr_seq_pedido = nr_seq_pedido_p 
	and	nr_seq_item = nr_sequencia_w;	
 
else 
 
	vl_total_item_w	:= round((vl_unitario_item_w * qt_material_p)::numeric,2);
 
	select	nr_seq_contrato_conv 
	into STRICT	nr_seq_contrato_conv_w 
	from	far_pedido 
	where	nr_sequencia = nr_seq_pedido_w;
 
	if (coalesce(nr_sequencia_w::text, '') = '') then 
		nr_sequencia_w := 1;
	end if;	
 
	select 	coalesce(max(nr_seq_item),0) + 1 
	into STRICT	nr_sequencia_w 
	from 	far_pedido_item 
	where	nr_seq_pedido = nr_seq_pedido_w;
	 
	insert into far_pedido_item( 
				nr_seq_item, 
				dt_atualizacao, 
				nm_usuario, 
				dt_atualizacao_nrec, 
				nm_usuario_nrec, 
				nr_seq_pedido, 
				qt_material, 
				cd_material, 
				vl_unitario_item, 
				vl_total_item, 
				vl_liquido_item, 
				cd_unidade_medida, 
				nr_seq_promocao, 
				vl_desconto, 
				pr_desconto) 
			values (nr_sequencia_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				clock_timestamp(), 
				nm_usuario_p, 
				nr_seq_pedido_w, 
				qt_material_p, 
				cd_material_p, 
				(vl_unitario_item_w+vl_desconto_w), 
				vl_total_item_w, 
				(((vl_unitario_item_w+vl_desconto_w)*qt_material_p)-vl_desconto_w), 
				cd_unidade_venda_w, 
				CASE WHEN nr_seq_promocao_w=0 THEN null  ELSE nr_seq_promocao_w END , 
				vl_desconto_w, 
				pr_desconto_w);
end if;			
commit;
 
CALL FAR_ATUALIZAR_VL_TOTAL_PED(nr_seq_pedido_w);
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_far_pedido_item (nr_seq_pedido_p bigint, cd_estabelecimento_p bigint, cd_pessoa_fisica_p text, nm_usuario_p text, cd_material_p bigint, qt_material_p bigint, nr_seq_contrato_conv_p bigint, nr_seq_item_p INOUT bigint, nr_pedido_retorno_p INOUT bigint) FROM PUBLIC;
