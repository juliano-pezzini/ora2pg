-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_copiar_natureza_estab () AS $body$
DECLARE


cd_estabelecimento_w		bigint;
cd_grupo_natureza_gasto_w		bigint;
cd_natureza_gasto_w		numeric(20);

c01 CURSOR FOR
SELECT	cd_estabelecimento
from	estabelecimento
where	cd_empresa		= 1
and	cd_estabelecimento	<> 5;

c02 CURSOR FOR
SELECT	a.cd_grupo_natureza_gasto
from	grupo_natureza_gasto a
where	a.cd_estabelecimento	= 5
and	not exists (	select	1
			from	grupo_natureza_gasto y
			where	y.cd_grupo_natureza_gasto = a.cd_grupo_natureza_gasto
			and	y.cd_estabelecimento	= cd_estabelecimento_w);

c03 CURSOR FOR
SELECT	a.cd_natureza_gasto
from	natureza_gasto a
where	a.cd_estabelecimento	  = 5
and	a.cd_grupo_natureza_gasto = cd_grupo_natureza_gasto_w
and	not exists (	select	1
			from	natureza_gasto y
			where	y.cd_natureza_gasto	= a.cd_natureza_gasto
			and	y.cd_estabelecimento	= cd_estabelecimento_w);


BEGIN

open C01;
loop
fetch C01 into
	cd_estabelecimento_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin

	open C02;
	loop
	fetch C02 into
		cd_grupo_natureza_gasto_w;
	EXIT WHEN NOT FOUND; /* apply on C02 */
		begin
		/*Insere grupos de Natureza de gasto*/

		insert into grupo_natureza_gasto(
			cd_estabelecimento,
			cd_grupo_natureza_gasto,
			ds_grupo_natureza_gasto,
			nm_usuario,
			dt_atualizacao,
			ie_situacao,
			ie_tipo_gasto,
			ie_compoe_taxa_custo,
			cd_nivel_capac_max,
			ie_classif_custo,
			dt_atualizacao_nrec,
			nm_usuario_nrec)
		SELECT	cd_estabelecimento_w,
			cd_grupo_natureza_gasto,
			ds_grupo_natureza_gasto,
			'BacaCopiaEstab',
			clock_timestamp(),
			ie_situacao,
			ie_tipo_gasto,
			ie_compoe_taxa_custo,
			cd_nivel_capac_max,
			ie_classif_custo,
			clock_timestamp(),
			'BacaCopiaEstab'
		from	grupo_natureza_gasto
		where	cd_grupo_natureza_gasto = cd_grupo_natureza_gasto_w
		and	cd_estabelecimento	= 5;

		open C03;
		loop
		fetch C03 into
			cd_natureza_gasto_w;
		EXIT WHEN NOT FOUND; /* apply on C03 */
			begin
			/*Gravar naturezas de gasto do grupo */

			insert into natureza_gasto(
				cd_estabelecimento,
				cd_natureza_gasto,
				ds_natureza_gasto,
				nm_usuario,
				dt_atualizacao,
				ie_situacao,
				ie_natureza_gasto,
				cd_grupo_natureza_gasto,
				qt_dias_prazo_medio,
				ie_resumo,
				cd_classif_result,
				cd_conta_contabil)
			SELECT	cd_estabelecimento_w,
				cd_natureza_gasto_w,
				ds_natureza_gasto,
				'BacaCopiaEstab',
				clock_timestamp(),
				ie_situacao,
				ie_natureza_gasto,
				cd_grupo_natureza_gasto_w,
				qt_dias_prazo_medio,
				ie_resumo,
				cd_classif_result,
				cd_conta_contabil
			from	natureza_gasto
			where	cd_natureza_gasto	= cd_natureza_gasto_w
			and	cd_estabelecimento	= 5;
			end;
		end loop;
		close C03;

		commit;

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
-- REVOKE ALL ON PROCEDURE baca_copiar_natureza_estab () FROM PUBLIC;
