-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_se_classif_nut_lib (nr_seq_classif_p bigint, cd_perfil_p bigint) RETURNS varchar AS $body$
DECLARE


ie_liberado_w	varchar(1) := 'S';
cont_w		bigint;


BEGIN

select	count(*)
into STRICT	cont_w
from	classif_nut_prod_perfil
where	nr_seq_classif	= nr_seq_classif_p;

if (cont_w > 0) then
	select	count(*)
	into STRICT	cont_w
	from	classif_nut_prod_perfil
	where	nr_seq_classif	= nr_seq_classif_p
	and	cd_perfil	= cd_perfil_p;

	if (cont_w = 0) then
		ie_liberado_w	:= 'N';
	end if;
end if;

return	ie_liberado_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_se_classif_nut_lib (nr_seq_classif_p bigint, cd_perfil_p bigint) FROM PUBLIC;

