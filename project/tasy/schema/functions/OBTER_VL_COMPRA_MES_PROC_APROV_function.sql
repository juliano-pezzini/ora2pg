-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_vl_compra_mes_proc_aprov ( nr_sequencia_p bigint, cd_processo_aprov_p bigint) RETURNS bigint AS $body$
DECLARE



cd_grupo_material_w		smallint;
cd_subgrupo_material_w		smallint;
cd_classe_material_w		integer;
cd_familia_material_w 		processo_aprov_estrut.cd_familia_material%type;
cd_material_w			integer;
cd_estabelecimento_w		integer;
ie_urgente_w			varchar(1);
vl_retorno_w			double precision;
nr_seq_proj_rec_w			bigint;
vl_ordem_compra_w		double precision	:= 0;
vl_solic_compra_w			double precision	:= 0;
vl_cot_compra_w			double precision	:= 0;
cd_estabelecimento_ww		integer	:= coalesce(wheb_usuario_pck.get_cd_estabelecimento,1);
cd_centro_custo_w			integer;
ie_consid_valor_oc_compra_w	parametro_compras.ie_consid_valor_oc_compra%type;
ie_consid_valor_sc_compra_w	parametro_compras.ie_consid_valor_sc_compra%type;
ie_consid_valor_cc_compra_w	parametro_compras.ie_consid_valor_cc_compra%type;
vl_total_previsto_regra_w	double precision	:= 0;
cd_intervalo_vl_w		processo_aprov_estrut.cd_intervalo_vl%type;
dt_inicio_intervalo_w		ordem_compra.dt_ordem_compra%type;

/*esta function busca o valor total de compras no mes referente a regra de processo de aprovacao*/

BEGIN

select	coalesce(max(cd_material),0),
	coalesce(max(cd_classe_material),0),
	coalesce(max(cd_subgrupo_material),0),
	coalesce(max(cd_grupo_material),0),
	coalesce(max(cd_estabelecimento),0),
	coalesce(max(nr_seq_proj_rec),0),
	coalesce(max(ie_urgente),'A'),
	coalesce(max(cd_centro_custo),0),
	coalesce(max(cd_familia_material),0),
	coalesce(max(cd_intervalo_vl),'D')
into STRICT	cd_material_w,
	cd_classe_material_w,
	cd_subgrupo_material_w,
	cd_grupo_material_w,
	cd_estabelecimento_w,
	nr_seq_proj_rec_w,
	ie_urgente_w,
	cd_centro_custo_w,
	cd_familia_material_w,
	cd_intervalo_vl_w
from	processo_aprov_estrut
where	nr_sequencia	= nr_sequencia_p
and	cd_processo_aprov = cd_processo_aprov_p;

select	coalesce(ie_consid_valor_oc_compra,'S'),
	coalesce(ie_consid_valor_sc_compra,'N'),
	coalesce(ie_consid_valor_cc_compra,'N')
into STRICT	ie_consid_valor_oc_compra_w,
	ie_consid_valor_sc_compra_w,
	ie_consid_valor_cc_compra_w
from	parametro_compras
where	cd_estabelecimento = cd_estabelecimento_ww;

if (cd_intervalo_vl_w = 'D') then
	dt_inicio_intervalo_w := clock_timestamp();
elsif (cd_intervalo_vl_w = 'M') then
	dt_inicio_intervalo_w := trunc(clock_timestamp(), 'MM');
elsif (cd_intervalo_vl_w = 'S') then
	dt_inicio_intervalo_w := clock_timestamp() - interval '7 days';
elsif (cd_intervalo_vl_w = 'Q') then
	dt_inicio_intervalo_w := clock_timestamp() - interval '15 days';
end if;

if (ie_consid_valor_oc_compra_w = 'S') then
	begin

	select	coalesce(sum(a.vl_item_liquido), 0)
	into STRICT	vl_ordem_compra_w
	from 	estrutura_material_v b,
		ordem_compra o,
		ordem_compra_item a
	where	a.cd_material = b.cd_material
	and	a.nr_ordem_compra	= o.nr_ordem_compra
	and	coalesce(o.nr_seq_motivo_cancel::text, '') = ''
	and	coalesce(a.dt_reprovacao::text, '') = ''
	and	(o.dt_liberacao IS NOT NULL AND o.dt_liberacao::text <> '')
	and	o.dt_ordem_compra between inicio_dia(dt_inicio_intervalo_w) and fim_dia(clock_timestamp())
	and (o.cd_estabelecimento = cd_estabelecimento_w or cd_estabelecimento_w = 0)
	and (a.cd_material = cd_material_w or cd_material_w = 0)
	and (b.cd_classe_material = cd_classe_material_w or cd_classe_material_w = 0)
	and (b.cd_subgrupo_material = cd_subgrupo_material_w or cd_subgrupo_material_w = 0)
	and (b.cd_grupo_material = cd_grupo_material_w or cd_grupo_material_w = 0)
	and (b.nr_seq_familia = cd_familia_material_w or cd_familia_material_w = 0)
	and (a.nr_seq_proj_rec = nr_seq_proj_rec_w or nr_seq_proj_rec_w = 0)
	and (o.ie_urgente = ie_urgente_w or ie_urgente_w = 'A');

	end;
end if;

if (ie_consid_valor_sc_compra_w = 'S') then
	begin

	select	coalesce(sum(a.vl_custo_total), 0)
	into STRICT	vl_solic_compra_w
	from 	estrutura_material_v b,
		solic_compra s,
		solic_compra_item a
	where	a.cd_material		= b.cd_material
	and	a.nr_solic_compra		= s.nr_solic_compra
	and	coalesce(s.nr_seq_motivo_cancel::text, '') = ''
	and	coalesce(a.dt_reprovacao::text, '') = ''
	and	(s.dt_liberacao IS NOT NULL AND s.dt_liberacao::text <> '')
	and (s.cd_centro_custo = cd_centro_custo_w or cd_centro_custo_w = 0)
	and	pkg_date_utils.start_of(s.dt_solicitacao_compra, 'MM', null) = pkg_date_utils.start_of(clock_timestamp(), 'MM', null)
	and (s.cd_estabelecimento = cd_estabelecimento_w or cd_estabelecimento_w = 0)
	and (a.cd_material = cd_material_w or cd_material_w = 0)
	and (b.cd_classe_material = cd_classe_material_w or cd_classe_material_w = 0)
	and (b.cd_subgrupo_material = cd_subgrupo_material_w or cd_subgrupo_material_w = 0)
	and (b.cd_grupo_material = cd_grupo_material_w or cd_grupo_material_w = 0)
	and (b.nr_seq_familia = cd_familia_material_w or cd_familia_material_w = 0)
	and (a.nr_seq_proj_rec = nr_seq_proj_rec_w or nr_seq_proj_rec_w = 0)
	and (s.ie_urgente = ie_urgente_w or ie_urgente_w = 'A');

	end;
else
	if (ie_consid_valor_sc_compra_w = 'R') then
		begin

		select	coalesce(sum(a.vl_unit_previsto * a.qt_material), 0)
		into STRICT	vl_total_previsto_regra_w
		from 	estrutura_material_v b,
			solic_compra s,
			solic_compra_item a
		where	a.cd_material		= b.cd_material
		and	a.nr_solic_compra		= s.nr_solic_compra
		and	coalesce(s.nr_seq_motivo_cancel::text, '') = ''
		and	coalesce(a.dt_reprovacao::text, '') = ''
		and	(s.dt_liberacao IS NOT NULL AND s.dt_liberacao::text <> '')
		and (s.cd_centro_custo = cd_centro_custo_w or cd_centro_custo_w = 0)
		and	pkg_date_utils.start_of(s.dt_solicitacao_compra, 'MM', null) = pkg_date_utils.start_of(clock_timestamp(), 'MM', null)
		and (s.cd_estabelecimento = cd_estabelecimento_w or cd_estabelecimento_w = 0)
		and (a.cd_material = cd_material_w or cd_material_w = 0)
		and (b.cd_classe_material = cd_classe_material_w or cd_classe_material_w = 0)
		and (b.cd_subgrupo_material = cd_subgrupo_material_w or cd_subgrupo_material_w = 0)
		and (b.cd_grupo_material = cd_grupo_material_w or cd_grupo_material_w = 0)
		and (b.nr_seq_familia = cd_familia_material_w or cd_familia_material_w = 0)
		and (a.nr_seq_proj_rec = nr_seq_proj_rec_w or nr_seq_proj_rec_w = 0)
		and (s.ie_urgente = ie_urgente_w or ie_urgente_w = 'A');
	
		end;
	end if;
end if;

if (ie_consid_valor_cc_compra_w = 'S') then
	begin
	
	select	coalesce(sum(vl_liquido),0) vl_liquido
	into STRICT	vl_cot_compra_w
	from (
		SELECT	coalesce(sum(a.vl_preco_liquido),0) vl_liquido
		from	cot_compra_forn_item_tr_v a,
			estrutura_material_v e
		where	a.cd_material = e.cd_material
		and	coalesce(a.dt_reprovacao::text, '') = ''
		and	coalesce(a.nr_seq_motivo_cancel::text, '') = ''		
		and	establishment_timezone_utils.startofmonth(a.dt_cot_compra) = establishment_timezone_utils.startofmonth(clock_timestamp())
		and (a.cd_estabelecimento = cd_estabelecimento_w or cd_estabelecimento_w = 0)
		and (a.cd_material = cd_material_w or cd_material_w = 0)
		and (e.cd_classe_material = cd_classe_material_w or cd_classe_material_w = 0)
		and (e.cd_subgrupo_material = cd_subgrupo_material_w or cd_subgrupo_material_w = 0)
		and (e.cd_grupo_material = cd_grupo_material_w or cd_grupo_material_w = 0)
		and (e.nr_seq_familia = cd_familia_material_w or cd_familia_material_w = 0)
		and (a.nr_seq_proj_rec = nr_seq_proj_rec_w or nr_seq_proj_rec_w = 0)
		and	a.nr_seq_item_fornec = Obter_Venc_Cot_Fornec_item(a.nr_cot_compra, a.nr_item_cot_compra)
		and	substr(obter_se_existe_cot_resumo(a.nr_cot_compra),1,1) = 'N'
		
union all

		SELECT	coalesce(sum(a.vl_preco_liquido),0) vl_liquido
		from	cot_compra_resumo_v a,
			estrutura_material_v e
		where	a.cd_material = e.cd_material
		and	coalesce(a.dt_reprovacao::text, '') = ''
		and	coalesce(a.nr_seq_motivo_cancel::text, '') = ''
		and (a.cd_estabelecimento = cd_estabelecimento_w or cd_estabelecimento_w = 0)
		and (a.cd_material = cd_material_w or cd_material_w = 0)
		and (e.cd_classe_material = cd_classe_material_w or cd_classe_material_w = 0)
		and (e.cd_subgrupo_material = cd_subgrupo_material_w or cd_subgrupo_material_w = 0)
		and (e.cd_grupo_material = cd_grupo_material_w or cd_grupo_material_w = 0)
		and (e.nr_seq_familia = cd_familia_material_w or cd_familia_material_w = 0)
		and (a.nr_seq_proj_rec = nr_seq_proj_rec_w or nr_seq_proj_rec_w = 0)
		and	establishment_timezone_utils.startofmonth(a.dt_cot_compra) = establishment_timezone_utils.startofmonth(clock_timestamp())
		and	substr(obter_se_existe_cot_resumo(a.nr_cot_compra),1,1) = 'S') alias36;

	end;
end if;

vl_retorno_w	:= (vl_ordem_compra_w + vl_solic_compra_w + vl_cot_compra_w + vl_total_previsto_regra_w);

return	vl_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_vl_compra_mes_proc_aprov ( nr_sequencia_p bigint, cd_processo_aprov_p bigint) FROM PUBLIC;

