-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION cus_obter_rec_liquida_classif ( cd_estabelecimento_p bigint, cd_tabela_custo_p bigint, cd_centro_controle_p bigint, cd_classificacao_p bigint, ie_centro_resultado_p text, ie_tipo_centro_controle_p text, nr_seq_tabela_p bigint, ie_unidade_negocio_p bigint DEFAULT null) RETURNS bigint AS $body$
DECLARE


cd_classif_rec_liq_w		bigint;
cd_empresa_w			smallint;
qt_classif_calc_w		bigint;
vl_receita_liquida_w		double precision	:= 0;
ie_somente_centro_usuario_w	varchar(1);


BEGIN

cd_empresa_w	:= obter_empresa_estab(cd_estabelecimento_p);

select	min(cd_classificacao)
into STRICT	cd_classif_rec_liq_w
from	classif_result
where	ie_receita_liquida	= 'S'
and	cd_empresa	= cd_empresa_w;

select	count(*)
into STRICT	qt_classif_calc_w
from	classif_result
where	cd_classif_calc	= cd_classificacao_p
and	cd_empresa	= cd_empresa_w;

ie_somente_centro_usuario_w := coalesce(substr(obter_valor_param_usuario(927, 3, wheb_usuario_pck.get_cd_perfil(), wheb_usuario_pck.get_nm_usuario(), wheb_usuario_pck.get_cd_estabelecimento()),1,1),'N');

if (cd_classificacao_p >= cd_classif_rec_liq_w) and (qt_classif_calc_w > 0) then
	begin
	if (cd_centro_controle_p = 99999999) then
		begin
		if (ie_tipo_centro_controle_p = 2) then
			select	sum(vl_mes)
			into STRICT	vl_receita_liquida_w
			from	centro_controle c,
				classif_result b,
				resultado_centro_controle a
			where	a.cd_estabelecimento	= c.cd_estabelecimento
			and	a.cd_centro_controle	= c.cd_centro_controle
			and	a.ie_classif_conta		= b.cd_classificacao
			and	c.ie_situacao		= 'A'
			and	b.ie_receita_liquida		= 'S'
			and	c.ie_tipo_centro_controle	= ie_tipo_centro_controle_p
			and	c.ie_centro_resultado	= coalesce(ie_centro_resultado_p,'N')
			and (a.cd_estabelecimento	= cd_estabelecimento_p or cd_estabelecimento_p = 0)
			and	a.nr_seq_tabela		= nr_seq_tabela_p
			and	((ie_somente_centro_usuario_w = 'N') or (cus_obter_se_centro_usuario(a.cd_estabelecimento,a.cd_centro_controle,wheb_usuario_pck.get_nm_usuario()) = 'S'))
			and	((coalesce(ie_unidade_negocio_p, 0) = 0) or (substr(cus_obter_se_centro_unid_neg(c.cd_estabelecimento, c.cd_centro_controle, ie_unidade_negocio_p),1,1) = 'S'))
			and	b.cd_empresa		= cd_empresa_w;
		else
			select	sum(vl_mes)
			into STRICT	vl_receita_liquida_w
			from	centro_controle c,
				classif_result b,
				resultado_centro_controle a
			where	a.cd_estabelecimento	= c.cd_estabelecimento
			and	a.cd_centro_controle	= c.cd_centro_controle
			and	a.ie_classif_conta		= b.cd_classificacao
			and	c.ie_situacao		= 'A'
			and	b.ie_receita_liquida		= 'S'
			and	c.ie_tipo_centro_controle <> ie_tipo_centro_controle_p
			and	c.ie_centro_resultado	= coalesce(ie_centro_resultado_p,'N')
			and (a.cd_estabelecimento	= cd_estabelecimento_p or cd_estabelecimento_p = 0)
			and	a.NR_SEQ_TABELA		= nr_seq_tabela_p
			and	((ie_somente_centro_usuario_w = 'N') or (cus_obter_se_centro_usuario(a.cd_estabelecimento,a.cd_centro_controle,wheb_usuario_pck.get_nm_usuario()) = 'S'))
			and	((coalesce(ie_unidade_negocio_p, 0) = 0) or (substr(cus_obter_se_centro_unid_neg(c.cd_estabelecimento, c.cd_centro_controle, ie_unidade_negocio_p),1,1) = 'S'))
			and	b.cd_empresa		= cd_empresa_w;
		end if;
		end;	
	else
		select	sum(vl_mes)
		into STRICT	vl_receita_liquida_w
		from	centro_controle c,
			classif_result b,
			resultado_centro_controle a
		where	a.cd_estabelecimento	= c.cd_estabelecimento
		and	a.cd_centro_controle	= c.cd_centro_controle
		and	a.ie_classif_conta		= b.cd_classificacao
		and	c.ie_situacao		= 'A'
		and	b.ie_receita_liquida		= 'S'
		and	((c.ie_tipo_centro_controle	= ie_tipo_centro_controle_p) or (coalesce(ie_tipo_centro_controle_p::text, '') = ''))
		and	c.ie_centro_resultado	= coalesce(ie_centro_resultado_p,'N')
		and (a.cd_estabelecimento	= cd_estabelecimento_p or cd_estabelecimento_p = 0)
		and	a.NR_SEQ_TABELA		= nr_seq_tabela_p
		and	c.cd_centro_controle	= cd_centro_controle_p
		and	((ie_somente_centro_usuario_w = 'N') or (cus_obter_se_centro_usuario(a.cd_estabelecimento,a.cd_centro_controle,wheb_usuario_pck.get_nm_usuario()) = 'S'))
		and	((coalesce(ie_unidade_negocio_p, 0) = 0) or (substr(cus_obter_se_centro_unid_neg(c.cd_estabelecimento, c.cd_centro_controle, ie_unidade_negocio_p),1,1) = 'S'))
		and	b.cd_empresa		= cd_empresa_w;
	end if;
	end;
end if;

return vl_receita_liquida_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION cus_obter_rec_liquida_classif ( cd_estabelecimento_p bigint, cd_tabela_custo_p bigint, cd_centro_controle_p bigint, cd_classificacao_p bigint, ie_centro_resultado_p text, ie_tipo_centro_controle_p text, nr_seq_tabela_p bigint, ie_unidade_negocio_p bigint DEFAULT null) FROM PUBLIC;

