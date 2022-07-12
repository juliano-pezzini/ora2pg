-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION fa_obter_orientacao_medic (cd_material_p bigint, cd_estabelecimento_p bigint default 0, ie_via_aplicacao_p text default null) RETURNS varchar AS $body$
DECLARE


ds_orientacao_w			varchar(2000);


BEGIN
if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then
	if (coalesce(ie_via_aplicacao_p::text, '') = '') then
		select 	max(ds_orientacao)
		into STRICT ds_orientacao_w
		from 	fa_orientacao_medic b,
			fa_medic_farmacia_amb a
		where 	a.nr_sequencia = b.nr_seq_medic
		and 	a.cd_material = cd_material_P
		and	((coalesce(a.cd_estabelecimento,coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0)) or (coalesce(cd_estabelecimento_p,0) = 0))
		and (coalesce(b.ie_via_aplicacao::text, '') = '' and coalesce(ie_via_aplicacao_p::text, '') = '');
	else
		select 	max(ds_orientacao)
		into STRICT ds_orientacao_w
		from 	fa_orientacao_medic b,
			fa_medic_farmacia_amb a
		where 	a.nr_sequencia = b.nr_seq_medic
		and 	a.cd_material = cd_material_P
		and	((coalesce(a.cd_estabelecimento,coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0)) or (coalesce(cd_estabelecimento_p,0) = 0))
		and (upper(b.ie_via_aplicacao)) = upper(ie_via_aplicacao_p);

		if coalesce(ds_orientacao_w::text, '') = '' then
			select 	max(ds_orientacao)
			into STRICT ds_orientacao_w
			from 	fa_orientacao_medic b,
				fa_medic_farmacia_amb a
			where 	a.nr_sequencia = b.nr_seq_medic
			and 	a.cd_material = cd_material_P
			and	((coalesce(a.cd_estabelecimento,coalesce(cd_estabelecimento_p,0)) = coalesce(cd_estabelecimento_p,0)) or (coalesce(cd_estabelecimento_p,0) = 0))
			and (coalesce(b.ie_via_aplicacao::text, '') = '' and (ie_via_aplicacao_p IS NOT NULL AND ie_via_aplicacao_p::text <> ''));
		end if;

	end if;


end if;

return	ds_orientacao_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION fa_obter_orientacao_medic (cd_material_p bigint, cd_estabelecimento_p bigint default 0, ie_via_aplicacao_p text default null) FROM PUBLIC;

