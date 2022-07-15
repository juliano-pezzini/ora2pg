-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_nota_fiscal_resp_consig ( nr_sequencia_resp_consig_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, cd_operacao_nf_p bigint, cd_serie_nf_p text, dt_emissao_p timestamp, nr_nota_fiscal_p text, ie_valor_itens_p text, ds_observacao_p text, cd_natureza_operacao_p bigint, ie_gerar_itens_p text, cd_setor_atendimento_p bigint, ie_tipo_nota_p text, cd_condicao_pagamento_p bigint, nr_sequencia_p INOUT bigint, nr_sequencia_nf_p INOUT bigint) AS $body$
DECLARE


/* ie_tipo_doc_p
'S' -> normal: itens da nota são gerados a partir dos itens informados no documento.
'N' -> devolução: itens da nota são gerados a partir dos itens de devolução em outra procedure.
*/
			

cd_condicao_pagamento_w		bigint 	:= cd_condicao_pagamento_p;
ie_tipo_nota_w			varchar(2)	:= ie_tipo_nota_p;
ie_gerar_itens_w	         		varchar(1)	:= ie_gerar_itens_p;
cd_estabelecimento_w		smallint		:= cd_estabelecimento_p;
nm_usuario_w			varchar(15)	:= nm_usuario_p;
nr_seq_resp_consig_w		bigint	:= nr_sequencia_resp_consig_p;
cd_operacao_nf_w			smallint		:= cd_operacao_nf_p;
cd_serie_w			nota_fiscal.cd_serie_nf%type	:= cd_serie_nf_p;
dt_atualizacao_w			timestamp 		:= clock_timestamp();
dt_emissao_w			timestamp		:= dt_emissao_p;
dt_entrada_saida_w		timestamp		:= trunc(clock_timestamp(),'dd');
ie_acao_nf_w			varchar(1) 	:= '1';
ie_emissao_nf			varchar(1) 	:= '0';
ie_tipo_frete_w			varchar(1)	:= '0';
nr_nota_fiscal_w			varchar(255)	:= nr_nota_fiscal_p;
nr_sequencia_w	 		bigint;
nr_sequencia_nf_w			bigint;
qt_peso_bruto_w			double precision	:= 0;
qt_peso_liquido_w			double precision	:= 0;
vl_mercadoria_w			double precision	:= 0;
vl_total_nota_w			double precision	:= 0;
ie_valor_itens_w			varchar(1)	:= ie_valor_itens_p;
cd_cgc_w			varchar(14);
cd_cgc_emitente_w		varchar(14);
ds_observacao_w			varchar(4000)	:= ds_observacao_p;
cd_natureza_operacao_w		smallint		:= cd_natureza_operacao_p;
vl_ipi_w				double precision	:= 0;
ie_situacao_w			varchar(1)	:= '1';
ie_entregue_bloqueto_w		varchar(1) 	:= 'N';
cd_setor_atendimento_w		integer		:= cd_setor_atendimento_p;

------------------ // valores para os itens da nota //-----------------
nr_item_nf_w			integer;
qt_item_nf_w			double precision;
qt_item_estoque_w			double precision;
cd_unidade_medida_compra_w	varchar(30);
cd_unidade_medida_estoque_w	varchar(30);
vl_desconto_w			double precision	:= 0;
vl_desconto_rateio_w		double precision	:= 0;
vl_despesa_acessoria_w		double precision	:= 0;
vl_frete_w			double precision	:= 0;
vl_liquido_w			double precision	:= 0;
vl_seguro_w			double precision 	:= 0;
vl_total_item_nf_w			double precision;
vl_unitario_item_nf_w		double precision;
cd_material_w			integer		:= 0;
cd_material_estoque_w		integer		:= 0;
nr_item_resp_consig_w		bigint;
nr_seq_lote_w			bigint;
cd_local_estoque_w		smallint;
ie_tipo_conta_w			integer;
cd_conta_contabil_w		varchar(20);
cd_centro_conta_w			integer;

c01 CURSOR FOR
SELECT	nr_sequencia,
	cd_material,
	qt_material,
	cd_unidade_compra,
	qt_estoque,
	cd_unidade_estoque,
	nr_seq_lote_fornec,
	cd_local_estoque
from	sup_resp_consig_item	
where	nr_seq_resp = nr_seq_resp_consig_w
order by nr_sequencia;


BEGIN
select	nextval('nota_fiscal_seq')
into STRICT	nr_sequencia_w
;

nr_sequencia_p := nr_sequencia_w;

select	cd_cnpj
into STRICT	cd_cgc_w
from	sup_resp_consignado
where	nr_sequencia = nr_seq_resp_consig_w;

select	cd_cgc
into STRICT	cd_cgc_emitente_w
from	estabelecimento
where	cd_estabelecimento = cd_estabelecimento_w;

select (coalesce(max(nr_item_nf),0)+1)
into STRICT	nr_item_nf_w
from	nota_fiscal_item
where	nr_sequencia = nr_sequencia_w;

select (coalesce(max(nr_sequencia_nf),0)+1)
into STRICT	nr_sequencia_nf_w	
from	nota_fiscal
where	cd_estabelecimento = cd_estabelecimento_w
and	cd_cgc_emitente = cd_cgc_emitente_w
and	cd_serie_nf = cd_serie_w
and	nr_nota_fiscal = nr_nota_fiscal_w;

nr_sequencia_nf_p := nr_sequencia_nf_w;

insert into nota_fiscal(cd_estabelecimento,
	nm_usuario,
	nr_seq_resp_consig,
	cd_operacao_nf,
	cd_serie_nf,
	dt_atualizacao,
	dt_emissao,
	dt_entrada_saida,
	ie_acao_nf,
	ie_emissao_nf,
	ie_tipo_frete,
	nr_nota_fiscal,
	nr_sequencia,
	nr_sequencia_nf,
	qt_peso_bruto,
	qt_peso_liquido,
	vl_mercadoria,
	vl_total_nota,
	cd_cgc,
	cd_cgc_emitente,
	ds_observacao,
	cd_natureza_operacao,
	vl_ipi,
	ie_situacao,
	ie_entregue_bloqueto,
	cd_setor_digitacao,
	ie_tipo_nota,
	cd_condicao_pagamento)
values (	cd_estabelecimento_w,
	nm_usuario_w,
	nr_seq_resp_consig_w,
	cd_operacao_nf_w,
	cd_serie_w,
	dt_atualizacao_w,
	dt_emissao_w,
	dt_entrada_saida_w,
	ie_acao_nf_w,
	ie_emissao_nf,
	ie_tipo_frete_w,
	nr_nota_fiscal_w,
	nr_sequencia_w,
	nr_sequencia_nf_w,
	qt_peso_bruto_w,
	qt_peso_liquido_w,
	vl_mercadoria_w,
	vl_total_nota_w,
	cd_cgc_w,
	cd_cgc_emitente_w,
	ds_observacao_w,
	cd_natureza_operacao_w,
	vl_ipi_w,
	ie_situacao_w,
	ie_entregue_bloqueto_w,
	cd_setor_atendimento_w,
	ie_tipo_nota_w,
	cd_condicao_pagamento_w);
			
if (ie_gerar_itens_w = 'S') then			
open c01;
loop
fetch c01 into	
	nr_item_resp_consig_w,
	cd_material_w,
	qt_item_nf_w,
	cd_unidade_medida_compra_w,
	qt_item_estoque_w,
	cd_unidade_medida_estoque_w,
	nr_seq_lote_w,
	cd_local_estoque_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	
	if (ie_valor_itens_w = '0') then
		vl_unitario_item_nf_w := obter_custo_medio_material(cd_estabelecimento_p, trunc(clock_timestamp(), 'mm'), cd_material_w);
	elsif (ie_valor_itens_w = '1') then
		vl_unitario_item_nf_w := obter_valor_ultima_compra(cd_estabelecimento_p, 99999, cd_material_w, null, 'N');
	end if;
	
	vl_unitario_item_nf_w	:= coalesce(vl_unitario_item_nf_w,0);
	vl_total_item_nf_w 		:= (vl_unitario_item_nf_w * qt_item_nf_w);
	vl_liquido_w		:= (vl_total_item_nf_w - vl_desconto_w);
	
	/*sempre deve possuir local de estoque e o centro de custo será nulo*/

	ie_tipo_conta_w	:= 2;

	SELECT * FROM define_conta_material(
		cd_estabelecimento_p, cd_material_w, ie_tipo_conta_w, 0, 0, 0, 0, 0, 0, 0, cd_local_estoque_w, cd_operacao_nf_w, trunc(clock_timestamp()), cd_conta_contabil_w, cd_centro_conta_w, null) INTO STRICT cd_conta_contabil_w, cd_centro_conta_w;
	
	select	a.cd_material_estoque
	into STRICT	cd_material_estoque_w
	from	material a
	where	a.cd_material = cd_material_w;
	
	insert into nota_fiscal_item(
		cd_estabelecimento,
		cd_natureza_operacao,
		dt_atualizacao,
		nm_usuario,
		nr_item_nf,
		nr_sequencia,
		nr_sequencia_nf,
		qt_item_nf,
		qt_item_estoque,
		vl_desconto,
		vl_desconto_rateio,
		vl_despesa_acessoria,
		vl_frete,
		vl_liquido,
		vl_seguro, 
		vl_total_item_nf,
		vl_unitario_item_nf,
		cd_cgc_emitente,
		cd_material,
		cd_material_estoque,
		cd_unidade_medida_compra,
		cd_unidade_medida_estoque,
		nr_item_resp_consig,
		nr_nota_fiscal,
		cd_serie_nf,
		nr_seq_lote_fornec,
		cd_local_estoque,
		cd_conta_contabil,
		cd_sequencia_parametro)
	values (	cd_estabelecimento_w,
		cd_natureza_operacao_w,
		dt_atualizacao_w,
		nm_usuario_w,
		nr_item_nf_w,
		nr_sequencia_w,
		nr_sequencia_nf_w,
		qt_item_nf_w,
		qt_item_estoque_w,
		vl_desconto_w,
		vl_desconto_rateio_w,
		vl_despesa_acessoria_w,
		vl_frete_w,
		vl_liquido_w,
		vl_seguro_w,
		vl_total_item_nf_w,
		vl_unitario_item_nf_w,
		cd_cgc_emitente_w,
		cd_material_w,
		cd_material_estoque_w,
		cd_unidade_medida_compra_w,
		cd_unidade_medida_estoque_w,
		nr_item_resp_consig_w,
		nr_nota_fiscal_w,
		cd_serie_w,
		nr_seq_lote_w,
		cd_local_estoque_w,
		cd_conta_contabil_w,
		philips_contabil_pck.get_parametro_conta_contabil);
	
	nr_item_nf_w := (nr_item_nf_w + 1);	
	end;
end loop;
close c01;
end if;
commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_nota_fiscal_resp_consig ( nr_sequencia_resp_consig_p bigint, nm_usuario_p text, cd_estabelecimento_p bigint, cd_operacao_nf_p bigint, cd_serie_nf_p text, dt_emissao_p timestamp, nr_nota_fiscal_p text, ie_valor_itens_p text, ds_observacao_p text, cd_natureza_operacao_p bigint, ie_gerar_itens_p text, cd_setor_atendimento_p bigint, ie_tipo_nota_p text, cd_condicao_pagamento_p bigint, nr_sequencia_p INOUT bigint, nr_sequencia_nf_p INOUT bigint) FROM PUBLIC;

