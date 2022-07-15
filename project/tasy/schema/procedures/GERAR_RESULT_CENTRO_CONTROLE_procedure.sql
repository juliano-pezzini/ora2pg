-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE gerar_result_centro_controle ( cd_estabelecimento_p bigint, cd_tabela_custo_p bigint) AS $body$
DECLARE



cd_centro_controle_w				integer;
ds_centro_controle_w				varchar(50);
vl_receita_bruta_w				double precision	:= 0;
vl_deducao_w					double precision	:= 0;
vl_receita_liquida_w				double precision	:= 0;
vl_custo_direto_w				double precision	:= 0;
vl_margem_contrib_w				double precision	:= 0;
vl_administracao_w				double precision	:= 0;
vl_custo_ind_proprio_w			double precision	:= 0;
vl_custo_ind_apoio_w				double precision	:= 0;
vl_total_indireto_w				double precision	:= 0;
vl_lucro_bruto_w				double precision	:= 0;
vl_desp_adm_w					double precision	:= 0;
vl_result_mes1_w				double precision	:= 0;
vl_indireto_desp_w				double precision	:= 0;
vl_ponto_equilibrio_w			double precision	:= 0;
vl_lucro_operacional_w			double precision	:= 0;
vl_dif_rec_liq_pe_w				double precision	:= 0;
pr_margem_contrib_w				double precision	:= 0;
pr_ponto_equilibrio_w			double precision	:= 0;
pr_lucro_operacional_w			double precision	:= 0;
dt_mes_refer1_w				timestamp;
cd_tabela_custo_mes1_w			integer	:= 0;
cd_empresa_w					smallint;

c01 CURSOR FOR
	SELECT	a.cd_centro_controle,
		b.ds_centro_controle
	from	centro_controle b,
		resultado_centro_controle a
	where	a.cd_centro_controle	= b.cd_centro_controle
	and	a.cd_estabelecimento	= cd_estabelecimento_p
	and	a.cd_tabela_custo	= cd_tabela_custo_p
	and	b.ie_centro_resultado	= 'S'
	group by a.cd_centro_controle,
		b.ds_centro_controle;


BEGIN

/*Matheus OS 48462 em 02/02/07 Restricao da classif_result por empresa*/

select	obter_empresa_estab(cd_estabelecimento_p)
into STRICT	cd_empresa_w
;

delete from w_result_centro;

select	PKG_DATE_UTILS.ADD_MONTH(dt_mes_referencia, -1, 0)
into STRICT	dt_mes_refer1_w
from	tabela_custo
where	cd_tabela_custo	= cd_tabela_custo_p;


begin
select	cd_tabela_custo
into STRICT	cd_tabela_custo_mes1_w
from	tabela_custo
where	dt_mes_referencia	= dt_mes_refer1_w
and	cd_tipo_tabela_custo	= 11;
exception
when others then
	cd_tabela_custo_mes1_w := 0;
end;


open	c01;
loop
fetch	c01 into
	cd_centro_controle_w,
	ds_centro_controle_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */


	/* Obter valor margem contribuição */

	select	coalesce(sum(coalesce(a.vl_mes,0)),0)
	into STRICT	vl_margem_contrib_w
	from	resultado_centro_controle a,
		classif_result b
	where	a.cd_estabelecimento	= cd_estabelecimento_p
	and	b.cd_empresa		= cd_empresa_w
	and	a.cd_centro_controle	= cd_centro_controle_w
	and	a.cd_tabela_custo	= cd_tabela_custo_p
	and	a.ie_classif_conta	= b.cd_classificacao
	and	b.ie_tipo_classif	= 4;


	/* Obter valor custo indireto apoio  */

	select	coalesce(sum(coalesce(a.vl_mes,0)),0)
	into STRICT	vl_custo_ind_apoio_w
	from	resultado_centro_controle a,
		classif_result b
	where	a.cd_estabelecimento	= cd_estabelecimento_p
	and	b.cd_empresa		= cd_empresa_w
	and	a.cd_centro_controle	= cd_centro_controle_w
	and	a.cd_tabela_custo	= cd_tabela_custo_p
	and	a.ie_classif_conta	= b.cd_classificacao
	and	b.ie_tipo_classif	= 6;


	/* Obter valor custo indireto proprio */

	select	coalesce(sum(coalesce(a.vl_mes,0)),0)
	into STRICT	vl_custo_ind_proprio_w
	from	resultado_centro_controle a,
		classif_result b
	where	a.cd_estabelecimento	= cd_estabelecimento_p
	and	b.cd_empresa		= cd_empresa_w
	and	a.cd_centro_controle	= cd_centro_controle_w
	and	a.cd_tabela_custo	= cd_tabela_custo_p
	and	a.ie_classif_conta	= b.cd_classificacao
	and	b.ie_tipo_classif	= 5;


	/* Obter valor custo direto */

	select	coalesce(sum(coalesce(a.vl_mes,0)),0)
	into STRICT	vl_custo_direto_w
	from	resultado_centro_controle a,
		classif_result b
	where	a.cd_estabelecimento	= cd_estabelecimento_p
	and	b.cd_empresa		= cd_empresa_w
	and	a.cd_centro_controle	= cd_centro_controle_w
	and	a.cd_tabela_custo	= cd_tabela_custo_p
	and	a.ie_classif_conta	= b.cd_classificacao
	and	b.ie_tipo_classif	= 3;


	/* Obter valor lucro bruto */

	select	coalesce(sum(coalesce(a.vl_mes,0)),0)
	into STRICT	vl_lucro_bruto_w
	from	resultado_centro_controle a,
		classif_result b
	where	a.cd_estabelecimento	= cd_estabelecimento_p
	and	b.cd_empresa		= cd_empresa_w
	and	a.cd_centro_controle	= cd_centro_controle_w
	and	a.cd_tabela_custo	= cd_tabela_custo_p
	and	a.ie_classif_conta	= b.cd_classificacao
	and	b.ie_tipo_classif	= 9;

	/* Obter valor despesa administrativa */

	select	coalesce(sum(coalesce(a.vl_mes,0)),0)
	into STRICT	vl_desp_adm_w
	from	resultado_centro_controle a,
		classif_result b
	where	a.cd_estabelecimento	= cd_estabelecimento_p
	and	b.cd_empresa		= cd_empresa_w
	and	a.cd_centro_controle	= cd_centro_controle_w
	and	a.cd_tabela_custo	= cd_tabela_custo_p
	and	a.ie_classif_conta	= b.cd_classificacao
	and	b.ie_tipo_classif	= 7;


	/* Obter valor resultado Mes 1 */

	select	coalesce(sum(coalesce(a.vl_mes,0)),0)
	into STRICT	vl_result_mes1_w
	from	resultado_centro_controle a,
		classif_result b
	where	a.cd_estabelecimento	= cd_estabelecimento_p
	and	b.cd_empresa		= cd_empresa_w
	and	a.cd_centro_controle	= cd_centro_controle_w
	and	a.cd_tabela_custo	= cd_tabela_custo_mes1_w
	and	a.ie_classif_conta	= b.cd_classificacao
	and	b.ie_tipo_classif	= 1;



	/* Obter Glosas */

	select	coalesce(sum(coalesce(a.vl_mes,0)),0)
	into STRICT	vl_deducao_w
	from	resultado_centro_controle a,
		classif_result c
	where	a.cd_estabelecimento	= cd_estabelecimento_p
	and	c.cd_empresa		= cd_empresa_w
	and	a.cd_centro_controle	= cd_centro_controle_w
	and	a.cd_tabela_custo	= cd_tabela_custo_p
	and	a.ie_classif_conta	= c.cd_classificacao
	and	c.ie_tipo_classif	= 2;


	/* Obter Receita Bruta */

	select	coalesce(sum(coalesce(a.vl_mes,0)),0)
	into STRICT	vl_receita_bruta_w
	from	resultado_centro_controle a,
		classif_result c
	where	a.cd_estabelecimento	= cd_estabelecimento_p
	and	c.cd_empresa		= cd_empresa_w
	and	a.cd_centro_controle	= cd_centro_controle_w
	and	a.cd_tabela_custo	= cd_tabela_custo_p
	and	a.ie_classif_conta	= c.cd_classificacao
	and	c.ie_tipo_classif	= 1;

	/* Total custos indiretos */

	begin
		vl_total_indireto_w	:= (vl_custo_ind_proprio_w + vl_custo_ind_apoio_w);
	exception
		when others then
			vl_total_indireto_w 	:= 0;
	end;

	/* Obter Receita Liquida */

	begin
  		vl_receita_liquida_w	:= (vl_receita_bruta_w + vl_deducao_w);
	exception
		when others then
			vl_receita_liquida_w 	:= 0;
	end;

	/* Obter Total Indiretos + Desp. Administrativas */

	begin
  		vl_indireto_desp_w	:= (vl_total_indireto_w + vl_desp_adm_w);
	exception
		when others then
			vl_indireto_desp_w 	:= 0;
	end;

	/* Obter Lucro operacional */

	begin
  		vl_lucro_operacional_w	:= (vl_lucro_bruto_w - vl_desp_adm_w);
	exception
		when others then
			vl_lucro_operacional_w 	:= 0;
	end;


	/* Obter Diferenca ponto de equilibrio e receita liquida */

	begin
  		vl_dif_rec_liq_pe_w	:= (vl_receita_liquida_w - vl_ponto_equilibrio_w);
	exception
		when others then
			vl_dif_rec_liq_pe_w 	:= 0;
	end;

	/* Obter % margem contrib sobre rec.liq. */

	begin
  		pr_margem_contrib_w	:= (vl_margem_contrib_w / vl_receita_liquida_w) * 100;
	exception
		when others then
			pr_margem_contrib_w 	:= 0;
	end;

	/* Obter % lucro operacional sobre rec.liq. */

	begin
  		pr_lucro_operacional_w	:= (vl_lucro_operacional_w / vl_receita_liquida_w) * 100;
	exception
		when others then
			pr_lucro_operacional_w 	:= 0;
	end;

	/* Obter % ponto equilibrio sobre rec.liq. */

	begin
  		pr_ponto_equilibrio_w	:= (vl_ponto_equilibrio_w / vl_receita_liquida_w) * 100;
	exception
		when others then
			pr_ponto_equilibrio_w 	:= 0;
	end;

	insert into w_result_centro(cd_centro_controle,
			ds_centro_controle,
			vl_receita_bruta,
			vl_deducao,
			vl_receita_liquida,
			vl_custo_direto,
			vl_margem_contrib,
			vl_custo_ind_apoio,
			vl_custo_ind_proprio,
			vl_lucro_bruto,
			vl_desp_adm,
			vl_result_mes1,
			vl_indireto_desp,
			vl_ponto_equilibrio,
			vl_total_indireto,
			vl_lucro_operacional,
			vl_dif_rec_liq_pe,
			pr_margem_contrib,
			pr_lucro_operacional,
			pr_ponto_equilibrio)
		values (cd_centro_controle_w,
			ds_centro_controle_w,
			vl_receita_bruta_w,
			vl_deducao_w,
			vl_receita_liquida_w,
			vl_custo_direto_w,
			vl_margem_contrib_w,
			vl_custo_ind_apoio_w,
			vl_custo_ind_proprio_w,
			vl_lucro_bruto_w,
			vl_desp_adm_w,
			vl_result_mes1_w,
			vl_indireto_desp_w,
			vl_ponto_equilibrio_w,
			vl_total_indireto_w,
			vl_lucro_operacional_w,
			vl_dif_rec_liq_pe_w,
			pr_margem_contrib_w,
			pr_lucro_operacional_w,
			pr_ponto_equilibrio_w);
end loop;
close c01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE gerar_result_centro_controle ( cd_estabelecimento_p bigint, cd_tabela_custo_p bigint) FROM PUBLIC;

