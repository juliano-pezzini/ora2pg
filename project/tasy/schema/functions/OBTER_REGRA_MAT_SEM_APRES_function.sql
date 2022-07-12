-- Generated by Ora2Pg, the Oracle database Schema converter, version 23.1
-- Copyright 2000-2022 Gilles DAROLD. All rights reserved.
-- DATASOURCE: dbi:Oracle:host=srv-dbora-03.whebdc.com.br;service_name=DEV_1815;port=1521

SET client_encoding TO 'UTF8';





CREATE OR REPLACE FUNCTION obter_regra_mat_sem_apres ( cd_material_p bigint, cd_mat_sem_apresent_p bigint, cd_convenio_p bigint) RETURNS varchar AS $body$
DECLARE



ds_retorno_w	varchar(1);
qt_registro_w	bigint;

BEGIN

select 	count(nr_sequencia)
into STRICT	qt_registro_w
from	regra_mat_sem_apresentacao
where 	cd_mat_sem_apresent = 	cd_mat_sem_apresent_p
and		cd_convenio			=	cd_convenio_p;

ds_retorno_w := 'S';

if (qt_registro_w > 0) and (cd_mat_sem_apresent_p IS NOT NULL AND cd_mat_sem_apresent_p::text <> '') and (cd_material_p IS NOT NULL AND cd_material_p::text <> '') and (cd_convenio_p IS NOT NULL AND cd_convenio_p::text <> '') then

	select 	coalesce(max('S'),'N')
	into STRICT	ds_retorno_w
	from	regra_mat_sem_apresentacao
	where	cd_mat_sem_apresent = 	cd_mat_sem_apresent_p
	and		cd_material			=	cd_material_p
	and		cd_convenio			=	cd_convenio_p;
end if;

return	ds_retorno_w;

end;
$body$
LANGUAGE PLPGSQL
SECURITY DEFINER
 STABLE;
-- REVOKE ALL ON FUNCTION obter_regra_mat_sem_apres ( cd_material_p bigint, cd_mat_sem_apresent_p bigint, cd_convenio_p bigint) FROM PUBLIC;
