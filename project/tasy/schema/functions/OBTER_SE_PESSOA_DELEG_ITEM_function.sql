-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_pessoa_deleg_item ( cd_material_p bigint, nr_seq_aprovacao_p bigint, nr_seq_processo_p bigint, cd_pessoa_fisica_p text, ie_objetivo_p text, dt_limite_p timestamp) RETURNS varchar AS $body$
DECLARE


ie_retorno_w		varchar(1)	:= 'S';
cd_pessoa_fisica_w	varchar(10);
cd_aprovador_w		varchar(10);
qt_existe_delegacao_w	bigint;
cd_material_w		integer;
cd_grupo_material_w	smallint;
cd_subgrupo_material_w	smallint;
cd_classe_material_w	integer;
qt_existe_w		bigint;
ie_existe_w		varchar(1)	:= 'N';
ie_consignado_w		varchar(1);
ie_material_estoque_w	varchar(1);
qt_existe_regra_w		bigint;

c01 CURSOR FOR
SELECT	f.cd_pessoa_fisica
from	pessoa_fisica f,
	processo_aprov_compra p
where	p.cd_pessoa_fisica = f.cd_pessoa_fisica
and	(p.cd_pessoa_fisica IS NOT NULL AND p.cd_pessoa_fisica::text <> '')
and	p.nr_sequencia = nr_seq_aprovacao_p
and	p.nr_seq_proc_aprov = nr_seq_processo_p

union all

select	f.cd_pessoa_fisica
from	pessoa_fisica f,
	processo_aprov_compra p
where	f.cd_cargo = p.cd_cargo
and	(p.cd_cargo IS NOT NULL AND p.cd_cargo::text <> '')
and	p.nr_sequencia = nr_seq_aprovacao_p
and	p.nr_seq_proc_aprov = nr_seq_processo_p;

c02 CURSOR FOR
SELECT	cd_material,
	cd_grupo_material,
	cd_subgrupo_material,
	cd_classe_material,
	coalesce(ie_consignado,'X'),
	coalesce(ie_material_estoque,'A')
from	pessoa_fisica_delegacao
where	cd_pessoa_fisica = cd_aprovador_w
and	cd_pessoa_substituta = cd_pessoa_fisica_p
and	ie_objetivo = ie_objetivo_p
and	((coalesce(PKG_DATE_UTILS.start_of(dt_inicio_limite, 'dd', 0),PKG_DATE_UTILS.start_of(clock_timestamp(), 'dd', 0)) <= PKG_DATE_UTILS.start_of(clock_timestamp(), 'dd', 0)) and (PKG_DATE_UTILS.start_of(dt_limite, 'dd', 0) >= PKG_DATE_UTILS.start_of(clock_timestamp(), 'dd', 0)));


BEGIN

select	count(*)
into STRICT	qt_existe_regra_w
from	pessoa_fisica_delegacao
where	cd_pessoa_substituta = cd_pessoa_fisica_p
and	ie_objetivo = ie_objetivo_p
and	((coalesce(PKG_DATE_UTILS.start_of(dt_inicio_limite, 'dd', 0),PKG_DATE_UTILS.start_of(clock_timestamp(), 'dd', 0)) <= PKG_DATE_UTILS.start_of(clock_timestamp(), 'dd', 0)) and (PKG_DATE_UTILS.start_of(dt_limite, 'dd', 0) >= PKG_DATE_UTILS.start_of(clock_timestamp(), 'dd', 0)));

if (qt_existe_regra_w > 0) then
	begin

	open c01;
	loop
	fetch c01 into
		cd_pessoa_fisica_w;
	EXIT WHEN NOT FOUND; /* apply on c01 */
		begin

		select	count(*)
		into STRICT	qt_existe_delegacao_w
		from	pessoa_fisica_delegacao
		where	cd_pessoa_fisica = cd_pessoa_fisica_w
		and	cd_pessoa_substituta = cd_pessoa_fisica_p
		and	ie_objetivo = ie_objetivo_p
		and	((coalesce(PKG_DATE_UTILS.start_of(dt_inicio_limite, 'dd', 0),PKG_DATE_UTILS.start_of(clock_timestamp(), 'dd', 0)) <= PKG_DATE_UTILS.start_of(clock_timestamp(), 'dd', 0)) and (PKG_DATE_UTILS.start_of(dt_limite, 'dd', 0) >= PKG_DATE_UTILS.start_of(clock_timestamp(), 'dd', 0)));

		if (qt_existe_delegacao_w > 0) then
			cd_aprovador_w	:= cd_pessoa_fisica_w;
			ie_existe_w	:= 'S';
		end if;

		end;
	end loop;
	close c01;

	if (ie_existe_w = 'S') then
		begin

		ie_retorno_w	:= 'N';

		open c02;
		loop
		fetch c02 into
			cd_material_w,
			cd_grupo_material_w,
			cd_subgrupo_material_w,
			cd_classe_material_w,
			ie_consignado_w,
			ie_material_estoque_w;
		EXIT WHEN NOT FOUND or ie_retorno_w = 'S';  /* apply on c02 */
			begin

			select	count(*)
			into STRICT	qt_existe_w
			from	estrutura_material_v
			where	cd_material = cd_material_p
			and (cd_material = coalesce(cd_material_w,cd_material))
			and (cd_grupo_material = coalesce(cd_grupo_material_w,cd_grupo_material))
			and (cd_subgrupo_material = coalesce(cd_subgrupo_material_w,cd_subgrupo_material))
			and (cd_classe_material = coalesce(cd_classe_material_w,cd_classe_material))
			and	((ie_consignado_w = 'X') 	or (ie_consignado = ie_consignado_w))
			and	((ie_material_estoque_w = 'A') or (ie_material_estoque_w = ie_material_estoque));

			if (qt_existe_w > 0) then
				ie_retorno_w := 'S';
			else
				ie_retorno_w := 'N';
			end if;

			end;
		end loop;
		close c02;

		end;
	else
		ie_retorno_w	:= 'S';
	end if;

	end;
end if;

return ie_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_pessoa_deleg_item ( cd_material_p bigint, nr_seq_aprovacao_p bigint, nr_seq_processo_p bigint, cd_pessoa_fisica_p text, ie_objetivo_p text, dt_limite_p timestamp) FROM PUBLIC;
