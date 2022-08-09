-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE cm_gera_nota_transferencia ( nr_seq_lote_transf_p bigint, cd_setor_atendimento_p bigint, nr_nota_fiscal_p bigint, cd_serie_nf_p text, cd_operacao_nf_p bigint, cd_natureza_operacao_p bigint, cd_local_estoque_p bigint, nr_seq_modelo_p bigint, ds_observacao_p text, ie_opcao_gera_item_p text, nm_usuario_p text, nr_sequencia_p INOUT bigint, ds_erro_nota_p INOUT text, ds_erro_item_p INOUT text) AS $body$
DECLARE


dt_emissao_w			timestamp;
dt_entrada_saida_w		timestamp;
nr_nota_fiscal_w			nota_fiscal.nr_nota_fiscal%type;
qt_nota_w			bigint;
cd_cgc_estab_w			varchar(14);
cd_cgc_destino_w			varchar(14);
nr_sequencia_w			bigint;
cd_material_w			integer;
cd_conta_contabil_w		varchar(20);
cd_centro_conta_w		integer;
nr_seq_cont_w			bigint;
nr_item_w			bigint;
cd_estabelecimento_w		integer;
vl_item_w			double precision;
cd_unidade_medida_estoque_w	varchar(30);
nr_item_nf_w			bigint;
ie_tipo_conta_w			smallint;
cd_centro_custo_w		integer;
qt_conv_compra_estoque_w		bigint;
ds_observacao_w			varchar(255);
cd_material_estoque_w		integer;
qt_itens_nota_w			bigint;
ds_erro_item_w			varchar(4000);
ds_erro_nota_w			varchar(4000);
nr_seq_item_conj_w		bigint;
cd_condicao_pagto_w		bigint;
cd_estab_destino_w		integer;
ds_estab_destino_w		varchar(255);
nr_seq_conjunto_w		bigint;
ie_gera_nf_calculada_w		varchar(1);
ie_existe_nota_fiscal_w    varchar(1);

c00 CURSOR FOR
SELECT	a.nr_sequencia,
	a.nr_seq_conjunto,
	c.cd_material
from	cm_conjunto_cont a,
	cm_lote_transf_conj b,
	cm_conjunto c
where	a.nr_sequencia = b.nr_seq_conjunto
and	c.nr_sequencia = a.nr_seq_conjunto
and	b.nr_seq_lote_transf = nr_seq_lote_transf_p
and	(c.cd_material IS NOT NULL AND c.cd_material::text <> '')
and	ie_opcao_gera_item_p = 'C'

union

SELECT	a.nr_sequencia,
	a.nr_seq_item,
	c.cd_material
from	cm_item_cont a,
	cm_lote_transf_conj b,
	cm_item c
where	a.nr_seq_conjunto = b.nr_seq_conjunto
and	c.nr_sequencia = a.nr_seq_item
and	b.nr_seq_lote_transf = nr_seq_lote_transf_p
and	(c.cd_material IS NOT NULL AND c.cd_material::text <> '')
and	ie_opcao_gera_item_p = 'I';

c01 CURSOR FOR
SELECT	nr_seq_conjunto
from	cm_lote_transf_conj
where	nr_seq_lote_transf = nr_seq_lote_transf_p;


BEGIN

dt_emissao_w		:= clock_timestamp();
dt_entrada_saida_w	:= clock_timestamp();

select	cd_estabelecimento,
	cd_estab_destino,
	cd_cnpj,
	substr(obter_cgc_estabelecimento(cd_estab_destino),1,14),
	cd_condicao_pagamento
into STRICT	cd_estabelecimento_w,
	cd_estab_destino_w,
	cd_cgc_estab_w,
	cd_cgc_destino_w,
	cd_condicao_pagto_w
from	cm_lote_transferencia
where	nr_sequencia = nr_seq_lote_transf_p;

ie_gera_nf_calculada_w := Obter_Param_Usuario(406, 143, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_gera_nf_calculada_w);

if (coalesce(nr_nota_fiscal_p, '0') = '0') then
	begin
	select	coalesce(max(somente_numero(nr_ultima_nf)), nr_sequencia_w) + 1
	into STRICT	nr_nota_fiscal_w
	from	serie_nota_fiscal
	where	cd_serie_nf 		= cd_serie_nf_p
	and	cd_estabelecimento 	= cd_estabelecimento_w;

	select	count(*)
	into STRICT	qt_nota_w
	from	nota_fiscal
	where	cd_estabelecimento = cd_estabelecimento_w
	and	cd_cgc_emitente = cd_cgc_estab_w
	and	cd_serie_nf = cd_serie_nf_p
	and	nr_nota_fiscal = nr_nota_fiscal_w;

	if (qt_nota_w > 0) then
		select (coalesce(max(somente_numero(nr_nota_fiscal)),'0')+1)
		into STRICT	nr_nota_fiscal_w
		from	nota_fiscal
		where	cd_estabelecimento = cd_estabelecimento_w
		and	cd_cgc_emitente = cd_cgc_estab_w
		and	cd_serie_nf = cd_serie_nf_p;
	end if;
	end;
else
	nr_nota_fiscal_w	:= nr_nota_fiscal_p;

    begin
        select  'S'
        into STRICT    ie_existe_nota_fiscal_w
        from    nota_fiscal
        where   nr_nota_fiscal = nr_nota_fiscal_w
        and     cd_serie_nf = cd_serie_nf_p  LIMIT 1;
    exception
        when no_data_found then
        ie_existe_nota_fiscal_w := 'N';
    end;

    if (ie_existe_nota_fiscal_w = 'S') then
        CALL wheb_mensagem_pck.exibir_mensagem_abort(nr_seq_mensagem_p => 202906);
    end if;
end if;

if (coalesce(cd_operacao_nf_p::text, '') = '') then
     CALL wheb_mensagem_pck.exibir_mensagem_abort(nr_seq_mensagem_p => 275240);
end if;

select	nextval('nota_fiscal_seq')
into STRICT	nr_sequencia_w
;

insert into nota_fiscal(
	nr_sequencia,		cd_estabelecimento,
	cd_cgc_emitente,		cd_serie_nf,
	nr_nota_fiscal,		nr_sequencia_nf,
	cd_operacao_nf,		dt_emissao,
	dt_entrada_saida,		ie_acao_nf,
	ie_emissao_nf,		ie_tipo_frete,
	vl_mercadoria,		vl_total_nota,
	qt_peso_bruto,		qt_peso_liquido,
	dt_atualizacao,		nm_usuario,
	cd_condicao_pagamento,	cd_cgc,
	cd_pessoa_fisica,		vl_ipi,
	vl_descontos,		vl_frete,
	vl_seguro,		vl_despesa_acessoria,
	ds_observacao,		cd_natureza_operacao,
	vl_desconto_rateio,		ie_situacao,
	nr_interno_conta,		nr_seq_protocolo,
	ds_obs_desconto_nf,	nr_seq_classif_fiscal,
	ie_tipo_nota,		nr_ordem_compra,
	ie_entregue_bloqueto,	cd_setor_digitacao,
	nr_seq_modelo,		nr_seq_transf_cme)
values ( nr_sequencia_w,		cd_estabelecimento_w,
	cd_cgc_estab_w,		cd_serie_nf_p,
	nr_nota_fiscal_w,		9,
	cd_operacao_nf_p,		dt_emissao_w,
	dt_entrada_saida_w,	'1',
	'0',			'0',
	0,			0,
	0,			0,
	clock_timestamp(),			nm_usuario_p,
	cd_condicao_pagto_w,	cd_cgc_destino_w,
	null,			0,
	0,			0,
	0,			0,
	ds_observacao_p,		cd_natureza_operacao_p,
	0,			'1',
	null,			null,
	null,			null,
	'SE',			null,
	'N',			cd_setor_atendimento_p,
	nr_seq_modelo_p,		nr_seq_lote_transf_p);

CALL gerar_historico_nota_fiscal(nr_sequencia_w, nm_usuario_p, '17', wheb_mensagem_pck.get_texto(311701));

open c00;
loop
fetch c00 into
	nr_seq_cont_w,
	nr_seq_item_conj_w,
	cd_material_w;
EXIT WHEN NOT FOUND; /* apply on c00 */
	begin

	select	coalesce(max(nr_item_nf), 0) + 1
	into STRICT	nr_item_nf_w
	from	nota_fiscal_item
	where	nr_sequencia = nr_sequencia_w;

	select	substr(obter_dados_material_estab(cd_material,cd_estabelecimento_w,'UME'),1,30) cd_unidade_medida_estoque,
		qt_conv_compra_estoque,
		cd_material_estoque
	into STRICT	cd_unidade_medida_estoque_w,
		qt_conv_compra_estoque_w,
		cd_material_estoque_w
	from	material
	where	cd_material = cd_material_w;

	select	coalesce(max(obter_custo_medio_material(cd_estabelecimento_w,trunc(clock_timestamp(),'mm'),cd_material_w)),0)
	into STRICT	vl_item_w
	;

	ie_tipo_conta_w	:= 3;
	if (coalesce(cd_centro_custo_w::text, '') = '') then
		ie_tipo_conta_w	:= 2;
	end if;

	SELECT * FROM define_conta_material(
		cd_estabelecimento_w, cd_material_w, ie_tipo_conta_w, 0, 0, 0, 0, 0, 0, 0, cd_local_estoque_p, cd_operacao_nf_p, trunc(clock_timestamp()), cd_conta_contabil_w, cd_centro_conta_w, null) INTO STRICT cd_conta_contabil_w, cd_centro_conta_w;

	if (ie_opcao_gera_item_p = 'C') then
		ds_observacao_w	:= wheb_mensagem_pck.get_texto(311703,'NR_SEQ_CONT_W='||to_char(nr_seq_cont_w));
	else
		ds_observacao_w	:= wheb_mensagem_pck.get_texto(311705,'NR_SEQ_CONT_W='||to_char(nr_seq_cont_w));
	end if;

	insert into nota_fiscal_item(
			nr_sequencia,			cd_estabelecimento,
			cd_cgc_emitente,			cd_serie_nf,
			nr_nota_fiscal,			nr_sequencia_nf,
			nr_item_nf,			cd_natureza_operacao,
			qt_item_nf,			vl_unitario_item_nf,
			vl_total_item_nf,			dt_atualizacao,
			nm_usuario,			vl_frete,
			vl_desconto,			vl_despesa_acessoria,
			cd_material,			cd_local_estoque,
			ds_observacao,			ds_complemento,
			cd_unidade_medida_compra,		qt_item_estoque,
			cd_unidade_medida_estoque,	cd_conta_contabil,
			vl_desconto_rateio,		vl_seguro,
			cd_material_estoque,		vl_liquido,
			pr_desconto,			dt_entrega_ordem,
			nr_seq_conta_financ,		pr_desc_financ,
			cd_sequencia_parametro)
		values (	nr_sequencia_w,			cd_estabelecimento_w,
			cd_cgc_estab_w,			cd_serie_nf_p,
			nr_nota_fiscal_w,			9,
			nr_item_nf_w,			cd_natureza_operacao_p,
			1,				vl_item_w,
			vl_item_w,			clock_timestamp(),
			nm_usuario_p, 			0,
			0,				0,
			cd_material_w, 			cd_local_estoque_p,
			'',				'',
			cd_unidade_medida_estoque_w,	1,
			cd_unidade_medida_estoque_w,	cd_conta_contabil_w,
			0,				0,
			cd_material_estoque_w,		vl_item_w,
			0,				null,
			null,				0,
			philips_contabil_pck.get_parametro_conta_contabil);

	end;
end loop;
close c00;

select	substr(obter_nome_fantasia_estab(cd_estab_destino_w),1,255)
into STRICT	ds_estab_destino_w
;

open c01;
loop
fetch c01 into
	nr_seq_conjunto_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin

	CALL cm_gerar_historico_conj(nr_seq_conjunto_w, wheb_mensagem_pck.get_texto(311706) || ds_estab_destino_w,nm_usuario_p);

	end;
end loop;
close c01;

CALL atualiza_total_nota_fiscal(nr_sequencia_w,nm_usuario_p);

if (ie_gera_nf_calculada_w = 'S') then
	begin
	SELECT * FROM consistir_nota_fiscal(nr_sequencia_w, nm_usuario_p, ds_erro_item_w, ds_erro_nota_w) INTO STRICT ds_erro_item_w, ds_erro_nota_w;

	if (coalesce(ds_erro_item_w::text, '') = '') and (coalesce(ds_erro_nota_w::text, '') = '') then
		CALL Atualizar_Nota_Fiscal(nr_sequencia_w,'I',nm_usuario_p,3);
	else
		begin

		delete	FROM nota_fiscal
		where	nr_sequencia = nr_sequencia_w;

		nr_sequencia_w	:= 0;

		end;
	end if;

	end;
end if;

commit;

ds_erro_item_p	:= ds_erro_item_w;
ds_erro_nota_p	:= ds_erro_nota_w;
nr_sequencia_p	:= nr_sequencia_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE cm_gera_nota_transferencia ( nr_seq_lote_transf_p bigint, cd_setor_atendimento_p bigint, nr_nota_fiscal_p bigint, cd_serie_nf_p text, cd_operacao_nf_p bigint, cd_natureza_operacao_p bigint, cd_local_estoque_p bigint, nr_seq_modelo_p bigint, ds_observacao_p text, ie_opcao_gera_item_p text, nm_usuario_p text, nr_sequencia_p INOUT bigint, ds_erro_nota_p INOUT text, ds_erro_item_p INOUT text) FROM PUBLIC;
