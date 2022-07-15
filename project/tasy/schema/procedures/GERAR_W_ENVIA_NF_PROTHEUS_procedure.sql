-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_w_envia_nf_protheus ( nr_sequencia_p bigint, ie_operacao_p text, nm_usuario_p text, nr_seq_integracao_p INOUT bigint) AS $body$
DECLARE


nr_seq_integracao_w		bigint;
nr_nota_fiscal_w		nota_fiscal.nr_nota_fiscal%type;
cd_serie_nf_w			nota_fiscal.cd_serie_nf%type;
dt_emissao_w			timestamp;
dt_digitacao_w			timestamp;
cd_cgc_emitente_w		varchar(14);
cd_cgc_w			varchar(14);
cd_cgc_nf_w			varchar(14);
vl_desconto_w			double precision;
vl_despesa_acessoria_w		double precision;
vl_seguro_w			double precision;
vl_frete_w			double precision;
cd_condicao_pagamento_w		bigint;
cd_natureza_operacao_w		bigint;
cd_operacao_nf_w			bigint;
ie_entrada_saida_w		varchar(1);
ie_tipo_nota_w			varchar(15);

nr_seq_item_integ_w		bigint;
nr_item_nf_w			bigint;
cd_material_w			integer;
qt_item_nf_w			double precision;
cd_unidade_medida_compra_w	varchar(30);
vl_unitario_item_nf_w		nota_fiscal_item.vl_unitario_item_nf%type;
cd_local_estoque_w		bigint;
vl_desconto_item_w		double precision;
cd_lote_fabricacao_w		varchar(20);
dt_validade_w			timestamp;
cd_centro_custo_w		integer;
cd_conta_contabil_w		varchar(20);
nr_ordem_compra_w		bigint;
nr_item_oci_w			bigint;

cd_natureza_operacao_ww		varchar(20);
cd_operacao_nf_ww		varchar(20);
cd_local_estoque_ww		varchar(20);
cd_material_ww			varchar(20);
cd_unidade_medida_ww		varchar(30);
cd_centro_custo_ww		varchar(20);
cd_conta_contabil_ww		varchar(20);
cd_condicao_pagamento_ww	varchar(20);
nr_item_documento_w 		varchar(10);
nr_documento_externo_w		varchar(10);

c01 CURSOR FOR
SELECT	nr_item_nf,
	cd_material,
	qt_item_nf,
	cd_unidade_medida_compra,
	vl_unitario_item_nf,
	cd_local_estoque,
	vl_desconto,
	cd_lote_fabricacao,
	dt_validade,
	cd_centro_custo,
	cd_conta_contabil,
	nr_ordem_compra,
	nr_item_oci
from	nota_fiscal_item
where	nr_sequencia = nr_sequencia_p
and	(cd_material IS NOT NULL AND cd_material::text <> '')
and	substr(obter_se_integr_item_nf_ext(nr_sequencia,nr_item_nf,'PR'),1,1) = 'S'
order by	nr_item_nf;


BEGIN

select	ie_tipo_nota,
	nr_nota_fiscal,
	cd_serie_nf,
	dt_emissao,
	dt_entrada_saida,
	cd_cgc_emitente,
	cd_cgc,
	vl_descontos,
	vl_despesa_acessoria,
	vl_seguro,
	vl_frete,
	cd_condicao_pagamento,
	cd_natureza_operacao,
	cd_operacao_nf
into STRICT	ie_tipo_nota_w,
	nr_nota_fiscal_w,
	cd_serie_nf_w,
	dt_emissao_w,
	dt_digitacao_w,
	cd_cgc_emitente_w,
	cd_cgc_w,
	vl_desconto_w,
	vl_despesa_acessoria_w,
	vl_seguro_w,
	vl_frete_w,
	cd_condicao_pagamento_w,
	cd_natureza_operacao_w,
	cd_operacao_nf_w
from	nota_fiscal
where	nr_sequencia = nr_sequencia_p;

if (ie_tipo_nota_w in ('EN','EF','EP')) then
	ie_entrada_saida_w	:= 'E';
	cd_cgc_nf_w		:= cd_cgc_emitente_w;
else
	ie_entrada_saida_w	:= 'S';
	cd_cgc_nf_w		:= cd_cgc_w;
end if;

select	coalesce(max(cd_sistema_ant),'')
into STRICT	cd_condicao_pagamento_ww
from	condicao_pagamento
where	cd_condicao_pagamento = cd_condicao_pagamento_w;

select	coalesce(cd_sistema_ext,to_char(cd_natureza_operacao))
into STRICT	cd_natureza_operacao_ww
from	natureza_operacao
where	cd_natureza_operacao = cd_natureza_operacao_w;

select	coalesce(nr_documento_ext,to_char(cd_operacao_nf_w))
into STRICT	cd_operacao_nf_ww
from	operacao_nota
where	cd_operacao_nf = cd_operacao_nf_w;

select	nextval('w_envia_nf_protheus_seq')
into STRICT	nr_seq_integracao_w
;

insert into w_envia_nf_protheus(
	nr_sequencia,
	dt_atualizacao,
	nm_usuario,
	dt_atualizacao_nrec,
	nm_usuario_nrec,
	ie_tipo_nota,
	ie_entrada_saida,
	nr_seq_nota_fiscal,
	nr_nota_fiscal,
	cd_serie_nf,
	dt_emissao,
	dt_digitacao,
	cd_cgc,
	vl_frete,
	vl_desconto,
	vl_despesa_acessoria,
	vl_seguro,
	cd_condicao_pagamento,
	cd_natureza_operacao,
	ie_operacao_integ)
values (
	nr_seq_integracao_w,
	clock_timestamp(),
	nm_usuario_p,
	clock_timestamp(),
	nm_usuario_p,
	'N',
	ie_entrada_saida_w,
	nr_sequencia_p,
	nr_nota_fiscal_w,
	cd_serie_nf_w,
	dt_emissao_w,
	dt_digitacao_w,
	cd_cgc_nf_w,
	vl_frete_w,
	vl_desconto_w,
	vl_despesa_acessoria_w,
	vl_seguro_w,
	cd_condicao_pagamento_ww,
	cd_natureza_operacao_ww,
	ie_operacao_p);

open c01;
loop
fetch c01 into
	nr_item_nf_w,
	cd_material_w,
	qt_item_nf_w,
	cd_unidade_medida_compra_w,
	vl_unitario_item_nf_w,
	cd_local_estoque_w,
	vl_desconto_item_w,
	cd_lote_fabricacao_w,
	dt_validade_w,
	cd_centro_custo_w,
	cd_conta_contabil_w,
	nr_ordem_compra_w,
	nr_item_oci_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	
	nr_item_documento_w 	:= '';
	nr_documento_externo_w	:= '';

	select	coalesce(max(cd_externo),0)
	into STRICT	cd_local_estoque_ww
	from	conversao_meio_externo
	where	ie_sistema_externo = 'PTH'
	and	nm_tabela = 'LOCAL_ESTOQUE'
	and	nm_atributo = 'CD_LOCAL_ESTOQUE'
	and	cd_interno = to_char(cd_local_estoque_w);

	select	somente_numero(coalesce(max(cd_sistema_ant),0))
	into STRICT	cd_material_ww
	from	material
	where	cd_material = cd_material_w;

	select	coalesce(max(cd_sistema_ant),max(cd_unidade_medida))
	into STRICT	cd_unidade_medida_ww
	from	unidade_medida
	where	cd_unidade_medida = cd_unidade_medida_compra_w;
	
	if (coalesce(cd_centro_custo_w,0) = 0) and (coalesce(cd_local_estoque_w,0) > 0) then
		
		select	cd_centro_custo
		into STRICT	cd_centro_custo_w
		from	local_estoque
		where	cd_local_estoque = cd_local_estoque_w;
	
	end if;

	select	coalesce(max(cd_sistema_contabil),'')
	into STRICT	cd_centro_custo_ww
	from	centro_custo
	where	cd_centro_custo = cd_centro_custo_w;
	
	/*select	cd_conta_contabil
	into	cd_conta_contabil_w
	from	classe_material a,
		material b
	where	a.cd_classe_material = b.cd_classe_material
	and	b.cd_material = cd_material_w;*/
	select	coalesce(max(cd_sistema_contabil),'')
	into STRICT	cd_conta_contabil_ww
	from	conta_contabil
	where	cd_conta_contabil = cd_conta_contabil_w;
	
	if (nr_ordem_compra_w > 0) then
	
		select	max(nr_documento_externo)
		into STRICT	nr_documento_externo_w
		from	ordem_compra
		where	nr_ordem_compra = nr_ordem_compra_w;
		
		nr_item_documento_w := nr_item_oci_w;
		
	end if;

	select	nextval('w_envia_item_nf_protheus_seq')
	into STRICT	nr_seq_item_integ_w
	;

	insert into w_envia_item_nf_protheus(
		nr_sequencia,
		dt_atualizacao,
		nm_usuario,
		dt_atualizacao_nrec,
		nm_usuario_nrec,
		nr_seq_nf_integ,
		nr_seq_nota_fiscal,
		nr_item_nf,
		cd_material,
		qt_item_nf,
		cd_unidade_medida,
		vl_unitario_item_nf,
		cd_local_estoque,
		cd_operacao_nf,
		vl_desconto_item,
		cd_lote_fabricacao,
		dt_validade,
		cd_centro_custo,
		cd_conta_contabil,
		nr_ordem_compra,
		nr_item_oci)
	values (
		nr_seq_item_integ_w,
		clock_timestamp(),
		nm_usuario_p,
		clock_timestamp(),
		nm_usuario_p,
		nr_seq_integracao_w,
		nr_sequencia_p,
		nr_item_nf_w,
		cd_material_ww,
		qt_item_nf_w,
		cd_unidade_medida_ww,
		vl_unitario_item_nf_w,
		cd_local_estoque_ww,
		cd_operacao_nf_ww,
		vl_desconto_item_w,
		cd_lote_fabricacao_w,
		dt_validade_w,
		cd_centro_custo_ww,
		cd_conta_contabil_ww,
		nr_documento_externo_w,
		nr_item_documento_w);

	end;
end loop;
close c01;

nr_seq_integracao_p	:= coalesce(nr_seq_integracao_w,0);

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_w_envia_nf_protheus ( nr_sequencia_p bigint, ie_operacao_p text, nm_usuario_p text, nr_seq_integracao_p INOUT bigint) FROM PUBLIC;

