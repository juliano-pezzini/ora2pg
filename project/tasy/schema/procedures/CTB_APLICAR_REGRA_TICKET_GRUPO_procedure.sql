-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE ctb_aplicar_regra_ticket_grupo ( nr_seq_cenario_p bigint, cd_estabelecimento_p bigint, cd_empresa_p bigint, nr_sequencia_p bigint, nm_usuario_p text, nr_seq_grupo_centro_p bigint, ie_sobrepor_p text, cd_centro_custo_p bigint) AS $body$
DECLARE


cd_centro_custo_w			bigint;
cd_conta_contabil_w			varchar(20);
dt_mes_inicial_w			timestamp;
dt_mes_final_w				timestamp;
dt_referencia_w				timestamp;
nr_seq_mes_ref_w			bigint;
nr_seq_metrica_w			bigint;
pr_valor_w				double precision;
qt_metrica_w				double precision;
vl_fixo_w				double precision;
vl_ticket_medio_w			double precision;
vl_ticket_total_w			double precision;
qt_reg_w				bigint;


c01 CURSOR FOR
SELECT	a.cd_conta_contabil,
	a.pr_valor
from	ctb_regra_tm_distrib a
where	a.nr_seq_regra_ticket	= nr_sequencia_p;

c02 CURSOR FOR
SELECT	a.nr_sequencia,
	a.dt_referencia
from	ctb_mes_ref a
where	a.cd_empresa	= cd_empresa_p
and	a.dt_referencia between dt_mes_inicial_w and dt_mes_final_w
order by 2;

c03 CURSOR FOR
SELECT	cd_centro_custo_p

where	(cd_centro_custo_p IS NOT NULL AND cd_centro_custo_p::text <> '')

union all

select	b.cd_centro_custo
from	ctb_cen_grupo_centro a,
	ctb_cen_centro_grupo b
where	a.nr_sequencia	= b.nr_seq_grupo
and	a.nr_sequencia	= nr_seq_grupo_centro_p
and coalesce(a.cd_estab_exclusivo, cd_estabelecimento_p) = cd_estabelecimento_p
and	coalesce(cd_centro_custo_p::text, '') = ''
and	(nr_seq_grupo_centro_p IS NOT NULL AND nr_seq_grupo_centro_p::text <> '');


BEGIN

select	a.nr_seq_metrica,
	a.vl_fixo,
	a.dt_mes_inic,
	a.dt_mes_fim
into STRICT	nr_seq_metrica_w,
	vl_fixo_w,
	dt_mes_inicial_w,
	dt_mes_final_w
from	ctb_regra_ticket_medio a
where	a.nr_sequencia	= nr_sequencia_p;

open C01;
loop
fetch C01 into
	cd_conta_contabil_w,
	pr_valor_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin


	open C02;
	loop
	fetch C02 into
		nr_seq_mes_ref_w,
		dt_referencia_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin

		open c03;
		loop
		fetch c03 into
			cd_centro_custo_w;
		EXIT WHEN NOT FOUND; /* apply on c03 */
			begin


				select	coalesce(sum(qt_metrica),0)
				into STRICT	qt_metrica_w
				from	ctb_cen_metrica
				where	nr_seq_cenario	= nr_seq_cenario_p
				and	cd_centro_custo	= cd_centro_custo_w
				and	nr_seq_metrica	= nr_seq_metrica_w;

				vl_ticket_total_w	:= (vl_fixo_w * qt_metrica_w);


				vl_ticket_medio_w	:= dividir(vl_ticket_total_w * pr_valor_w, 100);
				vl_ticket_medio_w	:= dividir(vl_ticket_medio_w,qt_metrica_w);

			select	count(*)
			into STRICT	qt_reg_w
			from 	ctb_cen_ticket_medio
			where 	nr_seq_cenario	= nr_seq_cenario_p
			and	nr_seq_mes_ref	= nr_seq_mes_ref_w
			and	nr_seq_metrica	= nr_seq_metrica_w
			and	cd_centro_custo	= cd_centro_custo_w
			and	cd_conta_contabil	= cd_conta_contabil_w;

			if (qt_reg_w = 0)	then
				insert into ctb_cen_ticket_medio(
					nr_sequencia,
					nr_seq_cenario,
					nr_seq_mes_ref,
					cd_estabelecimento,
					cd_centro_custo,
					nr_seq_metrica,
					cd_conta_contabil,
					vl_medio,
					vl_original,
					dt_atualizacao,
					nm_usuario,
					dt_atualizacao_nrec,
					nm_usuario_nrec)
				values (	nextval('ctb_cen_ticket_medio_seq'),
					nr_seq_cenario_p,
					nr_seq_mes_ref_w,
					cd_estabelecimento_p,
					cd_centro_custo_w,
					nr_seq_metrica_w,
					cd_conta_contabil_w,
					vl_ticket_medio_w,
					null,
					clock_timestamp(),
					nm_usuario_p,
					clock_timestamp(),
					nm_usuario_p);
			elsif (ie_sobrepor_p = 'S') then
				update	ctb_cen_ticket_medio
				set	dt_atualizacao		= clock_timestamp(),
					nm_usuario		= nm_usuario_p,
					vl_medio		= vl_ticket_medio_w
				where 	nr_seq_cenario		= nr_seq_cenario_p
				and	nr_seq_mes_ref 		= nr_seq_mes_ref_w
				and	nr_seq_metrica 		= nr_seq_metrica_w
				and	cd_centro_custo 	= cd_centro_custo_w
				and	cd_estabelecimento	= cd_estabelecimento_p
				and	cd_conta_contabil	= cd_conta_contabil_w;
			end if;


			end;
		end loop;
		close c03;
		end;
	end loop;
	close C02;


	end;
end loop;
close C01;

commit;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE ctb_aplicar_regra_ticket_grupo ( nr_seq_cenario_p bigint, cd_estabelecimento_p bigint, cd_empresa_p bigint, nr_sequencia_p bigint, nm_usuario_p text, nr_seq_grupo_centro_p bigint, ie_sobrepor_p text, cd_centro_custo_p bigint) FROM PUBLIC;

