-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_cotacao_mat_fornec ( nr_cot_compra_p bigint, ie_escolhe_fornec_p text, cd_cnpj_p text, dt_documento_p timestamp, ie_frete_p text, cd_moeda_p bigint, cd_condicao_pag_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


cd_material_w				integer;
cd_material_ww				integer;
cd_grupo_material_w			smallint;
cd_subgrupo_w				smallint;
cd_classe_material_w			integer;
cd_cgc_fornecedor_w			varchar(14);
cd_moeda_w				bigint;
cd_condicao_pagto_w			bigint;
qt_dia_prazo_entrega_w			smallint;
nr_seq_cot_fornecedor_w			bigint;
nr_sequencia_item_w			bigint;
nr_item_cot_compra_w			bigint;
qt_material_w				double precision;
cd_condicao_pagamento_padrao_w		bigint;
qt_conv_compra_estoque_w		double precision;
qt_convertido_w				double precision;
ie_desdobra_mat_cotacao_w		varchar(1);
ie_desdobra_mat_estoque_w		varchar(1);
vl_preco_w				double precision;
qt_existe_w				bigint;
ie_gera_todos_itens_w			varchar(1);
ds_material_direto_ww			varchar(255);
ie_gerar_marca_w			varchar(1);
nr_solic_compra_w			bigint;
nr_item_solic_compra_w			integer;
ds_marca_w				varchar(30);
nr_seq_cot_item_forn_w			bigint;
vl_total_w				double precision;
cd_tributo_w				bigint;
vl_tributo_w				double precision;
pr_tributo_w				double precision;
ie_trib_regra_preco_pj_w		varchar(1);
ds_fornecedor_w				varchar(100);
ie_regra_preco_w			cot_compra_item.ie_regra_preco%type;
cd_unidade_medida_cotada_w		unidade_medida.cd_unidade_medida%type;
cd_unidade_medida_compra_w		unidade_medida.cd_unidade_medida%type;
cd_convenio_w				regra_material_cotacao.cd_convenio%type;
cd_categoria_w				regra_material_cotacao.cd_categoria%type;
vl_preco_venda_w			cot_compra_forn_item.vl_preco%type;
cd_paciente_cotacao_w			cot_compra_item.cd_paciente_cotacao%type;

C00 CURSOR FOR
SELECT	cd_material,
	nr_item_cot_compra,
	qt_material,
	ds_material_direto_w,
	nr_solic_compra,
	nr_item_solic_compra,
	cd_unidade_medida_compra,
	ie_regra_preco,
	cd_paciente_cotacao
from	cot_compra_item
where	nr_cot_compra	= nr_cot_compra_p
and	coalesce(ie_situacao,'A')	= 'A';

C01 CURSOR FOR
SELECT	cd_cgc_fornecedor,
	coalesce(obter_preco_vigente_mat_forn(cd_cgc_fornecedor,cd_material_w,cd_estabelecimento_p),0)
from	regra_cotacao_mat_fornec
where	coalesce(cd_grupo_material, cd_grupo_material_w)	= cd_grupo_material_w
and	coalesce(cd_subgrupo_material, cd_subgrupo_w)	= cd_subgrupo_w
and	coalesce(cd_classe_material, cd_classe_material_w)	= cd_classe_material_w
and	coalesce(cd_material, cd_material_w)		= cd_material_w
and	substr(obter_dados_pf_pj(null,cd_cgc_fornecedor,'S'),1,1) = 'A'
and	coalesce(ie_gerar,'S') = 'S'
and	((ie_escolhe_fornec_p = 'N') or
	(ie_escolhe_fornec_p = 'S' AND cd_cgc_fornecedor = cd_cnpj_p))
and	((coalesce(cd_estabelecimento::text, '') = '') or
	(cd_estabelecimento IS NOT NULL AND cd_estabelecimento::text <> '' AND cd_estabelecimento = cd_estabelecimento_p))
order by
	coalesce(cd_grupo_material, 0),
	coalesce(cd_subgrupo_material, 0),
	coalesce(cd_classe_material, 0),
	coalesce(cd_material, 0);

C02 CURSOR FOR
SELECT	a.cd_material,
	coalesce(obter_preco_vigente_mat_forn(cd_cgc_fornecedor_w,a.cd_material,cd_estabelecimento_p),0),
	a.cd_unidade_medida_compra
from	material a
where	cd_material_estoque = cd_material_w
and (coalesce(Obter_se_mat_ressuprimento(cd_estabelecimento_p, a.cd_material),'S') = 'S')
and (coalesce(obter_se_material_padronizado(cd_estabelecimento_p, a.cd_material),'S') = 'S')
and	a.ie_situacao   	= 'A'
and	ie_desdobra_mat_cotacao_w in ('S','F')
and	(((cd_material_estoque <> a.cd_material and obter_qt_mesmo_mat_estoque(a.cd_material_estoque) > 1) or (obter_qt_mesmo_mat_estoque(a.cd_material_estoque) = 1)) or (ie_desdobra_mat_estoque_w = 'S'));
		
c03 CURSOR FOR
SELECT	b.cd_tributo,
	b.vl_tributo,
	b.pr_tributo
from	preco_pj a,
	preco_pj_tributo b
where	a.nr_Sequencia = b.nr_seq_regra
and	a.cd_cgc = cd_cgc_fornecedor_w
and	a.cd_material = cd_material_w
and	((coalesce(dt_vigencia::text, '') = '') or (trunc(dt_vigencia,'dd') <= trunc(clock_timestamp(),'dd')))
and	((coalesce(dt_vigencia_fim::text, '') = '') or (trunc(dt_vigencia_fim,'dd') >= trunc(clock_timestamp(),'dd')))
and	((b.vl_tributo > 0) or (b.pr_tributo > 0))
and	ie_trib_regra_preco_pj_w = 'S'
and	((coalesce(a.cd_estabelecimento::text, '') = '') or
	(a.cd_estabelecimento IS NOT NULL AND a.cd_estabelecimento::text <> '' AND a.cd_estabelecimento = cd_estabelecimento_p));


BEGIN
begin
select	max(coalesce(cd_moeda_padrao,cd_moeda_p)),
	coalesce(max(cd_condicao_pagamento_padrao),30),
	coalesce(max(ie_desdobra_mat_cotacao),'N'),
	coalesce(max(ie_desdobra_mat_estoque),'N'),
	coalesce(max(ie_gerar_marca_cotacao),'N'),
	coalesce(max(ie_trib_regra_preco_pj),'N')
into STRICT	cd_moeda_w,
	cd_condicao_pagamento_padrao_w,
	ie_desdobra_mat_cotacao_w,
	ie_desdobra_mat_estoque_w,
	ie_gerar_marca_w,
	ie_trib_regra_preco_pj_w
from	parametro_compras
where	cd_estabelecimento = cd_estabelecimento_p;
exception
when no_data_found then
	--(-20011,'Informar a moeda padrao no parametro compras');
	CALL WHEB_MENSAGEM_PCK.exibir_mensagem_abort(211233);
end;

if (coalesce(cd_moeda_p,0) = 0) and (coalesce(cd_moeda_w,0) = 0) then
	--(-20011,'Necessario informar a moeda, para que se possa Gerar itens pela regra do fornecedor');
	CALL WHEB_MENSAGEM_PCK.exibir_mensagem_abort(211235);
end if;

select (max(Obter_Valor_Param_Usuario(915, 83, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p)))
into STRICT	ie_gera_todos_itens_w
;

open	c00;
loop
fetch	c00 into
	cd_material_w,
	nr_item_cot_compra_w,
	qt_material_w,
	ds_material_direto_ww,
	nr_solic_compra_w,
	nr_item_solic_compra_w,
	cd_unidade_medida_cotada_w,
	ie_regra_preco_w,
	cd_paciente_cotacao_w;
EXIT WHEN NOT FOUND; /* apply on c00 */
	begin
	select	cd_grupo_material,
		cd_subgrupo_material,
		cd_classe_material
	into STRICT	cd_grupo_material_w,
		cd_subgrupo_w,
		cd_classe_material_w
	from	estrutura_material_v
	where 	cd_material	= cd_material_w;

	if (ie_gerar_marca_w = 'S') and (nr_solic_compra_w > 0) and (nr_item_solic_compra_w > 0) then
		
		select	substr(obter_desc_material_marca(nr_seq_marca,cd_material),1,30)
		into STRICT	ds_marca_w
		from	solic_compra_item
		where	nr_solic_compra = nr_solic_compra_w
		and	nr_item_solic_compra = nr_item_solic_compra_w;
	end if;
	
	open	c01;
	loop
	fetch	c01 into
		cd_cgc_fornecedor_w,
		vl_preco_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin
		begin
		select	coalesce(cd_cond_pagto, cd_condicao_pagamento_padrao_w),
			coalesce(qt_dia_prazo_entrega, 0)
		into STRICT	cd_condicao_pagto_w,
			qt_dia_prazo_entrega_w
		from	pessoa_juridica_estab
		where	cd_cgc = cd_cgc_fornecedor_w
		and	cd_estabelecimento = cd_estabelecimento_p;
		exception
			when no_data_found then
			
			ds_fornecedor_w := substr(obter_nome_pf_pj(null,cd_cgc_fornecedor_w),1,100);
			CALL wheb_mensagem_pck.exibir_mensagem_abort(230322,'CD_CGC_FORNECEDOR_W='	|| cd_cgc_fornecedor_w ||
									';DS_FORNECEDOR_W='	|| ds_fornecedor_w);
		end;
		
			

		if (coalesce(cd_condicao_pag_p,0) <> 0) then
			cd_condicao_pagto_w := cd_condicao_pag_p;
		end if;

		if (coalesce(cd_moeda_p,0) <> 0) then
			cd_moeda_w := cd_moeda_p;
		end if;

		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_cot_fornecedor_w
		from	cot_compra_forn
		where	nr_cot_compra	= nr_cot_compra_p
		and	cd_cgc_fornecedor	= cd_cgc_fornecedor_w;

		if (nr_seq_cot_fornecedor_w = 0) then
			select	nextval('cot_compra_forn_seq')
			into STRICT	nr_seq_cot_fornecedor_w
			;

			insert	into cot_compra_forn(
				nr_sequencia,
				nr_cot_compra,
				cd_cgc_fornecedor,
				dt_atualizacao,
				nm_usuario,
				cd_moeda,
				cd_condicao_pagamento,
				ie_frete,
				dt_documento,
				ie_liberada_internet,
				ie_status_envio_email_lib)
			values (	nr_seq_cot_fornecedor_w,
				nr_cot_compra_p,
				cd_cgc_fornecedor_w,
				clock_timestamp(),
				nm_usuario_p,
				cd_moeda_w,
				cd_condicao_pagto_w,
				coalesce(ie_frete_p,'N'),
				coalesce(dt_documento_p,''),
				'N',
				'N');
		end if;
		
		select	count(*)
		into STRICT	qt_existe_w
		from	material a
		where	a.cd_material_estoque = cd_material_w
		and (coalesce(Obter_se_mat_ressuprimento(cd_estabelecimento_p, a.cd_material),'S') = 'S')
		and (coalesce(obter_se_material_padronizado(cd_estabelecimento_p, a.cd_material),'S') = 'S')
		and	a.ie_situacao   	= 'A'
		and	ie_desdobra_mat_cotacao_w in ('S','F')
		and	(((a.cd_material_estoque <> a.cd_material and obter_qt_mesmo_mat_estoque(a.cd_material_estoque) >1) or (obter_qt_mesmo_mat_estoque(a.cd_material_estoque) = 1)) or (ie_desdobra_mat_estoque_w = 'S'));

		
		select	max(cd_convenio),
			max(cd_categoria)
		into STRICT	cd_convenio_w,
			cd_categoria_w
		from	regra_material_cotacao
		where	cd_material = cd_material_w
		and	cd_estabelecimento = cd_estabelecimento_p;
		
			
		/*Se nao desdobra ou desdobra so nos itens*/

		if (ie_desdobra_mat_cotacao_w in ('N','I')) or (qt_existe_w = 0) then

			select	count(*)
			into STRICT	qt_existe_w
			from	cot_compra_forn_item a
			where	a.nr_cot_compra	= nr_cot_compra_p
			and	a.nr_seq_cot_forn	= nr_seq_cot_fornecedor_w
			and	a.nr_item_cot_compra	= nr_item_cot_compra_w
			and	a.cd_material		= cd_material_w;

			if (qt_existe_w = 0) then
			
				vl_preco_venda_w := 0;
				select	obter_preco_venda_cot_compra(cd_estabelecimento_p,cd_material_w,ie_regra_preco_w,cd_convenio_w,cd_categoria_w,cd_unidade_medida_cotada_w)
				into STRICT	vl_preco_venda_w
				;
			
				select	nextval('cot_compra_forn_item_seq')
				into STRICT	nr_seq_cot_item_forn_w
				;

				insert into cot_compra_forn_item(
					nr_sequencia,
					nr_seq_cot_forn,
					nr_cot_compra,
					nr_item_cot_compra,
					cd_cgc_fornecedor,
					qt_material,
					qt_prioridade,
					cd_material,
					vl_unitario_material,
					dt_atualizacao,
					nm_usuario,
					vl_preco_liquido,
					vl_total_liquido_item,
					ie_situacao,
					ds_material_direto,
					ds_marca,
					vl_preco,
					cd_paciente_forn_item)
				values (	nr_seq_cot_item_forn_w,
					nr_seq_cot_fornecedor_w,
					nr_cot_compra_p,
					nr_item_cot_compra_w,
					cd_cgc_fornecedor_w,
					qt_material_w,
					100,
					cd_material_w,
					vl_preco_w,
					clock_timestamp(),
					nm_usuario_p,
					0,
					0,
					'A',
					ds_material_direto_ww,
					CASE WHEN ie_gerar_marca_w='S' THEN coalesce(ds_marca_w, substr(obter_marca_material_estab(cd_estabelecimento_p, cd_material_w,'D'),1,30))  ELSE '' END ,
					vl_preco_venda_w,
					cd_paciente_cotacao_w);

				vl_total_w := qt_material_w * vl_preco_w;

				open C03;
				loop
				fetch C03 into	
					cd_tributo_w,
					vl_tributo_w,
					pr_tributo_w;
				EXIT WHEN NOT FOUND; /* apply on C03 */
					begin

					if (vl_tributo_w > 0) then
						pr_tributo_w	:= dividir(vl_tributo_w * 100, vl_total_w);
					else
						vl_tributo_w	:= dividir((vl_total_w * pr_tributo_w), 100);
					end if;
					
					select	count(*)
					into STRICT	qt_existe_w
					from	cot_compra_forn_item_tr
					where	nr_seq_cot_item_forn = nr_seq_cot_item_forn_w
					and	cd_tributo = cd_tributo_w;
					
					if (qt_existe_w = 0) then

						insert into cot_compra_forn_item_tr(
							nr_cot_compra,
							nr_item_cot_compra,
							cd_cgc_fornecedor,
							cd_tributo,
							pr_tributo,
							vl_tributo,
							dt_atualizacao,
							nm_usuario,
							ds_observacao,
							nr_sequencia,
							nr_seq_cot_item_forn,
							dt_atualizacao_nrec,
							nm_usuario_nrec)
						values (	nr_cot_compra_p,
							nr_item_cot_compra_w,
							cd_cgc_fornecedor_w,
							cd_tributo_w,
							pr_tributo_w,
							vl_tributo_w,
							clock_timestamp(),
							nm_usuario_p,
							null,
							nextval('cot_compra_forn_item_tr_seq'),
							nr_seq_cot_item_forn_w,
							clock_timestamp(),
							nm_usuario_p);
					else
						
						update	cot_compra_forn_item_tr
						set	pr_tributo		= pr_tributo_w,
							vl_tributo		= vl_tributo_w,
							dt_atualizacao		= clock_timestamp(),
							nm_usuario		= nm_usuario_p
						where	nr_seq_cot_item_forn 	= nr_seq_cot_item_forn_w
						and	cd_tributo 		= cd_tributo_w;
					end if;
					end;
				end loop;
				close C03;
			end if;
		else
			begin
			open c02;
			loop
			fetch c02 into
				cd_material_ww,
				vl_preco_w,
				cd_unidade_medida_compra_w;
			EXIT WHEN NOT FOUND; /* apply on c02 */
				begin
				
				if (cd_unidade_medida_compra_w <> cd_unidade_medida_cotada_w) then
				
					select	qt_conv_compra_estoque
					into STRICT	qt_conv_compra_estoque_w
					from	material
					where	cd_material = cd_material_ww;

					select	round(CASE WHEN(round(dividir(qt_material_w, 								qt_conv_compra_estoque_w))) * qt_conv_compra_estoque_w=0 THEN (round((dividir(qt_material_w,								qt_conv_compra_estoque_w))::numeric,4)) * qt_conv_compra_estoque_w  ELSE (round(dividir(qt_material_w, 								qt_conv_compra_estoque_w))) * qt_conv_compra_estoque_w END )
					into STRICT	qt_convertido_w
					;
				else
					qt_convertido_w := qt_material_w;
				end if;

				select	count(*)
				into STRICT	qt_existe_w
				from	cot_compra_forn_item a
				where	a.nr_cot_compra	= nr_cot_compra_p
				and	a.nr_seq_cot_forn	= nr_seq_cot_fornecedor_w
				and	a.nr_item_cot_compra	= nr_item_cot_compra_w
				and	a.cd_material		= cd_material_ww;

				if (qt_existe_w = 0) then
				
					vl_preco_venda_w := 0;
					select	obter_preco_venda_cot_compra(cd_estabelecimento_p,cd_material_ww,ie_regra_preco_w,cd_convenio_w,cd_categoria_w,cd_unidade_medida_cotada_w)
					into STRICT	vl_preco_venda_w
					;

					select	nextval('cot_compra_forn_item_seq')
					into STRICT	nr_seq_cot_item_forn_w
					;

					insert into cot_compra_forn_item(
						nr_sequencia,
						nr_seq_cot_forn,
						nr_cot_compra,
						nr_item_cot_compra,
						cd_cgc_fornecedor,
						qt_material,
						qt_prioridade,
						vl_unitario_material,
						dt_atualizacao,
						nm_usuario,
						cd_material,
						vl_preco_liquido,
						vl_total_liquido_item,
						ie_situacao,
						ds_material_direto,
						ds_marca,
						vl_preco)
					values (	nr_seq_cot_item_forn_w,
						nr_seq_cot_fornecedor_w,
						nr_cot_compra_p,
						nr_item_cot_compra_w,
						cd_cgc_fornecedor_w,
						qt_convertido_w,
						100,
						vl_preco_w,
						clock_timestamp(),
						nm_usuario_p,
						cd_material_ww,
						0,
						0,
						'A',
						ds_material_direto_ww,
						CASE WHEN ie_gerar_marca_w='S' THEN coalesce(ds_marca_w, substr(obter_marca_material_Estab(cd_estabelecimento_p, cd_material_ww,'D'),1,30))  ELSE '' END ,
						vl_preco_venda_w);

					vl_total_w := qt_convertido_w * vl_preco_w;

					open C03;
					loop
					fetch C03 into	
						cd_tributo_w,
						vl_tributo_w,
						pr_tributo_w;
					EXIT WHEN NOT FOUND; /* apply on C03 */
					begin
								
					if (vl_tributo_w > 0) then
						pr_tributo_w	:= dividir(vl_tributo_w * 100, vl_total_w);
					else
						vl_tributo_w	:= dividir((vl_total_w * pr_tributo_w), 100);
					end if;
					
					select	count(*)
					into STRICT	qt_existe_w
					from	cot_compra_forn_item_tr
					where	nr_seq_cot_item_forn = nr_seq_cot_item_forn_w
					and	cd_tributo = cd_tributo_w;
					
					if (qt_existe_w = 0) then

						insert into cot_compra_forn_item_tr(
							nr_cot_compra,
							nr_item_cot_compra,
							cd_cgc_fornecedor,
							cd_tributo,
							pr_tributo,
							vl_tributo,
							dt_atualizacao,
							nm_usuario,
							ds_observacao,
							nr_sequencia,
							nr_seq_cot_item_forn,
							dt_atualizacao_nrec,
							nm_usuario_nrec)
						values (	nr_cot_compra_p,
							nr_item_cot_compra_w,
							cd_cgc_fornecedor_w,
							cd_tributo_w,
							pr_tributo_w,
							vl_tributo_w,
							clock_timestamp(),
							nm_usuario_p,
							null,
							nextval('cot_compra_forn_item_tr_seq'),
							nr_seq_cot_item_forn_w,
							clock_timestamp(),
							nm_usuario_p);
					else
						update	cot_compra_forn_item_tr
						set	pr_tributo		= pr_tributo_w,
							vl_tributo		= vl_tributo_w,
							dt_atualizacao		= clock_timestamp(),
							nm_usuario		= nm_usuario_p
						where	nr_seq_cot_item_forn 	= nr_seq_cot_item_forn_w
						and	cd_tributo 		= cd_tributo_w;
					end if;
					end;
				end loop;
				close C03;

				end if;
				end;
			end loop;
			close c02;
			end;
		end if;
		end;
	end loop;
	close 	c01;
	end;
end loop;
close 	c00;

if (ie_gera_todos_itens_w = 'S') then
	CALL atualizar_item_cot_fornec(nr_cot_compra_p, nr_seq_cot_fornecedor_w, 1, nm_usuario_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_cotacao_mat_fornec ( nr_cot_compra_p bigint, ie_escolhe_fornec_p text, cd_cnpj_p text, dt_documento_p timestamp, ie_frete_p text, cd_moeda_p bigint, cd_condicao_pag_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
