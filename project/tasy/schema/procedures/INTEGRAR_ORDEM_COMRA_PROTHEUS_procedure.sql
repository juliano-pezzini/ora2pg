-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE integrar_ordem_comra_protheus (nr_seq_pedido_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_estabelecimento_w	bigint;	
nr_solic_compra_w	bigint;	
cd_fornecedor_w		varchar(10);
cd_cnpj_w		varchar(14);
ds_contato_w		varchar(30);
ds_observacao_w		varchar(255);
dt_emissao_w		timestamp;
nr_pedido_w		varchar(10);
tp_frete_w		varchar(1);
cd_comprador_w		varchar(10);
cd_condicao_pagamento_w	bigint;
cd_moeda_padrao_w	bigint;
cd_pessoa_solicitante_w	varchar(10);
nr_ordem_compra_w	bigint;
cd_cgc_fornecedor_w	varchar(14);
cd_produto_w		varchar(15);
cd_unidade_medida_imp_w	varchar(2);
dt_entrega_w		timestamp;
nr_item_w		bigint;
qt_item_w		double precision;
vl_unitario_w		double precision;
vl_total_item_w		double precision;
cd_unidade_medida_w	varchar(30);
cd_material_w		bigint;
dt_prevista_entrega_w	timestamp;
cd_local_estoque_w	bigint;
cd_centro_custo_w	integer;
cd_conta_contabil_w	varchar(20);
ie_erro_w		varchar(1) := 'N';
qt_existe_w		bigint;
nr_solicitacao_w	bigint;
nr_solicitacao_item_w	bigint;
nr_solicitacao_tasy_w	bigint;
ie_operacao_w		varchar(1);
ds_erro_w		varchar(4000);


c01 CURSOR FOR
SELECT	cd_produto,
	cd_unidade_medida,
	dt_entrega,
	(nr_item)::numeric  nr_item,
	to_number(qt_item, '99999999999D9999', 'NLS_NUMERIC_CHARACTERS=''.,''') qt_item,
	to_number(vl_unitario, '999999999D9999', 'NLS_NUMERIC_CHARACTERS=''.,''') vl_unitario,
	(nr_solicitacao)::numeric  nr_solicitacao,
	(nr_solicitacao_item)::numeric  nr_solicitacao_item,
	(nr_solicitacao_tasy)::numeric  nr_solicitacao_tasy
from	w_protheus_pedido_item
where	nr_seq_pedido	= nr_seq_pedido_p
order by nr_item;


BEGIN

cd_estabelecimento_w	:= cd_estabelecimento_p;

select	max(nr_solicitacao_tasy)
into STRICT	nr_solic_compra_w
from	w_protheus_pedido_item
where	nr_seq_pedido = nr_seq_pedido_p;

if (nr_solic_compra_w > 0) then
	select	cd_estabelecimento
	into STRICT	cd_estabelecimento_w
	from	solic_compra
	where	nr_solic_compra = nr_solic_compra_w;
end if;

if (coalesce(nr_seq_pedido_p,0) > 0) then

	select	cd_fornecedor,
		cd_cnpj,
		ds_contato,
		ds_observacao,
		dt_emissao,
		nr_pedido,
		tp_frete,
		ie_operacao
	into STRICT	cd_fornecedor_w,
		cd_cnpj_w,
		ds_contato_w,
		ds_observacao_w,
		dt_emissao_w,
		nr_pedido_w,
		tp_frete_w,
		ie_operacao_w
	from	w_protheus_pedido
	where	nr_sequencia	= nr_seq_pedido_p;
	
	if (ie_operacao_w = 'I') then
	
	
		if (coalesce(cd_fornecedor_w::text, '') = '') then
			CALL gravar_log_protheus('ERRO', 'OC', Wheb_mensagem_pck.get_Texto(303078), nm_usuario_p);
								/*'O Fornecedor da ordem de compra recebida do Protheus esta vazio.'*/

			ie_erro_w := 'S';
		end if;
	
		select	max(cd_comprador_padrao),
			max(cd_condicao_pagamento_padrao),
			max(cd_moeda_padrao),
			max(cd_pessoa_solic_padrao),
			max(cd_local_estoque_padrao)
		into STRICT	cd_comprador_w,
			cd_condicao_pagamento_w,
			cd_moeda_padrao_w,
			cd_pessoa_solicitante_w,
			cd_local_estoque_w
		from	parametro_compras
		where	cd_estabelecimento	= cd_estabelecimento_w;
	
		if (coalesce(cd_comprador_w::text, '') = '') then
			CALL gravar_log_protheus('ERRO', 'OC', Wheb_mensagem_pck.get_Texto(303079) , nm_usuario_p);
							/*'Deve ser informado o comprador padrao nos parametros de compras.'*/

			ie_erro_w := 'S';
		end if;
	
		if (coalesce(cd_condicao_pagamento_w::text, '') = '') then
			CALL gravar_log_protheus('ERRO', 'OC', Wheb_mensagem_pck.get_Texto(303080) , nm_usuario_p);
							/*'Deve ser informado a condicao de pagamento padrao nos parametros de compras.'*/

			ie_erro_w := 'S';
		end if;
		
		if (coalesce(cd_moeda_padrao_w::text, '') = '') then
			CALL gravar_log_protheus('ERRO', 'OC', Wheb_mensagem_pck.get_Texto(303081) , nm_usuario_p);
							/*'Deve ser informado a moeda padrao nos parametros de compras.'*/

			ie_erro_w := 'S';
		end if;
	
		if (coalesce(cd_pessoa_solicitante_w::text, '') = '') then
			CALL gravar_log_protheus('ERRO', 'OC', Wheb_mensagem_pck.get_Texto(303082) , nm_usuario_p);
							/*'Deve ser informado a pessoa solicitante padrao nos parametros de compras.'*/

			ie_erro_w := 'S';
		end if;
	
		if (coalesce(cd_local_estoque_w::text, '') = '') then
			CALL gravar_log_protheus('ERRO', 'OC', Wheb_mensagem_pck.get_Texto(303083) , nm_usuario_p);
							/*Deve ser informado o local de estoque padrao nos parametros de compras.*/

			ie_erro_w := 'S';
		end if;	

		select	max(cd_cgc)
		into STRICT	cd_cgc_fornecedor_w
		from	pessoa_juridica
		where	cd_sistema_ant		= cd_fornecedor_w
		and	coalesce(ie_situacao,'A') 	= 'A';
	
		if (coalesce(cd_cgc_fornecedor_w::text, '') = '') then
		
			select	max(cd_cgc)
			into STRICT	cd_cgc_fornecedor_w
			from	pessoa_juridica
			where	cd_cgc = cd_cnpj_w
			and	coalesce(ie_situacao,'A') 	= 'A';
			
			if (coalesce(cd_cgc_fornecedor_w::text, '') = '') then
				CALL gravar_log_protheus('ERRO', 'OC', Wheb_mensagem_pck.get_Texto(303085, 'CD_CNPJ_W='|| CD_CNPJ_W) , nm_usuario_p);
								/*'Nao existe o cadastro do CNPJ ' || CD_CNPJ_W || ' no Tasy.'*/

								
				ie_erro_w := 'S';
			end if;
		end if;	
	
		if (ie_erro_w = 'N') then

			select	nextval('ordem_compra_seq')
			into STRICT	nr_ordem_compra_w
			;

			insert	into ordem_compra(cd_comprador,
				cd_condicao_pagamento,
				cd_estabelecimento,
				cd_cgc_fornecedor,
				cd_moeda,
				cd_pessoa_solicitante,
				ds_observacao,
				ds_pessoa_contato,
				dt_atualizacao,
				dt_entrega,
				dt_inclusao,
				dt_ordem_compra,
				ie_aviso_chegada,
				ie_emite_obs,
				ie_frete,
				ie_situacao,
				ie_somente_pagto,
				ie_urgente,
				nm_usuario,
				nr_ordem_compra,
				vl_desconto,
				vl_despesa_acessoria,
				vl_despesa_doc,
				vl_frete,
				vl_seguro,
				nr_documento_externo,
				dt_liberacao,
				dt_aprovacao,
				nm_usuario_lib)
			values (cd_comprador_w,
				cd_condicao_pagamento_w,
				cd_estabelecimento_w,
				cd_cgc_fornecedor_w,
				cd_moeda_padrao_w,
				cd_pessoa_solicitante_w,
				ds_observacao_w,
				ds_contato_w,
				clock_timestamp(),
				clock_timestamp(),
				coalesce(dt_emissao_w,clock_timestamp()),
				clock_timestamp(),
				'N',
				'S',
				tp_frete_w,
				'A',
				'N',
				'N',
				nm_usuario_p,
				nr_ordem_compra_w,
				0,
				0,
				0,
				0,
				0,
				nr_pedido_w,
				clock_timestamp(),
				clock_timestamp(),
				nm_usuario_p);
			
			open C01;
			loop
			fetch C01 into	
				cd_produto_w,
				cd_unidade_medida_imp_w,
				dt_entrega_w,
				nr_item_w,
				qt_item_w,
				vl_unitario_w,
				nr_solicitacao_w,
				nr_solicitacao_item_w,
				nr_solicitacao_tasy_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin
				
				select	max(cd_material)
				into STRICT	cd_material_w
				from	material
				where	cd_sistema_ant		= cd_produto_w
				and	coalesce(ie_situacao,'A')	= 'A';
				
				if (coalesce(cd_material_w::text, '') = '') then
					CALL gravar_log_protheus('ERRO', 'OC',Wheb_mensagem_pck.get_Texto(303087, 'CD_PRODUTO_W='|| CD_PRODUTO_W), nm_usuario_p);
									/*'Nao existe o cadastro do produto ' || CD_PRODUTO_W || ' no Tasy.'*/

									
					ie_erro_w := 'S';
				end if;	
				
				select	max(cd_unidade_medida)
				into STRICT	cd_unidade_medida_w
				from	unidade_medida
				where	cd_sistema_ant	= cd_unidade_medida_imp_w;
				
				if (coalesce(cd_unidade_medida_w::text, '') = '') then
					CALL gravar_log_protheus('ERRO', 'OC',Wheb_mensagem_pck.get_Texto(303088, 'CD_UNIDADE_MEDIDA_IMP_W='|| CD_UNIDADE_MEDIDA_IMP_W) , nm_usuario_p);
									/*'Nao existe o cadastro da unidade de medida ' || cd_unidade_medida_imp_w || ' no Tasy.'*/
									
					ie_erro_w := 'S';
				end if;	
				
				if (ie_erro_w = 'N') then

					vl_total_item_w	:= coalesce(vl_unitario_w,0) * coalesce(qt_item_w,0);
				
					SELECT * FROM define_conta_material(	cd_estabelecimento_w, cd_material_w, 2, null, null, null, null, null, null, null, cd_local_estoque_w, null, clock_timestamp(), cd_conta_contabil_w, cd_centro_custo_w, null) INTO STRICT cd_conta_contabil_w, cd_centro_custo_w;
					
					insert into ordem_compra_item(cd_centro_custo,
						cd_conta_contabil,
						cd_local_estoque,
						cd_material,			
						cd_pessoa_solicitante,			
						cd_unidade_medida_compra,
						dt_atualizacao,
						ie_situacao,
						nm_usuario,
						nr_item_oci,
						nr_ordem_compra,
						qt_material,
						qt_original,
						vl_unitario_material,
						vl_desconto,
						vl_dif_ultima_compra,
						vl_item_liquido,
						vl_total_item,
						vl_ultima_compra,
						vl_unit_mat_original,
						dt_aprovacao,
						dt_aprovacao_orig,
						nm_usuario_lib,
						cd_sequencia_parametro)
					values (cd_centro_custo_w,
						cd_conta_contabil_w,
						cd_local_estoque_w,
						cd_material_w,			
						cd_pessoa_solicitante_w,
						cd_unidade_medida_w,
						clock_timestamp(),
						'A',
						nm_usuario_p,
						nr_item_w,
						nr_ordem_compra_w,
						qt_item_w,
						qt_item_w,
						vl_unitario_w,
						0,
						0,
						vl_total_item_w,
						vl_total_item_w,
						0,
						vl_unitario_w,
						clock_timestamp(),
						clock_timestamp(),
						nm_usuario_p,
						philips_contabil_pck.get_parametro_conta_contabil);
					
					
					begin
						update	ordem_compra_item
						set	nr_solic_compra = nr_solicitacao_tasy_w,
							nr_item_solic_compra = nr_solicitacao_item_w
						where	nr_ordem_compra = nr_ordem_compra_w
						and	nr_item_oci = nr_item_w;
					exception
					when others then
						nr_solicitacao_w := nr_solicitacao_w;
					end;

					insert	into ordem_compra_item_entrega(dt_atualizacao,
						dt_prevista_entrega,
						nm_usuario,
						nr_item_oci,
						nr_ordem_compra,
						nr_sequencia,
						qt_prevista_entrega)
					values (clock_timestamp(),
						dt_entrega_w,
						nm_usuario_p,
						nr_item_w,
						nr_ordem_compra_w,
						nextval('ordem_compra_item_entrega_seq'),
						qt_item_w);
				end if;
				
				end;
			end loop;
			close C01;
	
			select	min(dt_prevista_entrega)
			into STRICT	dt_prevista_entrega_w
			from	ordem_compra_item_entrega
			where	nr_ordem_compra	= nr_ordem_compra_w;
			
			update	ordem_compra
			set	dt_entrega	= coalesce(dt_prevista_entrega_w,dt_entrega)
			where	nr_ordem_compra	= nr_ordem_compra_w;
		end if;
	
		select	count(*)
		into STRICT	qt_existe_w
		from	ordem_compra_item
		where	nr_ordem_compra = nr_ordem_compra_w;
		
		if (qt_existe_w > 0) then
			CALL gerar_ordem_compra_venc(nr_ordem_compra_w,nm_usuario_p);
		else
			delete from ordem_compra where nr_ordem_compra = nr_ordem_compra_w;
		end if;
	end if;
	
	if (ie_operacao_w = 'E') then
		
		select	coalesce(max(nr_ordem_compra),0)
		into STRICT	nr_ordem_compra_w
		from	ordem_compra
		where	nr_documento_externo = nr_pedido_w;
		
		if (nr_ordem_compra_w > 0) then
		
			select	count(*)
			into STRICT	qt_existe_w
			from	nota_fiscal a,
				nota_fiscal_item b
			where	a.nr_sequencia = b.nr_sequencia
			and	a.ie_situacao = '1'
			and	b.nr_ordem_compra = nr_ordem_compra_w;
			
			if (qt_existe_w > 0) then
				CALL gravar_log_protheus('ERRO', 'OC',Wheb_mensagem_pck.get_Texto(303090, 'NR_ORDEM_COMPRA_W='|| NR_ORDEM_COMPRA_W), nm_usuario_p);
								/*A ordem de compra numero #@NR_ORDEM_COMPRA_W#@ nao pode ser excluida, pois ja possui nota fiscal.*/

								
				ie_erro_w := 'S';
			end if;			
			
			if (ie_erro_w = 'N') then
		
				update	nota_fiscal_item
				set	nr_ordem_compra  = NULL,
					nr_item_oci  = NULL
				where	nr_ordem_compra = nr_ordem_compra_w;
		
				update	nota_fiscal
				set	nr_ordem_compra  = NULL
				where	nr_ordem_compra = nr_ordem_compra_w;
			
				begin
				delete from ordem_compra where nr_ordem_compra = nr_ordem_compra_w;
				exception
				when others then
					ds_erro_w := substr(sqlerrm,1,4000);
					CALL gravar_log_protheus('ERRO', 'OC',substr(WHEB_MENSAGEM_PCK.get_texto(303092,'NR_ORDEM_COMPRA_W='|| nr_ordem_compra_w ||';DS_ERRO_W='|| ds_erro_w),1,4000) , nm_usuario_p);
					/*'Ocorreu o seguinte erro ao excluir a ordem de compra numero ' || nr_ordem_compra_w || chr(13) || chr(10) || ds_erro_w */
					
					ie_erro_w := 'S';
				end;				
				
			end if;			
		end if;	
	end if;

end if;

delete from w_protheus_pedido
where nr_sequencia = nr_seq_pedido_p;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE integrar_ordem_comra_protheus (nr_seq_pedido_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
