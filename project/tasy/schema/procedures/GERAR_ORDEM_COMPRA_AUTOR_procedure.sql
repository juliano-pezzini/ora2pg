-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_ordem_compra_autor (nr_seq_autor_p bigint, dt_entrega_p timestamp, cd_local_estoque_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_ordem_compra_p INOUT bigint) AS $body$
DECLARE



nr_sequencia_w			bigint;
cd_comprador_w			varchar(10);
nr_ordem_compra_w		bigint;
cd_cgc_w			varchar(14);
cd_cgc_ww			varchar(14) := 'X';
nr_cot_compra_w			bigint;
nr_item_cot_compra_w		bigint;
cd_moeda_w			bigint;
vl_desconto_w			double precision;
pr_desconto_w			double precision;
ie_frete_w			varchar(1);
cd_pessoa_solicitante_w		varchar(10);
cd_local_entrega_w		bigint;
cd_condicao_pagamento_w		bigint;
nr_item_oci_w			integer;
cd_conta_contabil_w		varchar(20);
cd_centro_custo_w			bigint;
cd_material_w			integer;
qt_material_w			double precision;
cd_unidade_medida_compra_w	varchar(30);
vl_unitario_material_w		double precision;
vl_item_liquido_w			double precision := 0;
nr_seq_marca_w			bigint;


C01 CURSOR FOR
SELECT	b.cd_cgc,
	a.nr_cot_compra,
	a.nr_item_cot_compra,
	a.nr_sequencia,
	a.cd_material,
	substr(obter_dados_material(a.cd_material,'UMP'),1,30) cd_unidade_medida_compra,
	b.vl_unitario_cotado,
	a.qt_solicitada,	
	b.nr_seq_marca
from	material_autor_cirurgia a,
	material_autor_cir_cot b
where	a.nr_sequencia = b.nr_sequencia
and	a.nr_seq_autorizacao =  nr_seq_autor_p
and	b.ie_aprovacao = 'S'
and	a.qt_solicitada > 0
and	coalesce(a.nr_ordem_compra::text, '') = ''
order by	cd_cgc,cd_material;



BEGIN

open C01;
loop
fetch C01 into	
	cd_cgc_w,
	nr_cot_compra_w,
	nr_item_cot_compra_w,
	nr_sequencia_w,
	cd_material_w,
	cd_unidade_medida_compra_w,
	vl_unitario_material_w,
	qt_material_w,
	nr_seq_marca_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	if (cd_cgc_w <> cd_cgc_ww) then
	
		select	cd_moeda_padrao,
			cd_condicao_pagamento_padrao,
			cd_comprador_padrao,
			cd_pessoa_solic_padrao
		into STRICT	cd_moeda_w,
			cd_condicao_pagamento_w,
			cd_comprador_w,
			cd_pessoa_solicitante_w
		from	parametro_compras
		where	cd_estabelecimento = cd_estabelecimento_p;
	
		if (nr_cot_compra_w > 0) then
		
			select	coalesce(max(b.cd_moeda),cd_moeda_w),
				coalesce(max(b.cd_condicao_pagamento),cd_condicao_pagamento_w),
				coalesce(max(b.vl_desconto),0),
				max(b.pr_desconto),
				max(b.ie_frete),
				coalesce(max(a.cd_comprador), cd_comprador_w)
			into STRICT	cd_moeda_w,
				cd_condicao_pagamento_w,
				vl_desconto_w,
				pr_desconto_w,
				ie_frete_w,
				cd_comprador_w
			from	cot_compra a,
				cot_compra_forn b
			where	a.nr_cot_compra = b.nr_cot_compra
			and	b.cd_cgc_fornecedor = cd_cgc_w
			and	a.nr_cot_compra = nr_cot_compra_w;
		end if;
	
		if (coalesce(cd_moeda_w,0) = 0) then
			CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(260559);
		end if;
		
		if (coalesce(cd_condicao_pagamento_w,0) = 0) then
			CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(260558);
		end if;
		
		if (coalesce(cd_comprador_w,'0') = '0') then
			CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(260560);
		end if;
		
		if (coalesce(cd_pessoa_solicitante_w,'0') = '0') then
			CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(260564);
		end if;
		
	
		select	nextval('ordem_compra_seq')
		into STRICT	nr_ordem_compra_w
		;

		insert into ordem_compra(
			nr_ordem_compra,
			cd_estabelecimento,
			cd_cgc_fornecedor,
			cd_condicao_pagamento,
			cd_comprador,
			dt_ordem_compra,
			dt_atualizacao,
			nm_usuario,
			cd_moeda,
			ie_situacao,
			dt_inclusao,
			cd_pessoa_solicitante,
			ie_frete,
			pr_desconto,
			cd_local_entrega,
			dt_entrega,
			ie_aviso_chegada,
			ie_emite_obs,
			ie_urgente,
			vl_desconto,
			ie_tipo_ordem,
			ds_observacao,
			nr_seq_autor_cir)
		values (	nr_ordem_compra_w,
			cd_estabelecimento_p,
			cd_cgc_w,
			cd_condicao_pagamento_w,
			cd_comprador_w,
			clock_timestamp(),
			clock_timestamp(),
			nm_usuario_p,
			cd_moeda_w,
			'A',
			clock_timestamp(),
			cd_pessoa_solicitante_w,
			coalesce(ie_frete_w,'C'),
			pr_desconto_w,
			cd_local_estoque_p,
			dt_entrega_p,
			'N',
			'N',
			'N',
			vl_desconto_w,
			'M',
			wheb_mensagem_pck.get_texto(301945,'NR_SEQ_AUTOR_P='||nr_seq_autor_p),
			nr_seq_autor_p);
		
		cd_cgc_ww := cd_cgc_w;
	end if;
	
	if (nr_ordem_compra_w > 0) then
		
		vl_item_liquido_w	:= vl_unitario_material_w * qt_material_w;
		
		SELECT * FROM define_conta_material(cd_estabelecimento_p, cd_material_w, 1, null, null, null, null, null, null, null, cd_local_estoque_p, null, clock_timestamp(), cd_conta_contabil_w, cd_centro_custo_w, null) INTO STRICT cd_conta_contabil_w, cd_centro_custo_w;
		
		select	coalesce(max(nr_item_oci),0) + 1
		into STRICT	nr_item_oci_w
		from	ordem_compra_item
		where	nr_ordem_compra = nr_ordem_compra_w;
		
		insert into ordem_compra_item(
			nr_ordem_compra,
			nr_item_oci,
			cd_material,
			cd_unidade_medida_compra,
			vl_unitario_material,
			qt_material,
			qt_original,
			dt_atualizacao,
			nm_usuario,
			ie_situacao,
			cd_local_estoque,
			nr_cot_compra,
			nr_item_cot_compra,
			vl_item_liquido,
			cd_conta_contabil,
			nr_seq_marca,
			vl_total_item,
			cd_sequencia_parametro)
		values (	nr_ordem_compra_w,
			nr_item_oci_w,
			cd_material_w,
			cd_unidade_medida_compra_w,
			vl_unitario_material_w,
			qt_material_w,
			qt_material_w,
			clock_timestamp(),
			nm_usuario_p,
			'A',
			cd_local_estoque_p,
			nr_cot_compra_w,
			nr_item_cot_compra_w,
			vl_item_liquido_w,
			cd_conta_contabil_w,
			nr_seq_marca_w,
			round((qt_material_w * vl_unitario_material_w)::numeric,4),
			philips_contabil_pck.get_parametro_conta_contabil);
			
		insert into ordem_compra_item_entrega(
			nr_sequencia,
			nr_ordem_compra,
			nr_item_oci,
			dt_prevista_entrega,
			qt_prevista_entrega,
			dt_atualizacao,
			nm_usuario)
		values (	nextval('ordem_compra_item_entrega_seq'),
			nr_ordem_compra_w,
			nr_item_oci_w,
			dt_entrega_p,
			qt_material_w,
			clock_timestamp(),
			nm_usuario_p);
		
		update	material_autor_cirurgia
		set	nr_ordem_compra = nr_ordem_compra_w
		where	nr_sequencia = nr_sequencia_w;
	
	end if;	
	end;
	
end loop;
close C01;

if (nr_ordem_compra_w = 0) then
   CALL wheb_mensagem_pck.Exibir_Mensagem_Abort(1109639);
end if;

commit;

nr_ordem_compra_p	:= nr_ordem_compra_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_ordem_compra_autor (nr_seq_autor_p bigint, dt_entrega_p timestamp, cd_local_estoque_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, nr_ordem_compra_p INOUT bigint) FROM PUBLIC;

