-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE PROCEDURE baca_conta_nf (dt_parametro_P timestamp) AS $body$
DECLARE


dt_parametro_inicio_w	timestamp;
dt_parametro_fim_w		timestamp;
cd_estabelecimento_w		integer;
cd_material_w			integer;
cd_centro_custo_w		integer;
cd_conta_contabil_w		varchar(20);
cd_local_estoque_w		integer;
nr_sequencia_w		bigint;
nr_item_nf_w			integer;
ie_tipo_conta_w		smallint;

C01 CURSOR FOR
SELECT a.cd_estabelecimento,
	b.nr_sequencia,
	b.nr_item_nf,
	b.cd_conta_contabil,
	b.cd_centro_custo,
	b.cd_local_estoque,
	b.cd_material
from 	nota_fiscal_item b,
	nota_fiscal a
where	a.DT_ATUALIZACAO_ESTOQUE between dt_parametro_inicio_w and dt_parametro_fim_w
and	a.nr_sequencia	= b.nr_sequencia;


BEGIN

dt_parametro_fim_w                  := last_day(Trunc(dt_parametro_p,'dd')) + 86399/86400;
dt_parametro_Inicio_w		  := trunc(dt_parametro_p,'month');

OPEN C01;
LOOP
FETCH C01 into
	cd_estabelecimento_w,
	nr_sequencia_w,
	nr_item_nf_w,
	cd_conta_contabil_w,
	cd_centro_custo_w,
	cd_local_estoque_w,
	cd_material_w;
EXIT WHEN NOT FOUND; /* apply on C01 */
	begin
	if (coalesce(cd_centro_custo_w::text, '') = '') then
		ie_tipo_conta_w	:= 2;
	else
		ie_tipo_conta_w	:= 3;
	end if;
	SELECT * FROM define_conta_material(
			cd_estabelecimento_w, cd_material_w, ie_tipo_conta_w, null, 0, null, 0, 0, 0, 0, cd_local_estoque_w, Null, dt_parametro_P, cd_conta_contabil_w, cd_centro_custo_w, '') INTO STRICT cd_conta_contabil_w, cd_centro_custo_w;

	if (cd_conta_contabil_w IS NOT NULL AND cd_conta_contabil_w::text <> '') then
		update	nota_fiscal_item
		set 	cd_conta_contabil	= cd_conta_contabil_w,
			dt_atualizacao	= clock_timestamp()
		where	nr_sequencia		= nr_sequencia_w
		and	nr_item_nf		= nr_item_nf;
	end if;
	end;
END LOOP;
close c01;
commit;
END;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
;
-- REVOKE ALL ON PROCEDURE baca_conta_nf (dt_parametro_P timestamp) FROM PUBLIC;

