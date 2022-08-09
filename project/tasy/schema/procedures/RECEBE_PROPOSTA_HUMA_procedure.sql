-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE recebe_proposta_huma ( nr_cot_compra_p bigint, nm_usuario_p text, ie_erro_p INOUT text) AS $body$
DECLARE


nr_sequencia_w			bigint;
cd_fornecedor_w			varchar(14);
nm_fornecedor_w			varchar(100);
tp_frete_w			varchar(3);
vl_cotacao_w			cotacao_moeda.vl_cotacao%type;
ie_situacao_w			varchar(1);
dt_cotacao_w			timestamp;
dt_venda_w			timestamp;
vl_venda_w			double precision;
dt_validade_w			timestamp;
nm_vendedor_w			varchar(100);
vl_fatura_min_w			double precision;
qt_prazo_entrega_w		bigint;
ds_observacao_w			varchar(100);
nr_cep_w				varchar(15);
ds_endereco_w			varchar(40);
ds_municipio_w			varchar(40);
ds_razao_social_w			varchar(80);
sg_estado_w			pessoa_juridica.sg_estado%type;

cd_produto_w			bigint;
ds_produto_w			varchar(255);
qt_cotacao_tasy_w			double precision;
qt_cotacao_huma_w		double precision;
vl_unitario_material_w		double precision;
vl_desconto_w			double precision;
vl_custo_unitario_w			double precision;
ds_marca_w			varchar(30);
ds_observacao_item_w		varchar(255);

vl_total_w			double precision;
cd_estabelecimento_w		bigint;
nr_item_cotacao_w			bigint;
cd_tipo_pessoa_w			varchar(15);
ie_erro_w				varchar(1) := 'N';
ds_erro_w			varchar(255);
qt_registros_w			bigint;
qt_registro_huma_w		bigint;
cd_estab_w			bigint;
nr_seq_cot_forn_w			bigint;
cd_moeda_padrao_w		bigint;
cd_condicao_pagamento_w		bigint;
cd_interno_w			varchar(40);
qt_condicacao_pagamento_w	bigint;
			
c01 CURSOR FOR
SELECT	a.nr_sequencia,
	a.cd_fornecedor,
	a.nm_fornecedor,
	a.tp_frete,
	a.vl_cotacao,
	a.ie_situacao,
	a.dt_cotacao,
	a.dt_venda,
	a.vl_venda,
	a.dt_validade,
	a.nm_vendedor,
	a.vl_fatura_min,
	somente_numero(a.qt_dias_entrega),
	a.ds_observacao,
	a.cd_condicao_pagamento,
	a.nr_cep,
	a.ds_endereco,
	a.ds_municipio,
	a.ds_razao_social,
	a.sg_estado,
	b.cd_produto,
	b.ds_produto,
	coalesce(b.qt_item,0) qt_cotacao_tasy,
	coalesce(b.qt_cotacao,0) qt_cotacao_huma,
	coalesce(b.vl_cotacao,0) vl_unitario_material,
	coalesce(b.vl_desconto,0) vl_desconto,
	coalesce(b.vl_custo_unitario,0) vl_custo_unit,
	substr(b.ds_marca,1,30) ds_marca,
	b.ds_observacao
from	w_huma_cotacao a,
	w_huma_cot_item b
where	a.nr_sequencia = b.nr_seq_cotacao
and	a.nr_cot_compra = nr_cot_compra_p;

c02 CURSOR FOR
SELECT	cd_estabelecimento
from	estabelecimento
where	ie_situacao = 'A';
				

BEGIN

select	cd_estabelecimento
into STRICT	cd_estabelecimento_w
from	cot_compra
where	nr_cot_compra = nr_cot_compra_p;

select	cd_tipo_pessoa_bionexo,
	cd_moeda_padrao
into STRICT	cd_tipo_pessoa_w,
	cd_moeda_padrao_w
from	parametro_compras
where	cd_estabelecimento = cd_estabelecimento_w;

open C01;
loop
fetch C01 into	
	nr_sequencia_w,
	cd_fornecedor_w,
	nm_fornecedor_w,
	tp_frete_w,
	vl_cotacao_w,
	ie_situacao_w,
	dt_cotacao_w,
	dt_venda_w,
	vl_venda_w,
	dt_validade_w,
	nm_vendedor_w,
	vl_fatura_min_w,
	qt_prazo_entrega_w,
	ds_observacao_w,
	cd_condicao_pagamento_w,
	nr_cep_w,
	ds_endereco_w,
	ds_municipio_w,
	ds_razao_social_w,
	sg_estado_w,
	cd_produto_w,
	ds_produto_w,
	qt_cotacao_tasy_w,
	qt_cotacao_huma_w,
	vl_unitario_material_w,
	vl_desconto_w,
	vl_custo_unitario_w,
	ds_marca_w,
	ds_observacao_item_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	
	if (coalesce(cd_fornecedor_w::text, '') = '') then
		ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(306435);
		ie_erro_w := 'S';
	end if;
	
	if (coalesce(nm_fornecedor_w::text, '') = '') then
		ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(306436);
		ie_erro_w := 'S';
	end if;
	
	if (coalesce(tp_frete_w::text, '') = '') then
		ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(306437);
		ie_erro_w := 'S';
	end if;
	
	if (coalesce(nr_cep_w::text, '') = '') then
		ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(306438);
		ie_erro_w := 'S';
	end if;
	
	if (coalesce(ds_endereco_w::text, '') = '') then
		ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(306439);
		ie_erro_w := 'S';
	end if;
	
	if (coalesce(ds_municipio_w::text, '') = '') then
		ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(306440);
		ie_erro_w := 'S';
	end if;
	
	if (coalesce(ds_razao_social_w::text, '') = '') then
		ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(306441);
		ie_erro_w := 'S';
	end if;
	
	if (coalesce(sg_estado_w::text, '') = '') then
		ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(306442);
		ie_erro_w := 'S';
	end if;	
	
	if (coalesce(qt_prazo_entrega_w,0) = 0) then
		ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(306443);
		ie_erro_w := 'S';
	end if;
	
	if (coalesce(cd_produto_w::text, '') = '') then
		ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(306444);
		ie_erro_w := 'S';
	else
		select	count(*)
		into STRICT	qt_registros_w
		from	material
		where	cd_material = cd_produto_w;
		
		if (qt_registros_w = 0) then
			ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(306447,'CD_PRODUTO_W='||cd_produto_w);
			ie_erro_w := 'S';
		end if;	
	end if;	
		
	if (qt_cotacao_huma_w = 0) then
		ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(306451);
		ie_erro_w := 'S';
	end if;
	
	if (coalesce(cd_moeda_padrao_w::text, '') = '') then
		ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(306452);
		ie_erro_w := 'S';
	end if;	
	
	cd_interno_w	:= substr(obter_conversao_interna(null,'CONDICAO_PAGAMENTO','CD_CONDICAO_PAGAMENTO',coalesce(cd_condicao_pagamento_w,0)),1,40);
	
	if (coalesce(cd_interno_w::text, '') = '') then
		begin
		
		select	count(1)
		into STRICT	qt_condicacao_pagamento_w
		from	condicao_pagamento
		where	cd_condicao_pagamento = coalesce(cd_condicao_pagamento_w,0);
		
		end;
	else
		begin
		
		select	count(1)
		into STRICT	qt_condicacao_pagamento_w
		from	condicao_pagamento
		where	cd_condicao_pagamento = cd_interno_w;
		
		cd_condicao_pagamento_w := cd_interno_w;
		
		end;
	end if;
	
	if (coalesce(cd_condicao_pagamento_w::text, '') = '') or (cd_condicao_pagamento_w = 0) or (qt_condicacao_pagamento_w <= 0) then
		ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(306453);
		ie_erro_w := 'S';
	end if;	
	
	select	coalesce(min(a.nr_item_cot_compra),0)
	into STRICT	nr_item_cotacao_w
	from	cot_compra_item a
	where	a.nr_cot_compra	= nr_cot_compra_p
	and	a.cd_material = cd_produto_w;
	
	if (nr_item_cotacao_w = 0) then
		ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(306454,'CD_PRODUTO_W='||cd_produto_w);
		ie_erro_w := 'S';
	end if;	
	
	if (ie_erro_w = 'N') then
	
		/*Início cadastro da pessoa jurídica*/

		select	count(*)
		into STRICT	qt_registros_w
		from	pessoa_juridica
		where	cd_cgc = cd_fornecedor_w;
		
		if (qt_registros_w = 0) then
			
			
			if (coalesce(cd_tipo_pessoa_w::text, '') = '') then
				select	min(cd_tipo_pessoa)
				into STRICT	cd_tipo_pessoa_w
				from	tipo_pessoa_juridica
				where	ie_situacao = 'A';
			end if;
			
			insert into pessoa_juridica(
				cd_cgc,
				ds_razao_social,
				nm_fantasia,
				cd_cep,
				ds_endereco,
				ds_municipio,
				sg_estado,
				dt_atualizacao,
				nm_usuario,
				cd_tipo_pessoa,
				ie_prod_fabric,
				ie_situacao,
				dt_atualizacao_nrec,
				nm_usuario_nrec)
			values (	cd_fornecedor_w,
				ds_razao_social_w,
				ds_razao_social_w,
				nr_cep_w,
				ds_endereco_w,
				ds_municipio_w,
				sg_estado_w,
				clock_timestamp(),
				nm_usuario_p,
				cd_tipo_pessoa_w,
				'N',
				'A',
				clock_timestamp(),
				nm_usuario_p);
				
			open C02;
			loop
			fetch C02 into	
				cd_estab_w;
			EXIT WHEN NOT FOUND; /* apply on C02 */
				begin
				
				insert into pessoa_juridica_estab(
					nr_sequencia,
					cd_cgc,
					cd_estabelecimento,
					dt_atualizacao,
					nm_usuario,
					ie_conta_dif_nf,
					ie_rateio_adiant,
					ie_retem_iss)
				values (	nextval('pessoa_juridica_estab_seq'),
					cd_fornecedor_w,
					cd_estab_w,
					clock_timestamp(),
					nm_usuario_p,
					'N',
					'P',
					'N');	
				end;
			end loop;
			close C02;

		else
			
			update	pessoa_juridica
			set	ie_situacao = 'A',
				ds_razao_social = ds_razao_social_w,
				nm_fantasia = ds_razao_social_w,
				cd_cep = nr_cep_w,
				ds_endereco = ds_endereco_w,
				ds_municipio = ds_municipio_w,
				sg_estado = sg_estado_w
			where	cd_cgc = cd_fornecedor_w;
		end if;
		/*Fim cadastro da pessoa jurídica*/

	
		select	coalesce(max(nr_sequencia),0)
		into STRICT	nr_seq_cot_forn_w
		from	cot_compra_forn
		where	nr_cot_compra = nr_cot_compra_p
		and	cd_cgc_fornecedor = cd_fornecedor_w;
	
		if (nr_seq_cot_forn_w = 0) then
			
			select	CASE WHEN upper(tp_frete_w)='1' THEN 'C' WHEN upper(tp_frete_w)='CIF' THEN 'C' WHEN upper(tp_frete_w)='2' THEN 'F' WHEN upper(tp_frete_w)='FOB' THEN 'F' END
			into STRICT	tp_frete_w
			;			
			
			select	nextval('cot_compra_forn_seq')
			into STRICT	nr_seq_cot_forn_w
			;
			
			begin
			insert	into cot_compra_forn(
				nr_sequencia,
				nr_cot_compra,
				cd_cgc_fornecedor,
				dt_atualizacao,
				nm_usuario,
				ds_observacao,
				cd_moeda,
				cd_condicao_pagamento,
				ie_frete,
				ie_status_envio_email_lib,
				qt_dias_entrega)
			values (	nr_seq_cot_forn_w,
				nr_cot_compra_p,
				cd_fornecedor_w,
				clock_timestamp(),
				nm_usuario_p,
				ds_observacao_w,
				cd_moeda_padrao_w,
				cd_condicao_pagamento_w,
				tp_frete_w,
				'N',
				qt_prazo_entrega_w);
			exception
			when others then
				ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(306458,'SQL_ERRO_W='||sqlerrm);
				ie_erro_w := 'S';
			end;
			
		else
			select	CASE WHEN upper(tp_frete_w)='1' THEN 'C' WHEN upper(tp_frete_w)='CIF' THEN 'C' WHEN upper(tp_frete_w)='2' THEN 'F' WHEN upper(tp_frete_w)='FOB' THEN 'F' END
			into STRICT	tp_frete_w
			;			
			
			update	cot_compra_forn
			set	ds_observacao = ds_observacao_w,
				ie_frete = tp_frete_w,
				qt_dias_entrega = qt_prazo_entrega_w,
				cd_condicao_pagamento = cd_condicao_pagamento_w
			where	nr_sequencia = nr_seq_cot_forn_w;
		end if;
		
		if (ie_erro_w = 'N') then
			
			vl_total_w := 0;
			vl_total_w := ((vl_unitario_material_w * qt_cotacao_huma_w) - vl_desconto_w);
			
			delete from cot_compra_forn_item
			where	nr_cot_compra = nr_cot_compra_p
			and	nr_seq_cot_forn = nr_seq_cot_forn_w
			and	cd_material = cd_produto_w;
		
			begin
			insert into cot_compra_forn_item(
				nr_sequencia,
				nr_seq_cot_forn,
				nr_cot_compra,
				nr_item_cot_compra,
				cd_cgc_fornecedor,
				qt_material,
				vl_unitario_material,
				vl_desconto,
				dt_atualizacao,
				nm_usuario,
				vl_preco_liquido,
				vl_total_liquido_item,
				ie_situacao,
				ds_marca,
				ds_marca_fornec,
				cd_material,
				ds_observacao)
			values (	nextval('cot_compra_forn_item_seq'),
				nr_seq_cot_forn_w,
				nr_cot_compra_p,
				nr_item_cotacao_w,
				cd_fornecedor_w,
				qt_cotacao_huma_w,
				vl_unitario_material_w,
				vl_desconto_w,
				clock_timestamp(),
				nm_usuario_p,
				vl_total_w,
				vl_total_w,
				'A',
				substr(ds_marca_w,1,30),
				substr(ds_marca_w,1,30),
				cd_produto_w,
				ds_observacao_item_w);
			exception
			when others then
				ds_erro_w := WHEB_MENSAGEM_PCK.get_texto(306460,'SQL_ERRO_W='||sqlerrm);
				ie_erro_w := 'S';
			end;
		end if;
	end if;
	
	end;
end loop;
close C01;

delete from w_huma_cotacao where nr_cot_compra = nr_cot_compra_p;

if (ie_erro_w = 'N') then
	commit;
else
	rollback;
end if;

if (ie_erro_w = 'S') then
	CALL gerar_historico_cotacao(	
		nr_cot_compra_p,
		WHEB_MENSAGEM_PCK.get_texto(306461),
		WHEB_MENSAGEM_PCK.get_texto(306462,'DS_ERRO_W='||ds_erro_w),
		'S',
		nm_usuario_p);
else
	update	cot_compra
	set	IE_SISTEMA_COTACAO = 'HUMA'
	where	nr_cot_compra = nr_cot_compra_p;
	
	
	CALL gerar_historico_cotacao(	
		nr_cot_compra_p,
		WHEB_MENSAGEM_PCK.get_texto(306466),
		WHEB_MENSAGEM_PCK.get_texto(306467),
		'S',
		nm_usuario_p);

end if;

ie_erro_p := ie_erro_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE recebe_proposta_huma ( nr_cot_compra_p bigint, nm_usuario_p text, ie_erro_p INOUT text) FROM PUBLIC;
