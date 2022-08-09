-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE transferir_itens_cotacao ( nr_cot_compra_p bigint, nr_item_cot_compra_p bigint, nm_usuario_p text, nr_cot_compra_nova_p INOUT bigint) AS $body$
DECLARE


qt_existe_w		integer;
nr_item_cot_compra_w	bigint;
nr_cot_compra_w		bigint;
nr_seq_cot_forn_w		bigint;
nr_seq_cot_forn_ww	bigint;
cd_cgc_fornecedor_w	varchar(14);
cd_condicao_pagamento_w	bigint;
cd_moeda_w		integer;
ie_frete_w		varchar(1);
vl_previsto_frete_w		double precision;
nr_documento_fornec_w	varchar(10);
dt_documento_w		timestamp;
ie_tipo_documento_w	varchar(1);
qt_dias_validade_w		integer;
qt_dias_entrega_w		integer;
pr_desconto_w		double precision;
pr_desconto_pgto_antec_w	double precision;
pr_juros_negociado_w	double precision;
ds_observacao_w		varchar(2000);
cd_pessoa_fisica_w	varchar(10);
ie_status_w		varchar(5);
vl_despesa_acessoria_w	double precision;
vl_desconto_w		double precision;
ie_exclusivo_w		varchar(1);
nr_solic_compra_w		bigint;
nr_item_solic_compra_w	integer;


c01 CURSOR FOR
SELECT	a.nr_sequencia,
	a.cd_cgc_fornecedor,
	a.cd_condicao_pagamento,
	a.cd_moeda,
	a.ie_frete,
	a.vl_previsto_frete,
	a.nr_documento_fornec,
	a.dt_documento,
	a.ie_tipo_documento,
	a.qt_dias_validade,
	a.qt_dias_entrega,
	a.pr_desconto,
	a.pr_desconto_pgto_antec,
	a.pr_juros_negociado,
	a.ds_observacao,
	a.cd_pessoa_fisica,
	a.ie_status,
	a.vl_despesa_acessoria,
	a.vl_desconto,
	a.ie_exclusivo
from	cot_compra_forn a
where	a.nr_cot_compra = nr_cot_compra_p
and exists (
	SELECT	1
	from	cot_compra_forn_item b
	where	b.nr_seq_cot_forn = a.nr_sequencia
	and	b.nr_item_cot_compra = nr_item_cot_compra_p)
order by
	coalesce(a.cd_cgc_fornecedor, a.cd_pessoa_fisica);


BEGIN

if (coalesce(nr_cot_compra_nova_p, 0) > 0) then
	select	count(*)
	into STRICT	qt_existe_w
	from	cot_compra
	where	nr_cot_compra = nr_cot_compra_nova_p;
	if (qt_existe_w = 0) then		
		CALL wheb_mensagem_pck.exibir_mensagem_abort(248287,'NR_COT_COMPRA_NOVA='||nr_cot_compra_nova_p);
	end if;
end if;

nr_cot_compra_w		:= nr_cot_compra_nova_p;

if (coalesce(nr_cot_compra_nova_p, 0) = 0) then
	select	nextval('cot_compra_seq')
	into STRICT	nr_cot_compra_w
	;
	nr_cot_compra_nova_p	:= nr_cot_compra_w;

	insert into cot_compra(
		nr_cot_compra,
		dt_cot_compra,
		dt_atualizacao,
		cd_comprador,
		nm_usuario,
		ds_observacao,
		cd_pessoa_solicitante,
		cd_estabelecimento,
		ie_finalidade_cotacao)
	SELECT	nr_cot_compra_w,
		clock_timestamp(),
		clock_timestamp(),
		cd_comprador,
		nm_usuario_p,
		ds_observacao,
		cd_pessoa_solicitante,
		cd_estabelecimento,
		coalesce(ie_finalidade_cotacao,'C')
	from	cot_compra
	where	nr_cot_compra = nr_cot_compra_p;
		
end if;

select	coalesce(max(nr_item_cot_compra), 0) + 1
into STRICT	nr_item_cot_compra_w
from	cot_compra_item
where	nr_cot_compra = nr_cot_compra_nova_p;

insert into cot_compra_item(
	nr_cot_compra,
	nr_item_cot_compra,	
	cd_material,
	qt_material,
	cd_unidade_medida_compra,
	dt_atualizacao,
	dt_limite_entrega,
	nm_usuario,
	ie_situacao,
	ds_material_direto_w,
	ie_regra_preco,
	nr_solic_compra,
	nr_item_solic_compra,
	cd_estab_item)
SELECT	nr_cot_compra_w,
	nr_item_cot_compra_w,
	cd_material,
	qt_material,
	cd_unidade_medida_compra,
	clock_timestamp(),
	dt_limite_entrega,
	nm_usuario_p,
	ie_situacao,
	ds_material_direto_w,
	ie_regra_preco,
	nr_solic_compra,
	nr_item_solic_compra,
	cd_estab_item
from	cot_compra_item
where	nr_cot_compra = nr_cot_compra_p
and	nr_item_cot_compra = nr_item_cot_compra_p;

update	cot_compra_anexo
set		nr_cot_compra = nr_cot_compra_w,
		nr_item_cot_compra = nr_item_cot_compra_w
where	nr_cot_compra = nr_cot_compra_p
and		nr_item_cot_compra = nr_item_cot_compra_p;

CALL gerar_cot_compra_item_entrega(nr_cot_compra_w, nr_item_cot_compra_w, nm_usuario_p);

open C01;
loop
fetch C01 into
	nr_seq_cot_forn_ww,
	cd_cgc_fornecedor_w,
	cd_condicao_pagamento_w,
	cd_moeda_w,
	ie_frete_w,
	vl_previsto_frete_w,
	nr_documento_fornec_w,
	dt_documento_w,
	ie_tipo_documento_w,
	qt_dias_validade_w,
	qt_dias_entrega_w,
	pr_desconto_w,
	pr_desconto_pgto_antec_w,
	pr_juros_negociado_w,
	ds_observacao_w,
	cd_pessoa_fisica_w,
	ie_status_w,
	vl_despesa_acessoria_w,
	vl_desconto_w,
	ie_exclusivo_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	if (cd_cgc_fornecedor_w IS NOT NULL AND cd_cgc_fornecedor_w::text <> '') then
		select	coalesce(max(nr_sequencia), 0)
		into STRICT	nr_seq_cot_forn_w
		from	cot_compra_forn
		where	nr_cot_compra = nr_cot_compra_w
		and	cd_cgc_fornecedor = cd_cgc_fornecedor_w;
	elsif (cd_pessoa_fisica_w IS NOT NULL AND cd_pessoa_fisica_w::text <> '') then
		select	coalesce(max(nr_sequencia), 0)
		into STRICT	nr_seq_cot_forn_w
		from	cot_compra_forn
		where	nr_cot_compra = nr_cot_compra_w
		and	cd_pessoa_fisica = cd_pessoa_fisica_w;
	end if;

	if (nr_seq_cot_forn_w = 0) then
		begin

		select	nextval('cot_compra_forn_seq')
		into STRICT	nr_seq_cot_forn_w
		;

		insert into cot_compra_forn(
			nr_sequencia,
			nr_cot_compra,
			cd_cgc_fornecedor,
			cd_condicao_pagamento,
			cd_moeda,
			ie_frete,
			dt_atualizacao,
			nm_usuario,
			vl_previsto_frete,
			nr_documento_fornec,
			dt_documento,
			ie_tipo_documento,
			qt_dias_validade,
			qt_dias_entrega,
			pr_desconto,
			pr_desconto_pgto_antec,
			pr_juros_negociado,
			ds_observacao,
			cd_pessoa_fisica,
			ie_status,
			vl_despesa_acessoria,
			vl_desconto,
			ie_exclusivo)
		values ( nr_seq_cot_forn_w,
			nr_cot_compra_w,
			cd_cgc_fornecedor_w,
			cd_condicao_pagamento_w,
			cd_moeda_w,
			ie_frete_w,
			clock_timestamp(),
			nm_usuario_p,
			vl_previsto_frete_w,
			nr_documento_fornec_w,
			dt_documento_w,
			ie_tipo_documento_w,
			qt_dias_validade_w,
			qt_dias_entrega_w,
			pr_desconto_w,
			pr_desconto_pgto_antec_w,
			pr_juros_negociado_w,
			ds_observacao_w,
			cd_pessoa_fisica_w,
			ie_status_w,
			vl_despesa_acessoria_w,
			vl_desconto_w,
			ie_exclusivo_w);

		end;
	end if;

	insert into cot_compra_forn_item(
		nr_sequencia,
		nr_cot_compra,
		nr_item_cot_compra,
		cd_cgc_fornecedor,
		qt_material,
		vl_unitario_material,
		dt_atualizacao,
		nm_usuario,
		pr_desconto,
		vl_frete_rateio,
		vl_preco_liquido,
		vl_total_liquido_item,
		ds_observacao,
		vl_presente,
		ds_marca,
		ds_marca_fornec,
		qt_prioridade,
		vl_unid_fornec,
		qt_conv_unid_fornec,
		ds_material_direto,
		ie_situacao,
		dt_validade,
		nr_seq_cot_forn,
		cd_motivo_falta_preco,
		vl_preco,
		cd_material,
		vl_unitario_liquido,
		vl_desconto,
		vl_unitario_inicial)
	SELECT	nextval('cot_compra_forn_item_seq'),
		nr_cot_compra_w,
		nr_item_cot_compra_w,
		cd_cgc_fornecedor,
		qt_material,
		vl_unitario_material,
		clock_timestamp(),
		nm_usuario_p,
		pr_desconto,
		vl_frete_rateio,
		vl_preco_liquido,
		vl_total_liquido_item,
		ds_observacao,
		vl_presente,
		ds_marca,
		ds_marca_fornec,
		qt_prioridade,
		vl_unid_fornec,
		qt_conv_unid_fornec,
		ds_material_direto,
		ie_situacao,
		dt_validade,
		nr_seq_cot_forn_w,
		cd_motivo_falta_preco,
		vl_preco,
		cd_material,
		vl_unitario_liquido,
		vl_desconto,
		vl_unitario_inicial
	from	cot_compra_forn_item
	where	nr_seq_cot_forn = nr_seq_cot_forn_ww
	and	nr_item_cot_compra = nr_item_cot_compra_p;

	end;
end loop;
close c01;

select	coalesce(max(nr_solic_compra),0),
	coalesce(max(nr_item_solic_compra),0)
into STRICT	nr_solic_compra_w,
	nr_item_solic_compra_w
from	solic_compra_item
where	nr_cot_compra = nr_cot_compra_p
and	nr_item_cot_compra = nr_item_cot_compra_p;

delete
from	cot_compra_item
where	nr_cot_compra = nr_cot_compra_p
and	nr_item_cot_compra = nr_item_cot_compra_p;

if (nr_solic_compra_w > 0) then
	update	solic_compra_item
	set	nr_cot_compra = nr_cot_compra_w,
		nr_item_cot_compra = nr_item_cot_compra_w
	where	nr_solic_compra = nr_solic_compra_w
	and	nr_item_solic_compra = nr_item_solic_compra_w;	
end if;

/*Tratamento para excluir a cotacao se foi transferido integralmente*/

select	count(*)
into STRICT	qt_existe_w
from	cot_compra_item
where	nr_cot_compra = nr_cot_compra_p;
if (qt_existe_w = 0) then
	delete
	from	cot_compra
	where	nr_cot_compra = nr_cot_compra_p;
	
	CALL gerar_historico_cotacao(
		nr_cot_compra_nova_p,
		WHEB_MENSAGEM_PCK.get_texto(298025),
		WHEB_MENSAGEM_PCK.get_texto(298026,'NR_COT_COMPRA_P='||nr_cot_compra_p),
		'S',
		nm_usuario_p);
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE transferir_itens_cotacao ( nr_cot_compra_p bigint, nr_item_cot_compra_p bigint, nm_usuario_p text, nr_cot_compra_nova_p INOUT bigint) FROM PUBLIC;
