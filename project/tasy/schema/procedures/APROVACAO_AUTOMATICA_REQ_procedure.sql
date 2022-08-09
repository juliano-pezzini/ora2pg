-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE aprovacao_automatica_req ( nr_sequencia_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_seq_proc_aprov_w			processo_aprov_compra.nr_seq_proc_aprov%type	:= 0;
vl_minimo_w				Processo_aprov_Resp.vl_minimo%type		:= 0;
vl_maximo_w				Processo_aprov_Resp.vl_maximo%type		:= 0;
vl_ordem_compra_w			ordem_compra_item.vl_item_liquido%type		:= 0;
vl_solic_compra_w				solic_compra_item.vl_unit_previsto%type		:= 0;
vl_requisicao_w				item_requisicao_material.vl_unit_previsto%type	:= 0;
nr_ordem_compra_w			ordem_compra.nr_ordem_compra%type;
nr_solic_compra_w				solic_compra.nr_solic_compra%type;
cd_estabelecimento_w			estabelecimento.cd_estabelecimento%type;
ie_valor_maximo_aprov_w			parametro_compras.ie_valor_maximo_aprov%type 	:= 'N';
cd_moeda_padrao_w			parametro_compras.cd_moeda_padrao%type;
cd_moeda_w				parametro_compras.cd_moeda_padrao%type;
ie_aprov_regra_minimo_w			parametro_compras.ie_aprov_regra_minimo%type;
nr_requisicao_w				requisicao_material.nr_requisicao%type;
nr_cot_compra_w				cot_compra.nr_cot_compra%type;
vl_cotacao_w				cotacao_moeda.vl_cotacao%type		:= 0;
vl_nota_fiscal_w				nota_fiscal_item.vl_liquido%type		:= 0;
nr_sequencia_w				nota_fiscal.nr_sequencia%type;
ie_teto_aprovacao_w			parametro_compras.ie_teto_aprovacao%type;
vl_total_licitacao_w				reg_lic_item.vl_maximo_edital%type		:= 0;	
nr_seq_licitacao_w				reg_licitacao.nr_sequencia%type;
nr_seq_contrato_w			contrato.nr_sequencia%type;
vl_total_contrato_w			contrato.vl_total_contrato%type;
nr_seq_projeto_w 			projeto_recurso.nr_sequencia%type;
vl_projeto_w				projeto_recurso.vl_projeto%type;
ie_requisicao_w 			processo_aprov_resp.ie_requisicao%type;
qt_itens_regra_w			processo_aprov_resp.qt_itens_regra%type;
qt_intervalo_regra_w			processo_aprov_resp.qt_intervalo_regra%type;
cd_processo_aprov_w			item_requisicao_material.cd_processo_aprov%type;
qt_total_itens_req_w			item_requisicao_material.qt_material_requisitada%type;
qt_material_requisitada_w		item_requisicao_material.qt_material_requisitada%type;
nr_documento_w            		processo_aprov_compra.nr_documento%type;


c01 CURSOR FOR
SELECT	nr_seq_proc_aprov /*Para aprovar todos os procesos inferiores ao cargo da pessoa*/
from	processo_aprov_compra
where 	nr_sequencia	= nr_sequencia_p
and	ie_aprov_regra_minimo_w	in ('N','A','T')
and	nr_seq_proc_aprov <= (
	SELECT	coalesce(max(x.nr_seq_proc_aprov),0)
	from	Processo_aprov_Compra x
	where	x.nr_sequencia	= nr_sequencia_p
	and	((obter_se_proc_usu_fixo(x.nr_seq_proc_aprov, nm_usuario_p, nr_sequencia_p) = 'F') or
		 (cd_cargo = (	select	coalesce(cd_cargo,0)
				from	pessoa_fisica b,
					usuario a
				where	a.cd_pessoa_fisica = b.cd_pessoa_fisica
				and	a.nm_usuario  = nm_usuario_p))))

union all

select	nr_seq_proc_aprov
from	processo_aprov_compra
where 	nr_sequencia	= nr_sequencia_p
and	ie_aprov_regra_minimo_w	= 'S'
and	nr_seq_proc_aprov = (
	select	coalesce(max(x.nr_seq_proc_aprov),0)
	from	Processo_aprov_Compra x
	where	x.nr_sequencia	= nr_sequencia_p
	and	((obter_se_proc_usu_fixo(x.nr_seq_proc_aprov, nm_usuario_p, nr_sequencia_p) = 'F') or
		 (cd_cargo = (	select	coalesce(cd_cargo,0)
				from	pessoa_fisica b,
					usuario a
				where	a.cd_pessoa_fisica = b.cd_pessoa_fisica
				and	a.nm_usuario  = nm_usuario_p))))
order by 1;	

c02 CURSOR FOR
SELECT	a.nr_seq_proc_aprov,
	coalesce(a.vl_minimo, 0),
	coalesce(a.vl_maximo, 9999999999999),
	CASE WHEN a.ie_tipo='R' THEN  'S'  ELSE 'N' END  ie_tipo,
	a.qt_itens_regra,
	a.qt_intervalo_regra
from	Processo_compra b,
	Processo_aprov_Compra a
where 	a.nr_sequencia		= nr_sequencia_p
and	a.nr_sequencia		= b.nr_sequencia
and	a.nr_documento		= nr_documento_w
and (SELECT obter_estrutura_aprovacao(a.nr_seq_proc_aprov, nr_documento_w) ) = 1

union

select	a.nr_seq_proc_aprov,
	coalesce(c.vl_minimo, 0),
	coalesce(c.vl_maximo, 9999999999999),
	c.ie_requisicao,
	c.qt_itens_regra,
	c.qt_intervalo_regra
from	Processo_aprov_Resp c,
	Processo_compra b,
	Processo_aprov_Compra a
where 	a.nr_sequencia		= nr_sequencia_p
and	a.nr_sequencia		= b.nr_sequencia
and	b.cd_processo_aprov	= c.cd_processo_aprov
and	a.nr_seq_proc_aprov 	= c.nr_sequencia
and (select obter_estrutura_aprovacao(a.nr_seq_proc_aprov, nr_documento_w) ) = 0
order by 1;	


BEGIN

select	coalesce(max(obter_estab_processo_aprov(nr_sequencia_p)), 1)
into STRICT	cd_estabelecimento_w
;

select	coalesce(ie_aprov_regra_minimo, 'N')
into STRICT	ie_aprov_regra_minimo_w
from	parametro_compras
where	cd_estabelecimento	= cd_estabelecimento_w;

select	max(nr_documento)
into STRICT	nr_documento_w
from	processo_aprov_compra
where 	nr_sequencia = nr_sequencia_p
and     cd_pessoa_fisica = obter_pessoa_fisica_usuario(nm_usuario_p,'C');

open c01;
loop
fetch c01 into
	nr_seq_proc_aprov_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	CALL aprovar_compra( nr_sequencia_p, nr_seq_proc_aprov_w, nm_usuario_p, 'S', 'N');
	end;
end loop;
close c01;

open c02;
loop
fetch c02 into
	nr_seq_proc_aprov_w,
	vl_minimo_w,
	vl_maximo_w,
	ie_requisicao_w,
	qt_itens_regra_w,
	qt_intervalo_regra_w;
EXIT WHEN NOT FOUND; /* apply on c02 */
	begin
	begin
	select	coalesce(sum(coalesce(vl_unit_previsto,0) * coalesce(qt_material,0)),0),
		coalesce(max(nr_solic_compra),0)
	into STRICT	vl_solic_compra_w,
		nr_solic_compra_w
	from	solic_compra_item
	where	nr_seq_aprovacao = nr_sequencia_p;
	exception
		when others then
			vl_solic_compra_w		:= 0;
	end;
	
	begin
	select	coalesce(sum(vl_item_liquido),0),
		coalesce(max(nr_ordem_compra),0)
	into STRICT	vl_ordem_compra_w,
		nr_ordem_compra_w
	from	ordem_compra_item	
	where	nr_seq_aprovacao = nr_sequencia_p;
	exception
		when others then
			vl_ordem_compra_w	:= 0;
	end;
	
	begin
	select	coalesce(sum(vl_liquido),0),
		coalesce(max(nr_Sequencia),0)
	into STRICT	vl_nota_fiscal_w,
		nr_sequencia_w
	from	nota_fiscal_item	
	where	nr_seq_aprovacao = nr_sequencia_p;
	exception
		when others then
			vl_nota_fiscal_w	:= 0;
	end;
	
	begin
	select	coalesce(sum(coalesce(vl_unit_previsto,0) * coalesce(qt_estoque,0)),0),
		coalesce(max(nr_requisicao),0),
		max(cd_processo_aprov),
		max(qt_material_requisitada)
	into STRICT	vl_requisicao_w,
		nr_requisicao_w,
		cd_processo_aprov_w,
		qt_material_requisitada_w
	from	item_requisicao_material
	where	nr_seq_aprovacao = nr_sequencia_p
	group by vl_unit_previsto,
		 qt_estoque,
		 nr_requisicao,
		 cd_processo_aprov,
		 qt_material_requisitada;
	exception
		when others then
			vl_requisicao_w		:= 0;
	end;
	
	begin
	select	coalesce(sum(coalesce(vl_maximo_edital,0) * coalesce(qt_item,0)),0),
		coalesce(max(nr_seq_licitacao),0)
	into STRICT	vl_total_licitacao_w,
		nr_seq_licitacao_w
	from	reg_lic_item
	where	nr_seq_aprovacao = nr_sequencia_p;
	exception
		when others then
			vl_total_licitacao_w		:= 0;
	end;
	
	begin
	select	coalesce(sum(a.vl_preco_liquido),0),
		coalesce(max(a.nr_cot_compra),0)
	into STRICT	vl_cotacao_w,
		nr_cot_compra_w
	from	cot_compra_resumo a,
		cot_compra_item b
	where	a.nr_cot_compra = b.nr_cot_compra
	and	a.nr_item_cot_compra = b.nr_item_cot_compra
	and	b.nr_seq_aprovacao = nr_sequencia_p;
	exception
		when others then
			vl_cotacao_w		:= 0;
	end;

	begin
	select	coalesce(sum(vl_total_contrato),0),
		coalesce(max(nr_sequencia),0)
	into STRICT	vl_total_contrato_w,
		nr_seq_contrato_w
	from	contrato
	where	nr_seq_aprovacao = nr_sequencia_p;
	exception
	when no_data_found then
		vl_total_contrato_w := 0;
	end;	

	begin
	select	coalesce(sum(vl_projeto),0),
		coalesce(max(nr_sequencia),0)
	into STRICT	vl_projeto_w,
		nr_seq_projeto_w
	from	projeto_recurso
	where	nr_seq_aprovacao = nr_sequencia_p;
	exception
	when no_data_found then
		vl_projeto_w := 0;
	end;

	if (nr_requisicao_w > 0 and ie_requisicao_w = 'S' AND qt_itens_regra_w IS NOT NULL AND qt_itens_regra_w::text <> '' AND qt_intervalo_regra_w IS NOT NULL AND qt_intervalo_regra_w::text <> '') then
		
		select coalesce(sum(b.qt_material_requisitada), 0)
		into STRICT   qt_total_itens_req_w
		from requisicao_material a,
		item_requisicao_material b,
		processo_aprovacao c
		where a.nr_requisicao = b.nr_requisicao
		and b.cd_processo_aprov = c.cd_processo_aprov
		and ((a.dt_aprovacao IS NOT NULL AND a.dt_aprovacao::text <> '') and (round((clock_timestamp() - a.dt_aprovacao) * 24) <= qt_intervalo_regra_w))
		and b.cd_processo_aprov = cd_processo_aprov_w;	
		
		if ((qt_material_requisitada_w + qt_total_itens_req_w) <= qt_itens_regra_w) then
			CALL aprovar_compra(nr_sequencia_p, nr_seq_proc_aprov_w, nm_usuario_p, 'S', 'N');
		end if;
		
	end if;
	
	if (nr_solic_compra_w > 0) then
		select	coalesce(max(cd_estabelecimento),0)
		into STRICT	cd_estabelecimento_w
		from	solic_compra
		where	nr_solic_compra = nr_solic_compra_w;
	elsif (nr_ordem_compra_w > 0) then
		select	coalesce(max(cd_estabelecimento),0)
		into STRICT	cd_estabelecimento_w
		from	ordem_compra
		where	nr_ordem_compra = nr_ordem_compra_w;
	elsif (nr_requisicao_w > 0) then
		select	coalesce(max(cd_estabelecimento), 0)
		into STRICT	cd_estabelecimento_w
		from	requisicao_material
		where	nr_requisicao = nr_requisicao_w;
	elsif (nr_Sequencia_w > 0) then
		select	coalesce(max(cd_estabelecimento), 0)
		into STRICT	cd_estabelecimento_w
		from	nota_fiscal
		where	nr_Sequencia = nr_Sequencia_w;
	elsif (nr_cot_compra_w > 0) then
		select	coalesce(max(cd_estabelecimento), 0)
		into STRICT	cd_estabelecimento_w
		from	cot_compra
		where	nr_cot_compra = nr_cot_compra_w;
	elsif (nr_seq_licitacao_w > 0) then
		select	coalesce(max(cd_estabelecimento), 0)
		into STRICT	cd_estabelecimento_w
		from	reg_licitacao
		where	nr_sequencia = nr_seq_licitacao_w;
	elsif (nr_seq_contrato_w > 0) then
		select	coalesce(max(cd_estabelecimento), 0)
		into STRICT	cd_estabelecimento_w
		from	contrato
		where	nr_sequencia = nr_seq_contrato_w;
	elsif (nr_seq_projeto_w > 0) then
		select	coalesce(max(cd_estabelecimento), 0)
		into STRICT	cd_estabelecimento_w
		from	projeto_recurso
		where	nr_sequencia = nr_seq_projeto_w;
	end if;
		
	if (cd_estabelecimento_w > 0) then
		select	coalesce(max(ie_valor_maximo_aprov),'N'),
			coalesce(max(ie_teto_aprovacao),'N'),
			coalesce(max(cd_moeda_padrao), 0)			
		into STRICT	ie_valor_maximo_aprov_w,
			ie_teto_aprovacao_w,
			cd_moeda_padrao_w
		from	parametro_compras
		where	cd_estabelecimento = cd_estabelecimento_w;
	end if;

	/*Tratamento para valores com moeda estrangeira na OC*/

	if (nr_ordem_compra_w > 0) then
		begin
		select	coalesce(max(cd_moeda), 0)
		into STRICT	cd_moeda_w
		from	ordem_compra
		where	nr_ordem_compra	= nr_ordem_compra_w;

		if (coalesce(cd_moeda_w, 0) <> coalesce(cd_moeda_padrao_w, 0)) then

			begin
			vl_ordem_compra_w	:= obter_conversao_moeda(
							vl_ordem_compra_w,
							cd_moeda_w,
							clock_timestamp(),
							'EN');
			exception
				when others then
					vl_ordem_compra_w	:= vl_ordem_compra_w;
			end;
		end if;
		end;
	end if;
	
	if (ie_teto_aprovacao_w = 'N') then

		if (ie_valor_maximo_aprov_w = 'S') then
			if	(((vl_ordem_compra_w + vl_solic_compra_w + vl_requisicao_w + vl_cotacao_w + vl_nota_fiscal_w + vl_total_licitacao_w + vl_total_contrato_w + vl_projeto_w) < vl_minimo_w) or
				((vl_ordem_compra_w + vl_solic_compra_w + vl_requisicao_w + vl_cotacao_w + vl_nota_fiscal_w + vl_total_licitacao_w + vl_total_contrato_w + vl_projeto_w) > vl_maximo_w)) then
				CALL aprovar_compra(nr_sequencia_p, nr_seq_proc_aprov_w, nm_usuario_p, 'S', 'N');
			end if;
		else
			if	((vl_ordem_compra_w + vl_solic_compra_w + vl_requisicao_w + vl_cotacao_w + vl_nota_fiscal_w + vl_total_licitacao_w + vl_total_contrato_w + vl_projeto_w) < vl_minimo_w) then
				CALL aprovar_compra( nr_sequencia_p, nr_seq_proc_aprov_w, nm_usuario_p, 'S', 'N');
			end if;
		end if;

	else
		
		if	((vl_ordem_compra_w + vl_solic_compra_w + vl_requisicao_w + vl_cotacao_w + vl_nota_fiscal_w + vl_total_licitacao_w + vl_total_contrato_w + vl_projeto_w) < vl_minimo_w) then
			CALL aprovar_compra( nr_sequencia_p, nr_seq_proc_aprov_w, nm_usuario_p, 'S', 'N');
		end if;		
		
	end if;
	end;
end loop;
close c02;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE aprovacao_automatica_req ( nr_sequencia_p bigint, nm_usuario_p text) FROM PUBLIC;
