-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_orc_cen_aplicar_regra ( nr_seq_cenario_p bigint, nr_sequencia_p bigint, cd_centro_custo_p bigint, cd_conta_contabil_p text, cd_classif_conta_p text, cd_classif_centro_p text, nr_seq_mes_ref_p bigint, dt_mes_inic_p timestamp, dt_mes_fim_p timestamp, cd_centro_origem_p bigint, cd_conta_origem_p text, ie_regra_valor_p text, pr_aplicar_p bigint, ie_sobrepor_p text, nr_seq_criterio_rateio_p bigint, vl_fixo_p bigint, cd_empresa_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, dt_vigencia_p timestamp, ds_observacao_p text) AS $body$
DECLARE


/*
ie_regra_valor - dominio 1690
			VF            valor fixo
			PAV           percentual adicional da origem
			PV            percentual do valor
			CM            cálculo a partir da métrica
			PPV           percentual progressivo da origem
*/
nr_seq_mes_ref_w			bigint;
nr_seq_mes_ant_w			bigint;
cd_estabelecimento_w			integer;
cd_conta_contabil_w			varchar(20);
cd_conta_contabil_ww			varchar(20);
cd_centro_custo_w			integer;
nr_sequencia_w			bigint;
vl_orcado_w				double precision;
vl_orcado_ww				double precision;
pr_rateio_w				double precision;
ds_erro_w				varchar(2000);
qt_reg_w				bigint;

c01 CURSOR FOR
SELECT	a.cd_estabelecimento,
	a.cd_conta_contabil,
	a.cd_centro_custo,
	a.vl_orcado,
	a.nr_seq_mes_ref
from	ctb_orc_cen_valor a
where	a.nr_seq_cenario	= nr_seq_cenario_p
and	a.cd_estabelecimento	= cd_estabelecimento_p
and	ie_regra_valor_p	in ('PAV','PV', 'PPV')
and	a.cd_centro_custo 	= coalesce(cd_centro_origem_p, a.cd_centro_custo)
and	a.nr_seq_mes_ref in (
	SELECT	nr_sequencia
	from	ctb_mes_ref
	where	dt_referencia between trunc(dt_mes_inic_p,'month') and trunc(dt_mes_fim_p,'month')
	and	cd_empresa = cd_empresa_p
	
union

	select	(nr_seq_mes_ref_p)::numeric
	)
and (coalesce(cd_classif_conta_p::text, '') = '' or ctb_obter_se_conta_classif_sup(a.cd_conta_contabil, cd_classif_conta_p) = 'S')
and	a.cd_conta_contabil 	= coalesce(cd_conta_origem_p, a.cd_conta_contabil)

union all

select	cd_estabelecimento_p,
	cd_conta_contabil_p,
	cd_centro_custo_p,
	vl_fixo_p,
	a.nr_sequencia nr_seq_mes_ref
from	ctb_mes_ref a
where	ie_regra_valor_p	= 'VF'
and	a.cd_empresa 		= cd_empresa_p
and	a.nr_sequencia in (
		select	nr_sequencia
		from	ctb_mes_ref
		where	dt_referencia between trunc(dt_mes_inic_p,'month') and trunc(dt_mes_fim_p,'month')
		and	cd_empresa = cd_empresa_p
		
union

		select	(nr_seq_mes_ref_p)::numeric 
		)
and	(cd_conta_contabil_p IS NOT NULL AND cd_conta_contabil_p::text <> '')
and	((cd_centro_custo_p IS NOT NULL AND cd_centro_custo_p::text <> '') or (nr_seq_criterio_rateio_p IS NOT NULL AND nr_seq_criterio_rateio_p::text <> ''));

c02 CURSOR FOR
SELECT	distinct
	nr_sequencia
from	ctb_mes_ref
where	cd_empresa	= cd_empresa_p
and	dt_referencia between trunc(dt_mes_inic_p,'month') and trunc(dt_mes_fim_p,'month');

c03 CURSOR FOR
SELECT	a.cd_estabelecimento,
	a.cd_conta_contabil,
	a.cd_centro_custo,
	a.vl_orcado,
	a.nr_seq_mes_ref
from	ctb_orc_cen_valor a
where	a.nr_seq_cenario	= nr_seq_cenario_p
and	a.cd_estabelecimento	= cd_estabelecimento_p
and	a.cd_centro_custo	= coalesce(cd_centro_origem_p,a.cd_centro_custo)
and	a.nr_seq_mes_ref in (
		SELECT	nr_sequencia
		from	ctb_mes_ref
		where	dt_referencia between trunc(dt_mes_inic_p,'month') and trunc(dt_mes_fim_p,'month')
		and	cd_empresa = cd_empresa_p
		
union

		select	(nr_seq_mes_ref_p)::numeric
		)
and (coalesce(cd_classif_conta_p::text, '') = '' or ctb_obter_se_conta_classif_sup(a.cd_conta_contabil, cd_classif_conta_p) = 'S')
and	a.cd_conta_contabil 		= coalesce(cd_conta_origem_p, a.cd_conta_contabil);

c04 CURSOR FOR
SELECT	a.cd_estabelecimento,
	b.cd_centro_custo,
	b.pr_rateio
from	ctb_criterio_rateio_item b,
	ctb_criterio_rateio a
where	a.nr_sequencia		= b.nr_seq_criterio
and	b.nr_seq_criterio	= nr_seq_criterio_rateio_p
and (coalesce(dt_inicio_vigencia, dt_vigencia_p) <= dt_vigencia_p and coalesce(dt_fim_vigencia, dt_vigencia_p) >= dt_vigencia_p);


BEGIN

if (ie_regra_valor_p = 'VF') or (coalesce(nr_seq_mes_ref_p::text, '') = '') and not(coalesce(cd_conta_contabil_p::text, '') = '') then


	nr_seq_mes_ant_w	:= null;
	open c01;
	loop
	fetch c01 into
		cd_estabelecimento_w,
		cd_conta_contabil_w,
		cd_centro_custo_w,
		vl_orcado_w,
		nr_seq_mes_ref_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */

		if (ie_regra_valor_p = 'PAV') or (ie_regra_valor_p = 'PV') then

			select	coalesce(sum(vl_orcado),0)
			into STRICT	vl_orcado_w
			from	ctb_orc_cen_valor
			where 	nr_seq_cenario		= nr_seq_cenario_p
			and	nr_seq_mes_ref	 	= nr_seq_mes_ref_w
			and	cd_centro_custo 	= coalesce(cd_centro_origem_p, cd_centro_custo_w)
			and	cd_estabelecimento	= cd_estabelecimento_w
			and	cd_conta_contabil 	= coalesce(cd_conta_origem_p, cd_conta_contabil)
			and (coalesce(cd_classif_conta_p::text, '') = '' or ctb_obter_se_conta_classif_sup(cd_conta_contabil, cd_classif_conta_p) = 'S');
		end if;

		if (ie_regra_valor_p = 'PAV') then
			vl_orcado_w := vl_orcado_w + ((vl_orcado_w * pr_aplicar_p) / 100);
		elsif (ie_regra_valor_p = 'PV') then
			vl_orcado_w := vl_orcado_w * (pr_aplicar_p / 100);

		elsif (ie_regra_valor_p = 'PPV') then

			select	coalesce(sum(vl_orcado),0)
			into STRICT	vl_orcado_w
			from	ctb_orc_cen_valor
			where 	nr_seq_cenario		= nr_seq_cenario_p
			and	nr_seq_mes_ref	 	= coalesce(nr_seq_mes_ant_w, nr_seq_mes_ref_w)
			and	cd_centro_custo 	= coalesce(cd_centro_origem_p, cd_centro_custo_w)
			and	cd_estabelecimento	= cd_estabelecimento_w
			and	cd_conta_contabil 	= coalesce(cd_conta_origem_p, cd_conta_contabil)
			and (coalesce(cd_classif_conta_p::text, '') = '' or ctb_obter_se_conta_classif_sup(cd_conta_contabil, cd_classif_conta_p) = 'S');

			vl_orcado_w	:= vl_orcado_w + ((vl_orcado_w * pr_aplicar_p) / 100);
			nr_seq_mes_ant_w	:= nr_seq_mes_ref_w;

		end if;

		cd_centro_custo_w	:= coalesce(cd_centro_custo_p, cd_centro_custo_w);
		if (coalesce(nr_seq_criterio_rateio_p::text, '') = '') then

			select	count(*)
			into STRICT	qt_reg_w
			from 	ctb_orc_cen_valor
			where 	nr_seq_cenario	= nr_seq_cenario_p
			and	nr_seq_mes_ref	= nr_seq_mes_ref_w
			and	cd_conta_contabil	= cd_conta_contabil_p
			and	cd_centro_custo	= cd_centro_custo_w
			and	cd_estabelecimento 	= cd_estabelecimento_w;
			if (qt_reg_w = 0)	then

				select	nextval('ctb_orc_cen_valor_seq')
				into STRICT	nr_sequencia_w
				;
				insert into ctb_orc_cen_valor(
					nr_sequencia,
					nr_seq_cenario,
					cd_estabelecimento,
					nr_seq_mes_ref,
					dt_atualizacao,
					nm_usuario,
					cd_conta_contabil,
					cd_centro_custo,
					vl_orcado,
					ds_observacao)
				values (nr_sequencia_w,
					nr_seq_cenario_p,
					cd_estabelecimento_w,
					nr_seq_mes_ref_w,
					clock_timestamp(),
					nm_usuario_p,
					cd_conta_contabil_p,
					cd_centro_custo_w,
					vl_orcado_w,
					ds_observacao_p);
			elsif (ie_sobrepor_p = 'S') then
				update	ctb_orc_cen_valor
				set	dt_atualizacao		= clock_timestamp(),
					nm_usuario		= nm_usuario_p,
					vl_orcado			= vl_orcado_w,
					ds_observacao		= ds_observacao_p
				where 	nr_seq_cenario		= nr_seq_cenario_p
				and	nr_seq_mes_ref	 	= nr_seq_mes_ref_w
				and	cd_conta_contabil 	= cd_conta_contabil_p
				and	cd_centro_custo 	= cd_centro_custo_w
				and	cd_estabelecimento 	= cd_estabelecimento_w;
			elsif (ie_sobrepor_p = 'N') and (qt_reg_w > 0) then
				update	ctb_orc_cen_valor
				set	dt_atualizacao	= clock_timestamp(),
					nm_usuario		= nm_usuario_p,
					vl_orcado		= vl_orcado + vl_orcado_w
				where 	nr_seq_cenario	= nr_seq_cenario_p
				and	nr_seq_mes_ref	= nr_seq_mes_ref_w
				and	cd_conta_contabil 	= cd_conta_contabil_p
				and	cd_centro_custo 	= cd_centro_custo_w
				and	cd_estabelecimento	= cd_estabelecimento_w;
			end if;
		elsif (nr_seq_criterio_rateio_p IS NOT NULL AND nr_seq_criterio_rateio_p::text <> '') and (ie_regra_valor_p = 'VF') then
			vl_orcado_ww	:= vl_orcado_w;
			open c04;
			loop
			fetch c04 into
				cd_estabelecimento_w,
				cd_centro_custo_w,
				pr_rateio_w;
			EXIT WHEN NOT FOUND; /* apply on c04 */

				vl_orcado_w	:= vl_orcado_ww * (pr_rateio_w / 100);
				select	count(*)
				into STRICT	qt_reg_w
				from 	ctb_orc_cen_valor
				where 	nr_seq_cenario	= nr_seq_cenario_p
				and	nr_seq_mes_ref	= nr_seq_mes_ref_w
				and	cd_conta_contabil	= cd_conta_contabil_p
				and	cd_centro_custo	= cd_centro_custo_w
				and	cd_estabelecimento 	= cd_estabelecimento_w;

				if (qt_reg_w = 0)	then
					select	nextval('ctb_orc_cen_valor_seq')
					into STRICT	nr_sequencia_w
					;
					insert into ctb_orc_cen_valor(
						nr_sequencia,
						nr_seq_cenario,
						cd_estabelecimento,
						nr_seq_mes_ref,
						dt_atualizacao,
						nm_usuario,
						cd_conta_contabil,
						cd_centro_custo,
						vl_orcado,
						ds_observacao)
					values (nr_sequencia_w,
						nr_seq_cenario_p,
						cd_estabelecimento_w,
						nr_seq_mes_ref_w,
						clock_timestamp(),
						nm_usuario_p,
						cd_conta_contabil_p,
						cd_centro_custo_w,
						vl_orcado_w,
						ds_observacao_p);
				elsif (ie_sobrepor_p = 'S') then
					update	ctb_orc_cen_valor
					set	dt_atualizacao		= clock_timestamp(),
						nm_usuario		= nm_usuario_p,
						vl_orcado		= vl_orcado_w,
						ds_observacao		= ds_observacao_p
					where 	nr_seq_cenario		= nr_seq_cenario_p
					and	nr_seq_mes_ref 		= nr_seq_mes_ref_w
					and	cd_conta_contabil 	= cd_conta_contabil_p
					and	cd_centro_custo 	= cd_centro_custo_w
					and	cd_estabelecimento 	= cd_estabelecimento_w;
				elsif (ie_sobrepor_p = 'N') and (qt_reg_w > 0) then
					update	ctb_orc_cen_valor
					set	dt_atualizacao	= clock_timestamp(),
						nm_usuario		= nm_usuario_p,
						vl_orcado		= vl_orcado + vl_orcado_w
					where 	nr_seq_cenario	= nr_seq_cenario_p
					and	nr_seq_mes_ref	= nr_seq_mes_ref_w
					and	cd_conta_contabil 	= cd_conta_contabil_p
					and	cd_centro_custo 	= cd_centro_custo_w
					and	cd_estabelecimento	= cd_estabelecimento_w;
				end if;
			end loop;
			close c04;
		end if;
	end loop;
	close c01;
else

	begin

	nr_seq_mes_ant_w	:= null;
	open c03;
	loop
	fetch c03 into
		cd_estabelecimento_w,
		cd_conta_contabil_w,
		cd_centro_custo_w,
		vl_orcado_w,
		nr_seq_mes_ref_w;
	EXIT WHEN NOT FOUND; /* apply on c03 */

		cd_conta_contabil_ww		:= coalesce(cd_conta_contabil_p ,cd_conta_contabil_w);
	/*	retirei o cursor co2 matheus os 73203 02/11/2007
		open c02;
		loop
		fetch c02 into nr_seq_mes_ref_w;
		exit when c02%notfound;*/
		if (ie_regra_valor_p = 'PAV') or (ie_regra_valor_p = 'PV') then

			select	coalesce(sum(vl_orcado),0)
			into STRICT	vl_orcado_w
			from	ctb_orc_cen_valor
			where 	nr_seq_cenario		= nr_seq_cenario_p
			and	nr_seq_mes_ref 		= nr_seq_mes_ref_w
			and	cd_centro_custo 		= coalesce(cd_centro_origem_p, cd_centro_custo_w)
			and	cd_estabelecimento		= cd_estabelecimento_w
			and	cd_conta_contabil 		= coalesce(cd_conta_origem_p, cd_conta_contabil)
			and (coalesce(cd_classif_conta_p::text, '') = '' or ctb_obter_se_conta_classif_sup(cd_conta_contabil, cd_classif_conta_p) = 'S');
		end if;


		if (ie_regra_valor_p = 'PAV') then
			vl_orcado_w := vl_orcado_w + ((vl_orcado_w * pr_aplicar_p) / 100);
		elsif (ie_regra_valor_p = 'PV') then
			vl_orcado_w := vl_orcado_w * (pr_aplicar_p / 100);
		elsif (ie_regra_valor_p = 'PPV') then

			select	coalesce(sum(vl_orcado),0)
			into STRICT	vl_orcado_w
			from	ctb_orc_cen_valor
			where 	nr_seq_cenario		= nr_seq_cenario_p
			and	nr_seq_mes_ref 		= coalesce(nr_seq_mes_ant_w, nr_seq_mes_ref_w)
			and	cd_centro_custo 		= coalesce(cd_centro_origem_p, cd_centro_custo_w)
			and	cd_estabelecimento	= cd_estabelecimento_w
			and	cd_conta_contabil 	= coalesce(cd_conta_origem_p, cd_conta_contabil)
			and (coalesce(cd_classif_conta_p::text, '') = '' or ctb_obter_se_conta_classif_sup(cd_conta_contabil, cd_classif_conta_p) = 'S');

			vl_orcado_w	:= vl_orcado_w + ((vl_orcado_w * pr_aplicar_p) / 100);
			nr_seq_mes_ant_w	:= nr_seq_mes_ref_w;
		end if;

			select	count(*)
			into STRICT	qt_reg_w
			from 	ctb_orc_cen_valor
			where	nr_seq_cenario	= nr_seq_cenario_p
			and	nr_seq_mes_ref	= nr_seq_mes_ref_w
			and	cd_conta_contabil	= cd_conta_contabil_ww
			and	cd_estabelecimento	= cd_estabelecimento_w
			and	cd_centro_custo 	= cd_centro_custo_w;
			if (qt_reg_w = 0)	then
				select	nextval('ctb_orc_cen_valor_seq')
				into STRICT	nr_sequencia_w
				;

				insert into ctb_orc_cen_valor(
					nr_sequencia,
					nr_seq_cenario,
					cd_estabelecimento,
					nr_seq_mes_ref,
					dt_atualizacao,
					nm_usuario,
					cd_conta_contabil,
					cd_centro_custo,
					vl_orcado,
					ds_observacao)
				values (nr_sequencia_w,
					nr_seq_cenario_p,
					cd_estabelecimento_w,
					nr_seq_mes_ref_w,
					clock_timestamp(),
					nm_usuario_p,
					cd_conta_contabil_ww,
					cd_centro_custo_w,
					vl_orcado_w,
					ds_observacao_p);
			elsif (ie_sobrepor_p = 'S') then
				update	ctb_orc_cen_valor
				set	dt_atualizacao	= clock_timestamp(),
					nm_usuario		= nm_usuario_p,
					vl_orcado		= vl_orcado_w,
					ds_observacao	= ds_observacao_p
				where 	nr_seq_cenario	= nr_seq_cenario_p
				and	nr_seq_mes_ref	= nr_seq_mes_ref_w
				and	cd_conta_contabil 	= cd_conta_contabil_ww
				and	cd_centro_custo 	= cd_centro_custo_w
				and	cd_estabelecimento	= cd_estabelecimento_w;
			elsif (ie_sobrepor_p = 'N') and (qt_reg_w > 0) then
				update	ctb_orc_cen_valor
				set	dt_atualizacao	= clock_timestamp(),
					nm_usuario		= nm_usuario_p,
					vl_orcado		= vl_orcado + vl_orcado_w
				where 	nr_seq_cenario	= nr_seq_cenario_p
				and	nr_seq_mes_ref	= nr_seq_mes_ref_w
				and	cd_conta_contabil 	= cd_conta_contabil_ww
				and	cd_centro_custo 	= cd_centro_custo_w
				and	cd_estabelecimento	= cd_estabelecimento_w;

			end if;
		/*end loop;
		close c02;*/
	end loop;
	close c03;
	end;
end if;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_orc_cen_aplicar_regra ( nr_seq_cenario_p bigint, nr_sequencia_p bigint, cd_centro_custo_p bigint, cd_conta_contabil_p text, cd_classif_conta_p text, cd_classif_centro_p text, nr_seq_mes_ref_p bigint, dt_mes_inic_p timestamp, dt_mes_fim_p timestamp, cd_centro_origem_p bigint, cd_conta_origem_p text, ie_regra_valor_p text, pr_aplicar_p bigint, ie_sobrepor_p text, nr_seq_criterio_rateio_p bigint, vl_fixo_p bigint, cd_empresa_p bigint, cd_estabelecimento_p bigint, nm_usuario_p text, dt_vigencia_p timestamp, ds_observacao_p text) FROM PUBLIC;
