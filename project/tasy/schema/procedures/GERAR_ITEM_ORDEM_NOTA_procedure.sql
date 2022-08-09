-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_item_ordem_nota (cd_estabelecimento_p bigint, nr_sequencia_p bigint, nr_ordem_compra_p bigint, nm_usuario_p text, ie_grava_observacao_p text, ie_restricao_p text, ie_restr_item_em_nf_p text, nr_item_oci_p bigint, vl_cotacao_p bigint, nr_danfe_p text) AS $body$
DECLARE


nr_item_oci_w			integer;
cd_material_w			integer;
cd_unidade_medida_compra_w	varchar(30);
vl_unitario_item_nf_w		double precision	:= 0;
pr_descontos_w			double precision;
cd_local_estoque_w		integer;
ds_material_direto_w		varchar(255);
ds_observacao_item_w		varchar(255);
cd_centro_custo_w			integer;
cd_conta_contabil_w		varchar(20)	:= null;
cd_conta_contabil_ord_w		varchar(20)	:= null;
cd_conta_contabil_par_w		varchar(20)	:= null;
nr_seq_proj_rec_w			bigint;
pr_desc_financ_w			double precision;
nr_solic_compra_w			bigint;
nr_item_solic_compra_w		bigint;
cd_unidade_medida_estoque_w	varchar(30);
qt_conv_compra_estoque_w		double precision;
cd_material_estoque_w		integer	:= null;
qt_existe_convert_w		integer;
qt_conv_compra_est_w		double precision;
dt_prevista_entrega_w		timestamp;
qt_prevista_entrega_w		double precision;
cd_serie_nf_w			nota_fiscal.cd_serie_nf%type;
nr_nota_fiscal_w			varchar(255);
nr_sequencia_nf_w			bigint;
cd_cgc_emitente_w		varchar(14);
qt_item_estoque_w			double precision	:= 0;
vl_total_item_nf_w			double precision	:= 0;
vl_desconto_w			double precision	:= 0;
vl_liquido_w			double precision	:= 0;
vl_desconto_oc_w			double precision	:= 0;
nr_item_nf_w			integer;
nr_seq_conta_financeira_w		bigint	:= null;
ie_consignado_w			varchar(01);
cd_pessoa_fisica_w		varchar(255);
ie_tipo_conta_w			integer	:= 2;
nr_seq_ordem_serv_w		bigint;
cd_local_direto_w			integer;
dt_liberacao_w			timestamp;
cd_centro_conta_w			integer;
dt_aprovacao_w			timestamp;
cd_tributo_w			integer;
nr_atendimento_w			bigint;
pr_tributo_w			double precision;
vl_tributo_w			double precision;
vl_desconto_rateio_w		double precision	:= 0;
vl_seguro_w			double precision	:= 0;
vl_frete_w			double precision	:= 0;
dt_atualizacao_estoque_w		timestamp		:= null;
dt_validade_w			timestamp		:= null;
cd_lote_fabricacao_w		varchar(15);
vl_despesa_acessoria_w		double precision	:= 0;
cd_natureza_operacao_w		smallint;
qt_material_w			double precision;
qt_item_nf_w			double precision;
cd_operacao_nf_w			bigint;
dt_entrada_saida_w		timestamp;
nr_contrato_w			bigint;
cd_operacao_estoque_w		bigint;
dt_inicio_garantia_w		timestamp;
dt_fim_garantia_w			timestamp;
nr_seq_marca_w			bigint;
ie_origem_titulo_w			varchar(10);
ie_atualiza_conta_contabil_w		varchar(2);
nr_seq_classe_tit_rec_w		bigint;
nr_ordem_compra_w		bigint;
nr_seq_criterio_rateio_w	bigint;
dt_atualizacao_w           		timestamp 		:= clock_timestamp();
qt_registro_w			bigint;
ie_tipo_titulo_rec_w		titulo_receber.ie_tipo_titulo%type;
cd_sequencia_parametro_w nota_fiscal_item.cd_sequencia_parametro%type;



/*Regras de local da nf por centro de custo */

ie_gerar_local_cc_regra_w		varchar(1);
cd_centro_custo_ww		integer;
cd_local_estoque_ww		integer;
vl_cotacao_w			cotacao_moeda.vl_cotacao%type;
qt_dias_antecipacao_w		double precision;

/*	Rateio		*/

cd_centro_custo_rat_w		integer;
cd_conta_contabil_rat_w		varchar(20);
cd_conta_financ_rat_w		bigint;
vl_rateio_rat_w			double precision;
vl_frete_rat_w			double precision;
vl_desconto_rat_w			double precision;
vl_seguro_rat_w			double precision;
vl_despesa_acessoria_rat_w		double precision;
ie_situacao_rat_w			varchar(1);
qt_rateio_w			double precision;

c01 CURSOR FOR
SELECT	a.nr_item_oci,
	a.cd_material,
	a.cd_unidade_medida_compra,
	a.vl_unitario_material,
	coalesce(a.pr_descontos, 0),
	coalesce(a.cd_local_estoque, cd_local_direto_w),
	substr(a.ds_material_direto,1,255) ds_material_direto,
	CASE WHEN ie_grava_observacao_p='S' THEN  a.ds_observacao  ELSE '' END ,
	a.cd_centro_custo,
	a.cd_conta_contabil,
	a.nr_seq_proj_rec,
	coalesce(a.pr_desc_financ, 0),
	a.nr_solic_compra,
	a.qt_material,
	coalesce(a.vl_desconto,0),
	a.nr_seq_ordem_serv,
	b.dt_prevista_entrega,
	a.nr_contrato,
	a.nr_seq_proj_rec,
	a.dt_inicio_garantia,
	a.dt_fim_garantia,
	a.nr_seq_marca,
	a.nr_seq_criterio_rateio,
	a.nr_item_solic_compra
from 	ordem_compra_item_entrega b,
	ordem_compra_item a
where (a.nr_ordem_compra = nr_ordem_compra_p)
and (a.nr_ordem_compra = b.nr_ordem_compra)
and (a.nr_item_oci = b.nr_item_oci)
and	((a.nr_item_oci = nr_item_oci_p) or (nr_item_oci_p = 0))
and	coalesce(a.qt_material,0) > obter_qt_entregue_oci(a.nr_ordem_compra, a.nr_item_oci)
and (coalesce(b.qt_prevista_entrega,0) - coalesce(b.qt_real_entrega,0)) > 0
and	((coalesce(qt_dias_antecipacao_w,0) = 0) or
	((coalesce(qt_dias_antecipacao_w,0) <> 0) and ((dt_prevista_entrega - clock_timestamp()) <= qt_dias_antecipacao_w)))
and (coalesce(a.dt_reprovacao::text, '') = '')
and (coalesce(b.dt_cancelamento::text, '') = '')
and	((not exists (SELECT	1
			from	nota_fiscal y,
				nota_fiscal_item i
			where	y.nr_sequencia = i.nr_sequencia
			and	y.ie_situacao = 1
			and	i.nr_ordem_compra = a.nr_ordem_compra
			and	i.nr_item_oci = a.nr_item_oci) and (ie_restr_item_em_nf_p = 'S')) or (ie_restr_item_em_nf_p = 'N'));

c02 CURSOR FOR
SELECT	cd_tributo,
	pr_tributo,
	vl_tributo
from	ordem_compra_item_trib
where	nr_ordem_compra	= nr_ordem_compra_p
and	nr_item_oci	= nr_item_oci_w;

c03 CURSOR FOR
SELECT	cd_centro_custo,
	cd_conta_contabil,
	cd_conta_financ,
	vl_rateio,
	vl_frete,
	vl_desconto,
	vl_seguro,
	vl_despesa_acessoria,
	ie_situacao,
	qt_rateio
from	ordem_compra_item_rateio
where	nr_ordem_compra = nr_ordem_compra_p
and	nr_item_oci = nr_item_oci_w;

c04 CURSOR FOR
SELECT	cd_centro_custo,
	cd_conta_contabil,
	cd_conta_financ,
	vl_rateio,
	vl_frete,
	vl_desconto,
	vl_seguro,
	vl_despesa_acessoria,
	ie_situacao,
	qt_rateio
from	solic_compra_item_rateio
where	nr_solic_compra = nr_solic_compra_w
and	nr_item_solic_compra = nr_item_solic_compra_w;


BEGIN

select	coalesce(max(vl_cotacao_p),1)
into STRICT	vl_cotacao_w
;

ie_atualiza_conta_contabil_w := obter_param_usuario(40, 41, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_atualiza_conta_contabil_w);
ie_gerar_local_cc_regra_w := obter_param_usuario(40, 395, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, ie_gerar_local_cc_regra_w);
qt_dias_antecipacao_w := obter_param_usuario(40, 91, obter_perfil_ativo, nm_usuario_p, cd_estabelecimento_p, qt_dias_antecipacao_w);


--entregas_wcp.Consulta_q.ParamByName('ie_consiste_antecipacao').AsString    := ifLinha(param_91 = 0,'N',ConverteBooleanString(param_348));

--entregas_wcp.Consulta_q.ParamByName('qt_dias_antecipacao').AsFloat			:= param_91;
update	nota_fiscal
set	nr_danfe	= nr_danfe_p
where	nr_sequencia	= nr_sequencia_p
and	coalesce(nr_danfe::text, '') = '';	

select	dt_liberacao,
	dt_aprovacao,
	nr_atendimento
into STRICT	dt_liberacao_w,
	dt_aprovacao_w,
	nr_atendimento_w
from	ordem_compra
where	nr_ordem_compra = nr_ordem_compra_p;

if (ie_restricao_p = 'L') and (coalesce(dt_liberacao_w::text, '') = '') then
	--(-20011,'Esta ordem de compra nao foi liberada');
	CALL wheb_mensagem_pck.exibir_mensagem_abort(217010);
elsif (ie_restricao_p = 'A') and (coalesce(dt_aprovacao_w::text, '') = '') then
	--(-20011,'Esta ordem de compra nao foi Aprovada');
	CALL wheb_mensagem_pck.exibir_mensagem_abort(217011);
end if;

begin
select	min(cd_local_estoque)
into STRICT	cd_local_direto_w
from	local_estoque
where	ie_tipo_local = 8
and	cd_estabelecimento = cd_estabelecimento_p; -- rfoliveira 05/05/2011 OS 314583
exception
	when others then
		cd_local_direto_w := 1;
end;

select	cd_serie_nf,
	nr_nota_fiscal,
	nr_sequencia_nf,
	cd_cgc_emitente,
	cd_natureza_operacao,
	cd_operacao_nf,
	dt_entrada_saida,
	cd_pessoa_fisica,
	coalesce(nr_ordem_compra,0)
into STRICT	cd_serie_nf_w,
	nr_nota_fiscal_w,
	nr_sequencia_nf_w,
	cd_cgc_emitente_w,
	cd_natureza_operacao_w,
	cd_operacao_nf_w,
	dt_entrada_saida_w,
	cd_pessoa_fisica_w,
	nr_ordem_compra_w
from	nota_fiscal
where	nr_sequencia = nr_sequencia_p;

select	max(a.ie_origem_titulo),
	max(a.nr_seq_classe),
	max(a.ie_tipo_titulo)
into STRICT	ie_origem_titulo_w,
	nr_seq_classe_tit_rec_w,
	ie_tipo_titulo_rec_w
from	titulo_receber a
where	a.nr_seq_nf_saida	= nr_sequencia_p;

select	cd_operacao_estoque
into STRICT	cd_operacao_estoque_w
from	operacao_nota
where	cd_operacao_nf	= cd_operacao_nf_w;

open c01;
loop
fetch c01 into
	nr_item_oci_w,
	cd_material_w,
	cd_unidade_medida_compra_w,
	vl_unitario_item_nf_w,
	pr_descontos_w,
	cd_local_estoque_w,
	ds_material_direto_w,
	ds_observacao_item_w,
	cd_centro_custo_w,
	cd_conta_contabil_ord_w,
	nr_seq_proj_rec_w,
	pr_desc_financ_w,
	nr_solic_compra_w,
	qt_material_w,
	vl_desconto_oc_w,
	nr_seq_ordem_serv_w,
	dt_prevista_entrega_w,
	nr_contrato_w,
	nr_seq_proj_rec_w,
	dt_inicio_garantia_w,
	dt_fim_garantia_w,
	nr_seq_marca_w,
	nr_seq_criterio_rateio_w,
	nr_item_solic_compra_w;
EXIT WHEN NOT FOUND; /* apply on c01 */
	begin
	cd_conta_contabil_w := null;
	ie_tipo_conta_w := null;
	cd_sequencia_parametro_w := null;

	select	coalesce(sum(coalesce(i.qt_item_nf,0)),0)
	into STRICT	qt_item_nf_w
	from	nota_fiscal y,
		nota_fiscal_item i
	where	y.nr_sequencia = i.nr_sequencia
	and	y.ie_situacao = 1
	and	i.nr_ordem_compra = nr_ordem_compra_p
	and	i.nr_item_oci = nr_item_oci_w;

	if	((ie_restr_item_em_nf_p = 'S') and		/*Anderson 03/10/2007 - Problema no Oracle 8 - Inclusao do tratamento do c01 aqui*/
		(qt_item_nf_w <= coalesce(qt_material_w,0))) or (ie_restr_item_em_nf_p = 'N') then

		begin

		select	substr(obter_dados_material_estab(cd_material,cd_estabelecimento_p,'UME'),1,30) cd_unidade_medida_estoque,
			qt_conv_compra_estoque,
			cd_material_estoque
		into STRICT	cd_unidade_medida_estoque_w,
			qt_conv_compra_estoque_w,
			cd_material_estoque_w
		from 	material
		where	cd_material	= cd_material_w;

/*		select	min(dt_prevista_entrega)	Anderson 08/02/2008 OS82187 - Coloquei a entrega no c01
		into	dt_prevista_entrega_w
		from	ordem_compra_item_entrega
		where	nr_ordem_compra		= nr_ordem_compra_p
		and	nr_item_oci			= nr_item_oci_w
		and	(nvl(qt_prevista_entrega,0) - nvl(qt_real_entrega,0)) > 0
		and	dt_cancelamento is null;*/
		if (dt_prevista_entrega_w IS NOT NULL AND dt_prevista_entrega_w::text <> '') then
			begin
			select	coalesce(max(coalesce(qt_prevista_entrega,0) - coalesce(qt_real_entrega,0)),0)
			into STRICT	qt_prevista_entrega_w
			from	ordem_compra_item_entrega
			where	nr_ordem_compra	= nr_ordem_compra_p
			and	nr_item_oci		= nr_item_oci_w
        		and	dt_prevista_entrega	= dt_prevista_entrega_w
			and	coalesce(dt_cancelamento::text, '') = '';
			
            select	count(*)
			into STRICT	qt_existe_convert_w
			from	material_marca
			where	coalesce(cd_estabelecimento, cd_estabelecimento_p) = cd_estabelecimento_p
			and	cd_material	= cd_material_w
			and	coalesce(cd_cnpj, cd_cgc_emitente_w) 	= cd_cgc_emitente_w
			and	cd_unidade_medida	= cd_unidade_medida_compra_w
			and	nr_sequencia		= nr_seq_marca_w
			and	coalesce(qt_conv_compra_est, 0) > 0;

			if (qt_existe_convert_w = 0) then
				select	count(*)
				into STRICT	qt_existe_convert_w
				from	material_fornec
				where	cd_estabelecimento	= cd_estabelecimento_p
				and	cd_material		= cd_material_w
				and	cd_cgc			= cd_cgc_emitente_w
				and	cd_unid_medida		= cd_unidade_medida_compra_w
				and	coalesce(ie_nota_fiscal,'S') = 'S';
			end if;

			if (cd_unidade_medida_compra_w = cd_unidade_medida_estoque_w) and (qt_existe_convert_w = 0) then
				qt_item_estoque_w	:= qt_prevista_entrega_w;
			elsif (cd_unidade_medida_compra_w <> cd_unidade_medida_estoque_w) and (qt_existe_convert_w = 0) then
				qt_item_estoque_w	:= obter_quantidade_convertida(cd_material_w, qt_prevista_entrega_w, cd_unidade_medida_compra_w, 'UME');
			elsif (qt_existe_convert_w > 0) then
				qt_conv_compra_est_w := obter_qt_conv_compra_est(cd_material_w, cd_cgc_emitente_w, cd_unidade_medida_compra_w, cd_estabelecimento_p, nr_seq_marca_w, qt_conv_compra_est_w);
				qt_item_estoque_w := qt_prevista_entrega_w * qt_conv_compra_est_w;
			end if;

            vl_unitario_item_nf_w := (vl_unitario_item_nf_w * vl_cotacao_w);
			vl_total_item_nf_w		:= (qt_prevista_entrega_w * vl_unitario_item_nf_w);
			
			if (pr_descontos_w <> 0) then
				vl_desconto_w	:= (vl_total_item_nf_w * pr_descontos_w) / 100;
			else
				vl_desconto_w	:= coalesce(vl_desconto_oc_w,0);
			end if;
			
			vl_liquido_w			:=  vl_total_item_nf_w - vl_desconto_w;

			select (coalesce(max(nr_item_nf),0)+1)
			into STRICT	nr_item_nf_w
			from	nota_fiscal_item
			where	nr_sequencia	 = nr_sequencia_p;

			if (ie_gerar_local_cc_regra_w = 'S') then
				begin

				SELECT * FROM obter_local_estoque_cc_item_nf(
						cd_estabelecimento_p, cd_operacao_nf_w, cd_material_w, cd_local_estoque_ww, cd_centro_custo_ww) INTO STRICT cd_local_estoque_ww, cd_centro_custo_ww;

				if (coalesce(cd_local_estoque_ww,0) > 0) then
					cd_local_estoque_w	:= cd_local_estoque_ww;
				end if;

				if (coalesce(cd_centro_custo_ww,0) > 0) then
					cd_centro_custo_w	:= cd_centro_custo_ww;
				end if;

				end;
			end if;
			
			/* define conta contabil do material 	*/

			if (coalesce(nr_item_oci_w::text, '') = '') then
				begin
				if (ie_atualiza_conta_contabil_w = 'N') then
					cd_conta_contabil_w := null;
				elsif (ie_atualiza_conta_contabil_w in ('O','OP')) then
					cd_conta_contabil_w := cd_conta_contabil_ord_w;
				end if;
				
				if (ie_atualiza_conta_contabil_w not in ('P','S')) or
					((ie_atualiza_conta_contabil_w = 'OP') and (coalesce(cd_conta_contabil_w::text, '') = '')) then
					begin
					begin
					SELECT * FROM SELECT * FROM define_conta_contabil(	2, cd_estabelecimento_p, null, null, null, null, cd_material_w, null, null, cd_local_estoque_w, cd_conta_contabil_par_w, cd_centro_custo_w, null, dt_entrada_saida_w) INTO STRICT cd_conta_contabil_par_w, cd_centro_custo_w INTO cd_conta_contabil_par_w, cd_centro_custo_w;
								
					cd_sequencia_parametro_w := philips_contabil_pck.get_parametro_conta_contabil();
					exception
					when others then
						cd_conta_contabil_par_w := null;
						cd_sequencia_parametro_w:= null;
					end;
					
					cd_conta_contabil_w := cd_conta_contabil_par_w;
					
					if (coalesce(cd_conta_contabil_w::text, '') = '') and (ie_atualiza_conta_contabil_w = 'S') then
						cd_conta_contabil_w := cd_conta_contabil_ord_w;
						cd_sequencia_parametro_w:= null;
					end if;
					end;
				end if;
				end;
			end if;

			nr_seq_conta_financeira_w := obter_conta_financeira(	'S', cd_estabelecimento_p, cd_material_w, null, null, null, null, cd_cgc_emitente_w, cd_centro_custo_w, nr_seq_conta_financeira_w, null, cd_operacao_nf_w, null, null, null, nr_seq_proj_rec_w, null, cd_pessoa_fisica_w, ie_origem_titulo_w, null, nr_seq_classe_tit_rec_w, null, cd_local_estoque_w, null, null, null, null, ie_tipo_titulo_rec_w, null);
	
			if (nr_seq_conta_financeira_w = 0) then
				nr_seq_conta_financeira_w := null;
			end if;

			if (ie_consignado_w = 1) then
				cd_local_estoque_w	:= null;
			end if;

			if (not ie_atualiza_conta_contabil_w = 'N') and
				((coalesce(cd_conta_contabil_w::text, '') = '') or (length(cd_conta_contabil_w) = 0)) then
				begin
				ie_tipo_conta_w := 3;

				if (coalesce(cd_centro_custo_w::text, '') = '') then
					ie_tipo_conta_w	:= 2;
				end if;
				
				if (ie_atualiza_conta_contabil_w in ('O','OP')) then
					cd_conta_contabil_w := cd_conta_contabil_ord_w;
					cd_sequencia_parametro_w:= null;
				end if;

			
				
				if	((ie_atualiza_conta_contabil_w in ('P','S','OP')) or (coalesce(cd_conta_contabil_w::text, '') = '')) then					
					begin
					begin
					cd_conta_contabil_par_w := null;
					

					
					SELECT * FROM define_conta_material(	cd_estabelecimento_p, cd_material_w, ie_tipo_conta_w, 0, 0, 0, 0, 0, 0, 0, cd_local_estoque_w, cd_operacao_estoque_w, dt_entrada_saida_w, cd_conta_contabil_par_w, --cd_centro_conta_w,
										cd_centro_custo_w, null) INTO STRICT cd_conta_contabil_par_w, 
										cd_centro_custo_w;
					cd_sequencia_parametro_w := philips_contabil_pck.get_parametro_conta_contabil();
					exception
					when others then
						cd_conta_contabil_par_w := null;
						cd_sequencia_parametro_w:= null;
					end;
					
					if (ie_atualiza_conta_contabil_w = 'OP') and (not coalesce(cd_conta_contabil_ord_w::text, '') = '') then
						cd_conta_contabil_w := cd_conta_contabil_ord_w;
						cd_sequencia_parametro_w:= null;
					elsif (not ie_atualiza_conta_contabil_w = 'O') then
						cd_conta_contabil_w := cd_conta_contabil_par_w;
					end if;
					
					if (coalesce(cd_conta_contabil_w::text, '') = '') and (ie_atualiza_conta_contabil_w = 'S') then
						cd_conta_contabil_w := cd_conta_contabil_ord_w;
						cd_sequencia_parametro_w:= null;
					end if;
					end;
				end if;
				end;
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
				cd_procedimento,
				cd_setor_atendimento,
				cd_conta,
				cd_local_estoque,
				ds_observacao,
				ds_complemento,
				qt_peso_bruto,
				qt_peso_liquido,
				cd_unidade_medida_compra,
				qt_item_estoque,
				cd_unidade_medida_estoque,
				cd_lote_fabricacao,
				dt_validade,
				dt_atualizacao_estoque,
				cd_conta_contabil,
				vl_desconto_rateio,
				vl_seguro,
				cd_centro_custo,
				cd_material_estoque,
				ie_origem_proced,
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
				nr_contrato,
				dt_inicio_garantia,
				dt_fim_garantia,
				nr_seq_marca,
				cd_sequencia_parametro,
                nr_solic_compra,
                nr_item_solic_compra)
			values (	cd_estabelecimento_p,
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
				null,
 				null,
	 			null,
 				cd_local_estoque_w,
		 		ds_observacao_item_w,
 				ds_material_direto_w,
				null,
 				null,
	 			cd_unidade_medida_compra_w,
		 		qt_item_estoque_w,
 				cd_unidade_medida_estoque_w,
 				cd_lote_fabricacao_w,
		 		dt_validade_w,
 				dt_atualizacao_estoque_w,
 				cd_conta_contabil_w,
 				vl_desconto_rateio_w,
		 		vl_seguro_w,
 				cd_centro_custo_w,
 				cd_material_estoque_w,
 				null,
		 		nr_ordem_compra_p,
 				nr_sequencia_p,
 				vl_liquido_w,
				pr_descontos_w,
				nr_item_oci_w,
				dt_prevista_entrega_w,
				nr_seq_conta_financeira_w,
				nr_seq_proj_rec_w,
				pr_desc_financ_w,
				nr_seq_ordem_serv_w,
				nr_atendimento_w,
				nr_contrato_w,
				dt_inicio_garantia_w,
				dt_fim_garantia_w,
				nr_seq_marca_w,
				cd_sequencia_parametro_w,
                nr_solic_compra_w,
                nr_item_solic_compra_w);
			commit;
			
			if (nr_ordem_compra_w = 0) then
				update	nota_fiscal
				set	nr_ordem_compra = nr_ordem_compra_p
				where	nr_sequencia = nr_sequencia_p;
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
				values (cd_estabelecimento_p,
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
 					nr_sequencia_p,
					'N',
					0,
					0,
					0,	
					0);
				end;
			end loop;
			close c02;
			
			
			if (nr_seq_criterio_rateio_w IS NOT NULL AND nr_seq_criterio_rateio_w::text <> '') then
				CALL ratear_item_nf(nr_sequencia_p, nr_item_nf_w, nr_seq_criterio_rateio_w, nm_usuario_p, trunc(dt_atualizacao_w));
			else
				select	count(*)
				into STRICT	qt_registro_w
				from	ordem_compra_item_rateio
				where	nr_ordem_compra = nr_ordem_compra_p;

				if (qt_registro_w > 0) then

					open C03;
					loop
					fetch C03 into
						cd_centro_custo_rat_w,
						cd_conta_contabil_rat_w,
						cd_conta_financ_rat_w,
						vl_rateio_rat_w,
						vl_frete_rat_w,
						vl_desconto_rat_w,
						vl_seguro_rat_w,
						vl_despesa_acessoria_rat_w,
						ie_situacao_rat_w,
						qt_rateio_w;
					EXIT WHEN NOT FOUND; /* apply on C03 */
						begin

						if (qt_rateio_w > 0) then
							vl_rateio_rat_w := coalesce(vl_unitario_item_nf_w,0) * qt_rateio_w;
						end if;

						insert into nota_fiscal_item_rateio(
							nr_sequencia,
							nr_seq_nota,
							nr_item_nf,
							dt_atualizacao,
							nm_usuario,
							cd_centro_custo,
							cd_conta_contabil,
							cd_conta_financ,
							vl_rateio,
							vl_frete,
							vl_desconto,
							vl_seguro,
							vl_despesa_acessoria,
							ie_situacao,
							qt_rateio)
						values (nextval('nota_fiscal_item_rateio_seq'),
							nr_sequencia_p,
							nr_item_nf_w,
							clock_timestamp(),
							nm_usuario_p,
							cd_centro_custo_rat_w,
							cd_conta_contabil_rat_w,
							cd_conta_financ_rat_w,
							vl_rateio_rat_w,
							vl_frete_rat_w,
							vl_desconto_rat_w,
							vl_seguro_rat_w,
							vl_despesa_acessoria_rat_w,
							ie_situacao_rat_w,
							qt_rateio_w);

						end;
					end loop;
					close C03;

				else
					open c04;
					loop
					fetch c04 into
						cd_centro_custo_rat_w,
						cd_conta_contabil_rat_w,
						cd_conta_financ_rat_w,
						vl_rateio_rat_w,
						vl_frete_rat_w,
						vl_desconto_rat_w,
						vl_seguro_rat_w,
						vl_despesa_acessoria_rat_w,
						ie_situacao_rat_w,
						qt_rateio_w;
					EXIT WHEN NOT FOUND; /* apply on c04 */
						begin

						if (qt_rateio_w > 0) then
							vl_rateio_rat_w := coalesce(vl_unitario_item_nf_w,0) * qt_rateio_w;
						end if;

						insert into nota_fiscal_item_rateio(
							nr_sequencia,
							nr_seq_nota,
							nr_item_nf,
							dt_atualizacao,
							nm_usuario,
							cd_centro_custo,
							cd_conta_contabil,
							cd_conta_financ,
							vl_rateio,
							vl_frete,
							vl_desconto,
							vl_seguro,
							vl_despesa_acessoria,
							ie_situacao,
							qt_rateio)
						values (nextval('nota_fiscal_item_rateio_seq'),
							nr_sequencia_p,
							nr_item_nf_w,
							clock_timestamp(),
							nm_usuario_p,
							cd_centro_custo_rat_w,
							cd_conta_contabil_rat_w,
							cd_conta_financ_rat_w,
							vl_rateio_rat_w,
							vl_frete_rat_w,
							vl_desconto_rat_w,
							vl_seguro_rat_w,
							vl_despesa_acessoria_rat_w,
							ie_situacao_rat_w,
							qt_rateio_w);
						end;
					end loop;
					close c04;
				end if;
			end if;
			
			
			
			end;
		end if;

		end;
	end if;

	end;
end loop;
close c01;

CALL gerar_historico_nota_fiscal(nr_sequencia_p, nm_usuario_p, '11', wheb_mensagem_pck.get_texto(301640,'NR_ORDEM_COMPRA_P='||nr_ordem_compra_p));

commit;
end;	
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_item_ordem_nota (cd_estabelecimento_p bigint, nr_sequencia_p bigint, nr_ordem_compra_p bigint, nm_usuario_p text, ie_grava_observacao_p text, ie_restricao_p text, ie_restr_item_em_nf_p text, nr_item_oci_p bigint, vl_cotacao_p bigint, nr_danfe_p text) FROM PUBLIC;
