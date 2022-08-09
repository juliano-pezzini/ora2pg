-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE atualizar_item_aprovacao ( nr_seq_aprovacao_p bigint, nr_seq_proc_aprov_p bigint, nr_seq_solic_ordem_p bigint, nr_seq_item_p bigint, ie_tipo_item_p text, ie_acao_p text, nm_usuario_p text, qt_alteracao_p bigint, ds_justificativa_p text default null) AS $body$
DECLARE


qt_original_w			double precision;
cd_material_w			integer;
nr_seq_aprovacao_w		bigint;
nr_seq_classif_w		bigint;
nm_usuario_destino_w		varchar(50);
qt_material_atendida_w		double precision;
cd_unidade_medida_w		varchar(30);
cd_unidade_medida_estoque_w	varchar(30);
qt_conv_estoque_consumo_w	double precision;
qt_estoque_w			double precision;
cd_estabelecimento_w		smallint;
nr_sequencia_w			bigint;
qt_alteracao_w			double precision;
qt_prevista_entrega_w		double precision;
qt_baixar_w			double precision;
qt_somar_w			double precision;
ie_soma_diminui_w		varchar(1);
nr_item_solic_compra_entr_w	solic_compra_item_entrega.nr_item_solic_compra_entr%type;
ds_justificativa_w		varchar(2000);
ds_material_w			material.ds_material%type;

/*
Acao
A - Alteracao
E - Excluir */
c01 CURSOR FOR
SELECT	nr_sequencia,
	qt_prevista_entrega
from	ordem_compra_item_entrega
where	nr_ordem_compra	= nr_seq_solic_ordem_p
and	nr_item_oci	= nr_seq_item_p
and	coalesce(dt_cancelamento::text, '') = ''
order by dt_prevista_entrega desc;

c02 CURSOR FOR
SELECT	nr_item_solic_compra_entr,
	qt_entrega_solicitada
from	solic_compra_item_entrega
where	nr_solic_compra = nr_seq_solic_ordem_p
and	nr_item_solic_compra = nr_seq_item_p
order by dt_entrega_solicitada desc;



BEGIN

qt_alteracao_w		:= qt_alteracao_p;
ds_justificativa_w	:= substr(coalesce(ds_justificativa_p,''),1,2000);

select	obter_classif_comunic('F')
into STRICT	nr_seq_classif_w
;

if (ie_tipo_item_p	= 'O') then
	begin

	select	cd_material,
		nr_seq_aprovacao
	into STRICT	cd_material_w,
		nr_seq_aprovacao_w
	from	ordem_compra_item
	where	nr_ordem_compra	= nr_seq_solic_ordem_p
	and	nr_item_oci	= nr_seq_item_p;

	if (ie_acao_p = 'E') then
		begin
		
		CALL gravar_log_exclusao('ORDEM_COMPRA_ITEM',nm_usuario_p,WHEB_MENSAGEM_PCK.get_texto(297572,'NR_SEQ_SOLIC_ORDEM_P=' || nr_seq_solic_ordem_p || ';' || 'NR_SEQ_ITEM_P=' || nr_seq_item_p || ';' ||
													'CD_MATERIAL_W=' || cd_material_w || ';' || 'NR_SEQ_APROVACAO_P=' || nr_seq_aprovacao_p),'N');

		CALL comunica_excluir_item_aprov(nr_seq_solic_ordem_p,nr_seq_item_p,cd_material_w,'OC',nm_usuario_p,ds_justificativa_w);

		delete	from ordem_compra_item
		where	nr_ordem_compra	= nr_seq_solic_ordem_p
		and	nr_item_oci	= nr_seq_item_p;

		delete	from processo_aprov_compra
		where	nr_sequencia 	= nr_seq_aprovacao_w
		and	not exists (
			SELECT	nr_ordem_compra
			from	ordem_compra_item
			where	nr_seq_aprovacao	= nr_seq_aprovacao_w);

		update	processo_aprov_compra
						
		set	ds_observacao	= substr(substr(WHEB_MENSAGEM_PCK.get_texto(297574,'CD_MATERIAL_W=' || cd_material_w || ';' || 'NM_USUARIO_P=' || nm_usuario_p || ';' ||
										'DS_OBSERVACAO=' || ds_observacao),1,2000) || ds_justificativa_w,1,2000)
		where	nr_sequencia	= nr_seq_aprovacao_p
		and	nr_seq_proc_aprov	= nr_seq_proc_aprov_p;
						
		CALL inserir_historico_ordem_compra(
				nr_seq_solic_ordem_p,
				'S',
				WHEB_MENSAGEM_PCK.get_texto(297576),
				substr(WHEB_MENSAGEM_PCK.get_texto(297579,'NR_SEQ_ITEM_P=' || nr_seq_item_p || ';' ||
									'CD_MATERIAL_W=' || cd_material_w || ';' ||
									'NM_USUARIO_P=' || nm_usuario_p || ';' ||
									'DS_JUSTIFICATIVA_W=' || ds_justificativa_w),1,4000),
				nm_usuario_p);
		end;
	elsif (ie_acao_p = 'A') then
		begin
		
		select	coalesce(sum(qt_material), 0)
		into STRICT	qt_original_w
		from	ordem_compra_item
		where	nr_ordem_compra	= nr_seq_solic_ordem_p
		and	nr_item_oci	= nr_seq_item_p;

		ie_soma_diminui_w := '';
		
		if (qt_original_w > qt_alteracao_w) then
			ie_soma_diminui_w := 'D'; /*Diminui*/
			
		elsif (qt_original_w < qt_alteracao_w) then
			ie_soma_diminui_w := 'S';/*Soma*/
		
		end if;

		
		
		if (ie_soma_diminui_w in ('D','S')) then
		
			update	ordem_compra_item
			set	qt_material	= qt_alteracao_w,
				qt_original	= qt_original_w,
				nm_usuario	= nm_usuario_p,
				dt_atualizacao	= clock_timestamp(),
				vl_total_item = round((qt_alteracao_w * vl_unitario_material)::numeric,4)
			where	nr_ordem_compra	= nr_seq_solic_ordem_p
			and	nr_item_oci	= nr_seq_item_p;
			
			qt_baixar_w	:= abs(qt_alteracao_w - qt_original_w);
			qt_somar_w	:= abs(qt_alteracao_w - qt_original_w);
			
			open C01;
			loop
			fetch C01 into	
				nr_sequencia_w,
				qt_prevista_entrega_w;
			EXIT WHEN NOT FOUND; /* apply on C01 */
				begin
				
				if (ie_soma_diminui_w = 'S') then
				
					update	ordem_compra_item_entrega
					set	qt_prevista_entrega	= qt_prevista_entrega + qt_somar_w,
						nm_usuario		= nm_usuario_p,
						dt_atualizacao		= clock_timestamp()
					where	nr_sequencia		= nr_sequencia_w;
					exit;
				
				elsif (ie_soma_diminui_w = 'D') then
				

					if (qt_prevista_entrega_w < qt_baixar_w) then
						
						qt_baixar_w := qt_baixar_w - qt_prevista_entrega_w;
						
						delete from ordem_compra_item_entrega
						where nr_sequencia = nr_sequencia_w;
						
					else
						
						qt_baixar_w := qt_prevista_entrega_w - qt_baixar_w;
						
						
						update	ordem_compra_item_entrega
						set	qt_prevista_entrega	= qt_baixar_w,
							nm_usuario		= nm_usuario_p,
							dt_atualizacao		= clock_timestamp()
						where	nr_sequencia		= nr_sequencia_w;
						exit;
						
					end if;
				
				end if;
				end;
			end loop;
			close C01;		

			select	substr(obter_usuario_pessoa(cd_pessoa_solicitante) || ',' || obter_usuario_pessoa(cd_comprador),1,50) ds_usuarios_destino
			into STRICT	nm_usuario_destino_w
			from	ordem_compra
			where	nr_ordem_compra = nr_seq_solic_ordem_p;

			CALL inserir_historico_ordem_compra(
					nr_seq_solic_ordem_p,
					'S',
					WHEB_MENSAGEM_PCK.get_texto(297580),
					WHEB_MENSAGEM_PCK.get_texto(297582,'NR_SEQ_ITEM_P=' || nr_seq_item_p || ';' || 'CD_MATERIAL_W=' || cd_material_w || ';' ||
									'QT_ORIGNIAL_W=' || qt_original_w || ';' || 'QT_ALTERACAO_W=' || qt_alteracao_w || ';' ||
									'NM_USUARIO_P=' || nm_usuario_p),
					nm_usuario_p);
				
			if (nm_usuario_destino_w IS NOT NULL AND nm_usuario_destino_w::text <> '') then
				
				CALL gerar_comunic_padrao(
					clock_timestamp(),
					WHEB_MENSAGEM_PCK.get_texto(297583,'NR_SEQ_SOLIC_ORDEM_P=' || nr_seq_solic_ordem_p),
					WHEB_MENSAGEM_PCK.get_texto(297584,'NR_SEQ_ITEM_P=' || nr_seq_item_p || ';' || 'NR_SEQ_SOLIC_ORDEM_P=' || nr_seq_solic_ordem_p || ';' ||
									'CD_MATERIAL_W=' || cd_material_w ||'-'|| Obter_Desc_Material(cd_material_w) || ';' || 'QT_ORIGINAL_W=' || qt_original_w || ';' ||
									'QT_ALTERACAO_W=' || qt_alteracao_w || ';' || 'NM_USUARIO_P=' || nm_usuario_p),
					nm_usuario_p,
					'N',
					nm_usuario_destino_w,
					'N',
					nr_seq_classif_w,'','','',clock_timestamp(),'','');
			end if;		
		end if;
		end;
	end if;
				
	calcular_liquido_ordem_compra(nr_seq_solic_ordem_p, nm_usuario_p);

	/*Inclui a linha para deletar somente as condicoes diferentes de (Conforme vencimentos)*/

	delete
	from	ordem_compra_venc
	where	nr_ordem_compra = nr_seq_solic_ordem_p
	and	obter_forma_pagamento_ordem(nr_ordem_compra) <> 10;

	CALL Gerar_ordem_compra_venc(nr_seq_solic_ordem_p, nm_usuario_p);
	CALL gravar_log_processo(927, clock_timestamp(), nm_usuario_p,
			WHEB_MENSAGEM_PCK.get_texto(297585,'NR_SEQ_SOLIC_ORDEM_P=' || nr_seq_solic_ordem_p || ';' ||
						'NR_SEQ_ITEM_P=' || nr_seq_item_p || ';' || 'IE_ACAO_P=' || ie_acao_p));				
	end;
elsif (ie_tipo_item_p = 'S') then
	begin
	select	cd_material
	into STRICT	cd_material_w
	from	solic_compra_item
	where	nr_solic_compra		= nr_seq_solic_ordem_p
	and	nr_item_solic_compra	= nr_seq_item_p;

	if (ie_acao_p = 'E') then
		begin
													
		CALL gravar_log_exclusao('SOLIC_COMPRA_ITEM',nm_usuario_p,WHEB_MENSAGEM_PCK.get_texto(297587,'NR_SEQ_SOLIC_ORDEM_P=' || nr_seq_solic_ordem_p || ';' || 'NR_SEQ_ITEM_P=' || nr_seq_item_p || ';' ||
													'CD_MATERIAL_W=' || cd_material_w || ';' || 'NR_SEQ_APROVACAO_P=' || nr_seq_aprovacao_p),'N');

		CALL comunica_excluir_item_aprov(nr_seq_solic_ordem_p,nr_seq_item_p,cd_material_w,'SC',nm_usuario_p,ds_justificativa_w);

		delete	from solic_compra_item
		where	nr_solic_compra		= nr_seq_solic_ordem_p
		and	nr_item_solic_compra	= nr_seq_item_p;

		delete	from processo_aprov_compra
		where	nr_sequencia 	= nr_seq_aprovacao_w
		and	not exists (
			SELECT	nr_solic_compra
			from	solic_compra_item
			where	nr_seq_aprovacao	= nr_seq_aprovacao_w);

		update	processo_aprov_compra
		set	ds_observacao	= substr(substr(WHEB_MENSAGEM_PCK.get_texto(297588,'CD_MATERIAL_W=' || cd_material_w || ';' || 'NM_USUARIO_P=' || nm_usuario_p || ';' ||
								'DS_OBSERVACAO=' || ds_observacao),1,2000) || ds_justificativa_w,1,2000)
		where	nr_sequencia	= nr_seq_aprovacao_p
                	and	nr_seq_proc_aprov = nr_seq_proc_aprov_p;


		CALL gerar_historico_solic_compra(
				nr_seq_solic_ordem_p,
				WHEB_MENSAGEM_PCK.get_texto(297576),
				WHEB_MENSAGEM_PCK.get_texto(297579,'NR_SEQ_ITEM_P=' || nr_seq_item_p || ';' ||
									'CD_MATERIAL_W=' || cd_material_w || ';' ||
									'NM_USUARIO_P=' || nm_usuario_p || ';' ||
									'DS_JUSTIFICATIVA_W=' || ds_justificativa_w),
				'C',
				nm_usuario_p);

		end;
	elsif (ie_acao_p	= 'A') then
		begin
		
		select	coalesce(sum(qt_material), 0)
		into STRICT	qt_original_w
		from	solic_compra_item
		where	nr_solic_compra		= nr_seq_solic_ordem_p
		and	nr_item_solic_compra	= nr_seq_item_p;
		
		ie_soma_diminui_w := '';
		
		if (qt_original_w > qt_alteracao_w) then
			ie_soma_diminui_w := 'D'; /*Diminui*/
			
		elsif (qt_original_w < qt_alteracao_w) then
			ie_soma_diminui_w := 'S';/*Soma*/
		
		end if;
		
		if (ie_soma_diminui_w in ('D','S')) then
		
			update	solic_compra_item
			set	qt_material		= qt_alteracao_w,
				nm_usuario		= nm_usuario_p,
				dt_atualizacao		= clock_timestamp()
			where	nr_solic_compra		= nr_seq_solic_ordem_p
			and	nr_item_solic_compra	= nr_seq_item_p;
			
			qt_baixar_w	:= abs(qt_alteracao_w - qt_original_w);
			qt_somar_w	:= abs(qt_alteracao_w - qt_original_w);
			
			open C02;
			loop
			fetch C02 into	
				nr_item_solic_compra_entr_w,
				qt_prevista_entrega_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin
				
				if (ie_soma_diminui_w = 'S') then
				
					update	solic_compra_item_entrega
					set	qt_entrega_solicitada	= qt_prevista_entrega_w + qt_somar_w,
						nm_usuario		= nm_usuario_p,
						dt_atualizacao		= clock_timestamp()
					where	nr_solic_compra		= nr_seq_solic_ordem_p
					and	nr_item_solic_compra	= nr_seq_item_p
					and	nr_item_solic_compra_entr = nr_item_solic_compra_entr_w;
					exit;
				
				elsif (ie_soma_diminui_w = 'D') then				

					if (qt_prevista_entrega_w < qt_baixar_w) then
						
						qt_baixar_w := qt_baixar_w - qt_prevista_entrega_w;
						
						delete from solic_compra_item_entrega
						where	nr_solic_compra		= nr_seq_solic_ordem_p
						and	nr_item_solic_compra	= nr_seq_item_p
						and	nr_item_solic_compra_entr = nr_item_solic_compra_entr_w;
						
					else
						
						qt_baixar_w := qt_prevista_entrega_w - qt_baixar_w;
						
						
						update	solic_compra_item_entrega
						set	qt_entrega_solicitada	= qt_baixar_w,
							nm_usuario		= nm_usuario_p,
							dt_atualizacao		= clock_timestamp()
						where	nr_solic_compra		= nr_seq_solic_ordem_p
						and	nr_item_solic_compra	= nr_seq_item_p
						and	nr_item_solic_compra_entr = nr_item_solic_compra_entr_w;
						exit;		
					end if;				
				end if;
				end;
			end loop;
			close C02;
		

			select	obter_usuario_pessoa(cd_pessoa_solicitante)
			into STRICT	nm_usuario_destino_w
			from	solic_compra
			where	nr_solic_compra = nr_seq_solic_ordem_p;

			CALL gerar_historico_solic_compra(
					nr_seq_solic_ordem_p,
					WHEB_MENSAGEM_PCK.get_texto(297580),
					WHEB_MENSAGEM_PCK.get_texto(297582,'NR_SEQ_ITEM_P=' || nr_seq_item_p || ';' || 'CD_MATERIAL_W=' || cd_material_w || ';' ||
									'QT_ORIGNIAL_W=' || qt_original_w || ';' || 'QT_ALTERACAO_W=' || qt_alteracao_w || ';' ||
									'NM_USUARIO_P=' || nm_usuario_p),
					'C',
					nm_usuario_p);
		
			if (nm_usuario_destino_w IS NOT NULL AND nm_usuario_destino_w::text <> '') then
				
				CALL gerar_comunic_padrao(
					clock_timestamp(),
					WHEB_MENSAGEM_PCK.get_texto(297591,'NR_SEQ_SOLIC_ORDEM_P=' || nr_seq_solic_ordem_p),
					WHEB_MENSAGEM_PCK.get_texto(297593,'NR_SEQ_ITEM_P=' || nr_seq_item_p || ';' || 'NR_SEQ_SOLIC_ORDEM_P=' || nr_seq_solic_ordem_p || ';' ||
									'CD_MATERIAL_W=' || cd_material_w ||'-'|| Obter_Desc_Material(cd_material_w) || ';' ||
									'QT_ORIGINAL_W=' || qt_original_w || ';' || 'QT_ALTERACAO_W=' || qt_alteracao_w || ';' ||
									'NM_USUARIO_P=' || nm_usuario_p),
					nm_usuario_p,
					'N',
					nm_usuario_destino_w,
					'N',
					nr_seq_classif_w,'','','',clock_timestamp(),'','');
			end if;		
		end if;
		end;
	end if;


	CALL gravar_log_processo(927, clock_timestamp(), nm_usuario_p,
			WHEB_MENSAGEM_PCK.get_texto(297586,'NR_SEQ_SOLIC_ORDEM_P=' || nr_seq_solic_ordem_p || ';' ||
							'NR_SEQ_ITEM_P=' || nr_seq_item_p || ';' ||
							'IE_ACAO_P=' || ie_acao_p));		

	end;
	
elsif (ie_tipo_item_p = 'R') then
	begin
	select	cd_material
	into STRICT	cd_material_w
	from	item_requisicao_material
	where	nr_requisicao		= nr_seq_solic_ordem_p
	and		nr_sequencia		= nr_seq_item_p;

	if (ie_acao_p = 'E') then
		begin

		select 	coalesce(sum(qt_material_atendida), 0)
		into STRICT	qt_material_atendida_w
		from	item_requisicao_material
		where	nr_requisicao	= nr_seq_solic_ordem_p
		and	nr_sequencia	= nr_seq_item_p;
		
		if (qt_material_atendida_w > 0) then
			/*(-20011,'Este item ja foi atendido. Nao pode excluir.');*/

			CALL wheb_mensagem_pck.exibir_mensagem_abort(218514);
		end if;		
		
		CALL gravar_log_exclusao('ITEM_REQUISICAO_MATERIAL',nm_usuario_p,WHEB_MENSAGEM_PCK.get_texto(297594,'NR_SEQ_SOLIC_ORDEM_P=' || nr_seq_solic_ordem_p || ';' ||
														'NR_SEQ_ITEM_P=' || nr_seq_item_p || ';' ||
														'CD_MATERIAL_W=' || cd_material_w || ';' ||
														'NR_SEQ_APROVACAO_P=' || nr_seq_aprovacao_p),'N');			

		CALL comunica_excluir_item_aprov(nr_seq_solic_ordem_p,nr_seq_item_p,cd_material_w,'RM',nm_usuario_p,ds_justificativa_w);

		delete	from item_requisicao_material
		where	nr_requisicao	= nr_seq_solic_ordem_p
		and	nr_sequencia	= nr_seq_item_p;

		delete	from processo_aprov_compra
		where	nr_sequencia 	= nr_seq_aprovacao_w
		and not exists (
			SELECT	nr_requisicao
			from	item_requisicao_material
			where	nr_seq_aprovacao = nr_seq_aprovacao_w);

		update	processo_aprov_compra
		set	ds_observacao	= substr(substr(WHEB_MENSAGEM_PCK.get_texto(297595,'CD_MATERIAL_W=' || cd_material_w || ';' ||
											'NM_USUARIO_P=' || nm_usuario_p || ';' ||
											'DS_OBSERVACAO=' || ds_observacao),1,2000) || ds_justificativa_w,1,2000)
		where	nr_sequencia	= nr_seq_aprovacao_p
               	and	nr_seq_proc_aprov = nr_seq_proc_aprov_p;


		CALL gerar_historico_requisicao(
				nr_seq_solic_ordem_p,
				WHEB_MENSAGEM_PCK.get_texto(297576),
				substr(WHEB_MENSAGEM_PCK.get_texto(297579,'NR_SEQ_ITEM_P=' || nr_seq_item_p || ';' ||
									'CD_MATERIAL_W=' || cd_material_w || ';' ||
									'NM_USUARIO_P=' || nm_usuario_p || ';' ||
									'DS_JUSTIFICATIVA_W=' || ds_justificativa_w),1,4000),
				'EI',
				nm_usuario_p);		

		end;
	elsif (ie_acao_p	= 'A') then
		begin
		select 	coalesce(sum(qt_material_atendida), 0)
		into STRICT	qt_material_atendida_w
		from	item_requisicao_material
		where	nr_requisicao	= nr_seq_solic_ordem_p
		and	nr_sequencia	= nr_seq_item_p;
		
		if (qt_material_atendida_w > 0) then
			/*(-20011,'Este item ja foi atendido. Nao pode efetuar a alteracao na quantidade.');*/

			CALL wheb_mensagem_pck.exibir_mensagem_abort(218515);
		end if;
	
		select	coalesce(sum(qt_material_requisitada), 0),
			max(cd_unidade_medida),
			max(cd_estabelecimento)
		into STRICT	qt_original_w,
			cd_unidade_medida_w,
			cd_estabelecimento_w
		from	item_requisicao_material
		where	nr_requisicao	= nr_seq_solic_ordem_p
		and	nr_sequencia	= nr_seq_item_p;
		
		select	qt_conv_estoque_consumo,
			substr(obter_dados_material_estab(cd_material,cd_estabelecimento_w,'UME'),1,30) cd_unidade_medida_estoque
		into STRICT	qt_conv_estoque_consumo_w,
			cd_unidade_medida_estoque_w
		from	material
		where	cd_material = cd_material_w;
		
		if (cd_unidade_medida_estoque_w <> cd_unidade_medida_w) then			
			qt_estoque_w := round(dividir(qt_alteracao_w, qt_conv_estoque_consumo_w));
		else
			qt_estoque_w := qt_alteracao_w;
		end if;

		update	item_requisicao_material
		set	qt_material_requisitada	= qt_alteracao_w,
			qt_estoque				= coalesce(qt_estoque_w,qt_estoque),  --alteracao wmvieira 969728
			nm_usuario		= nm_usuario_p,
			dt_atualizacao		= clock_timestamp()
		where	nr_requisicao		= nr_seq_solic_ordem_p
		and	nr_sequencia		= nr_seq_item_p;	

		select	obter_usuario_pessoa(cd_pessoa_requisitante)
		into STRICT	nm_usuario_destino_w
		from	requisicao_material
		where	nr_requisicao = nr_seq_solic_ordem_p;

		CALL gerar_historico_requisicao(
				nr_seq_solic_ordem_p,
				WHEB_MENSAGEM_PCK.get_texto(297580),
				WHEB_MENSAGEM_PCK.get_texto(297582,'NR_SEQ_ITEM_P=' || nr_seq_item_p || ';' || 'CD_MATERIAL_W=' || cd_material_w || ';' ||
								'QT_ORIGNIAL_W=' || qt_original_w || ';' || 'QT_ALTERACAO_W=' || qt_alteracao_w || ';' ||
								'NM_USUARIO_P=' || nm_usuario_p),
				'AQ',
				nm_usuario_p);
		
		if (nm_usuario_destino_w IS NOT NULL AND nm_usuario_destino_w::text <> '') then
			
			CALL gerar_comunic_padrao(
				clock_timestamp(),
				WHEB_MENSAGEM_PCK.get_texto(297596,'NR_SEQ_SOLIC_ORDEM_P=' || nr_seq_solic_ordem_p),
				WHEB_MENSAGEM_PCK.get_texto(297597,'NR_SEQ_ITEM_P=' || nr_seq_item_p || ';' || 'NR_SEQ_SOLIC_ORDEM_P=' || nr_seq_solic_ordem_p || ';' ||
								'CD_MATERIAL_W=' || cd_material_w ||'-'|| Obter_Desc_Material(cd_material_w) || ';' || 'QT_ORIGNIAL_W=' || qt_original_w || ';' ||
								'QT_ALTERACAO_W=' || qt_alteracao_w || ';' || 'NM_USUARIO_P=' || nm_usuario_p),
				nm_usuario_p,
				'N',
				nm_usuario_destino_w,
				'N',
				nr_seq_classif_w,'','','',clock_timestamp(),'','');
		end if;		
		end;
	end if;

	CALL gravar_log_processo(927, clock_timestamp(), nm_usuario_p,
			WHEB_MENSAGEM_PCK.get_texto(297586,'NR_SEQ_SOLIC_ORDEM_P=' || nr_seq_solic_ordem_p || ';' ||
							'NR_SEQ_ITEM_P=' || nr_seq_item_p || ';' ||
							'IE_ACAO_P=' || ie_acao_p));				

	end;
	
elsif (ie_tipo_item_p = 'C') then
	select  cd_material,
        nr_seq_aprovacao
	into STRICT	cd_material_w,
		nr_seq_aprovacao_w
	from	cot_compra_item
	where	nr_cot_compra	    = nr_seq_solic_ordem_p
	and	    nr_item_cot_compra	= nr_seq_item_p;

	if (ie_acao_p = 'E') then
		CALL gravar_log_exclusao('COTACAO_COMPRA_ITEM', nm_usuario_p, WHEB_MENSAGEM_PCK.get_texto(297587,
						'NR_SEQ_SOLIC_ORDEM_P=' || nr_seq_solic_ordem_p || ';' || 
						'NR_SEQ_ITEM_P='        || nr_seq_item_p        || ';' ||
						'CD_MATERIAL_W='        || cd_material_w        || ';' || 
						'NR_SEQ_APROVACAO_P='   || nr_seq_aprovacao_p), 'N');
		CALL comunica_excluir_item_aprov(nr_seq_solic_ordem_p,nr_seq_item_p,cd_material_w,'CC',nm_usuario_p,ds_justificativa_w);

		delete	
        from 	cot_compra_item
		where	nr_cot_compra		= nr_seq_solic_ordem_p
		and		nr_item_cot_compra	= nr_seq_item_p;

		delete	
        from 	processo_aprov_compra
		where	nr_sequencia = nr_seq_aprovacao_p
		and	not exists (
			SELECT	Nr_Cot_Compra
            from	Cot_Compra_Item
            where	nr_seq_aprovacao = nr_seq_aprovacao_p);

		update	processo_aprov_compra
		set	ds_observacao	= substr(substr(WHEB_MENSAGEM_PCK.get_texto(1047502,'CD_MATERIAL_W=' || cd_material_w || ';' || 'NM_USUARIO_P=' || nm_usuario_p || ';' ||
								'DS_OBSERVACAO=' || ds_observacao),1,2000) || ds_justificativa_w,1,2000)
		where	nr_sequencia		= nr_seq_aprovacao_p
		and		nr_seq_proc_aprov 	= nr_seq_proc_aprov_p;


		CALL gerar_historico_cotacao(
				nr_seq_solic_ordem_p,
				WHEB_MENSAGEM_PCK.get_texto(297576),
				WHEB_MENSAGEM_PCK.get_texto(297579,'NR_SEQ_ITEM_P=' || nr_seq_item_p || ';' ||
									'CD_MATERIAL_W=' || cd_material_w || ';' ||
									'NM_USUARIO_P=' || nm_usuario_p || ';' ||
									'DS_JUSTIFICATIVA_W=' || ds_justificativa_w),
				'C',
				nm_usuario_p);
	end if;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE atualizar_item_aprovacao ( nr_seq_aprovacao_p bigint, nr_seq_proc_aprov_p bigint, nr_seq_solic_ordem_p bigint, nr_seq_item_p bigint, ie_tipo_item_p text, ie_acao_p text, nm_usuario_p text, qt_alteracao_p bigint, ds_justificativa_p text default null) FROM PUBLIC;
