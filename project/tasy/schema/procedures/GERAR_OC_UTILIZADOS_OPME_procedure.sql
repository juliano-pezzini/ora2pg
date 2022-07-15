-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_oc_utilizados_opme ( cd_material_p bigint, cd_fornecedor_p text, qt_material_p bigint, vl_material_p bigint, nr_seq_agenda_pac_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) AS $body$
DECLARE


nr_ordem_compra_w		bigint;
cd_comprador_consig_w		varchar(10);
cd_condicao_pagamento_padrao_w	bigint;
cd_moeda_padrao_w		bigint;
qt_dias_entrega_oc_consig_w	integer;
cd_centro_custo_w		integer;
cd_local_estoque_w		smallint;
ie_frete_w			varchar(1);
nr_item_oci_w			integer;
cd_conta_contabil_w		varchar(20);
ie_tipo_conta_w			integer;
qt_existe_w			integer;
cd_pessoa_w			varchar(10);
cd_unidade_medida_w		varchar(30);
nr_atendimento_w		bigint;
qt_existe_mat_w			bigint;


BEGIN

cd_pessoa_w := obter_pf_usuario(nm_usuario_p,'C');

select	cd_comprador_consig,
	cd_condicao_pagamento_padrao,
	cd_moeda_padrao,
	qt_dias_entrega_oc_consig
into STRICT	cd_comprador_consig_w,
	cd_condicao_pagamento_padrao_w,
	cd_moeda_padrao_w,
	qt_dias_entrega_oc_consig_w
from	parametro_compras
where	cd_estabelecimento = cd_estabelecimento_p;

select 	coalesce(max(cd_centro_custo),0),
	coalesce(max(cd_local_estoque),0)
into STRICT	cd_centro_custo_w,
	cd_local_estoque_w	
from	parametros_opme
where	cd_estabelecimento = cd_estabelecimento_p;

select	coalesce(max(ie_frete),'C')
into STRICT	ie_frete_w
from	pessoa_juridica_estab
where	cd_cgc = cd_fornecedor_p
and	cd_estabelecimento = cd_estabelecimento_p;

if (coalesce(cd_comprador_consig_w::text, '') = '') then
	--Favor informar o campo Comprador consignado nos parametros de compras.
	CALL wheb_mensagem_pck.exibir_mensagem_abort(217470);
end if;

if (coalesce(cd_condicao_pagamento_padrao_w::text, '') = '') then
	--Favor informar o campo Cond. pagamento nos parametros de compras.
	CALL wheb_mensagem_pck.exibir_mensagem_abort(217471);
end if;

if (coalesce(cd_moeda_padrao_w::text, '') = '') then
	--Favor informar o campo Moeda nos parametros de compras.
	CALL wheb_mensagem_pck.exibir_mensagem_abort(217472);
end if;

if (cd_centro_custo_w = 0) then
	--Favor informar o campo Centro custo Ordem compra nos parametros de OPME.
	CALL wheb_mensagem_pck.exibir_mensagem_abort(217473);
end if;

if (cd_local_estoque_w = 0) then
	--Favor informar o campo Local estoque Ordem compra nos parametros de OPME.
	CALL wheb_mensagem_pck.exibir_mensagem_abort(217474);
end if;

select	coalesce(max(nr_ordem_compra),0)
into STRICT	nr_ordem_compra_w
from	ordem_compra
where	nr_seq_agenda_pac = nr_seq_agenda_pac_p
and	cd_cgc_fornecedor = cd_fornecedor_p
and	coalesce(nr_seq_motivo_cancel::text, '') = ''
and 	coalesce(dt_aprovacao::text, '') = ''
and 	coalesce(dt_liberacao::text, '') = '';

select 	max(nr_atendimento)
into STRICT	nr_atendimento_w
from	agenda_paciente
where	nr_sequencia = nr_seq_agenda_pac_p;
if (nr_ordem_compra_w = 0) then
	
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
		vl_frete,
		pr_desconto,
		pr_desc_pgto_antec,
		pr_juros_negociado,
		dt_entrega,
		ie_aviso_chegada,
		cd_pessoa_fisica,
		ie_emite_obs,
		ie_urgente,
		pr_desc_financeiro,
		vl_desconto,
		ie_somente_pagto,
		ie_tipo_ordem,
		cd_local_entrega,
		cd_centro_custo,
		nr_seq_agenda_pac,
		nr_atendimento)
	values (	nr_ordem_compra_w,
		cd_estabelecimento_p,
		cd_fornecedor_p,
		cd_condicao_pagamento_padrao_w,
		cd_comprador_consig_w,
		clock_timestamp(),
		clock_timestamp(),
		nm_usuario_p,
		cd_moeda_padrao_w,
		'A',
		clock_timestamp(),
		cd_pessoa_w,
		ie_frete_w,
		0,
		0,
		0,
		0,
		trunc(clock_timestamp() + qt_dias_entrega_oc_consig_w,'dd'),
		'N',
		null,
		'N',
		'N',
		0,
		0,
		'N',
		'H',
		cd_local_estoque_w,
		cd_centro_custo_w,
		nr_seq_agenda_pac_p,
		nr_atendimento_w);
end if;

select	count(*)
into STRICT	qt_existe_mat_w
from	ordem_compra a,
	ordem_compra_item b
where	a.nr_ordem_compra = b.nr_ordem_compra
and 	a.nr_seq_agenda_pac = nr_seq_agenda_pac_p
and	a.cd_cgc_fornecedor = cd_fornecedor_p
and 	b.cd_material = cd_material_p
and	coalesce(a.nr_seq_motivo_cancel::text, '') = '';

select	coalesce(max(nr_item_oci),0) + 1
into STRICT	nr_item_oci_w
from	ordem_compra_item
where	nr_ordem_compra = nr_ordem_compra_w;

if (coalesce(cd_conta_contabil_w::text, '') = '') then
	
	if (coalesce(cd_centro_custo_w::text, '') = '') then
		ie_tipo_conta_w	:= 2;
	else
		ie_tipo_conta_w	:= 3;
	end if;
	
	SELECT * FROM define_conta_material(	cd_estabelecimento_p, cd_material_p, ie_tipo_conta_w, null, null, null, null, null, null, null, cd_local_estoque_w, Null, clock_timestamp(), cd_conta_contabil_w, cd_centro_custo_w, null) INTO STRICT cd_conta_contabil_w, cd_centro_custo_w;
	
end if;

if (coalesce(qt_existe_mat_w,0) = 0)then

	select	coalesce(cd_unidade_medida_compra,cd_unidade_medida_consumo)
	into STRICT	cd_unidade_medida_w
	from	material
	where	cd_material = cd_material_p;

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
		cd_pessoa_solicitante,
		pr_descontos,
		cd_local_estoque,
		vl_item_liquido,
		cd_centro_custo,
		cd_conta_contabil,
		pr_desc_financ,
		vl_desconto,
		vl_total_item,
		cd_sequencia_parametro)
	values (	nr_ordem_compra_w,
		nr_item_oci_w,
		cd_material_p,
		cd_unidade_medida_w,
		vl_material_p,
		qt_material_p,
		qt_material_p,
		clock_timestamp(),
		nm_usuario_p,
		'A',
		cd_pessoa_w,
		0,
		cd_local_estoque_w,
		vl_material_p,
		cd_centro_custo_w,
		cd_conta_contabil_w,
		0,
		0,
		round((qt_material_p * vl_material_p)::numeric,4),
		philips_contabil_pck.get_parametro_conta_contabil);

	insert into ordem_compra_item_entrega(
		nr_ordem_compra,
		nr_item_oci,
		dt_prevista_entrega,
		qt_prevista_entrega,
		dt_atualizacao,
		nm_usuario,
		nr_sequencia)
	values (	nr_ordem_compra_w,
		nr_item_oci_w,
		trunc(clock_timestamp() + qt_dias_entrega_oc_consig_w,'dd'),
		qt_material_p,
		clock_timestamp(),
		nm_usuario_p,
		nextval('ordem_compra_item_entrega_seq'));
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_oc_utilizados_opme ( cd_material_p bigint, cd_fornecedor_p text, qt_material_p bigint, vl_material_p bigint, nr_seq_agenda_pac_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text) FROM PUBLIC;

