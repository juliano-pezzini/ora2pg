-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_via_aplic_mat_endov (cd_material_p bigint) RETURNS varchar AS $body$
DECLARE


ie_endovenosa_w	varchar(1);
qt_via_mat_w		bigint;
qt_via_mat_ww		bigint;


BEGIN
if (cd_material_p IS NOT NULL AND cd_material_p::text <> '') then

	/* cadastro material */

	select	count(*)
	into STRICT	qt_via_mat_w
	from	material
	where	cd_material = cd_material_p
	and	(ie_via_aplicacao IS NOT NULL AND ie_via_aplicacao::text <> '');

	/* cadastro via aplicacao */

	select	count(*)
	into STRICT	qt_via_mat_ww
	from	mat_via_aplic
	where	cd_material = cd_material_p;

	/* validar via cadastro material */

	if (qt_via_mat_w > 0) then

		select	coalesce(max(b.ie_endovenosa),'S')
		into STRICT	ie_endovenosa_w
		from	via_aplicacao b,
			material a
		where	b.ie_via_aplicacao = a.ie_via_aplicacao
		and	a.cd_material = cd_material_p;

		/* validar vias cadastro via aplicacao */

		if (ie_endovenosa_w = 'N') and (qt_via_mat_ww > 0) then

			select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
			into STRICT	ie_endovenosa_w
			from	via_aplicacao b,
				mat_via_aplic a
			where	b.ie_via_aplicacao = a.ie_via_aplicacao
			and	a.cd_material = cd_material_p
			and	coalesce(b.ie_endovenosa,'S') = 'S';

		end if;

	/* validar vias cadastro via aplicacao */

	elsif (qt_via_mat_ww > 0) then

		select	CASE WHEN count(*)=0 THEN 'N'  ELSE 'S' END
		into STRICT	ie_endovenosa_w
		from	via_aplicacao b,
			mat_via_aplic a
		where	b.ie_via_aplicacao = a.ie_via_aplicacao
		and	a.cd_material = cd_material_p
		and	coalesce(b.ie_endovenosa,'S') = 'S';

	else

		ie_endovenosa_w := 'S';

	end if;

end if;

return ie_endovenosa_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_via_aplic_mat_endov (cd_material_p bigint) FROM PUBLIC;

