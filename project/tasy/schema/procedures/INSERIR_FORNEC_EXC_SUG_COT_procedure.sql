-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE inserir_fornec_exc_sug_cot ( nr_cot_compra_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE

 
cd_cgc_fornecedor_w			varchar(14);
nr_solic_compra_w				bigint;
cd_condicao_pagto_w			bigint;
qt_dia_prazo_entrega_w			smallint;
nr_seq_cot_fornecedor_w			bigint;
cd_moeda_w				bigint;
cd_condicao_pagamento_padrao_w		bigint;
ie_desdobra_mat_cotacao_w			varchar(1);
ie_desdobra_mat_estoque_w			varchar(1);
qt_conv_compra_estoque_w			double precision;
cd_material_ww				integer;
cd_material_w				integer;
nr_item_cot_compra_w			bigint;
qt_material_w				double precision;
qt_convertido_w				double precision;
ie_exclusivo_w				varchar(1);
qt_exclusivo_w				bigint;
ie_tipo_w				varchar(1);
nr_contrato_w			bigint;

c01 CURSOR FOR				 
SELECT	distinct 
	nr_solic_compra 
from (	SELECT	a.nr_solic_compra 
	from	cot_compra_item a 
	where	a.nr_cot_compra = nr_cot_compra_p 
	and	(a.nr_solic_compra IS NOT NULL AND a.nr_solic_compra::text <> '') 
	
union
 
	select	b.nr_solic_compra 
	from	cot_compra_item a, 
		cot_compra_solic_agrup b 
	where	a.nr_cot_compra = b.nr_cot_compra 
	and	a.nr_item_cot_compra = b.nr_item_cot_compra 
	and	a.nr_cot_compra = nr_cot_compra_p 
	and	(b.nr_solic_compra IS NOT NULL AND b.nr_solic_compra::text <> '')) alias2;
		
c02 CURSOR FOR 
SELECT	distinct 
	cd_cgc_fornecedor, 
	ie_exclusivo, 
	ie_tipo 
from ( 
	SELECT	0 ie_tipo, 
		cd_fornec_exclusivo cd_cgc_fornecedor, 
		'S' ie_exclusivo 
	from	solic_compra 
	where	nr_solic_compra = nr_solic_compra_w 
	and	(cd_fornec_exclusivo IS NOT NULL AND cd_fornec_exclusivo::text <> '') 
	
union
 
	select	1 ie_tipo, 
		cd_fornec_sugerido cd_cgc_fornecedor, 
		'N' ie_exclusivo 
	from	solic_compra 
	where	nr_solic_compra = nr_solic_compra_w 
	and	(cd_fornec_sugerido IS NOT NULL AND cd_fornec_sugerido::text <> '') 
	and	coalesce(cd_fornec_exclusivo::text, '') = '') alias3 
order by	ie_tipo;

c03 CURSOR FOR 
SELECT	cd_material, 
	nr_item_cot_compra, 
	qt_material, 
	nr_contrato 
from	cot_compra_item 
where	nr_cot_compra	= nr_cot_compra_p 
and	coalesce(ie_situacao,'A')	= 'A';	
 
c04 CURSOR FOR 
SELECT	cd_material 
from	material 
where	cd_material_estoque = cd_material_w 
and (coalesce(Obter_se_mat_ressuprimento(cd_estabelecimento_p, cd_material),'S') = 'S') 
and (coalesce(obter_se_material_padronizado(cd_estabelecimento_p, cd_material),'S') = 'S') 
and	ie_situacao  	= 'A' 
and	ie_desdobra_mat_cotacao_w in ('S','F') 
and	(((cd_material_estoque <> cd_material and obter_qt_mesmo_mat_estoque(cd_material_estoque) > 1) or (obter_qt_mesmo_mat_estoque(cd_material_estoque) = 1)) or (ie_desdobra_mat_estoque_w = 'S'));
	

BEGIN 
 
open C01;
loop 
fetch C01 into	 
	nr_solic_compra_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin 
	 
	open C02;
	loop 
	fetch C02 into	 
		cd_cgc_fornecedor_w, 
		ie_exclusivo_w, 
		ie_tipo_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin 
		 
		begin 
		select	max(cd_moeda_padrao), 
			coalesce(max(cd_condicao_pagamento_padrao),30), 
			coalesce(max(ie_desdobra_mat_cotacao),'N'), 
			coalesce(max(ie_desdobra_mat_estoque),'N') 
		into STRICT	cd_moeda_w, 
			cd_condicao_pagamento_padrao_w, 
			ie_desdobra_mat_cotacao_w, 
			ie_desdobra_mat_estoque_w 
		from	parametro_compras 
		where	cd_estabelecimento = cd_estabelecimento_p;
		exception 
			when no_data_found then 
			CALL wheb_mensagem_pck.exibir_mensagem_abort(266073);
			--' Informar moeda padrão no parâmetro de compras'); 
		end;		
		 
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
			CALL wheb_mensagem_pck.exibir_mensagem_abort(266074,'CD_CGC=' || cd_cgc_fornecedor_w || ';DS_FORNECEDOR=' || substr(obter_nome_pf_pj(null,cd_cgc_fornecedor_w),1,100));
			--' Falta a informação da condição pagamento no cadastro do fornecedcor.' || chr(13) || chr(10) || 
			--cd_cgc_fornecedor_w || ' - ' || substr(obter_nome_pf_pj(null,cd_cgc_fornecedor_w),1,100)); 
		end;
 
		select	coalesce(max(nr_sequencia),0) 
		into STRICT	nr_seq_cot_fornecedor_w 
		from	cot_compra_forn 
		where	nr_cot_compra		= nr_cot_compra_p 
		and	cd_cgc_fornecedor	= cd_cgc_fornecedor_w;
		 
		select	count(*) 
		into STRICT	qt_exclusivo_w 
		from	cot_compra_forn 
		where	nr_cot_compra		= nr_cot_compra_p 
		and	coalesce(ie_exclusivo,'N') 	= 'S';
 
		if (nr_seq_cot_fornecedor_w = 0) and (qt_exclusivo_w = 0) then 
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
				ie_exclusivo) 
			values (	nr_seq_cot_fornecedor_w, 
				nr_cot_compra_p, 
				cd_cgc_fornecedor_w, 
				clock_timestamp(), 
				nm_usuario_p, 
				cd_moeda_w, 
				cd_condicao_pagto_w, 
				'N', 
				ie_exclusivo_w);
				 
			open C03;
			loop 
			fetch C03 into	 
				cd_material_w, 
				nr_item_cot_compra_w, 
				qt_material_w, 
				nr_contrato_w;
			EXIT WHEN NOT FOUND; /* apply on C03 */
				begin 
 
				/*Se o fornecedor é o mesmo fornecedor do contrato vinculado a esse item*/
 
				if	((coalesce(nr_contrato_w::text, '') = '') or (cd_cgc_fornecedor_w <> obter_dados_contrato(nr_contrato_w,'CNPJ'))) then 
					nr_contrato_w := null;
				end if;
				 
				/*Se nao desdobra ou desdobra so nos itens*/
 
				if (ie_desdobra_mat_cotacao_w in ('N','I')) then 
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
						nr_contrato) 
					values (	nextval('cot_compra_forn_item_seq'), 
						nr_seq_cot_fornecedor_w, 
						nr_cot_compra_p, 
						nr_item_cot_compra_w, 
						cd_cgc_fornecedor_w, 
						qt_material_w, 
						100, 
						cd_material_w, 
						0, 
						clock_timestamp(), 
						nm_usuario_p, 
						0, 
						0, 
						'A', 
						nr_contrato_w);
				else 
					begin 
					 
					open	c04;
					loop 
					fetch	c04 into 
						cd_material_ww;
					EXIT WHEN NOT FOUND; /* apply on c04 */
						begin 
						 
						select	qt_conv_compra_estoque 
						into STRICT	qt_conv_compra_estoque_w 
						from	material 
						where	cd_material = cd_material_ww;
 
						qt_convertido_w	:= (round(dividir(qt_material_w,qt_conv_compra_estoque_w))) * qt_conv_compra_estoque_w;
						 
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
							nr_contrato) 
						values (	nextval('cot_compra_forn_item_seq'), 
							nr_seq_cot_fornecedor_w, 
							nr_cot_compra_p, 
							nr_item_cot_compra_w, 
							cd_cgc_fornecedor_w, 
							qt_convertido_w, 
							100, 
							0, 
							clock_timestamp(), 
							nm_usuario_p, 
							cd_material_ww, 
							0, 
							0, 
							'A', 
							nr_contrato_w);
						end;
					end loop;
					close c04;
					end;
				end if;
				end;
			end loop;
			close C03;		
		end if;		
		end;
	end loop;
	close C02;	
	end;	
	CALL atualizar_item_cot_fornec(nr_cot_compra_p,null,1,nm_usuario_p);
end loop;
close C01;
commit;
 
end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE inserir_fornec_exc_sug_cot ( nr_cot_compra_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;
