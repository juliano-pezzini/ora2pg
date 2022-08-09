-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_item_oc_nf ( nr_seq_nf_p bigint, nr_ordem_compra_p bigint, nr_item_oci_p bigint, ie_entrega_p text, dt_entrega_p timestamp, nm_usuario_p text) AS $body$
DECLARE



cd_cgc_emitente_w		varchar(14);
cd_estabelecimento_w		smallint;
cd_serie_nf_w			nota_fiscal.cd_serie_nf%type;
nr_nota_fiscal_w			varchar(255);
nr_sequencia_nf_w			bigint;
nr_item_nf_w			integer;
cd_natureza_operacao_w		smallint;
qt_prevista_entrega_w		double precision;
vl_unitario_item_nf_w		double precision	:= 0;
vl_total_item_nf_w			double precision	:= 0;
vl_frete_w			double precision	:= 0;
vl_desconto_w			double precision	:= 0;
vl_despesa_acessoria_w		double precision	:= 0;
cd_material_w			integer;
cd_local_estoque_w		integer;
ds_observacao_item_w		varchar(255);
ds_material_direto_w		varchar(255);
cd_pessoa_fisica_w		varchar(255);
cd_unidade_medida_compra_w	varchar(30);
qt_item_estoque_w			double precision	:= 0;
cd_unidade_medida_estoque_w	varchar(30);
cd_conta_contabil_w		varchar(20)	:= null;
cd_conta_contabil_ww		varchar(20)	:= null;
cd_conta_ordem_w			varchar(20)	:= null;
cd_centro_custo_w			integer;
cd_material_estoque_w		integer	:= null;
vl_liquido_w			double precision	:= 0;
pr_descontos_w			double precision;
dt_prevista_entrega_w		timestamp;
nr_seq_conta_financeira_w		bigint	:= null;
nr_seq_proj_rec_w			bigint;
pr_desc_financ_w			double precision;
nr_seq_ordem_serv_w		bigint;
nr_atendimento_w			bigint;
nr_seq_unidade_adic_w		bigint;
nr_seq_proj_gpi_w			bigint;
nr_seq_etapa_gpi_w		bigint;
nr_seq_conta_gpi_w		bigint;
nr_contrato_w			bigint;
nr_seq_criterio_rateio_w		bigint;
cd_tributo_w			integer;
vl_tributo_w			double precision;
pr_tributo_w			double precision;
nr_solic_compra_w			bigint;
vl_desconto_oci_w			double precision;
qt_conv_compra_estoque_w		double precision;
qt_conversao_w			double precision;
dt_emissao_w			timestamp;
cd_operacao_nf_w			smallint;
ie_tipo_conta_w			integer	:= 2;
cd_centro_conta_w			integer;
dt_inicio_garantia_w		timestamp;
dt_fim_garantia_w		timestamp;
nr_seq_marca_w			bigint;
ie_origem_titulo_w		varchar(10);
nr_seq_classe_tit_rec_w		bigint;
ie_tipo_titulo_rec_w		titulo_receber.ie_tipo_titulo%type;
ie_atualiza_conta_cont_oc_w		varchar(2);
cd_sequencia_parametro_w        parametros_conta_contabil.cd_sequencia_parametro%type;
cd_sequencia_parametro_ww		parametros_conta_contabil.cd_sequencia_parametro%type;

ie_gerar_local_cc_regra_w		varchar(1);
cd_centro_custo_ww		integer;
cd_local_estoque_ww		integer;

c01 CURSOR FOR
SELECT	a.cd_material,
	a.cd_unidade_medida_compra,
	a.vl_unitario_material,
	coalesce(a.pr_descontos,0),
	cd_local_estoque,
	substr(a.ds_material_direto,1,255) ds_material_direto,
	a.ds_observacao,
	a.cd_centro_custo,
	a.cd_conta_contabil,
	a.nr_seq_proj_rec,
	coalesce(a.pr_desc_financ,0),
	a.nr_solic_compra,
	b.dt_prevista_entrega,
	a.nr_seq_unidade_adic,
	a.nr_seq_criterio_rateio,
	coalesce(a.vl_desconto,0),
	a.nr_seq_ordem_serv,
	a.nr_seq_proj_gpi,
	a.nr_seq_etapa_gpi,
	a.nr_seq_conta_gpi,
	a.nr_contrato,
	a.dt_inicio_garantia,
	a.dt_fim_garantia,
	a.nr_seq_marca
from 	ordem_compra_item_entrega b,
	ordem_compra_item a
where	a.nr_ordem_compra	= b.nr_ordem_compra
and	a.nr_item_oci		= b.nr_item_oci
and	a.nr_ordem_compra	= nr_ordem_compra_p
and	a.nr_item_oci		= nr_item_oci_p
and (coalesce(a.qt_material,0) > coalesce(a.qt_material_entregue,0))
and (coalesce(qt_prevista_entrega,0) - coalesce(qt_real_entrega,0)) > 0
and	((ie_entrega_p		= 'N') or
	((ie_entrega_p		= 'S') and trunc(b.dt_prevista_entrega,'dd') = trunc(dt_entrega_p,'dd')))
and	coalesce(a.dt_reprovacao::text, '') = ''
and	coalesce(b.dt_cancelamento::text, '') = '';

c02 CURSOR FOR
SELECT	cd_tributo,
	pr_tributo,
	vl_tributo
from	ordem_compra_item_trib
where	nr_ordem_compra	= nr_ordem_compra_p
and	nr_item_oci	= nr_item_oci_p;
	

BEGIN

select	cd_cgc_emitente,
	cd_estabelecimento,
	cd_serie_nf,
	nr_nota_fiscal,
	nr_sequencia_nf,
	cd_natureza_operacao,
	dt_emissao,
	cd_operacao_nf,
	cd_pessoa_fisica
into STRICT	cd_cgc_emitente_w,
	cd_estabelecimento_w,
	cd_serie_nf_w,
	nr_nota_fiscal_w,
	nr_sequencia_nf_w,
	cd_natureza_operacao_w,
	dt_emissao_w,
	cd_operacao_nf_w,
	cd_pessoa_fisica_w
from	nota_fiscal
where	nr_sequencia	= nr_seq_nf_p;

ie_gerar_local_cc_regra_w := obter_param_usuario(40, 395, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_gerar_local_cc_regra_w);
ie_atualiza_conta_cont_oc_w := obter_param_usuario(40, 41, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_w, ie_atualiza_conta_cont_oc_w);

select	max(a.ie_origem_titulo),
	max(a.nr_seq_classe),
	max(a.ie_tipo_titulo)
into STRICT	ie_origem_titulo_w,
	nr_seq_classe_tit_rec_w,
	ie_tipo_titulo_rec_w
from	titulo_receber a
where	a.nr_seq_nf_saida	= nr_seq_nf_p;

select	nr_atendimento
into STRICT	nr_atendimento_w
from	ordem_compra
where	nr_ordem_compra = nr_ordem_compra_p;

open c01;
loop
fetch c01 into
	cd_material_w,
	cd_unidade_medida_compra_w,
	vl_unitario_item_nf_w,
	pr_descontos_w,
	cd_local_estoque_w,
	ds_material_direto_w,
	ds_observacao_item_w,
	cd_centro_custo_w,
	cd_conta_ordem_w,
	nr_seq_proj_rec_w,
	pr_desc_financ_w,
	nr_solic_compra_w,
	dt_prevista_entrega_w,
	nr_seq_unidade_adic_w,
	nr_seq_criterio_rateio_w,
	vl_desconto_oci_w,
	nr_seq_ordem_serv_w,
	nr_seq_proj_gpi_w,
	nr_seq_etapa_gpi_w,
	nr_seq_conta_gpi_w,
	nr_contrato_w,
	dt_inicio_garantia_w,
	dt_fim_garantia_w,
	nr_seq_marca_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	select	substr(obter_dados_material_estab(cd_material,cd_estabelecimento_w,'UME'),1,30) cd_unidade_medida_estoque,
		qt_conv_compra_estoque,
		cd_material_estoque
	into STRICT	cd_unidade_medida_estoque_w,
		qt_conv_compra_estoque_w,
		cd_material_estoque_w
	from 	material
	where	cd_material = cd_material_w;
	
	cd_sequencia_parametro_w  := null;
	cd_sequencia_parametro_ww := null;

	if (dt_prevista_entrega_w IS NOT NULL AND dt_prevista_entrega_w::text <> '') then
		select	coalesce(max(coalesce(qt_prevista_entrega,0) - coalesce(qt_real_entrega,0)),0)
		into STRICT	qt_prevista_entrega_w
		from	ordem_compra_item_entrega
		where	nr_ordem_compra		= nr_ordem_compra_p
		and	nr_item_oci		= nr_item_oci_p
		and	dt_prevista_entrega		= dt_prevista_entrega_w
		and	coalesce(dt_cancelamento::text, '') = '';

		if (cd_unidade_medida_compra_w = cd_unidade_medida_estoque_w) then
			qt_item_estoque_w	:= qt_prevista_entrega_w;
		else
			qt_item_estoque_w	:= qt_prevista_entrega_w * qt_conv_compra_estoque_w;
		end if;

		if (coalesce(nr_seq_unidade_adic_w, 0) > 0) then
			select	qt_conversao
			into STRICT	qt_conversao_w
			from	unidade_medida_adic_compra
			where	nr_sequencia = nr_seq_unidade_adic_w;
			qt_item_estoque_w	:= qt_prevista_entrega_w * qt_conversao_w;
		end if;

		vl_unitario_item_nf_w	:= (vl_unitario_item_nf_w);
		vl_total_item_nf_w		:= (qt_prevista_entrega_w * vl_unitario_item_nf_w);
		vl_desconto_w		:= (vl_total_item_nf_w * pr_descontos_w) / 100 + coalesce(vl_desconto_oci_w,0);
		vl_liquido_w		:=  vl_total_item_nf_w - vl_desconto_w;

		select (coalesce(max(nr_item_nf),0)+1)
		into STRICT	nr_item_nf_w
		from	nota_fiscal_item
		where	nr_sequencia = nr_seq_nf_p;

		if (ie_gerar_local_cc_regra_w = 'S') then
			begin

			SELECT * FROM obter_local_estoque_cc_item_nf(
					cd_estabelecimento_w, cd_operacao_nf_w, cd_material_w, cd_local_estoque_ww, cd_centro_custo_ww) INTO STRICT cd_local_estoque_ww, cd_centro_custo_ww;

			if (coalesce(cd_local_estoque_ww,0) > 0) then
				cd_local_estoque_w	:= cd_local_estoque_ww;
			end if;

			if (coalesce(cd_centro_custo_ww,0) > 0) then
				cd_centro_custo_w	:= cd_centro_custo_ww;
			end if;

			end;
		end if;


		/*define conta contabil do material*/

		if (ie_atualiza_conta_cont_oc_w not in ('P','S','OP')) and (coalesce(cd_centro_custo_w::text, '') = '') then								
			begin			
			SELECT * FROM SELECT * FROM define_conta_contabil(	2, cd_estabelecimento_w, null, null, null, null, cd_material_w, null, null, cd_local_estoque_w, cd_conta_contabil_w, cd_centro_custo_w, null, dt_emissao_w) INTO STRICT cd_conta_contabil_w, cd_centro_custo_w INTO cd_conta_contabil_w, cd_centro_custo_w;
			cd_sequencia_parametro_w := philips_contabil_pck.get_parametro_conta_contabil();
			end;
		end if;

		
		nr_seq_conta_financeira_w := obter_conta_financeira('S', cd_estabelecimento_w, cd_material_w, null, null, null, null, cd_cgc_emitente_w, cd_centro_custo_w, nr_seq_conta_financeira_w, null, cd_operacao_nf_w, null, null, null, nr_seq_proj_rec_w, null, cd_pessoa_fisica_w, ie_origem_titulo_w, null, nr_seq_classe_tit_rec_w, null, cd_local_estoque_w, null, null, null, null, ie_tipo_titulo_rec_w, null);

		if (nr_seq_conta_financeira_w = 0) then
			nr_seq_conta_financeira_w := null;
		end if;

		if (coalesce(cd_conta_contabil_w::text, '') = '') or (length(cd_conta_contabil_w) = 0) or (ie_atualiza_conta_cont_oc_w in ('P','OP','S')) then
			begin

			ie_tipo_conta_w	:= 3;
			if (coalesce(cd_centro_custo_w::text, '') = '') then
				ie_tipo_conta_w	:= 2;
			end if;

			SELECT * FROM define_conta_material(
					cd_estabelecimento_w, cd_material_w, ie_tipo_conta_w, 0, 0, 0, 0, 0, 0, 0, cd_local_estoque_w, cd_operacao_nf_w, trunc(clock_timestamp()), cd_conta_contabil_ww, --cd_centro_conta_w, Esse parametro nao era utilizado para nada, e sempre era inserido nulo
					cd_centro_custo_w,  --Incluido na OS 765021
					null) INTO STRICT cd_conta_contabil_ww, 
					cd_centro_custo_w;
			cd_sequencia_parametro_ww := philips_contabil_pck.get_parametro_conta_contabil();
								
			end;
		end if;		
		
		if (ie_atualiza_conta_cont_oc_w = 'S') then
			cd_conta_contabil_w	     := cd_conta_contabil_ww;
			cd_sequencia_parametro_w := cd_sequencia_parametro_ww;
		
			if (coalesce(cd_conta_contabil_ww, 'X') = 'X') and (ie_atualiza_conta_cont_oc_w = 'S') then
				cd_conta_contabil_w	     := cd_conta_ordem_w;
				cd_sequencia_parametro_w := null;
			end if;
		elsif (ie_atualiza_conta_cont_oc_w = 'P') then
			cd_conta_contabil_w      := cd_conta_contabil_ww;
			cd_sequencia_parametro_w := cd_sequencia_parametro_ww;
		elsif (ie_atualiza_conta_cont_oc_w = 'O') then
			cd_conta_contabil_w      := cd_conta_ordem_w;
			cd_sequencia_parametro_w := null;
		elsif (ie_atualiza_conta_cont_oc_w = 'OP') then
			cd_conta_contabil_w      := cd_conta_ordem_w;
			cd_sequencia_parametro_w := null;
		
			if (coalesce(cd_conta_ordem_w, 'X') = 'X') then
				cd_conta_contabil_w      := cd_conta_contabil_ww;
				cd_sequencia_parametro_w := cd_sequencia_parametro_ww;
			end if;
		end if;		
			
		if (nr_solic_compra_w IS NOT NULL AND nr_solic_compra_w::text <> '') and (coalesce(nr_seq_ordem_serv_w::text, '') = '') then
			select	nr_seq_ordem_serv
			into STRICT	nr_seq_ordem_serv_w
			from	solic_compra
			where	nr_solic_compra	= nr_solic_compra_w;
		end if;

		insert into nota_fiscal_item(
				cd_estabelecimento,
				cd_cgc_emitente,
				cd_serie_nf,
				nr_nota_fiscal,
				nr_sequencia_nf,
				nr_item_nf,
				cd_natureza_operacao,
				qt_item_nf,
				vl_unitario_item_nf,
				vl_total_item_nf,
				dt_atualizacao,
				nm_usuario,
				vl_frete,
				vl_desconto,
				vl_despesa_acessoria,
				cd_material,
				cd_local_estoque,
				ds_observacao,
				ds_complemento,
				cd_unidade_medida_compra,
				qt_item_estoque,
				cd_unidade_medida_estoque,
				cd_conta_contabil,
				cd_centro_custo,
				cd_material_estoque,
				nr_ordem_compra,
				nr_sequencia,
				vl_liquido,
				pr_desconto,
				nr_item_oci,
				dt_entrega_ordem,
				nr_seq_conta_financ,
				nr_seq_proj_rec,
				pr_desc_financ,
				nr_seq_ordem_serv,
				nr_atendimento,
				nr_seq_unidade_adic,
				nr_seq_proj_gpi,
				nr_seq_etapa_gpi,
				nr_seq_conta_gpi,
				nr_contrato,
				vl_desconto_rateio,
				vl_seguro,
				dt_inicio_garantia,
				dt_fim_garantia,
				nr_seq_marca,
				cd_sequencia_parametro)
			values (	cd_estabelecimento_w,
				cd_cgc_emitente_w,
				cd_serie_nf_w,
				nr_nota_fiscal_w,
				nr_sequencia_nf_w,
				nr_item_nf_w,
				cd_natureza_operacao_w,
				qt_prevista_entrega_w,
				vl_unitario_item_nf_w,
				vl_total_item_nf_w,
				clock_timestamp(),
				nm_usuario_p,
				vl_frete_w,
				coalesce(vl_desconto_w,0),
				vl_despesa_acessoria_w,
				cd_material_w,
				cd_local_estoque_w,
				ds_observacao_item_w,
				ds_material_direto_w,
				cd_unidade_medida_compra_w,
				qt_item_estoque_w,
				cd_unidade_medida_estoque_w,
				cd_conta_contabil_w,
				cd_centro_custo_w,
				cd_material_estoque_w,
				nr_ordem_compra_p,
				nr_seq_nf_p,
				vl_liquido_w,
				pr_descontos_w,
				nr_item_oci_p,
				dt_prevista_entrega_w,
				nr_seq_conta_financeira_w,
				nr_seq_proj_rec_w,
				pr_desc_financ_w,
				nr_seq_ordem_serv_w,
				nr_atendimento_w,
				nr_seq_unidade_adic_w,
				nr_seq_proj_gpi_w,
				nr_seq_etapa_gpi_w,
				nr_seq_conta_gpi_w,
				nr_contrato_w,
				0,
				0,
				dt_inicio_garantia_w,
				dt_fim_garantia_w,
				nr_seq_marca_w,
				cd_sequencia_parametro_w);
		commit;

		if (nr_seq_criterio_rateio_w IS NOT NULL AND nr_seq_criterio_rateio_w::text <> '') then
			CALL ratear_item_nf(nr_seq_nf_p, nr_item_nf_w, nr_seq_criterio_rateio_w, nm_usuario_p, trunc(clock_timestamp()));
		end if;

		open c02;
		loop
		fetch c02 into
			cd_tributo_w,
			pr_tributo_w,
			vl_tributo_w;
		EXIT WHEN NOT FOUND; /* apply on c02 */
			begin
			insert into nota_fiscal_item_trib(
				cd_estabelecimento,
				cd_cgc_emitente,
				cd_serie_nf,
				nr_nota_fiscal,
				nr_sequencia_nf,
				nr_item_nf,
				cd_tributo,
				vl_tributo,
				dt_atualizacao,
				nm_usuario,
				vl_base_calculo,
				tx_tributo,
				vl_reducao_base,
				nr_sequencia,
				ie_rateio,
				vl_trib_nao_retido,
				vl_base_nao_retido,
				vl_trib_adic,
				vl_base_adic)
			values (	cd_estabelecimento_w,
				cd_cgc_emitente_w,
				cd_serie_nf_w,
				nr_nota_fiscal_w,
				nr_sequencia_nf_w,
				nr_item_nf_w,
				cd_tributo_w,
				vl_tributo_w,
				clock_timestamp(),
				nm_usuario_p,
				vl_liquido_w,
				pr_tributo_w,
				0,
				nr_seq_nf_p,
				'N',
				0,
				0,
				0,
				0);
			end;
		end loop;
		close c02;
	end if;
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_item_oc_nf ( nr_seq_nf_p bigint, nr_ordem_compra_p bigint, nr_item_oci_p bigint, ie_entrega_p text, dt_entrega_p timestamp, nm_usuario_p text) FROM PUBLIC;
