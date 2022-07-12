-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_envia_email_regra ( nr_documento_p bigint, ie_tipo_documento_p text, ie_tipo_mensagem_p bigint, cd_estabelecimento_p bigint, nr_seq_regra_p bigint default 0, nr_seq_aprovacao_p bigint default 0, nr_seq_proc_aprov_p bigint default 0) RETURNS varchar AS $body$
DECLARE

/*
IE_TIPO_DOCUMENTO_P
	SC - Solicitacao de Compra
	OC - Ordem de Compra
	TR - Controle Transferencia Estoque
	IR - Inspecao Recebimento
	CC - Cotacao de Compra
	AP - Aprovacao Pendente
	CM - Cadastro de Materiais
	NF - Nota Fiscal
	RM -  Requisicao Material*/
ie_envia_email_w 		varchar(1) := 'N';
qt_existe_w			bigint;
qt_existe_regras_w		bigint;
nr_documento_w			bigint;
ie_tipo_w			varchar(1);
nr_seq_regra_w			bigint;
cd_local_estoque_w		bigint;
cd_centro_custo_w		bigint;
cd_material_w			bigint;
cd_grupo_material_w		bigint;
cd_subgrupo_material_w		bigint;
cd_classe_material_w		bigint;
ie_consignado_w			varchar(1);
ie_tipo_servico_w		varchar(15);
ie_urgente_solic_w		varchar(1);
ie_urgente_oc_w			varchar(1);
vl_total_documento_w		double precision;
vl_minimo_documento_w		double precision;
vl_maximo_documento_w		double precision;
nr_seq_regra_param_w		bigint;

c00 CURSOR FOR
SELECT	nr_sequencia
from	regra_envio_email_compra
where	cd_estabelecimento = cd_estabelecimento_p
and	ie_tipo_mensagem = ie_tipo_mensagem_p
and	((nr_seq_regra_param_w = 0) or
	(nr_seq_regra_param_w > 0 AND nr_sequencia = nr_seq_regra_param_w))
and	ie_situacao = 'A';

c01 CURSOR FOR
SELECT	a.cd_local_estoque,
	a.cd_centro_custo,
	b.cd_material,
	coalesce(a.ie_tipo_servico,'ES'),
	a.ie_urgente
from	solic_compra a,
	solic_compra_item b
where	a.nr_solic_compra = b.nr_solic_compra
and	a.nr_solic_compra = nr_documento_w;

c02 CURSOR FOR
SELECT	a.cd_local_estoque,
	a.cd_centro_custo,
	a.cd_material,
	b.ie_urgente
from	ordem_compra_item a,
	ordem_compra b
where	a.nr_ordem_compra = nr_documento_w
and	a.nr_ordem_compra = b.nr_ordem_compra;

c03 CURSOR FOR
SELECT	a.cd_material
from	cot_compra_item a
where	nr_cot_compra = nr_documento_w;

c04 CURSOR FOR
SELECT	a.cd_local_estoque,
	a.cd_centro_custo,
	b.cd_material
from	requisicao_material a,
	item_requisicao_material b
where	a.nr_requisicao = b.nr_requisicao
and	a.nr_requisicao = nr_documento_w;

c05 CURSOR FOR
SELECT	a.cd_local_estoque,
	a.cd_centro_custo,
	a.cd_material
from	nota_fiscal_item a
where	a.nr_sequencia = nr_documento_w
and	(a.cd_material IS NOT NULL AND a.cd_material::text <> '');

c06 CURSOR FOR
SELECT	a.cd_local_estoque,
	a.cd_centro_custo,
	b.cd_material
from	requisicao_material a,
	item_requisicao_material b
where	a.nr_requisicao = nr_documento_p
and	a.nr_requisicao = b.nr_requisicao;


BEGIN

nr_documento_w		:= nr_documento_p;
nr_seq_regra_param_w	:= coalesce(nr_seq_regra_p,0);

open C00;
loop
fetch C00 into	
	nr_seq_regra_w;
EXIT WHEN NOT FOUND; /* apply on C00 */
	begin
	
	select	max(coalesce(vl_minimo_documento,0)),
		max(coalesce(vl_maximo_documento,0))
	into STRICT	vl_minimo_documento_w,
		vl_maximo_documento_w
	from	envio_email_compra_filtro
	where	nr_seq_regra = nr_seq_regra_w;

	select	count(*)
	into STRICT	qt_existe_regras_w
	from	envio_email_compra_filtro
	where	nr_seq_regra = nr_seq_regra_w;
		
	if (qt_existe_regras_w = 0) then
		ie_envia_email_w := 'S';		/*Quando nao tem regras ja passa S para a variavel, pois quando nao tem filtros deve enviar o e-mail*/
	end if;
	
	if (qt_existe_regras_w > 0) and (ie_tipo_documento_p = 'SC') then	/*SOLICITACAO DE COMPRA*/
		open C01;
		loop
		fetch C01 into	
			cd_local_estoque_w,
			cd_centro_custo_w,
			cd_material_w,
			ie_tipo_servico_w,
			ie_urgente_solic_w;
		exit when(C01%notfound or ie_envia_email_w = 'S');
			begin
			select	cd_grupo_material,
				cd_subgrupo_material,
				cd_classe_material,
				ie_consignado
			into STRICT	cd_grupo_material_w,
				cd_subgrupo_material_w,
				cd_classe_material_w,
				ie_consignado_w
			from	estrutura_material_v
			where	cd_material = cd_material_w;
			
			select	count(*),
				max(coalesce(vl_minimo_documento,0)),
				max(coalesce(vl_maximo_documento,0))
			into STRICT	qt_existe_w,
				vl_minimo_documento_w,
				vl_maximo_documento_w
			from	envio_email_compra_filtro
			where	nr_seq_regra = nr_seq_regra_w
			and	coalesce(ie_envia_email,'S') = 'S'
			and	((coalesce(cd_local_estoque::text, '') = '') or (coalesce(cd_local_estoque, cd_local_estoque_w) = cd_local_estoque_w))
			and	((coalesce(cd_centro_custo::text, '') = '') or (coalesce(cd_centro_custo, cd_centro_custo_w) = cd_centro_custo_w))
			and	coalesce(cd_grupo_material,cd_grupo_material_w) = cd_grupo_material_w
			and	coalesce(cd_subgrupo_material,cd_subgrupo_material_w) = cd_subgrupo_material_w
			and	coalesce(cd_classe_material,cd_classe_material_w) = cd_classe_material_w
			and	coalesce(cd_material,cd_material_w) = cd_material_w			
			and	((ie_solic_estoque = 'S' AND ie_tipo_servico_w = 'ES') or
				((ie_solic_servico = 'S') and (ie_tipo_servico_w in ('CD','SR','SN'))) or
				(ie_solic_investimento = 'S' AND ie_tipo_servico_w = 'SI') or
				(ie_solic_pagto = 'S' AND ie_tipo_servico_w = 'SP'))		
			and	((coalesce(ie_consignado,'A') = 'A') or
				((coalesce(ie_consignado,'A') = 'N') and (ie_consignado_w = '0')) or
				((coalesce(ie_consignado,'A') = 'S') and (ie_consignado_w = '1')))
			and	((ie_urgente = 'N') or
				(ie_urgente = 'S' AND ie_urgente_solic_w = 'S'))
			order by
				coalesce(cd_local_estoque,0),
				coalesce(cd_centro_custo,0),
				coalesce(ie_consignado,0),
				coalesce(cd_grupo_material, 0),
				coalesce(cd_subgrupo_material, 0),
				coalesce(cd_classe_material, 0),
				coalesce(cd_material, 0);
			
			if (qt_existe_w > 0) then
				ie_envia_email_w := 'S';
			end if;
			end;
		end loop;
		close C01;

		select	coalesce(sum(qt_material * coalesce(vl_unit_previsto,0)),0)
		into STRICT	vl_total_documento_w
		from	solic_compra_item
		where	nr_solic_compra = nr_documento_w;

	elsif (ie_envia_email_w = 'N') and (ie_tipo_documento_p in ('OC','TR')) then	/*ORDEM DE COMPRA e CONTROLE TRANSFERENCIA ESTOQUE*/
		
		
		open C02;
		loop
		fetch C02 into	
			cd_local_estoque_w,
			cd_centro_custo_w,
			cd_material_w,
			ie_urgente_oc_w;
		exit when(C02%notfound or ie_envia_email_w = 'S');

			begin
			select	cd_grupo_material,
				cd_subgrupo_material,
				cd_classe_material,
				ie_consignado
			into STRICT	cd_grupo_material_w,
				cd_subgrupo_material_w,
				cd_classe_material_w,
				ie_consignado_w
			from	estrutura_material_v
			where	cd_material = cd_material_w;
			
			select	count(*),
				max(coalesce(vl_minimo_documento,0)),
				max(coalesce(vl_maximo_documento,0))
			into STRICT	qt_existe_w,
				vl_minimo_documento_w,
				vl_maximo_documento_w
			from	envio_email_compra_filtro
			where	nr_seq_regra = nr_seq_regra_w
			and	coalesce(ie_envia_email,'S') = 'S'
			and	((coalesce(cd_local_estoque::text, '') = '') or (coalesce(cd_local_estoque, cd_local_estoque_w) = cd_local_estoque_w))
			and	((coalesce(cd_centro_custo::text, '') = '') or (coalesce(cd_centro_custo, cd_centro_custo_w) = cd_centro_custo_w))
			and	coalesce(cd_grupo_material,cd_grupo_material_w) = cd_grupo_material_w
			and	coalesce(cd_subgrupo_material,cd_subgrupo_material_w) = cd_subgrupo_material_w
			and	coalesce(cd_classe_material,cd_classe_material_w) = cd_classe_material_w
			and	coalesce(cd_material,cd_material_w) = cd_material_w
			and	((ie_urgente = 'N') or
				(ie_urgente = 'S' AND ie_urgente_oc_w = 'S'))
			and	((coalesce(ie_consignado,'A') = 'A') or
				((coalesce(ie_consignado,'A') = 'N') and (ie_consignado_w = '0')) or
				((coalesce(ie_consignado,'A') = 'S') and (ie_consignado_w = '1')))
			order by
				coalesce(cd_local_estoque,0),
				coalesce(cd_centro_custo,0),
				coalesce(ie_consignado,0),
				coalesce(cd_grupo_material, 0),
				coalesce(cd_subgrupo_material, 0),
				coalesce(cd_classe_material, 0),
				coalesce(cd_material, 0);
			
			if (qt_existe_w > 0) then
				ie_envia_email_w := 'S';
			end if;
			end;
		end loop;
		close C02;

		select	coalesce(sum(obter_valor_liquido_ordem(nr_ordem_compra)),0)
		into STRICT	vl_total_documento_w
		from	ordem_compra
		where	nr_ordem_compra = nr_documento_w;

	elsif (ie_envia_email_w = 'N') and (ie_tipo_documento_p = 'NF') then	/*NOTA FISCAL*/
		open C05;
		loop
		fetch C05 into	
			cd_local_estoque_w,
			cd_centro_custo_w,
			cd_material_w;
		exit when(C05%notfound or ie_envia_email_w = 'S');
			begin
			
			select	cd_grupo_material,
				cd_subgrupo_material,
				cd_classe_material,
				ie_consignado
			into STRICT	cd_grupo_material_w,
				cd_subgrupo_material_w,
				cd_classe_material_w,
				ie_consignado_w
			from	estrutura_material_v
			where	cd_material = cd_material_w;
			
			select	count(*),
				max(coalesce(vl_minimo_documento,0)),
				max(coalesce(vl_maximo_documento,0))
			into STRICT	qt_existe_w,
				vl_minimo_documento_w,
				vl_maximo_documento_w
			from	envio_email_compra_filtro
			where	nr_seq_regra = nr_seq_regra_w
			and	coalesce(ie_envia_email,'S') = 'S'
			and	((coalesce(cd_local_estoque::text, '') = '') or (coalesce(cd_local_estoque, cd_local_estoque_w) = cd_local_estoque_w))
			and	((coalesce(cd_centro_custo::text, '') = '') or (coalesce(cd_centro_custo, cd_centro_custo_w) = cd_centro_custo_w))
			and	coalesce(cd_grupo_material,cd_grupo_material_w) = cd_grupo_material_w
			and	coalesce(cd_subgrupo_material,cd_subgrupo_material_w) = cd_subgrupo_material_w
			and	coalesce(cd_classe_material,cd_classe_material_w) = cd_classe_material_w
			and	coalesce(cd_material,cd_material_w) = cd_material_w
			and	((coalesce(ie_consignado,'A') = 'A') or
				((coalesce(ie_consignado,'A') = 'N') and (ie_consignado_w = '0')) or
				((coalesce(ie_consignado,'A') = 'S') and (ie_consignado_w = '1')))
			order by
				coalesce(cd_local_estoque,0),
				coalesce(cd_centro_custo,0),
				coalesce(ie_consignado,0),
				coalesce(cd_grupo_material, 0),
				coalesce(cd_subgrupo_material, 0),
				coalesce(cd_classe_material, 0),
				coalesce(cd_material, 0);
				
			if (qt_existe_w > 0) then
				ie_envia_email_w := 'S';
			end if;
			end;
		end loop;
		close C05;

		select	coalesce(vl_total_nota,0)
		into STRICT	vl_total_documento_w
		from	nota_fiscal
		where	nr_sequencia = nr_documento_w;

	elsif (ie_envia_email_w = 'N') and (ie_tipo_documento_p = 'IR') then	/*INSPECAO RECEBIMENTO*/
		select	e.cd_grupo_material,
			e.cd_subgrupo_material,
			e.cd_classe_material,
			e.cd_material,
			e.ie_consignado
		into STRICT	cd_grupo_material_w,
			cd_subgrupo_material_w,
			cd_classe_material_w,
			cd_material_w,
			ie_consignado_w
		from	inspecao_recebimento a,
			estrutura_material_v e
		where	a.cd_material = e.cd_material
		and	a.nr_sequencia = nr_documento_w;
			
		select	count(*),
			max(coalesce(vl_minimo_documento,0)),
			max(coalesce(vl_maximo_documento,0))
		into STRICT	qt_existe_w,
			vl_minimo_documento_w,
			vl_maximo_documento_w
		from	envio_email_compra_filtro
		where	nr_seq_regra = nr_seq_regra_w
		and	coalesce(ie_envia_email,'S') = 'S'
		and	coalesce(cd_grupo_material,cd_grupo_material_w) = cd_grupo_material_w
		and	coalesce(cd_subgrupo_material,cd_subgrupo_material_w) = cd_subgrupo_material_w
		and	coalesce(cd_classe_material,cd_classe_material_w) = cd_classe_material_w
		and	coalesce(cd_material,cd_material_w) = cd_material_w
		and	((coalesce(ie_consignado,'A') = 'A') or
			((coalesce(ie_consignado,'A') = 'N') and (ie_consignado_w = '0')) or
			((coalesce(ie_consignado,'A') = 'S') and (ie_consignado_w = '1')))
		order by	
			coalesce(ie_consignado,0),
			coalesce(cd_grupo_material, 0),
			coalesce(cd_subgrupo_material, 0),
			coalesce(cd_classe_material, 0),
			coalesce(cd_material, 0);
				
		if (qt_existe_w > 0) then
			ie_envia_email_w := 'S';
		end if;

	elsif (ie_envia_email_w = 'N') and (ie_tipo_documento_p = 'CC') then	/*COTACAO DE COMPRAS*/
	

		open C03;
		loop
		fetch C03 into
			cd_material_w;
		exit when(C03%notfound or ie_envia_email_w = 'S');
			begin
			
			select	cd_grupo_material,
				cd_subgrupo_material,
				cd_classe_material,
				ie_consignado
			into STRICT	cd_grupo_material_w,
				cd_subgrupo_material_w,
				cd_classe_material_w,
				ie_consignado_w
			from	estrutura_material_v
			where	cd_material = cd_material_w;
			
			select	count(*),
				max(coalesce(vl_minimo_documento,0)),
				max(coalesce(vl_maximo_documento,0))
			into STRICT	qt_existe_w,
				vl_minimo_documento_w,
				vl_maximo_documento_w
			from	envio_email_compra_filtro
			where	nr_seq_regra = nr_seq_regra_w
			and	coalesce(ie_envia_email,'S') = 'S'
			and	coalesce(cd_grupo_material,cd_grupo_material_w) = cd_grupo_material_w
			and	coalesce(cd_subgrupo_material,cd_subgrupo_material_w) = cd_subgrupo_material_w
			and	coalesce(cd_classe_material,cd_classe_material_w) = cd_classe_material_w
			and	coalesce(cd_material,cd_material_w) = cd_material_w
			and	((coalesce(ie_consignado,'A') = 'A') or
				((coalesce(ie_consignado,'A') = 'N') and (ie_consignado_w = '0')) or
				((coalesce(ie_consignado,'A') = 'S') and (ie_consignado_w = '1')))
			order by
				coalesce(ie_consignado,0),
				coalesce(cd_grupo_material, 0),
				coalesce(cd_subgrupo_material, 0),
				coalesce(cd_classe_material, 0),
				coalesce(cd_material, 0);

			if (qt_existe_w > 0) then
				ie_envia_email_w := 'S';
			end if;
			end;
		end loop;
		close C03;

		select	coalesce(sum(vl_preco_liquido),0)
		into STRICT	vl_total_documento_w
		from	cot_compra_resumo
		where	nr_cot_compra = nr_documento_w;

	elsif (ie_envia_email_w = 'N') and (ie_tipo_documento_p = 'AP') and (coalesce(nr_seq_aprovacao_p,0) > 0 and coalesce(nr_seq_proc_aprov_p,0) > 0) then	/*APROVACAO PENDENTE*/
	
		
		select	ie_tipo,
            nr_documento
        into STRICT ie_tipo_w,
          nr_documento_w
		from processo_aprov_compra
        where nr_sequencia = nr_seq_aprovacao_p
        and nr_seq_proc_aprov = nr_seq_proc_aprov_p;
			
		if (ie_tipo_w = 'O') and		/*APROVACAO DA ORDEM DE COMPRAS*/
			(nr_documento_w > 0) then
			
			open C02;
			loop
			fetch C02 into	
				cd_local_estoque_w,
				cd_centro_custo_w,
				cd_material_w,
				ie_urgente_oc_w;
			exit when(C02%notfound or ie_envia_email_w = 'S');
				begin
				
				select	cd_grupo_material,
					cd_subgrupo_material,
					cd_classe_material,
					ie_consignado
				into STRICT	cd_grupo_material_w,
					cd_subgrupo_material_w,
					cd_classe_material_w,
					ie_consignado_w
				from	estrutura_material_v
				where	cd_material = cd_material_w;
				
				select	count(*),
					max(coalesce(vl_minimo_documento,0)),
					max(coalesce(vl_maximo_documento,0))
				into STRICT	qt_existe_w,
					vl_minimo_documento_w,
					vl_maximo_documento_w
				from	envio_email_compra_filtro
				where	nr_seq_regra = nr_seq_regra_w
				and	coalesce(ie_envia_email,'S') = 'S'
				and	((coalesce(cd_local_estoque::text, '') = '') or (coalesce(cd_local_estoque, cd_local_estoque_w) = cd_local_estoque_w))
				and	((coalesce(cd_centro_custo::text, '') = '') or (coalesce(cd_centro_custo, cd_centro_custo_w) = cd_centro_custo_w))
				and	coalesce(cd_grupo_material,cd_grupo_material_w) = cd_grupo_material_w
				and	((ie_urgente = 'N') or
					(ie_urgente = 'S' AND ie_urgente_oc_w = 'S'))
				and	coalesce(cd_subgrupo_material,cd_subgrupo_material_w) = cd_subgrupo_material_w
				and	coalesce(cd_classe_material,cd_classe_material_w) = cd_classe_material_w
				and	coalesce(cd_material,cd_material_w) = cd_material_w
				and	((coalesce(ie_consignado,'A') = 'A') or
					((coalesce(ie_consignado,'A') = 'N') and (ie_consignado_w = '0')) or
					((coalesce(ie_consignado,'A') = 'S') and (ie_consignado_w = '1')))
				order by
					coalesce(cd_local_estoque,0),
					coalesce(cd_centro_custo,0),
					coalesce(ie_consignado,0),
					coalesce(cd_grupo_material, 0),
					coalesce(cd_subgrupo_material, 0),
					coalesce(cd_classe_material, 0),
					coalesce(cd_material, 0);
					
				if (qt_existe_w > 0) then
					ie_envia_email_w := 'S';
				end if;
				end;
			end loop;
			close C02;

			select	coalesce(sum(obter_valor_liquido_ordem(nr_ordem_compra)),0)
			into STRICT	vl_total_documento_w
			from	ordem_compra
			where	nr_ordem_compra = nr_documento_w;

		elsif (ie_tipo_w = 'S') and		/*APROVACAO DA SOLICITACAO DE COMPRAS*/
			(nr_documento_w > 0) then
			
			open C01;
			loop
			fetch C01 into	
				cd_local_estoque_w,
				cd_centro_custo_w,
				cd_material_w,
				ie_tipo_servico_w,
				ie_urgente_solic_w;
			exit when(C01%notfound or ie_envia_email_w = 'S');
				begin
				
				select	cd_grupo_material,
					cd_subgrupo_material,
					cd_classe_material,
					ie_consignado
				into STRICT	cd_grupo_material_w,
					cd_subgrupo_material_w,
					cd_classe_material_w,
					ie_consignado_w
				from	estrutura_material_v
				where	cd_material = cd_material_w;
				
				select	count(*),
					max(coalesce(vl_minimo_documento,0)),
					max(coalesce(vl_maximo_documento,0))
				into STRICT	qt_existe_w,
					vl_minimo_documento_w,
					vl_maximo_documento_w
				from	envio_email_compra_filtro
				where	nr_seq_regra = nr_seq_regra_w
				and	coalesce(ie_envia_email,'S') = 'S'
				and	((coalesce(cd_local_estoque::text, '') = '') or (coalesce(cd_local_estoque, cd_local_estoque_w) = cd_local_estoque_w))
				and	((coalesce(cd_centro_custo::text, '') = '') or (coalesce(cd_centro_custo, cd_centro_custo_w) = cd_centro_custo_w))
				and	coalesce(cd_grupo_material,cd_grupo_material_w) = cd_grupo_material_w
				and	coalesce(cd_subgrupo_material,cd_subgrupo_material_w) = cd_subgrupo_material_w
				and	coalesce(cd_classe_material,cd_classe_material_w) = cd_classe_material_w
				and	coalesce(cd_material,cd_material_w) = cd_material_w
				and	((ie_solic_estoque = 'S' AND ie_tipo_servico_w = 'ES') or
					((ie_solic_servico = 'S') and (ie_tipo_servico_w in ('CD','SR','SN'))) or
					(ie_solic_investimento = 'S' AND ie_tipo_servico_w = 'SI') or
					(ie_solic_pagto = 'S' AND ie_tipo_servico_w = 'SP'))
				and	((coalesce(ie_consignado,'A') = 'A') or
					((coalesce(ie_consignado,'A') = 'N') and (ie_consignado_w = '0')) or
					((coalesce(ie_consignado,'A') = 'S') and (ie_consignado_w = '1')))
				and	((ie_urgente = 'N') or
					(ie_urgente = 'S' AND ie_urgente_solic_w = 'S'))	
				order by
					coalesce(cd_local_estoque,0),
					coalesce(cd_centro_custo,0),
					coalesce(ie_consignado,0),
					coalesce(cd_grupo_material, 0),
					coalesce(cd_subgrupo_material, 0),
					coalesce(cd_classe_material, 0),
					coalesce(cd_material, 0);
					
				if (qt_existe_w > 0) then
					ie_envia_email_w := 'S';
				end if;
				end;
			end loop;
			close C01;

			select	coalesce(sum(qt_material * coalesce(vl_unit_previsto,0)),0)
			into STRICT	vl_total_documento_w
			from	solic_compra_item
			where	nr_solic_compra = nr_documento_w;

		elsif (ie_tipo_w = 'C') and		/*APROVACAO DA COTACAO DE COMPRAS*/
			(nr_documento_w > 0) then

			open C03;
			loop
			fetch C03 into
				cd_material_w;
			exit when(C03%notfound or ie_envia_email_w = 'S');
				begin
				
				select	cd_grupo_material,
					cd_subgrupo_material,
					cd_classe_material,
					ie_consignado
				into STRICT	cd_grupo_material_w,
					cd_subgrupo_material_w,
					cd_classe_material_w,
					ie_consignado_w
				from	estrutura_material_v
				where	cd_material = cd_material_w;
				
				select	count(*),
					max(coalesce(vl_minimo_documento,0)),
					max(coalesce(vl_maximo_documento,0))
				into STRICT	qt_existe_w,
					vl_minimo_documento_w,
					vl_maximo_documento_w
				from	envio_email_compra_filtro
				where	nr_seq_regra = nr_seq_regra_w
				and	coalesce(ie_envia_email,'S') = 'S'
				and	coalesce(cd_grupo_material,cd_grupo_material_w) = cd_grupo_material_w
				and	coalesce(cd_subgrupo_material,cd_subgrupo_material_w) = cd_subgrupo_material_w
				and	coalesce(cd_classe_material,cd_classe_material_w) = cd_classe_material_w
				and	coalesce(cd_material,cd_material_w) = cd_material_w
				and	((coalesce(ie_consignado,'A') = 'A') or
					((coalesce(ie_consignado,'A') = 'N') and (ie_consignado_w = '0')) or
					((coalesce(ie_consignado,'A') = 'S') and (ie_consignado_w = '1')))
				order by
					coalesce(ie_consignado,0),
					coalesce(cd_grupo_material, 0),
					coalesce(cd_subgrupo_material, 0),
					coalesce(cd_classe_material, 0),
					coalesce(cd_material, 0);

				if (qt_existe_w > 0) then
					ie_envia_email_w := 'S';
				end if;
				end;
			end loop;
			close C03;

			select	coalesce(sum(vl_preco_liquido),0)
			into STRICT	vl_total_documento_w
			from	cot_compra_resumo
			where	nr_cot_compra = nr_documento_w;

		elsif (ie_tipo_w = 'R') and		/*APROVACAO DA REQUISICAO DE MATERIAIS*/
			(nr_documento_w > 0) then
			
			open C04;
			loop
			fetch C04 into	
				cd_local_estoque_w,
				cd_centro_custo_w,
				cd_material_w;
			exit when(C04%notfound or ie_envia_email_w = 'S');
				begin
				
				select	cd_grupo_material,
					cd_subgrupo_material,
					cd_classe_material,
					ie_consignado
				into STRICT	cd_grupo_material_w,
					cd_subgrupo_material_w,
					cd_classe_material_w,
					ie_consignado_w
				from	estrutura_material_v
				where	cd_material = cd_material_w;
				
				select	count(*),
					max(coalesce(vl_minimo_documento,0)),
					max(coalesce(vl_maximo_documento,0))
				into STRICT	qt_existe_w,
					vl_minimo_documento_w,
					vl_maximo_documento_w
				from	envio_email_compra_filtro
				where	nr_seq_regra = nr_seq_regra_w
				and	coalesce(ie_envia_email,'S') = 'S'
				and	((coalesce(cd_local_estoque::text, '') = '') or (coalesce(cd_local_estoque, cd_local_estoque_w) = cd_local_estoque_w))
				and	((coalesce(cd_centro_custo::text, '') = '') or (coalesce(cd_centro_custo, cd_centro_custo_w) = cd_centro_custo_w))
				and	coalesce(cd_grupo_material,cd_grupo_material_w) = cd_grupo_material_w
				and	coalesce(cd_subgrupo_material,cd_subgrupo_material_w) = cd_subgrupo_material_w
				and	coalesce(cd_classe_material,cd_classe_material_w) = cd_classe_material_w
				and	coalesce(cd_material,cd_material_w) = cd_material_w
				and	((coalesce(ie_consignado,'A') = 'A') or
					((coalesce(ie_consignado,'A') = 'N') and (ie_consignado_w = '0')) or
					((coalesce(ie_consignado,'A') = 'S') and (ie_consignado_w = '1')))
				order by
					coalesce(cd_local_estoque,0),
					coalesce(cd_centro_custo,0),
					coalesce(ie_consignado,0),
					coalesce(cd_grupo_material, 0),
					coalesce(cd_subgrupo_material, 0),
					coalesce(cd_classe_material, 0),
					coalesce(cd_material, 0);
					
				if (qt_existe_w > 0) then
					ie_envia_email_w := 'S';
				end if;
				end;
			end loop;
			close C04;
		end if;

	elsif (ie_envia_email_w = 'N') and (ie_tipo_documento_p = 'CM') then	/*CADASTRO MATERIAIS*/
		select	a.cd_grupo_material,
			a.cd_subgrupo_material,
			a.cd_classe_material,
			a.cd_material,
			a.ie_consignado
		into STRICT	cd_grupo_material_w,
			cd_subgrupo_material_w,
			cd_classe_material_w,
			cd_material_w,
			ie_consignado_w
		from	estrutura_material_v a
		where	a.cd_material = nr_documento_w;
			
		select	count(*),
			max(coalesce(vl_minimo_documento,0)),
			max(coalesce(vl_maximo_documento,0))
		into STRICT	qt_existe_w,
			vl_minimo_documento_w,
			vl_maximo_documento_w
		from	envio_email_compra_filtro
		where	nr_seq_regra = nr_seq_regra_w
		and	coalesce(ie_envia_email,'S') = 'S'
		and	coalesce(cd_grupo_material,cd_grupo_material_w) = cd_grupo_material_w
		and	coalesce(cd_subgrupo_material,cd_subgrupo_material_w) = cd_subgrupo_material_w
		and	coalesce(cd_classe_material,cd_classe_material_w) = cd_classe_material_w
		and	coalesce(cd_material,cd_material_w) = cd_material_w
		and	((coalesce(ie_consignado,'A') = 'A') or
			((coalesce(ie_consignado,'A') = 'N') and (ie_consignado_w = '0')) or
			((coalesce(ie_consignado,'A') = 'S') and (ie_consignado_w = '1')))
		order by	
			coalesce(ie_consignado,0),
			coalesce(cd_grupo_material, 0),
			coalesce(cd_subgrupo_material, 0),
			coalesce(cd_classe_material, 0),
			coalesce(cd_material, 0);
				
		if (qt_existe_w > 0) then
			ie_envia_email_w := 'S';
		end if;		
	elsif (ie_envia_email_w = 'N') and (ie_tipo_documento_p = 'RM') then	/* REQUISICAO MATERIAIS */
		open c06;
		loop
		fetch c06 into	
			cd_local_estoque_w,
			cd_centro_custo_w,
			cd_material_w;
		exit when(c06%notfound or ie_envia_email_w = 'S');
			begin

			select	cd_grupo_material,
				cd_subgrupo_material,
				cd_classe_material,
				ie_consignado
			into STRICT	cd_grupo_material_w,
				cd_subgrupo_material_w,
				cd_classe_material_w,
				ie_consignado_w
			from	estrutura_material_v
			where	cd_material = cd_material_w;

			select	count(*),
				max(coalesce(vl_minimo_documento,0)),
				max(coalesce(vl_maximo_documento,0))
			into STRICT	qt_existe_w,
				vl_minimo_documento_w,
				vl_maximo_documento_w
			from	envio_email_compra_filtro
			where	nr_seq_regra = nr_seq_regra_w
			and	coalesce(ie_envia_email,'S') = 'S'
			and	((coalesce(cd_local_estoque::text, '') = '') or (coalesce(cd_local_estoque, cd_local_estoque_w) = cd_local_estoque_w))
			and	((coalesce(cd_centro_custo::text, '') = '') or (coalesce(cd_centro_custo, cd_centro_custo_w) = cd_centro_custo_w))
			and	coalesce(cd_grupo_material,cd_grupo_material_w) = cd_grupo_material_w
			and	coalesce(cd_subgrupo_material,cd_subgrupo_material_w) = cd_subgrupo_material_w
			and	coalesce(cd_classe_material,cd_classe_material_w) = cd_classe_material_w
			and	coalesce(cd_material,cd_material_w) = cd_material_w
			and	((coalesce(ie_consignado,'A') = 'A') or
				((coalesce(ie_consignado,'A') = 'N') and (ie_consignado_w = '0')) or
				((coalesce(ie_consignado,'A') = 'S') and (ie_consignado_w = '1')))
			order by
				coalesce(cd_local_estoque,0),
				coalesce(cd_centro_custo,0),
				coalesce(ie_consignado,0),
				coalesce(cd_grupo_material, 0),
				coalesce(cd_subgrupo_material, 0),
				coalesce(cd_classe_material, 0),
				coalesce(cd_material, 0);

			if (qt_existe_w > 0) then
				ie_envia_email_w := 'S';
			end if;
			end;
		end loop;
		close c06;
	end if;

	if (ie_envia_email_w = 'S') and (vl_total_documento_w > 0)  and (vl_minimo_documento_w > 0) and (vl_minimo_documento_w > vl_total_documento_w) then
		ie_envia_email_w := 'N';
	end if;
	
	if (ie_envia_email_w = 'S') and (vl_total_documento_w > 0)  and (vl_maximo_documento_w > 0) and (vl_maximo_documento_w < vl_total_documento_w) then
		ie_envia_email_w := 'N';
	end if;
	
	end;
end loop;
close C00;


return	ie_envia_email_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_envia_email_regra ( nr_documento_p bigint, ie_tipo_documento_p text, ie_tipo_mensagem_p bigint, cd_estabelecimento_p bigint, nr_seq_regra_p bigint default 0, nr_seq_aprovacao_p bigint default 0, nr_seq_proc_aprov_p bigint default 0) FROM PUBLIC;
