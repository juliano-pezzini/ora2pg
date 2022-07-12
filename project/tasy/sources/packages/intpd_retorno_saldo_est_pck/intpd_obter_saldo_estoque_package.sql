-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';




CREATE OR REPLACE FUNCTION intpd_retorno_saldo_est_pck.intpd_obter_saldo_estoque ( nr_seq_fila_p bigint) RETURNS SETOF T_SALDO_ESTOQUE AS $body$
DECLARE


r_saldo_estoque_row_w	r_saldo_estoque_row;
nr_seq_documento_w	intpd_fila_transmissao.nr_seq_documento%type;
nr_seq_regra_w		intpd_eventos_sistema.nr_seq_regra_conv%type;
ie_conversao_w		intpd_eventos_sistema.ie_conversao%type;

c01 CURSOR FOR
SELECT	coalesce(a.cd_estabelecimento,0) cd_establishment,
	pkg_date_utils.start_of(a.dt_mesano_referencia, 'MM', null) dt_reference_month_year,
	coalesce(a.cd_local_estoque,0) cd_stock_location,
	coalesce(a.cd_grupo_material,0) cd_material_group,
	coalesce(a.cd_subgrupo_material,0) cd_material_subgroup,
	coalesce(a.cd_classe_material,0) cd_material_class,
	coalesce(a.cd_material,0) cd_material,
	coalesce(a.ie_consignado,'N') ie_consigned,
	coalesce(a.cd_fornecedor,'X') cd_supplier
from	intpd_w_consulta_saldo_est a
where	a.nr_sequencia = nr_seq_documento_w;
c01_w	c01%rowtype;

c02 CURSOR FOR
SELECT	a.cd_estabelecimento cd_establishment,
	a.dt_mesano_referencia dt_reference_month_year,
	a.cd_local_estoque cd_stock_location,
	a.cd_material cd_material,
	'N' ie_consigned,
	null cd_supplier,
	a.qt_estoque qt_stock_balance,
	obter_saldo_disp_estoque(a.cd_estabelecimento, a.cd_material, a.cd_local_estoque, a.dt_mesano_referencia) qt_stock_available_balance,
	a.vl_estoque vl_stock,
	a.vl_custo_medio vl_average_cost
from	saldo_estoque a,
	estrutura_material_v e
where	a.cd_material = e.cd_material
and	((a.cd_estabelecimento = c01_w.cd_establishment) or (c01_w.cd_establishment = 0))
and	((a.cd_local_estoque = c01_w.cd_stock_location) or (c01_w.cd_stock_location = 0))
and	((a.dt_mesano_referencia = c01_w.dt_reference_month_year) or (coalesce(c01_w.dt_reference_month_year::text, '') = ''))
and	((e.cd_grupo_material = c01_w.cd_material_group) or (c01_w.cd_material_group = 0))
and	((e.cd_subgrupo_material = c01_w.cd_material_subgroup) or (c01_w.cd_material_subgroup = 0))
and	((e.cd_classe_material = c01_w.cd_material_class) or (c01_w.cd_material_class = 0))
and	((a.cd_material = c01_w.cd_material) or (c01_w.cd_material = 0))
and	c01_w.ie_consigned = 'N'

union

select	a.cd_estabelecimento cd_establishment,
	a.dt_mesano_referencia dt_reference_month_year,
	a.cd_local_estoque cd_stock_location,
	a.cd_material cd_material,
	'S' ie_consigned,
	cd_fornecedor cd_supplier,
	a.qt_estoque qt_stock_balance,
	obter_saldo_disp_consig(a.cd_estabelecimento,  a.cd_fornecedor, a.cd_material, a.cd_local_estoque) qt_stock_available_balance,
	a.vl_estoque vl_stock,
	a.vl_custo_medio vl_average_cost
from	fornecedor_Mat_Consignado a,
	estrutura_material_v e
where	a.cd_material = e.cd_material
and	((a.cd_estabelecimento = c01_w.cd_establishment) or (c01_w.cd_establishment = 0))
and	((a.cd_local_estoque = c01_w.cd_stock_location) or (c01_w.cd_stock_location = 0))
and	((a.dt_mesano_referencia = c01_w.dt_reference_month_year) or (coalesce(c01_w.dt_reference_month_year::text, '') = ''))
and	((e.cd_grupo_material = c01_w.cd_material_group) or (c01_w.cd_material_group = 0))
and	((e.cd_subgrupo_material = c01_w.cd_material_subgroup) or (c01_w.cd_material_subgroup = 0))
and	((e.cd_classe_material = c01_w.cd_material_class) or (c01_w.cd_material_class = 0))
and	((a.cd_material = c01_w.cd_material) or (c01_w.cd_material = 0))
and	((a.cd_fornecedor = c01_w.cd_supplier) or (c01_w.cd_supplier = 'X'))
and	c01_w.ie_consigned = 'S';
c02_w	c02%rowtype;


BEGIN
if (coalesce(nr_seq_fila_p,0) > 0) then

	select	a.nr_seq_documento,
		b.nr_seq_regra_conv,
		coalesce(b.ie_conversao,'I')
	into STRICT	nr_seq_documento_w,
		nr_seq_regra_w,
		ie_conversao_w
	from	intpd_fila_transmissao a,
		intpd_eventos_sistema b
	where	a.nr_seq_evento_sistema = b.nr_sequencia
	and	a.nr_sequencia = nr_seq_fila_p;

	open C01;
	loop
	fetch C01 into
		c01_w;
	EXIT WHEN NOT FOUND; /* apply on C01 */
		begin
		/*LIMPA TODOS OS ATRIBUTOS DO REGISTRO
		limpar_atributos_diagnosis(r_diagnosis_row_w);*/
		open C02;
		loop
		fetch C02 into
			c02_w;
		EXIT WHEN NOT FOUND; /* apply on C02 */
			begin

			r_saldo_estoque_row_w.cd_establishment			:= substr(intpd_conv('ESTABELECIMENTO','CD_ESTABELECIMENTO',c02_w.cd_establishment,nr_seq_regra_w,ie_conversao_w,'E'),1,255);
			r_saldo_estoque_row_w.cd_stock_location			:= substr(intpd_conv('LOCAL_ESTOQUE','CD_LOCAL_ESTOQUE',c02_w.cd_stock_location,nr_seq_regra_w,ie_conversao_w,'E'),1,255);
			r_saldo_estoque_row_w.cd_material			:= substr(intpd_conv('MATERIAL','CD_MATERIAL',c02_w.cd_material,nr_seq_regra_w,ie_conversao_w,'E'),1,255);
			r_saldo_estoque_row_w.cd_supplier			:= substr(coalesce(intpd_conv('PESSOA_JURIDICA','CD_CGC',c02_w.cd_supplier,nr_seq_regra_w,ie_conversao_w,'E'),c02_w.cd_supplier),1,255);
			r_saldo_estoque_row_w.dt_reference_month_year		:= c02_w.dt_reference_month_year;
			r_saldo_estoque_row_w.ie_consigned			:= C02_W.ie_consigned;
			r_saldo_estoque_row_w.qt_stock_balance			:= c02_w.qt_stock_balance;
			r_saldo_estoque_row_w.qt_stock_available_balance	:= c02_w.qt_stock_available_balance;
			r_saldo_estoque_row_w.vl_stock				:= c02_w.vl_stock;
			r_saldo_estoque_row_w.vl_average_cost			:= c02_w.vl_average_cost;


			RETURN NEXT r_saldo_estoque_row_w;

			end;
		end loop;
		close C02;

		end;
	end loop;
	close C01;


end if;

END;

$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION intpd_retorno_saldo_est_pck.intpd_obter_saldo_estoque ( nr_seq_fila_p bigint) FROM PUBLIC;